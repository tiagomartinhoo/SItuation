package model;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "purchase")
public class Purchase {
    @EmbeddedId
    private PurchaseId id;

    @MapsId("playerId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    @MapsId("gameId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    @Column(name = "p_date", nullable = false)
    private Instant pDate;

    @Column(name = "price", nullable = false)
    private Integer price;

    public PurchaseId getId() {
        return id;
    }

    public void setId(PurchaseId id) {
        this.id = id;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Instant getPDate() {
        return pDate;
    }

    public void setPDate(Instant pDate) {
        this.pDate = pDate;
    }

    public Integer getPrice() {
        return price;
    }

    public void setPrice(Integer price) {
        this.price = price;
    }

}