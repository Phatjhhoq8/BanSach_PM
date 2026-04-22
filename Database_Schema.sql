-- Khởi tạo Database nếu chưa có
IF NOT EXISTS (SELECT name FROM master.dbo.sysdatabases WHERE name = N'BanSachPremium')
BEGIN
    CREATE DATABASE BanSachPremium;
END
GO

USE BanSachPremium;
GO

-- 1. Bảng AdminUser
CREATE TABLE AdminUser (
    Username VARCHAR(50) PRIMARY KEY,
    Password VARCHAR(255) NOT NULL,
    FullName NVARCHAR(100) NOT NULL,
    Role NVARCHAR(50) DEFAULT 'Admin'
);

-- 2. Bảng DanhMuc (Danh mục sách)
CREATE TABLE DanhMuc (
    MaDM INT IDENTITY(1,1) PRIMARY KEY,
    TenDM NVARCHAR(100) NOT NULL,
    TrangThai BIT DEFAULT 1
);

-- 3. Bảng KhuyenMai (Mã giảm giá)
CREATE TABLE KhuyenMai (
    MaKM VARCHAR(50) PRIMARY KEY,
    PhanTramGiam INT DEFAULT 0,
    GiaTriGiam DECIMAL(18, 2) DEFAULT 0,
    NgayBatDau DATETIME,
    NgayKetThuc DATETIME,
    SoLuong INT DEFAULT 100,
    DieuKien DECIMAL(18,2) DEFAULT 0
);

-- 4. Bảng SanPham (Sách)
CREATE TABLE SanPham (
    MaSP INT IDENTITY(1,1) PRIMARY KEY,
    TenSP NVARCHAR(255) NOT NULL,
    TacGia NVARCHAR(100),
    MoTa NVARCHAR(MAX),
    Gia DECIMAL(18, 2) NOT NULL,
    GiaKhuyenMai DECIMAL(18, 2), -- Giá sau khi giảm mặc định nếu có
    SoLuongTon INT DEFAULT 0,
    HinhAnh VARCHAR(255),
    LoaiBia NVARCHAR(50), -- Bìa cứng, Bìa mềm
    SoTrang INT,
    NhaXuatBan NVARCHAR(100),
    NgayXuatBan DATE,
    MaDM INT NOT NULL,
    TrangThai BIT DEFAULT 1,
    FOREIGN KEY (MaDM) REFERENCES DanhMuc(MaDM)
);

-- 5. Bảng KhachHang
CREATE TABLE KhachHang (
    MaKH INT IDENTITY(1,1) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    SoDienThoai VARCHAR(20),
    DiaChi NVARCHAR(255),
    NgayDangKy DATETIME DEFAULT GETDATE()
);

-- 6. Bảng GioHang (Mỗi Khách Hàng 1 giỏ hàng duy nhất đang active)
-- Thực chất ta chỉ cần ChiTietGioHang map trực tiếp MaKH là đủ, nhưng làm 1 bảng GioHang để dễ quản lý Session
CREATE TABLE GioHang (
    MaKH INT PRIMARY KEY,
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- 7. Bảng ChiTietGioHang
CREATE TABLE ChiTietGioHang (
    MaKH INT,
    MaSP INT,
    SoLuong INT NOT NULL DEFAULT 1,
    PRIMARY KEY (MaKH, MaSP),
    FOREIGN KEY (MaKH) REFERENCES GioHang(MaKH),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- 8. Bảng DonHang
CREATE TABLE DonHang (
    MaDH INT IDENTITY(1,1) PRIMARY KEY,
    MaKH INT NOT NULL,
    NgayDat DATETIME DEFAULT GETDATE(),
    TongTien DECIMAL(18, 2) NOT NULL,
    MaKM VARCHAR(50) NULL,
    DiaChiGiaoHang NVARCHAR(255),
    SoDienThoaiGiao VARCHAR(20),
    GhiChu NVARCHAR(500),
    TrangThai INT DEFAULT 0, -- 0: Chờ xác nhận, 1: Đang giao, 2: Hoàn thành, 3: Đã hủy
    HinhThucThanhToan NVARCHAR(50) DEFAULT 'COD',
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH),
    FOREIGN KEY (MaKM) REFERENCES KhuyenMai(MaKM)
);

-- 9. Bảng ChiTietDonHang
CREATE TABLE ChiTietDonHang (
    MaDH INT,
    MaSP INT,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18, 2) NOT NULL, -- Lưu giá tại thời điểm đặt
    PRIMARY KEY (MaDH, MaSP),
    FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- THÊM DỮ LIỆU MẪU (Mock Data)
INSERT INTO AdminUser (Username, Password, FullName) VALUES ('admin', '123456', N'Quản trị viên');

INSERT INTO DanhMuc (TenDM) VALUES 
(N'Văn học'), 
(N'Kỹ năng sống'), 
(N'Kinh tế'), 
(N'Công nghệ thông tin');

INSERT INTO KhuyenMai (MaKM, PhanTramGiam, GiaTriGiam, NgayBatDau, NgayKetThuc, SoLuong) VALUES 
('SALE10', 10, 0, GETDATE(), DATEADD(day, 30, GETDATE()), 100),
('FREESHIP', 0, 30000, GETDATE(), DATEADD(day, 30, GETDATE()), 100);

INSERT INTO SanPham (TenSP, TacGia, MoTa, Gia, SoLuongTon, HinhAnh, LoaiBia, MaDM) VALUES
(N'Dế Mèn Phiêu Lưu Ký', N'Tô Hoài', N'Tác phẩm thiếu nhi kinh điển', 45000, 100, 'demen.jpg', N'Bìa mềm', 1),
(N'Đắc Nhân Tâm', N'Dale Carnegie', N'Sách kỹ năng giao tiếp', 89000, 50, 'dacnhantam.jpg', N'Bìa cứng', 2),
(N'Tư Duy Nhanh Và Chậm', N'Daniel Kahneman', N'Tìm hiểu về tư duy con người', 250000, 20, 'tuduynhanhvacham.jpg', N'Bìa cứng', 3),
(N'Clean Code', N'Robert C. Martin', N'Kỹ thuật viết code gọn nhẹ, dễ bảo trì', 450000, 10, 'cleancode.jpg', N'Bìa mềm', 4);

INSERT INTO KhachHang (HoTen, Email, MatKhau, SoDienThoai) VALUES 
(N'Nguyễn Văn Trăm', 'user@gmail.com', '123456', '0901234567');

INSERT INTO GioHang (MaKH) VALUES (1);
