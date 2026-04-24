using System;
using System.Web;
using System.Web.Security;

public partial class Admin_Admin : System.Web.UI.MasterPage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                FahasaCatalogService.GetFeaturedProducts(1);
            }
            catch
            {
            }
        }
    }

    protected void btnLogout_Click(object sender, EventArgs e)
    {
        FormsAuthentication.SignOut();
        Session.Clear();
        Response.Redirect("~/Admin/Login.aspx");
    }
}
