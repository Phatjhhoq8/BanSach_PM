using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class GioHang : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=GioHang.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadCart();
        }
    }

    private void LoadCart()
    {
        int userId = (int)Session["UserId"];
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT sp.MaSP, sp.TenSP, sp.TacGia, sp.HinhAnh, ct.SoLuong, 
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
                rptCartItems.DataSource = dt;
                rptCartItems.DataBind();
                
                decimal total = 0;
                int count = 0;
                foreach (DataRow row in dt.Rows)
                {
                    total += Convert.ToDecimal(row["ThanhTien"]);
                    count += Convert.ToInt32(row["SoLuong"]);
                }

                litCartCount.Text = count.ToString();
                litSubtotal.Text = total.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
                litTotal.Text = litSubtotal.Text;
                
                phEmptyCart.Visible = false;
            }
            else
            {
                phEmptyCart.Visible = true;
                rptCartItems.Visible = false;
            }
        }
    }
}
