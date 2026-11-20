-- aggregate functions - count(), sum(), max(), min(), avg()
select contents from comments group by user_id;
select max(id) from comments;
select avg(id) from comments;
select sum(id) from comments;
select sum(id), id from comments;
select user_id,max(id) from comments group by user_id;
select user_id,count(id) as num_comments_created from comments group by user_id;
select count(user_id) from photos; -- does not count NULL values
select count(*) from photos; -- counts all rows, including rows with NULL values
select user_id, count(*) from comments group by user_id;

-- finding the number of comments on each photo
select photo_id, count(*) from comments group by photo_id;

-- join coding exercise: finding the number of books written by each author
-- select name, count(*) from books join authors on authors.id=books.author_id group by authors.name;

-- having clause: finding photos with more than 2 comments where photo_id is less than 3
select photo_id, count(*) from comments where photo_id<3 group by photo_id having count(*)>2;

-- finding users who commented on the first 50 photos and added more than 20 comments
select user_id, count(*) from comments where photo_id<50 group by user_id having count(*)>20;
