-- sorting records
select * from products order by price; -- sorting products by price in ascending order (default)
select * from products order by price desc; -- sorting products by price in descending order
select * from products order by name; -- sorting products alphabetically by name
select * from products order by price,weight; -- sorting by price first and then by weight

-- using offset and limit
select * from users1 offset 40; -- skipping the first 40 rows
select * from users1 limit 5; -- displaying only the first 5 rows
select * from products order by price desc limit 5 offset 1; -- getting the 5 most expensive products after skipping the highest-priced one
