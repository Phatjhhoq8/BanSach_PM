using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;

public partial class Wishlist : System.Web.UI.Page
{
    public class WishlistItem
    {
        public int MaSP { get; set; }
        public string TenSP { get; set; }
        public string TacGia { get; set; }
        public string DisplayImageUrl { get; set; }
        public string GiaHienThiText { get; set; }
        public string GiaGocText { get; set; }
        public string OldPriceClass { get; set; }
        public string StockText { get; set; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=Wishlist.aspx");
            return;
        }

        EnsureWishlistTable();
        if (!IsPostBack) LoadWishlist();
    }

    private void EnsureWishlistTable()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlCommand cmd = new SqlCommand(@"
                IF OBJECT_ID(N'dbo.YeuThich', N'U') IS NULL
                BEGIN
                    CREATE TABLE dbo.YeuThich (
                        MaKH INT NOT NULL,
                        MaSP INT NOT NULL,
                        NgayThem DATETIME NOT NULL DEFAULT GETDATE(),
                        CONSTRAINT PK_YeuThich PRIMARY KEY (MaKH, MaSP),
                        CONSTRAINT FK_YeuThich_KhachHang FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
                        CONSTRAINT FK_YeuThich_SanPham FOREIGN KEY (MaSP) REFERENCES dbo.SanPham(MaSP)
                    )
                END", conn);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }

    private void LoadWishlist()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT sp.MaSP, sp.TenSP, sp.TacGia, sp.Gia, sp.GiaKhuyenMai, sp.SoLuongTon,
                       CASE
                           WHEN sp.HinhAnh IS NULL OR LTRIM(RTRIM(sp.HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN sp.HinhAnh LIKE 'http%' OR sp.HinhAnh LIKE 'img/%' OR sp.HinhAnh LIKE '/%' THEN sp.HinhAnh
                           ELSE 'img/books/' + sp.HinhAnh
                       END AS DisplayImageUrl
                FROM dbo.YeuThich yt JOIN dbo.SanPham sp ON sp.MaSP = yt.MaSP
                WHERE yt.MaKH = @MaKH
                ORDER BY yt.NgayThem DESC", conn);
            da.SelectCommand.Parameters.AddWithValue("@MaKH", (int)Session["UserId"]);
            DataTable dt = new DataTable();
            da.Fill(dt);

            List<WishlistItem> items = new List<WishlistItem>();
            foreach (DataRow row in dt.Rows)
            {
                decimal gia = Convert.ToDecimal(row["Gia"]);
                decimal giaKhuyenMai = row["GiaKhuyenMai"] == DBNull.Value ? 0 : Convert.ToDecimal(row["GiaKhuyenMai"]);
                decimal giaHienThi = giaKhuyenMai > 0 ? giaKhuyenMai : gia;
                bool hasSale = giaKhuyenMai > 0 && gia > giaKhuyenMai;
                int stock = row["SoLuongTon"] == DBNull.Value ? 0 : Convert.ToInt32(row["SoLuongTon"]);
                items.Add(new WishlistItem
                {
                    MaSP = Convert.ToInt32(row["MaSP"]),
                    TenSP = row["TenSP"].ToString(),
                    TacGia = row["TacGia"] == DBNull.Value ? "Đang cập nhật" : row["TacGia"].ToString(),
                    DisplayImageUrl = row["DisplayImageUrl"].ToString(),
                    GiaHienThiText = FormatCurrency(giaHienThi),
                    GiaGocText = hasSale ? FormatCurrency(gia) : string.Empty,
                    OldPriceClass = hasSale ? "text-xs text-[var(--muted)] line-through" : "hidden",
                    StockText = stock > 0 ? "Còn " + stock + " cuốn" : "Tạm hết hàng"
                });
            }

            rptWishlist.DataSource = items;
            rptWishlist.DataBind();
            bool hasItems = items.Count > 0;
            emptyWishlistState.Attributes["class"] = hasItems ? "surface-panel py-20 text-center hidden" : "surface-panel py-20 text-center";
            wishlistGrid.Attributes["class"] = hasItems ? "grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 lg:grid-cols-5 lg:gap-x-7" : "hidden grid grid-cols-2 gap-x-4 gap-y-10 sm:grid-cols-3 lg:grid-cols-5 lg:gap-x-7";
        }
    }

    private string FormatCurrency(decimal value)
    {
        return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }
}
