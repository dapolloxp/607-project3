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
education nchar(50),
degree nchar(50),
location nchar(50),
company nchar(50)
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



select distinct(skillname), skillid
FROM skills;

insert into person(name, title, education) 
VALUES
("Cassie Kozyrkov", "Chief Decision Scientist", "PhD"); #1

delete from skills where skillid = 384;
select * from person;
select * from skills;

select * from person_skills;

select * from person as p
join person_skills as ps
on p.personid = ps.personid
join skills as s
on ps.skillid = s.skillid
where s.skillid = 330;

