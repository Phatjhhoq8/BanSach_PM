using System;
using System.Data;
using System.Data.SqlClient;

public partial class News : System.Web.UI.Page
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
            SqlDataAdapter da = new SqlDataAdapter(@"
                SELECT MaTin, TieuDe, TomTat, ChuyenMuc
                FROM dbo.TinTuc
                WHERE TrangThai = 1
                ORDER BY NgayDang DESC, MaTin DESC", conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptNews.DataSource = dt;
            rptNews.DataBind();
            phEmpty.Visible = dt.Rows.Count == 0;
        }
    }
}
