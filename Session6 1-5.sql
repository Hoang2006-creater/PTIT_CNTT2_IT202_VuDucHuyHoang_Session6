create database session6;
use session6;

-- Bài 1:
create table customers(
customer_id int primary key ,
full_name varchar(255) not null,
city varchar(255) not null
);

create table orders(
	order_id int primary key,
    order_date date,
    status enum('pending','completed','cancelled'),
    customer_id int not null,
    foreign key (customer_id) references customers(customer_id)
);

insert into customers values
	(1, 'Nguyen Van An', 'Ha Noi'),
	(2, 'Tran Thi Binh', 'Ho Chi Minh'),
	(3, 'Le Van Cuong', 'Da Nang'),
	(4, 'Pham Thi Dao', 'Can Tho'),
	(5, 'Hoang Van Em', 'Hai Phong');

insert into orders values 
(101, '2025-01-01', 'pending', 1),
(102, '2025-01-02', 'completed', 2),
(103, '2025-01-03', 'cancelled', 3),
(104, '2025-01-04', 'completed', 1),
(105, '2025-01-05', 'pending', 4);

select customers.full_name, orders.order_id as MaDon
from customers 
inner join orders on customers.customer_id =orders.customer_id;

select 
	customers.customer_id,
	customers.full_name,
    count(orders.order_id) as SoDonHang
    from customers
    left join orders on customers.customer_id = orders.customer_id
     group by customers.customer_id,customers.full_name;
   
    select 
	customers.customer_id,
	customers.full_name,
    count(orders.order_id) as SoDonHang
    from customers
    left join orders on customers.customer_id = orders.customer_id
	group by customers.customer_id,customers.full_name
    having count(orders.order_id)>0; 

-- Bài 2:
alter table orders
add total_amount decimal(10,2);

UPDATE orders SET total_amount = 10000 WHERE order_id = 101;
UPDATE orders SET total_amount = 25000 WHERE order_id = 102;
UPDATE orders SET total_amount = 40000 WHERE order_id = 103;
UPDATE orders SET total_amount = 15000 WHERE order_id = 104;
UPDATE orders SET total_amount = 29000 WHERE order_id = 105;

select 
	customers.customer_id,
    customers.full_name,
    sum(orders.total_amount) as TongTienDon
    from customers
    left join orders on customers.customer_id=orders.customer_id
    group by customers.customer_id,customers.full_name
	having count(orders.order_id)>0; 

select 
	customers.customer_id,
    customers.full_name,
    max(orders.total_amount) as DonHangCaoNhat
    from customers
    left join orders on customers.customer_id=orders.customer_id
    group by customers.customer_id,orders.customer_id
	having count(orders.order_id)>0; 

select 
	customers.customer_id,
    customers.full_name,
	sum(orders.total_amount) as TongTienDon
    from customers
    left join orders on customers.customer_id=orders.customer_id
    group by customers.customer_id,orders.customer_id
	having count(orders.order_id)>0
    order by TongTienDon desc;

-- Bài 3:
select 
    orders.order_date,sum(orders.total_amount) as TongDoanhThu
    from orders
    where status ='completed'
    group by orders.order_date;
		
select 
	orders.order_date,
    count(orders.order_id) as SoLuongDonHang
    from orders
    where status ='completed'
    group by orders.order_date;

select 
	orders.order_date,
    sum(orders.total_amount) as TongDoanhThu
    from orders
    where status ='completed'
    group by orders.order_date
    having sum(orders.total_amount) >10000000;
    
-- Bài 4:
create table products (
	product_id int primary key,
    product_name varchar(255) not null ,
    price decimal(10,2) not null
);

create table order_items(
	order_id int primary key,
	quantity int not null,
    product_id int not null,
    foreign key (product_id) references products(product_id)
);

insert into products values 
	(1, 'Laptop Dell', 15000000),
	(2, 'Laptop HP', 14500000),
	(3, 'Chuột Logitech', 350000),
	(4, 'Bàn phím cơ', 1200000),
	(5, 'Màn hình Samsung', 4500000),
	(6, 'Tai nghe Sony', 1800000),
	(7, 'USB Kingston 32GB', 250000),
	(8, 'Ổ cứng SSD 512GB', 2200000),
	(9, 'Webcam Logitech', 900000),
	(10, 'Loa Bluetooth JBL', 1600000);
    
INSERT INTO order_items (order_id, quantity, product_id) VALUES
(101, 1, 1),
(102, 2, 3),
(103, 1, 5),
(104, 3, 7),
(105, 1, 2),
(106, 2, 4),
(107, 1, 6),
(108, 4, 7),
(109, 1, 8),
(110, 2, 10);

select products.product_id ,
		products.product_name,
        order_items.quantity as SanPham
from products
inner join order_items on products.product_id=order_items.product_id;

select products.product_id ,
		products.product_name,
        sum(products.price * order_items.quantity) as DoanhThu
from products
inner join order_items on products.product_id=order_items.product_id
group by products.product_id,products.product_name;

select products.product_id ,
		products.product_name,
        sum(products.price * order_items.quantity) as DoanhThu
from products
inner join order_items on products.product_id=order_items.product_id
group by products.product_id,products.product_name
having DoanhThu >5000000;

-- Bài 5:
SELECT 
    customers.customer_id,
    customers.full_name,
    COUNT(orders.order_id) AS TongSoDonHang,
    SUM(orders.total_amount) AS TongTienDaChi,
    AVG(orders.total_amount) AS GiaTriDonHangTrungBinh
FROM customers 
JOIN orders 
    ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.full_name
HAVING 
    COUNT(orders.order_id) >= 3
    AND SUM(orders.total_amount) > 1000000
ORDER BY TongTienDaChi DESC;

