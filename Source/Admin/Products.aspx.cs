using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin_Products : System.Web.UI.Page
{
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
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaDM, TenDM FROM dbo.DanhMuc WHERE TrangThai = 1";
            SqlDataAdapter da = new SqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            ddlCategory.DataSource = dt;
            ddlCategory.DataTextField = "TenDM";
            ddlCategory.DataValueField = "MaDM";
            ddlCategory.DataBind();
            ddlCategory.Items.Insert(0, new ListItem("Tất cả thể loại", ""));
        }
    }

    private void LoadProducts()
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT MaSP, TenSP, TacGia, Gia, GiaKhuyenMai, SoLuongTon,
                       CASE
                           WHEN HinhAnh IS NULL OR LTRIM(RTRIM(HinhAnh)) = '' THEN 'https://placehold.co/400x550/f8f1e3/3b3028?text=Book'
                           WHEN HinhAnh LIKE 'http%' OR HinhAnh LIKE '../%' OR HinhAnh LIKE '/%' THEN HinhAnh
                           WHEN HinhAnh LIKE 'img/%' THEN '../' + HinhAnh
                           ELSE '../img/books/' + HinhAnh
                       END AS HinhAnh,
                       TrangThai
                FROM dbo.SanPham WHERE 1=1";
            
            if (!string.IsNullOrEmpty(txtSearch.Text))
            {
                sql += " AND (TenSP LIKE @Search OR TacGia LIKE @Search)";
            }
            if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
            {
                sql += " AND MaDM = @MaDM";
            }
            
            sql += " ORDER BY MaSP DESC";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (!string.IsNullOrEmpty(txtSearch.Text))
                cmd.Parameters.AddWithValue("@Search", "%" + txtSearch.Text.Trim() + "%");
            if (!string.IsNullOrEmpty(ddlCategory.SelectedValue))
                cmd.Parameters.AddWithValue("@MaDM", ddlCategory.SelectedValue);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptProducts.DataSource = dt;
            rptProducts.DataBind();
            litProductSummary.Text = "Hiển thị " + dt.Rows.Count + " sản phẩm theo bộ lọc hiện tại";
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadProducts();
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        int id = Convert.ToInt32(((LinkButton)sender).CommandArgument);
        DeleteProduct(id);
        LoadProducts();
    }

    private void DeleteProduct(int id)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            // Instead of hard delete, we could do soft delete by setting TrangThai = 0
            string sql = "UPDATE dbo.SanPham SET TrangThai = 0 WHERE MaSP = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
    }
}
