using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public partial class DanhMuc : System.Web.UI.Page
{
    private const int PageSize = 24;
    public string VideoBgUrl { get; set; }
    protected int CurrentPage { get; private set; }
    protected int TotalPages { get; private set; }

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
            string sql = @"
SELECT dm.MaDM, dm.TenDM
FROM dbo.DanhMuc dm
WHERE dm.TrangThai = 1
  AND EXISTS (
      SELECT 1
      FROM dbo.SanPham sp
      WHERE sp.MaDM = dm.MaDM AND sp.TrangThai = 1
  )
ORDER BY dm.TenDM";
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
        CurrentPage = GetCurrentPage();
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
            string whereSql = " FROM dbo.SanPham sp WHERE sp.TrangThai = 1";
            SqlCommand countCmd = new SqlCommand();
            countCmd.Connection = conn;

            if (hasCategory)
            {
                whereSql += " AND sp.MaDM = @Cat";
                countCmd.Parameters.AddWithValue("@Cat", categoryId);
            }

            if (!string.IsNullOrWhiteSpace(search))
            {
                whereSql += " AND (sp.TenSP LIKE @Search OR sp.TacGia LIKE @Search OR sp.NhaXuatBan LIKE @Search)";
                countCmd.Parameters.AddWithValue("@Search", "%" + search + "%");
            }

            AddPriceFilter(ref whereSql, countCmd, price);

            countCmd.CommandText = "SELECT COUNT(1)" + whereSql;
            conn.Open();
            int totalItems = Convert.ToInt32(countCmd.ExecuteScalar());
            TotalPages = Math.Max(1, (int)Math.Ceiling(totalItems / (decimal)PageSize));
            if (CurrentPage > TotalPages)
            {
                CurrentPage = TotalPages;
            }

            string orderSql;

            switch (sort)
            {
                case "price_asc":
                    orderSql = " ORDER BY CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END ASC, sp.MaSP DESC";
                    break;
                case "price_desc":
                    orderSql = " ORDER BY CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END DESC, sp.MaSP DESC";
                    break;
                case "name_asc":
                    orderSql = " ORDER BY sp.TenSP ASC, sp.MaSP DESC";
                    break;
                default:
                    orderSql = " ORDER BY sp.MaSP DESC";
                    break;
            }

            string sql = @"
                SELECT sp.MaSP, sp.Slug, sp.TenSP, sp.TacGia, sp.MoTa, sp.Gia, sp.GiaKhuyenMai,
                       sp.PhanTramGiam, sp.HinhAnh, sp.LoaiBia, sp.NhaXuatBan, sp.NhaCungCap, sp.DanhGia, sp.NguonUrl"
                + whereSql + orderSql + " OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY";

            SqlCommand cmd = CloneCommand(countCmd);
            cmd.CommandText = sql;
            cmd.Parameters.AddWithValue("@Offset", (CurrentPage - 1) * PageSize);
            cmd.Parameters.AddWithValue("@PageSize", PageSize);
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

            BindPagination();

            if (totalItems == 0)
            {
                litResultSummary.Text = "Không có sách phù hợp";
            }
            else
            {
                int from = ((CurrentPage - 1) * PageSize) + 1;
                int to = Math.Min(CurrentPage * PageSize, totalItems);
                litResultSummary.Text = "Hiển thị " + from + "-" + to + " / " + totalItems + " sách phù hợp";
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
        Response.Redirect(BuildFilterUrl(1));
    }

    protected string BuildPageUrl(object page)
    {
        int pageNumber = Convert.ToInt32(page);
        return BuildFilterUrl(pageNumber);
    }

    protected string GetPageLinkClass(object page)
    {
        int pageNumber = Convert.ToInt32(page);
        if (pageNumber == CurrentPage)
        {
            return "flex h-10 min-w-10 items-center justify-center rounded-full bg-[var(--primary)] px-3 text-sm font-black text-white";
        }

        return "flex h-10 min-w-10 items-center justify-center rounded-full border border-[var(--line)] bg-[var(--surface)] px-3 text-sm font-black text-[var(--ink-soft)] hover:border-[var(--primary)] hover:text-[var(--primary-dark)]";
    }

    protected string GetPrevPageUrl()
    {
        return BuildFilterUrl(Math.Max(1, CurrentPage - 1));
    }

    protected string GetNextPageUrl()
    {
        return BuildFilterUrl(Math.Min(TotalPages, CurrentPage + 1));
    }

    protected bool HasPagination()
    {
        return TotalPages > 1;
    }

    protected bool HasPrevPage()
    {
        return CurrentPage > 1;
    }

    protected bool HasNextPage()
    {
        return CurrentPage < TotalPages;
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
            return "flex rounded-2xl border border-[var(--primary)] bg-white px-4 py-3 text-[var(--primary-dark)] shadow-sm";
        }

        return "flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]";
    }

    protected string GetPriceFilterClass(string value)
    {
        string active = Request.QueryString["price"] ?? string.Empty;
        if (active == value)
        {
            return "flex rounded-2xl border border-[var(--primary)] bg-white px-4 py-3 text-[var(--primary-dark)] shadow-sm";
        }

        return "flex rounded-2xl px-4 py-3 text-[var(--ink-soft)] hover:bg-[var(--paper-soft)] hover:text-[var(--primary-dark)]";
    }

    private string SafeString(object value)
    {
        return value == null || value == DBNull.Value ? string.Empty : value.ToString();
    }

    private int GetCurrentPage()
    {
        int page;
        if (!int.TryParse(Request.QueryString["p"], out page) || page < 1)
        {
            return 1;
        }

        return page;
    }

    private SqlCommand CloneCommand(SqlCommand source)
    {
        SqlCommand clone = new SqlCommand();
        clone.Connection = source.Connection;
        foreach (SqlParameter parameter in source.Parameters)
        {
            clone.Parameters.AddWithValue(parameter.ParameterName, parameter.Value);
        }

        return clone;
    }

    private void BindPagination()
    {
        List<int> pages = new List<int>();
        if (TotalPages <= 7)
        {
            for (int i = 1; i <= TotalPages; i++) pages.Add(i);
        }
        else
        {
            int start = Math.Max(1, CurrentPage - 2);
            int end = Math.Min(TotalPages, CurrentPage + 2);
            for (int i = start; i <= end; i++) pages.Add(i);

            if (!pages.Contains(1)) pages.Insert(0, 1);
            if (!pages.Contains(TotalPages)) pages.Add(TotalPages);
        }

        rptPagination.DataSource = pages;
        rptPagination.DataBind();
        phPagination.Visible = TotalPages > 1;
    }

    private string BuildFilterUrl(int page)
    {
        List<string> parts = new List<string>();
        AddQueryPart(parts, "cat", Request.QueryString["cat"]);
        AddQueryPart(parts, "price", Request.QueryString["price"]);
        AddQueryPart(parts, "sort", ddlSort.SelectedValue == "new" ? string.Empty : ddlSort.SelectedValue);
        AddQueryPart(parts, "q", txtSearch.Text.Trim());
        if (page > 1)
        {
            AddQueryPart(parts, "p", page.ToString());
        }

        return "DanhMuc.aspx" + (parts.Count == 0 ? string.Empty : "?" + string.Join("&", parts.ToArray()));
    }

    private void AddQueryPart(List<string> parts, string key, string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return;
        }

        parts.Add(HttpUtility.UrlEncode(key) + "=" + HttpUtility.UrlEncode(value));
    }
}
