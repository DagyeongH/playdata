use hr_join;
-- TODO: 4개의 테이블에 어떤 값들이 있는지 확인.
select * from customers;
select * from order_items;
select * from orders;
select * from products;
select distinct category from products;


-- TODO: 주문 번호가 1인 주문의 주문자 이름, 주소, 우편번호, 전화번호 조회
select	o.order_id, c.cust_name, c.address, c.postal_code, c.phone_number
from 	customers c inner join orders o on c.cust_id = o.cust_id
where 	o.order_id = 1;

-- TODO : 주문 번호가 2인 주문의 주문일, 주문상태, 총금액, 주문고객 이름, 주문고객 이메일 주소 조회
select	o.order_date, o.order_status, o.order_total, 
		c.cust_name, c.cust_email
from 	orders o left join customers c on o.cust_id = c.cust_id
where	o.order_id = 2;

-- TODO : 고객 ID가 120인 고객의 이름, 성별, 가입일과 지금까지 주문한 주문정보중 주문_ID, 주문일, 총금액을 조회
select	c.cust_id, c.cust_name, c.gender, c.join_date,
		o.order_id, o.order_date, o.rder_total
from 	customers c left join orders o on c.cust_id = o.cust_id
where	c.cust_id = 120;

-- TODO : 고객 ID가 110인 고객의 이름, 주소, 전화번호, 그가 지금까지 주문한 주문정보중 주문_ID, 주문일, 주문상태 조회
 select	c.cust_id, cust_name, address, phone_number, order_id, order_date, order_status
 from 	customers c inner join orders o on c.cust_id = o.cust_id
 where c.cust_id = 110;

-- TODO : 고객 ID가 120인 고객의 정보와 지금까지 주문한 주문정보를 모두 조회.
select 	*
from	customers c left join orders o on c.cust_id = o.cust_id
where	c.cust_id = 120;


-- TODO : '2017/11/13'(주문날짜) 에 주문된 주문의 주문고객의 고객_ID, 이름, 주문상태, 총금액을 조회
select  c.cust_id, c.cust_name, order_status, order_total
from	customers c inner join orders o on c.cust_id = o.cust_id
where 	order_date = '2017-11-13';

-- TODO : 주문상세 ID가 xxxx(임의의 id)인 주문제품의 제품이름, 판매가격, 제품가격을 조회.
select	order_item_id, o.order_id, oi.product_id, sell_price, price
from 	order_items oi inner join orders o on oi.order_id = o.order_id
					   inner join products p on oi.product_id = p.product_id;


-- TODO : 주문 ID가 4인 주문의 주문 고객의 이름, 주소, 우편번호, 주문일, 주문상태, 총금액, 주문 제품이름, 제조사, 제품가격, 판매가격, 제품수량을 조회.
select 	c.cust_name, c.address, c.postal_code, o.order_date, o.order_status, o.order_total, 
		p.product_name, p.maker, p.price, oi.sell_price, oi.quantity
from 	orders o left join order_items oi on oi.order_id = o.order_id
				 left join products p on oi.product_id = p.product_id
				 left join customers c on o.cust_id = c.cust_id
where 	o.order_id  = 4;

-- TODO : 제품 ID가 200인 제품이 2017년에 몇개 주문되었는지 조회.
select	oi.product_id, sum(quantity) as total_quantity
from 	orders o inner join order_items oi on oi.order_id = o.order_id
				 -- inner join products p on oi.product_id = p.product_id
where	year(order_date) = 2017 and oi.product_id = 200;

-- TODO : 제품분류별 총 주문량을 조회
select	category, sum(quantity) as total_quantity
from 	order_items oi inner join orders o on oi.order_id = o.order_id
				       inner join products p on oi.product_id = p.product_id
group by category;

-- inner join이 아니라 left join을 하는 이유: inner join을 하면 팔리지 않은 카테고리는 포함되지 않음
select 	p.category,
		ifnull(sum(oi.quantity), 0) as '총 주문개수'
from	products p left join order_items oi on p.product_id = oi.product_id
group by p.category;