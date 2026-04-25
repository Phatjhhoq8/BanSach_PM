using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;

public partial class Admin_OrderDetail : System.Web.UI.Page
{
    private int OrderId
    {
        get
        {
            int id;
            return int.TryParse(Request.QueryString["id"], out id) ? id : 0;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadOrder();
        }
    }

    private void LoadOrder()
    {
        if (OrderId <= 0)
        {
            Response.Redirect("Orders.aspx");
            return;
        }

        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlCommand cmd = new SqlCommand(@"
                SELECT dh.MaDH, dh.NgayDat, dh.TamTinh, dh.PhiVanChuyen, dh.GiamGia, dh.TongTien, dh.MaKM, dh.DiaChiGiaoHang, dh.SoDienThoaiGiao, dh.GhiChu, dh.TrangThai, kh.HoTen
                FROM dbo.DonHang dh
                JOIN dbo.KhachHang kh ON dh.MaKH = kh.MaKH
                WHERE dh.MaDH = @Id", conn);
            cmd.Parameters.AddWithValue("@Id", OrderId);

            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (!reader.Read())
                {
                    Response.Redirect("Orders.aspx");
                    return;
                }

                litOrderId.Text = OrderId.ToString();
                litCustomer.Text = HttpUtility.HtmlEncode(reader["HoTen"].ToString());
                litPhone.Text = HttpUtility.HtmlEncode(reader["SoDienThoaiGiao"].ToString());
                litAddress.Text = HttpUtility.HtmlEncode(reader["DiaChiGiaoHang"].ToString());
                litNote.Text = HttpUtility.HtmlEncode(reader["GhiChu"] == DBNull.Value ? "Không có" : reader["GhiChu"].ToString());
                litDate.Text = Convert.ToDateTime(reader["NgayDat"]).ToString("dd/MM/yyyy HH:mm");
                litSubtotal.Text = FormatCurrency(Convert.ToDecimal(reader["TamTinh"]));
                litShippingFee.Text = FormatCurrency(Convert.ToDecimal(reader["PhiVanChuyen"]));
                decimal discount = Convert.ToDecimal(reader["GiamGia"]);
                litDiscount.Text = discount > 0 ? "-" + FormatCurrency(discount) : "0đ";
                litCoupon.Text = reader["MaKM"] == DBNull.Value ? "Không áp dụng" : HttpUtility.HtmlEncode(reader["MaKM"].ToString());
                litTotal.Text = FormatCurrency(Convert.ToDecimal(reader["TongTien"]));
                ddlStatus.SelectedValue = reader["TrangThai"].ToString();
            }

            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT ct.MaSP, sp.TenSP,
                       CASE
                           WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE '../%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                           WHEN sp.HinhAnh LIKE 'img/%' THEN '../' + sp.HinhAnh
                           ELSE '../img/books/' + sp.HinhAnh
                       END AS HinhAnh,
                       ct.SoLuong, ct.DonGia, ct.SoLuong * ct.DonGia AS ThanhTien
                FROM dbo.ChiTietDonHang ct
                JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
                WHERE ct.MaDH = @Id", conn);
            da.SelectCommand.Parameters.AddWithValue("@Id", OrderId);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptItems.DataSource = dt;
            rptItems.DataBind();
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        if (OrderId <= 0)
        {
            Response.Redirect("Orders.aspx");
            return;
        }

        int status;
        if (!int.TryParse(ddlStatus.SelectedValue, out status) || status < 0 || status > 4)
        {
            litMessage.Text = "<p class='mt-4 text-sm font-bold text-rose-400'>Trạng thái không hợp lệ.</p>";
            return;
        }

        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            UpdateOrderStatus(conn, OrderId, status);
        }

        litMessage.Text = "<p class='mt-4 text-sm font-bold text-emerald-400'>Đã cập nhật trạng thái đơn hàng.</p>";
    }

    private string FormatCurrency(decimal value)
    {
        return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }

    private void UpdateOrderStatus(SqlConnection conn, int orderId, int newStatus)
    {
        int oldStatus = GetCurrentStatus(conn, orderId);
        using (SqlTransaction trans = conn.BeginTransaction())
        {
            try
            {
                if (newStatus == 4 && oldStatus != 4)
                {
                    RestoreStock(conn, trans, orderId);
                }

                SqlCommand cmd = new SqlCommand("UPDATE dbo.DonHang SET TrangThai = @Status WHERE MaDH = @Id", conn, trans);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@Id", orderId);
                cmd.ExecuteNonQuery();
                trans.Commit();
            }
            catch
            {
                try { trans.Rollback(); } catch { }
                throw;
            }
        }
    }

    private int GetCurrentStatus(SqlConnection conn, int orderId)
    {
        SqlCommand cmd = new SqlCommand("SELECT TrangThai FROM dbo.DonHang WHERE MaDH = @Id", conn);
        cmd.Parameters.AddWithValue("@Id", orderId);
        object value = cmd.ExecuteScalar();
        return value == null || value == DBNull.Value ? -1 : Convert.ToInt32(value);
    }

    private void RestoreStock(SqlConnection conn, SqlTransaction trans, int orderId)
    {
        SqlCommand cmd = new SqlCommand(@"
            UPDATE sp SET sp.SoLuongTon = sp.SoLuongTon + ct.SoLuong
            FROM dbo.SanPham sp
            JOIN dbo.ChiTietDonHang ct ON ct.MaSP = sp.MaSP
            WHERE ct.MaDH = @Id", conn, trans);
        cmd.Parameters.AddWithValue("@Id", orderId);
        cmd.ExecuteNonQuery();
    }
}
