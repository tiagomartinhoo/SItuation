package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinColumns;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class PlayerBadgeId implements Serializable {
    private static final long serialVersionUID = -6591020232047863107L;

    @Column(name = "player_id", nullable = false)
    private Integer playerId;

    @JoinColumns({
            @JoinColumn(name = "b_name", referencedColumnName = "b_name"),
            @JoinColumn(name = "game_id", referencedColumnName = "game_id")
    })
    private BadgeId badgeId;

    /*@Column(name = "b_name", nullable = false, length = 20)
    private String bName;

    @Column(name = "game_id", nullable = false, length = 10)
    private String gameId;*/

    public Integer getPlayerId() {
        return playerId;
    }

    public void setPlayerId(Integer playerId) {
        this.playerId = playerId;
    }

    /*public String getBName() {
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
        PlayerBadgeId entity = (PlayerBadgeId) o;
        return Objects.equals(this.gameId, entity.gameId) &&
                Objects.equals(this.bName, entity.bName) &&
                Objects.equals(this.playerId, entity.playerId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gameId, bName, playerId);
    }*/

}