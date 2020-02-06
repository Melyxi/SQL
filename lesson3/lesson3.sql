

-- 1)Написать крипт, добавляющий в БД vk, которую создали на занятии, 
-- 3 новые таблицы (с перечнем полей, указанием индексов и внешних ключей)

DROP TABLE IF EXISTS friends;
CREATE TABLE friends (
	user_id BIGINT UNSIGNED NOT NULL,
	friend_id BIGINT UNSIGNED NOT NULL,
	`status` ENUM('colleague', 'school_friend', 'best_friend'), -- можно ли статус оставить без значения?
	-- что бы по дефолту был null
	
	PRIMARY KEY (user_id, fried_id), 
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (friend_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS subscribers;
CREATE TABLE subscribers (
	user_id BIGINT unsigned NOT NULL,
	subscribers_id BIGINT unsigned NOT NULL,
	
	PRIMARY KEY (user_id, subscribers_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (subscribers_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS load_music;
CREATE TABLE load_music (
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	genre ENUM('rock', 'rap', 'punk', 'metal'),
	data_load DATETIME DEFAULT NOW()
	
);

DROP TABLE IF EXISTS music;
CREATE TABLE music (
	user_id BIGINT unsigned NOT NULL,
	music_id BIGINT unsigned NOT NULL,
	
	PRIMARY KEY (user_id, music_id),
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (music_id) REFERENCES load_music(id)
);