-- distinct
select distinct department from products;
select count(distinct department) from products;
select distinct department, name from products; -- gets unique department and name combinations
