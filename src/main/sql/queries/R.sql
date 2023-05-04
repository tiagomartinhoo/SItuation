-- ############################ EX e ################################

create or replace function totalPontosJogador(user_id int, points OUT int)
language plpgsql
As
$$
begin
	SELECT into points SUM(p.score) from PLAYER_SCORE as p where p.player_id = user_id;
end;$$;

-- Validação
-- SELECT * from PLAYER_SCORE;

-- INSERT INTO player_score values(2,1, 'abcdefghi8', 2);

-- SELECT totalPontosJogador(1);
-- SELECT totalPontosJogador(2);
-- SELECT totalPontosJogador(3);

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

-- CALL associarCrachá(1, 'abcdefghi8','Win-Streak');

-- Não se espera que o user tenha sido associado porque não tem pontos suficientes
-- SELECT * FROM PLAYER_BADGE;

-- insert into badge(b_name, game_id, points_limit, url)
--         VALUES('test','abcdefghi8', 1, 'https://www.winStreak.com')
--     ;
-- SELECT * FROM badge;

-- CALL associarCrachá(1, 'abcdefghi8','test');

-- SELECT * FROM PLAYER_BADGE;


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
	
	INSERT INTO message(chat_id, player_id, m_time, m_text) Values(c_id, user_id, now(), msg);
end;$$;

-- Validação

-- CALL enviarMensagem(1, 2, 'test message');
-- User 1 does not have an entry in chat_lookup for chat_id = 2, therefore has no permissions

-- INSERT INTO chat_lookup VALUES (2,1);

-- CALL enviarMensagem(1, 2, 'test message');

-- SELECT * FROM message WHERE message.chat_id = 2; 

-- ############################ EX n ################################

CREATE OR REPLACE FUNCTION delete_totalPlayerInfo() RETURNS TRIGGER AS $$
    BEGIN
        IF (TG_OP = 'DELETE') THEN
            CALL banirJogador(OLD.id);
        ELSE
			raise notice 'Trigger ran on an operation % instead of delete', TG_OP;
        END IF;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER banUserOnTotalInfoDel
INSTEAD OF DELETE ON jogadorTotalInfo
    FOR EACH ROW EXECUTE FUNCTION delete_totalPlayerInfo();


--- INICIO DE TESTES ----

-- ############################ EX e ################################

DO
$$
DECLARE
	test_name text := 'totalPontosJogador User não existente';
	code char(5) default '00000';
	msg text;
	res int;
begin
	select totalPontosJogador(201) into res;
	
	if res IS NULL then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL, res=%', test_name, res;
	end if;
	exception
		when others then
		
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text := 'totalPontosJogador User null';
	code char(5) default '00000';
	msg text;
	res int;
begin
	select totalPontosJogador(null) into res;
	
	if res IS NULL then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
	end if;
	exception
		when others then
		
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'totalPontosJogador User ids 1, 2 and 3';
	code char(5) default '00000';
	msg text;
	user1_p int;
	user2_p int;
	user3_p int;
begin
	SELECT totalPontosJogador(1) into user1_p;
	SELECT totalPontosJogador(2) into user2_p;
	SELECT totalPontosJogador(3) into user3_p;
	
	if user1_p = 3 and user2_p = 2 and user3_p = 5 then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
		raise notice '1:%, 2:%, 3:%',user1_p, user2_p, user3_p;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

-- ############################ EX h ################################

DO
$$
DECLARE
	test_name text:= 'associarCrachá quando utilizador não tem pontos suficientes';
	code char(5) default '00000';
	msg text;
begin
	CALL associarCrachá(1, 'abcdefghi8','Win-Streak');
	-- Não se espera que o user tenha sido associado porque não tem pontos suficientes
	
	PERFORM * FROM PLAYER_BADGE where player_id = 1 and b_name = 'Win-Streak' and game_id = 'abcdefghi8';
	
	if not found then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'associarCrachá quando utilizador tem pontos suficientes';
	code char(5) default '00000';
	msg text;
	res record;
begin

	CALL associarCrachá(1, 'abcdefghi8','test');

	PERFORM * FROM PLAYER_BADGE where player_id = 1 and b_name = 'test' and game_id = 'abcdefghi8';
	
	if not found then
		raise notice 'teste %: Resultado FAIL', test_name;
	else
		raise notice 'teste %: Resultado OK', test_name;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'associarCrachá de user/game/nome nulls';
	code char(5) default '00000';
	msg text;
	res record;
begin

	CALL associarCrachá(null, null, null);

	-- nothing CAN happen, therefore we test the throwing of unhandled exceptions
	raise notice 'teste %: Resultado OK', test_name;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;


-- ############################ EX k ################################

DO
$$
DECLARE
	test_name text:= 'enviarMensagem valid message';
	code char(5) default '00000';
	msg text;
	res record;
begin
	call enviarMensagem(1, 1, 'TestMessage');
	
	-- Obtain last message sent to chat 1, which should be the test message sent by user 1
	select * from message where chat_id=1 order by n_order DESC limit 1 into res;
	
	if res.player_id = 1 and res.m_text = 'TestMessage' then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'enviarMensagem user without permissions';
	code char(5) default '00000';
	msg text;
	res record;
begin
	call enviarMensagem(1, 2, 'TestMessage');
	
	select * from message where chat_id=2 and player_id=1 into res;
	
	if res IS NULL then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'enviarMensagem invalid user';
	code char(5) default '00000';
	msg text;
	res record;
begin
	call enviarMensagem(120, 2, 'TestMessage');
	
	select * from message where chat_id=2 and player_id=120 into res;
	
	if res IS NULL then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'enviarMensagem invalid chat id';
	code char(5) default '00000';
	msg text;
	res record;
begin
	call enviarMensagem(1, 152, 'TestMessage');
	
	select * from message where chat_id=152 and player_id=1 into res;
	
	if res IS NULL then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL', test_name;
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'enviarMensagem user and chat null';
	code char(5) default '00000';
	msg text;
	res record;
begin
	call enviarMensagem(null, null, 'TestMessage');
	
	-- In this case nothing CAN happen, therefore we test for exceptions not being treated
	raise notice 'teste %: Resultado OK', test_name;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text:= 'enviarMensagem absurdely big message';
	code char(5) default '00000';
	msg text;
	res record;
	test_msg text := 'TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987
						TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987
						TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987
						TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987';
begin
	call enviarMensagem(1, 1, test_msg);
	
	-- Obtain last message, the message should not have been inserted
	select * from message where chat_id=1 order by n_order DESC limit 1 into res;
	
	if res.m_text = test_msg then
		raise notice 'teste %: Resultado FAIL', test_name;
	else
		raise notice 'teste %: Resultado OK', test_name;	
	end if;
	
	exception
		when others then
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

-- ############################ EX n ################################

DO
$$
DECLARE
	test_name text := 'delete existing user from jogadorTotalInfo ';
	code char(5) default '00000';
	msg text;
	res record;
	res2 record;
begin
	-- DELETE from view should result in user status being turned into banned and user disappearing from said view
	DELETE FROM jogadorTotalInfo where email='rafa@gmail.com';
	
	SELECT * FROM player where email='rafa@gmail.com' into res;
	
	SELECT * FROM jogadorTotalInfo where email='rafa@gmail.com' into res2;
	
	if res.activity_state = 'Banned' and res2 IS NULL then
		raise notice 'teste %: Resultado OK', test_name;
	else
		raise notice 'teste %: Resultado FAIL, res=%', test_name, res;
	end if;
	exception
		when others then
		
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;

DO
$$
DECLARE
	test_name text := 'delete inexistent user from jogadorTotalInfo';
	code char(5) default '00000';
	msg text;

begin
	
	DELETE FROM jogadorTotalInfo where email='abcd@gamil.com';
	
	-- Once again we only test for unhandled exceptions
	raise notice 'teste %: Resultado OK', test_name;
	
	exception
		when others then
		
		GET stacked DIAGNOSTICS
		code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			raise notice 'teste %: Resultado FAIL EXCEPTION', test_name;
			raise notice 'An exception did not get handled: code=%:%', code, msg;
end;$$;