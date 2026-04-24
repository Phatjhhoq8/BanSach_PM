using System;

public partial class Success : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string id = Request.QueryString["id"];
        if (!string.IsNullOrEmpty(id))
        {
            litOrderId.Text = id;
        }
        else
        {
            Response.Redirect("~/Default.aspx");
        }
    }
}
