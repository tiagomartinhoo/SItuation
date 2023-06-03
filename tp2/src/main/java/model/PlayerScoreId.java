package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinColumns;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class PlayerScoreId implements Serializable {
    private static final long serialVersionUID = -175753438629135463L;
    @Column(name = "player_id", nullable = false)
    private Integer playerId;

    @JoinColumns({
            @JoinColumn(name = "match_number", referencedColumnName = "number"),
            @JoinColumn(name = "game_id", referencedColumnName = "game_id")
    })
    private MatchId matchId;

    /*@Column(name = "match_number", nullable = false)
    private Integer matchNumber;

    @Column(name = "game_id", nullable = false, length = 10)
    private String gameId;*/

    public Integer getPlayerId() {
        return playerId;
    }

    public void setPlayerId(Integer playerId) {
        this.playerId = playerId;
    }

    /*public Integer getMatchNumber() {
        return matchNumber;
    }

    public void setMatchNumber(Integer matchNumber) {
        this.matchNumber = matchNumber;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }*/


}