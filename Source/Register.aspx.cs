using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;

public partial class Register : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    }

    protected void btnRegister_Click(object sender, EventArgs e)
    {
        string fullName = txtFullName.Text.Trim();
        string email = txtEmail.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string password = txtPassword.Text.Trim();
        string confirm = txtConfirmPassword.Text.Trim();

        if (string.IsNullOrWhiteSpace(fullName) || string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
        {
            ShowError("Vui lòng nhập đầy đủ họ tên, email và mật khẩu.");
            return;
        }

        if (!Regex.IsMatch(email, @"^[^@\s]+@[^@\s]+\.[^@\s]+$"))
        {
            ShowError("Email chưa hợp lệ.");
            return;
        }

        if (!string.IsNullOrWhiteSpace(phone) && !Regex.IsMatch(phone, @"^[0-9+\-\s]{9,15}$"))
        {
            ShowError("Số điện thoại chưa hợp lệ.");
            return;
        }

        if (password.Length < 6)
        {
            ShowError("Mật khẩu cần có ít nhất 6 ký tự.");
            return;
        }

        if (password != confirm)
        {
            ShowError("Mật khẩu xác nhận không khớp.");
            return;
        }

        if (IsEmailExists(email))
        {
            ShowError("Email này đã được sử dụng.");
            return;
        }

        int userId = CreateUser(fullName, email, phone, password);
        if (userId > 0)
        {
            Session["UserId"] = userId;
            Session["UserEmail"] = email;
            Session["UserName"] = fullName;

            string returnUrl = Request.QueryString["ReturnUrl"];
            if (!string.IsNullOrWhiteSpace(returnUrl) && IsSafeReturnUrl(returnUrl))
            {
                Response.Redirect(returnUrl);
                return;
            }

            Response.Redirect("~/Default.aspx");
        }
        else
        {
            ShowError("Có lỗi xảy ra, vui lòng thử lại sau.");
        }
    }

    private bool IsEmailExists(string email)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT COUNT(1) FROM dbo.KhachHang WHERE Email = @Email";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Email", email);
                conn.Open();
                int count = (int)cmd.ExecuteScalar();
                return count > 0;
            }
        }
    }

    private int CreateUser(string fullName, string email, string phone, string password)
    {
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                INSERT INTO dbo.KhachHang (HoTen, Email, SoDienThoai, MatKhau) VALUES (@Name, @Email, @Phone, @Pass);
                DECLARE @NewId INT = CAST(SCOPE_IDENTITY() AS INT);
                INSERT INTO dbo.GioHang (MaKH) VALUES (@NewId);
                SELECT @NewId;";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Name", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Pass", SecurityHelper.HashPassword(password));
                conn.Open();
                object result = cmd.ExecuteScalar();
                return result == null || result == DBNull.Value ? 0 : Convert.ToInt32(result);
            }
        }
    }

    private bool IsSafeReturnUrl(string returnUrl)
    {
        if (string.IsNullOrWhiteSpace(returnUrl))
        {
            return false;
        }

        return returnUrl.IndexOf("://", StringComparison.Ordinal) < 0 &&
               !returnUrl.StartsWith("//", StringComparison.Ordinal) &&
               !returnUrl.StartsWith("\\\\", StringComparison.Ordinal);
    }

    private void ShowError(string message)
    {
        litError.Text = "<div class='mt-4 rounded-3xl border border-red-200 bg-red-50 p-4 text-sm font-bold text-red-700'>" + HttpUtility.HtmlEncode(message) + "</div>";
    }
}
