package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.Version;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class BadgeId implements Serializable {

    @Column(name = "b_name", nullable = false, length = 20)
    private String bName;

    @Column(name = "game_id", nullable = false, length = 10)
    private String gameId;

    public String getBName() {
        return bName;
    }

    public void setBName(String bName) {
        this.bName = bName;
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
        BadgeId entity = (BadgeId) o;
        return Objects.equals(this.gameId, entity.gameId) &&
                Objects.equals(this.bName, entity.bName);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gameId, bName);
    }

}