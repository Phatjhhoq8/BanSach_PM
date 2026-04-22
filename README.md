# Hướng dẫn Khởi chạy Hệ thống Nhà Sách Premium (BanSachDemo)

Dự án này là hệ thống thương mại điện tử phục vụ mục đích bán sách cao cấp. Web sử dụng giao diện lấy cảm hứng thiết kế từ Stripe Press, Fahasa, và Nothing.tech (theo quy chuẩn tài liệu dự án).

## Môi trường & Công nghệ
- **Nền tảng:** ASP.NET Web Forms (.NET Framework 4.5 C#)
- **Database:** SQL Server (LINQ to SQL)
- **Frontend Stack:** HTML5, Tailwind CSS, Vanilla JS, Fetch API

## Cấu trúc Dự án Mới
Toàn bộ mã nguồn thực chạy mới nằm trong thư mục `Source/`. Cơ sở dữ liệu và thư mục cũ đã được dọn dẹp để đảm bảo ứng dụng vận hành mượt mà theo kiến trúc sạch sẽ nhất. 

- `Source/Default.aspx`: Trang chủ (Tích hợp Video Banner).
- `Source/GioHang.aspx`: Quản lý giỏ hàng.
- `Source/Site.Master`: Giao diện bao quát (Header/Footer Tailwind CSS).
- `Database_Schema.sql`: File chứa script khởi tạo CSDL với đầy đủ quy trình Lưu Giỏ Hàng thẳng vào Database (không dùng Session tạm).

## 🚀 Cách Thức Chạy Giao Diện Web Nhanh (Local IIS Express)

Để chạy nhanh giao diện này mà không cần thiết lập Visual Studio nặng nề, bạn có thể gọi trực tiếp IIS Express (đã được tích hợp sẵn trong công cụ đính kèm):

### Tùy chọn 1: Chạy bằng Dòng lệnh PowerShell
Mở command prompt / PowerShell tại thư mục gốc `BanSachDemo` và chạy lệnh sau:
```powershell
& ".\tools\IISExpress\IIS Express\iisexpress.exe" /path:"$(Get-Location)\Source" /port:8080
```
Sau đó mở trình duyệt tại: **http://localhost:8080/**

### Tùy chọn 2: Chạy thông qua Visual Studio (Đề xuất Phát triển)
Để trải nghiệm đầy đủ các Backend CodeBehind (C#) và tương tác được với CSDL LINQ to SQL:
1. Mở CSDL (SQL Server Management Studio hoặc LocalDB), chạy file `Database_Schema.sql` để xây DB.
2. Mở Visual Studio.
3. Chọn **File -> Open Web Site...**
4. Trỏ tới thư mục `c:\Users\Admin\Desktop\BanSachDemo\Source`.
5. Thêm cấu hình LINQ to SQL `.dbml` từ CSDL và sửa các mock function tại `#CodeBehind` để hệ thống kết nối logic đầy đủ.
6. Bấm `F5` / `Ctrl + F5` để khởi chạy ứng dụng web.

> **Lưu ý tính năng Front-end**: Giỏ hàng (nút Add to Cart) hiện đang được cấu hình thực hiện gọi nền `cartCount` theo hướng non-postback (không tải lại trang). Hãy đảm bảo gọi Fetch API qua Handler `CartHandler.ashx` để hoàn tác trải nghiệm thay vì submit form .NET truyền thống.
