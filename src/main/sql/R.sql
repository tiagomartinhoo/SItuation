-- ############################ EX e ################################

create or replace function totalPontosJogador(user_id int, points OUT int)
language plpgsql
As
$$
begin
	SELECT into points SUM(p.score) from PLAYER_SCORE as p where p.player_id = user_id;
end;$$;

-- Validação
SELECT * from PLAYER_SCORE;

SELECT totalPontosJogador(1);

-- ############################ EX h ################################

create or replace procedure associarCrachá(user_id int, game_id int, badge text)
language plpgsql
As
$$
begin
	-- TODO
end;$$;

-- ############################ EX k ################################

create or replace procedure enviarMensagem(user_id int, c_id int, msg text)
language plpgsql
As
$$

begin
	-- TODO
end;$$;