using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class Admin_Analytics : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadAnalytics();
    }

    private void LoadAnalytics()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            litRevenue.Text = Money(Scalar(conn, "SELECT ISNULL(SUM(TongTien), 0) FROM dbo.DonHang WHERE TrangThai = 3"));
            litOrders.Text = Scalar(conn, "SELECT COUNT(*) FROM dbo.DonHang").ToString();
            litCustomers.Text = Scalar(conn, "SELECT COUNT(*) FROM dbo.KhachHang").ToString();
            litProducts.Text = Scalar(conn, "SELECT COUNT(*) FROM dbo.SanPham WHERE TrangThai = 1").ToString();

            Bind(rptTopProducts, conn, @"
                SELECT TOP 8 sp.TenSP, SUM(ct.SoLuong) AS SoLuongBan
                FROM dbo.ChiTietDonHang ct
                JOIN dbo.DonHang dh ON dh.MaDH = ct.MaDH
                JOIN dbo.SanPham sp ON sp.MaSP = ct.MaSP
                WHERE dh.TrangThai = 3
                GROUP BY sp.TenSP ORDER BY SoLuongBan DESC");
            Bind(rptStatus, conn, @"
                SELECT CASE TrangThai WHEN 0 THEN N'Chờ xác nhận' WHEN 1 THEN N'Đang đóng gói' WHEN 2 THEN N'Đang giao' WHEN 3 THEN N'Hoàn thành' WHEN 4 THEN N'Đã hủy' ELSE N'Khác' END AS TenTrangThai,
                       COUNT(*) AS SoLuong
                FROM dbo.DonHang GROUP BY TrangThai ORDER BY TrangThai");
        }
    }

    private object Scalar(SqlConnection conn, string sql)
    {
        SqlCommand cmd = new SqlCommand(sql, conn);
        return cmd.ExecuteScalar();
    }

    private void Bind(System.Web.UI.WebControls.Repeater repeater, SqlConnection conn, string sql)
    {
        SqlDataAdapter da = new SqlDataAdapter(sql, conn);
        DataTable dt = new DataTable();
        da.Fill(dt);
        repeater.DataSource = dt;
        repeater.DataBind();
    }

    private string Money(object value)
    {
        return Convert.ToDecimal(value).ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }
}
