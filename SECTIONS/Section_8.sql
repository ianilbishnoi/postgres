-- union and intersection
-- finding the 4 most expensive products and the 4 products with the highest price/weight ratio
(select * from products order by price desc limit 4)union all -- includes duplicate rows
(select * from products order by price/weight desc limit 4);

-- different set operations: union, union all, intersect, intersect all, except, except all
(select * from products order by price desc limit 4)intersect all -- returns common rows, including duplicates
(select * from products order by price/weight desc limit 4);

(select * from products order by price desc limit 4)except -- returns rows present in the first query but not in the second
(select * from products order by price/weight desc limit 4);
