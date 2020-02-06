/*i. Заполнить все таблицы БД vk данными (по 10-100 записей в каждой таблице)
ii. Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке
iii. Написать скрипт, отмечающий несовершеннолетних пользователей как неактивных (поле is_active = false).
 Предварительно добавить такое поле в таблицу profiles со значением по умолчанию = true (или 1)
iv. Написать скрипт, удаляющий сообщения «из будущего» (дата позже сегодняшней)
*/

USE vk;

SELECT distinct firstname FROM users
ORDER BY firstname;
-- как мне вывести всю таблицу с этими же параметрами?


-- ALTER TABLE profiles ADD  COLUMN  is_active BIT DEFAULT b'1';
-- ALTER TABLE profiles drop COLUMN is_active;


ALTER TABLE profiles ADD COLUMN  is_active BIT DEFAULT b'1';

-- как сделать проверку на существование колонки?

-- SELECT count(COLUMN_NAME) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_SCHEMA = 'vk' AND TABLE_NAME = 'profiles' AND COLUMN_NAME ='is_active' ;


UPDATE profiles
 set is_active=0
 WHERE 18 > TIMESTAMPDIFF(YEAR, birthday, CURDATE());

DELETE FROM messages
WHERE created_at > CURDATE();

