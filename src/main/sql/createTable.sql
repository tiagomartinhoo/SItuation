CREATE TABLE IF NOT EXISTS REGION (
    r_name VARCHAR(20) PRIMARY KEY NOT NULL
);

CREATE TABLE IF NOT EXISTS PLAYER (
    id  SERIAL PRIMARY KEY NOT NULL,
    email VARCHAR(50) UNIQUE CHECK (email LIKE '%@%.%') NOT NULL,
    username VARCHAR(20) UNIQUE NOT NULL,
    activity_state VARCHAR(100) CHECK( activity_state IN ('Active', 'Inactive', 'Banned') ),
    region_name VARCHAR(20) NOT NULL,

    FOREIGN KEY(region_name) REFERENCES REGION (r_name)
); 

CREATE TABLE IF NOT EXISTS FRIENDSHIP (
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,

    PRIMARY KEY(player1_id,player2_id),
    FOREIGN KEY(player1_id) REFERENCES PLAYER (id),
    FOREIGN KEY(player2_id) REFERENCES PLAYER (id)
);

CREATE TABLE IF NOT EXISTS CHAT (
    id SERIAL PRIMARY KEY NOT NULL,
    c_name VARCHAR(20) NOT NULL
);

CREATE TABLE IF NOT EXISTS CHAT_LOOKUP (
    chat_id INT  NOT NULL,
    player_id INT NOT NULL,

    PRIMARY KEY(chat_id,player_id),
    FOREIGN KEY(chat_id) REFERENCES CHAT (id),
    FOREIGN KEY(player_id) REFERENCES PLAYER (id)
);

CREATE TABLE IF NOT EXISTS MESSAGE (
    n_order INT NOT NULL,
    chat_id INT NOT NULL,
    player_id INT NOT NULL,
    m_time TIMESTAMP NOT NULL,
    m_text VARCHAR(200) NOT NULL,

    PRIMARY KEY(n_order,chat_id),
    FOREIGN KEY(chat_id) REFERENCES CHAT (id),
    FOREIGN KEY(player_id) REFERENCES PLAYER (id)
);

CREATE TABLE IF NOT EXISTS GAME (
    id VARCHAR(10) PRIMARY KEY NOT NULL,
    g_name VARCHAR(20) UNIQUE NOT NULL,
    url VARCHAR(100) CHECK ( url LIKE 'https://%' )
);

CREATE TABLE IF NOT EXISTS PURCHASE (
    player_id INT NOT NULL,
    game_id VARCHAR(10) NOT NULL,
    p_date TIMESTAMP NOT NULL,
    price INT NOT NULL,

    PRIMARY KEY(player_id,game_id),
    FOREIGN KEY(player_id) REFERENCES PLAYER (id),
    FOREIGN KEY(game_id) REFERENCES GAME (id)
);

CREATE TABLE IF NOT EXISTS MATCH (
    number INT NOT NULL,
    game_id VARCHAR(10) NOT NULL,
    dt_start TIMESTAMP NOT NULL,
    dt_end TIMESTAMP NOT NULL CHECK ( dt_end > dt_start ),

    PRIMARY KEY(number,game_id),
    FOREIGN KEY(game_id) REFERENCES GAME (id)
);

CREATE TABLE IF NOT EXISTS MATCH_NORMAL (
    match_number INT PRIMARY KEY NOT NULL,
    difficulty_level INT NOT NULL CHECK ( difficulty_level >= 1 and difficulty_level <= 5 )
);

CREATE TABLE IF NOT EXISTS MATCH_MULTIPLAYER (
    match_number INT PRIMARY KEY NOT NULL,
    state VARCHAR(20) CHECK ( state IN ('To start', 'Waiting for players', 'Ongoing', 'Finished') )
);

CREATE TABLE IF NOT EXISTS PLAYER_SCORE (
    player_id INT NOT NULL,
    match_number INT NOT NULL,
    game_id VARCHAR(10) NOT NULL,--verificar se e mesmo necessario!!!!!
    score INT NOT NULL,

    PRIMARY KEY(player_id, match_number,game_id),
    FOREIGN KEY(player_id) REFERENCES PLAYER (id),
    FOREIGN KEY(match_number, game_id) REFERENCES MATCH (number, game_id)

);

CREATE TABLE IF NOT EXISTS BADGE (
    b_name VARCHAR(20) NOT NULL,
    game_id VARCHAR(10) NOT NULL, -- garante que o nome do crachá é distinto para cada jogo
    player_id INT NOT NULL,
    points_limit INT,
    url VARCHAR(100) CHECK ( url LIKE 'https://%' ),

    PRIMARY KEY(b_name,game_id),
    FOREIGN KEY(game_id) REFERENCES GAME (id),
    FOREIGN KEY(player_id) REFERENCES PLAYER (id)
);

CREATE TABLE IF NOT EXISTS STATISTIC_PLAYER (
    player_id INT PRIMARY KEY NOT NULL,
    matches_played INT NOT NULL,
    total_points INT NOT NULL,
    games_played INT NOT NULL,

    FOREIGN KEY(player_id) REFERENCES PLAYER (id)
);

CREATE TABLE IF NOT EXISTS STATISTIC_GAME (
    game_id VARCHAR(10) PRIMARY KEY NOT NULL,
    matches_played INT NOT NULL,
    total_points INT NOT NULL,
    n_players INT NOT NULL,

    FOREIGN KEY(game_id) REFERENCES GAME (id)
);
