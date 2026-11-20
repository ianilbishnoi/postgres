-- creating a primary key to uniquely identify each user
create table users(id SERIAL primary key, username varchar(50));

insert into users (username) values ('monahan93'),('pferrer'),('si93onis'),('99stroman');
select * from users;

create table photos (id SERIAL primary key, url varchar(200), user_id int references users(id));

insert into photos (url,user_id) values ('https://one.jpg',4);
select * from photos;

-- running queries on related data
insert into photos(url, user_id) values('https://two.jpg',1),('https://25.jpg',1),('https://36.jpg',1),('https://754.jpg',2),('https://35.jpg',3),('https://256.jpg',4);
select * from photos;

-- finding all photos uploaded by the user with ID 4
select * from photos where user_id=4;

-- displaying photos along with the username of the user
select url, username from photos join users on users.id=photos.user_id;

-- delete statement
delete from users where id=1;

drop table photos; -- deleting the entire table

-- deleting a user who has related records in another table will cause a foreign key error
-- the foreign key constraint prevents deleting a user who is still referenced by photos
-- this helps maintain data integrity by ensuring every photo is linked to a valid user
