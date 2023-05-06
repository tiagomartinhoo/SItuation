-- Util functions

CREATE OR REPLACE FUNCTION check_player_exists(p_id INT)
    RETURNS BOOL
	LANGUAGE plpgsql
    AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM player WHERE id = p_id) THEN
        RAISE NOTICE 'Player with ID % does not exist', p_id;
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;$$;

CREATE OR REPLACE FUNCTION check_chat_name_is_empty(c_name TEXT)
    RETURNS BOOL
	LANGUAGE plpgsql
    AS $$
BEGIN
    IF length(c_name) = 0 THEN
        RAISE NOTICE 'Name of the chat can not be empty';
        RETURN TRUE;
    ELSE
        RETURN FALSE;
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
	INSERT INTO player(email, username, activity_state, region_name)
		VALUES(p_email, p_username, p_activity_state, p_region_name);
	exception
		when sqlstate '23505' then -- Handle duplicate key (bad insert)
			raise notice 'The email/username are already in use';
END;$$;

CREATE OR REPLACE PROCEDURE mudarEstadoJogador(
	p_id INT,
	new_state TEXT
)
    LANGUAGE plpgsql
	AS $$
BEGIN
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
CREATE OR REPLACE FUNCTION totalPontosJogador(user_id INT)
	RETURNS INT
	LANGUAGE plpgsql
	AS $$
DECLARE
	points INT;
BEGIN
	SELECT INTO points SUM(p.score) FROM player_score AS p WHERE p.player_id = user_id;
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
	SELECT INTO games_count COUNT(DISTINCT game_id) FROM player_score AS ps WHERE ps.player_id = p_id;
	RETURN games_count;
END;$$;

-- ############################ EX g ################################

CREATE OR REPLACE FUNCTION pontosJogoPorJogador(g_id VARCHAR)
    RETURNS TABLE(user_id INT, points INT)
	LANGUAGE plpgsql
	AS $$
DECLARE
    i RECORD;
BEGIN
    IF g_id IS NOT NULL THEN

        IF exists(SELECT id FROM game WHERE id = g_id) THEN
            FOR i IN (
                SELECT p.player_id, SUM(p.score) FROM player_score AS p WHERE p.game_id = g_id GROUP BY p.player_id
            ) LOOP
                    user_id := i.player_id;
                    points := i.sum;
                	RETURN NEXT;
                END LOOP;
        ELSE
            RAISE NOTICE 'Game ID % does not exist in the game table', g_id;
        END IF;
       
    ELSE
        RAISE NOTICE 'Game id is null';
    END IF;

END;$$;

-- ############################ EX h ################################


CREATE OR REPLACE PROCEDURE associarCrachá(
	user_id INT,
	game TEXT,
	badge TEXT
)
	LANGUAGE plpgsql
	AS $$
DECLARE
	needed_points INT DEFAULT -1;
	user_points INT DEFAULT -1;
BEGIN
    -- Verify that the user does not already have the badge
	PERFORM * FROM PLAYER_BADGE AS t WHERE t.player_id = user_id AND game_id = game AND b_name = badge;
	IF FOUND THEN
		RAISE NOTICE 'Player already has the badge';
		RETURN;
	END IF;

	-- Obtain user points in the game
	SELECT INTO user_points SUM(p.score) FROM player_score AS p WHERE p.player_id = user_id AND (p.game_id = game);
	-- Obtain needed points for the badge
	SELECT INTO needed_points b.points_limit FROM badge AS b WHERE b.game_id = game_id AND b.b_name = badge;

	IF needed_points = -1 OR user_points = -1 THEN
		RAISE NOTICE 'One of the queries went wrong';
	END IF;

	IF user_points >= needed_points THEN
		INSERT INTO player_badge VALUES(user_id, badge, game);
	ELSE
		RAISE NOTICE 'User does not have enough points: (%) needed: (%)', user_points, needed_points;
	END IF;
END;$$;


-- RR porque há a verificação dos pontos e de o utilizador não ter o crachá (não permitir double insert)
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
	INSERT INTO message (chat_id, player_id, m_text)
	VALUES (c_id, p_id, CONCAT('The player ', player_name, ' starts the chat.'));
END;$$;

-- RR porque temos de garantir que as inserções e as validações continuam válidas até ao fim
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
	user_id INT,
	c_id INT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
    --verify if the ids are null
    --verify if the ids exist
    --verify if the parameter user_id is already in the chat_lookup table
    if c_id is not null then
        if exists(SELECT c_id from chat where id = c_id) then
            if user_id is not null then
                if exists(SELECT user_id from player where id = user_id) then
                    if exists(SELECT user_id from chat_lookup where player_id = user_id and chat_id = c_id) then
                        raise notice 'Player ID % its already in the chat with the id %', user_id, c_id;
                    else --if the player id isnt already in the table with the specific chat id in the parameter c_id insert
                        insert into chat_lookup(chat_id, player_id)
                        VALUES (c_id, user_id);
                    end if;

                else
                    raise notice 'Player ID % does not exist in the player table', user_id;
                end if;

            else
                raise notice 'Player id is null';
            end if;
        else
            raise notice 'Chat ID % does not exist in the chat table', c_id;
        end if;

    else
        raise notice 'Chat id is null';
    end if;

END;$$;

-- RR porque se verificamos que o utilizador tem permissões, continua a precisar de as ter ao inserir mensagem
CREATE OR REPLACE PROCEDURE juntarConversaIsol(
	user_id INT,
	c_id INT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	ROLLBACK;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL juntarConversa(user_id, c_id);
END;$$;

-- ############################ EX k ################################
 
CREATE OR REPLACE PROCEDURE enviarMensagem(
	user_id INT,
	c_id INT,
	msg TEXT
)
	LANGUAGE plpgsql
	AS $$
BEGIN
	PERFORM * FROM chat_lookup AS c WHERE c.player_id = user_id AND c.chat_id = c_id;
	IF NOT FOUND THEN
		-- Some error condition (user/chat does not exist or user doesn't have access to chat)
		RAISE NOTICE 'User does not have permission to chat in this chat';
		RETURN;
	END IF;

	INSERT INTO message(chat_id, player_id, m_text)
		VALUES(c_id, user_id, msg);
		
	EXCEPTION
	WHEN SQLSTATE '22001' THEN -- Handle messages being too big
		RAISE NOTICE 'Attempted to send a message that is too big';
END;$$;

-- RR porque se o utilizador tem permissões para falar no chat, continua a precisar de as ter até à mensagem ser enviada
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
				-- call the associarCrachá procedure for each badge in the game
				CALL associarCrachá(player.player_id, NEW.game_id, badge.b_name);
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
