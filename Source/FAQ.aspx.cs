using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;

public partial class FAQ : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadFaq();
        }
    }

    private void LoadFaq()
    {
        DatabaseInitializer.EnsureInitialized();
        using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
        {
            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT CauHoi, TraLoi, Nhom
                FROM dbo.FAQ
                WHERE TrangThai = 1
                ORDER BY ThuTu ASC, MaFAQ ASC", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptFaq.DataSource = dt;
            rptFaq.DataBind();
        }
    }

    protected string GetSearchText(object group, object question, object answer)
    {
        string text = ((group ?? string.Empty) + " " + (question ?? string.Empty) + " " + (answer ?? string.Empty)).ToLowerInvariant();
        return HttpUtility.HtmlAttributeEncode(text);
    }
}
