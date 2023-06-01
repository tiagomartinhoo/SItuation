package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MatchId implements Serializable {
    private static final long serialVersionUID = 3046712298854773311L;
    @Column(name = "number", nullable = false)
    private Integer number;

    @Column(name = "game_id", nullable = false, length = 10)
    private String gameId;

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
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
        MatchId entity = (MatchId) o;
        return Objects.equals(this.gameId, entity.gameId) &&
                Objects.equals(this.number, entity.number);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gameId, number);
    }

}