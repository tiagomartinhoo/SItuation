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

create or replace function pontosJogoPorJogador(game_id int) RETURNS TABLE(user_id int, points integer)
language plpgsql
As
$$
Declare
	-- Probably gonna need to declare somewhere to store user_id and auxiliary count
begin
	-- something something loop(...) return NEXT
  
  	return;
  
end;$$;

-- ############################ EX j ################################

create or replace procedure juntarConversa(user_id int, c_id int)
language plpgsql
As
$$

begin
	-- TODO
end;$$;