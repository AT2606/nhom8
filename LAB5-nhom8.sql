-----------LAB5-------------
----------BAI1-------------
----CAU 1
create procedure sp_bai1_1 @name nvarchar(20)
as 
begin
	print'xin chao : ' +@name
	end;
exec sp_bai1_1 N'toi'

--CAU 2
create procedure sp_bai1_2 @a int ,@b int
as
begin
	declare @tong int = 0
	set @tong = @a + @b
	print @tong
	end
exec sp_bai1_2 4,5
---CAU 3
create procedure sp_bai1_3 @n int 
as
begin
	declare @tong int = 0 , @i int = 0
	while @i<@n
		begin
			set @tong = @tong + @i
			set @i = @i+ 2
		end
	print @tong
	end

exec sp_bai1_3 10

---CAU 4
create procedure sp_bai1_4 @a int ,@b int 
as
begin
	
	while (@a != @b)
		begin
			if (@a > @b)
				set	@a  = @a - @b
			else 
				set @b = @b - @a
		end
		return @a	
end
declare @c int
exec @c = sp_bai1_4 30,40
print @c 

----------BAI 2------------
--------------------------
----CAU 1
create procedure bai2_1 @MANV varchar(3)
as
begin
select *
from NHANVIEN 
where MANV = @MANV
end
exec bai2_1 '001'

--CAU 2
create procedure bai2_2 @MADA varchar(3)
as
begin
select count(MANV) as 'So luong nhan vien tham gia',MADA, TENPHG from NHANVIEN
inner join PHONGBAN on NHANVIEN.PHG =PHONGBAN.MAPHG
inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
where MADA = @MADA
group by TENPHG,MADA
end
exec bai2_2 10

--- CAU 3
create procedure bai2_3 @MADA varchar(3), @Ddiem_DA varchar(15)
as
begin
select count(MANV) as 'So luong nhan vien tham gia',MADA, DEAN.DDIEM_DA from NHANVIEN
inner join PHONGBAN on NHANVIEN.PHG =PHONGBAN.MAPHG
inner join DEAN on DEAN.PHONG = PHONGBAN.MAPHG
where MADA = @MADA and DDIEM_DA =@Ddiem_DA
group by MADA,DDIEM_DA
end
exec bai2_3 2, N'Nha Trang'

---- CAU 4
create procedure bai2_4 @MaTP varchar(5)
as
begin
select HONV,TENNV,TENPHG,NHANVIEN.MANV,THANNHAN.* from NHANVIEN
inner join PHONGBAN on PHONGBAN.MAPHG= NHANVIEN.PHG 
left outer join THANNHAN  on THANNHAN.MA_NVIEN= NHANVIEN.MANV
where THANNHAN.MA_NVIEN is null and TRPHG= @MaTP
end
exec bai2_4 '006'

---- CAU 5
create procedure bai2_5 @MaNV varchar(5),@MaPB varchar(5)
as
begin
if exists (select *from NHANVIEN where MANV=@MaNV and PHG =@MaPB)
	print 'Nhan vien ' +@MaNV +' co trong phong ban: '+ @MaPB
else 
	print 'Nhan vien ' +@MaNV +' ko co trong phong ban: '+ @MaPB
end
exec bai2_5 '001','4'

------------------BAI 3 -------------
---------CAU 1------------

create proc ThemPhongBanMoi
	@TenPhg nvarchar(20),@MaPhg int,@TrPhg nvarchar(10), @Ng_NhanChuc date
as
begin
	if exists(select * from PHONGBAN where MAPHG = @MAPHG)
	begin
		print('Mã phòng ban đã tồn tại');
		return;
	end
	Insert into PHONGBAN(TENPHG,MAPHG,TRPHG,NG_NHANCHUC)
	Values
		(@TenPhg,@MaPhg,@TenPhg,@Ng_NhanChuc);
end
exec ThemPhongBanMoi 'IT','15','007','20-10-2012'

-------CAU 2--------
create proc sp_CapNhatPhongBan
	@OldTenPHG nvarchar(15),
	@TenPHG nvarchar(15),
	@MaPHG int,
	@TRPHG nvarchar(10),
	@NG_NHANCHUC date
as
begin
	UPDATE PHONGBAN
	SET 
		TENPHG =@TENPHG,
		MAPHG = @MAPHG,
		TRPHG = @TRPHG,
		NG_NHANCHUC=@NG_NHANCHUC
		where TENPHG = @OldTenPHG;
end
exec sp_CapNhatPhongBan 'CNTT','IT','10','005','1-1-2020'

----------------------------CAU 3--------------
create proc sp_insertNV @Ho nvarchar(15),@tenNV nvarchar(15),@MaNV nvarchar(9),
@NgaySinh datetime,@diachi nvarchar(30),@phai nvarchar(3),@luong float,@Ma_NQL nvarchar(9),@PHG int
as
begin
	if not exists(select * from PHONGBAN where TENPHG like 'IT')
	begin
		print 'NHAN VIEN phai la phong IT'
	return
end
if @luong < 25000
set @Ma_NQL='009'
else
begin
set @Ma_NQL = '005'
end
declare @age int = datediff(YEAR,@ngaySinh,getDate())
if(@phai like 'nam' and @age > 65 and @age <18)
begin
print 'nam phai tu 18 - 65 '
return 
end
else if(@phai like N'Nữ' and @age > 60 and @age < 18)
begin
print 'nu phai tu 18-60'
return 
end
insert into NHANVIEN(HONV,TENLOT,TENNV,MANV,NGSINH,DCHI,PHAI,LUONG,MA_NQL,PHG)
values(@Ho,@tenNV,@MaNV,@NgaySinh,@diachi,@phai,@luong,@Ma_NQL,@PHG)
end
