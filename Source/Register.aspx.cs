using System;
using System.Configuration;
using System.Data.SqlClient;
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

        if (password != confirm)
        {
            litError.Text = "<div class='mt-4 p-4 bg-red-50 border border-red-200 rounded-2xl text-red-600 text-sm font-medium'>Mật khẩu xác nhận không khớp.</div>";
            return;
        }

        if (IsEmailExists(email))
        {
            litError.Text = "<div class='mt-4 p-4 bg-red-50 border border-red-200 rounded-2xl text-red-600 text-sm font-medium'>Email này đã được sử dụng.</div>";
            return;
        }

        if (CreateUser(fullName, email, phone, password))
        {
            Response.Redirect("~/Login.aspx?msg=success");
        }
        else
        {
            litError.Text = "<div class='mt-4 p-4 bg-red-50 border border-red-200 rounded-2xl text-red-600 text-sm font-medium'>Có lỗi xảy ra, vui lòng thử lại sau.</div>";
        }
    }

    private bool IsEmailExists(string email)
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
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

    private bool CreateUser(string fullName, string email, string phone, string password)
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "INSERT INTO dbo.KhachHang (HoTen, Email, SoDienThoai, MatKhau) VALUES (@Name, @Email, @Phone, @Pass)";
            using (SqlCommand cmd = new SqlCommand(sql, conn))
            {
                cmd.Parameters.AddWithValue("@Name", fullName);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.Parameters.AddWithValue("@Phone", phone);
                cmd.Parameters.AddWithValue("@Pass", password);
                conn.Open();
                return cmd.ExecuteNonQuery() > 0;
            }
        }
    }
}
