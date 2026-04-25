using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

public partial class Admin_Orders : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.HttpMethod == "POST" && Request.QueryString["action"] == "update")
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
        string connString = DbConfig.GetConnectionString();
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
        int id;
        int status;
        if (!int.TryParse(Request.QueryString["id"], out id) || !int.TryParse(Request.QueryString["status"], out status) || status < 0 || status > 4)
        {
            Response.Redirect("Orders.aspx");
            return;
        }
        
        string connString = DbConfig.GetConnectionString();
        using (SqlConnection conn = new SqlConnection(connString))
        {
            conn.Open();
            UpdateOrderStatus(conn, id, status);
        }
        Response.Redirect("Orders.aspx");
    }

    private void UpdateOrderStatus(SqlConnection conn, int orderId, int newStatus)
    {
        int oldStatus = GetCurrentStatus(conn, orderId);
        using (SqlTransaction trans = conn.BeginTransaction())
        {
            try
            {
                if (newStatus == 4 && oldStatus != 4)
                {
                    RestoreStock(conn, trans, orderId);
                }

                SqlCommand cmd = new SqlCommand("UPDATE dbo.DonHang SET TrangThai = @Status WHERE MaDH = @Id", conn, trans);
                cmd.Parameters.AddWithValue("@Status", newStatus);
                cmd.Parameters.AddWithValue("@Id", orderId);
                cmd.ExecuteNonQuery();
                trans.Commit();
            }
            catch
            {
                try { trans.Rollback(); } catch { }
                throw;
            }
        }
    }

    private int GetCurrentStatus(SqlConnection conn, int orderId)
    {
        SqlCommand cmd = new SqlCommand("SELECT TrangThai FROM dbo.DonHang WHERE MaDH = @Id", conn);
        cmd.Parameters.AddWithValue("@Id", orderId);
        object value = cmd.ExecuteScalar();
        return value == null || value == DBNull.Value ? -1 : Convert.ToInt32(value);
    }

    private void RestoreStock(SqlConnection conn, SqlTransaction trans, int orderId)
    {
        SqlCommand cmd = new SqlCommand(@"
            UPDATE sp SET sp.SoLuongTon = sp.SoLuongTon + ct.SoLuong
            FROM dbo.SanPham sp
            JOIN dbo.ChiTietDonHang ct ON ct.MaSP = sp.MaSP
            WHERE ct.MaDH = @Id", conn, trans);
        cmd.Parameters.AddWithValue("@Id", orderId);
        cmd.ExecuteNonQuery();
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadOrders();
    }

    protected void rptOrders_ItemDataBound(object sender, RepeaterItemEventArgs e)
    {
        if (e.Item.ItemType != ListItemType.Item && e.Item.ItemType != ListItemType.AlternatingItem)
        {
            return;
        }

        DataRowView row = e.Item.DataItem as DataRowView;
        DropDownList ddl = e.Item.FindControl("ddlUpdateStatus") as DropDownList;
        if (row != null && ddl != null)
        {
            ddl.SelectedValue = row["TrangThai"].ToString();
        }
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
