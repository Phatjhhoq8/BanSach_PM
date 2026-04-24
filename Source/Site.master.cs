using System;
using System.Configuration;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CheckLogin();
        }
    }

    private void CheckLogin()
    {
        if (Session["UserId"] != null)
        {
            int userId = (int)Session["UserId"];
            phGuest.Visible = false;
            phUser.Visible = true;
            litUserName.Text = Session["UserName"] == null ? string.Empty : Session["UserName"].ToString();
            litUserEmail.Text = Session["UserEmail"] == null ? string.Empty : Session["UserEmail"].ToString();
            UpdateCartCount(userId);
        }
        else
        {
            phGuest.Visible = true;
            phUser.Visible = false;
        }
    }

    private void UpdateCartCount(int userId)
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (System.Data.SqlClient.SqlConnection conn = new System.Data.SqlClient.SqlConnection(connString))
        {
            string sql = "SELECT SUM(SoLuong) FROM dbo.ChiTietGioHang WHERE MaKH = @UID";
            System.Data.SqlClient.SqlCommand cmd = new System.Data.SqlClient.SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@UID", userId);
            conn.Open();
            object result = cmd.ExecuteScalar();
            string count = (result == DBNull.Value) ? "0" : Convert.ToInt32(result).ToString();
            
            // We need to use a Literal or Script to update the span id="cartCount"
            Page.ClientScript.RegisterStartupScript(this.GetType(), "UpdateCart", 
                "document.getElementById('cartCount').innerText = '" + count + "';", true);
        }
    }

    protected void btnUserLogout_Click(object sender, EventArgs e)
    {
        Session.Remove("UserEmail");
        Session.Remove("UserName");
        Session.Remove("UserId");
        Response.Redirect("~/Default.aspx");
    }
}
