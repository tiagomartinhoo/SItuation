DO
$$
BEGIN
    DROP FUNCTION IF EXISTS check_player_duplicate (TEXT, TEXT);

    DROP FUNCTION IF EXISTS check_player_exists(INT);

    DROP FUNCTION IF EXISTS check_player_has_state(INT, TEXT);

    DROP FUNCTION IF EXISTS check_player_has_badge(INT, TEXT, TEXT);

    DROP FUNCTION IF EXISTS check_game_exists(VARCHAR);
    
    DROP FUNCTION IF EXISTS check_chat_exists(INT);
    
    DROP FUNCTION IF EXISTS check_chat_name_is_empty(TEXT);

    DROP FUNCTION IF EXISTS check_player_in_chat(INT, INT);

    DROP FUNCTION IF EXISTS check_player_chat_permission(INT, INT);

    DROP PROCEDURE IF EXISTS criarJogador(TEXT, TEXT, TEXT, TEXT);

    DROP PROCEDURE IF EXISTS mudarEstadoJogador(INT, TEXT);

    DROP PROCEDURE IF EXISTS desativarJogador(INT);

    DROP PROCEDURE IF EXISTS banirJogador(INT);

    DROP FUNCTION IF EXISTS totalPontosJogador(INT);

    DROP FUNCTION IF EXISTS totalJogosJogador(INT);

    DROP FUNCTION IF EXISTS pontosJogoPorJogador(VARCHAR);

    DROP PROCEDURE IF EXISTS associarCrachá(INT, TEXT, TEXT);

    DROP PROCEDURE IF EXISTS associarCracháIsol(INT, TEXT, TEXT);

    DROP TRIGGER IF EXISTS insert_message_trigger ON message;
	
    DROP FUNCTION IF EXISTS insert_message();

    DROP PROCEDURE IF EXISTS iniciarConversa(INT, TEXT, INT);

    DROP PROCEDURE IF EXISTS iniciarConversaIsol(INT, TEXT, INT);

    DROP PROCEDURE IF EXISTS juntarConversa(INT, INT);

    DROP PROCEDURE IF EXISTS juntarConversaIsol(INT, INT);

    DROP PROCEDURE IF EXISTS enviarMensagem(INT, INT, TEXT);

    DROP PROCEDURE IF EXISTS enviarMensagemIsol(INT, INT, TEXT);

	DROP TRIGGER IF EXISTS EX_M ON match_multiplayer;

    DROP FUNCTION IF EXISTS trigger_exM();
	
	DROP TRIGGER IF EXISTS banUserOnTotalInfoDel ON jogadorTotalInfo;

    DROP FUNCTION IF EXISTS delete_totalPlayerInfo();

END;$$;