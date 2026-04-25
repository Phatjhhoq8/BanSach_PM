<%@ WebHandler Language="C#" Class="CartHandler" %>

using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.SessionState;

public class CartHandler : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Response.ContentType = "application/json";

        if (context.Session["UserId"] == null)
        {
            WriteJson(context, false, "Vui lòng đăng nhập để thực hiện.", 0, "auth_required");
            return;
        }

        string action = (context.Request["action"] ?? string.Empty).Trim().ToLowerInvariant();
        int maSP;
        if (!int.TryParse(context.Request["maSP"], out maSP) || maSP <= 0)
        {
            WriteJson(context, false, "Sản phẩm không hợp lệ.", 0, "invalid_product");
            return;
        }

        int userId = (int)context.Session["UserId"];
        string connString = DbConfig.GetConnectionString();

        try
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                EnsureCart(conn, userId);

                int stock = GetStock(conn, maSP);
                if (stock <= 0 && action != "remove")
                {
                    WriteJson(context, false, "Sách này đang tạm hết hàng.", GetCartCount(conn, userId), "out_of_stock");
                    return;
                }

                if (action == "add")
                {
                    int qty = ParseQty(context.Request["qty"], 1);
                    int currentQty = GetCurrentQty(conn, userId, maSP);
                    if (currentQty + qty > stock)
                    {
                        WriteJson(context, false, "Số lượng trong giỏ vượt quá tồn kho hiện có.", GetCartCount(conn, userId), "stock_limit");
                        return;
                    }

                    AddItem(conn, userId, maSP, qty);
                    WriteJson(context, true, "Đã thêm sách vào giỏ hàng.", GetCartCount(conn, userId), string.Empty);
                    return;
                }

                if (action == "update")
                {
                    int qty = ParseQty(context.Request["qty"], 1);
                    if (qty > stock)
                    {
                        WriteJson(context, false, "Số lượng cập nhật vượt quá tồn kho hiện có.", GetCartCount(conn, userId), "stock_limit");
                        return;
                    }

                    UpdateItem(conn, userId, maSP, qty);
                    WriteJson(context, true, "Đã cập nhật giỏ hàng.", GetCartCount(conn, userId), string.Empty, FormatCurrency(GetCartSubtotal(conn, userId)), FormatCurrency(GetItemTotal(conn, userId, maSP)));
                    return;
                }

                if (action == "remove")
                {
                    RemoveItem(conn, userId, maSP);
                    WriteJson(context, true, "Đã xóa sách khỏi giỏ hàng.", GetCartCount(conn, userId), string.Empty, FormatCurrency(GetCartSubtotal(conn, userId)), string.Empty);
                    return;
                }

                WriteJson(context, false, "Thao tác không hợp lệ.", GetCartCount(conn, userId), "invalid_action");
            }
        }
        catch
        {
            WriteJson(context, false, "Không thể xử lý giỏ hàng lúc này.", 0, "server_error");
        }
    }

    private static int ParseQty(string raw, int fallback)
    {
        int qty;
        if (!int.TryParse(raw, out qty) || qty < 1)
        {
            return fallback;
        }

        return qty;
    }

    private static void EnsureCart(SqlConnection conn, int userId)
    {
        string sql = "IF NOT EXISTS (SELECT 1 FROM dbo.GioHang WHERE MaKH = @UID) INSERT INTO dbo.GioHang (MaKH) VALUES (@UID)";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.ExecuteNonQuery();
        }
    }

    private static int GetStock(SqlConnection conn, int maSP)
    {
        string sql = "SELECT CASE WHEN TrangThai = 1 THEN SoLuongTon ELSE 0 END FROM dbo.SanPham WHERE MaSP = @MID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@MID", maSP);
            object result = cmd.ExecuteScalar();
            if (result == null || result == DBNull.Value)
            {
                return 0;
            }

            return Convert.ToInt32(result);
        }
    }

    private static int GetCurrentQty(SqlConnection conn, int userId, int maSP)
    {
        string sql = "SELECT SoLuong FROM dbo.ChiTietGioHang WHERE MaKH = @UID AND MaSP = @MID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            object result = cmd.ExecuteScalar();
            return result == null || result == DBNull.Value ? 0 : Convert.ToInt32(result);
        }
    }

    private static void AddItem(SqlConnection conn, int userId, int maSP, int qty)
    {
        string sql = @"
            IF EXISTS (SELECT 1 FROM dbo.ChiTietGioHang WHERE MaKH = @UID AND MaSP = @MID)
                UPDATE dbo.ChiTietGioHang SET SoLuong = SoLuong + @Qty WHERE MaKH = @UID AND MaSP = @MID
            ELSE
                INSERT INTO dbo.ChiTietGioHang (MaKH, MaSP, SoLuong) VALUES (@UID, @MID, @Qty)";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            cmd.Parameters.AddWithValue("@Qty", qty);
            cmd.ExecuteNonQuery();
        }
    }

    private static void UpdateItem(SqlConnection conn, int userId, int maSP, int qty)
    {
        string sql = "UPDATE dbo.ChiTietGioHang SET SoLuong = @Qty WHERE MaKH = @UID AND MaSP = @MID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            cmd.Parameters.AddWithValue("@Qty", qty);
            cmd.ExecuteNonQuery();
        }
    }

    private static void RemoveItem(SqlConnection conn, int userId, int maSP)
    {
        string sql = "DELETE FROM dbo.ChiTietGioHang WHERE MaKH = @UID AND MaSP = @MID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            cmd.ExecuteNonQuery();
        }
    }

    private static int GetCartCount(SqlConnection conn, int userId)
    {
        string sql = "SELECT SUM(SoLuong) FROM dbo.ChiTietGioHang WHERE MaKH = @UID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            object result = cmd.ExecuteScalar();
            return result == null || result == DBNull.Value ? 0 : Convert.ToInt32(result);
        }
    }

    private static decimal GetCartSubtotal(SqlConnection conn, int userId)
    {
        string sql = @"
            SELECT SUM(ct.SoLuong * (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END))
            FROM dbo.ChiTietGioHang ct
            JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
            WHERE ct.MaKH = @UID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            object result = cmd.ExecuteScalar();
            return result == null || result == DBNull.Value ? 0 : Convert.ToDecimal(result);
        }
    }

    private static decimal GetItemTotal(SqlConnection conn, int userId, int maSP)
    {
        string sql = @"
            SELECT ct.SoLuong * (CASE WHEN sp.GiaKhuyenMai > 0 THEN sp.GiaKhuyenMai ELSE sp.Gia END)
            FROM dbo.ChiTietGioHang ct
            JOIN dbo.SanPham sp ON ct.MaSP = sp.MaSP
            WHERE ct.MaKH = @UID AND ct.MaSP = @MID";
        using (SqlCommand cmd = new SqlCommand(sql, conn))
        {
            cmd.Parameters.AddWithValue("@UID", userId);
            cmd.Parameters.AddWithValue("@MID", maSP);
            object result = cmd.ExecuteScalar();
            return result == null || result == DBNull.Value ? 0 : Convert.ToDecimal(result);
        }
    }

    private static string FormatCurrency(decimal value)
    {
        return value.ToString("N0", CultureInfo.GetCultureInfo("vi-VN")) + "đ";
    }

    private static void WriteJson(HttpContext context, bool success, string message, int cartCount, string code)
    {
        context.Response.Write("{\"success\":" + (success ? "true" : "false") +
            ",\"message\":\"" + EscapeJson(message) + "\"" +
            ",\"cartCount\":" + cartCount +
            ",\"code\":\"" + EscapeJson(code) + "\"}");
    }

    private static void WriteJson(HttpContext context, bool success, string message, int cartCount, string code, string subtotalText, string itemTotalText)
    {
        context.Response.Write("{\"success\":" + (success ? "true" : "false") +
            ",\"message\":\"" + EscapeJson(message) + "\"" +
            ",\"cartCount\":" + cartCount +
            ",\"code\":\"" + EscapeJson(code) + "\"" +
            ",\"subtotalText\":\"" + EscapeJson(subtotalText) + "\"" +
            ",\"itemTotalText\":\"" + EscapeJson(itemTotalText) + "\"}");
    }

    private static string EscapeJson(string value)
    {
        if (string.IsNullOrEmpty(value))
        {
            return string.Empty;
        }

        return value.Replace("\\", "\\\\").Replace("\"", "\\\"").Replace("\r", "").Replace("\n", " ");
    }

    public bool IsReusable
    {
        get { return false; }
    }
}
