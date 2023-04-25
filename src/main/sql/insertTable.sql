DO
$$
begin
    insert into region(r_name)
        VALUES('Sintra'),
        ('Carcavelos'),
        ('Cascais'),
        ('Vinhais')
    ;

    insert into player(email,username,activity_state,region_name)
        VALUES('tiago@gmail.com','tiago','Active','Sintra'),
        ('gui@gmail.com','gui','Active','Vinhais'),
        ('rafa@gmail.com','rafael','Active','Cascais')
    ;

    insert into friendship(player1_id, player2_id)
        VALUES(1,2),
        (2,3),
        (1,3)
    ;

    insert into chat(c_name)
        VALUES ('tomas'),
        ('yeye')
    ;

    insert into message(n_order, chat_id, player_id, m_time, m_text)
        VALUES(1,1,1,'2023-02-5 04:05:06','hello'),
        (2,1,2,'2023-02-5 04:06:10','hey')
    ;

    insert into game(id, g_name, url)
        VALUES('abcdefghi8','Destroyer','https://www.destroyer.com'),
        ('bbbbbbbbb1','SuperSmashYe','https://www.SuperSmashYe.com')
    ;

    insert into purchase(player_id, game_id, p_date, price)
        VALUES(1,'abcdefghi8','2023-02-25 04:06:10',69),
        (2,'bbbbbbbbb1','2023-01-22 04:06:10',10),
        (3,'bbbbbbbbb1','2023-01-23 04:06:10',10)
    ;

    insert into match(number, game_id, dt_start, dt_end)
        VALUES(1,'abcdefghi8','2023-03-01 04:06:10','2023-03-02 04:06:10'),
        (2,'bbbbbbbbb1','2023-01-25 04:06:10','2023-01-26 04:06:10')
    ;

    insert into match_normal(match_number, difficulty_level)
        VALUES(1,3)
    ;

    insert into match_multiplayer(match_number, state)
        VALUES(2,'Finished')
    ;

    insert into player_score(player_id, match_number, game_id, score)
        VALUES(1,1,'abcdefghi8',3),
        (2,2,'bbbbbbbbb1',0),
        (3,2,'bbbbbbbbb1',1)
    ;

    insert into player_badge(player_id, b_name, game_id)
        VALUES('Win-Streak','abcdefghi8', 1)
    ;
    insert into badge(b_name, game_id, player_id, points_limit, url)
        VALUES('Win-Streak','abcdefghi8',5,'https://www.winStreak.com')
    ;

    insert into statistic_player(player_id, matches_played, total_points, games_played)
        VALUES(1,1,3,1),
        (2,1,0,1),
        (3,1,1,1)
    ;

    insert into statistic_game(game_id, matches_played, total_points, n_players)
        VALUES('abcdefghi8',1,3,1),
        ('bbbbbbbbb1',1,1,2)
    ;

end;$$;
