-- ############################ EX d ################################

DO
$$
DECLARE
	test_name text := 'criarJogador criar novo Player';
	code char(5) default '00000';
	msg text;
	res record;
begin

	CALL criarJogador('test@gmail.com','test','Banned','Sintra');

	select * FROM PLAYER where email = 'test@gmail.com' into res;

	if res is null then
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
        test_name text := 'criarJogador Player existente';
        code char(5) default '00000';
        msg text;
        res record;
    begin

        select * FROM PLAYER where email = 'test@gmail.com' into res;

        if res is null then
            CALL criarJogador('test@gmail.com','test','Banned','Sintra');
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
        test_name text := 'mudarEstadoJogador altera estado corretamente';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL mudarEstadoJogador(1,'Inactive');

        select activity_state FROM PLAYER where id = 1 into res;

        if res.activity_state = 'Inactive' then
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
        test_name text := 'desativarJogador desativa o jogador corretamente';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL desativarJogador(2);

        select activity_state FROM PLAYER where id = 2 into res;

        if res.activity_state = 'Inactive' then
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
        test_name text := 'banirJogador bane o jogador corretamente';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        CALL banirJogador(2);

        select activity_state FROM PLAYER where id = 2 into res;

        if res.activity_state = 'Banned' then
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


-- ############################ EX f ################################

DO
$$
DECLARE
	test_name TEXT:= 'totalJogosJogador with user ids 1, 2 and 3';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	user1_j INT;
	user2_j INT;
	user3_j INT;
BEGIN
	SELECT totalJogosJogador(1) INTO user1_j;
	SELECT totalJogosJogador(2) INTO user2_j;
	SELECT totalJogosJogador(3) INTO user3_j;

	IF user1_j = 1 AND user2_j = 2 AND user3_j = 2 THEN
		RAISE NOTICE 'Test %: Result OK', test_name;
	ELSE
		RAISE NOTICE 'Test %: Result FAIL', test_name;
		RAISE NOTICE '1:%, 2:%, 3:%', user1_j, user2_j, user3_j;
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
	test_name TEXT := 'totalJogosJogador with user that does not exists';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	res INT;
BEGIN
	SELECT totalJogosJogador(200) INTO res;

	IF res = 0 THEN
		RAISE NOTICE 'Test %: Result OK', test_name;
	ELSE
		RAISE NOTICE 'Test %: Result FAIL, res= %', test_name, res;
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
	test_name TEXT := 'totalJogosJogador User null';
	code CHAR(5) DEFAULT '00000';
	msg TEXT;
	res INT;
BEGIN
	SELECT totalJogosJogador(null) INTO res;

	IF res = 0 THEN
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


-- ############################ EX g ################################

DO
$$
    DECLARE
        test_name text := 'pontosJogoPorJogador apresenta o id de um unico jogador e os seus respetivos pontos num unico jogo corretamente';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        select * FROM pontosJogoPorJogador('abcdefghi8') into res;

        if res.user_id = 1 and res.points = 3 then
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
        test_name text := 'pontosJogoPorJogador apresenta o id de vários jogadores e os seus respetivos pontos num unico jogo corretamente';
        code char(5) default '00000';
        msg text;
        res record;
        tmp_rec record;
    begin

        CREATE TEMPORARY TABLE tmp_user_points (
           user_id INTEGER,
           points INTEGER
        );

        INSERT INTO tmp_user_points(user_id, points) VALUES	(2,0),
                                                            (3,1);

        -- to use both table in the loop
        for res in select p.user_id, p.points FROM pontosJogoPorJogador('bbbbbbbbb1') p
            LOOP
                if (res.user_id, res.points) NOT IN (SELECT user_id, points FROM tmp_user_points) then
                    raise notice 'teste %: Resultado FAIL', test_name;
					DROP TABLE tmp_user_points;
					RETURN;
                end if;
            end loop;
		raise notice 'teste %: Resultado OK', test_name;
        -- drop temporary table
        DROP TABLE tmp_user_points;
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
        test_name text := 'pontosJogoPorJogador retorna null';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        select * FROM pontosJogoPorJogador(null) into res;

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
        test_name text := 'pontosJogoPorJogador jogo nao existe';
        code char(5) default '00000';
        msg text;
        res record;
    begin
        select * FROM pontosJogoPorJogador('abscvggggg') into res;

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


-- ############################ EX h ################################

DO
$$
DECLARE
	test_name text:= 'associarCrachá quando utilizador não tem pontos suficientes';
	code char(5) default '00000';
	msg text;
begin
	CALL associarCrachá(2, 'bbbbbbbbb1','Win-Streak');
	-- Não se espera que o user tenha sido associado porque não tem pontos suficientes
	
	PERFORM * FROM PLAYER_BADGE where player_id = 2 and b_name = 'Win-Streak' and game_id = 'abcdefghi8';
	
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
        UPDATE match_multiplayer SET state = 'Finished' where match_number = 2 and game_id = 'bbbbbbbbb1';

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
