
DROP DATABASE IF EXISTS website;
CREATE DATABASE website;

USE website;

DROP TABLE IF EXISTS auth_user;
CREATE TABLE auth_user (
	id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
	`password` varchar(150) not null,
	last_login DATETIME DEFAULT NOW(), -- последний вход на сайт
	username varchar(30) not NULL UNIQUE, 
	email varchar(250) not NULL UNIQUE,
	is_superuser TINYINT default 0 , -- админ 
	is_active TINYINT default 0 ,
	subscription TINYINT default 0, -- подписан ли пользователь
	phone BIGINT UNIQUE, -- телефон
	data_joined DATETIME DEFAULT NOW(), -- дата регистрации	
	
	KEY index_subscription(subscription)
);

DROP TABLE IF EXISTS profile;
CREATE TABLE profile(
	user_id bigint UNSIGNED NOT NULL UNIQUE,
	firstname varchar(40), -- имя 
	lastname varchar(40), -- фамилия 
	gender char(1), -- пол
	update_at DATETIME DEFAULT NOW(), -- дата обновления
	birthday DATE, -- день рождения 
	is_delete TINYINT default 0, -- удален ли пользователь
	
	FOREIGN KEY (user_id) REFERENCES auth_user(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- база данных игроков 
DROP TABLE IF EXISTS players;
CREATE TABLE players(
	player_id bigint UNSIGNED NOT NULL UNIQUE,
	name varchar(100) UNIQUE,
	rating int,
	
	KEY index_player(player_id)
	
);

-- база данных героев
DROP TABLE IF EXISTS heros;
CREATE TABLE heros(
	hero_id bigint UNSIGNED NOT NULL UNIQUE,
	name_hero varchar(255) UNIQUE,
	photo varchar(255) UNIQUE,
	
	
	KEY index_hero(hero_id)
	

	
);


-- название лиги
DROP TABLE IF EXISTS league;
CREATE TABLE league(
	league_id bigint UNSIGNED NOT NULL UNIQUE,
	league_name varchar(255) not null UNIQUE,
 	
	KEY index_league_id (league_id)
);

-- база данных команд

DROP TABLE IF EXISTS teams;
CREATE TABLE teams(
	team_id INT UNSIGNED NOT NULL UNIQUE,
	name varchar(255) UNIQUE not null,
	logo INT UNSIGNED NOT NULL UNIQUE,
	logo_url varchar(255) UNIQUE,  -- название файла
	
	
	KEY index_team_id (team_id)

	

);

-- создаем таблицу матчей 

DROP TABLE IF EXISTS matches;
CREATE TABLE matches(
	id SERIAL PRIMARY KEY,
	match_id bigint UNSIGNED NOT NULL UNIQUE,
	create_match DATETIME default now(),
	start_game datetime not NULL,
	stop_game datetime default 0,
	game_time datetime default 0,
	league_id bigint UNSIGNED NOT NULL,
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
	-- players_team1 JSON not null,
	-- players_team2 JSON not null,
	building_state BIGINT,
	graph JSON,
	win_match varchar(255),
	
	
	
	FOREIGN KEY (team_id_radiant) REFERENCES teams(team_id),
	FOREIGN KEY (team_id_dire) REFERENCES teams(team_id),
	FOREIGN KEY (league_id) REFERENCES league(league_id),
	KEY index_match_id (match_id)

);


-- таблица матчей и игроков 
DROP TABLE IF EXISTS match_players;
CREATE TABLE match_players(
	match_id bigint UNSIGNED NOT NULL,
	player bigint UNSIGNED NOT NULL,
	hero_player bigint UNSIGNED NOT NULL,
	side enum('radiant', 'dire'), 
	
	FOREIGN KEY (player) REFERENCES players(player_id),
	FOREIGN KEY (hero_player) REFERENCES heros(hero_id),
	FOREIGN KEY (match_id) REFERENCES matches(match_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- таблица чатов, на каждый матч есть свой чат 

DROP TABLE IF EXISTS chat;
CREATE TABLE chat(
	chat_id SERIAL PRIMARY KEY, -- номер чата 
	name_chat varchar(100) UNIQUE, -- название чата
	chat_match_id bigint UNSIGNED NOT NULL UNIQUE, -- к какой игре относится данный чат
	create_at DATETIME DEFAULT NOW(), -- дата создания 
	
	-- KEY index_match_id (match_id)
	FOREIGN KEY (chat_match_id) REFERENCES matches(match_id) -- связываем чат с матчеем
	ON UPDATE CASCADE
	ON DELETE CASCADE
);

-- таблица сообщений 
DROP TABLE IF EXISTS message; -- все собщения в чатах
CREATE TABLE message(
	message_id SERIAL PRIMARY KEY,  -- номер сообщения
	message_chat_id BIGINT UNSIGNED NOT NULL,
	`text` TEXT,-- какой чат 
	from_user_id BIGINT UNSIGNED NOT NULL, -- кто пишет
	create_at DATETIME DEFAULT NOW(), -- время создания
	
	FOREIGN KEY (message_chat_id) REFERENCES chat(chat_id), -- связываем с чатом
	FOREIGN KEY (from_user_id) REFERENCES auth_user(id) -- связываем с профилем 
	ON UPDATE CASCADE
	ON DELETE CASCADE
);	

-- таблица транзакций, на сайте будет присутствовать платная подписка 
DROP TABLE IF EXISTS transaction_sub;
CREATE TABLE transaction_sub(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL, -- пользователь
	price decimal(11,2),
	subscription enum('0','month1','month3','month6') default '0', -- выбор подписки 
	create_at DATETIME DEFAULT NOW(), -- начало подписки
	end_time DATETIME, -- конец подписки
	
	FOREIGN KEY (user_id) REFERENCES auth_user(id)
	ON UPDATE CASCADE
	ON DELETE CASCADE

);

-- все возможные букмекерские конторы 

DROP TABLE IF EXISTS bets_bk;
CREATE TABLE bets_bk(
	id SERIAL PRIMARY KEY,
	name_bk varchar(255) unique,
	
	
	KEY index_bk_id (id)
);


-- таблица коэффициентов, сбор информации коэффициентов

DROP TABLE IF EXISTS bets;
CREATE TABLE bets(
	id SERIAL PRIMARY KEY,
	match_id BIGINT UNSIGNED NOT NULL,
	team_radiant varchar(255) not null,
	team_dire varchar(255) not null,
	ratio_radiant decimal(11,2),
	ratio_dire decimal(11,2),
	bk_id BIGINT UNSIGNED NOT NULL,
	create_at DATETIME DEFAULT NOW(),
	
	FOREIGN KEY (bk_id) REFERENCES bets_bk(id),
	FOREIGN KEY (team_radiant) REFERENCES teams(name),
	FOREIGN KEY (team_dire) REFERENCES teams(name),
	FOREIGN KEY (match_id) REFERENCES matches(match_id)
	ON UPDATE CASCADE
	ON DELETE CASCADE

);

