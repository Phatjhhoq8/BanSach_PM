using System;
using System.Data;
using System.Data.SqlClient;

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
}
