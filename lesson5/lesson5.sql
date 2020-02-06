-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.




DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    created_at DATETIME,
    update_at DATETIME
);
INSERT INTO users(firstname) VALUES
  ('игорь'),
  ('Слава'),
  ('Паша'),
  ('Лена'),
  ('Олег');

 
INSERT INTO users(firstname, created_at, update_at) VALUES
  ('игорь', NOW(), NOW()),
  ('Слава', NOW(), NOW()),
  ('Паша', NOW(), NOW()),
  ('Лена', NOW(), NOW()),
  ('Олег', NOW(), NOW());
  
 
-- ////////////////////////////////////////////////


  /*
 Таблица users была неудачно спроектирована. 
 Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10".
 Необходимо преобразовать поля к типу DATETIME,
 сохранив введеные ранее значения.
 */
 
use dota;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(50),
    created_at VARCHAR(100),
    updated_at VARCHAR(100)
);


INSERT INTO users(firstname, created_at, updated_at) VALUES
  ('игорь', '22.11.2018 8:10', '20.10.2020 8:10'),
  ('Слава', '10.09.2019 8:10', '20.10.2020 8:10'),
  ('Паша', '02.10.2014 10:10', '20.10.2020 8:10'),
  ('Лена', '20.08.2017 9:10', '20.10.2020 8:10'),
  ('Олег', '20.07.2016 8:10', '20.10.2020 8:10');
  


UPDATE users set created_at=STR_TO_DATE(created_at, '%d.%m.%Y %H:%i'), updated_at=STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i');
ALTER TABLE users MODIFY created_at DATETIME, MODIFY updated_at DATETIME;
 
 -- ///////////////////////////////////////////
 
/*
В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, 
 чтобы они выводились в порядке увеличения значения value. Однако,
  нулевые запасы должны выводиться в конце, после всех записей.
*/

use dota;

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';


INSERT INTO storehouses_products(product_id, storehouse_id, value) VALUES
  (1, 2, 4),
  (1, 6, 3),
  (2, 8, 0),
  (4, 3, 1),
  (3, 4, 0),
  (3, 5, 4);

select * from storehouses_products order by if(value = 0, 1, 0), value;

 