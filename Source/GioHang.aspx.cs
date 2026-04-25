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
        string connString = DbConfig.GetConnectionString();

        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT sp.MaSP, sp.TenSP, sp.TacGia,
                       CASE
                           WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE 'img/%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                           ELSE 'img/books/' + sp.HinhAnh
                       END AS HinhAnh,
                       ct.SoLuong,
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

                emptyCartState.Attributes["class"] = "surface-panel py-20 text-center hidden";
                rptCartItems.Visible = true;
                cartSummaryAside.Visible = true;
            }
            else
            {
                emptyCartState.Attributes["class"] = "surface-panel py-20 text-center";
                rptCartItems.Visible = false;
                cartSummaryAside.Visible = false;
                litCartCount.Text = "0";
                litSubtotal.Text = "0đ";
                litTotal.Text = "0đ";
            }
        }
    }
}
