# The Book Haven

Website bán sách dùng ASP.NET Web Forms, SQL Server và giao diện storefront/admin tùy biến. Repo hỗ trợ 2 cách chạy:

- Chạy thủ công: dùng SQL Server và IIS Express trên Windows.
- Chạy bằng Docker: dùng Docker Compose để dựng web và database.

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

## Cách 1: Chạy Thủ Công Không Dùng Docker

### Yêu Cầu
- Windows
- SQL Server hoặc SQL Server Express
- .NET Framework 4.x
- IIS Express
- Visual Studio hỗ trợ ASP.NET Web Forms nếu muốn chạy bằng IDE

### Các Bước Làm Thủ Công

#### Bước 1: Cài SQL Server Express
1. Tải và cài `SQL Server Express` từ Microsoft.
2. Chọn instance mặc định là `SQLEXPRESS` nếu được hỏi.
3. Sau khi cài xong, mở `Services` bằng `Win + R` -> nhập `services.msc`.
4. Tìm `SQL Server (SQLEXPRESS)`.
5. Nếu service đang dừng, bấm `Start`.

#### Bước 2: Tạo Database
1. Mở `SQL Server Management Studio` nếu bạn có.
2. Kết nối tới server `.\SQLEXPRESS` bằng `Windows Authentication`.
3. Chuột phải `Databases` -> `New Database...`.
4. Đặt tên database là `BanSachPremium`.
5. Bấm `OK`.

Nếu bạn không dùng SSMS, có thể tạo database bằng `sqlcmd` hoặc trong Visual Studio, miễn là tên database khớp với connection string.

#### Bước 3: Kiểm Tra Connection String
1. Mở file `Source/Web.config`.
2. Kiểm tra phần `BanSachConnectionString`.
3. Mặc định của repo là:

```xml
<add name="BanSachConnectionString"
     connectionString="Data Source=.\SQLEXPRESS;Initial Catalog=BanSachPremium;Integrated Security=True"
     providerName="System.Data.SqlClient" />
```

4. Nếu máy bạn dùng SQL Server local hoặc LocalDB, sửa lại cho đúng:

```xml
<add name="BanSachConnectionString"
     connectionString="Data Source=.;Initial Catalog=BanSachPremium;Integrated Security=True;TrustServerCertificate=True"
     providerName="System.Data.SqlClient" />
```

```xml
<add name="BanSachConnectionString"
     connectionString="Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=BanSachPremium;Integrated Security=True;TrustServerCertificate=True"
     providerName="System.Data.SqlClient" />
```

#### Bước 4: Chạy Website Bằng IIS Express
1. Mở PowerShell tại thư mục gốc của repo.
2. Chạy lệnh:

```powershell
& ".\tools\IISExpress\IIS Express\iisexpress.exe" /path:"$PWD\Source" /port:8080 /clr:v4.0
```

3. Đợi cửa sổ IIS Express chạy xong.

Nếu muốn chạy một chạm từ đầu, dùng file `start/3_start-all.cmd`. File này sẽ tự kiểm tra quyền admin, cài SQL Server Express bằng `winget` nếu máy chưa có, tạo database `BanSachPremium` nếu thiếu, rồi khởi động web. Cần có internet để tải gói cài đặt.

#### Bước 5: Mở Trình Duyệt
1. Mở `http://localhost:8080/Default.aspx` để xem trang chủ.
2. Mở `http://localhost:8080/Admin/Login.aspx` để vào trang quản trị.

#### Bước 6: Đăng Nhập Demo
- Khách hàng: `user@gmail.com` / `123456`
- Admin: `admin` / `123456`

#### Bước 7: Dữ Liệu Lần Đầu
- Khi ứng dụng chạy lần đầu, hệ thống sẽ tự khởi tạo schema và import dữ liệu sách từ `Source/App_Data/product-details.json`.
- Nếu cần đối chiếu cấu trúc bảng, xem `Database_Schema.sql`.

#### Bước 8: Nếu Gặp Lỗi
- Kiểm tra service `SQL Server (SQLEXPRESS)` đã chạy.
- Kiểm tra database `BanSachPremium` đã tồn tại.
- Kiểm tra connection string trong `Source/Web.config`.
- Kiểm tra IIS Express đã mở đúng thư mục `Source`.
- Nếu cần, thử tải lại trang bằng `Ctrl + F5`.

### Chạy Bằng Visual Studio
1. Mở Visual Studio.
2. Chọn `File -> Open -> Web Site...`.
3. Trỏ tới thư mục `Source`.
4. Chạy bằng IIS Express hoặc `Ctrl + F5`.

### Khởi Tạo Dữ Liệu
- Khi ứng dụng mở lần đầu, hệ thống sẽ tự khởi tạo schema và import dữ liệu sách từ `Source/App_Data/product-details.json`.
- Nếu cần đối chiếu schema, xem `Database_Schema.sql`.

## Thứ Tự Ưu Tiên Connection String
Ứng dụng đọc connection string theo thứ tự:

1. Biến môi trường `BAN_SACH_CONNECTION_STRING`
2. Connection string `BanSachConnectionString` trong `Source/Web.config`

Khi chạy thủ công, app thường dùng `Source/Web.config`.

## Cách 2: Chạy Bằng Docker

### Yêu Cầu
- Docker Desktop hoặc Docker Engine
- Docker Compose khả dụng qua lệnh `docker compose`

### Các Bước Chạy
1. Mở terminal tại thư mục gốc repo.
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

### Xem Log

```bash
docker compose logs -f web
docker compose logs -f db
```

### Dừng Hệ Thống
Giữ nguyên dữ liệu:

```bash
docker compose down
```

Xóa cả container, network và volume dữ liệu để chạy lại từ đầu:

```bash
docker compose down -v
docker compose up --build -d
```

### Cấu Hình Mật Khẩu SQL Server Khi Chạy Docker
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

### Dữ Liệu Ban Đầu Khi Chạy Docker
- Database dùng tên `BanSachPremium`
- Khi ứng dụng khởi tạo lần đầu, hệ thống sẽ tự tạo schema và import dữ liệu sách
- Volume `mssql_data` lưu dữ liệu SQL Server
- Volume `book_uploads` lưu ảnh upload từ admin
- Khi chạy Docker, app dùng biến môi trường từ `docker-compose.yml`

## Một Số Lệnh Hữu Ích
Compile nhanh bằng ASP.NET compiler trên Windows:

```powershell
& "C:\Windows\Microsoft.NET\Framework64\v4.0.30319\aspnet_compiler.exe" -p ".\Source" -v / ".\_compiled"
```

Kiểm tra container đang chạy:

```bash
docker compose ps
```

Khởi động lại web Docker sau khi sửa giao diện:

```bash
docker compose up --build -d web
```

## Ghi Chú
- Nếu chạy thủ công, hãy kiểm tra kỹ `Web.config`, SQL Server và IIS Express.
- Nếu muốn chạy nhanh và ít cấu hình môi trường, dùng Docker.
- Dữ liệu demo và admin demo chỉ phục vụ mục đích học tập/đồ án.
