-- subquery
-- products more expensive than all products in Toys
select name, price from products where price>(select max (price) from products where department ='Toys');

-- query shapes
select * from orders; -- many rows and columns
select id from orders; -- many rows, one column
select count(*) from orders; -- one row, one column

-- subquery in select
select name, price,(select max(price) from products)  from products where price  > 867;
select name, price,(select price from products where id=3)as id_3_price from products where price > 867;
select name, price_weight_ratio from(select name, price/weight as price_weight_ratio from products)as p where price_weight_ratio >5;

-- average orders per user
select avg(order_count) from (select user1_id, count(*) as order_count from orders group by user1_id )as p;

-- subquery in join
select user1_id from orders where product_id=3;
select first_name from users1 join (select user1_id from orders where product_id=3) as o on o.user1_id=users1.id;

-- subquery in where
select id from orders where product_id in (select id from products where price/weight>50);

-- products above average price
select name ,price from products where price >(select avg(price) from products);

-- products not in departments with products below 100
select name, department from products where department not in( select department from products where price<100);

-- using all, any and some
select name, department, price from products where price >all (select price from products where department='Indusrtial');

-- products more expensive than at least one Industrial product
select name, department, price from products where price >=any (select price from products where department='Indusrtial');

-- most expensive product in each department
select name, department, price from products as p1  where p1.price = (select max(price) from products as p2 where p2.department = p1.department);

-- counting orders without join or group by
select p1.name, (select count(*) from orders as o1 where o1.product_id=p1.id)as num_orders from products as p1;

-- select without from
select(select max(price) from products)/(select avg(price) from products); -- calculation using single values
