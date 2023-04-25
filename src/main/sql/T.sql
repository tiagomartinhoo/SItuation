
-- ############################ EX f ################################

create or replace function totalJogosJogador(user_id int, OUT games_count int) 
language plpgsql
As
$$

begin
  -- TODO: obter a contagem das entradas em MATCH com game_id unico
  
  	return games_count;
  
end;$$;





-- ############################ EX i ################################

create or replace procedure iniciarConversa(user_id int, c_name text, OUT c_id int)
language plpgsql
As
$$

begin
	-- TODO
end;$$;

-- ############################ EX l ################################

create or replace procedure jogadorTotalInfo()
language plpgsql
As
$$

begin
	-- TODO
end;$$;