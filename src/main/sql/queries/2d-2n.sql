-- Util functions
CREATE OR REPLACE FUNCTION check_player_exists(p_id INT) RETURNS BOOL AS $$
BEGIN
    IF NOT EXISTS(SELECT 1 FROM player WHERE id = p_id) THEN
        RAISE NOTICE 'Player with ID % does not exist', p_id;
        RETURN FALSE;
    ELSE
        RETURN TRUE;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION check_chat_name_is_empty(c_name TEXT) RETURNS BOOL AS $$
BEGIN
    IF length(c_name) = 0 THEN
        RAISE NOTICE 'Name of the chat can not be empty';
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- ############################ EX d ################################

CREATE OR REPLACE PROCEDURE criarJogador(
	p_email TEXT,
	p_username TEXT,
	p_activity_state TEXT,
	p_region_name TEXT
) LANGUAGE plpgsql
AS
$$
BEGIN
	INSERT INTO player(email, username, activity_state, region_name)
		VALUES(p_email, p_username, p_activity_state, p_region_name);
	exception
		when sqlstate '23505' then -- Handle duplicate key (bad insert)
			raise notice 'The email/username are already in use';
END;$$;

CREATE OR REPLACE PROCEDURE mudarEstadoJogador(p_id INT, new_state TEXT)
LANGUAGE plpgsql
AS
$$
BEGIN
	UPDATE player SET activity_state = new_state WHERE id = p_id;
END;$$;

-- Nível de isolamento default (não necessita de ser definido explicitamente)
CREATE OR REPLACE PROCEDURE desativarJogador(p_id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
	CALL mudarEstadoJogador(p_id, 'Inactive');
END;$$;

-- Nível de isolamento default (não necessita de ser definido explicitamente)
CREATE OR REPLACE PROCEDURE banirJogador(p_id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
	CALL mudarEstadoJogador(p_id, 'Banned');
END;$$;

-- ############################ EX e ################################

-- Nível de isolamento default (não necessita de ser definido explicitamente)
create or replace function totalPontosJogador(user_id int, points OUT int)
language plpgsql
As
$$
begin
	SELECT into points SUM(p.score) from PLAYER_SCORE as p where p.player_id = user_id;
end;$$;
	
-- ############################ EX f ################################

-- Nível de isolamento default (não necessita de ser definido explicitamente)
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

-- ############################ EX g ################################

create or replace function pontosJogoPorJogador(g_id varchar) RETURNS TABLE(user_id int, points integer)
language plpgsql
As
$$
Declare
    i record; --for the for loop
begin

    if g_id is not null then

        if exists(SELECT id FROM game WHERE id = g_id) then
            for i in (
                SELECT p.player_id, SUM(p.score) FROM player_score AS p WHERE p.game_id = g_id GROUP BY p.player_id
            )LOOP
                    user_id := i.player_id;
                    points := i.sum;
                    RETURN NEXT;
                end loop;
        else
            raise notice 'Game ID % does not exist in the game table', g_id;
        end if;
       
    else
        raise notice 'Game id is null';
    end if;
  
end;$$;

-- ############################ EX h ################################


create or replace procedure associarCrachá(user_id int, game text, badge text)
language plpgsql
As
$$
Declare
	needed_points int DEFAULT -1;
	user_points int DEFAULT -1;
begin
    -- Verify that the user does not already have the badge
	PERFORM * from PLAYER_BADGE as t where t.player_id = user_id and game_id = game and b_name = badge;
	if found then
		raise notice 'Player already has the badge';
		return;
	end if;

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


-- RR porque há a verificação dos pontos e de o utilizador não ter o crachá (não permitir double insert)
create or replace procedure associarCracháIsol(user_id int, game text, badge text)
language plpgsql
As
$$
BEGIN
	rollback;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL associarCrachá(user_id, game, badge);
END;$$;

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

-- RR porque temos de garantir que as inserções e as validações continuam válidas até ao fim
CREATE OR REPLACE PROCEDURE iniciarConversaIsol (
	IN p_id INT,
	IN chat_name TEXT,
	OUT c_id INT
)
	LANGUAGE plpgsql
AS $$
BEGIN
	rollback;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	CALL iniciarConversa(p_id, chat_name, c_id);
END;
$$;

-- ############################ EX j ################################

create or replace procedure juntarConversa(user_id int, c_id int)
language plpgsql
As
$$

begin
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

end;$$;
-- RR porque se verificamos que o utilizador tem permissões, continua a precisar de as ter ao inserir mensagem
create or replace procedure juntarConversaIsol(user_id int, c_id int)
language plpgsql
As
$$
begin
	rollback;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	call juntarConversa(user_id, c_id);
end;$$;
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

	INSERT INTO message(chat_id, player_id, m_time, m_text) 
		Values(c_id, user_id, now(), msg);
		
	exception 
	when sqlstate '22001' then -- Handle messages being too big
		raise notice 'Attempted to send a message that is too big';
end;$$;

-- RR porque se o utilizador tem permissões para falar no chat, continua a precisar de as ter até à mensagem ser enviada
create or replace procedure enviarMensagemIsol(user_id int, c_id int, msg text)
language plpgsql
As
$$
begin
	rollback;
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
	call enviarMensagem(user_id, c_id, msg);
end;$$;

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

CREATE OR REPLACE FUNCTION trigger_exM() RETURNS TRIGGER
LANGUAGE plpgsql
AS
$$
DECLARE
        player record;
BEGIN
    IF NEW.state = 'Finished' THEN
        -- call the associarCrachá procedure for each player in the match
        FOR player IN (SELECT player_id
                       FROM PLAYER_SCORE
                       WHERE match_number = NEW.match_number AND game_id = NEW.game_id)
            LOOP
                CALL associarCrachá(player.player_id, NEW.game_id, 'Win-Streak');
            END LOOP;
    END IF;
    RETURN NULL;
END;$$;

CREATE OR REPLACE TRIGGER EX_M
    AFTER UPDATE OF state ON match_multiplayer
    FOR EACH ROW
    when (NEW.state = 'Finished' AND OLD.state = 'Ongoing')
    EXECUTE FUNCTION  trigger_exM();


-- ############################ EX n ################################

CREATE OR REPLACE FUNCTION delete_totalPlayerInfo() RETURNS TRIGGER AS $$
    BEGIN
        --
        -- Perform the required operation on emp, and create a row in emp_audit
        -- to reflect the change made to emp.
        --
        IF (TG_OP = 'DELETE') THEN
            CALL banirJogador(OLD.id);
        ELSE
			raise notice 'Trigger ran on an operation % instead of delete', TG_OP;
        END IF;
		RETURN NEW;
    END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER banUserOnTotalInfoDel
INSTEAD OF DELETE ON jogadorTotalInfo
    FOR EACH ROW EXECUTE FUNCTION delete_totalPlayerInfo();
