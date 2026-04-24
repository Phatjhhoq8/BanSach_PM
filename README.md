# Hướng dẫn Khởi chạy Hệ thống Nhà Sách Premium (BanSachDemo)

Dự án này là hệ thống thương mại điện tử phục vụ mục đích bán sách cho đồ án môn học. Giao diện mới đi theo hướng **nhà sách editorial hiện đại**: ấm, tinh tế, tập trung vào bìa sách và hành trình mua hàng rõ ràng.

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
- `Source/App_Data/product-details.json`: Dữ liệu sách Fahasa đã được đưa sẵn vào repo để tự import khi chạy lần đầu.

## Chức năng chính sau khi hoàn thiện
- **Khách vãng lai:** xem trang chủ, danh mục, tìm kiếm/lọc sách, xem chi tiết sách.
- **Khách hàng:** đăng ký, đăng nhập, cập nhật tài khoản, thêm giỏ hàng, kiểm tra tồn kho, áp dụng mã ưu đãi, đặt hàng COD, xem lịch sử và chi tiết đơn hàng.
- **Quản trị viên:** đăng nhập admin, xem dashboard số liệu thật, quản lý sản phẩm, danh mục, đơn hàng, khách hàng và mã ưu đãi.
- **Thiết kế:** dùng `Source/css/site.css` để chuẩn hóa token màu/spacing/component cho storefront editorial.

## Tài khoản demo
- Khách hàng: `user@gmail.com` / `123456`
- Admin: `admin` / `123456`

## Mã ưu đãi demo
- `SALE10`: giảm 10%.
- `FREESHIP`: giảm 30.000đ.

## Chạy bằng Docker trên Ubuntu

Dự án là ASP.NET Web Forms .NET Framework nên Docker trên Ubuntu chạy qua Mono/XSP4, kèm SQL Server Linux container.

```bash
docker compose up --build -d
```

Sau khi container khởi động, mở:

```text
http://localhost:8080
```

Các lệnh hữu ích:

```bash
docker compose ps
docker compose logs -f web
docker compose logs -f db
docker compose down
```

Database được lưu ở Docker volume `mssql_data`, ảnh upload admin được lưu ở volume `book_uploads`. Nếu muốn chạy lại từ đầu với database sạch:

```bash
docker compose down -v
docker compose up --build -d
```

Mật khẩu SQL Server mặc định trong `docker-compose.yml` là `YourStrong!Passw0rd`. Có thể đổi bằng biến môi trường:

```bash
MSSQL_SA_PASSWORD='MatKhauManhHon!123' docker compose up --build -d
```

## Dữ liệu đi kèm repo
- Repo đã chứa sẵn dữ liệu crawl tại `Source/App_Data/product-details.json`.
- Khi ứng dụng khởi chạy và truy cập vào trang có đọc catalog, hệ thống sẽ tự tạo schema và import dữ liệu vào `BanSachPremium` nếu chưa có.
- Vì vậy người khác chỉ cần clone repo, chạy web bằng môi trường phù hợp (`IIS Express`/Visual Studio + SQL Server hoặc LocalDB) là có dữ liệu để xem ngay.

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
