SELECT * from auth_user;


-- посчитаем сколько человек имеют права администратора, сколько не имеют  
select is_superuser ,count(*) from auth_user au 
group by is_superuser;

-- сколько человек которые в сети, являются администраторами

select is_superuser ,count(*) from auth_user au 
WHERE is_active = 1
group by is_superuser;


-- посмотрим имя и фамилию и username

SELECT username, firstname, lastname, email from auth_user au
inner join profile pr
on au.id = pr.user_id;


-- win raite teams
SELECT win_match , count(*) from matches
group by win_match 
order by count(*) DESC;

-- match_id, team_id_radiant, team_id_dire, win_match, league_id

-- представления

-- сообщения в матчах

DROP VIEW IF EXISTS message_match;
CREATE VIEW message_match AS SELECT match_id, chat_id, message_id, `text` from matches mt
inner join chat c
on mt.match_id = c.chat_match_id
inner join message m
on c.chat_id = m.message_chat_id;

SELECT * FROM message_match;




-- вывод матча, номер матча лиги , название команд, и их url логотипа 
-- из-за автоматического заполнения не коректные названия команд 

DROP VIEW IF EXISTS match_name;
CREATE VIEW match_name AS select match_id,league_name, team_name_radiant, t.logo_url as `radiant url name`, team_name_dire , te.logo_url `dire url name` from matches m
join league l
on m.league_id = l.league_id 
join teams t
on m.team_id_radiant = t.team_id 
join teams te
on m.team_id_dire = te.team_id; 

SELECT * FROM match_name;

-- процедуры 

-- процидура подписки выбор подписки 

DELIMITER //

DROP PROCEDURE IF EXISTS sub//
CREATE PROCEDURE sub (format CHAR(6), IN `user` INT)
BEGIN
  	CASE format
		WHEN 'month1' THEN
		
	  	INSERT INTO transaction_sub(user_id, price, subscription, end_time) VALUES(`user`, 350.00, 'month1', (now() + INTERVAL 1 MONTH));
	  	UPDATE auth_user 
	  	set subscription = 1
	  	WHERE id = `user`;
	  	
	  
		WHEN 'month3' THEN
		
	  	INSERT INTO transaction_sub(user_id, price, subscription, end_time) VALUES(`user`, 650.00, 'month3', (now() + INTERVAL 3 MONTH));
	  	UPDATE auth_user 
	  	set subscription = 1
	  	WHERE id = `user`;
	  
		WHEN 'month6' THEN
		
	  	INSERT INTO transaction_sub(user_id, price, subscription, end_time) VALUES(`user`, 850.00, 'month6', (now() + INTERVAL 6 MONTH));
	  	UPDATE auth_user 
	  	set subscription = 1
	  	WHERE id = `user`;
	  
		ELSE
		SELECT 'Ошибка в параметре format';
	
	END CASE;
END//
	
DELIMITER ;


CALL sub ('month1', 20);

-- тригеры  

-- если человек подписан он больше не может подписаться 
DELIMITER //
DROP TRIGGER IF EXISTS check_sub//
CREATE TRIGGER check_sub before INSERT ON transaction_sub
FOR EACH ROW
BEGIN
	
	set @til = (select (now() BETWEEN create_at and end_time ) from transaction_sub ts WHERE NEW.user_id = user_id ORDER by end_time DESC limit 1);
	IF (@til = 1) THEN
		
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Невозможно подписаться, вы уже подписаны';
  	END IF;
 
END//

DELIMITER ;



