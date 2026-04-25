using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
using System.Web;

public partial class Account : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["UserId"] == null)
        {
            Response.Redirect("~/Login.aspx?ReturnUrl=Account.aspx");
            return;
        }

        if (!IsPostBack)
        {
            LoadUserData();
        }

        txtFullName.Attributes["autocomplete"] = "name";
        txtPhone.Attributes["inputmode"] = "tel";
        txtPhone.Attributes["autocomplete"] = "tel";
        txtAddress.Attributes["autocomplete"] = "street-address";
        txtCurrentPassword.Attributes["autocomplete"] = "current-password";
        txtNewPassword.Attributes["autocomplete"] = "new-password";
        txtConfirmNewPassword.Attributes["autocomplete"] = "new-password";
    }

    private void LoadUserData()
    {
        int userId = (int)Session["UserId"];
        string connString = DbConfig.GetConnectionString();
        
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "SELECT * FROM dbo.KhachHang WHERE MaKH = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Id", userId);
            conn.Open();
            SqlDataReader reader = cmd.ExecuteReader();
            if (reader.Read())
            {
                txtFullName.Text = reader["HoTen"].ToString();
                txtEmail.Text = reader["Email"].ToString();
                txtPhone.Text = reader["SoDienThoai"].ToString();
                txtAddress.Text = reader["DiaChi"] == DBNull.Value ? string.Empty : reader["DiaChi"].ToString();
                
                litNameSide.Text = HttpUtility.HtmlEncode(txtFullName.Text);
                litAvatar.Text = string.IsNullOrWhiteSpace(txtFullName.Text) ? "K" : HttpUtility.HtmlEncode(txtFullName.Text.Substring(0, 1).ToUpper());
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int userId = (int)Session["UserId"];
        string name = txtFullName.Text.Trim();
        string phone = txtPhone.Text.Trim();
        string address = txtAddress.Text.Trim();

        if (string.IsNullOrWhiteSpace(name))
        {
            ShowMessage("Vui lòng nhập họ tên.", false);
            return;
        }

        if (!string.IsNullOrWhiteSpace(phone) && !Regex.IsMatch(phone, @"^[0-9+\-\s]{9,15}$"))
        {
            ShowMessage("Số điện thoại chưa hợp lệ.", false);
            return;
        }

        string connString = DbConfig.GetConnectionString();
        
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "UPDATE dbo.KhachHang SET HoTen = @Name, SoDienThoai = @Phone, DiaChi = @Address WHERE MaKH = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Name", name);
            cmd.Parameters.AddWithValue("@Phone", phone);
            cmd.Parameters.AddWithValue("@Address", address);
            cmd.Parameters.AddWithValue("@Id", userId);
            conn.Open();
            cmd.ExecuteNonQuery();
            
            Session["UserName"] = name;
            litNameSide.Text = HttpUtility.HtmlEncode(name);
            litAvatar.Text = HttpUtility.HtmlEncode(name.Substring(0, 1).ToUpper());
            ShowMessage("Đã cập nhật thông tin tài khoản.", true);
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("~/Default.aspx");
    }

    protected void btnChangePassword_Click(object sender, EventArgs e)
    {
        string current = txtCurrentPassword.Text.Trim();
        string next = txtNewPassword.Text.Trim();
        string confirm = txtConfirmNewPassword.Text.Trim();

        if (string.IsNullOrWhiteSpace(current) || string.IsNullOrWhiteSpace(next))
        {
            ShowMessage("Vui lòng nhập mật khẩu hiện tại và mật khẩu mới.", false);
            return;
        }

        if (next.Length < 6)
        {
            ShowMessage("Mật khẩu mới cần có ít nhất 6 ký tự.", false);
            return;
        }

        if (next != confirm)
        {
            ShowMessage("Mật khẩu xác nhận không khớp.", false);
            return;
        }

        int userId = (int)Session["UserId"];
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            SqlCommand read = new SqlCommand("SELECT MatKhau FROM dbo.KhachHang WHERE MaKH = @Id", conn);
            read.Parameters.AddWithValue("@Id", userId);
            object stored = read.ExecuteScalar();
            if (stored == null || stored == DBNull.Value || !SecurityHelper.VerifyPassword(current, stored.ToString()))
            {
                ShowMessage("Mật khẩu hiện tại không chính xác.", false);
                return;
            }

            SqlCommand update = new SqlCommand("UPDATE dbo.KhachHang SET MatKhau = @Password WHERE MaKH = @Id", conn);
            update.Parameters.AddWithValue("@Password", SecurityHelper.HashPassword(next));
            update.Parameters.AddWithValue("@Id", userId);
            update.ExecuteNonQuery();
        }

        txtCurrentPassword.Text = string.Empty;
        txtNewPassword.Text = string.Empty;
        txtConfirmNewPassword.Text = string.Empty;
        ShowMessage("Đã đổi mật khẩu thành công.", true);
    }

    private void ShowMessage(string message, bool success)
    {
        string cls = success ? "border-emerald-200 bg-emerald-50 text-emerald-700" : "border-red-200 bg-red-50 text-red-700";
        litMessage.Text = "<div class='mb-6 rounded-3xl border p-4 text-sm font-bold " + cls + "'>" + HttpUtility.HtmlEncode(message) + "</div>";
    }
}
