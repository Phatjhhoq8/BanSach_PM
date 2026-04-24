# BanSachDemo - Premium Books

Hệ thống thương mại điện tử bán sách cho đồ án môn học. Ứng dụng dùng ASP.NET Web Forms, SQL Server và giao diện storefront editorial hiện đại.

## Công Nghệ
- ASP.NET Web Forms (.NET Framework 4.5, C#)
- SQL Server
- Tailwind CSS CDN, Vanilla JavaScript, Fetch API
- Docker Compose: Mono/XSP4 cho web và SQL Server Linux container

## Cấu Trúc Chính
- `Source/`: mã nguồn web chạy chính.
- `Source/Site.Master`: layout storefront.
- `Source/Admin/Admin.master`: layout trang quản trị.
- `Source/css/site.css`: token giao diện và component dùng chung.
- `Source/App_Data/product-details.json`: dữ liệu sách import tự động khi chạy lần đầu.
- `Database_Schema.sql`: script schema tham khảo.
- `Dockerfile`, `docker-compose.yml`, `docker/entrypoint.sh`: cấu hình chạy bằng Docker.

## Tính Năng
- Khách vãng lai: xem trang chủ, danh mục, tìm kiếm/lọc sách, xem chi tiết sách, đọc tin tức/FAQ.
- Khách hàng: đăng ký, đăng nhập, cập nhật tài khoản, yêu thích sách, giỏ hàng, áp dụng mã ưu đãi, đặt hàng COD, xem lịch sử và chi tiết đơn hàng.
- Quản trị viên: dashboard, quản lý sản phẩm, danh mục, đơn hàng, khách hàng, mã ưu đãi, tin tức/FAQ/cài đặt.
- Docker: chạy web và database bằng một lệnh, hỗ trợ biến môi trường connection string.

## Tài Khoản Demo
- Khách hàng: `user@gmail.com` / `123456`
- Admin: `admin` / `123456`

## Mã Ưu Đãi Demo
- `SALE10`: giảm 10%.
- `FREESHIP`: giảm 30.000đ.

## Chạy Nhanh Bằng Docker

Yêu cầu đã cài Docker Desktop hoặc Docker Engine có hỗ trợ Docker Compose.

Tại thư mục gốc repo, chạy:

```bash
docker compose up --build -d
```

Chờ database healthy và web khởi động, sau đó mở:

```text
http://localhost:8080
```

Trang admin:

```text
http://localhost:8080/Admin/Login.aspx
```

Kiểm tra container:

```bash
docker compose ps
```

Xem log:

```bash
docker compose logs -f web
docker compose logs -f db
```

Dừng hệ thống nhưng giữ dữ liệu:

```bash
docker compose down
```

Chạy lại từ đầu với database sạch:

```bash
docker compose down -v
docker compose up --build -d
```

## Cấu Hình Database

Mật khẩu SQL Server mặc định trong `docker-compose.yml` là:

```text
YourStrong!Passw0rd
```

Đổi mật khẩu khi chạy:

```bash
MSSQL_SA_PASSWORD='MatKhauManhHon!123' docker compose up --build -d
```

Ứng dụng đọc connection string theo thứ tự:
- Biến môi trường `BAN_SACH_CONNECTION_STRING`.
- Connection string `BanSachConnectionString` trong `Source/Web.config`.

Khi chạy bằng Docker Compose, connection string được truyền sẵn qua `BAN_SACH_CONNECTION_STRING`.

## Dữ Liệu Ban Đầu
- Repo đã có dữ liệu sách tại `Source/App_Data/product-details.json`.
- Khi truy cập các trang đọc catalog lần đầu, hệ thống tự tạo schema và import dữ liệu vào database `BanSachPremium` nếu chưa có dữ liệu.
- Volume `mssql_data` lưu database SQL Server.
- Volume `book_uploads` lưu ảnh upload từ admin.

## Chạy Bằng Visual Studio

Nếu không dùng Docker:

1. Cài SQL Server hoặc LocalDB.
2. Tạo database theo `Database_Schema.sql` nếu cần.
3. Mở Visual Studio.
4. Chọn `File -> Open -> Web Site...` và trỏ tới thư mục `Source`.
5. Kiểm tra connection string `BanSachConnectionString` trong `Source/Web.config`.
6. Chạy bằng `Ctrl + F5` hoặc IIS Express.

Docker là cách chạy khuyến nghị vì không cần cấu hình IIS/SQL Server thủ công.
