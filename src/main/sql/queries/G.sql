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
END;$$;

-- TEST
CALL criarJogador('test@gmail.com','test','Banned','Sintra');


CREATE OR REPLACE PROCEDURE mudarEstadoJogador(p_id INT, new_state TEXT)
LANGUAGE plpgsql
AS
$$
BEGIN
	UPDATE player SET activity_state = new_state WHERE id = p_id;
END;$$;


CREATE OR REPLACE PROCEDURE desativarJogador(p_id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
	CALL mudarEstadoJogador(p_id, 'Inactive');
END;$$;

-- TEST
CALL desativarJogador(1);

CREATE OR REPLACE PROCEDURE banirJogador(p_id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
	CALL mudarEstadoJogador(p_id, 'Banned');
END;$$;

-- TEST
CALL banirJogador(1);


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
       /* BEGIN

        EXCEPTION
            WHEN no_data_found THEN
                raise exception 'Game ID % does not exist in the game table', g_id;
        END;*/
    else
        raise notice 'Game id is null';
    end if;
  
end;$$;


SELECT * from pontosJogoPorJogador('abcdefghi8');--one player in game
SELECT * from pontosJogoPorJogador('bbbbbbbbb1');-- multiple player in game
SELECT * from pontosJogoPorJogador(null);-- returns null
SELECT * from pontosJogoPorJogador('abscvggggg');-- returns exception/notice

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

insert into chat_lookup(chat_id, player_id)
VALUES (1,1),
       (1,2);

CALL juntarConversa(3,1);
CALL juntarConversa(3,2);
CALL juntarConversa(3,null);
CALL juntarConversa(null,1);
CALL juntarConversa(3,3);--chat id does not exist
CALL juntarConversa(7,1);-- player id does not exist
CALL juntarConversa(3,1);-- player already in chat


-- ############################ EX m ################################

CREATE TRIGGER EX_M
    AFTER UPDATE OF state ON match_multiplayer
    FOR EACH ROW
    when (NEW.state = 'Finished' AND OLD.state = 'Ongoing')
    EXECUTE FUNCTION  trigger_exM();

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

insert into match_multiplayer(match_number, game_id, state)
VALUES(2, 'bbbbbbbbb1', 'Ongoing')
;

-- working when theplayer dont have enough points for a badge
-- error when a player has enough points
UPDATE match_multiplayer SET state = 'Finished' where match_number = 2 and game_id = 'bbbbbbbbb1';