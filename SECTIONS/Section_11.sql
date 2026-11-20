-- greatest function
select greatest(20,10,30);

-- shipping cost
select name, weight, greatest(30,2*weight) from products; -- comparing shipping cost with 30

-- least function
select least(20,30,10);

-- sale price
select name, price, least(price*0.5,400) from products;

-- case statement
select name, price, case
    when price>600 then 'high'
    when price>300 then 'medium'
    else 'cheap'
end
from products;
