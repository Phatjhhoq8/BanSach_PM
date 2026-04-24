<%@ WebHandler Language="C#" Class="CartHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Configuration;
using System.Data.SqlClient;

public class CartHandler : IHttpHandler, IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json";
        
        string action = context.Request["action"];
        string maSpStr = context.Request["maSP"];
        int maSP = 0;
        int.TryParse(maSpStr, out maSP);

        if (context.Session["UserId"] == null) {
            context.Response.Write("{\"success\":false, \"message\":\"Vui lòng đăng nhập để thực hiện.\", \"code\": \"auth_required\"}");
            return;
        }

        int userId = (int)context.Session["UserId"];
        string connString = ConfigurationManager.ConnectionStrings["BanSachConnectionString"].ConnectionString;

        try {
            using (SqlConnection conn = new SqlConnection(connString)) {
                conn.Open();
                
                // Ensure Cart exists
                string sqlEnsureCart = "IF NOT EXISTS (SELECT 1 FROM dbo.GioHang WHERE MaKH = @UID) INSERT INTO dbo.GioHang (MaKH) VALUES (@UID)";
                using (SqlCommand cmd = new SqlCommand(sqlEnsureCart, conn)) {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    cmd.ExecuteNonQuery();
                }

                if (action == "add") {
                    string sqlAdd = @"
                        IF EXISTS (SELECT 1 FROM dbo.ChiTietGioHang WHERE MaKH = @UID AND MaSP = @MID)
                            UPDATE dbo.ChiTietGioHang SET SoLuong = SoLuong + 1 WHERE MaKH = @UID AND MaSP = @MID
                        ELSE
                            INSERT INTO dbo.ChiTietGioHang (MaKH, MaSP, SoLuong) VALUES (@UID, @MID, 1)";
                    using (SqlCommand cmd = new SqlCommand(sqlAdd, conn)) {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.Parameters.AddWithValue("@MID", maSP);
                        cmd.ExecuteNonQuery();
                    }
                }
                else if (action == "update") {
                    int qty = int.Parse(context.Request["qty"] ?? "1");
                    string sqlUpdate = "UPDATE dbo.ChiTietGioHang SET SoLuong = @Qty WHERE MaKH = @UID AND MaSP = @MID";
                    using (SqlCommand cmd = new SqlCommand(sqlUpdate, conn)) {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.Parameters.AddWithValue("@MID", maSP);
                        cmd.Parameters.AddWithValue("@Qty", qty);
                        cmd.ExecuteNonQuery();
                    }
                }
                else if (action == "remove") {
                    string sqlRemove = "DELETE FROM dbo.ChiTietGioHang WHERE MaKH = @UID AND MaSP = @MID";
                    using (SqlCommand cmd = new SqlCommand(sqlRemove, conn)) {
                        cmd.Parameters.AddWithValue("@UID", userId);
                        cmd.Parameters.AddWithValue("@MID", maSP);
                        cmd.ExecuteNonQuery();
                    }
                }

                // Get current cart count
                string sqlCount = "SELECT SUM(SoLuong) FROM dbo.ChiTietGioHang WHERE MaKH = @UID";
                using (SqlCommand cmd = new SqlCommand(sqlCount, conn)) {
                    cmd.Parameters.AddWithValue("@UID", userId);
                    object result = cmd.ExecuteScalar();
                    int count = (result == DBNull.Value) ? 0 : Convert.ToInt32(result);
                    context.Response.Write("{\"success\":true, \"cartCount\":" + count + "}");
                }
            }
        }
        catch (Exception ex) {
            context.Response.Write("{\"success\":false, \"message\":\"" + ex.Message + "\"}");
        }
    }
 
    public bool IsReusable {
        get { return false; }
    }
}
