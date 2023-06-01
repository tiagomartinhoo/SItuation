package model;

import jakarta.persistence.*;

@Entity
@Table(name = "player_badge")
public class PlayerBadge {
    @EmbeddedId
    private PlayerBadgeId id;

    @MapsId("playerId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    @MapsId
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumns({
            @JoinColumn(name = "b_name", referencedColumnName = "b_name", nullable = false),
            @JoinColumn(name = "game_id", referencedColumnName = "game_id", nullable = false)
    })
    private Badge badge;

    public PlayerBadgeId getId() {
        return id;
    }

    public void setId(PlayerBadgeId id) {
        this.id = id;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Badge getBadge() {
        return badge;
    }

    public void setBadge(Badge badge) {
        this.badge = badge;
    }

}