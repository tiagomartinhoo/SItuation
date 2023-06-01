package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MatchMultiplayerId implements Serializable {
    private static final long serialVersionUID = -2909962312563786413L;
    @Column(name = "match_number", nullable = false)
    private Integer matchNumber;

    @Column(name = "game_id", nullable = false, length = 10)
    private String gameId;

    public Integer getMatchNumber() {
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
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MatchMultiplayerId entity = (MatchMultiplayerId) o;
        return Objects.equals(this.gameId, entity.gameId) &&
                Objects.equals(this.matchNumber, entity.matchNumber);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gameId, matchNumber);
    }

}