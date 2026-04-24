using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin_Orders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["action"] == "update")
        {
            UpdateStatus();
        }

        if (!IsPostBack)
        {
            LoadOrders();
        }
    }

    private void LoadOrders()
    {
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = @"
                SELECT dh.MaDH, dh.NgayDat, dh.TongTien, dh.TrangThai, dh.SoDienThoaiGiao, kh.HoTen 
                FROM dbo.DonHang dh 
                JOIN dbo.KhachHang kh ON dh.MaKH = kh.MaKH 
                WHERE 1=1";
            
            if (ddlStatus.SelectedValue != "-1")
            {
                sql += " AND dh.TrangThai = @Status";
            }
            
            sql += " ORDER BY dh.MaDH DESC";

            SqlCommand cmd = new SqlCommand(sql, conn);
            if (ddlStatus.SelectedValue != "-1")
                cmd.Parameters.AddWithValue("@Status", ddlStatus.SelectedValue);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);
            rptOrders.DataSource = dt;
            rptOrders.DataBind();
        }
    }

    private void UpdateStatus()
    {
        int id = int.Parse(Request.QueryString["id"]);
        int status = int.Parse(Request.QueryString["status"]);
        
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;
        using (SqlConnection conn = new SqlConnection(connString))
        {
            string sql = "UPDATE dbo.DonHang SET TrangThai = @Status WHERE MaDH = @Id";
            SqlCommand cmd = new SqlCommand(sql, conn);
            cmd.Parameters.AddWithValue("@Status", status);
            cmd.Parameters.AddWithValue("@Id", id);
            conn.Open();
            cmd.ExecuteNonQuery();
        }
        Response.Redirect("Orders.aspx");
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadOrders();
    }

    protected string GetStatusText(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "Chờ xác nhận";
            case 1: return "Đang xử lý";
            case 2: return "Đang giao hàng";
            case 3: return "Hoàn thành";
            case 4: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    protected string GetStatusClass(object status)
    {
        int s = Convert.ToInt32(status);
        switch (s)
        {
            case 0: return "bg-amber-500/10 text-amber-500";
            case 1: return "bg-blue-500/10 text-blue-500";
            case 2: return "bg-purple-500/10 text-purple-500";
            case 3: return "bg-emerald-500/10 text-emerald-500";
            case 4: return "bg-rose-500/10 text-rose-500";
            default: return "bg-slate-500/10 text-slate-500";
        }
    }
}
