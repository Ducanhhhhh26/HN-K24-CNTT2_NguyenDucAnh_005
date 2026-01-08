drop database if exists HACKATHON;
create database HACKATHON;
use HACKATHON;


create table Creator(
	creator_id varchar(5) primary key,
    creator_name varchar(100) not null,
    creator_email varchar(100) not null unique,
    creator_phone varchar(15) not null unique,
    creator_platform varchar(50) not null
);
create table Studio(
	studio_id varchar(5) primary key,
    studio_name varchar(100) not null,
    studio_location varchar(100) not null,
    hourly_price decimal(10,2) not null,
    studio_status varchar(20) not null
);
create table LiveSession(
	session_id int primary key auto_increment,
    creator_id varchar(5) not null,
    studio_id varchar(5) not null,
    session_date date not null,
    duration_hours int not null,
    foreign key(creator_id) references Creator(creator_id),
    foreign key(studio_id) references Studio(studio_id)
);
 
 create table Payment(
	payment_id int primary key auto_increment,
    session_id int not null,
    payment_method varchar(50) not null,
    payment_amount decimal(10,2) not null,
    payment_date date not null,
    foreign key(session_id) references LiveSession(session_id)
 );
 
 insert into Creator(creator_id, creator_name, creator_email,creator_phone,creator_platform) values
 ('CR01','Nguyen Van A','a@live.com','0901111111','Tiktok'),
 ('CR02','Tran Thi B','b@live.com','0902222222','Youtube'),
 ('CR03','Le Minh C','c@live.com','0903333333','Facebook'),
 ('CR04','Pham Thi D','d@live.com','0904444444','Tiktok'),
 ('CR05','Vu Hoang E','e@live.com','0905555555','Shopee live');

 insert into Studio(studio_id,studio_name,studio_location,hourly_price,studio_status) values
 ('ST01','Studio A', 'Ha Noi','20.00','Available'),
 ('ST02','Studio B', 'HCM','25.00','Available'),
 ('ST03','Studio C', 'Da Nang','30.00','Booked'),
 ('ST04','Studio D', 'Ha Noi','22.00','Available'),
 ('ST05','Studio E', 'Can Tho','18.00','Maintenance');
 
 insert into LiveSession(session_id,creator_id,studio_id,session_date,duration_hours) values 
 (1,'CR01','ST01','2025-05-01','3'),
 (2,'CR02','ST02','2025-05-02','4'),
 (3,'CR03','ST03','2025-05-03','2'),
 (4,'CR01','ST04','2025-05-04','5'),
 (5,'CR05','ST02','2025-05-01','1');
 
 insert into Payment(payment_id,session_id,payment_method,payment_amount,payment_date) values 
 (1,1,'Cash','60.00','2025-05-01'),
 (2,2,'Credit Card','100.00','2025-05-02'),
 (3,3,'Bank Transfer','60.00','2025-05-03'),
 (4,4,'Credit Card','60.00','2025-05-04'),
 (5,5,'Cash','25.00','2025-05-05');
 
 
 -- Cập nhật và xóa dữ liệu
 -- Cập nhật creator_platform của creator CR03 thành "YouTube"
	UPDATE Creator 
	set creator_platform = 'YouTube'
	where creator_id = 'CR03';
 -- Do studio ST05 hoạt động trở lại, cập nhật studio_status = 'Available' và giảm hourly_price 10%
	UPDATE Studio
    set studio_status = 'Available', hourly_price = hourly_price - 0.1
    where studio_id = 'ST05';
 -- Xóa các payment có payment_method = 'Cash' và payment_date trước ngày 2025-05-03
	DELETE from Payment
    where payment_method = 'Cash' and payment_date < '2025-05-03';
    
    --  TRUY VẤN DỮ LIỆU CƠ BẢN
    -- 1: Liệt kê studio có studio_status = 'Available' và hourly_price > 20
		select * from Studio
		where studio_status = 'Available' and hourly_price > 20;
	-- 2: Lấy thông tin creator (creator_name, creator_phone) có nền tảng là TikTok
		select creator_name'Tên nhà sáng tạo', creator_phone'Số điện thoại nhà sáng tạo' from creator 
        where creator_platform = 'Tiktok';
        
       
	-- 3: Hiển thị danh sách studio gồm studio_id, studio_name, hourly_price sắp xếp theo giá thuê giảm dần
		 select studio_id'ID Studio', studio_name'Tên studio', hourly_price'Giá live mỗi giờ' 
         from Studio
         order by hourly_price desc;
	-- 4: Lấy 3 payment đầu tiên có payment_method = 'Credit Card'
		select * from Payment 
        where payment_method = 'Credit Card'
        limit 3 offset 0;
    -- 5: Hiển thị danh sách creator gồm creator_id, creator_name bỏ qua 2 bản ghi đầu và lấy 2 bản ghi tiếp theo
		select creator_id, creator_name from Creator
        limit 2 offset 2;
        
        -- Truy vấn nâng cao
        -- 1: Hiển thị danh sách livestream gồm: session_id, creator_name, studio_name, duration_hours, payment_amount
        select ls.session_id, ls.creator_id, ls.duration_hours, p.payment_amount from LiveSession ls
        join Payment p on ls.session_id = p.session_id;
        
        -- 2: Liệt kê tất cả studio và số lần được sử dụng (kể cả studio chưa từng được thuê)
		select s.studio_id,s.studio_name,s.studio_location,s.hourly_price,s.studio_status from studio s
        left join LiveSession ls on s.studio_id = ls.studio_id;

        -- 3: Tính tổng doanh thu theo từng payment_method
        
        select payment_method'Phương thức thanh toán', sum(payment_amount)  from payment p
        group by payment_method;
        
        -- 4: Thống kê số session của mỗi creator chỉ hiển thị creator có từ 2 session trở lên
        select c.creator_id, count(ls.session_id)'Session' from creator c
        join LiveSession ls on c.creator_id = ls.creator_id
        group by c.creator_id 
        having(Session >= 2);
        
        -- 5: Lấy studio có hourly_price cao hơn mức trung bình của tất cả studio
        select * from studio
        where hourly_price >  (select avg(hourly_price)'AVG' from studio);
       
        -- 6: Hiển thị creator_name, creator_email của những creator đã từng livestream tại Studio B
        
        select creator_name, creator_email from creator c
        join LiveSession ls on c.creator_id = ls.creator_id
		join Studio s on ls.studio_id = s.studio_id
        where s.studio_name = 'Studio B';
        
        -- 7: Hiển thị báo cáo tổng hợp gồm: session_id, creator_name, studio_name, payment_method, payment_amount
        select ls.session_id,c.creator_name,s.studio_name,p.payment_method,p.payment_amount from LiveSession ls
        join Creator c on ls.creator_id = c.creator_id
        join Studio s on ls.studio_id = s.studio_id
        join Payment p on ls.session_id = p.session_id;
        
        
        