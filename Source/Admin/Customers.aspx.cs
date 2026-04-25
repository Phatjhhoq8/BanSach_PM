using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class Admin_Customers : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCustomers();
        }
    }

    private void LoadCustomers()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT kh.MaKH, kh.HoTen, kh.Email, kh.SoDienThoai, kh.NgayDangKy,
                       COUNT(dh.MaDH) AS SoDon,
                       ISNULL(SUM(CASE WHEN dh.TrangThai = 3 THEN dh.TongTien ELSE 0 END), 0) AS TongChiTieu
                FROM dbo.KhachHang kh
                LEFT JOIN dbo.DonHang dh ON kh.MaKH = dh.MaKH
                WHERE 1=1";

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;
            if (!string.IsNullOrWhiteSpace(txtSearch.Text))
            {
                sql += " AND (kh.HoTen LIKE @Search OR kh.Email LIKE @Search OR kh.SoDienThoai LIKE @Search)";
                cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
            }

            sql += " GROUP BY kh.MaKH, kh.HoTen, kh.Email, kh.SoDienThoai, kh.NgayDangKy ORDER BY kh.MaKH DESC";
            cmd.CommandText = sql;

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptCustomers.DataSource = dt;
            rptCustomers.DataBind();
            litSummary.Text = "Hiển thị " + dt.Rows.Count + " khách hàng";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadCustomers();
    }
}
