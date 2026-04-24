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

    private void ShowMessage(string message, bool success)
    {
        string cls = success ? "border-emerald-200 bg-emerald-50 text-emerald-700" : "border-red-200 bg-red-50 text-red-700";
        litMessage.Text = "<div class='mb-6 rounded-3xl border p-4 text-sm font-bold " + cls + "'>" + HttpUtility.HtmlEncode(message) + "</div>";
    }
}
