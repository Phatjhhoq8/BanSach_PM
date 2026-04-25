using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web.UI.WebControls;

public partial class Admin_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDashboardData();
        }
    }

    private void LoadDashboardData()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            litMonthlyRevenue.Text = FormatCurrency(ExecuteDecimal(conn, "SELECT ISNULL(SUM(TongTien), 0) FROM dbo.DonHang WHERE MONTH(NgayDat) = MONTH(GETDATE()) AND YEAR(NgayDat) = YEAR(GETDATE()) AND TrangThai = 3"));
            litPendingOrders.Text = ExecuteInt(conn, "SELECT COUNT(1) FROM dbo.DonHang WHERE TrangThai IN (0, 1)").ToString();
            litCustomers.Text = ExecuteInt(conn, "SELECT COUNT(1) FROM dbo.KhachHang").ToString();
            litLowStock.Text = ExecuteInt(conn, "SELECT COUNT(1) FROM dbo.SanPham WHERE TrangThai = 1 AND SoLuongTon <= 5").ToString();

            string sqlOrders = @"
                SELECT TOP 5 dh.MaDH, kh.HoTen, dh.TongTien, dh.TrangThai 
                FROM dbo.DonHang dh 
                JOIN dbo.KhachHang kh ON dh.MaKH = kh.MaKH 
                ORDER BY dh.MaDH DESC";
            SqlDataAdapter daOrders = new SqlDataAdapter(sqlOrders, conn);
            DataTable dtOrders = new DataTable();
            daOrders.Fill(dtOrders);
            rptRecentOrders.DataSource = dtOrders;
            rptRecentOrders.DataBind();

            string sqlProducts = @"
                SELECT TOP 5 sp.MaSP, sp.TenSP, sp.TacGia,
                       CASE
                           WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE '../%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                           WHEN sp.HinhAnh LIKE 'img/%' THEN '../' + sp.HinhAnh
                           ELSE '../img/books/' + sp.HinhAnh
                       END AS HinhAnh,
                       ISNULL(SUM(CASE WHEN dh.TrangThai = 3 THEN ct.SoLuong ELSE 0 END), 0) AS SoLuongBan
                FROM dbo.SanPham sp
                LEFT JOIN dbo.ChiTietDonHang ct ON sp.MaSP = ct.MaSP
                LEFT JOIN dbo.DonHang dh ON dh.MaDH = ct.MaDH
                WHERE sp.TrangThai = 1
                GROUP BY sp.MaSP, sp.TenSP, sp.TacGia, sp.HinhAnh
                ORDER BY SoLuongBan DESC, sp.MaSP DESC";
            SqlDataAdapter daProducts = new SqlDataAdapter(sqlProducts, conn);
            DataTable dtProducts = new DataTable();
            daProducts.Fill(dtProducts);
            rptTopProducts.DataSource = dtProducts;
            rptTopProducts.DataBind();
        }
    }

    private int ExecuteInt(SqlConnection conn, string sql)
    {
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            object value = cmd.ExecuteScalar();
            return value == null || value == DBNull.Value ? 0 : Convert.ToInt32(value);
        }
    }

    private decimal ExecuteDecimal(SqlConnection conn, string sql)
    {
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            object value = cmd.ExecuteScalar();
            return value == null || value == DBNull.Value ? 0 : Convert.ToDecimal(value);
        }
    }

    private string FormatCurrency(decimal value)
    {
        return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }

    protected string GetStatusText(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "Chờ xác nhận";
            case 1: return "Đang đóng gói";
            case 2: return "Đang giao";
            case 3: return "Hoàn thành";
            case 4: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    protected string GetStatusClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "bg-blue-500/10 text-blue-500";
            case 1: return "bg-blue-500/10 text-blue-500";
            case 2: return "bg-sky-500/10 text-sky-500";
            case 3: return "bg-emerald-500/10 text-emerald-500";
            case 4: return "bg-rose-500/10 text-rose-500";
            default: return "bg-slate-500/10 text-slate-500";
        }
    }
}
