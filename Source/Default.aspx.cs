using System;
using System.Collections.Generic;

public partial class _Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadTrangChu();
        }
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
