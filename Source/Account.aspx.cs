using System;
using System.Configuration;
using System.Data.SqlClient;
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
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        
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
                
                litNameSide.Text = txtFullName.Text;
                litAvatar.Text = txtFullName.Text.Substring(0, 1).ToUpper();
            }
        }
    }

    protected void btnUpdate_Click(object sender, EventArgs e)
    {
        int userId = (int)Session["UserId"];
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "UPDATE dbo.KhachHang SET HoTen = @Name, SoDienThoai = @Phone, DiaChi = @Address WHERE MaKH = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Name", txtFullName.Text.Trim());
            cmd.Parameters.AddWithValue("@Phone", txtPhone.Text.Trim());
            cmd.Parameters.AddWithValue("@Address", txtAddress.Text.Trim());
            cmd.Parameters.AddWithValue("@Id", userId);
            conn.Open();
            cmd.ExecuteNonQuery();
            
            Session["UserName"] = txtFullName.Text.Trim();
            litNameSide.Text = txtFullName.Text.Trim();
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        Session.Clear();
        Response.Redirect("~/Default.aspx");
    }
}
