using System;
using System.Collections.Generic;
using System.Data.SqlClient;

public partial class _Default : System.Web.UI.Page
{
    private static readonly string[] HeroCaptions =
    {
        "Mở một trang sách, bắt đầu một hành trình mới.",
        "Mỗi cuốn sách hay là một cánh cửa mở ra thế giới khác.",
        "Chọn một quyển sách hôm nay, mang về một cảm hứng mới.",
        "Từ những trang giấy lặng im, muôn vàn ý tưởng bắt đầu lên tiếng.",
        "Một góc đọc nhỏ cũng đủ làm ngày dài trở nên đáng nhớ."
    };

    protected void Page_Load(object sender, EventArgs e)
    {
        SetHeroCaption();

        if (!IsPostBack)
        {
            LoadTrangChu();
        }
    }

    private void SetHeroCaption()
    {
        litHeroCaption.Text = HeroCaptions[new Random(Guid.NewGuid().GetHashCode()).Next(HeroCaptions.Length)];
    }

    private void LoadTrangChu()
    {
        try
        {
            List<CatalogProduct> danhSach = FahasaCatalogService.GetFeaturedProducts(20);
            MarkWishlistState(danhSach);
            if (danhSach.Count > 0)
            {
                rptSachNoiBat.DataSource = danhSach;
                rptSachNoiBat.DataBind();
                return;
            }
        }
        catch
        {
        }

        LabelNoData.Visible = true;
    }

    private void MarkWishlistState(List<CatalogProduct> products)
    {
        if (products == null || products.Count == 0 || Session["UserId"] == null)
        {
            return;
        }

        try
        {
            HashSet<int> wished = new HashSet<int>();
            using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("SELECT MaSP FROM dbo.YeuThich WHERE MaKH = @MaKH", conn);
                cmd.Parameters.AddWithValue("@MaKH", (int)Session["UserId"]);
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        wished.Add(Convert.ToInt32(reader["MaSP"]));
                    }
                }
            }

            foreach (CatalogProduct product in products)
            {
                product.IsWishlisted = wished.Contains(product.MaSP);
            }
        }
        catch
        {
        }
    }
}
