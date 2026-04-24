using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class Checkout : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=Checkout.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadOrderSummary();
            LoadUserInfo();
        }
    }

    private void LoadUserInfo()
    {
        int userId = (int)Session["UserId"];
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
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

    private void LoadOrderSummary()
    {
        int userId = (int)Session["UserId"];
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT sp.MaSP, sp.TenSP, sp.HinhAnh, ct.SoLuong, 
                       (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END) as DonGia,
                       ct.SoLuong * (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END) as ThanhTien
                FROM dbo.ChiTietGioHang ct
                JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
                WHERE ct.MaKH = @UID";
            
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            da.SelectCommand.Parameters.AddWithValue("@UID", userId);
            DataTable dt = new DataTable();
            da.Fill(dt);

            if (dt.Rows.Count > 0)
            {
                rptSummaryItems.DataSource = dt;
                rptSummaryItems.DataBind();
                
                decimal subtotal = 0;
                foreach (DataRow row in dt.Rows)
                {
                    subtotal += Convert.ToDecimal(row["ThanhTien"]);
                }

                decimal shipping = 30000;
                decimal total = subtotal + shipping;

                litSubtotal.Text = subtotal.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
                litTotal.Text = total.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
            }
            else
            {
                Response.Redirect("~/GioHang.aspx");
            }
        }
    }

    protected void btnOrder_Click(object sender, EventArgs e)
    {
        int userId = (int)Session["UserId"];
        string fullName = txtFullName.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string address = txtAddress.Text.Trim();
        string note = txtNote.Text.Trim();
        
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlTransaction trans = conn.BeginTransaction();
            
            try
            {
                // 1. Calculate Total again for security
                string sqlTotal = @"
                    SELECT SUM(ct.SoLuong * (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END)) 
                    FROM dbo.ChiTietGioHang ct 
                    JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP 
                    WHERE ct.MaKH = @UID";
                SqlCommand cmdTotal = new SqlCommand(sqlTotal, conn, trans);
                cmdTotal.Parameters.AddWithValue("@UID", userId);
                decimal subtotal = Convert.ToDecimal(cmdTotal.ExecuteScalar());
                decimal total = subtotal + 30000;

                // 2. Create Order
                string sqlOrder = @"
                    INSERT INTO dbo.DonHang (MaKH, TongTien, DiaChiGiaoHang, SoDienThoaiGiao, GhiChu, HinhThucThanhToan, TrangThai) 
                    VALUES (@UID, @Total, @Address, @Phone, @Note, N'COD', 0);
                    SELECT SCOPE_IDENTITY();";
                SqlCommand cmdOrder = new SqlCommand(sqlOrder, conn, trans);
                cmdOrder.Parameters.AddWithValue("@UID", userId);
                cmdOrder.Parameters.AddWithValue("@Total", total);
                cmdOrder.Parameters.AddWithValue("@Address", address);
                cmdOrder.Parameters.AddWithValue("@Phone", phone);
                cmdOrder.Parameters.AddWithValue("@Note", note);
                int orderId = Convert.ToInt32(cmdOrder.ExecuteScalar());

                // 3. Move Cart items to Order Details
                string sqlDetails = @"
                    INSERT INTO dbo.ChiTietDonHang (MaDH, MaSP, SoLuong, DonGia)
                    SELECT @OID, ct.MaSP, ct.SoLuong, (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END)
                    FROM dbo.ChiTietGioHang ct
                    JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
                    WHERE ct.MaKH = @UID";
                SqlCommand cmdDetails = new SqlCommand(sqlDetails, conn, trans);
                cmdDetails.Parameters.AddWithValue("@OID", orderId);
                cmdDetails.Parameters.AddWithValue("@UID", userId);
                cmdDetails.ExecuteNonQuery();

                // 4. Update Stock
                string sqlStock = @"
                    UPDATE sp SET sp.SoLuongTon = sp.SoLuongTon - ct.SoLuong
                    FROM dbo.SanPham sp
                    JOIN dbo.ChiTietGioHang ct ON sp.MaSP = ct.MaSP
                    WHERE ct.MaKH = @UID";
                SqlCommand cmdStock = new SqlCommand(sqlStock, conn, trans);
                cmdStock.Parameters.AddWithValue("@UID", userId);
                cmdStock.ExecuteNonQuery();

                // 5. Clear Cart
                string sqlClear = "DELETE FROM dbo.ChiTietGioHang WHERE MaKH = @UID";
                SqlCommand cmdClear = new SqlCommand(sqlClear, conn, trans);
                cmdClear.Parameters.AddWithValue("@UID", userId);
                cmdClear.ExecuteNonQuery();

                trans.Commit();
                Response.Redirect("~/Success.aspx?id=" + orderId);
            }
            catch (Exception ex)
            {
                trans.Rollback();
                // Handle error (show message)
            }
        }
    }
}
