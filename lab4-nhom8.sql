--------------------------------LAB4------------------------------------
--Bài 1:Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng if…else và case
-- Viết chương trình xem xét có tăng lương cho nhân viên hay không. Hiển thị cột thứ 1 là TenNV, cột thứ 2 nhận giá trị
-- “TangLuong” nếu lương hiện tại của nhân viên nhở hơn trung bình lương trong phòng mà nhân viên đó đang làm việc. 
-- “KhongTangLuong “ nếu lương hiện tại của nhân viên lớn hơn trung bình lương trong phòng mà nhân viên đó đang làm việc.
DECLARE @TB TABLE(MAPHG INT, LUONGTB FLOAT)
INSERT INTO @TB	
	SELECT PHG, AVG(LUONG) 
	FROM NHANVIEN 
	GROUP BY PHG
SELECT TENNV,IIF ((LUONG >LUONGTB), 'KHONG TANG LUONG','TANG LUONG')AS QUYETDINH
FROM NHANVIEN,@TB
WHERE PHG=MAPHG
 ---Viết chương trình phân loại nhân viên dựa vào mức lương.
-- Nếu lương nhân viên nhỏ hơn trung bình lương mà nhân viên đó đang làm việc thì xếp loại “nhanvien”, ngược lại xếp loại “truongphong”

DECLARE @TB TABLE(MAPHG INT, LUONGTB FLOAT)
INSERT INTO @TB	
	SELECT PHG, AVG(LUONG) 
	FROM NHANVIEN 
	GROUP BY PHG
SELECT TENNV,IIF ((LUONG >=LUONGTB), 'TRUONG PHONG','NHAN VIEN')AS CHUC_VU
FROM NHANVIEN,@TB
WHERE PHG=MAPHG
--Viết chương trình hiển thị TenNV THEO 'mr.' hoặc 'ms.', tùy vào cột phái của nhân viên

SELECT  IIF ((PHAI='Nam'),'Mr.'+TENNV,'Ms.'+Tennv) as TenNV
FROM NHANVIEN
--Viết chương trình tính thuế mà nhân viên phải đóng theo công thức:
-- 0<luong<25000 thì đóng 10% tiền lương
-- 25000<luong<30000 thì đóng 12% tiền lương
-- 30000<luong<40000 thì đóng 15% tiền lương
-- 40000<luong<50000 thì đóng 20% tiền lương
--Luong>50000 đóng 25% tiền lương

SELECT TENNV,LUONG , Thue = case 
	WHEN LUONG BETWEEN 0 AND  25000 THEN LUONG*0.1
	WHEN LUONG BETWEEN 25000 AND  30000 THEN LUONG*0.12
	WHEN LUONG BETWEEN 30000 AND  40000 THEN LUONG*0.15
	WHEN LUONG BETWEEN 40000 AND  50000 THEN LUONG*0.20
	ELSE LUONG*0.25
	END
FROM NHANVIEN

--Sử dụng cơ sở dữ liệu QLDA. Thực hiện các câu truy vấn sau, sử dụng vòng lặp
-- Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn.


DECLARE @MAX INT, @NUM INT;
SELECT @MAX = MAX(CAST(MANV AS INT)) FROM NHANVIEN;
SET @NUM =1;
WHILE @NUM <= @MAX
BEGIN
	IF @NUM %2 =0
	SELECT HONV,TENLOT, TENNV,MANV from NHANVIEN where cast (MANV as int) = @num;
	SET @NUM = @NUM +1;
END;
 --Cho biết thông tin nhân viên (HONV, TENLOT, TENNV) có MaNV là số chẵn nhưng không tính nhân viên có MaNV là 4.

 DECLARE @MAX INT, @NUM INT;
SELECT @MAX = MAX(CAST(MANV AS INT)) FROM NHANVIEN;

SET @NUM =1;

WHILE @NUM <= @MAX
BEGIN
	IF @NUM=4
	BEGIN
		SET @NUM=@NUM+1;
		CONTINUE;
	END

	IF @NUM %2 =0
	SELECT HONV,TENLOT, TENNV,MANV from NHANVIEN where cast (MANV as int) = @num;

	SET @NUM = @NUM +1;
END;
--Bài 3: (3 điểm)  Quản lý lỗi chương trình 
 --Thực hiện chèn thêm một dòng dữ liệu vào bảng PhongBan theo 2 bước 
 --Nhận thông báo “ thêm dư lieu thành cong” từ khối Try
-- Chèn sai kiểu dữ liệu cột MaPHG để nhận thông báo lỗi “Them dư lieu that bai” từ khối Catch
select * from PHONGBAN
BEGIN TRY
	insert into PHONGBAN(TENPHG,MAPHG,TRPHG, NG_NHANCHUC)
	values (N'Sản Xuất',29.0, '009','2020/03/02');
	print N'thêm dữ liệu thành công'
END TRY
BEGIN CATCH
	print N'fail : chèn dữ liệu không thành công'
END CATCH

