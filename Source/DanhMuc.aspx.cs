using System;
using System.Collections.Generic;

public partial class DanhMuc : System.Web.UI.Page
{
    public string VideoBgUrl { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDanhMuc();
        }
    }

    private void LoadDanhMuc()
    {
        string tl = Request.QueryString["tl"];

        if (!string.IsNullOrEmpty(tl) && (tl.ToLower() == "truyentranh" || tl.ToLower() == "hoathinh"))
        {
            VideoBgUrl = "videos/cartoon.mp4";
            litTitle.Text = "Sách Thiếu Nhi Từ Fahasa";
        }
        else
        {
            VideoBgUrl = "videos/book.mp4";
            litTitle.Text = "Toàn Bộ Sách Thiếu Nhi";
        }

        try
        {
            List<CatalogProduct> danhSach = FahasaCatalogService.GetAllProducts();
            if (danhSach.Count > 0)
            {
                rptSach.DataSource = danhSach;
                rptSach.DataBind();
                return;
            }
        }
        catch
        {
        }

        LabelNoData.Visible = true;
    }
}
