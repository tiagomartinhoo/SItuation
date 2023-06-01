package model;

import jakarta.persistence.*;

@Entity
@Table(name = "player_score")
public class PlayerScore {
    @EmbeddedId
    private PlayerScoreId id;

    @MapsId("playerId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    @MapsId
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumns({
            @JoinColumn(name = "match_number", referencedColumnName = "number", nullable = false),
            @JoinColumn(name = "game_id", referencedColumnName = "game_id", nullable = false)
    })
    private Match match;

    @Column(name = "score", nullable = false)
    private Integer score;

    public PlayerScoreId getId() {
        return id;
    }

    public void setId(PlayerScoreId id) {
        this.id = id;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Match getMatch() {
        return match;
    }

    public void setMatch(Match match) {
        this.match = match;
    }

    public Integer getScore() {
        return score;
    }

    public void setScore(Integer score) {
        this.score = score;
    }

}