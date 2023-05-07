
CREATE OR REPLACE FUNCTION test_ok(test_name TEXT)
    RETURNS VOID
	LANGUAGE plpgsql
	AS $$
BEGIN
	RAISE NOTICE 'teste %: Resultado OK', test_name;
END;$$;


CREATE OR REPLACE FUNCTION test_fails(test_name TEXT, test_error TEXT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'teste %: Resultado FAIL: %', test_name, test_error;
END;$$;


CREATE OR REPLACE FUNCTION test_fails_with_exception(test_name TEXT, code TEXT, msg TEXT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	RAISE NOTICE 'teste %: Resultado FAIL EXCEPTION', test_name;
	RAISE NOTICE 'An exception did not get handled: code= % : %', code, msg;
END;$$;


-- ############################ EX d ################################

DO
$$
DECLARE
	test_name TEXT := '1: Criar jogador com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	player_email_test CONSTANT TEXT := 'usertest@gmail.com';
BEGIN
	CALL criarJogador(player_email_test,'userTest','Active','Sintra');

	PERFORM FROM PLAYER WHERE email = player_email_test INTO res;

	IF FOUND THEN
		PERFORM test_ok(test_name);
	END IF;

    EXCEPTION
		WHEN SQLSTATE '23505' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
            GET STACKED DIAGNOSTICS
                code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
            PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '2: Criar jogador com email repetido';
	code CHAR(5) := '00000';
	msg TEXT;
	player_email_test CONSTANT TEXT := 'usertest@gmail.com';
BEGIN
	PERFORM FROM player WHERE email = player_email_test;
	IF NOT FOUND THEN
		CALL criarJogador(player_email_test,'userTest','Active','Sintra');
	END IF;

	CALL criarJogador(player_email_test,'userTest','Active','Sintra');

	EXCEPTION
		WHEN SQLSTATE '23505' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
	DECLARE
		test_name TEXT := '3: Criar jogador com nome repetido';
		code CHAR(5) := '00000';
		msg TEXT;
		player_name_test CONSTANT TEXT := 'userTest';
	BEGIN
		PERFORM FROM player WHERE username = player_name_test;
		IF NOT FOUND THEN
			CALL criarJogador('usertest@gmail.com',player_name_test,'Active','Sintra');
		END IF;

		CALL criarJogador('usertest@gmail.com',player_name_test,'Active','Sintra');

	EXCEPTION
		WHEN SQLSTATE '23505' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '4: Mudar estado do jogador com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	player_id_test CONSTANT INT := 1;
    player_new_state_test CONSTANT TEXT := 'Inactive';
BEGIN
	CALL mudarEstadoJogador(player_id_test,player_new_state_test);

	SELECT activity_state FROM player WHERE id = player_id_test INTO res;

	IF res.activity_state = player_new_state_test THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, CONCAT('The state of the player has not been changed, current state is ', res.activity_state));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23505' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
end;$$;

DO
$$
DECLARE
	test_name TEXT := '5: Desativar jogador com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	player_id_test CONSTANT INT := 1;
BEGIN
	CALL desativarJogador(player_id_test);

	SELECT activity_state FROM player WHERE id = player_id_test INTO res;

	IF res.activity_state = 'Inactive' THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, CONCAT('The player has not been inactive, current state is ', res.activity_state));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23505' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '6: Banir jogador com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	player_id_test CONSTANT INT := 1;
BEGIN
	CALL banirJogador(player_id_test);

	SELECT activity_state FROM player WHERE id = player_id_test INTO res;

	IF res.activity_state = 'Banned' THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, CONCAT('The player has not been banned, current state is ', res.activity_state));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23505' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX e ################################

DO
$$
DECLARE
	test_name TEXT := '7: Total de pontos de um jogador com um jogador existente';
	code CHAR(5) := '00000';
	msg TEXT;
	res INT;
	player_id_test CONSTANT INT := 1;
    player_points_expected CONSTANT INT := 3;
BEGIN
	SELECT totalPontosJogador(player_id_test) INTO res;

	IF res = player_points_expected THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, CONCAT('Excpected ', player_points_expected, ' points, but got ', res));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '8: Total de pontos de um jogador com um jogador que não existe';
	code CHAR(5) := '00000';
	msg TEXT;
	res INT;
	player_id_test CONSTANT INT := 100;
BEGIN
	SELECT totalPontosJogador(player_id_test) INTO res;

	IF res IS NOT NULL THEN
		PERFORM test_fails(test_name, CONCAT('The function shouldn''t return anything, but it returns ', res));
	END IF;

	EXCEPTION
			WHEN SQLSTATE '20000' THEN
				PERFORM test_ok(test_name);
			WHEN OTHERS THEN
				GET STACKED DIAGNOSTICS
					code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
				PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX f ################################

DO
$$
DECLARE
	test_name TEXT:= '9: Total de jogos de um jogador com um jogador existente';
	code CHAR(5) := '00000';
	msg TEXT;
	res INT;
	player_id_test CONSTANT INT := 1;
	player_games_expected CONSTANT INT := 1;
BEGIN
	SELECT totalJogosJogador(player_id_test) INTO res;

	IF res = player_games_expected THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, CONCAT('Excpected ', player_games_expected, ' games, but got ', res));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '10: Total de jogos de um jogador com um jogador que não existe';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	res INT;
	player_id_test CONSTANT INT := 100;
BEGIN
	SELECT totalJogosJogador(player_id_test) INTO res;

	IF res IS NOT NULL THEN
		PERFORM test_fails(test_name, CONCAT('The function shouldn''t return anything, but it returns ', res));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX g ################################

DO
$$
DECLARE
	test_name TEXT := '11: Total de pontos de um jogador num jogo com um jogo existente';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	res RECORD;
	game_id_test CONSTANT TEXT := 'abcdefghi8';
	player_id_expected CONSTANT INT := 1;
	player_points_expected CONSTANT INT := 3;
BEGIN
	SELECT * FROM pontosJogoPorJogador(game_id_test) INTO res;

	IF res.player_id = player_id_expected THEN
	    IF res.points = player_points_expected THEN
			PERFORM test_ok(test_name);
		ELSE
			PERFORM test_fails(test_name, CONCAT('Excpected ', player_points_expected, ' points, but got ', res.points));
		END IF;
	ELSE
		PERFORM test_fails(test_name, CONCAT('Excpected ', player_id_expected, ' player id, but got ', res.player_id));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '12: Total de pontos de vários jogadores num jogo com um jogo existente';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	game_id_test CONSTANT TEXT := 'bbbbbbbbb1';
BEGIN
	CREATE TEMPORARY TABLE tmp_user_points (
	   player_id INT,
	   points INT
	);

	INSERT INTO tmp_user_points(player_id, points) VALUES (2,5), (3,1);

	-- to use both table in the loop
	FOR res IN SELECT p.player_id, p.points FROM pontosJogoPorJogador(game_id_test) p
		LOOP
			IF (res.player_id, res.points) NOT IN (SELECT player_id, points FROM tmp_user_points) THEN
				PERFORM test_fails(test_name, CONCAT('The player ', res.player_id,' should has ', res.points,' points in the game ', game_id_test));
				DROP TABLE tmp_user_points;
				RETURN;
			END IF;
		END LOOP;
	PERFORM test_ok(test_name);

	-- drop temporary table
	DROP TABLE tmp_user_points;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '13: Total de pontos de um jogador num jogo que não existe';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
begin
	SELECT pontosJogoPorJogador(null) INTO res;

	IF res IS NOT NULL THEN
		PERFORM test_fails(test_name, CONCAT('The function shouldn''t return anything, but it returns ', res));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX h ################################

DO
$$
DECLARE
	test_name TEXT := '14: Associar crachá a um jogador que tem pontos suficientes';
	code char(5) default '00000';
	msg text;
	player_id_test CONSTANT INT := 1;
	game_id_test CONSTANT TEXT := 'abcdefghi8';
	badge_name_test CONSTANT TEXT := 'test';
BEGIN
	CALL associarCrachá(player_id_test, game_id_test,badge_name_test);

	PERFORM FROM player_badge WHERE player_id = player_id_test AND b_name = badge_name_test AND game_id = game_id_test;

	IF FOUND THEN
		PERFORM test_ok(test_name);
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23505' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '15: Associar crachá a um jogador que não tem pontos suficientes';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 2;
	game_id_test CONSTANT TEXT := 'bbbbbbbbb1';
    badge_name_test CONSTANT TEXT := 'Win-Streak';
begin
	CALL associarCrachá(player_id_test, game_id_test,badge_name_test);

	PERFORM FROM player_badge WHERE player_id = player_id_test AND b_name = badge_name_test AND game_id = game_id_test;
	
	IF NOT FOUND THEN
		PERFORM test_ok(test_name);
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23505' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

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


-- ############################ EX i ################################

DO
$$
DECLARE
	test_name TEXT:= 'iniciarConversa with user 1';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	p_id INT := 1;
	chat_name TEXT := 'Test Chat';
	c_id INT;
	m_id INT;
BEGIN

	CALL iniciarConversa(p_id, chat_name, c_id);

	-- Check if chat was created
	PERFORM FROM chat WHERE id = c_id;
	IF NOT FOUND THEN
		RAISE NOTICE 'Test %: Result FAIL', test_name;
		RETURN;
	END IF;

	-- Check if chat lookup was created
	PERFORM FROM chat_lookup WHERE chat_id = c_id AND player_id = p_id;
	IF NOT FOUND THEN
		RAISE NOTICE 'Test %: Result FAIL', test_name;
		RETURN;
	END IF;

	-- Check if message was created
	SELECT n_order INTO m_id FROM message WHERE chat_id = c_id;
	IF m_id <> 1 THEN
		RAISE NOTICE 'Test %: Result FAIL', test_name;
		RETURN;
	END IF;

	RAISE NOTICE 'Test %: Result OK', test_name;

EXCEPTION
	WHEN OTHERS THEN
		GET STACKED DIAGNOSTICS
			code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
		RAISE NOTICE 'Test %: Result FAIL EXCEPTION', test_name;
		RAISE NOTICE 'An exception did not get handled: code= % : %', code, msg;
END;$$;

DO
$$
DECLARE
	test_name TEXT := 'iniciarConversa with user that does not exists';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	p_id INT := 100;
	chat_name TEXT := 'Test Chat';
	c_id INT;
BEGIN

	CALL iniciarConversa(p_id, chat_name, c_id);

	IF c_id IS NULL THEN
		RAISE NOTICE 'Test %: Result OK', test_name;
	ELSE
		RAISE NOTICE 'Test %: Result FAIL, res= %', test_name, c_id;
	END IF;
EXCEPTION
	WHEN OTHERS THEN

		GET STACKED DIAGNOSTICS
			code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
		RAISE NOTICE 'Test %: Result FAIL EXCEPTION', test_name;
		RAISE NOTICE 'An exception did not get handled: code= % : %', code, msg;
END;$$;

DO
$$
DECLARE
	test_name TEXT := 'iniciarConversa with chat name empty';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	p_id INT := 1;
	chat_name TEXT := '';
	c_id INT;
BEGIN

	CALL iniciarConversa(p_id, chat_name, c_id);

	IF c_id IS NULL THEN
		RAISE NOTICE 'Test %: Result OK', test_name;
	ELSE
		RAISE NOTICE 'Test %: Result FAIL', test_name;
	END IF;
EXCEPTION
	WHEN OTHERS THEN

		GET STACKED DIAGNOSTICS
			code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
		RAISE NOTICE 'Test %: Result FAIL EXCEPTION', test_name;
		RAISE NOTICE 'An exception did not get handled: code= % : %', code, msg;
END;$$;


-- ############################ EX j ################################

DO
$$
    DECLARE
        test_name text := 'juntarConversa junta um player na conversa corretamente';
        code char(5) default '00000';
        msg text;
        res record;
    begin
       CALL juntarConversa(3,1);

       SELECT * FROM chat_lookup where chat_id = 1 and player_id = 3 into res;

        if res.chat_id = 1 and res.player_id = 3 then
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
        test_name text := 'juntarConversa junta um player que ja estava anteriormente na conversa';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL juntarConversa(3,1);

        SELECT * FROM chat_lookup where chat_id = 1 and player_id = 3 into res;

        if res.chat_id = 1 and res.player_id = 3 then
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
        test_name text := 'juntarConversa chat id is null';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL juntarConversa(3,null);

        SELECT * FROM chat_lookup where chat_id = null and player_id = 3 into res;

        if res is null then
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
        test_name text := 'juntarConversa player id is null';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL juntarConversa(null,1);

        SELECT * FROM chat_lookup where chat_id = 1 and player_id = null into res;

        if res is null then
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
        test_name text := 'juntarConversa chat id does not exist';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL juntarConversa(3,3512);

        SELECT * FROM chat_lookup where chat_id = 3512 and player_id = 3 into res;

        if res is null then
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
        test_name text := 'juntarConversa player id does not exist';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL juntarConversa(7,1);

        SELECT * FROM chat_lookup where chat_id = 3 and player_id = 7 into res;

        if res is null then
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


-- ############################ EX l ################################

DO
$$
DECLARE
	test_name TEXT := 'jogadorTotalInfo with user 1';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	p_id INT := 1;
	games INT := 1;
	matches INT := 1;
	score INT := 3;
	res_games INT;
	res_matches INT;
	res_score INT;
BEGIN

	SELECT total_games INTO res_games FROM jogadorTotalInfo WHERE id = p_id;
	SELECT total_matches INTO res_matches FROM jogadorTotalInfo WHERE id = p_id;
	SELECT total_score INTO res_score FROM jogadorTotalInfo WHERE id = p_id;

	IF games = res_games AND matches = res_matches AND score = res_score THEN
		RAISE NOTICE 'Test %: Result OK', test_name;
	ELSE
		RAISE NOTICE 'Test %: Result FAIL', test_name;
	END IF;
EXCEPTION
	WHEN OTHERS THEN

		GET STACKED DIAGNOSTICS
			code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
		RAISE NOTICE 'Test %: Result FAIL EXCEPTION', test_name;
		RAISE NOTICE 'An exception did not get handled: code= % : %', code, msg;
END;$$;


-- ############################ EX m ################################

DO
$$
    DECLARE
        test_name text := 'Ex M apos update do estado da match multiplayer de Ongoing para Finished associa os crachas corretamente';
        code char(5) default '00000';
        msg text;
        res record;
    begin
		UPDATE player_score SET score = 5 WHERE player_id = 2 AND match_number = 2 AND game_id = 'bbbbbbbbb1';
	
        UPDATE match_multiplayer SET state = 'Finished' WHERE match_number = 2 AND game_id = 'bbbbbbbbb1';

        SELECT * FROM player_badge where player_id = 2 and b_name = 'Win-Streak' and game_id = 'bbbbbbbbb1' into res;

        if res is not null then
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
        test_name text := 'Ex M match already finished';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        SELECT * FROM match_multiplayer where match_number = 2 and game_id = 'bbbbbbbbb1' and state = 'Finished' into res;

        UPDATE match_multiplayer SET state = 'Finished' where match_number = 2 and game_id = 'bbbbbbbbb1';

        if res is not null then
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
