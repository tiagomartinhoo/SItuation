
-- ############################ EX f ################################

CREATE OR REPLACE FUNCTION totalJogosJogador(p_id INT)
	RETURNS INT AS $$
DECLARE
	games_count INT;
BEGIN
	SELECT COUNT(DISTINCT game_id) INTO games_count
	FROM player_score AS p
	WHERE p.player_id = p_id;
	RETURN games_count;
END;
$$ LANGUAGE plpgsql;

SELECT totalJogosJogador(2);


-- ############################ EX i ################################

CREATE OR REPLACE PROCEDURE iniciarConversa (
	p_id INT,
	chat_name TEXT,
	OUT c_id INT
)
	LANGUAGE plpgsql
AS $$
DECLARE
	player_name VARCHAR;
BEGIN
	-- insere a conversa na tabela de chat e retorna o id
	INSERT INTO chat (c_name)
	VALUES (chat_name)
	RETURNING id INTO c_id;

	-- insere o player na tabela de chat_lookup
	INSERT INTO chat_lookup (chat_id, player_id)
	VALUES (c_id, p_id);

	-- obtém o name do player que iniciou a conversa
	SELECT username INTO player_name
	FROM player
	WHERE id = p_id;

	-- insere uma mensagem na conversa informando que o jogador criou a conversa
	INSERT INTO message
	VALUES (1, c_id, p_id, NOW(), CONCAT('The player ', player_name, ' starts the chat.'));

END;
$$;

CALL iniciarConversa(1, CAST('Test' AS TEXT));


-- ############################ EX l ################################

create or replace procedure jogadorTotalInfo()
language plpgsql
As
$$

begin
	-- TODO
end;$$;