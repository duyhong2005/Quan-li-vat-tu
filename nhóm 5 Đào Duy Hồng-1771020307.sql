USE master;
GO
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QLVATTU')
    DROP DATABASE QLVATTU;
GO

-- Tạo cơ sở dữ liệu
CREATE DATABASE QLVATTU;
GO
USE QLVATTU;
GO

-- Tạo bảng Khách hàng
CREATE TABLE KHACHHANG (
    MaKhachHang INT PRIMARY KEY,
    TenKhachHang NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    DienThoai NVARCHAR(15) UNIQUE,
    Email NVARCHAR(100) UNIQUE
);
GO

-- Tạo bảng Nhà cung cấp
CREATE TABLE NHACUNGCAP (
    MaNCC INT PRIMARY KEY,
    TenNCC NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(200),
    DienThoai NVARCHAR(15) UNIQUE
);
GO

-- Tạo bảng Vật tư
CREATE TABLE VATTU (
    MaVatTu INT PRIMARY KEY,
    TenVatTu NVARCHAR(100) NOT NULL,
    DonViTinh NVARCHAR(50) NOT NULL,
    GiaMua DECIMAL(18,2) CHECK (GiaMua >= 0) NOT NULL,
    SoLuongTon INT CHECK (SoLuongTon >= 0) DEFAULT 0 NOT NULL
);
GO

-- Chèn dữ liệu vào bảng VATTU
INSERT INTO VATTU (MaVatTu, TenVatTu, DonViTinh, GiaMua, SoLuongTon)
VALUES
(231, N'Xi măng', N'Bao', 50000, 100),
(472, N'Gạch đỏ', N'Viên', 4000, 5000),
(389, N'Cát vàng', N'Khối', 350000, 200),
(514, N'Sắt phi 12', N'Cây', 60000, 300),
(628, N'Thép hộp', N'Mét', 70000, 250),
(756, N'Sơn nước', N'Lit', 45000, 150),
(821, N'Gỗ công nghiệp', N'Tấm', 55000, 180),
(943, N'Gạch men', N'M2', 30000, 400),
(127, N'Đá 1x2', N'Khối', 320000, 220),
(398, N'Ống nước PVC', N'Mét', 28000, 600),
(564, N'Ván ép', N'Tấm', 51000, 120),
(682, N'Tôn lạnh', N'M2', 42000, 170),
(775, N'Cửa nhôm kính', N'Bộ', 3600000, 30),
(846, N'Bulong ốc vít', N'Bộ', 61000, 1000),
(923, N'Keo dán gạch', N'Túi', 71000, 90),
(158, N'Bột trét tường', N'Bao', 46000, 300),
(294, N'Dây điện', N'Mét', 56000, 500),
(339, N'Công tắc điện', N'Cái', 31000, 200),
(487, N'Bóng đèn LED', N'Cái', 33000, 250),
(512, N'Máy khoan', N'Cái', 2900000, 50);
GO


-- Tạo bảng Phiếu nhập
CREATE TABLE PHIEUNHAP (
    MaPN INT PRIMARY KEY,
    NgayNhap DATE DEFAULT GETDATE(),
    MaNCC INT,
    FOREIGN KEY (MaNCC) REFERENCES NHACUNGCAP(MaNCC)
);
GO

-- Tạo bảng Hóa đơn
CREATE TABLE HOADON (
    MaHoaDon INT PRIMARY KEY,
    Ngay DATE DEFAULT GETDATE(),
    MaKhachHang INT,
    FOREIGN KEY (MaKhachHang) REFERENCES KHACHHANG(MaKhachHang)
);
GO

-- Tạo bảng Phiếu xuất
CREATE TABLE PHIEUXUAT (
    MaPX INT PRIMARY KEY,
    NgayXuat DATE DEFAULT GETDATE()
);
GO

-- Tạo bảng Chi tiết phiếu nhập
CREATE TABLE CHITIETPHIEUNHAP (
    MaPN INT,
    MaVatTu INT,
    SoLuongNhap INT CHECK (SoLuongNhap > 0),
    DonGiaNhap DECIMAL(18,2) CHECK (DonGiaNhap >= 0),
    PRIMARY KEY (MaPN, MaVatTu),
    FOREIGN KEY (MaPN) REFERENCES PHIEUNHAP(MaPN) ON DELETE CASCADE,
    FOREIGN KEY (MaVatTu) REFERENCES VATTU(MaVatTu) ON DELETE CASCADE
);
GO

-- Tạo bảng Chi tiết hóa đơn
CREATE TABLE CHITIETHOADON (
    MaHoaDon INT,
    MaVatTu INT,
    SoLuongBan INT CHECK (SoLuongBan > 0),
    GiaBan DECIMAL(18,2) CHECK (GiaBan >= 0),
    PRIMARY KEY (MaHoaDon, MaVatTu),
    FOREIGN KEY (MaHoaDon) REFERENCES HOADON(MaHoaDon) ON DELETE CASCADE,
    FOREIGN KEY (MaVatTu) REFERENCES VATTU(MaVatTu) ON DELETE CASCADE
);
GO

-- Tạo bảng Chi tiết phiếu xuất
CREATE TABLE CHITIETPHIEUXUAT (
    MaPX INT,
    MaVatTu INT,
    SoLuongXuat INT CHECK (SoLuongXuat > 0),
    DonGiaXuat DECIMAL(18,2) CHECK (DonGiaXuat >= 0), -- Thêm cột giá xuất
    PRIMARY KEY (MaPX, MaVatTu),
    FOREIGN KEY (MaPX) REFERENCES PHIEUXUAT(MaPX) ON DELETE CASCADE,
    FOREIGN KEY (MaVatTu) REFERENCES VATTU(MaVatTu) ON DELETE CASCADE
);
GO


INSERT INTO KHACHHANG (MaKhachHang, TenKhachHang, DiaChi, DienThoai, Email)
VALUES
(101, N'Nguyễn Văn An', N'123 Đường Láng, Hà Nội', '0912345678', 'an.nguyen101@gmail.com'),
(102, N'Trần Thị Bích', N'56 Nguyễn Trãi, Hà Nội', '0987654321', 'bich.tran102@gmail.com'),
(103, N'Phạm Quốc Cường', N'89 Tây Sơn, Hà Nội', '0901234567', 'cuong.pham103@gmail.com'),
(104, N'Hoàng Mai Dung', N'34 Kim Mã, Hà Nội', '0912233445', 'dung.hoang104@gmail.com'),
(105, N'Lê Văn Đạt', N'12 Cầu Giấy, Hà Nội', '0922334455', 'dat.le105@gmail.com'),
(106, N'Đỗ Thị Hạnh', N'78 Hoàng Quốc Việt, Hà Nội', '0933445566', 'hanh.do106@gmail.com'),
(107, N'Vũ Tiến Hưng', N'90 Trần Duy Hưng, Hà Nội', '0944556677', 'hung.vu107@gmail.com'),
(108, N'Nguyễn Hữu Khoa', N'45 Xuân Thủy, Hà Nội', '0955667788', 'khoa.nguyen108@gmail.com'),
(109, N'Trịnh Thị Lan', N'23 Lạc Long Quân, Hà Nội', '0966778899', 'lan.trinh109@gmail.com'),
(110, N'Bùi Văn Minh', N'67 Hai Bà Trưng, Hà Nội', '0977889900', 'minh.bui110@gmail.com'),
(111, N'Phan Thị Nga', N'11 Phạm Văn Đồng, Hà Nội', '0988990011', 'nga.phan111@gmail.com'),
(112, N'Hà Thanh Nam', N'88 Chùa Bộc, Hà Nội', '0999001122', 'nam.ha112@gmail.com'),
(113, N'Hoàng Văn Phúc', N'22 Nguyễn Chí Thanh, Hà Nội', '0911112233', 'phuc.hoang113@gmail.com'),
(114, N'Ngô Thị Quỳnh', N'33 Bà Triệu, Hà Nội', '0922223344', 'quynh.ngo114@gmail.com'),
(115, N'Tô Thành Sơn', N'55 Láng Hạ, Hà Nội', '0933334455', 'son.to115@gmail.com'),
(116, N'Dương Thị Thảo', N'99 Thái Hà, Hà Nội', '0944445566', 'thao.duong116@gmail.com'),
(117, N'Nguyễn Văn Tuấn', N'66 Hàng Bông, Hà Nội', '0955556677', 'tuan.nguyen117@gmail.com'),
(118, N'Đặng Thị Uyên', N'77 Hàng Ngang, Hà Nội', '0966667788', 'uyen.dang118@gmail.com'),
(119, N'Phùng Văn Việt', N'44 Hàng Đào, Hà Nội', '0977778899', 'viet.phung119@gmail.com'),
(120, N'Nguyễn Thị Xuân', N'11 Tràng Tiền, Hà Nội', '0988889900', 'xuan.nguyen120@gmail.com');
GO

INSERT INTO NHACUNGCAP (MaNCC, TenNCC, DiaChi, DienThoai)
VALUES
(201, N'Công ty TNHH Hòa Bình', N'101 Nguyễn Trãi, Hà Nội', '0912233445'),
(202, N'Công ty CP An Phát', N'56 Trần Duy Hưng, Hà Nội', '0923344556'),
(203, N'Công ty TNHH Minh Khang', N'88 Giảng Võ, Hà Nội', '0934455667'),
(204, N'Công ty CP Gia Hưng', N'23 Hoàng Đạo Thúy, Hà Nội', '0945566778'),
(205, N'Công ty TNHH Thịnh Vượng', N'78 Đê La Thành, Hà Nội', '0956677889'),
(206, N'Công ty CP Đại Phát', N'45 Kim Liên, Hà Nội', '0967788990'),
(207, N'Công ty TNHH Việt An', N'99 Tôn Thất Tùng, Hà Nội', '0978899001'),
(208, N'Công ty CP Minh Quân', N'33 Lê Văn Lương, Hà Nội', '0989900112'),
(209, N'Công ty TNHH Phú Lộc', N'22 Nguyễn Xiển, Hà Nội', '0990011223'),
(210, N'Công ty CP Nam Hải', N'55 Lạc Trung, Hà Nội', '0911122334'),
(211, N'Công ty TNHH Thiên Long', N'44 Thanh Xuân, Hà Nội', '0922233445'),
(212, N'Công ty CP Tân Tiến', N'77 Tây Hồ, Hà Nội', '0933344556'),
(213, N'Công ty TNHH Đại Thành', N'12 Mỹ Đình, Hà Nội', '0944455667'),
(214, N'Công ty CP Gia Phát', N'33 Ba Đình, Hà Nội', '0955566778'),
(215, N'Công ty TNHH Thế Kỷ', N'99 Đống Đa, Hà Nội', '0966677889'),
(216, N'Công ty CP Hoàng Gia', N'66 Hoàn Kiếm, Hà Nội', '0977788990'),
(217, N'Công ty TNHH Bảo An', N'11 Cầu Giấy, Hà Nội', '0988899001'),
(218, N'Công ty CP Quốc Cường', N'88 Hai Bà Trưng, Hà Nội', '0999900112'),
(219, N'Công ty TNHH Kim Long', N'33 Tây Sơn, Hà Nội', '0910011223'),
(220, N'Công ty CP Đại Lộc', N'22 Hoàng Cầu, Hà Nội', '0921122334');
GO


INSERT INTO PHIEUNHAP (MaPN, NgayNhap, MaNCC)
VALUES
(401, '2024-01-10', 201),
(402, '2024-01-12', 202),
(403, '2024-01-15', 203),
(404, '2024-01-18', 204),
(405, '2024-01-20', 205),
(406, '2024-01-22', 201),
(407, '2024-01-25', 202),
(408, '2024-01-28', 203),
(409, '2024-01-30', 204),
(410, '2024-02-02', 205),
(411, '2024-02-05', 201),
(412, '2024-02-08', 202),
(413, '2024-02-10', 203),
(414, '2024-02-12', 204),
(415, '2024-02-15', 205),
(416, '2024-02-18', 201),
(417, '2024-02-20', 202),
(418, '2024-02-22', 203),
(419, '2024-02-25', 204),
(420, '2024-02-28', 205);
GO


INSERT INTO HOADON (MaHoaDon, Ngay, MaKhachHang)
VALUES
(501, '2024-02-01', 101),
(502, '2024-02-03', 102),
(503, '2024-02-05', 103),
(504, '2024-02-07', 104),
(505, '2024-02-09', 105),
(506, '2024-02-11', 106),
(507, '2024-02-13', 107),
(508, '2024-02-15', 108),
(509, '2024-02-17', 109),
(510, '2024-02-19', 110),
(511, '2024-02-21', 111),
(512, '2024-02-23', 112),
(513, '2024-02-25', 113),
(514, '2024-02-27', 114),
(515, '2024-02-28', 115),
(516, '2024-03-02', 116),
(517, '2024-03-04', 117),
(518, '2024-03-06', 118),
(519, '2024-03-08', 119),
(520, '2024-03-10', 120);


INSERT INTO PHIEUXUAT (MaPX, NgayXuat)
VALUES
(601, '2024-02-02'),
(602, '2024-02-04'),
(603, '2024-02-06'),
(604, '2024-02-08'),
(605, '2024-02-10'),
(606, '2024-02-12'),
(607, '2024-02-14'),
(608, '2024-02-16'),
(609, '2024-02-18'),
(610, '2024-02-20'),
(611, '2024-02-22'),
(612, '2024-02-24'),
(613, '2024-02-26'),
(614, '2024-02-28'),
(615, '2024-03-02'),
(616, '2024-03-04'),
(617, '2024-03-06'),
(618, '2024-03-08'),
(619, '2024-03-10'),
(620, '2024-03-12');
GO

-- Chèn dữ liệu vào bảng CHITIETPHIEUNHAP
INSERT INTO CHITIETPHIEUNHAP (MaPN, MaVatTu, SoLuongNhap, DonGiaNhap)
VALUES
(401, 231, 50, 50000),
(402, 472, 1000, 4000),
(403, 389, 30, 350000),
(404, 514, 100, 60000),
(405, 628, 80, 70000),
(406, 756, 60, 45000),
(407, 821, 90, 55000),
(408, 943, 150, 30000),
(409, 127, 50, 320000),
(410, 398, 200, 28000),
(411, 564, 40, 51000),
(412, 682, 70, 42000),
(413, 775, 10, 3600000),
(414, 846, 300, 61000),
(415, 923, 35, 71000),
(416, 158, 100, 46000),
(417, 294, 120, 56000),
(418, 339, 90, 31000),
(419, 487, 80, 33000),
(420, 512, 5, 2900000);
GO

-- Chèn dữ liệu vào bảng CHITIETHOADON
INSERT INTO CHITIETHOADON (MaHoaDon, MaVatTu, SoLuongBan, GiaBan)
VALUES
(501, 231, 10, 55000),
(502, 472, 500, 5000),
(503, 389, 5, 380000),
(504, 514, 20, 65000),
(505, 628, 15, 75000),
(506, 756, 10, 50000),
(507, 821, 25, 60000),
(508, 943, 60, 35000),
(509, 127, 20, 350000),
(510, 398, 70, 30000),
(511, 564, 15, 56000),
(512, 682, 25, 48000),
(513, 775, 3, 3800000),
(514, 846, 100, 70000),
(515, 923, 10, 77000),
(516, 158, 40, 52000),
(517, 294, 50, 61000),
(518, 339, 30, 35000),
(519, 487, 25, 37000),
(520, 512, 2, 3200000);
GO

-- Chèn dữ liệu vào bảng CHITIETPHIEUXUAT
INSERT INTO CHITIETPHIEUXUAT (MaPX, MaVatTu, SoLuongXuat)
VALUES
(601, 231, 5),
(602, 472, 300),
(603, 389, 10),
(604, 514, 15),
(605, 628, 12),
(606, 756, 8),
(607, 821, 18),
(608, 943, 50),
(609, 127, 15),
(610, 398, 40),
(611, 564, 12),
(612, 682, 20),
(613, 775, 2),
(614, 846, 70),
(615, 923, 8),
(616, 158, 30),
(617, 294, 40),
(618, 339, 20),
(619, 487, 18),
(620, 512, 1);
GO


-- 1. View tổng hợp số lượng tồn kho của từng vật tư
CREATE VIEW vw_TonKhoVatTu AS
SELECT 
    V.MaVatTu,
    V.TenVatTu,
    V.DonViTinh,
    CAST(V.SoLuongTon AS INT) AS SoLuongTonBanDau,
    ISNULL(SUM(CAST(CTPN.SoLuongNhap AS INT)), 0) AS TongNhap,
    ISNULL(SUM(CAST(CTPX.SoLuongXuat AS INT)), 0) AS TongXuat,
    (CAST(V.SoLuongTon AS INT) + 
     ISNULL(SUM(CAST(CTPN.SoLuongNhap AS INT)), 0) - 
     ISNULL(SUM(CAST(CTPX.SoLuongXuat AS INT)), 0)) AS SoLuongTonHienTai
FROM 
    VATTU V
LEFT JOIN 
    CHITIETPHIEUNHAP CTPN ON V.MaVatTu = CTPN.MaVatTu
LEFT JOIN 
    CHITIETPHIEUXUAT CTPX ON V.MaVatTu = CTPX.MaVatTu
GROUP BY 
    V.MaVatTu, V.TenVatTu, V.DonViTinh, V.SoLuongTon;
GO


-- 2. View tổng hợp doanh thu theo từng khách hàng
CREATE VIEW vw_DoanhThuKhachHang AS
SELECT 
    HD.MaKhachHang,
    KH.TenKhachHang,
    SUM(CTHD.SoLuongBan * CTHD.GiaBan) AS TongDoanhThu
FROM 
    HOADON HD
JOIN 
    CHITIETHOADON CTHD ON HD.MaHoaDon = CTHD.MaHoaDon
JOIN 
    KHACHHANG KH ON HD.MaKhachHang = KH.MaKhachHang
GROUP BY 
    HD.MaKhachHang, KH.TenKhachHang;
GO

-- 3. View tổng hợp chi phí nhập hàng theo từng nhà cung cấp
CREATE VIEW vw_ChiPhiNhapHangNCC AS
SELECT 
    PN.MaNCC,
    NCC.TenNCC,
    SUM(CTPN.SoLuongNhap * CTPN.DonGiaNhap) AS TongChiPhiNhap
FROM 
    PHIEUNHAP PN
JOIN 
    CHITIETPHIEUNHAP CTPN ON PN.MaPN = CTPN.MaPN
JOIN 
    NHACUNGCAP NCC ON PN.MaNCC = NCC.MaNCC
GROUP BY 
    PN.MaNCC, NCC.TenNCC;
GO

-- 4. View tổng hợp số lượng vật tư đã bán theo từng tháng
CREATE VIEW vw_VatTuBanTheoThang AS
SELECT 
    YEAR(HD.Ngay) AS Nam,
    MONTH(HD.Ngay) AS Thang,
    V.MaVatTu,
    V.TenVatTu,
    SUM(CTHD.SoLuongBan) AS TongSoLuongBan
FROM 
    HOADON HD
JOIN 
    CHITIETHOADON CTHD ON HD.MaHoaDon = CTHD.MaHoaDon
JOIN 
    VATTU V ON CTHD.MaVatTu = V.MaVatTu
GROUP BY 
    YEAR(HD.Ngay), MONTH(HD.Ngay), V.MaVatTu, V.TenVatTu;
GO

-- 5. View tổng hợp số lượng vật tư đã xuất kho theo từng tháng
CREATE VIEW vw_VatTuXuatTheoThang AS
SELECT 
    YEAR(PX.NgayXuat) AS Nam,
    MONTH(PX.NgayXuat) AS Thang,
    V.MaVatTu,
    V.TenVatTu,
    SUM(CTPX.SoLuongXuat) AS TongSoLuongXuat
FROM 
    PHIEUXUAT PX
JOIN 
    CHITIETPHIEUXUAT CTPX ON PX.MaPX = CTPX.MaPX
JOIN 
    VATTU V ON CTPX.MaVatTu = V.MaVatTu
GROUP BY 
    YEAR(PX.NgayXuat), MONTH(PX.NgayXuat), V.MaVatTu, V.TenVatTu;
GO

-- 6. View tổng hợp lợi nhuận từ việc bán vật tư
CREATE VIEW vw_LoiNhuanBanVatTu AS
SELECT 
    V.MaVatTu,
    V.TenVatTu,
    SUM(CTHD.SoLuongBan * (CTHD.GiaBan - V.GiaMua)) AS LoiNhuan
FROM 
    VATTU V
JOIN 
    CHITIETHOADON CTHD ON V.MaVatTu = CTHD.MaVatTu
GROUP BY 
    V.MaVatTu, V.TenVatTu;
GO

-- 7. View tổng hợp số lượng vật tư nhập theo từng nhà cung cấp
CREATE VIEW vw_VatTuNhapTheoNCC AS
SELECT 
    PN.MaNCC,
    NCC.TenNCC,
    V.MaVatTu,
    V.TenVatTu,
    SUM(CTPN.SoLuongNhap) AS TongSoLuongNhap
FROM 
    PHIEUNHAP PN
JOIN 
    CHITIETPHIEUNHAP CTPN ON PN.MaPN = CTPN.MaPN
JOIN 
    VATTU V ON CTPN.MaVatTu = V.MaVatTu
JOIN 
    NHACUNGCAP NCC ON PN.MaNCC = NCC.MaNCC
GROUP BY 
    PN.MaNCC, NCC.TenNCC, V.MaVatTu, V.TenVatTu;
GO

-- 8. View tổng hợp số lượng vật tư bán ra theo từng khách hàng
CREATE VIEW vw_VatTuBanTheoKhachHang AS
SELECT 
    HD.MaKhachHang,
    KH.TenKhachHang,
    V.MaVatTu,
    V.TenVatTu,
    SUM(CTHD.SoLuongBan) AS TongSoLuongBan
FROM 
    HOADON HD
JOIN 
    CHITIETHOADON CTHD ON HD.MaHoaDon = CTHD.MaHoaDon
JOIN 
    VATTU V ON CTHD.MaVatTu = V.MaVatTu
JOIN 
    KHACHHANG KH ON HD.MaKhachHang = KH.MaKhachHang
GROUP BY 
    HD.MaKhachHang, KH.TenKhachHang, V.MaVatTu, V.TenVatTu;
GO

-- 9. View tổng hợp số lượng vật tư tồn kho dưới mức tối thiểu
CREATE VIEW vw_VatTuTonKhoDuoiMucToiThieu AS
SELECT 
    V.MaVatTu,
    V.TenVatTu,
    V.SoLuongTon,
    V.DonViTinh,
    (V.SoLuongTon + ISNULL(SUM(CTPN.SoLuongNhap), 0) - ISNULL(SUM(CTPX.SoLuongXuat), 0)) AS SoLuongTonHienTai
FROM 
    VATTU V
LEFT JOIN 
    CHITIETPHIEUNHAP CTPN ON V.MaVatTu = CTPN.MaVatTu
LEFT JOIN 
    CHITIETPHIEUXUAT CTPX ON V.MaVatTu = CTPX.MaVatTu
GROUP BY 
    V.MaVatTu, V.TenVatTu, V.SoLuongTon, V.DonViTinh
HAVING 
    (V.SoLuongTon + ISNULL(SUM(CTPN.SoLuongNhap), 0) - ISNULL(SUM(CTPX.SoLuongXuat), 0)) < 100;
GO

-- 10. View tổng hợp doanh thu và lợi nhuận theo từng tháng
CREATE VIEW vw_DoanhThuLoiNhuanTheoThang AS
SELECT 
    YEAR(HD.Ngay) AS Nam,
    MONTH(HD.Ngay) AS Thang,
    SUM(CTHD.SoLuongBan * CTHD.GiaBan) AS TongDoanhThu,
    SUM(CTHD.SoLuongBan * (CTHD.GiaBan - V.GiaMua)) AS TongLoiNhuan
FROM 
    HOADON HD
JOIN 
    CHITIETHOADON CTHD ON HD.MaHoaDon = CTHD.MaHoaDon
JOIN 
    VATTU V ON CTHD.MaVatTu = V.MaVatTu
GROUP BY 
    YEAR(HD.Ngay), MONTH(HD.Ngay);
GO


SELECT * FROM vw_TonKhoVatTu;
SELECT * FROM vw_DoanhThuKhachHang;
SELECT * FROM vw_ChiPhiNhapHangNCC;
SELECT * FROM vw_VatTuBanTheoThang;
SELECT * FROM vw_VatTuXuatTheoThang;
SELECT * FROM vw_LoiNhuanBanVatTu;
SELECT * FROM vw_VatTuNhapTheoNCC;
SELECT * FROM vw_VatTuBanTheoKhachHang;
SELECT * FROM vw_VatTuTonKhoDuoiMucToiThieu;
SELECT * FROM vw_DoanhThuLoiNhuanTheoThang;


--PROCEDURE

-- 1. Procedure thêm vật tư mới và tự động cập nhật tồn kho
CREATE PROCEDURE sp_ThemVatTu
    @MaVatTu INT,
    @TenVatTu NVARCHAR(100),
    @DonViTinh NVARCHAR(50),
    @GiaMua DECIMAL(18,2),
    @SoLuongTon INT
AS
BEGIN
    -- Kiểm tra xem vật tư đã tồn tại chưa
    IF EXISTS (SELECT 1 FROM VATTU WHERE MaVatTu = @MaVatTu)
    BEGIN
        PRINT 'Vật tư đã tồn tại!';
        RETURN;
    END

    -- Thêm vật tư mới
    INSERT INTO VATTU (MaVatTu, TenVatTu, DonViTinh, GiaMua, SoLuongTon)
    VALUES (@MaVatTu, @TenVatTu, @DonViTinh, @GiaMua, @SoLuongTon);

    PRINT 'Thêm vật tư thành công!';
END;
GO

-- 2. Procedure nhập vật tư và cập nhật tồn kho
CREATE PROCEDURE sp_NhapVatTu
    @MaPN INT,
    @MaNCC INT,
    @MaVatTu INT,
    @SoLuongNhap INT,
    @DonGiaNhap DECIMAL(18,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Thêm phiếu nhập
        INSERT INTO PHIEUNHAP (MaPN, MaNCC)
        VALUES (@MaPN, @MaNCC);

        -- Thêm chi tiết phiếu nhập
        INSERT INTO CHITIETPHIEUNHAP (MaPN, MaVatTu, SoLuongNhap, DonGiaNhap)
        VALUES (@MaPN, @MaVatTu, @SoLuongNhap, @DonGiaNhap);

        -- Cập nhật tồn kho
        UPDATE VATTU
        SET SoLuongTon = SoLuongTon + @SoLuongNhap
        WHERE MaVatTu = @MaVatTu;

        COMMIT TRANSACTION;
        PRINT 'Nhập vật tư thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 3. Procedure xuất vật tư và kiểm tra tồn kho
CREATE PROCEDURE sp_XuatVatTu
    @MaPX INT,
    @MaVatTu INT,
    @SoLuongXuat INT
AS
BEGIN
    DECLARE @TonKho INT;

    -- Kiểm tra tồn kho
    SELECT @TonKho = SoLuongTon
    FROM VATTU
    WHERE MaVatTu = @MaVatTu;

    IF @TonKho < @SoLuongXuat
    BEGIN
        PRINT 'Không đủ tồn kho để xuất!';
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        -- Thêm phiếu xuất
        INSERT INTO PHIEUXUAT (MaPX)
        VALUES (@MaPX);

        -- Thêm chi tiết phiếu xuất
        INSERT INTO CHITIETPHIEUXUAT (MaPX, MaVatTu, SoLuongXuat)
        VALUES (@MaPX, @MaVatTu, @SoLuongXuat);

        -- Cập nhật tồn kho
        UPDATE VATTU
        SET SoLuongTon = SoLuongTon - @SoLuongXuat
        WHERE MaVatTu = @MaVatTu;

        COMMIT TRANSACTION;
        PRINT 'Xuất vật tư thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 4. Procedure tính tổng doanh thu theo khách hàng
CREATE PROCEDURE sp_TinhDoanhThuTheoKhachHang
    @MaKhachHang INT
AS
BEGIN
    SELECT 
        KH.MaKhachHang,
        KH.TenKhachHang,
        SUM(CTHD.SoLuongBan * CTHD.GiaBan) AS TongDoanhThu
    FROM 
        HOADON HD
    JOIN 
        CHITIETHOADON CTHD ON HD.MaHoaDon = CTHD.MaHoaDon
    JOIN 
        KHACHHANG KH ON HD.MaKhachHang = KH.MaKhachHang
    WHERE 
        KH.MaKhachHang = @MaKhachHang
    GROUP BY 
        KH.MaKhachHang, KH.TenKhachHang;
END;
GO

-- 5. Procedure tính lợi nhuận từ việc bán vật tư
CREATE PROCEDURE sp_TinhLoiNhuanBanVatTu
    @MaVatTu INT
AS
BEGIN
    SELECT 
        V.MaVatTu,
        V.TenVatTu,
        SUM(CTHD.SoLuongBan * (CTHD.GiaBan - V.GiaMua)) AS LoiNhuan
    FROM 
        VATTU V
    JOIN 
        CHITIETHOADON CTHD ON V.MaVatTu = CTHD.MaVatTu
    WHERE 
        V.MaVatTu = @MaVatTu
    GROUP BY 
        V.MaVatTu, V.TenVatTu;
END;
GO

-- 6. Procedure thống kê vật tư tồn kho dưới mức tối thiểu
CREATE PROCEDURE sp_ThongKeVatTuTonKhoDuoiMucToiThieu
    @MucToiThieu INT
AS
BEGIN
    SELECT 
        V.MaVatTu,
        V.TenVatTu,
        V.SoLuongTon,
        V.DonViTinh
    FROM 
        VATTU V
    WHERE 
        V.SoLuongTon < @MucToiThieu;
END;
GO

-- 7. Procedure thêm hóa đơn và chi tiết hóa đơn
CREATE PROCEDURE sp_ThemHoaDon
    @MaHoaDon INT,
    @MaKhachHang INT,
    @MaVatTu INT,
    @SoLuongBan INT,
    @GiaBan DECIMAL(18,2)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Thêm hóa đơn
        INSERT INTO HOADON (MaHoaDon, MaKhachHang)
        VALUES (@MaHoaDon, @MaKhachHang);

        -- Thêm chi tiết hóa đơn
        INSERT INTO CHITIETHOADON (MaHoaDon, MaVatTu, SoLuongBan, GiaBan)
        VALUES (@MaHoaDon, @MaVatTu, @SoLuongBan, @GiaBan);

        -- Cập nhật tồn kho
        UPDATE VATTU
        SET SoLuongTon = SoLuongTon - @SoLuongBan
        WHERE MaVatTu = @MaVatTu;

        COMMIT TRANSACTION;
        PRINT 'Thêm hóa đơn thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Lỗi: ' + ERROR_MESSAGE();
    END CATCH
END;
GO

-- 8. Procedure thống kê vật tư nhập theo nhà cung cấp
CREATE PROCEDURE sp_ThongKeVatTuNhapTheoNCC
    @MaNCC INT
AS
BEGIN
    SELECT 
        NCC.TenNCC,
        V.MaVatTu,
        V.TenVatTu,
        SUM(CTPN.SoLuongNhap) AS TongSoLuongNhap
    FROM 
        PHIEUNHAP PN
    JOIN 
        CHITIETPHIEUNHAP CTPN ON PN.MaPN = CTPN.MaPN
    JOIN 
        VATTU V ON CTPN.MaVatTu = V.MaVatTu
    JOIN 
        NHACUNGCAP NCC ON PN.MaNCC = NCC.MaNCC
    WHERE 
        NCC.MaNCC = @MaNCC
    GROUP BY 
        NCC.TenNCC, V.MaVatTu, V.TenVatTu;
END;
GO

-- 9. Procedure tính tổng chi phí nhập hàng theo tháng
CREATE PROCEDURE sp_TinhChiPhiNhapHangTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        SUM(CTPN.SoLuongNhap * CTPN.DonGiaNhap) AS TongChiPhiNhap
    FROM 
        PHIEUNHAP PN
    JOIN 
        CHITIETPHIEUNHAP CTPN ON PN.MaPN = CTPN.MaPN
    WHERE 
        MONTH(PN.NgayNhap) = @Thang AND YEAR(PN.NgayNhap) = @Nam;
END;
GO

-- 10. Procedure thống kê doanh thu và lợi nhuận theo tháng
CREATE PROCEDURE sp_ThongKeDoanhThuLoiNhuanTheoThang
    @Thang INT,
    @Nam INT
AS
BEGIN
    SELECT 
        SUM(CTHD.SoLuongBan * CTHD.GiaBan) AS TongDoanhThu,
        SUM(CTHD.SoLuongBan * (CTHD.GiaBan - V.GiaMua)) AS TongLoiNhuan
    FROM 
        HOADON HD
    JOIN 
        CHITIETHOADON CTHD ON HD.MaHoaDon = CTHD.MaHoaDon
    JOIN 
        VATTU V ON CTHD.MaVatTu = V.MaVatTu
    WHERE 
        MONTH(HD.Ngay) = @Thang AND YEAR(HD.Ngay) = @Nam;
END;
GO

EXEC sp_ThemVatTu @MaVatTu = 1, @TenVatTu = N'Xi măng', @DonViTinh = N'Bao', @GiaMua = 50000, @SoLuongTon = 100;
EXEC sp_NhapVatTu @MaPN = 127, @MaNCC = 207, @MaVatTu = 775, @SoLuongNhap = 50, @DonGiaNhap = 48000;
EXEC sp_XuatVatTu @MaPX = 1, @MaVatTu = 1, @SoLuongXuat = 30;
EXEC sp_TinhDoanhThuTheoKhachHang @MaKhachHang = 102;
EXEC sp_TinhLoiNhuanBanVatTu @MaVatTu = 512;
EXEC sp_ThongKeVatTuTonKhoDuoiMucToiThieu @MucToiThieu = 300;
EXEC sp_ThemHoaDon @MaHoaDon = 527, @MaKhachHang = 107, @MaVatTu = 339, @SoLuongBan = 59, @GiaBan = 50000;
EXEC sp_ThongKeVatTuNhapTheoNCC @MaNCC =205;
EXEC sp_TinhChiPhiNhapHangTheoThang @Thang =2, @Nam = 2024;
EXEC sp_ThongKeDoanhThuLoiNhuanTheoThang @Thang = 3, @Nam = 2024;

--TRIGGER
-- 1. Trigger kiểm tra số lượng tồn kho trước khi xuất vật tư
CREATE TRIGGER trg_KiemTraTonKhoTruocKhiXuat
ON CHITIETPHIEUXUAT
FOR INSERT
AS
BEGIN
    DECLARE @MaVatTu INT, @SoLuongXuat INT;

    SELECT @MaVatTu = MaVatTu, @SoLuongXuat = SoLuongXuat
    FROM inserted;

    DECLARE @TonKho INT;
    SELECT @TonKho = SoLuongTon
    FROM VATTU
    WHERE MaVatTu = @MaVatTu;

    IF @TonKho < @SoLuongXuat
    BEGIN
        PRINT 'Không đủ tồn kho để xuất!';
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        -- Cập nhật tồn kho
        UPDATE VATTU
        SET SoLuongTon = SoLuongTon - @SoLuongXuat
        WHERE MaVatTu = @MaVatTu;
    END
END;
GO

-- 2. Trigger tự động cập nhật tồn kho khi nhập vật tư
CREATE TRIGGER trg_CapNhatTonKhoKhiNhap
ON CHITIETPHIEUNHAP
FOR INSERT
AS
BEGIN
    DECLARE @MaVatTu INT, @SoLuongNhap INT;

    SELECT @MaVatTu = MaVatTu, @SoLuongNhap = SoLuongNhap
    FROM inserted;

    -- Cập nhật tồn kho
    UPDATE VATTU
    SET SoLuongTon = SoLuongTon + @SoLuongNhap
    WHERE MaVatTu = @MaVatTu;
END;
GO

-- 3. Trigger kiểm tra giá bán không được thấp hơn giá mua
CREATE TRIGGER trg_KiemTraGiaBan
ON CHITIETHOADON
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @MaVatTu INT, @GiaBan DECIMAL(18,2);

    SELECT @MaVatTu = MaVatTu, @GiaBan = GiaBan
    FROM inserted;

    DECLARE @GiaMua DECIMAL(18,2);
    SELECT @GiaMua = GiaMua
    FROM VATTU
    WHERE MaVatTu = @MaVatTu;

    IF @GiaBan < @GiaMua
    BEGIN
        PRINT 'Giá bán không được thấp hơn giá mua!';
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 4. Trigger tự động cập nhật tồn kho khi bán vật tư
CREATE TRIGGER trg_CapNhatTonKhoKhiBan
ON CHITIETHOADON
FOR INSERT
AS
BEGIN
    DECLARE @MaVatTu INT, @SoLuongBan INT;

    SELECT @MaVatTu = MaVatTu, @SoLuongBan = SoLuongBan
    FROM inserted;

    -- Cập nhật tồn kho
    UPDATE VATTU
    SET SoLuongTon = SoLuongTon - @SoLuongBan
    WHERE MaVatTu = @MaVatTu;
END;
GO

-- 5. Trigger kiểm tra số lượng tồn kho trước khi bán vật tư
CREATE TRIGGER trg_KiemTraTonKhoTruocKhiBan
ON CHITIETHOADON
FOR INSERT
AS
BEGIN
    DECLARE @MaVatTu INT, @SoLuongBan INT;

    SELECT @MaVatTu = MaVatTu, @SoLuongBan = SoLuongBan
    FROM inserted;

    DECLARE @TonKho INT;
    SELECT @TonKho = SoLuongTon
    FROM VATTU
    WHERE MaVatTu = @MaVatTu;

    IF @TonKho < @SoLuongBan
    BEGIN
        PRINT 'Không đủ tồn kho để bán!';
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 7. Trigger kiểm tra số lượng nhập không được âm
CREATE TRIGGER trg_KiemTraSoLuongNhap
ON CHITIETPHIEUNHAP
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @SoLuongNhap INT;

    SELECT @SoLuongNhap = SoLuongNhap
    FROM inserted;

    IF @SoLuongNhap <= 0
    BEGIN
        PRINT 'Số lượng nhập phải lớn hơn 0!';
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 9. Trigger kiểm tra số lượng xuất không được âm
CREATE TRIGGER trg_KiemTraSoLuongXuat
ON CHITIETPHIEUXUAT
FOR INSERT, UPDATE
AS
BEGIN
    DECLARE @SoLuongXuat INT;

    SELECT @SoLuongXuat = SoLuongXuat
    FROM inserted;

    IF @SoLuongXuat <= 0
    BEGIN
        PRINT 'Số lượng xuất phải lớn hơn 0!';
        ROLLBACK TRANSACTION;
    END
END;
GO

-- 10. Trigger tự động cập nhật tổng số lượng xuất khi thêm chi tiết phiếu xuất
ALTER TABLE PHIEUXUAT ADD TongSoLuongXuat INT DEFAULT 0;

CREATE TRIGGER trg_CapNhatTongSoLuongXuat
ON CHITIETPHIEUXUAT
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    -- Bảng tạm lưu các MaPX bị ảnh hưởng
    DECLARE @MaPX TABLE (MaPX INT);

    -- Lấy MaPX từ bảng inserted hoặc deleted
    INSERT INTO @MaPX (MaPX)
    SELECT DISTINCT MaPX FROM inserted
    UNION
    SELECT DISTINCT MaPX FROM deleted;

    -- Cập nhật tổng số lượng xuất cho từng MaPX
    UPDATE PHIEUXUAT
    SET TongSoLuongXuat = (
        SELECT COALESCE(SUM(SoLuongXuat), 0) 
        FROM CHITIETPHIEUXUAT 
        WHERE MaPX = p.MaPX
    )
    FROM PHIEUXUAT p
    INNER JOIN @MaPX m ON p.MaPX = m.MaPX;
END;
GO


-- 6. Trigger tự động tính tổng tiền hóa đơn khi thêm chi tiết hóa đơn
ALTER TABLE HOADON ADD TongTien DECIMAL(18,2) DEFAULT 0;

CREATE TRIGGER trg_TinhTongTienHoaDon
ON CHITIETHOADON
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    -- Bảng tạm lưu các MaHoaDon bị ảnh hưởng
    DECLARE @MaHD TABLE (MaHoaDon INT);

    -- Lấy danh sách MaHoaDon từ inserted và deleted
    INSERT INTO @MaHD (MaHoaDon)
    SELECT DISTINCT MaHoaDon FROM inserted
    UNION
    SELECT DISTINCT MaHoaDon FROM deleted;

    -- Cập nhật tổng tiền hóa đơn cho từng MaHoaDon
    UPDATE HOADON
    SET TongTien = (
        SELECT COALESCE(SUM(SoLuongBan * GiaBan), 0) 
        FROM CHITIETHOADON 
        WHERE MaHoaDon = h.MaHoaDon
    )
    FROM HOADON h
    INNER JOIN @MaHD m ON h.MaHoaDon = m.MaHoaDon;
END;
GO


-- 8. Trigger tự động cập nhật tổng chi phí nhập hàng khi thêm chi tiết phiếu nhập
ALTER TABLE PHIEUNHAP ADD TongChiPhi DECIMAL(18,2) DEFAULT 0;

CREATE TRIGGER trg_CapNhatTongChiPhiNhap
ON CHITIETPHIEUNHAP
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    -- Bảng tạm lưu các MaPN bị ảnh hưởng
    DECLARE @MaPN TABLE (MaPN INT);

    -- Lấy danh sách MaPN từ inserted và deleted
    INSERT INTO @MaPN (MaPN)
    SELECT DISTINCT MaPN FROM inserted
    UNION
    SELECT DISTINCT MaPN FROM deleted;

    -- Cập nhật tổng chi phí nhập hàng cho từng MaPN
    UPDATE PHIEUNHAP
    SET TongChiPhi = (
        SELECT COALESCE(SUM(SoLuongNhap * DonGiaNhap), 0) 
        FROM CHITIETPHIEUNHAP 
        WHERE MaPN = p.MaPN
    )
    FROM PHIEUNHAP p
    INNER JOIN @MaPN m ON p.MaPN = m.MaPN;
END;
GO

-- Tạo người dùng và vai trò
CREATE LOGIN NhanVienKho WITH PASSWORD = 'NhanVienKho@123';
CREATE USER NhanVienKho FOR LOGIN NhanVienKho;

CREATE LOGIN NhanVienBanHang WITH PASSWORD = 'NhanVienBanHang@123';
CREATE USER NhanVienBanHang FOR LOGIN NhanVienBanHang;

CREATE LOGIN QuanLy WITH PASSWORD = 'QuanLy@123';
CREATE USER QuanLy FOR LOGIN QuanLy;

CREATE ROLE NhanVienKhoRole;
CREATE ROLE NhanVienBanHangRole;
CREATE ROLE QuanLyRole;

ALTER ROLE NhanVienKhoRole ADD MEMBER NhanVienKho;
ALTER ROLE NhanVienBanHangRole ADD MEMBER NhanVienBanHang;
ALTER ROLE QuanLyRole ADD MEMBER QuanLy;

-- Phân quyền cho vai trò Nhân viên kho
GRANT SELECT ON VATTU TO NhanVienKhoRole;
GRANT INSERT, UPDATE, DELETE ON PHIEUNHAP TO NhanVienKhoRole;
GRANT INSERT, UPDATE, DELETE ON CHITIETPHIEUNHAP TO NhanVienKhoRole;
GRANT INSERT, UPDATE, DELETE ON PHIEUXUAT TO NhanVienKhoRole;
GRANT INSERT, UPDATE, DELETE ON CHITIETPHIEUXUAT TO NhanVienKhoRole;
GRANT EXECUTE ON sp_NhapVatTu TO NhanVienKhoRole;
GRANT EXECUTE ON sp_XuatVatTu TO NhanVienKhoRole;

-- Phân quyền cho vai trò Nhân viên bán hàng
GRANT SELECT ON VATTU TO NhanVienBanHangRole;
GRANT INSERT, UPDATE, DELETE ON HOADON TO NhanVienBanHangRole;
GRANT INSERT, UPDATE, DELETE ON CHITIETHOADON TO NhanVienBanHangRole;
GRANT SELECT ON KHACHHANG TO NhanVienBanHangRole;
GRANT EXECUTE ON sp_ThemHoaDon TO NhanVienBanHangRole;
GRANT EXECUTE ON sp_TinhDoanhThuTheoKhachHang TO NhanVienBanHangRole;

-- Phân quyền cho vai trò Quản lý
GRANT SELECT ON VATTU TO QuanLyRole;
GRANT SELECT ON KHACHHANG TO QuanLyRole;
GRANT SELECT ON NHACUNGCAP TO QuanLyRole;
GRANT SELECT ON PHIEUNHAP TO QuanLyRole;
GRANT SELECT ON PHIEUXUAT TO QuanLyRole;
GRANT SELECT ON HOADON TO QuanLyRole;
GRANT SELECT ON CHITIETPHIEUNHAP TO QuanLyRole;
GRANT SELECT ON CHITIETPHIEUXUAT TO QuanLyRole;
GRANT SELECT ON CHITIETHOADON TO QuanLyRole;

GRANT INSERT, UPDATE, DELETE ON VATTU TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON KHACHHANG TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON NHACUNGCAP TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON PHIEUNHAP TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON PHIEUXUAT TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON HOADON TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON CHITIETPHIEUNHAP TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON CHITIETPHIEUXUAT TO QuanLyRole;
GRANT INSERT, UPDATE, DELETE ON CHITIETHOADON TO QuanLyRole;

GRANT EXECUTE ON sp_ThemVatTu TO QuanLyRole;
GRANT EXECUTE ON sp_NhapVatTu TO QuanLyRole;
GRANT EXECUTE ON sp_XuatVatTu TO QuanLyRole;
GRANT EXECUTE ON sp_TinhDoanhThuTheoKhachHang TO QuanLyRole;
GRANT EXECUTE ON sp_TinhLoiNhuanBanVatTu TO QuanLyRole;
GRANT EXECUTE ON sp_ThongKeVatTuTonKhoDuoiMucToiThieu TO QuanLyRole;
GRANT EXECUTE ON sp_ThemHoaDon TO QuanLyRole;
GRANT EXECUTE ON sp_ThongKeVatTuNhapTheoNCC TO QuanLyRole;
GRANT EXECUTE ON sp_TinhChiPhiNhapHangTheoThang TO QuanLyRole;
GRANT EXECUTE ON sp_ThongKeDoanhThuLoiNhuanTheoThang TO QuanLyRole;

-- Thu hồi quyền Ví dụ
REVOKE SELECT ON VATTU FROM NhanVienKhoRole;

-- Từ chối quyền Ví dụ
DENY DELETE ON VATTU TO NhanVienKhoRole;

-- Kiểm tra quyền của người dùng NhanVienKho
SELECT * 
FROM sys.fn_my_permissions('VATTU', 'OBJECT') 
WHERE grantee_principal_id = USER_ID('NhanVienKho');

-- Xóa người dùng và vai trò
DROP USER NhanVienKho;
DROP USER NhanVienBanHang;
DROP USER QuanLy;

DROP ROLE NhanVienKhoRole;
DROP ROLE NhanVienBanHangRole;
DROP ROLE QuanLyRole;


