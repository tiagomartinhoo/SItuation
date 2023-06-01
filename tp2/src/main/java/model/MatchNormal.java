package model;

import jakarta.persistence.*;

@Entity
@Table(name = "match_normal")
public class MatchNormal {
    @EmbeddedId
    private MatchNormalId id;

    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumns({
            @JoinColumn(name = "match_number", referencedColumnName = "number", nullable = false),
            @JoinColumn(name = "game_id", referencedColumnName = "game_id", nullable = false)
    })
    private Match match;

    @Column(name = "difficulty_level", nullable = false)
    private Integer difficultyLevel;

    public MatchNormalId getId() {
        return id;
    }

    public void setId(MatchNormalId id) {
        this.id = id;
    }

    public Match getMatch() {
        return match;
    }

    public void setMatch(Match match) {
        this.match = match;
    }

    public Integer getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(Integer difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }

}