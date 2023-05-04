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