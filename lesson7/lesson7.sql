
/*
1) Составьте список пользователей users, 
которые осуществили хотя бы один заказ orders в интернет магазине.
*/

INSERT into users 
	(name, birthday_at)
VALUES   
  ('Антон', '1992-12-05'),
  ('Елена', '1974-11-12'),
  ('Александр', '1945-05-20'),
  ('Олег', '1980-06-15'),
  ('Михаил', '1978-01-11'),
  ('Дмитрий', '1932-08-29');


INSERT into orders 
	(user_id) 
VALUES   
	(1),
	(2),
	(5),
	(3),
	(2),
	(5),
	(1),
	(2)
	;


SELECT * FROM users U
WHERE EXISTS(SELECT 1 FROM orders WHERE user_id = U.id);

-- второй способ 
SELECT * 
from   (SELECT u.*
		from users u 
		right join orders o
		on u.id = o.user_id) as k
GROUP by id;


-- 2) Выведите список товаров products и разделов catalogs,
-- который соответствует товару.

SELECT  P.name AS product_name
       ,C.name AS catalog_name
FROM products P
INNER JOIN catalogs C on C.id = P.catalog_id;

/*
3) (по желанию) Пусть имеется таблица рейсов flights (id, from, to) 
и таблица городов cities (label, name).
Поля from, to и label содержат английские названия городов, 
поле name — русское. Выведите список рейсов flights 
с русскими названиями городов.
*/

DROP TABLE if exists flights; 
CREATE table flights (
	id SERIAL PRIMARY KEY,
	`from` varchar(30) NOT NULL,
	`to` varchar(30) NOT NULL
);

INSERT INTO flights (`from`, `to`) VALUES
  ('moscow', 'omsk'),
  ('novgorod', 'kazan'),
  ('irkutsk', 'moscow'),
  ('omsk', 'irkutsk'),
  ('moscow', 'kazan');


DROP TABLE if exists cities; 
CREATE table cities (
	`label` varchar(30) PRIMARY KEY,
	`name` varchar(30) NOT NULL
);

INSERT INTO cities(label, name) VALUES
  ('moscow', 'москва'),
  ('irkutsk', 'иркутск'),
  ('novgorod', 'новгород'),
  ('kazan', 'казань'),
  ('omsk', 'омск');

 
ALTER TABLE flights
ADD CONSTRAINT fk_from
FOREIGN KEY (`from`)
REFERENCES cities (label)
ON DELETE CASCADE
ON UPDATE CASCADE;


ALTER TABLE flights
ADD CONSTRAINT fk_to
FOREIGN KEY (`to`)
REFERENCES cities (label)
ON DELETE CASCADE
ON UPDATE CASCADE;



SELECT C.name AS `from`, C1.name as `to`
FROM flights F
INNER JOIN cities C ON C.label = F.`from`
INNER JOIN cities C1 ON C1.label = F.`to`
ORDER BY F.id
