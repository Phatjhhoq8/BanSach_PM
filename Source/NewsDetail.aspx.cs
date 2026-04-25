using System;
using System.Data.SqlClient;
using System.Web;

public partial class NewsDetail : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadNewsDetail();
        }
    }

    private void LoadNewsDetail()
    {
        DatabaseInitializer.EnsureInitialized();
        int id;
        if (!int.TryParse(Request.QueryString["id"], out id) || id <= 0)
        {
            Response.Redirect("News.aspx");
            return;
        }

        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlCommand cmd = new SqlCommand(@"
                SELECT TOP 1 TieuDe, TomTat, NoiDung, ChuyenMuc
                FROM dbo.TinTuc
                WHERE MaTin = @Id AND TrangThai = 1", conn);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            using (SqlDataReader reader = cmd.ExecuteReader())
            {
                if (!reader.Read())
                {
                    Response.Redirect("News.aspx");
                    return;
                }

                litCategory.Text = HttpUtility.HtmlEncode(reader["ChuyenMuc"].ToString());
                litTitle.Text = HttpUtility.HtmlEncode(reader["TieuDe"].ToString());
                litSummary.Text = HttpUtility.HtmlEncode(reader["TomTat"].ToString());
                litContent.Text = ToParagraphs(reader["NoiDung"].ToString());
            }
        }
    }

    private string ToParagraphs(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        string[] parts = value.Split(new[] { "\r\n", "\n" }, StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 0)
        {
            parts = value.Split(new[] { ". " }, StringSplitOptions.RemoveEmptyEntries);
        }

        string html = string.Empty;
        foreach (string part in parts)
        {
            string text = part.Trim();
            if (text.Length > 0)
            {
                html += "<p>" + HttpUtility.HtmlEncode(text) + "</p>";
            }
        }

        return html;
    }
}
