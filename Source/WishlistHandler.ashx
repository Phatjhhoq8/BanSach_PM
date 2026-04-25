<%@ WebHandler Language="C#" Class="WishlistHandler" %>

using System;
using System.Data.SqlClient;
using System.Web;
using System.Web.SessionState;

public class WishlistHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        if (context.Session["UserId"] == null)
        {
            WriteJson(context, false, "Vui lòng đăng nhập để lưu yêu thích.", "auth_required");
            return;
        }

        int maSP;
        if (!int.TryParse(context.Request["maSP"], out maSP) || maSP <= 0)
        {
            WriteJson(context, false, "Sản phẩm không hợp lệ.", "invalid_product");
            return;
        }

        string action = (context.Request["action"] ?? "toggle").Trim().ToLowerInvariant();
        int userId = (int)context.Session["UserId"];

        try
        {
            DatabaseInitializer.EnsureInitialized();
            using (SqlConnection conn = new SqlConnection(DbConfig.GetConnectionString()))
            {
                conn.Open();
                if (action == "remove")
                {
                    Execute(conn, "DELETE FROM dbo.YeuThich WHERE MaKH=@UID AND MaSP=@MID", userId, maSP);
                    WriteJson(context, true, "Đã xóa khỏi danh sách yêu thích.", "removed");
                    return;
                }

                if (Exists(conn, userId, maSP))
                {
                    Execute(conn, "DELETE FROM dbo.YeuThich WHERE MaKH=@UID AND MaSP=@MID", userId, maSP);
                    WriteJson(context, true, "Đã xóa khỏi danh sách yêu thích.", "removed");
                }
                else
                {
                    Execute(conn, "INSERT INTO dbo.YeuThich (MaKH, MaSP) VALUES (@UID, @MID)", userId, maSP);
                    WriteJson(context, true, "Đã thêm vào danh sách yêu thích.", "added");
                }
            }
        }
        catch
        {
            WriteJson(context, false, "Không thể xử lý yêu thích lúc này.", "server_error");
        }
    }

    private bool Exists(SqlConnection conn, int userId, int maSP)
    {
        using (SqlCommand cmd = new SqlCommand("SELECT COUNT(1) FROM dbo.YeuThich WHERE MaKH=@UID AND MaSP=@MID", conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            return Convert.ToInt32(cmd.ExecuteScalar()) > 0;
        }
    }

    private void Execute(SqlConnection conn, string sql, int userId, int maSP)
    {
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            cmd.ExecuteNonQuery();
        }
    }

    private void WriteJson(HttpContext context, bool success, string message, string code)
    {
        context.Response.Write("{\"success\":" + (success ? "true" : "false") + ",\"message\":\"" + EscapeJson(message) + "\",\"code\":\"" + EscapeJson(code) + "\"}");
    }

    private string EscapeJson(string value)
    {
        return string.IsNullOrEmpty(value) ? string.Empty : value.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "").Replace("\n", " ");
    }

    public bool IsReusable { get { return false; } }
}
