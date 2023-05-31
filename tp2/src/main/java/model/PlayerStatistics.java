package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="statistic_player")
@NamedQuery(name="PlayerStatistics.findAll", query="SELECT r FROM statistic_player r")
public class PlayerStatistics implements Serializable {

    @Id
    @Column(name = "player_id")
    private int playerId;

    @Column(name = "matches_played")
    private int matchesPlayed;

    @Column(name = "total_points")
    private int totalPoints;

    @Column(name = "games_played")
    private int gamesPlayed;

    public PlayerStatistics(){}

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
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

    public int getGamesPlayed() {
        return gamesPlayed;
    }

    public void setGamesPlayed(int gamesPlayed) {
        this.gamesPlayed = gamesPlayed;
    }
}
