using System;
using System.Collections.Generic;

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
}
