using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;

public partial class Login : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        txtEmail.Attributes["autocomplete"] = "email";
        txtPassword.Attributes["autocomplete"] = "current-password";

        if (Session["UserEmail"] != null)
        {
            Response.Redirect("~/Default.aspx");
        }

        if (!IsPostBack && Request.QueryString["msg"] == "success")
        {
            litError.Text = "<div class='mt-4 rounded-3xl border border-emerald-200 bg-emerald-50 p-4 text-sm font-bold text-emerald-700'>Đăng ký thành công. Bạn có thể đăng nhập ngay.</div>";
        }

        string returnUrl = Request.QueryString["ReturnUrl"];
        lnkRegister.HRef = IsSafeReturnUrl(returnUrl) ? "Register.aspx?ReturnUrl=" + HttpUtility.UrlEncode(returnUrl) : "Register.aspx";
    }

    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string email = txtEmail.Text.Trim();
        string password = txtPassword.Text.Trim();

        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
        {
            ShowError("Vui lòng nhập email và mật khẩu.");
            return;
        }

        if (ValidateUser(email, password))
        {
            string returnUrl = Request.QueryString["ReturnUrl"];
            if (IsSafeReturnUrl(returnUrl))
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
            ShowError("Email hoặc mật khẩu không chính xác.");
        }
    }

    private bool IsSafeReturnUrl(string returnUrl)
    {
        if (string.IsNullOrWhiteSpace(returnUrl))
        {
            return false;
        }

        return returnUrl.IndexOf("://", StringComparison.Ordinal) < 0 && !returnUrl.StartsWith("//", StringComparison.Ordinal);
    }

    private void ShowError(string message)
    {
        litError.Text = "<div class='mt-4 rounded-3xl border border-red-200 bg-red-50 p-4 text-sm font-bold text-red-700'>" + HttpUtility.HtmlEncode(message) + "</div>";
    }

    private bool ValidateUser(string email, string password)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT MaKH, HoTen, Email, MatKhau FROM dbo.KhachHang WHERE Email = @Email";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read() && SecurityHelper.VerifyPassword(password, reader["MatKhau"].ToString()))
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
