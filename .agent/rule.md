# QUY TẮC DỰ ÁN (PROJECT RULES) - HỆ THỐNG BÁN SÁCH PREMIUM UI/UX

## 1. VAI TRÒ CỦA AI (AI ROLE)
Bạn là một Full-stack Senior Developer chuyên nghiệp. Nhiệm vụ của bạn là xây dựng hệ thống e-commerce bán sách với UI/UX mang tầm cỡ quốc tế nhưng phải bám sát cấu trúc công nghệ cốt lõi được định nghĩa trong luồng dự án.

## 2. STACK CÔNG NGHỆ (TECH STACK)
* **Frontend:** HTML, CSS, Tailwind CSS, JavaScript.
* **Backend:** ASP.NET Web Forms (.NET Framework 4.5 C#). Đảm bảo tuân thủ nghiêm ngặt kỹ thuật Code-Behind của Web Forms, sử dụng MasterPages cho layout dùng chung.
* **Cơ sở dữ liệu:** SQL Server.
* **Truy cập dữ liệu:** LINQ to SQL.
* **Công cụ & Môi trường:**
  - IDE: Microsoft Visual Studio (2013 hoặc mới hơn).
  - Web Server: IIS Express (Được tích hợp sẵn trong thư mục tools).
  - Quản lý CSDL: SQL Server Management Studio (SSMS).

## 3. NGÔN NGỮ THIẾT KẾ & UI/UX (DESIGN GUIDELINES)
* **Màu chủ đạo:** Nâu Classic (Classic Brown) cho tổng thể, Đen Universe cho Footer.
* **Trang chủ (Hero & Banner):** Lấy ý tưởng banner từ [cachep.vn]. Sử dụng Video Banner Hero từ các nguồn: [Link 1](https://www.youtube.com/watch?v=6Fp9KofWq9I) và [Link 2](https://www.youtube.com/watch?v=pGkPOcnEuSE).
* **Cấu trúc web & luồng Sale:** Lấy cảm hứng từ [Fahasa.com](https://www.fahasa.com/).
* **Trang chi tiết sản phẩm:** Giao diện chi tiết như quyền sách 3D từ [Stripe Press](https://press.stripe.com/maintenance-part-one).
* **Footer:** Lấy cảm hứng thiết kế tối giản, công nghệ từ [Nothing.tech](https://nothing.tech/).

## 4. QUY TẮC CẤU TRÚC TÍNH NĂNG (CORE FEATURES)

### 4.1. Client-side (Trang người dùng)
* **Trang chủ (Home):** Banner khuyến mãi, sách mới/bán chạy, danh mục nổi bật, video banner hero.
* **Danh mục/Tìm kiếm:** Bộ lọc thông minh (theo thể loại, tác giả, giá, độ tuổi), tìm kiếm theo từ khóa.
* **Chi tiết sách:** Hiển thị thông tin đầy đủ, đánh giá, xem trước vài trang, liên kết sách cùng tác giả. Khớp chuẩn UI Stripe Press (hiệu ứng 3D).
* **Giỏ hàng (Cart):** Cập nhật số lượng, tính tổng tiền, giảm giá, tính phí vận chuyển tạm tính.
* **Thanh toán (Checkout):** Tích hợp nhiều phương thức thanh toán, lưu thông tin giao hàng.
* **Tài khoản cá nhân:** Quản lý đơn hàng, theo dõi trạng thái giao hàng, danh sách yêu thích.
* **Blog/Tin tức:** Chia sẻ bài cảm nhận, review sách, danh sách "Top 10 sách nên đọc".
* **Chăm sóc khách hàng:** FAQ, thông tin liên hệ hỗ trợ.

### 4.2. Admin-side (Trang quản trị)
* **Dashboard:** Tổng quan doanh thu, số đơn hàng mới, sách sắp hết kho, biểu đồ tăng trưởng.
* **Quản lý Sản phẩm:** Thêm/sửa/xóa sách, quản lý tồn kho, thiết lập thuộc tính (bìa cứng/mềm, định dạng).
* **Quản lý Đơn hàng:** Cập nhật trạng thái (chờ xác nhận, đang đóng gói, vận chuyển, hoàn thành), xử lý đổi trả.
* **Quản lý Khách hàng:** Xem lịch sử mua hàng, quản lý cấp độ thành viên, gửi thông báo/email marketing.
* **Quản lý Khuyến mãi:** Tạo mã giảm giá, combo sách.
* **Phân tích (Analytics):** Báo cáo doanh thu theo thời gian, sản phẩm bán chạy nhất, tỷ lệ khách hàng quay lại.
* **Cấu hình hệ thống:** Thiết lập phương thức thanh toán, đơn vị vận chuyển.

## 5. QUY TẮC CODE (CODING STANDARDS)
* **Frontend & UX:** Tận dụng utility classes của Tailwind CSS. Khai thác sức mạnh JavaScript thuần để tạo hiệu ứng 3D và DOM manipulation mượt mà thay vì phụ thuộc quá nhiều vào Web Forms postbacks.
* **Backend:** Do sử dụng ASP.NET Web Forms, cần tách biệt logic tầng Data Access (LINQ to SQL) và logic giao diện ở Code-Behind để code dễ bảo trì.
* **Giao tiếp Client-Server:** Ưu tiên dùng WebMethods (`[WebMethod]`) hoặc Generic Handlers (`.ashx`) kết hợp `Fetch API`/`AJAX` cho các tác vụ như thêm giỏ hàng, lọc tìm kiếm để trách Reload toàn trang (Postback) gây ảnh hưởng đến trải nghiệm Web hiện đại.
* **Bình luận & Git:** Viết comment rõ ràng đặc biệt ở xử lý giao hàng/giảm giá và xử lý UI 3D.