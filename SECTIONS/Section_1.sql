-- create a table cities with column names and datatypes
create table cities(
name varchar(50), country varchar(50),
population int , area int
);

-- insert values into the table using the values keyword (single quotes for strings)
insert into cities (name, country, population, area) values('Tokyo','Japan',38505000, 8223); -- can also insert all details directly after values
insert into cities (name, country, population, area) values('India','Delhi',28125000, 2240); -- entered country name instead of city name by mistake
insert into cities (name,country,population, area) values ('Shanghai','China',2215000, 4015);
insert into cities (name,country,population, area) values ('Sao Paulo','Brazil',20935000, 3043);

select * from cities;

update  cities set name= 'Delhi' where name = 'India' ; -- correcting the city name
update  cities set country= 'India' where country = 'Delhi' ; -- correcting the country name

select name, country from cities;

select name, population/area as population_density from cities; -- calculating population density and giving the new column a name

-- using string operators and functions
select name|| ','|| country as location from cities; -- joining two strings using concatenation
select concat(name,',',country) as location from cities; -- same result using concat function
select concat(upper(name),',',upper(country)) as location from cities; -- converting both names to uppercase using upper()
select upper(concat(name, ', ', country)) as location from cities; -- using upper() on the concatenated result
