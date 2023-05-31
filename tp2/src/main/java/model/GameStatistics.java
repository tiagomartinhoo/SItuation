package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="statistic_game")
@NamedQuery(name="GameStatistics.findAll", query="SELECT r FROM statistic_game r")
public class GameStatistics implements Serializable {

    @Id
    @Column(name = "game_id")
    private String gameId;

    @Column(name = "matches_played")
    private int matchesPlayed;

    @Column(name = "total_points")
    private int totalPoints;

    @Column(name = "n_players")
    private int nPlayers;

    public GameStatistics(){}

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public int getMatchesPlayed() {
        return matchesPlayed;
    }

    public void setMatchesPlayed(int matchesPlayed) {
        this.matchesPlayed = matchesPlayed;
    }

    public int getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(int totalPoints) {
        this.totalPoints = totalPoints;
    }

    public int getnPlayers() {
        return nPlayers;
    }

    public void setnPlayers(int nPlayers) {
        this.nPlayers = nPlayers;
    }
}
