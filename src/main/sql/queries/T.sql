
-- ############################ EX f ################################

CREATE OR REPLACE FUNCTION totalJogosJogador(p_id INT) RETURNS INT
	LANGUAGE plpgsql AS $$
DECLARE
	games_count INT;
BEGIN
	SELECT COUNT(DISTINCT game_id) INTO games_count
	FROM player_score AS ps
	WHERE ps.player_id = p_id;
	RETURN games_count;
END;
$$;

-- TEST
SELECT totalJogosJogador(2);


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

	INSERT INTO chat (c_name) VALUES (chat_name) RETURNING id INTO c_id;

	INSERT INTO chat_lookup (chat_id, player_id) VALUES (c_id, p_id);

	SELECT username INTO player_name FROM player WHERE id = p_id;

	INSERT INTO message (chat_id, player_id, m_time, m_text)
	VALUES (c_id, p_id, NOW(), CONCAT('The player ', player_name, ' starts the chat.'));
END;
$$;

-- TEST
DO $$
DECLARE res INT;
BEGIN
	CALL iniciarConversa(1,'Test', res);
	RAISE NOTICE 'Chat id = %', res;
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