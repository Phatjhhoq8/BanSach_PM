<%@ WebHandler Language="C#" Class="CartHandler" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Linq;

// CartHandler triển khai IRequiresSessionState để lấy Session cho UID nếu làm ẩn danh
public class CartHandler : IHttpHandler, IRequiresSessionState {
    
    public void ProcessRequest (HttpContext context) {
        context.Response.ContentType = "application/json";
        
        string action = context.Request["action"];
        string maSpStr = context.Request["maSP"];
        int maSP = 0;
        int.TryParse(maSpStr, out maSP);

        // Giả lập lấy ID Khách Hàng hiện hành (Nếu chưa đăng nhập, bắt đăng nhập)
        int currentUserId = 1; // context.Session["MaKH"] != null ...
        
        try {
            // NOTE: Bạn cần khởi tạo BanSachDataContext từ LINQ to SQL Designer của bạn.
            // using (var db = new BanSachDataContext()) { ... }
            
            if (action == "add") {
                // Logic thêm vào CSDL:
                // 1. Kiểm tra KhachHang đã có GioHang chưa. Chưa có thì Insert GioHang(MaKH).
                // 2. Insert hoặc Update ChiTietGioHang(MaKH, MaSP, SoLuong+1).
                
                context.Response.Write("{\"success\":true, \"message\":\"Sản phẩm đã được thêm vào giỏ hàng DB!\", \"cartCount\": 1}");
            }
            else if (action == "remove") {
                // Xóa ChiTietGioHang
                context.Response.Write("{\"success\":true, \"message\":\"Đã xóa sản phẩm.\"}");
            }
            else if (action == "update") {
                // Cập nhật số lượng
                context.Response.Write("{\"success\":true, \"message\":\"Đã cập nhật số lượng.\"}");
            }
            else {
                context.Response.Write("{\"success\":false, \"message\":\"Invalid action.\"}");
            }
        }
        catch (Exception ex)
        {
            context.Response.Write("{\"success\":false, \"message\":\"" + ex.Message + "\"}");
        }
    }
 
    public bool IsReusable {
        get { return false; }
    }
}
