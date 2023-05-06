DO
$$
BEGIN
    CREATE TABLE IF NOT EXISTS region (
        r_name  VARCHAR(20) PRIMARY KEY
    );

    CREATE TABLE IF NOT EXISTS player (
        id              SERIAL PRIMARY KEY,
        email           VARCHAR(50) UNIQUE NOT NULL,
        username        VARCHAR(20) UNIQUE NOT NULL,
        activity_state  VARCHAR(100),
        region_name     VARCHAR(20) NOT NULL,

        FOREIGN KEY(region_name) REFERENCES region (r_name),

        CONSTRAINT email_is_valid CHECK ( email ~ '^[A-Za-z0-9+_.-]+@(.+)$' ),
        CONSTRAINT state_is_valid CHECK ( activity_state IN ('Active', 'Inactive', 'Banned') )
    ); 

    CREATE TABLE IF NOT EXISTS friendship (
        player1_id INT NOT NULL,
        player2_id INT NOT NULL,

        PRIMARY KEY(player1_id, player2_id),
        FOREIGN KEY(player1_id) REFERENCES player (id),
        FOREIGN KEY(player2_id) REFERENCES player (id)
    );

    CREATE TABLE IF NOT EXISTS chat (
        id      SERIAL PRIMARY KEY,
        c_name  VARCHAR(20) NOT NULL
    );

    CREATE TABLE IF NOT EXISTS chat_lookup (
        chat_id     INT NOT NULL,
        player_id   INT NOT NULL,

        PRIMARY KEY(chat_id, player_id),
        FOREIGN KEY(chat_id) REFERENCES chat (id),
        FOREIGN KEY(player_id) REFERENCES player (id)
    );

    CREATE TABLE IF NOT EXISTS message (
        n_order     INT NOT NULL,
        chat_id     INT NOT NULL,
        player_id   INT NOT NULL,
        m_time      TIMESTAMP NOT NULL,
        m_text      VARCHAR(200) NOT NULL,

        PRIMARY KEY(n_order, chat_id),
        FOREIGN KEY(chat_id) REFERENCES chat (id),
        FOREIGN KEY(player_id) REFERENCES player (id)
    );

    CREATE TABLE IF NOT EXISTS game (
        id      VARCHAR(10) PRIMARY KEY,
        g_name  VARCHAR(20) UNIQUE NOT NULL,
        url     VARCHAR(100),

        CONSTRAINT url_is_valid CHECK ( url LIKE 'https://%' )
    );

    CREATE TABLE IF NOT EXISTS purchase (
        player_id   INT NOT NULL,
        game_id     VARCHAR(10) NOT NULL,
        p_date      TIMESTAMP NOT NULL,
        price       INT NOT NULL,

        PRIMARY KEY(player_id, game_id),
        FOREIGN KEY(player_id) REFERENCES player (id),
        FOREIGN KEY(game_id) REFERENCES game (id)
    );

    CREATE TABLE IF NOT EXISTS match (
        number      INT NOT NULL,
        game_id     VARCHAR(10) NOT NULL,
        dt_start    TIMESTAMP NOT NULL,
        dt_end      TIMESTAMP,

        PRIMARY KEY(number, game_id),
        FOREIGN KEY(game_id) REFERENCES game (id),

        CONSTRAINT start_date_less_than_end CHECK ( dt_start < dt_end)
    );

    CREATE TABLE IF NOT EXISTS match_normal (
        match_number        INT NOT NULL,
        game_id             VARCHAR(10) NOT NULL,
        difficulty_level    INT NOT NULL,

        PRIMARY KEY(match_number, game_id),
        FOREIGN KEY(match_number, game_id) REFERENCES match(number, game_id),

        CONSTRAINT difficulty_level_is_valid CHECK ( difficulty_level >= 1 and difficulty_level <= 5 )
    );

    CREATE TABLE IF NOT EXISTS match_multiplayer (
        match_number    INT NOT NULL,
        game_id         VARCHAR(10) NOT NULL,
        state           VARCHAR(20),

        PRIMARY KEY(match_number, game_id),
        FOREIGN KEY(match_number, game_id) REFERENCES match(number, game_id),

        CONSTRAINT state_is_valid CHECK ( state IN ('To start', 'Waiting for players', 'Ongoing', 'Finished') )
    );

    CREATE TABLE IF NOT EXISTS player_score (
        player_id       INT NOT NULL,
        match_number    INT NOT NULL,
        game_id         VARCHAR(10) NOT NULL,
        score           INT NOT NULL,

        PRIMARY KEY(player_id, match_number, game_id),
        FOREIGN KEY(player_id) REFERENCES player (id),
        FOREIGN KEY(match_number, game_id) REFERENCES match (number, game_id)
    );

    CREATE TABLE IF NOT EXISTS badge (
        b_name          VARCHAR(20) NOT NULL,
        game_id         VARCHAR(10) NOT NULL,
        points_limit    INT,
        url             VARCHAR(100),

        PRIMARY KEY(b_name, game_id),
        FOREIGN KEY(game_id) REFERENCES game (id),

        CONSTRAINT url_is_valid CHECK ( url LIKE 'https://%' )
    );
	
	CREATE TABLE IF NOT EXISTS player_badge (
        player_id   INT NOT NULL,
        b_name      VARCHAR(20) NOT NULL,
        game_id     VARCHAR(10) NOT NULL,

        PRIMARY KEY(player_id, b_name, game_id),
        FOREIGN KEY(b_name, game_id) REFERENCES badge(b_name, game_id),
        FOREIGN KEY(player_id) REFERENCES player (id)
    );

    CREATE TABLE IF NOT EXISTS statistic_player (
        player_id       INT PRIMARY KEY,
        matches_played  INT NOT NULL,
        total_points    INT NOT NULL,
        games_played    INT NOT NULL,

        FOREIGN KEY(player_id) REFERENCES player (id)
    );

    CREATE TABLE IF NOT EXISTS statistic_game (
        game_id         VARCHAR(10) PRIMARY KEY,
        matches_played  INT NOT NULL,
        total_points    INT NOT NULL,
        n_players       INT NOT NULL,

        FOREIGN KEY(game_id) REFERENCES game (id)
    );
END;$$;