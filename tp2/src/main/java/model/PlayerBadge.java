package model;

import jakarta.persistence.*;
import jakarta.persistence.StoredProcedureParameter;

@Entity
@Table(name = "player_badge")
@NamedQueries({
        @NamedQuery(name = "PlayerBadge.findAll", query="SELECT p FROM PlayerBadge p"),
        @NamedQuery(name = "PlayerBadge.findByPlayer", query = "SELECT p FROM PlayerBadge p where p.id.playerId = ?1")
})
public class PlayerBadge {
    @EmbeddedId
    private PlayerBadgeId id;

    @MapsId("playerId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    @MapsId("badgeId")
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