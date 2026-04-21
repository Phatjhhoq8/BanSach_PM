# BanSachDemo - Hệ Thống Bán Sách Trực Tuyến

Đây là một dự án ứng dụng web bán sách được xây dựng bằng công nghệ ASP.NET Web Forms.

## Thành viên thực hiện
- Trần Minh Khương - Designer
- Trương Hữu Tài - Coder
- Phan Thành Đô - Reporter
- Nguyễn Thị Hồng Vân - Database design

## Công nghệ sử dụng
- **Ngôn ngữ**: C#
- **Framework**: ASP.NET Web Forms (.NET Framework 4.5)
- **Cơ sở dữ liệu**: SQL Server (sử dụng LINQ to SQL)
- **Máy chủ**: IIS Express

## Hướng dẫn cài đặt và chạy hệ thống

### 1. Yêu cầu hệ thống
- Hệ điều hành Windows.
- **Visual Studio** (khuyên dùng VS 2013, 2015, 2017 hoặc mới hơn).
- **SQL Server Express** (Mặc định cấu hình là `.\SQLEXPRESS`).
- **.NET Framework 4.5** trở lên.

### 2. Cấu hình Cơ sở dữ liệu
Hệ thống sử dụng tệp cơ sở dữ liệu `BANSACH.mdf` nằm trong thư mục `database`.
Để hệ thống hoạt động, bạn cần:
1. Mở **SQL Server Management Studio (SSMS)**.
2. Kết nối tới instance `.\SQLEXPRESS`.
3. Nhấp chuột phải vào **Databases** -> **Attach...**
4. Chọn tệp `database/BANSACH.mdf` để gắn vào máy chủ SQL.

*Lưu ý: Nếu bạn sử dụng instance tên khác, hãy cập nhật lại chuỗi kết nối trong tệp `BanSachTest/Web.config`.*

### 3. Cách chạy ứng dụng

#### Cách 1: Sử dụng Visual Studio (Khuyên dùng)
1. Mở tệp `BanSachTest.sln` bằng Visual Studio.
2. Nhấn phím **F5** hoặc nút **Start** để biên dịch và chạy ứng dụng trên trình duyệt mặc định.

#### Cách 2: Sử dụng IIS Express (Nếu không có Visual Studio)
Nếu bạn chỉ muốn xem trang web mà không có Visual Studio, bạn có thể sử dụng công cụ IIS Express đi kèm trong thư mục `tools`:
1. Mở Terminal hoặc Command Prompt tại thư mục gốc của dự án.
2. Chạy lệnh sau:
   ```cmd
   .\tools\IISExpress\"IIS Express"\iisexpress.exe /path:%cd%\BanSachTest /port:51234
   ```
3. Mở trình duyệt và truy cập: `http://localhost:51234/TrangChu.aspx`

## Cấu trúc thư mục chính
- `BanSachTest/`: Chứa mã nguồn của ứng dụng web (.aspx, .aspx.cs).
- `database/`: Chứa tệp cơ sở dữ liệu SQL Server.
- `tools/`: Chứa bộ chạy IIS Express di động.
- `index.html`: Trang tĩnh (có thể dùng để giới thiệu hoặc test nhanh giao diện).
