DO
$$
begin
	SET default_transaction_isolation = 'serializable';
	raise notice 'Nível de isolamento antes de terminar = %',current_setting('transaction_isolation'); -- só para teste
end;$$;


DO
$$

begin
	call x(11,'aa');
	call x(2,'bb');
	call x(1,'aa');

	rollback; -- Rollback não aborta todos os x(...)
end;$$;

select * from t ;