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