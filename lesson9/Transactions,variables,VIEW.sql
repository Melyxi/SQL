/*
 1) В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. 
 Используйте транзакции.
 */

START TRANSACTION;
SELECT * from shop.users WHERE id = 1;
SELECT * from sample.users;
INSERT into sample.users(name) values((select name from shop.users WHERE id = 1));
DELETE FROM shop.users WHERE id = 1;
COMMIT;



-- INSERT into shop.users(id, name, birthday_at ) values(1, 'Коля', '1999-10-2');
-- select name from shop.users WHERE id = 1;
-- select name from shop.users WHERE id = 1;

/*
 Создайте представление, которое выводит название name товарной позиции
 из таблицы products и соответствующее название каталога 
 name из таблицы catalogs.
 */
use shop;

DROP VIEW IF EXISTS shop.new_product;
CREATE VIEW new_product AS
	SELECT P.name, 
		   C.name as name_catalog
	from products P
	inner join catalogs C
	on P.catalog_id = C.id;
SELECT * from new_product;

show tables;

/*
по желанию) Пусть имеется таблица с календарным полем created_at.
В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', 
'2018-08-16' и 2018-08-17. Составьте запрос, который выводит полный список дат за август, 
выставляя в соседнем поле значение 1, если дата присутствует в исходном таблице и 0, если она отсутствует.
*/

/*
drop table if exists `month`;
CREATE table `month`(
	num INT NOT null,
	is_month INT
);
*/

DELIMITER //
DROP PROCEDURE IF EXISTS  create_month//
CREATE PROCEDURE create_month()
BEGIN
	DECLARE i INT DEFAULT 1;

	drop table if exists `month`;
	CREATE table `month`(
	num INT NOT null,
	is_month INT
	);
	
  WHILE i <= 31 DO
	INSERT INTO `month`(num, is_month) VALUES(i, 0);
	SET i = i + 1;
  END WHILE;
END//

CALL create_month//


UPDATE `month`, (SELECT if((created_at like '2018-08%'), DATE_FORMAT(created_at, '%e'), 0)  as is_ag
from users) as new_t
SET is_month = 1
WHERE `month`.num = new_t.is_ag

SELECT * FROM `month`;

/*
Создайте хранимую функцию hello(), которая будет возвращать приветствие, 
в зависимости от текущего времени суток. 
С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/

DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello()
RETURNS TEXT DETERMINISTIC
BEGIN
  CASE format
	WHEN  '06:00:00' < DATE_FORMAT(now(), '%H:%i:%s') < '12:00:00'  THEN
		RETURN 'Доброе утро';
  	
	WHEN '12:00:00' < DATE_FORMAT(now(), '%H:%i:%s') < '18:00:00' THEN
  		RETURN 'Добрый день';
  
	WHEN '18:00:00' < DATE_FORMAT(now(), '%H:%i:%s') < '00:00:00' THEN
  		RETURN 'Добрый вечер';
	ELSE
		RETURN 'Доброй ночи';
  END CASE;
END
	
CALL hello()//


/*
2)В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
 Допустимо присутствие обоих полей или одно из них. 
 Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
 Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
 При попытке присвоить полям NULL-значение необходимо отменить операцию.*/

DELIMITER //
DROP TRIGGER IF EXISTS not_null;
CREATE TRIGGER not_null BEFORE UPDATE ON products
FOR EACH ROW
BEGIN
  IF ((NEW.name is NULL) and (NEW.description is NULL)) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'не может быть NULL NULL';
  ELSE
	set NEW.name = NEW.name;
	set NEW.description = NEW.description;
  END IF;
END//


DROP TRIGGER IF EXISTS not_null;
CREATE TRIGGER not_null BEFORE insert ON products
FOR EACH ROW
BEGIN
  DECLARE mysig condition FOR SQLSTATE '45000';
  IF ((NEW.name is NULL) and (NEW.description is NULL)) THEN
    SIGNAL mysig';
  ELSE
	set NEW.name = NEW.name;
	set NEW.description = NEW.description;
  END IF;
END//

  
 
 /*
 3)(по желанию) Напишите хранимую функцию для вычисления произвольного числа Фибоначчи. 
 Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел. 
 Вызов функции FIBONACCI(10) должен возвращать число 55.*/


DROP FUNCTION IF EXISTS FIBONACCI; 
CREATE FUNCTION FIBONACCI(n INT)
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE p1 INT DEFAULT 1;
    DECLARE p2 INT DEFAULT 1;
    DECLARE i INT DEFAULT 2;
    DECLARE res INT DEFAULT 0;
   
    IF (n <= 1) THEN RETURN n;
    ELSEIF (n = 2) THEN RETURN 1;
    END IF;  
    WHILE i < n DO
        SET i = i + 1;
	SET res = p2 + p1;
        SET p2 = p1;
        SET p1 = res;
    END WHILE;
    RETURN res;
 END//
 

