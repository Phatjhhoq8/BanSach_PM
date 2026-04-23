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
