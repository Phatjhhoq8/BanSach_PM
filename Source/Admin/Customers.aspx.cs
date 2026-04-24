using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_Customers : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) LoadCustomers();
    }

    private void LoadCustomers()
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT kh.MaKH, kh.HoTen, kh.Email, kh.SoDienThoai, kh.NgayDangKy,
                       COUNT(dh.MaDH) AS SoDon, ISNULL(SUM(dh.TongTien), 0) AS TongChiTieu
                FROM dbo.KhachHang kh
                LEFT JOIN dbo.DonHang dh ON dh.MaKH = kh.MaKH
                GROUP BY kh.MaKH, kh.HoTen, kh.Email, kh.SoDienThoai, kh.NgayDangKy
                ORDER BY kh.MaKH DESC", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptCustomers.DataSource = dt;
            rptCustomers.DataBind();
        }
    }
}
