-- filtering rows using where
select name ,area from cities where area>4000;
select name, area from cities where area between 2000 and 4000; -- using between to check a range
select name, area from cities where name in ('Delhi','Shanghai'); -- getting details of cities in this list
select name, area from cities where area not in (3043,8223) or name='Delhi'; -- checking multiple conditions
select name, population/area as population_density from cities where population/area>6000; -- using mathematical operations in where condition
update cities set population= 39505000 where name='Tokyo'; -- updating the population of a city
delete from cities where name='Tokyo'; -- deleting a row from the table
