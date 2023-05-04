
-- ############################ EX f ################################

CREATE OR REPLACE FUNCTION totalJogosJogador(p_id INT) RETURNS INT
	LANGUAGE plpgsql AS $$
DECLARE
	games_count INT;
BEGIN
	-- Check if player exists
    IF NOT check_player_exists(p_id) THEN
        RETURN NULL;
	END IF;

	SELECT COUNT(DISTINCT game_id) INTO games_count
	FROM player_score AS ps
	WHERE ps.player_id = p_id;
	RETURN games_count;
END;
$$;


-- ############################ EX i ################################

CREATE OR REPLACE FUNCTION set_message_id() RETURNS TRIGGER
	LANGUAGE plpgsql AS $$
BEGIN
	NEW.n_order = (
		SELECT COALESCE(MAX(n_order), 0) + 1
		FROM message
		WHERE chat_id = NEW.chat_id
	);
	RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER set_message_id_trigger
	BEFORE INSERT ON message
	FOR EACH ROW
	WHEN (NEW.n_order IS NULL)
		EXECUTE FUNCTION set_message_id();

-- TEST
INSERT INTO message (chat_id, player_id, m_time, m_text)
VALUES (1, 1, NOW(), 'bye');


CREATE OR REPLACE PROCEDURE iniciarConversa (
	IN p_id INT,
	IN chat_name TEXT,
	OUT c_id INT
)
	LANGUAGE plpgsql
AS $$
DECLARE
	player_name VARCHAR;
BEGIN
	-- Check if player exists
	IF NOT check_player_exists(p_id) OR check_chat_name_is_empty(chat_name) THEN
		RETURN;
	END IF;

	-- Insert a new chat and get its ID
	INSERT INTO chat (c_name) VALUES (chat_name) RETURNING id INTO c_id;

	-- Insert a lookup record to associate the player with the chat
	INSERT INTO chat_lookup (chat_id, player_id) VALUES (c_id, p_id);

	-- Get the player's username
	SELECT username INTO player_name FROM player WHERE id = p_id;

	-- Insert a message to indicate that the player started the chat
	INSERT INTO message (chat_id, player_id, m_time, m_text)
	VALUES (c_id, p_id, NOW(), CONCAT('The player ', player_name, ' starts the chat.'));
END;
$$;


-- ############################ EX l ################################

CREATE OR REPLACE VIEW jogadorTotalInfo AS
SELECT p.id, p.activity_state, p.email, p.username,
	   COUNT(DISTINCT g.id) AS total_games,
	   COUNT(DISTINCT m.number) AS total_matches,
	   SUM(ps.score) AS total_score
FROM player p
		 LEFT JOIN player_score ps ON p.id = ps.player_id
		 LEFT JOIN match m ON ps.match_number = m.number
		 LEFT JOIN game g ON m.game_id = g.id
WHERE p.activity_state != 'Banned'
GROUP BY p.id;

-- TEST
SELECT * FROM jogadorTotalInfo;




--- INICIO DE TESTES ----

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

	IF res IS NULL THEN
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

	IF res IS NULL THEN
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

