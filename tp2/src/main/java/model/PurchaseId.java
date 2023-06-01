package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class PurchaseId implements Serializable {
    private static final long serialVersionUID = 4153784544453999039L;
    @Column(name = "player_id", nullable = false)
    private Integer playerId;

    @Column(name = "game_id", nullable = false, length = 10)
    private String gameId;

    public Integer getPlayerId() {
        return playerId;
    }

    public void setPlayerId(Integer playerId) {
        this.playerId = playerId;
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
        PurchaseId entity = (PurchaseId) o;
        return Objects.equals(this.gameId, entity.gameId) &&
                Objects.equals(this.playerId, entity.playerId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gameId, playerId);
    }

}