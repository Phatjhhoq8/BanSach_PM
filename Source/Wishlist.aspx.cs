using System;
using System.Data;
using System.Data.SqlClient;

public partial class Wishlist : System.Web.UI.Page
{
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
                SELECT sp.MaSP, sp.TenSP, sp.HinhAnh, CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END AS GiaHienThi
                FROM dbo.YeuThich yt JOIN dbo.SanPham sp ON sp.MaSP = yt.MaSP
                WHERE yt.MaKH = @MaKH
                ORDER BY yt.NgayThem DESC", conn);
            da.SelectCommand.Parameters.AddWithValue("@MaKH", (int)Session["UserId"]);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptWishlist.DataSource = dt;
            rptWishlist.DataBind();
            phEmpty.Visible = dt.Rows.Count == 0;
        }
    }
}
