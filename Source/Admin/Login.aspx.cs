using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.Security;

public partial class Admin_Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (User.Identity.IsAuthenticated)
        {
            Response.Redirect("~/Admin/Default.aspx");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text.Trim();

        if (ValidateAdmin(username, password))
        {
            FormsAuthentication.SetAuthCookie(username, true);
            Response.Redirect("~/Admin/Default.aspx");
        }
        else
        {
            litError.Text = "<div class='mt-4 p-4 bg-rose-500/10 border border-rose-500/50 rounded-xl text-rose-500 text-sm font-medium flex items-center gap-2'>" +
                           "<svg class='w-4 h-4' fill='none' stroke='currentColor' viewBox='0 0 24 24'><path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z'></path></svg>" +
                           "Tên đăng nhập hoặc mật khẩu không đúng</div>";
        }
    }

    private bool ValidateAdmin(string username, string password)
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT COUNT(1) FROM dbo.AdminUser WHERE Username = @User AND Password = @Pass";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@User", username);
                cmd.Parameters.AddWithValue("@Pass", password);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
    }
}
