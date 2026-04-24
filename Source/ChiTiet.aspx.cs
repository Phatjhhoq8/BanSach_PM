using System;
using System.Web;

public partial class ChiTiet : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadChiTiet();
        }
    }

    private void LoadChiTiet()
    {
        string id = Request.QueryString["id"];
        if (string.IsNullOrWhiteSpace(id))
        {
            id = Request.QueryString["slug"];
        }

        CatalogProduct product = null;

        try
        {
            if (!string.IsNullOrWhiteSpace(id))
            {
                product = FahasaCatalogService.GetProductByIdOrSlug(id);
            }

            if (product == null)
            {
                product = FahasaCatalogService.GetFirstProduct();
            }
        }
        catch
        {
        }

        if (product == null)
        {
            Response.StatusCode = 404;
            product = new CatalogProduct
            {
                TenSP = "Không tìm thấy sản phẩm",
                TacGia = "Dữ liệu đang được cập nhật",
                MoTa = "Sản phẩm bạn đang tìm chưa có trong hệ thống hoặc dữ liệu chưa kịp đồng bộ.",
                HinhAnh = "https://placehold.co/400x550/FFF/333?text=Book"
            };
        }

        litMaSP.Text = product.MaSP.ToString();
        litTenSP.Text = HttpUtility.HtmlEncode(product.TenSP);
        litTacGia.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(product.TacGia) ? "Đang cập nhật" : product.TacGia);
        litGia.Text = HttpUtility.HtmlEncode(product.GiaText);
        litGiaGoc.Text = HttpUtility.HtmlEncode(product.GiaGocText);
        litDiscount.Text = HttpUtility.HtmlEncode(product.DiscountText);
        litMoTa.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(product.MoTa) ? "Chưa có mô tả cho sản phẩm này." : product.MoTa);
        litBreadcrumb.Text = HttpUtility.HtmlEncode(product.TenSP);
        litTitleCover.Text = HttpUtility.HtmlEncode(product.TenSP);
        litTitleCoverShine.Text = HttpUtility.HtmlEncode(product.TenSP);

        // Canh chỉnh bìa sách: Nếu có ảnh thật (không phải placeholder), ẩn text overlay để tránh rối mắt
        if (!string.IsNullOrWhiteSpace(product.HinhAnh) && !product.HinhAnh.Contains("placehold.co"))
        {
            litTitleCover.Text = "";
            litTitleCoverShine.Text = "";
        }
        litCoverType.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(product.LoaiBia) ? "Đang cập nhật" : product.LoaiBia);
        litSupplier.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(product.NhaCungCap) ? "Fahasa" : product.NhaCungCap);
        litPublisher.Text = HttpUtility.HtmlEncode(string.IsNullOrWhiteSpace(product.NhaXuatBan) ? "Đang cập nhật" : product.NhaXuatBan);
        litRating.Text = HttpUtility.HtmlEncode(product.DanhGia.HasValue && product.DanhGia.Value > 0 ? product.DanhGia.Value.ToString("0.0") + "/5" : "Chưa có đánh giá");

        if (!string.IsNullOrWhiteSpace(product.DiscountText))
        {
            discountBadge.Attributes["class"] = "bg-rose-500 text-white px-3 py-1 text-xs font-black rounded-lg";
            oldPriceContainer.Attributes["class"] = "text-lg text-gray-300 line-through";
        }
        else
        {
            discountBadge.Attributes["class"] = "hidden";
            oldPriceContainer.Attributes["class"] = "hidden";
        }

        bookFront.Style["background-image"] = "url('" + product.DisplayImageUrl + "')";
    }
}
