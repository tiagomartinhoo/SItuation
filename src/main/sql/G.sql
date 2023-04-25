-- ############################ EX d ################################

create or replace procedure criarJogador(
	email text,
	username text,
	activity_state text,
	region_name text
) language plpgsql
As
$$
begin
	insert into player(email,region_name, username)
		VALUES(email, username, 'Active', region_name)
end;$$;

create or replace procedure mudarEstadoJogador(username text, activity_state text)
language plpgsql
As
$$
begin
	-- TODO
end;$$;

create or replace procedure desativarJogador(username text)
language plpgsql
As
$$
begin
	PERFORM
	mudarEstadoJogador(username, 'Inactive')
end;$$;

create or replace procedure banirJogador(username text)
language plpgsql
As
$$
begin
	PERFORM
	mudarEstadoJogador(username, 'Banned')
end;$$;

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