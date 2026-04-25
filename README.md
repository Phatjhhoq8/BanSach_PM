# BanSachDemo - Premium Books

Website bán sách dùng ASP.NET Web Forms, SQL Server và giao diện storefront/admin tùy biến. Repo hỗ trợ 2 cách chạy:

- Chạy bằng Docker: nhanh nhất, ít cấu hình nhất.
- Chạy thủ công: dùng Visual Studio + SQL Server/IIS Express.

## Công Nghệ
- ASP.NET Web Forms (.NET Framework 4.5, C#)
- SQL Server
- Tailwind CSS CDN, Vanilla JavaScript, Fetch API
- Docker Compose: Mono/XSP4 cho web và SQL Server container

## Cấu Trúc Chính
- `Source/`: mã nguồn web chính
- `Source/Site.Master`: layout website khách
- `Source/Admin/Admin.master`: layout admin
- `Source/css/site.css`: token giao diện storefront
- `Source/App_Data/product-details.json`: dữ liệu sách import khi khởi tạo
- `Database_Schema.sql`: script schema tham khảo
- `Dockerfile`, `docker-compose.yml`, `docker/entrypoint.sh`: cấu hình Docker

## Tính Năng
- Khách vãng lai: xem trang chủ, danh mục, tìm kiếm/lọc sách, xem chi tiết sách, đọc tin tức/FAQ
- Khách hàng: đăng ký, đăng nhập, giỏ hàng, yêu thích, đặt hàng COD, xem lịch sử đơn
- Quản trị viên: dashboard, quản lý sản phẩm, danh mục, đơn hàng, khách hàng, mã ưu đãi, tin tức/FAQ/cài đặt

## Tài Khoản Demo
- Khách hàng: `user@gmail.com` / `123456`
- Admin: `admin` / `123456`

## Mã Ưu Đãi Demo
- `SALE10`: giảm 10%
- `FREESHIP`: giảm 30.000đ

## Cài Đặt Từ Đầu

### Cách 1: Chạy Bằng Docker

Đây là cách khuyến nghị.

### Yêu cầu
- Cài Docker Desktop hoặc Docker Engine
- Docker Compose khả dụng qua lệnh `docker compose`

### Các bước chạy
1. Mở terminal tại thư mục gốc repo
2. Chạy:

```bash
docker compose up --build -d
```

3. Kiểm tra trạng thái:

```bash
docker compose ps
```

4. Khi `db` đã `healthy` và `web` đang `up`, truy cập:

```text
Storefront: http://localhost:8080
Admin:      http://localhost:8080/Admin/Login.aspx
```

### Xem log

```bash
docker compose logs -f web
docker compose logs -f db
```

### Dừng hệ thống

Giữ nguyên dữ liệu:

```bash
docker compose down
```

Xóa cả container, network và volume dữ liệu để chạy lại từ đầu:

```bash
docker compose down -v
docker compose up --build -d
```

### Cấu hình mật khẩu SQL Server khi chạy Docker

Mật khẩu mặc định trong `docker-compose.yml`:

```text
YourStrong!Passw0rd
```

Nếu muốn đổi:

PowerShell:

```powershell
$env:MSSQL_SA_PASSWORD="MatKhauManhHon!123"
docker compose up --build -d
```

Bash:

```bash
MSSQL_SA_PASSWORD='MatKhauManhHon!123' docker compose up --build -d
```

## Dữ Liệu Ban Đầu Khi Chạy Docker
- Database dùng tên `BanSachPremium`
- Khi ứng dụng khởi tạo lần đầu, hệ thống sẽ tự:
  - tạo schema cần thiết
  - import dữ liệu sách từ `Source/App_Data/product-details.json`
- Volume `mssql_data` lưu dữ liệu SQL Server
- Volume `book_uploads` lưu ảnh upload từ admin

## Cách 2: Chạy Thủ Công Không Dùng Docker

### Yêu cầu
- Windows
- Visual Studio hỗ trợ ASP.NET Web Forms
- SQL Server hoặc LocalDB
- .NET Framework phù hợp với project Web Site

### Các bước chạy
1. Cài SQL Server hoặc LocalDB
2. Tạo database mới, ví dụ `BanSachPremium`
3. Mở `Source/Web.config`
4. Cập nhật connection string `BanSachConnectionString` cho đúng máy của bạn
5. Mở Visual Studio
6. Chọn `File -> Open -> Web Site...`
7. Trỏ tới thư mục `Source`
8. Chạy bằng IIS Express hoặc `Ctrl + F5`

### Gợi Ý Connection String

SQL Server local:

```xml
<add name="BanSachConnectionString"
     connectionString="Data Source=.;Initial Catalog=BanSachPremium;Integrated Security=True;TrustServerCertificate=True"
     providerName="System.Data.SqlClient" />
```

LocalDB:

```xml
<add name="BanSachConnectionString"
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=BanSachPremium;Integrated Security=True;TrustServerCertificate=True"
     providerName="System.Data.SqlClient" />
```

### Khởi Tạo Dữ Liệu
- Bạn có thể để ứng dụng tự khởi tạo schema/dữ liệu khi mở các trang catalog đầu tiên
- Hoặc tự kiểm tra schema bằng `Database_Schema.sql` nếu cần đối chiếu

## Thứ Tự Ưu Tiên Connection String
Ứng dụng đọc connection string theo thứ tự:

1. Biến môi trường `BAN_SACH_CONNECTION_STRING`
2. Connection string `BanSachConnectionString` trong `Source/Web.config`

Điều này có nghĩa:
- Khi chạy Docker: app dùng biến môi trường từ `docker-compose.yml`
- Khi chạy thủ công: app thường dùng `Source/Web.config`

## Một Số Lệnh Hữu Ích

Compile nhanh bằng ASP.NET compiler trên Windows:

```powershell
& "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_compiler.exe" -p ".\Source" -v / ".\_compiled"
```

Kiểm tra container đang chạy:

```bash
docker compose ps
```

Khởi động lại web sau khi sửa giao diện:

```bash
docker compose up --build -d web
```

## Ghi Chú
- Docker là cách nên dùng nếu muốn chạy nhanh và ít lỗi môi trường
- Nếu chạy thủ công, hãy kiểm tra kỹ `Web.config`, SQL Server và IIS Express
- Dữ liệu demo và admin demo chỉ phục vụ mục đích học tập/đồ án
