package model;

import jakarta.persistence.*;

@Entity
@Table(name = "statistic_game")
public class StatisticGame {
    @Id
    @Column(name = "game_id", nullable = false, length = 10)
    private String id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    @Column(name = "matches_played", nullable = false)
    private Integer matchesPlayed;

    @Column(name = "total_points", nullable = false)
    private Integer totalPoints;

    @Column(name = "n_players", nullable = false)
    private Integer nPlayers;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Integer getMatchesPlayed() {
        return matchesPlayed;
    }

    public void setMatchesPlayed(Integer matchesPlayed) {
        this.matchesPlayed = matchesPlayed;
    }

    public Integer getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }

    public Integer getNPlayers() {
        return nPlayers;
    }

    public void setNPlayers(Integer nPlayers) {
        this.nPlayers = nPlayers;
    }

}