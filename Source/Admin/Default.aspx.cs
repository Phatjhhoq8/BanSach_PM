using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
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
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            // Recent Orders
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

            // Top Products (Mock for now since we don't have enough real order data yet)
            string sqlProducts = @"
                SELECT TOP 5 MaSP, TenSP, TacGia, HinhAnh, (MaSP % 50 + 10) as SoLuongBan 
                FROM dbo.SanPham 
                WHERE TrangThai = 1 
                ORDER BY MaSP ASC";
            SqlDataAdapter daProducts = new SqlDataAdapter(sqlProducts, conn);
            DataTable dtProducts = new DataTable();
            daProducts.Fill(dtProducts);
            rptTopProducts.DataSource = dtProducts;
            rptTopProducts.DataBind();
        }
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
            case 0: return "bg-amber-500/10 text-amber-500";
            case 1: return "bg-blue-500/10 text-blue-500";
            case 2: return "bg-purple-500/10 text-purple-500";
            case 3: return "bg-emerald-500/10 text-emerald-500";
            case 4: return "bg-rose-500/10 text-rose-500";
            default: return "bg-slate-500/10 text-slate-500";
        }
    }
}
