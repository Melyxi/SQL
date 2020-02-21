
DROP DATABASE IF EXISTS website;
CREATE DATABASE website;

USE website;

DROP TABLE IF EXISTS auth_user;
CREATE TABLE auth_user (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	`password` varchar(150) not null,
	last_login DATETIME DEFAULT NOW(), 
	username varchar(30) not NULL UNIQUE, 
	email varchar(250) not NULL UNIQUE,
	is_superuser TINYINT,
	is_active TINYINT,
	phone BIGINT,
	data_joined DATETIME DEFAULT NOW()	
);

DROP TABLE IF EXISTS profile;
CREATE TABLE profile(
	user_id SERIAL PRIMARY KEY,
	firstname varchar(40),
	lastname varchar(40),
	gender char(1),
	photo_id BIGINT UNSIGNED NULL,
	created_at DATETIME DEFAULT NOW(),
	birthday DATE,
	is_delete TINYINT,
	
	FOREIGN KEY (user_id) REFERENCES auth_user(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- создаем таблицу матчей 

DROP TABLE IF EXISTS matches;
CREATE TABLE matches(
	match_id int UNSIGNED NOT NULL UNIQUE,
	create_match DATETIME default now(),
	start_game datetime not NULL,
	stop_game datetime default 0,
	game_time datetime default 0,
	league_id varchar(255),
	team_name_radiant varchar(255) not NULL,
	team_name_dire varchar(255) not NULL,
 	team_logo_radiant INT UNSIGNED NOT NULL,
 	team_logo_dire INT UNSIGNED NOT NULL,
 	team_id_radiant INT UNSIGNED NOT NULL,
 	team_id_dire INT UNSIGNED NOT NULL,
 	sort_score int,
 	last_update_time BIGINT,
	radiant_lead int,
	radiant_score int,
	dire_score int,
	players_team1 JSON not null, -- может быть написать для каждого игрока 
	players_team2 JSON not null,
	building_state BIGINT,
	graph JSON,
	win_match varchar(100),
	
	KEY index_of_logo_id_radiant(team_logo_radiant),
	KEY index_of_logo_id_dire (team_logo_dire),
	KEY index_of_team_id_radiant (team_id_radiant),
	KEY index_of_team_id_dire (team_id_dire),
	KEY index_match_id (match_id)
	
);


-- база данных команд

DROP TABLE IF EXISTS teams;
CREATE TABLE teams(
	team_id INT UNSIGNED NOT NULL,
	name varchar(100) UNIQUE,
	logo INT UNSIGNED NOT NULL,
	logo_url varchar(255) ,  -- название файла
	
	
	
	FOREIGN KEY (logo) REFERENCES matches(team_logo_radiant),
	FOREIGN KEY (logo) REFERENCES matches(team_logo_dire),
	FOREIGN KEY (team_id) REFERENCES matches(team_id_radiant),
	FOREIGN KEY (team_id) REFERENCES matches(team_id_dire)
	
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- база данных игроков 
DROP TABLE IF EXISTS players;
CREATE TABLE players(
	player_id SERIAL PRIMARY KEY,
	name varchar(100) UNIQUE,
	rating int
);

-- таблица чатов, на каждый матч есть свой чат 

DROP TABLE IF EXISTS chat;
CREATE TABLE chat(
	chat_id SERIAL PRIMARY KEY,
	name_chat varchar(100) UNIQUE,
	chat_match_id int UNSIGNED NOT NULL UNIQUE,
	create_at DATETIME DEFAULT NOW(),
	
	-- KEY index_match_id (match_id)
	FOREIGN KEY (chat_match_id) REFERENCES matches(match_id)
	
);

-- таблица сообщений 
DROP TABLE IF EXISTS message;
CREATE TABLE message(
	message_id SERIAL PRIMARY KEY,
	message_chat_id BIGINT UNSIGNED NOT NULL,
	from_user_id BIGINT UNSIGNED NOT NULL,
	create_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (message_chat_id) REFERENCES chat(chat_id),
	FOREIGN KEY (from_user_id) REFERENCES auth_user(id)

);	

-- таблица транзакций, на сайте будет присутствовать платная подписка 


-- таблица коэффициентов 



