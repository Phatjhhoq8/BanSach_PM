IF DB_ID(N'BanSachPremium') IS NULL
BEGIN
    CREATE DATABASE BanSachPremium;
END
GO

USE BanSachPremium;
GO

IF OBJECT_ID(N'dbo.AdminUser', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.AdminUser (
        Username VARCHAR(50) NOT NULL PRIMARY KEY,
        Password VARCHAR(255) NOT NULL,
        FullName NVARCHAR(100) NOT NULL,
        Role NVARCHAR(50) NOT NULL CONSTRAINT DF_AdminUser_Role DEFAULT N'Admin'
    );
END
GO

IF OBJECT_ID(N'dbo.DanhMuc', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DanhMuc (
        MaDM INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        TenDM NVARCHAR(100) NOT NULL,
        TrangThai BIT NOT NULL CONSTRAINT DF_DanhMuc_TrangThai DEFAULT 1
    );
END
GO

IF OBJECT_ID(N'dbo.KhuyenMai', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.KhuyenMai (
        MaKM VARCHAR(50) NOT NULL PRIMARY KEY,
        PhanTramGiam INT NOT NULL CONSTRAINT DF_KhuyenMai_PhanTramGiam DEFAULT 0,
        GiaTriGiam DECIMAL(18, 2) NOT NULL CONSTRAINT DF_KhuyenMai_GiaTriGiam DEFAULT 0,
        NgayBatDau DATETIME NULL,
        NgayKetThuc DATETIME NULL,
        SoLuong INT NOT NULL CONSTRAINT DF_KhuyenMai_SoLuong DEFAULT 100,
        DieuKien DECIMAL(18, 2) NOT NULL CONSTRAINT DF_KhuyenMai_DieuKien DEFAULT 0
    );
END
GO

IF OBJECT_ID(N'dbo.SanPham', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SanPham (
        MaSP INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        Slug NVARCHAR(255) NULL,
        TenSP NVARCHAR(255) NOT NULL,
        TacGia NVARCHAR(255) NULL,
        MoTa NVARCHAR(MAX) NULL,
        Gia DECIMAL(18, 2) NOT NULL,
        GiaKhuyenMai DECIMAL(18, 2) NULL,
        PhanTramGiam INT NULL,
        SoLuongTon INT NOT NULL CONSTRAINT DF_SanPham_SoLuongTon DEFAULT 0,
        HinhAnh NVARCHAR(500) NULL,
        LoaiBia NVARCHAR(100) NULL,
        SoTrang INT NULL,
        NhaXuatBan NVARCHAR(255) NULL,
        NhaCungCap NVARCHAR(255) NULL,
        DanhGia DECIMAL(4, 2) NULL,
        NguonUrl NVARCHAR(500) NULL,
        NguonDuLieu NVARCHAR(50) NULL,
        NgayXuatBan DATE NULL,
        MaDM INT NOT NULL,
        TrangThai BIT NOT NULL CONSTRAINT DF_SanPham_TrangThai DEFAULT 1,
        CONSTRAINT FK_SanPham_DanhMuc FOREIGN KEY (MaDM) REFERENCES dbo.DanhMuc(MaDM)
    );
END
GO

ALTER TABLE dbo.SanPham ALTER COLUMN TenSP NVARCHAR(255) NOT NULL;
GO
ALTER TABLE dbo.SanPham ALTER COLUMN TacGia NVARCHAR(255) NULL;
GO
ALTER TABLE dbo.SanPham ALTER COLUMN HinhAnh NVARCHAR(500) NULL;
GO
ALTER TABLE dbo.SanPham ALTER COLUMN LoaiBia NVARCHAR(100) NULL;
GO
ALTER TABLE dbo.SanPham ALTER COLUMN NhaXuatBan NVARCHAR(255) NULL;
GO

IF COL_LENGTH(N'dbo.SanPham', N'Slug') IS NULL
BEGIN
    ALTER TABLE dbo.SanPham ADD Slug NVARCHAR(255) NULL;
END
GO

IF COL_LENGTH(N'dbo.SanPham', N'PhanTramGiam') IS NULL
BEGIN
    ALTER TABLE dbo.SanPham ADD PhanTramGiam INT NULL;
END
GO

IF COL_LENGTH(N'dbo.SanPham', N'NhaCungCap') IS NULL
BEGIN
    ALTER TABLE dbo.SanPham ADD NhaCungCap NVARCHAR(255) NULL;
END
GO

IF COL_LENGTH(N'dbo.SanPham', N'DanhGia') IS NULL
BEGIN
    ALTER TABLE dbo.SanPham ADD DanhGia DECIMAL(4, 2) NULL;
END
GO

IF COL_LENGTH(N'dbo.SanPham', N'NguonUrl') IS NULL
BEGIN
    ALTER TABLE dbo.SanPham ADD NguonUrl NVARCHAR(500) NULL;
END
GO

IF COL_LENGTH(N'dbo.SanPham', N'NguonDuLieu') IS NULL
BEGIN
    ALTER TABLE dbo.SanPham ADD NguonDuLieu NVARCHAR(50) NULL;
END
GO

IF OBJECT_ID(N'dbo.KhachHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.KhachHang (
        MaKH INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        HoTen NVARCHAR(100) NOT NULL,
        Email VARCHAR(100) NOT NULL UNIQUE,
        MatKhau VARCHAR(255) NOT NULL,
        SoDienThoai VARCHAR(20) NULL,
        DiaChi NVARCHAR(255) NULL,
        NgayDangKy DATETIME NOT NULL CONSTRAINT DF_KhachHang_NgayDangKy DEFAULT GETDATE()
    );
END
GO

IF OBJECT_ID(N'dbo.GioHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.GioHang (
        MaKH INT NOT NULL PRIMARY KEY,
        NgayCapNhat DATETIME NOT NULL CONSTRAINT DF_GioHang_NgayCapNhat DEFAULT GETDATE(),
        CONSTRAINT FK_GioHang_KhachHang FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH)
    );
END
GO

IF OBJECT_ID(N'dbo.ChiTietGioHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChiTietGioHang (
        MaKH INT NOT NULL,
        MaSP INT NOT NULL,
        SoLuong INT NOT NULL CONSTRAINT DF_ChiTietGioHang_SoLuong DEFAULT 1,
        CONSTRAINT PK_ChiTietGioHang PRIMARY KEY (MaKH, MaSP),
        CONSTRAINT FK_ChiTietGioHang_GioHang FOREIGN KEY (MaKH) REFERENCES dbo.GioHang(MaKH),
        CONSTRAINT FK_ChiTietGioHang_SanPham FOREIGN KEY (MaSP) REFERENCES dbo.SanPham(MaSP)
    );
END
GO

IF OBJECT_ID(N'dbo.DonHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.DonHang (
        MaDH INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        MaKH INT NOT NULL,
        NgayDat DATETIME NOT NULL CONSTRAINT DF_DonHang_NgayDat DEFAULT GETDATE(),
        TamTinh DECIMAL(18, 2) NOT NULL CONSTRAINT DF_DonHang_TamTinh DEFAULT 0,
        PhiVanChuyen DECIMAL(18, 2) NOT NULL CONSTRAINT DF_DonHang_PhiVanChuyen DEFAULT 0,
        GiamGia DECIMAL(18, 2) NOT NULL CONSTRAINT DF_DonHang_GiamGia DEFAULT 0,
        TongTien DECIMAL(18, 2) NOT NULL,
        MaKM VARCHAR(50) NULL,
        DiaChiGiaoHang NVARCHAR(255) NULL,
        SoDienThoaiGiao VARCHAR(20) NULL,
        GhiChu NVARCHAR(500) NULL,
        TrangThai INT NOT NULL CONSTRAINT DF_DonHang_TrangThai DEFAULT 0,
        HinhThucThanhToan NVARCHAR(50) NOT NULL CONSTRAINT DF_DonHang_HinhThucThanhToan DEFAULT N'COD',
        CONSTRAINT FK_DonHang_KhachHang FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
        CONSTRAINT FK_DonHang_KhuyenMai FOREIGN KEY (MaKM) REFERENCES dbo.KhuyenMai(MaKM)
    );
END
GO

IF OBJECT_ID(N'dbo.ChiTietDonHang', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.ChiTietDonHang (
        MaDH INT NOT NULL,
        MaSP INT NOT NULL,
        SoLuong INT NOT NULL,
        DonGia DECIMAL(18, 2) NOT NULL,
        CONSTRAINT PK_ChiTietDonHang PRIMARY KEY (MaDH, MaSP),
        CONSTRAINT FK_ChiTietDonHang_DonHang FOREIGN KEY (MaDH) REFERENCES dbo.DonHang(MaDH),
        CONSTRAINT FK_ChiTietDonHang_SanPham FOREIGN KEY (MaSP) REFERENCES dbo.SanPham(MaSP)
    );
END
GO

IF OBJECT_ID(N'dbo.SanPhamHinhAnh', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.SanPhamHinhAnh (
        MaAnh INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        MaSP INT NOT NULL,
        UrlAnh NVARCHAR(500) NOT NULL,
        ThuTu INT NOT NULL CONSTRAINT DF_SanPhamHinhAnh_ThuTu DEFAULT 0,
        CONSTRAINT FK_SanPhamHinhAnh_SanPham FOREIGN KEY (MaSP) REFERENCES dbo.SanPham(MaSP)
    );
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'UX_SanPham_Slug'
      AND object_id = OBJECT_ID(N'dbo.SanPham')
)
BEGIN
    CREATE UNIQUE INDEX UX_SanPham_Slug ON dbo.SanPham (Slug) WHERE Slug IS NOT NULL;
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_SanPham_NguonDuLieu_TrangThai'
      AND object_id = OBJECT_ID(N'dbo.SanPham')
)
BEGIN
    CREATE INDEX IX_SanPham_NguonDuLieu_TrangThai ON dbo.SanPham (NguonDuLieu, TrangThai, MaSP DESC);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = N'IX_SanPhamHinhAnh_MaSP_ThuTu'
      AND object_id = OBJECT_ID(N'dbo.SanPhamHinhAnh')
)
BEGIN
    CREATE INDEX IX_SanPhamHinhAnh_MaSP_ThuTu ON dbo.SanPhamHinhAnh (MaSP, ThuTu);
END
GO

IF COL_LENGTH(N'dbo.DonHang', N'TamTinh') IS NULL
BEGIN
    ALTER TABLE dbo.DonHang ADD TamTinh DECIMAL(18, 2) NOT NULL CONSTRAINT DF_DonHang_TamTinh_Late DEFAULT 0;
END
GO

IF COL_LENGTH(N'dbo.DonHang', N'PhiVanChuyen') IS NULL
BEGIN
    ALTER TABLE dbo.DonHang ADD PhiVanChuyen DECIMAL(18, 2) NOT NULL CONSTRAINT DF_DonHang_PhiVanChuyen_Late DEFAULT 0;
END
GO

IF COL_LENGTH(N'dbo.DonHang', N'GiamGia') IS NULL
BEGIN
    ALTER TABLE dbo.DonHang ADD GiamGia DECIMAL(18, 2) NOT NULL CONSTRAINT DF_DonHang_GiamGia_Late DEFAULT 0;
END
GO

UPDATE dh
SET TamTinh = summary.TamTinh
FROM dbo.DonHang dh
INNER JOIN (
    SELECT MaDH, SUM(SoLuong * DonGia) AS TamTinh
    FROM dbo.ChiTietDonHang
    GROUP BY MaDH
) summary ON summary.MaDH = dh.MaDH
WHERE dh.TamTinh = 0;
GO

IF OBJECT_ID(N'dbo.YeuThich', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.YeuThich (
        MaKH INT NOT NULL,
        MaSP INT NOT NULL,
        NgayThem DATETIME NOT NULL CONSTRAINT DF_YeuThich_NgayThem DEFAULT GETDATE(),
        CONSTRAINT PK_YeuThich PRIMARY KEY (MaKH, MaSP),
        CONSTRAINT FK_YeuThich_KhachHang FOREIGN KEY (MaKH) REFERENCES dbo.KhachHang(MaKH),
        CONSTRAINT FK_YeuThich_SanPham FOREIGN KEY (MaSP) REFERENCES dbo.SanPham(MaSP)
    );
END
GO

IF OBJECT_ID(N'dbo.TinTuc', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.TinTuc (
        MaTin INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        TieuDe NVARCHAR(255) NOT NULL,
        Slug NVARCHAR(255) NULL,
        TomTat NVARCHAR(500) NULL,
        NoiDung NVARCHAR(MAX) NULL,
        HinhAnh NVARCHAR(500) NULL,
        ChuyenMuc NVARCHAR(100) NULL,
        NgayDang DATETIME NOT NULL CONSTRAINT DF_TinTuc_NgayDang DEFAULT GETDATE(),
        TrangThai BIT NOT NULL CONSTRAINT DF_TinTuc_TrangThai DEFAULT 1
    );
END
GO

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes WHERE name = N'UX_TinTuc_Slug' AND object_id = OBJECT_ID(N'dbo.TinTuc')
)
BEGIN
    CREATE UNIQUE INDEX UX_TinTuc_Slug ON dbo.TinTuc (Slug) WHERE Slug IS NOT NULL;
END
GO

IF OBJECT_ID(N'dbo.FAQ', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.FAQ (
        MaFAQ INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
        CauHoi NVARCHAR(255) NOT NULL,
        TraLoi NVARCHAR(MAX) NOT NULL,
        Nhom NVARCHAR(100) NULL,
        ThuTu INT NOT NULL CONSTRAINT DF_FAQ_ThuTu DEFAULT 0,
        TrangThai BIT NOT NULL CONSTRAINT DF_FAQ_TrangThai DEFAULT 1
    );
END
GO

IF OBJECT_ID(N'dbo.CaiDat', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.CaiDat (
        [Key] VARCHAR(100) NOT NULL PRIMARY KEY,
        [Value] NVARCHAR(MAX) NULL,
        MoTa NVARCHAR(255) NULL
    );
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.AdminUser WHERE Username = 'admin')
BEGIN
    INSERT INTO dbo.AdminUser (Username, Password, FullName, Role)
    VALUES ('admin', '123456', N'Quản trị viên', N'Admin');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DanhMuc WHERE TenDM = N'Văn học')
BEGIN
    INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (N'Văn học', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DanhMuc WHERE TenDM = N'Kỹ năng sống')
BEGIN
    INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (N'Kỹ năng sống', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DanhMuc WHERE TenDM = N'Kinh tế')
BEGIN
    INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (N'Kinh tế', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DanhMuc WHERE TenDM = N'Công nghệ thông tin')
BEGIN
    INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (N'Công nghệ thông tin', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.DanhMuc WHERE TenDM = N'Thiếu nhi')
BEGIN
    INSERT INTO dbo.DanhMuc (TenDM, TrangThai) VALUES (N'Thiếu nhi', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.KhuyenMai WHERE MaKM = 'SALE10')
BEGIN
    INSERT INTO dbo.KhuyenMai (MaKM, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, SoLuong, DieuKien)
    VALUES ('SALE10', 10, 0, GETDATE(), DATEADD(DAY, 30, GETDATE()), 100, 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.KhuyenMai WHERE MaKM = 'FREESHIP')
BEGIN
    INSERT INTO dbo.KhuyenMai (MaKM, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, SoLuong, DieuKien)
    VALUES ('FREESHIP', 0, 30000, GETDATE(), DATEADD(DAY, 30, GETDATE()), 100, 0);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.KhachHang WHERE Email = 'user@gmail.com')
BEGIN
    INSERT INTO dbo.KhachHang (HoTen, Email, MatKhau, SoDienThoai)
    VALUES (N'Nguyễn Văn Trăm', 'user@gmail.com', '123456', '0901234567');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CaiDat WHERE [Key] = 'StoreName')
BEGIN
    INSERT INTO dbo.CaiDat ([Key], [Value], MoTa) VALUES ('StoreName', N'Premium Books', N'Tên cửa hàng hiển thị');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CaiDat WHERE [Key] = 'SupportEmail')
BEGIN
    INSERT INTO dbo.CaiDat ([Key], [Value], MoTa) VALUES ('SupportEmail', N'cskh@premiumbooks.vn', N'Email hỗ trợ khách hàng');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CaiDat WHERE [Key] = 'Hotline')
BEGIN
    INSERT INTO dbo.CaiDat ([Key], [Value], MoTa) VALUES ('Hotline', N'1900 123456', N'Hotline hỗ trợ');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CaiDat WHERE [Key] = 'StoreAddress')
BEGIN
    INSERT INTO dbo.CaiDat ([Key], [Value], MoTa) VALUES ('StoreAddress', N'123, DNC', N'Địa chỉ cửa hàng');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.CaiDat WHERE [Key] = 'ShippingFee')
BEGIN
    INSERT INTO dbo.CaiDat ([Key], [Value], MoTa) VALUES ('ShippingFee', N'30000', N'Phí vận chuyển mặc định');
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.TinTuc)
BEGIN
    INSERT INTO dbo.TinTuc (TieuDe, Slug, TomTat, NoiDung, ChuyenMuc, TrangThai)
    VALUES
    (N'10 cuốn sách nên đọc khi bắt đầu xây thói quen đọc', N'10-cuon-sach-nen-doc', N'Danh sách cân bằng giữa tư duy, kỹ năng sống và văn học dễ tiếp cận.', N'Hãy bắt đầu bằng một câu hỏi rõ: bạn muốn giải trí, học kỹ năng, hiểu bản thân hay tìm kiến thức chuyên môn? Khi mua online, hãy xem mô tả, tác giả, nhà xuất bản, đánh giá và ảnh bìa. Premium Books sẽ tiếp tục cập nhật các danh sách gợi ý đọc sách theo chủ đề để người dùng khám phá nhanh hơn.', N'Top list', 1),
    (N'Cách chọn sách kỹ năng sống không bị lan man', N'chon-sach-ky-nang-song', N'Ưu tiên vấn đề bạn đang gặp, tác giả có nền tảng rõ và nội dung có bài tập thực hành.', N'Một cuốn sách kỹ năng tốt nên giải quyết đúng vấn đề hiện tại của bạn. Hãy đọc mục lục, phần giới thiệu và một vài đánh giá trước khi mua. Nội dung có ví dụ thực tế và bài tập áp dụng thường hữu ích hơn những lời khuyên chung chung.', N'Review', 1),
    (N'Bảo quản sách giấy trong mùa ẩm', N'bao-quan-sach-giay', N'Những thói quen nhỏ giúp sách giữ phom, không cong gáy và hạn chế ố giấy.', N'Đặt sách ở nơi khô thoáng, tránh ánh nắng trực tiếp và không ép sách sát tường ẩm. Có thể dùng túi hút ẩm trong kệ sách và vệ sinh bụi định kỳ để giữ giấy bền màu hơn.', N'Hướng dẫn', 1);
END
GO

IF NOT EXISTS (SELECT 1 FROM dbo.FAQ)
BEGIN
    INSERT INTO dbo.FAQ (CauHoi, TraLoi, Nhom, ThuTu, TrangThai)
    VALUES
    (N'Đổi trả và hoàn tiền như thế nào?', N'Sản phẩm lỗi in ấn, giao sai tựa hoặc hư hỏng trong vận chuyển được hỗ trợ đổi trả trong 7 ngày kể từ khi nhận hàng.', N'Đổi trả', 1, 1),
    (N'Thời gian vận chuyển bao lâu?', N'Phí vận chuyển mặc định 30.000đ cho đơn thường. Thời gian giao dự kiến 2-5 ngày làm việc tùy khu vực.', N'Vận chuyển', 2, 1),
    (N'Hệ thống hỗ trợ thanh toán nào?', N'Hệ thống hiện hỗ trợ COD. Các phương thức chuyển khoản và ví điện tử được thiết kế sẵn để cấu hình mở rộng.', N'Thanh toán', 3, 1),
    (N'Liên hệ hỗ trợ ở đâu?', N'Bạn có thể liên hệ qua email cskh@premiumbooks.vn hoặc hotline 1900 123456 trong giờ hành chính.', N'Hỗ trợ', 4, 1);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM dbo.GioHang gh
    INNER JOIN dbo.KhachHang kh ON kh.MaKH = gh.MaKH
    WHERE kh.Email = 'user@gmail.com'
)
BEGIN
    INSERT INTO dbo.GioHang (MaKH)
    SELECT TOP 1 MaKH
    FROM dbo.KhachHang
    WHERE Email = 'user@gmail.com';
END
GO
