DO
$$
BEGIN

	DROP VIEW IF EXISTS jogadortotalinfo;

    DROP TABLE IF EXISTS friendship;

    DROP TABLE IF EXISTS chat_lookup;

    DROP TABLE IF EXISTS message;

    DROP TABLE IF EXISTS chat;

    DROP TABLE IF EXISTS purchase;

    DROP TABLE IF EXISTS match_normal;

    DROP TABLE IF EXISTS match_multiplayer;

    DROP TABLE IF EXISTS player_score;

    DROP TABLE IF EXISTS match;

    DROP TABLE IF EXISTS player_badge;

    DROP TABLE IF EXISTS badge;

    DROP TABLE IF EXISTS statistic_player;

    DROP TABLE IF EXISTS player;

    DROP TABLE IF EXISTS region;

    DROP TABLE IF EXISTS statistic_game;

    DROP TABLE IF EXISTS game;

END;$$;