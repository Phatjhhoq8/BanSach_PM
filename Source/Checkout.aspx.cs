using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Text.RegularExpressions;
using System.Web;

public partial class Checkout : System.Web.UI.Page
{
    private decimal ShippingFee
    {
        get { return DatabaseInitializer.GetDecimalSetting("ShippingFee", 30000m); }
    }

    private class CouponResult
    {
        public bool IsValid { get; set; }
        public string Code { get; set; }
        public string Message { get; set; }
        public decimal Discount { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=Checkout.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadUserInfo();
            LoadOrderSummary(false);
        }
    }

    private void LoadUserInfo()
    {
        int userId = (int)Session["UserId"];
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT * FROM dbo.KhachHang WHERE MaKH = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", userId);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                txtFullName.Text = reader["HoTen"].ToString();
                txtEmail.Text = reader["Email"].ToString();
                txtPhone.Text = reader["SoDienThoai"].ToString();
                txtAddress.Text = reader["DiaChi"] == DBNull.Value ? string.Empty : reader["DiaChi"].ToString();
            }
        }
    }

    private void LoadOrderSummary(bool showCouponMessage)
    {
        int userId = (int)Session["UserId"];
        string connString = DbConfig.GetConnectionString();

        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            DataTable dt = GetCartTable(conn, null, userId);
            if (dt.Rows.Count == 0)
            {
                Response.Redirect("~/GioHang.aspx");
                return;
            }

            rptSummaryItems.DataSource = dt;
            rptSummaryItems.DataBind();

            decimal subtotal = CalculateSubtotal(dt);
            string code = GetCouponCode();
            CouponResult coupon = CalculateCoupon(conn, null, code, subtotal);
            decimal discount = coupon.Discount;
            decimal total = Math.Max(0, subtotal + ShippingFee - discount);

            litSubtotal.Text = FormatCurrency(subtotal);
            litShipping.Text = FormatCurrency(ShippingFee);
            litDiscountAmount.Text = discount > 0 ? "-" + FormatCurrency(discount) : "0đ";
            litTotal.Text = FormatCurrency(total);
            txtCoupon.Text = code;

            if (showCouponMessage)
            {
                ShowCouponMessage(coupon);
            }
        }
    }

    protected void btnApplyCoupon_Click(object sender, EventArgs e)
    {
        ViewState["CouponCode"] = (txtCoupon.Text ?? string.Empty).Trim().ToUpperInvariant();
        LoadOrderSummary(true);
    }

    protected void btnOrder_Click(object sender, EventArgs e)
    {
        litError.Text = string.Empty;
        if (!ValidateCheckoutForm())
        {
            return;
        }

        int userId = (int)Session["UserId"];
        string fullName = txtFullName.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string address = txtAddress.Text.Trim();
        string note = txtNote.Text.Trim();
        string couponCode = GetCouponCode();
        string connString = DbConfig.GetConnectionString();

        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlTransaction trans = conn.BeginTransaction();

            try
            {
                DataTable cart = GetCartTable(conn, trans, userId);
                if (cart.Rows.Count == 0)
                {
                    trans.Rollback();
                    ShowError("Giỏ hàng đang trống.");
                    return;
                }

                foreach (DataRow row in cart.Rows)
                {
                    int qty = Convert.ToInt32(row["SoLuong"]);
                    int stock = Convert.ToInt32(row["SoLuongTon"]);
                    if (stock < qty)
                    {
                        trans.Rollback();
                        ShowError("Một số sách trong giỏ đã vượt quá tồn kho. Vui lòng cập nhật lại giỏ hàng.");
                        return;
                    }
                }

                decimal subtotal = CalculateSubtotal(cart);
                CouponResult coupon = CalculateCoupon(conn, trans, couponCode, subtotal);
                if (!string.IsNullOrWhiteSpace(couponCode) && !coupon.IsValid)
                {
                    trans.Rollback();
                    ShowError(coupon.Message);
                    return;
                }

                decimal total = Math.Max(0, subtotal + ShippingFee - coupon.Discount);
                int orderId = CreateOrder(conn, trans, userId, subtotal, ShippingFee, coupon.Discount, total, coupon.IsValid ? coupon.Code : string.Empty, address, phone, note);
                CreateOrderDetails(conn, trans, orderId, userId);
                UpdateStock(conn, trans, userId);
                MarkCouponUsed(conn, trans, coupon);
                ClearCart(conn, trans, userId);

                trans.Commit();
                Response.Redirect("~/Success.aspx?id=" + orderId, false);
                Context.ApplicationInstance.CompleteRequest();
            }
            catch
            {
                try { trans.Rollback(); } catch { }
                ShowError("Không thể tạo đơn hàng lúc này. Vui lòng thử lại sau.");
            }
        }
    }

    private DataTable GetCartTable(SqlConnection conn, SqlTransaction trans, int userId)
    {
        string sql = @"
            SELECT sp.MaSP, sp.TenSP,
                   CASE
                       WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                       WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE 'img/%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                       ELSE 'img/books/' + sp.HinhAnh
                   END AS HinhAnh,
                   ct.SoLuong,
                   sp.SoLuongTon,
                   (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END) as DonGia,
                   ct.SoLuong * (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END) as ThanhTien
            FROM dbo.ChiTietGioHang ct
            JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
            WHERE ct.MaKH = @UID AND sp.TrangThai = 1";

        SqlCommand cmd = new SqlCommand(sql, conn);
        if (trans != null)
        {
            cmd.Transaction = trans;
        }

        cmd.Parameters.AddWithValue("@UID", userId);
        SqlDataAdapter da = new SqlDataAdapter(cmd);
        DataTable dt = new DataTable();
        da.Fill(dt);
        return dt;
    }

    private decimal CalculateSubtotal(DataTable cart)
    {
        decimal subtotal = 0;
        foreach (DataRow row in cart.Rows)
        {
            subtotal += Convert.ToDecimal(row["ThanhTien"]);
        }

        return subtotal;
    }

    private CouponResult CalculateCoupon(SqlConnection conn, SqlTransaction trans, string code, decimal subtotal)
    {
        CouponResult result = new CouponResult { Code = string.Empty, Message = string.Empty, Discount = 0, IsValid = false };
        if (string.IsNullOrWhiteSpace(code))
        {
            return result;
        }

        string sql = @"
            SELECT MaKM, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, SoLuong, DieuKien
            FROM dbo.KhuyenMai
            WHERE MaKM = @Code";
        SqlCommand cmd = new SqlCommand(sql, conn);
        if (trans != null)
        {
            cmd.Transaction = trans;
        }
        cmd.Parameters.AddWithValue("@Code", code);

        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            if (!reader.Read())
            {
                result.Message = "Mã ưu đãi không tồn tại.";
                return result;
            }

            DateTime now = DateTime.Now;
            DateTime? start = reader["NgayBatDau"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["NgayBatDau"]);
            DateTime? end = reader["NgayKetThuc"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(reader["NgayKetThuc"]);
            int quantity = Convert.ToInt32(reader["SoLuong"]);
            decimal condition = Convert.ToDecimal(reader["DieuKien"]);

            if ((start.HasValue && now < start.Value) || (end.HasValue && now > end.Value) || quantity <= 0)
            {
                result.Message = "Mã ưu đãi đã hết hạn hoặc hết lượt sử dụng.";
                return result;
            }

            if (subtotal < condition)
            {
                result.Message = "Đơn hàng chưa đủ điều kiện áp dụng mã ưu đãi.";
                return result;
            }

            int percent = Convert.ToInt32(reader["PhanTramGiam"]);
            decimal amount = Convert.ToDecimal(reader["GiaTriGiam"]);
            decimal discount = Math.Round(subtotal * percent / 100m, 0) + amount;
            decimal maxDiscount = subtotal + ShippingFee;

            result.Code = reader["MaKM"].ToString();
            result.Discount = Math.Min(discount, maxDiscount);
            result.IsValid = result.Discount > 0;
            result.Message = result.IsValid ? "Đã áp dụng mã " + result.Code + "." : "Mã ưu đãi không có giá trị giảm.";
            return result;
        }
    }

    private int CreateOrder(SqlConnection conn, SqlTransaction trans, int userId, decimal subtotal, decimal shippingFee, decimal discount, decimal total, string couponCode, string address, string phone, string note)
    {
        string sql = @"
            INSERT INTO dbo.DonHang (MaKH, TamTinh, PhiVanChuyen, GiamGia, TongTien, MaKM, DiaChiGiaoHang, SoDienThoaiGiao, GhiChu, HinhThucThanhToan, TrangThai)
            VALUES (@UID, @Subtotal, @ShippingFee, @Discount, @Total, @MaKM, @Address, @Phone, @Note, N'COD', 0);
            SELECT SCOPE_IDENTITY();";
        SqlCommand cmd = new SqlCommand(sql, conn, trans);
        cmd.Parameters.AddWithValue("@UID", userId);
        cmd.Parameters.AddWithValue("@Subtotal", subtotal);
        cmd.Parameters.AddWithValue("@ShippingFee", shippingFee);
        cmd.Parameters.AddWithValue("@Discount", discount);
        cmd.Parameters.AddWithValue("@Total", total);
        cmd.Parameters.AddWithValue("@MaKM", string.IsNullOrWhiteSpace(couponCode) ? (object)DBNull.Value : couponCode);
        cmd.Parameters.AddWithValue("@Address", address);
        cmd.Parameters.AddWithValue("@Phone", phone);
        cmd.Parameters.AddWithValue("@Note", string.IsNullOrWhiteSpace(note) ? (object)DBNull.Value : note);
        return Convert.ToInt32(cmd.ExecuteScalar());
    }

    private void CreateOrderDetails(SqlConnection conn, SqlTransaction trans, int orderId, int userId)
    {
        string sql = @"
            INSERT INTO dbo.ChiTietDonHang (MaDH, MaSP, SoLuong, DonGia)
            SELECT @OID, ct.MaSP, ct.SoLuong, (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END)
            FROM dbo.ChiTietGioHang ct
            JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
            WHERE ct.MaKH = @UID";
        SqlCommand cmd = new SqlCommand(sql, conn, trans);
        cmd.Parameters.AddWithValue("@OID", orderId);
        cmd.Parameters.AddWithValue("@UID", userId);
        cmd.ExecuteNonQuery();
    }

    private void UpdateStock(SqlConnection conn, SqlTransaction trans, int userId)
    {
        string sql = @"
            UPDATE sp SET sp.SoLuongTon = sp.SoLuongTon - ct.SoLuong
            FROM dbo.SanPham sp
            JOIN dbo.ChiTietGioHang ct ON sp.MaSP = ct.MaSP
            WHERE ct.MaKH = @UID";
        SqlCommand cmd = new SqlCommand(sql, conn, trans);
        cmd.Parameters.AddWithValue("@UID", userId);
        cmd.ExecuteNonQuery();
    }

    private void MarkCouponUsed(SqlConnection conn, SqlTransaction trans, CouponResult coupon)
    {
        if (coupon == null || !coupon.IsValid || string.IsNullOrWhiteSpace(coupon.Code))
        {
            return;
        }

        string sql = "UPDATE dbo.KhuyenMai SET SoLuong = SoLuong - 1 WHERE MaKM = @Code AND SoLuong > 0";
        SqlCommand cmd = new SqlCommand(sql, conn, trans);
        cmd.Parameters.AddWithValue("@Code", coupon.Code);
        cmd.ExecuteNonQuery();
    }

    private void ClearCart(SqlConnection conn, SqlTransaction trans, int userId)
    {
        string sql = "DELETE FROM dbo.ChiTietGioHang WHERE MaKH = @UID";
        SqlCommand cmd = new SqlCommand(sql, conn, trans);
        cmd.Parameters.AddWithValue("@UID", userId);
        cmd.ExecuteNonQuery();
    }

    private bool ValidateCheckoutForm()
    {
        if (string.IsNullOrWhiteSpace(txtFullName.Text))
        {
            ShowError("Vui lòng nhập họ tên người nhận.");
            return false;
        }

        if (!Regex.IsMatch(txtPhone.Text.Trim(), @"^[0-9+\-\s]{9,15}$"))
        {
            ShowError("Số điện thoại chưa hợp lệ.");
            return false;
        }

        if (string.IsNullOrWhiteSpace(txtAddress.Text))
        {
            ShowError("Vui lòng nhập địa chỉ giao hàng.");
            return false;
        }

        if (!string.IsNullOrWhiteSpace(txtEmail.Text) && txtEmail.Text.IndexOf("@", StringComparison.Ordinal) < 0)
        {
            ShowError("Email nhận thông báo chưa hợp lệ.");
            return false;
        }

        return true;
    }

    private string GetCouponCode()
    {
        string code = txtCoupon.Text;
        if (string.IsNullOrWhiteSpace(code) && ViewState["CouponCode"] != null)
        {
            code = ViewState["CouponCode"].ToString();
        }

        return (code ?? string.Empty).Trim().ToUpperInvariant();
    }

    private void ShowError(string message)
    {
        litError.Text = "<div class='mb-6 rounded-3xl border border-red-200 bg-red-50 p-4 text-sm font-bold text-red-700'>" + HttpUtility.HtmlEncode(message) + "</div>";
    }

    private void ShowCouponMessage(CouponResult coupon)
    {
        if (coupon == null || string.IsNullOrWhiteSpace(coupon.Message))
        {
            litCouponMessage.Text = string.Empty;
            return;
        }

        string color = coupon.IsValid ? "var(--success)" : "var(--danger)";
        litCouponMessage.Text = "<p class='mt-3 text-sm font-bold' style='color:" + color + "'>" + HttpUtility.HtmlEncode(coupon.Message) + "</p>";
    }

    private string FormatCurrency(decimal value)
    {
        return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }
}
