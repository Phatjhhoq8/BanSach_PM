using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EnsureCatalogReady();
            CheckLogin();
        }
    }

    private void EnsureCatalogReady()
    {
        try
        {
            FahasaCatalogService.GetFeaturedProducts(1);
        }
        catch
        {
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
            cartCount.InnerText = "0";
        }
    }

    private void UpdateCartCount(int userId)
    {
        try
        {
            string connString = DbConfig.GetConnectionString();
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string sql = "SELECT SUM(SoLuong) FROM dbo.ChiTietGioHang WHERE MaKH = @UID";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@UID", userId);
                conn.Open();
                object result = cmd.ExecuteScalar();
                cartCount.InnerText = (result == DBNull.Value || result == null) ? "0" : Convert.ToInt32(result).ToString();
            }
        }
        catch
        {
            cartCount.InnerText = "0";
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
