
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
	RAISE NOTICE 'teste %: Resultado FAIL EXCEPTION: An exception did not get handled: code = % : %', test_name, code, msg;
END;$$;


-- ############################ EX d ################################

DO
$$
DECLARE
	test_name TEXT := '1: Criar jogador com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	player_email_test CONSTANT TEXT := 'usertest@gmail.com';
    player_name_test CONSTANT TEXT := 'userTest';
BEGIN
	CALL criarJogador(player_email_test,player_name_test,'Active','Sintra');

	PERFORM FROM player WHERE email = player_email_test;

	IF FOUND THEN
		PERFORM test_ok(test_name);
		DELETE FROM player WHERE email = player_email_test;
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
	player_name_test CONSTANT TEXT := 'userTest';
BEGIN
	PERFORM FROM player WHERE email = player_email_test;
	IF NOT FOUND THEN
		CALL criarJogador(player_email_test,player_name_test,'Active','Sintra');
	END IF;

	CALL criarJogador(player_email_test,player_name_test,'Active','Sintra');

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
		player_email_test CONSTANT TEXT := 'usertest@gmail.com';
		player_name_test CONSTANT TEXT := 'userTest';
	BEGIN
		PERFORM FROM player WHERE username = player_name_test;
		IF NOT FOUND THEN
			CALL criarJogador(player_email_test,player_name_test,'Active','Sintra');
		END IF;

		CALL criarJogador(player_email_test,player_name_test,'Active','Sintra');

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
	game_id_test CONSTANT TEXT := 'abcdefghi8';
BEGIN
	CREATE TEMPORARY TABLE tmp_user_points (
	   player_id INT,
	   points INT
	);

	INSERT INTO tmp_user_points(player_id, points) VALUES (1,3), (2,2), (3,4);

	-- to use both table in the loop
	FOR res IN SELECT p.player_id, p.points FROM pontosJogoPorJogador(game_id_test) p
		LOOP
			IF (res.player_id, res.points) NOT IN (SELECT player_id, points FROM tmp_user_points) THEN
				PERFORM test_fails(test_name, CONCAT('The player ', res.player_id,' has ', res.points,' points in the game ', game_id_test));
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
		DELETE FROM player_badge WHERE player_id = player_id_test AND b_name = badge_name_test AND game_id = game_id_test;
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
	player_id_test CONSTANT INT := 4;
	game_id_test CONSTANT TEXT := 'bbbbbbbbb1';
    badge_name_test CONSTANT TEXT := 'Win-Streak';
begin
	CALL associarCrachá(player_id_test, game_id_test,badge_name_test);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '22000' THEN
			PERFORM test_ok(test_name);
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
	test_name TEXT := '16: Associar crachá a um jogador com dados mal passados';
	code CHAR(5) := '00000';
	msg TEXT;
BEGIN
	CALL associarCrachá(null, null, null);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX i ################################

DO
$$
DECLARE
	test_name TEXT:= '17: Iniciar conversa com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 1;
	chat_name_test CONSTANT TEXT := 'Test Chat';
	c_id INT;
	m_id INT;
BEGIN
	CALL iniciarConversa(player_id_test, chat_name_test, c_id);

	PERFORM FROM chat_lookup WHERE chat_id = c_id AND player_id = player_id_test;
	IF FOUND THEN
		SELECT n_order INTO m_id FROM message WHERE chat_id = c_id;
		IF m_id = 1 THEN
			PERFORM test_ok(test_name);
		ELSE
		    PERFORM test_fails(test_name, CONCAT('Inicial message was not created in the chat with id ', c_id));
		END IF;
	ELSE
		PERFORM test_fails(test_name, 'Chat was not created.');
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '22004' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT:= '18: Iniciar conversa com jogador que não existe';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 100;
	chat_name_test CONSTANT TEXT := 'Test Chat';
	c_id INT;
BEGIN

	CALL iniciarConversa(player_id_test, chat_name_test, c_id);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN SQLSTATE '22004' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT:= '19: Iniciar conversa com nome do chat vazio';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 1;
	chat_name_test CONSTANT TEXT := '';
	c_id INT;
BEGIN

	CALL iniciarConversa(player_id_test, chat_name_test, c_id);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '22004' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX j ################################

DO
$$
DECLARE
	test_name TEXT := '20: Juntar um player a uma conversa com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 3;
	chat_id_test CONSTANT INT := 1;
BEGIN
   CALL juntarConversa(player_id_test, chat_id_test);

   PERFORM FROM chat_lookup where chat_id = chat_id_test and player_id = player_id_test;

	IF FOUND THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, 'Player did not join the chat.');
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
	test_name TEXT := '21: Juntar um player a uma conversa que já estava na conversa';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 3;
	chat_id_test CONSTANT INT := 1;
BEGIN
    CALL juntarConversa(player_id_test,chat_id_test);

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
	test_name TEXT := '22: Juntar um player a uma conversa inexistente';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 3;
	chat_id_test CONSTANT INT := 1000;
BEGIN
        CALL juntarConversa(player_id_test,chat_id_test);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
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
	test_name TEXT := '23: Juntar um player inexistente a uma conversa';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 1000;
	chat_id_test CONSTANT INT := 1;
BEGIN
	CALL juntarConversa(player_id_test,chat_id_test);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN SQLSTATE '23505' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX k ################################

DO
$$
DECLARE
	test_name TEXT := '24: Enviar uma mensagem com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	player_id_test CONSTANT INT := 1;
	chat_id_test CONSTANT INT := 1;
    message_test CONSTANT TEXT := 'TestMessage';
BEGIN
	call enviarMensagem(player_id_test, chat_id_test, message_test);
	
	-- Obtain last message sent to chat 1, which should be the test message sent by user 1
	SELECT * FROM message WHERE chat_id = chat_id_test ORDER BY n_order DESC LIMIT 1 INTO res;
	
	IF res.player_id = player_id_test AND res.m_text = message_test THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, 'Message was not created.');
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23503' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '25: Enviar uma mensagem de um jogador sem permissão';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 1;
	chat_id_test CONSTANT INT := 2;
	message_test CONSTANT TEXT := 'TestMessage';
BEGIN
	CALL enviarMensagem(player_id_test, chat_id_test, message_test);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '23503' THEN
			PERFORM test_ok(test_name);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '26: Enviar uma mensagem de um jogador que não existe';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 100;
	chat_id_test CONSTANT INT := 2;
	message_test CONSTANT TEXT := 'TestMessage';
BEGIN
	CALL enviarMensagem(player_id_test, chat_id_test, message_test);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN SQLSTATE '23503' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '27: Enviar uma mensagem num chat que não existe';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 1;
	chat_id_test CONSTANT INT := 1000;
	message_test CONSTANT TEXT := 'TestMessage';
BEGIN
	CALL enviarMensagem(player_id_test, chat_id_test, message_test);

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_ok(test_name);
		WHEN SQLSTATE '23503' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;

DO
$$
DECLARE
	test_name TEXT := '28: Enviar uma mensagem demasiado grande';
	code CHAR(5) := '00000';
	msg TEXT;
	res record;
	player_id_test CONSTANT INT := 1;
	chat_id_test CONSTANT INT := 1;
	message_test CONSTANT TEXT := 'TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987
						TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987
						TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987
						TestMessage21412u56271765172651726215t682165621652815a6sd67861278461261845216541858652186186888asd2418217491824879481987421914978241987';
BEGIN
	CALL enviarMensagem(player_id_test, chat_id_test, message_test);
	
	-- Obtain last message, the message should not have been inserted
	SELECT * FROM message WHERE chat_id = chat_id_test ORDER BY n_order DESC LIMIT 1 INTO res;
	
	if res.m_text = message_test then
		PERFORM test_fails(test_name, 'The message should not have been created.');
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '22001' THEN
			PERFORM test_ok(test_name);
		WHEN SQLSTATE '23503' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX l ################################

DO
$$
DECLARE
	test_name TEXT := '29: Toda a informação de um jogador com dados bem passados';
	code CHAR(5) := '00000';
	msg TEXT;
	p_id INT := 2;
	games INT := 2;
	matches INT := 2;
	score INT := 2;
	res_games INT;
	res_matches INT;
	res_score INT;
BEGIN

	SELECT total_games, total_matches, total_score INTO res_games, res_matches, res_score FROM jogadorTotalInfo WHERE id = p_id;

	IF games = res_games AND matches = res_matches AND score = res_score THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, CONCAT('Expected: games = ', games, ', matches = ', matches, ', score = ', score, '. But got: games = ', res_games, ', matches = ', res_matches, ', score = ', res_score));
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX m ################################

DO
$$
DECLARE
	test_name TEXT := '30: Após update do estado da match multiplayer de Ongoing para Finished associa os crachas corretamente';
	code CHAR(5) := '00000';
	msg TEXT;
	player_id_test CONSTANT INT := 3;
	game_id_test CONSTANT TEXT := 'bbbbbbbbb1';
    match_number_test CONSTANT INT := 2;
BEGIN
	UPDATE player_score SET score = 5 WHERE player_id = player_id_test AND match_number = match_number_test AND game_id = game_id_test;

	UPDATE match_multiplayer SET state = 'Finished' WHERE match_number = match_number_test AND game_id = game_id_test;

	PERFORM FROM player_badge WHERE player_id = player_id_test AND b_name = 'Win-Streak' AND game_id = game_id_test;

	IF FOUND THEN
		PERFORM test_ok(test_name);
	ELSE
	    PERFORM test_fails(test_name, 'The player does not have the associated badge');
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN SQLSTATE '22000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;


-- ############################ EX n ################################

DO
$$
DECLARE
	test_name TEXT := '31: Apagar um jogador de jogadorTotalInfo bane o jogador';
	code CHAR(5) := '00000';
	msg TEXT;
	res RECORD;
	res2 RECORD;
    player_email_test TEXT := 'rafa@gmail.com';
BEGIN
	-- DELETE from view should result in user status being turned into banned and user disappearing from said view
	DELETE FROM jogadorTotalInfo WHERE email = player_email_test;
	
	SELECT * FROM player WHERE email = player_email_test INTO res;
	
	SELECT * FROM jogadorTotalInfo WHERE email = player_email_test INTO res2;
	
	IF res.activity_state = 'Banned' AND res2 IS NULL THEN
		PERFORM test_ok(test_name);
	ELSE
		PERFORM test_fails(test_name, 'Player is not banned.');
	END IF;

	EXCEPTION
		WHEN SQLSTATE '20000' THEN
			PERFORM test_fails(test_name, SQLERRM);
		WHEN OTHERS THEN
			GET STACKED DIAGNOSTICS
				code = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
			PERFORM test_fails_with_exception(test_name, code, msg);
END;$$;
