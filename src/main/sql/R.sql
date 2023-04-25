-- ############################ EX e ################################

create or replace function totalPontosJogador(user_id int, OUT points int) 
language plpgsql
As
$$

begin
  -- TODO: obter a soma da coluna score da tabela PLAYER_SCORE
  
  	return points;
  
end;$$;

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