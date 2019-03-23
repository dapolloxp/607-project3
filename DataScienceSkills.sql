drop schema if exists datascientists;
 
CREATE DATABASE datascientists;
 
use datascientists;
drop table if exists person;
drop table if exists skills;
drop table if exists company;
drop table if exists school;
drop table if exists person_skills;
 
CREATE TABLE person (
personid int NOT NULL auto_increment primary key,
title nchar(50),
name nchar(50) NOT NULL,
education nchar(50)
);

CREATE TABLE skills (
skillid int NOT NULL auto_increment primary key,
skillname nchar(50) NOT NULL
);

CREATE TABLE person_skills (
personid int NOT NULL references person(personid),
skillid int NOT NULL references skills(skillid),
CONSTRAINT person_skill primary key(personid, skillid)
);

insert into person(name, title, education) 
VALUES
("Cassie Kozyrkov", "Chief Decision Scientist", "PhD"); #1

insert into skills(skillname)
VALUES
("Python"),
("R"),
("SQL");

delete from skills where skillid = 384;
select * from person;
select * from skills;

select * from skills;

insert into person_skills(personid, skillid)
VALUES
(1,1),
(1,2),
(1,3);
select * from person_skills;




select p.name, s.skillname from person as p
join person_skills as ps
on p.personid = ps.personid
join skills as s
on ps.skillid = s.skillid
where p.personid = 17;

select * from person_skills;
select * from users;
select * from movies;
select * from movierating;
select u.username,m.title, mr.rating, mr.review from users as u
join users_movierating as umr on u.userid = umr.userid
join movierating as mr on umr.movieratingid = mr.movieratingid
join movies as m on mr.movieid = m.movieid;


select u.username, u.firstname, u.lastname, m.title, m.category, m.length, mr.rating, mr.review from users as u
join users_movierating as umr on u.userid = umr.userid
join movierating as mr on umr.movieratingid = mr.movieratingid
join movies as m on mr.movieid = m.movieid;