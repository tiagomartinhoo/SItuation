package model;

import jakarta.persistence.*;

@Entity
@Table(name = "badge")
@NamedQueries({
        @NamedQuery(name="Badge.findAll", query="SELECT b FROM Badge b"),
        @NamedQuery(name = "Badge.findByName", query="SELECT b FROM Badge b where b.id.bName = ?1")
})
public class Badge {
    @EmbeddedId
    private BadgeId id;

    @MapsId("gameId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    @Column(name = "points_limit")
    private Integer pointsLimit;

    @Column(name = "url", length = 100)
    private String url;

    public BadgeId getId() {
        return id;
    }

    public void setId(BadgeId id) {
        this.id = id;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Integer getPointsLimit() {
        return pointsLimit;
    }

    public void setPointsLimit(Integer pointsLimit) {
        this.pointsLimit = pointsLimit;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

}