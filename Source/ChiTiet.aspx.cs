using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Web;

public partial class ChiTiet : System.Web.UI.Page
{
    protected int ProductStock { get; set; }

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
        ProductStock = Math.Max(1, product.SoLuongTon);
        litStockHint.Text = product.SoLuongTon > 0 && product.SoLuongTon <= 5 ? "Chỉ còn " + product.SoLuongTon + " cuốn, nên đặt sớm để giữ sách." : "Bạn có thể điều chỉnh số lượng trước khi thêm vào giỏ.";
        phAvailable.Visible = product.MaSP > 0 && product.SoLuongTon > 0;
        phOutOfStock.Visible = !phAvailable.Visible;

        bool isWishlisted = IsWishlisted(product.MaSP);
        btnWishlist.InnerText = isWishlisted ? "♥" : "♡";
        btnWishlist.Attributes["aria-pressed"] = isWishlisted ? "true" : "false";
        btnWishlist.Attributes["aria-label"] = isWishlisted ? "Bỏ khỏi yêu thích" : "Thêm vào yêu thích";

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
        LoadRelatedProducts(product.MaSP);
    }

    private bool IsWishlisted(int productId)
    {
        if (productId <= 0 || Session["UserId"] == null)
        {
            return false;
        }

        try
        {
            using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
            {
                SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM dbo.YeuThich WHERE MaKH = @MaKH AND MaSP = @MaSP", conn);
                cmd.Parameters.AddWithValue("@MaKH", (int)Session["UserId"]);
                cmd.Parameters.AddWithValue("@MaSP", productId);
                conn.Open();
                return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
            }
        }
        catch
        {
            return false;
        }
    }

    private void LoadRelatedProducts(int currentProductId)
    {
        try
        {
            List<CatalogProduct> products = FahasaCatalogService.GetFeaturedProducts(6);
            products = products.FindAll(p => p.MaSP != currentProductId);
            if (products.Count > 5)
            {
                products = products.GetRange(0, 5);
            }

            rptRelated.DataSource = products;
            rptRelated.DataBind();
            phRelated.Visible = products.Count > 0;
        }
        catch
        {
            phRelated.Visible = false;
        }
    }
}
