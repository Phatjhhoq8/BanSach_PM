using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserEmail"] != null)
        {
            Response.Redirect("~/Default.aspx");
        }
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text.Trim();

        if (ValidateUser(email, password))
        {
            // Redirect back to return url if exists
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrEmpty(returnUrl))
            {
                Response.Redirect(returnUrl);
            }
            else
            {
                Response.Redirect("~/Default.aspx");
            }
        }
        else
        {
            litError.Text = "<div class='mt-4 p-4 bg-red-50 border border-red-200 rounded-2xl text-red-600 text-sm font-medium'>Email hoặc mật khẩu không chính xác.</div>";
        }
    }

    private bool ValidateUser(string email, string password)
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaKH, HoTen, Email FROM dbo.KhachHang WHERE Email = @Email AND MatKhau = @Pass";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Pass", password);
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        Session["UserId"] = reader["MaKH"];
                        Session["UserEmail"] = reader["Email"];
                        Session["UserName"] = reader["HoTen"];
                        return true;
                    }
                }
            }
        }
        return false;
    }
}
