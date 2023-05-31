package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="player_score")
@NamedQuery(name="PlayerScore.findAll", query="SELECT r FROM PLAYER_SCORE r")
public class PlayerScore implements Serializable {

    @Id
    @Column(name = "player_id")
    private int playerId;

    @Id
    @Column(name = "match_number")
    private int matchNumber;

    @Id
    @Column(name = "game_id")
    private String gameId;

    private int score;

    public PlayerScore(){}

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

    public int getMatchNumber() {
        return matchNumber;
    }

    public void setMatchNumber(int matchNumber) {
        this.matchNumber = matchNumber;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public int getScore() {
        return score;
    }

    public void setScore(int score) {
        this.score = score;
    }
}
