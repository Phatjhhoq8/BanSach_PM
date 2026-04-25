using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;

public partial class SiteMaster : MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            EnsureCatalogReady();
            LoadStoreSettings();
            CheckLogin();
        }
    }

    private void EnsureCatalogReady()
    {
        try
        {
            DatabaseInitializer.EnsureInitialized();
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
            phMobileGuest.Visible = false;
            phMobileUser.Visible = true;
            litUserName.Text = Session["UserName"] == null ? string.Empty : Session["UserName"].ToString();
            litUserEmail.Text = Session["UserEmail"] == null ? string.Empty : Session["UserEmail"].ToString();
            UpdateCartCount(userId);
        }
        else
        {
            phGuest.Visible = true;
            phUser.Visible = false;
            phMobileGuest.Visible = true;
            phMobileUser.Visible = false;
            cartCount.InnerText = "0";
        }
    }

    private void LoadStoreSettings()
    {
        try
        {
            string storeName = DatabaseInitializer.GetSetting("StoreName", "The Book Haven");
            string hotline = DatabaseInitializer.GetSetting("Hotline", "1900 123456");
            string email = DatabaseInitializer.GetSetting("SupportEmail", "cskh@premiumbooks.vn");
            string address = DatabaseInitializer.GetSetting("StoreAddress", "123, DNC");

            litHeaderStoreName.Text = HttpUtility.HtmlEncode(storeName);
            litFooterStoreName.Text = HttpUtility.HtmlEncode(storeName);
            litTopHotline.Text = HttpUtility.HtmlEncode(hotline);
            litFooterHotline.Text = HttpUtility.HtmlEncode(hotline);
            litFooterEmail.Text = HttpUtility.HtmlEncode(email);
            litFooterAddress.Text = HttpUtility.HtmlEncode(address);
            footerEmailLink.HRef = "mailto:" + email;
            footerHotlineLink.HRef = "tel:" + NormalizePhone(hotline);
        }
        catch
        {
        }
    }

    private string NormalizePhone(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return string.Empty;
        }

        return System.Text.RegularExpressions.Regex.Replace(value, @"[^0-9+]", string.Empty);
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
