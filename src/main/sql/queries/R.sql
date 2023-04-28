-- ############################ EX e ################################

create or replace function totalPontosJogador(user_id int, points OUT int)
language plpgsql
As
$$
begin
	SELECT into points SUM(p.score) from PLAYER_SCORE as p where p.player_id = user_id;
end;$$;

-- Validação
SELECT * from PLAYER_SCORE;

INSERT INTO player_score values(2,1, 'abcdefghi8', 2);

SELECT totalPontosJogador(1);
SELECT totalPontosJogador(2);
SELECT totalPontosJogador(3);

-- ############################ EX h ################################

-- DROP procedure "associarcrachá"(integer,text,text);

create or replace procedure associarCrachá(user_id int, game text, badge text)
language plpgsql
As
$$
Declare
	needed_points int DEFAULT -1;
	user_points int DEFAULT -1;
begin
	-- Obtain user points in the game
	select into user_points SUM(p.score) from PLAYER_SCORE as p where p.player_id = user_id and (p.game_id = game);
	-- Obtain needed points for the badge
	select into needed_points b.points_limit from BADGE as b where b.game_id = game_id and b.b_name = badge;
	
	IF needed_points = -1 or user_points = -1 THEN
		raise notice 'One of the queries went wrong';
	END IF;
	
	IF user_points >= needed_points THEN
		INSERT into PLAYER_BADGE VALUES(user_id, badge, game);
	ELSE
		raise notice 'User does not have enough points: (%) needed: (%)', user_points, needed_points;
	END IF;
end;$$;

-- Validação

CALL associarCrachá(1, 'abcdefghi8','Win-Streak');

-- Não se espera que o user tenha sido associado porque não tem pontos suficientes
SELECT * FROM PLAYER_BADGE;

insert into badge(b_name, game_id, points_limit, url)
        VALUES('test','abcdefghi8', 1, 'https://www.winStreak.com')
    ;
SELECT * FROM badge;

CALL associarCrachá(1, 'abcdefghi8','test');

SELECT * FROM PLAYER_BADGE;


-- ############################ EX k ################################

create or replace procedure enviarMensagem(user_id int, c_id int, msg text)
language plpgsql
As
$$

begin
	PERFORM * from chat_lookup as c where c.player_id = user_id and c.chat_id = c_id;
	if not found THEN
		-- Some error condition (user/chat does not exist or user doesn't have access to chat)
		raise notice 'User does not have permission to chat in this chat';
		return;
	END IF;
	-- TODO: Handle n_order parameter?
	INSERT INTO message Values(1, c_id, user_id, now(), msg);
end;$$;

-- Validação

CALL enviarMensagem(1, 2, 'test message');
-- User 1 does not have an entry in chat_lookup for chat_id = 2, therefore has no permissions

INSERT INTO chat_lookup VALUES (2,1);

CALL enviarMensagem(1, 2, 'test message');

SELECT * FROM message WHERE message.chat_id = 2; 