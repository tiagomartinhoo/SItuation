-- Util functions for the errors handling

CREATE OR REPLACE FUNCTION check_player_duplicate(p_email TEXT, p_name TEXT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM player WHERE email = p_email;
	IF FOUND THEN
		RAISE EXCEPTION 'Player with email % already exists.', p_email
		    USING ERRCODE = '23505';
	END IF;

	PERFORM FROM player WHERE username = p_name;
	IF FOUND THEN
		RAISE EXCEPTION 'Player with name % already exists.', p_name
		    USING ERRCODE = '23505';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_player_exists(p_id INT)
	RETURNS VOID
	LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM FROM player WHERE id = p_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Player with id % not found.', p_id
            USING ERRCODE = '20000';
    END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_player_has_state(p_id INT, state TEXT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM player WHERE id = p_id AND activity_state = state;
	IF FOUND THEN
		RAISE EXCEPTION 'Player with id % already has state "%".', p_id, state
		    USING ERRCODE = '23505';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_player_has_badge(p_id INT, game TEXT, badge TEXT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM PLAYER_BADGE AS t WHERE t.player_id = p_id AND game_id = game AND b_name = badge;
	IF FOUND THEN
		RAISE EXCEPTION 'Player with id % already has badge "%" in the game %.', p_id, badge, game
		    USING ERRCODE = '23505';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_game_exists(g_id VARCHAR)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM game WHERE id = g_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Game with id % not found.', g_id
			USING ERRCODE = '20000';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_chat_exists(c_id INT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM chat WHERE id = c_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Chat with id % not found.', c_id
			USING ERRCODE = '20000';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_chat_name_is_empty(c_name TEXT)
	RETURNS VOID
	LANGUAGE plpgsql
    AS $$
BEGIN
    IF length(c_name) = 0 THEN
        RAISE EXCEPTION 'Name of the chat can not be empty.'
			USING ERRCODE = '22004';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_player_in_chat(p_id INT, c_id INT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM chat_lookup WHERE player_id = p_id AND chat_id = c_id;
	IF FOUND THEN
		RAISE EXCEPTION 'Player with id % already in chat with id %', p_id, c_id
			USING ERRCODE = '23505';
	END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_player_chat_permission(p_id INT, c_id INT)
	RETURNS VOID
	LANGUAGE plpgsql
AS $$
BEGIN
	PERFORM FROM chat_lookup WHERE player_id = p_id AND chat_id = c_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'Player with id % does not have permission to send messages in chat with id %', p_id, c_id
			USING ERRCODE = '23503';
	END IF;
END;$$;


-- ############################ EX d ################################

CREATE OR REPLACE PROCEDURE criarJogador(
	p_email TEXT,
	p_username TEXT,
	p_activity_state TEXT,
	p_region_name TEXT
)
    LANGUAGE plpgsql
	AS $$
BEGIN
    PERFORM check_player_duplicate(p_email, p_username);

	INSERT INTO player(email, username, activity_state, region_name)
		VALUES(p_email, p_username, p_activity_state, p_region_name);
END;$$;

CREATE OR REPLACE PROCEDURE mudarEstadoJogador(
	p_id INT,
	new_state TEXT
)
    LANGUAGE plpgsql
	AS $$
BEGIN
	PERFORM check_player_exists(p_id);
	PERFORM check_player_has_state(p_id, new_state);

	UPDATE player SET activity_state = new_state WHERE id = p_id;
END;$$;

-- Nível de isolamento default (não necessita de ser definido explicitamente)
CREATE OR REPLACE PROCEDURE desativarJogador(
	p_id INT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	CALL mudarEstadoJogador(p_id, 'Inactive');
END;$$;

-- Nível de isolamento default (não necessita de ser definido explicitamente)
CREATE OR REPLACE PROCEDURE banirJogador(
	p_id INT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	CALL mudarEstadoJogador(p_id, 'Banned');
END;$$;


-- ############################ EX e ################################

-- Nível de isolamento default (não necessita de ser definido explicitamente)
CREATE OR REPLACE FUNCTION totalPontosJogador(p_id INT)
	RETURNS INT
	LANGUAGE plpgsql
	AS $$
DECLARE
	points INT;
BEGIN
	PERFORM check_player_exists(p_id);

	SELECT SUM(p.score) INTO points FROM player_score AS p WHERE p.player_id = p_id;
	RETURN points;
END;$$;


-- ############################ EX f ################################

-- Nível de isolamento default (não necessita de ser definido explicitamente)
CREATE OR REPLACE FUNCTION totalJogosJogador(p_id INT)
    RETURNS INT
	LANGUAGE plpgsql
    AS $$
DECLARE
	games_count INT;
BEGIN
	PERFORM check_player_exists(p_id);

	SELECT COUNT(DISTINCT game_id) INTO games_count FROM player_score AS ps WHERE ps.player_id = p_id;
	RETURN games_count;
END;$$;


-- ############################ EX g ################################

CREATE OR REPLACE FUNCTION pontosJogoPorJogador(g_id VARCHAR)
    RETURNS TABLE(player_id INT, points INT)
	LANGUAGE plpgsql
	AS $$
DECLARE
    i RECORD;
BEGIN
	PERFORM check_game_exists(g_id);

	FOR i IN (
		SELECT p.player_id, SUM(p.score) FROM player_score AS p WHERE p.game_id = g_id GROUP BY p.player_id
	) LOOP
		player_id := i.player_id;
		points := i.sum;
		RETURN NEXT;
	END LOOP;

END;$$;


-- ############################ EX h ################################

CREATE OR REPLACE PROCEDURE associarCrachá(
	p_id INT,
	g_id TEXT,
	badge TEXT
)
	LANGUAGE plpgsql
	AS $$
DECLARE
	needed_points INT DEFAULT -1;
	user_points INT DEFAULT -1;
BEGIN
	PERFORM check_player_exists(p_id);
	PERFORM check_game_exists(g_id);
	PERFORM check_player_has_badge(p_id, g_id, badge);

	-- Obtain user points in the game
	SELECT SUM(p.score) INTO user_points FROM player_score AS p WHERE p.player_id = p_id AND p.game_id = g_id;
	-- Obtain needed points for the badge
	SELECT b.points_limit INTO needed_points FROM badge AS b WHERE b.game_id = g_id AND b.b_name = badge;

	IF user_points >= needed_points THEN
		INSERT INTO player_badge VALUES(p_id, badge, g_id);
	ELSE
		RAISE EXCEPTION 'Player does not have enough points: (%) needed: (%)', user_points, needed_points
	    	USING ERRCODE = '22000';
	END IF;
END;$$;

CREATE OR REPLACE PROCEDURE associarCracháIsol(
	user_id INT,
	game TEXT,
	badge TEXT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	ROLLBACK;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL associarCrachá(user_id, game, badge);
END;$$;


-- ############################ EX i ################################

CREATE OR REPLACE FUNCTION insert_message()
    RETURNS TRIGGER
	LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.n_order = (
		SELECT COALESCE(MAX(n_order), 0) + 1
		FROM message
		WHERE chat_id = NEW.chat_id
	);
	NEW.m_time = now();
	RETURN NEW;
END;$$;

CREATE OR REPLACE TRIGGER insert_message_trigger
	BEFORE INSERT ON message
	FOR EACH ROW
	WHEN (NEW.n_order IS NULL)
		EXECUTE FUNCTION insert_message();

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
	PERFORM check_player_exists(p_id);
	PERFORM check_chat_name_is_empty(chat_name);

	-- Insert a new chat and get its id
	INSERT INTO chat (c_name) VALUES (chat_name) RETURNING id INTO c_id;

	-- Insert a lookup record to associate the player with the chat
	INSERT INTO chat_lookup (chat_id, player_id) VALUES (c_id, p_id);

	-- Get the player's username
	SELECT username INTO player_name FROM player WHERE id = p_id;

	-- Insert a message to indicate that the player started the chat
	INSERT INTO message (chat_id, player_id, m_text)
	VALUES (c_id, p_id, CONCAT(player_name, ' started the chat.'));
END;$$;

CREATE OR REPLACE PROCEDURE iniciarConversaIsol (
	IN p_id INT,
	IN chat_name TEXT,
	OUT c_id INT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	ROLLBACK;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL iniciarConversa(p_id, chat_name, c_id);
END;$$;


-- ############################ EX j ################################

CREATE OR REPLACE PROCEDURE juntarConversa(
	p_id INT,
	c_id INT
)
	LANGUAGE plpgsql
	AS $$
DECLARE
	player_name VARCHAR;
BEGIN
	PERFORM check_player_exists(p_id);
	PERFORM check_chat_exists(c_id);
	PERFORM check_player_in_chat(p_id, c_id);

	-- Insert lookup record for the player and the chat
	INSERT INTO chat_lookup(chat_id, player_id) VALUES (c_id, p_id);

	-- Get the player's username
	SELECT username INTO player_name FROM player WHERE id = p_id;

	-- Insert a message to indicate that the player joined the chat
	INSERT INTO message (chat_id, player_id, m_text)
	VALUES (c_id, p_id, CONCAT(player_name, ' joined the chat.'));

END;$$;

CREATE OR REPLACE PROCEDURE juntarConversaIsol(
	p_id INT,
	c_id INT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	ROLLBACK;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL juntarConversa(p_id, c_id);
END;$$;


-- ############################ EX k ################################
 
CREATE OR REPLACE PROCEDURE enviarMensagem(
	p_id INT,
	c_id INT,
	msg TEXT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	PERFORM check_player_exists(p_id);
	PERFORM check_chat_exists(c_id);
	PERFORM check_player_chat_permission(p_id, c_id);

	INSERT INTO message(chat_id, player_id, m_text) VALUES(c_id, p_id, msg);
		
	EXCEPTION
	WHEN SQLSTATE '22001' THEN -- Handle messages being too big
		RAISE EXCEPTION 'Attempted to send a message that is too big'
			USING ERRCODE = '22001';
END;$$;

CREATE OR REPLACE PROCEDURE enviarMensagemIsol(
	user_id INT,
	c_id INT,
	msg TEXT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	ROLLBACK;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL enviarMensagem(user_id, c_id, msg);
END;$$;


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


-- ############################ EX m ################################

CREATE OR REPLACE FUNCTION trigger_exM()
    RETURNS TRIGGER
	LANGUAGE plpgsql
	AS $$
DECLARE
    player RECORD;
	badge RECORD;
BEGIN
    IF NEW.state = 'Finished' THEN
        -- call the associarCrachá procedure for each player in the match
        FOR player IN (
			SELECT ps.player_id
            FROM player_score ps
            WHERE ps.match_number = NEW.match_number AND ps.game_id = NEW.game_id
		)
		LOOP
			FOR badge IN (
				SELECT b.b_name
				FROM badge b
				WHERE b.game_id = NEW.game_id
			)
			LOOP
			    BEGIN
				-- call the associarCrachá procedure for each badge in the game
					CALL associarCrachá(player.player_id, NEW.game_id, badge.b_name);
					EXCEPTION
						WHEN SQLSTATE '22000' THEN
			        	WHEN SQLSTATE '23505' THEN
				END;
			END LOOP;
		END LOOP;
    END IF;
    RETURN NULL;
END;$$;

CREATE OR REPLACE TRIGGER EX_M
    AFTER UPDATE OF state ON match_multiplayer
		FOR EACH ROW
		WHEN (NEW.state = 'Finished' AND OLD.state = 'Ongoing')
			EXECUTE FUNCTION trigger_exM();


-- ############################ EX n ################################

CREATE OR REPLACE FUNCTION delete_totalPlayerInfo()
    RETURNS TRIGGER
	LANGUAGE plpgsql
    AS $$
BEGIN
	--
	-- Perform the required operation on emp, and create a row in emp_audit
	-- to reflect the change made to emp.
	--
	IF (TG_OP = 'DELETE') THEN
		CALL banirJogador(OLD.id);
	ELSE
		RAISE NOTICE 'Trigger ran on an operation % instead of delete', TG_OP;
	END IF;
	RETURN NEW;
END;$$;

CREATE OR REPLACE TRIGGER banUserOnTotalInfoDel
	INSTEAD OF DELETE ON jogadorTotalInfo
		FOR EACH ROW
    		EXECUTE FUNCTION delete_totalPlayerInfo();
