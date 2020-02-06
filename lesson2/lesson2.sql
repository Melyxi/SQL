
 -- 1)Установите СУБД MySQL. Создайте в домашней директории файл .my.cnf, задав в нем логин и пароль, который указывался при установке
 -- установил mysql
 -- .my.chf

[client]
user=root
password=123123

-- 2)Создайте базу данных example, разместите в ней таблицу users,
--   состоящую из двух столбцов, числового id и строкового name.
create database if not exists example;
use example;
DROP TABLE IF EXISTS users;
create table users (
	id SERIAL primary key,
	name VARCHAR(255)
);

insert ignore into users values
	(default, '�����'),
	(default, '�����'),
	(default, '�����');

select * from users;

-- 3) Создайте дамп базы данных example из предыдущего задания, 
-- разверните содержимое дампа в новую базу данных sample.
create database if not exists sample;
-- с консоли
mysqldump example > num.sql
mysql sample < num.sql

