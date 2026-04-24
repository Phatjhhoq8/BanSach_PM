using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

public partial class DanhMuc : System.Web.UI.Page
{
    public string VideoBgUrl { get; set; }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadCategories();
            ApplyQueryState();
            LoadProducts();
        }
    }

    private void ApplyQueryState()
    {
        string q = Request.QueryString["q"];
        if (!string.IsNullOrWhiteSpace(q))
        {
            txtSearch.Text = q.Trim();
        }

        string sort = Request.QueryString["sort"];
        if (!string.IsNullOrWhiteSpace(sort) && ddlSort.Items.FindByValue(sort) != null)
        {
            ddlSort.SelectedValue = sort;
        }
    }

    private void LoadCategories()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaDM, TenDM FROM dbo.DanhMuc WHERE TrangThai = 1 ORDER BY TenDM";
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
        string price = Request.QueryString["price"];
        int categoryId;
        bool hasCategory = int.TryParse(cat, out categoryId);

        if (hasCategory)
        {
            litTitle.Text = GetCategoryName(categoryId);
        }
        else if (!string.IsNullOrWhiteSpace(search))
        {
            litTitle.Text = "Kết quả tìm kiếm";
        }
        else
        {
            litTitle.Text = "Tất cả tác phẩm";
        }

        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT sp.MaSP, sp.Slug, sp.TenSP, sp.TacGia, sp.MoTa, sp.Gia, sp.GiaKhuyenMai,
                       sp.PhanTramGiam, sp.HinhAnh, sp.LoaiBia, sp.NhaXuatBan, sp.NhaCungCap, sp.DanhGia, sp.NguonUrl
                FROM dbo.SanPham sp
                WHERE sp.TrangThai = 1";

            SqlCommand cmd = new SqlCommand();
            cmd.Connection = conn;

            if (hasCategory)
            {
                sql += " AND sp.MaDM = @Cat";
                cmd.Parameters.AddWithValue("@Cat", categoryId);
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                sql += " AND (sp.TenSP LIKE @Search OR sp.TacGia LIKE @Search OR sp.NhaXuatBan LIKE @Search)";
                cmd.Parameters.AddWithValue("@Search", "%" + search + "%");
            }

            AddPriceFilter(ref sql, cmd, price);

            switch (sort)
            {
                case "price_asc":
                    sql += " ORDER BY CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END ASC";
                    break;
                case "price_desc":
                    sql += " ORDER BY CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END DESC";
                    break;
                case "name_asc":
                    sql += " ORDER BY sp.TenSP ASC";
                    break;
                default:
                    sql += " ORDER BY sp.MaSP DESC";
                    break;
            }

            cmd.CommandText = sql;
            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            List<CatalogProduct> products = new List<CatalogProduct>();
            foreach (DataRow row in dt.Rows)
            {
                products.Add(new CatalogProduct
                {
                    MaSP = Convert.ToInt32(row["MaSP"]),
                    Slug = SafeString(row["Slug"]),
                    TenSP = SafeString(row["TenSP"]),
                    TacGia = SafeString(row["TacGia"]),
                    Gia = Convert.ToDecimal(row["Gia"]),
                    GiaKhuyenMai = row["GiaKhuyenMai"] == DBNull.Value ? (decimal?)null : Convert.ToDecimal(row["GiaKhuyenMai"]),
                    PhanTramGiam = row["PhanTramGiam"] == DBNull.Value ? (int?)null : Convert.ToInt32(row["PhanTramGiam"]),
                    HinhAnh = SafeString(row["HinhAnh"])
                });
            }

            litResultSummary.Text = products.Count == 0 ? "Không có sách phù hợp" : products.Count + " sách phù hợp";

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

    private void AddPriceFilter(ref string sql, SqlCommand cmd, string price)
    {
        string priceExpression = "CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END";
        switch (price)
        {
            case "under100":
                sql += " AND " + priceExpression + " < @PriceMax";
                cmd.Parameters.AddWithValue("@PriceMax", 100000m);
                break;
            case "100-200":
                sql += " AND " + priceExpression + " >= @PriceMin AND " + priceExpression + " <= @PriceMax";
                cmd.Parameters.AddWithValue("@PriceMin", 100000m);
                cmd.Parameters.AddWithValue("@PriceMax", 200000m);
                break;
            case "200-500":
                sql += " AND " + priceExpression + " > @PriceMin AND " + priceExpression + " <= @PriceMax";
                cmd.Parameters.AddWithValue("@PriceMin", 200000m);
                cmd.Parameters.AddWithValue("@PriceMax", 500000m);
                break;
            case "over500":
                sql += " AND " + priceExpression + " > @PriceMin";
                cmd.Parameters.AddWithValue("@PriceMin", 500000m);
                break;
        }
    }

    private string GetCategoryName(int id)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT TenDM FROM dbo.DanhMuc WHERE MaDM = @Id AND TrangThai = 1";
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

    protected bool IsAllCategoryActive()
    {
        return string.IsNullOrWhiteSpace(Request.QueryString["cat"]);
    }

    protected string GetCategoryLinkClass(object maDM)
    {
        string activeCat = Request.QueryString["cat"];
        string value = maDM == null ? string.Empty : maDM.ToString();
        if (!string.IsNullOrEmpty(activeCat) && activeCat == value)
        {
            return "flex rounded-2xl bg-[var(--primary-soft)] px-4 py-3 text-[var(--primary-dark)]";
        }

        return "flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]";
    }

    protected string GetPriceFilterClass(string value)
    {
        string active = Request.QueryString["price"] ?? string.Empty;
        if (active == value)
        {
            return "flex rounded-2xl bg-[var(--primary-soft)] px-4 py-3 text-[var(--primary-dark)]";
        }

        return "flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]";
    }

    private string SafeString(object value)
    {
        return value == null || value == DBNull.Value ? string.Empty : value.ToString();
    }
}
