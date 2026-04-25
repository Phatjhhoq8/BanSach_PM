using System;
using System.Data;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.WebControls;

public partial class Admin_News : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadNews();
        }
    }

    private void LoadNews()
    {
        DatabaseInitializer.EnsureInitialized();
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlDataAdapter da = new SqlDataAdapter("SELECT MaTin, TieuDe, TomTat, ChuyenMuc, TrangThai FROM dbo.TinTuc ORDER BY MaTin DESC", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptNews.DataSource = dt;
            rptNews.DataBind();
        }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrWhiteSpace(txtTitle.Text))
        {
            ShowMessage("Vui lòng nhập tiêu đề.", false);
            return;
        }

        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            string sql = string.IsNullOrWhiteSpace(hdnId.Value)
                ? @"INSERT INTO dbo.TinTuc (TieuDe, Slug, TomTat, NoiDung, ChuyenMuc, TrangThai) VALUES (@Title, @Slug, @Summary, @Content, @Category, @Active)"
                : @"UPDATE dbo.TinTuc SET TieuDe=@Title, Slug=@Slug, TomTat=@Summary, NoiDung=@Content, ChuyenMuc=@Category, TrangThai=@Active WHERE MaTin=@Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Title", txtTitle.Text.Trim());
            cmd.Parameters.AddWithValue("@Slug", MakeSlug(txtTitle.Text.Trim()) + (string.IsNullOrWhiteSpace(hdnId.Value) ? "-" + DateTime.Now.Ticks : "-" + hdnId.Value));
            cmd.Parameters.AddWithValue("@Summary", txtSummary.Text.Trim());
            cmd.Parameters.AddWithValue("@Content", txtContent.Text.Trim());
            cmd.Parameters.AddWithValue("@Category", txtCategory.Text.Trim());
            cmd.Parameters.AddWithValue("@Active", chkActive.Checked);
            if (!string.IsNullOrWhiteSpace(hdnId.Value)) cmd.Parameters.AddWithValue("@Id", hdnId.Value);
            conn.Open();
            cmd.ExecuteNonQuery();
        }

        ResetForm();
        LoadNews();
        ShowMessage("Đã lưu bài viết.", true);
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        string id = ((LinkButton)sender).CommandArgument;
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.TinTuc WHERE MaTin=@Id", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                hdnId.Value = id;
                txtTitle.Text = reader["TieuDe"].ToString();
                txtCategory.Text = reader["ChuyenMuc"].ToString();
                txtSummary.Text = reader["TomTat"].ToString();
                txtContent.Text = reader["NoiDung"].ToString();
                chkActive.Checked = Convert.ToBoolean(reader["TrangThai"]);
                litFormTitle.Text = "Chỉnh sửa bài viết #" + id;
            }
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        string id = ((LinkButton)sender).CommandArgument;
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlCommand cmd = new SqlCommand("DELETE FROM dbo.TinTuc WHERE MaTin=@Id", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
        LoadNews();
    }

    protected void btnCancel_Click(object sender, EventArgs e)
    {
        ResetForm();
    }

    private void ResetForm()
    {
        hdnId.Value = string.Empty;
        txtTitle.Text = string.Empty;
        txtCategory.Text = string.Empty;
        txtSummary.Text = string.Empty;
        txtContent.Text = string.Empty;
        chkActive.Checked = true;
        litFormTitle.Text = "Thêm bài viết";
    }

    private string MakeSlug(string value)
    {
        string slug = Regex.Replace(value.ToLowerInvariant(), @"[^a-z0-9]+", "-").Trim('-');
        return string.IsNullOrWhiteSpace(slug) ? "tin-tuc" : slug;
    }

    private void ShowMessage(string message, bool success)
    {
        litMessage.Text = "<p class='mb-4 text-sm font-bold " + (success ? "text-emerald-400" : "text-rose-400") + "'>" + HttpUtility.HtmlEncode(message) + "</p>";
    }
}
