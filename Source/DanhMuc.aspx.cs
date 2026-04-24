using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;

public partial class DanhMuc : System.Web.UI.Page
{
    public string VideoBgUrl { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
            LoadProducts();
        }
    }

    private void LoadCategories()
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaDM, TenDM FROM dbo.DanhMuc WHERE TrangThai = 1";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptCategories.DataSource = dt;
            rptCategories.DataBind();
        }
    }

    private void LoadProducts()
    {
        string cat = Request.QueryString["cat"];
        string sort = ddlSort.SelectedValue;
        string search = txtSearch.Text.Trim();

        // Update UI based on category
        if (!string.IsNullOrEmpty(cat))
        {
            VideoBgUrl = "videos/cartoon.mp4"; // Specific for child categories
            litTitle.Text = GetCategoryName(int.Parse(cat));
            litCatTitle.Text = litTitle.Text;
        }
        else
        {
            VideoBgUrl = "videos/book.mp4";
            litTitle.Text = "Tất Cả Tác Phẩm";
            litCatTitle.Text = "Tất Cả Sản Phẩm";
        }

        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT sp.MaSP, sp.Slug, sp.TenSP, sp.TacGia, sp.MoTa, sp.Gia, sp.GiaKhuyenMai, 
                       sp.PhanTramGiam, sp.HinhAnh, sp.LoaiBia, sp.NhaXuatBan, sp.NhaCungCap, sp.DanhGia, sp.NguonUrl 
                FROM dbo.SanPham sp 
                WHERE sp.TrangThai = 1";

            if (!string.IsNullOrEmpty(cat)) sql += " AND sp.MaDM = @Cat";
            if (!string.IsNullOrEmpty(search)) sql += " AND (sp.TenSP LIKE @Search OR sp.TacGia LIKE @Search)";

            switch (sort)
            {
                case "price_asc": sql += " ORDER BY CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END ASC"; break;
                case "price_desc": sql += " ORDER BY CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END DESC"; break;
                case "name_asc": sql += " ORDER BY sp.TenSP ASC"; break;
                default: sql += " ORDER BY sp.MaSP DESC"; break;
            }

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (!string.IsNullOrEmpty(cat)) cmd.Parameters.AddWithValue("@Cat", cat);
            if (!string.IsNullOrEmpty(search)) cmd.Parameters.AddWithValue("@Search", "%" + search + "%");

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            // Convert to CatalogProduct list to use helper methods (GiaText, etc)
            List<CatalogProduct> products = new List<CatalogProduct>();
            foreach (DataRow row in dt.Rows)
            {
                products.Add(new CatalogProduct {
                    MaSP = (int)row["MaSP"],
                    TenSP = row["TenSP"].ToString(),
                    TacGia = row["TacGia"].ToString(),
                    Gia = (decimal)row["Gia"],
                    GiaKhuyenMai = row["GiaKhuyenMai"] == DBNull.Value ? (decimal?)null : (decimal)row["GiaKhuyenMai"],
                    PhanTramGiam = row["PhanTramGiam"] == DBNull.Value ? (int?)null : (int)row["PhanTramGiam"],
                    HinhAnh = row["HinhAnh"].ToString()
                });
            }

            if (products.Count > 0)
            {
                rptSach.DataSource = products;
                rptSach.DataBind();
                LabelNoData.Visible = false;
                rptSach.Visible = true;
            }
            else
            {
                LabelNoData.Visible = true;
                rptSach.Visible = false;
            }
        }
    }

    private string GetCategoryName(int id)
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT TenDM FROM dbo.DanhMuc WHERE MaDM = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            object name = cmd.ExecuteScalar();
            return name != null ? name.ToString() : "Danh mục";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadProducts();
    }
}
