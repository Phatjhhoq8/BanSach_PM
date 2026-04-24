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

        hdnMaSP.Value = product.MaSP.ToString();
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
        litStock.Text = product.SoLuongTon > 0 ? product.SoLuongTon + " cuốn có sẵn" : "Tạm hết hàng";
        phAvailable.Visible = product.MaSP > 0 && product.SoLuongTon > 0;
        phOutOfStock.Visible = !phAvailable.Visible;

        if (!string.IsNullOrWhiteSpace(product.DiscountText))
        {
            discountBadge.Attributes["class"] = "badge-sale";
            oldPriceContainer.Attributes["class"] = "text-lg text-[var(--muted)] line-through";
        }
        else
        {
            discountBadge.Attributes["class"] = "hidden";
            oldPriceContainer.Attributes["class"] = "hidden";
        }

        bookFront.Style["background-image"] = "url('" + product.DisplayImageUrl + "')";
    }
}
