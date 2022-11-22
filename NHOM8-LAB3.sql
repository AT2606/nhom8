---BÀI THỰC HÀNH 3
--Với mỗi đề án, liệt kê tên đề án và tổng số giờ làm việc một tuần của tất cả các nhân viên tham dự đề án đó.
--	Dùng cast
Select TENDA, cast(sum(THOIGIAN) as decimal(5,2)) as 'tong so gio lam viec'
from CONGVIEC inner join DEAN on CONGVIEC.MADA=DEAN.MADA inner join PHANCONG on CONGVIEC.MADA=PHANCONG.MADA 
Group by TENDA

-- 	Dùng convert
Select TENDA, convert( decimal(5,2),sum(THOIGIAN)) as 'Tong so gio lam viec'
from CONGVIEC inner join DEAN on CONGVIEC.MADA=DEAN.MADA inner join PHANCONG on CONGVIEC.MADA=PHANCONG.MADA 
Group by TENDA  

--Xuất định dạng “tổng số giờ làm việc” kiểu varchar
--	Dùng cast
Select TENDA, cast(sum(THOIGIAN) as varchar(20)) as 'Tong so gio lam viec'
from CONGVIEC inner join DEAN on CONGVIEC.MADA=DEAN.MADA inner join PHANCONG on CONGVIEC.MADA=PHANCONG.MADA 
Group by TENDA

--	Dùng convert
Select TENDA, convert(varchar(20),sum(THOIGIAN)) as 'Tong so gio lam viec'
from CONGVIEC inner join DEAN on CONGVIEC.MADA=DEAN.MADA inner join PHANCONG on CONGVIEC.MADA=PHANCONG.MADA 
Group by TENDA

--	Xuất định dạng “luong trung bình” kiểu decimal với 2 số thập phân, sử dụng dấu phẩy để phân biệt phần nguyên và phần thập phân.
  --  Dùng cast
SELECT PHONGBAN.TENPHG , CAST(AVG(NHANVIEN.LUONG) AS decimal(10,2)) AS 'LUONG TRUNG BINH'
FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.PHG=PHONGBAN.MAPHG
GROUP BY PHONGBAN.TENPHG
  --	Dùng convert
SELECT PHONGBAN.TENPHG , CONVERT(DECIMAL(10,2),AVG(NHANVIEN.LUONG) ) AS 'LUONG TRUNG BINH'
FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.PHG=PHONGBAN.MAPHG
GROUP BY PHONGBAN.TENPHG

--	Xuất định dạng “luong trung bình” kiểu varchar. Sử dụng dấu phẩy tách cứ mỗi 3 chữ số trong chuỗi ra, gợi ý dùng thêm các hàm Left, Replace
--	Dùng cast
SELECT PHONGBAN.TENPHG , LEFT(CAST(AVG(NHANVIEN.LUONG) AS VARCHAR(20)),3)+',' +
REPLACE(CAST(AVG(NHANVIEN.LUONG) AS VARCHAR(20)),LEFT(CAST(AVG(NHANVIEN.LUONG) 	AS VARCHAR(20)),3),'')
AS 'LUONG TRUNG BINH' 
FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.PHG=PHONGBAN.MAPHG
GROUP BY PHONGBAN.TENPHG

--	Dùng convert
SELECT PHONGBAN.TENPHG , LEFT(CONVERT(VARCHAR(20),AVG(NHANVIEN.LUONG) ) ,3)+',' +
REPLACE(CONVERT(VARCHAR(20),AVG(NHANVIEN.LUONG) ),LEFT(CONVERT(VARCHAR(20),AVG(NHANVIEN.LUONG) ) ,3),'') 
AS 'LUONG TRUNG BINH'
FROM NHANVIEN INNER JOIN PHONGBAN ON NHANVIEN.PHG=PHONGBAN.MAPHG
GROUP BY PHONGBAN.TENPHG

--Bài 2: (2 điểm) Sử dụng các hàm toán học 
---	Xuất định dạng “tổng số giờ làm việc” với hàm CEILING 
SELECT DEAN.TENDA , CEILING(CONVERT(decimal(4,2),SUM(PHANCONG.THOIGIAN))) AS 'TONG THOI GIAN'
FROM PHANCONG INNER JOIN DEAN ON PHANCONG.MADA =DEAN.MADA
GROUP BY DEAN.TENDA
---	Xuất định dạng “tổng số giờ làm việc” với hàm FLOOR
 SELECT DEAN.TENDA ,FLOOR( CONVERT(decimal(4,2),SUM(PHANCONG.THOIGIAN))) AS 'TONG THOI GIAN'
FROM PHANCONG INNER JOIN DEAN ON PHANCONG.MADA =DEAN.MADA
GROUP BY DEAN.TENDA	

---	Xuất định dạng “tổng số giờ làm việc” làm tròn tới 2 chữ số thập phân 
SELECT DEAN.TENDA , ROUND(CONVERT(decimal(4,2),SUM(PHANCONG.THOIGIAN)),2) AS'TONG THOI GIAN'
FROM PHANCONG INNER JOIN DEAN ON PHANCONG.MADA =DEAN.MADA
GROUP BY DEAN.TENDA
--Cho biết họ tên nhân viên (HONV, TENLOT, TENNV) có mức lương trên mức lương trung bình (làm tròn đến 2 số thập phân) của phòng "Nghiên cứu"
DECLARE @TBluong float
DECLARE @MPNCuu int
SELECT @MPNCuu =(SELECT MAPHG FROM PHONGBAN WHERE TENPHG=N'Nghiên cứu')
SELECT @TBluong = (SELECT ROUND(AVG(NHANVIEN.LUONG),2) FROM NHANVIEN  WHERE NHANVIEN.PHG=@MPNCuu)
SELECT HONV + ' '+TENLOT + ' '+TENNV AS 'HỌ VÀ TÊN '
FROM NHANVIEN
WHERE LUONG > @TBluong

--Bài 3: (2 điểm) Sử dụng các hàm xử lý chuỗi 
-- Dữ liệu cột HONV được viết in hoa toàn bộ 
select UPPER(NHANVIEN.HONV) , NHANVIEN.TENLOT , NHANVIEN.TENNV as hoten,NHANVIEN.DCHI, count(TN.TENTN) AS 'SO THAN NHAN'
from NHANVIEN 
inner join THANNHAN TN on NHANVIEN.MANV = TN.MA_NVIEN
group by NHANVIEN.HONV,NHANVIEN.TENLOT, NHANVIEN.TENNV, NHANVIEN.DCHI
having count(TN.TENTN) > 2 

--Dữ liệu cột TENLOT được viết chữ thường toàn bộ
select NHANVIEN.HONV ,LOWER( NHANVIEN.TENLOT) , NHANVIEN.TENNV as hoten,NHANVIEN.DCHI, count(TN.TENTN) AS 'SO THAN NHAN'
from NHANVIEN 
inner join THANNHAN TN on NHANVIEN.MANV = TN.MA_NVIEN
group by NHANVIEN.HONV,NHANVIEN.TENLOT, NHANVIEN.TENNV, NHANVIEN.DCHI
having count(TN.TENTN) > 2 

--Dữ liệu cột TENNV có ký tự thứ 2 được viết in hoa, các ký tự còn lại viết thường( ví dụ: kHanh) 
select NHANVIEN.HONV ,NHANVIEN.TENLOT ,
LOWER(left(NHANVIEN.TENNV, 1)) +
UPPER(right(left(NHANVIEN.TENNV, 2), 1)) +
LOWER(right(NHANVIEN.TENNV, LEN(NHANVIEN.TENNV) - 2))
as hoten, NHANVIEN.DCHI, 
NHANVIEN.TENNV, count(TN.TENTN) AS 'SO THAN NHAN'
from NHANVIEN 
inner join THANNHAN TN on NHANVIEN.MANV = TN.MA_NVIEN
group by NHANVIEN.HONV,NHANVIEN.TENLOT, NHANVIEN.TENNV, NHANVIEN.DCHI
having count(TN.TENTN) > 2 

--Bài 4: (2 điểm) Sử dụng các hàm ngày tháng năm 
-- Cho biết các nhân viên có năm sinh trong khoảng 1960 đến 1965.
SELECT * FROM NHANVIEN
WHERE YEAR(NGSINH) BETWEEN 1960 AND 1965

-- Cho biết tuổi của các nhân viên tính đến thời điểm hiện tại. 
SELECT TENNV, YEAR(GETDATE())-YEAR(NGSINH) AS TUOI
FROM NHANVIEN

--Dựa vào dữ liệu NGSINH, cho biết nhân viên sinh vào thứ mấy. 
SELECT  *,DATENAME(DW,NGSINH) AS DAY_OF_WEEK
FROM NHANVIEN
