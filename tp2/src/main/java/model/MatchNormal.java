package model;

import jakarta.persistence.*;

@Entity
@Table(name = "match_normal")
@PrimaryKeyJoinColumns ({
        @PrimaryKeyJoinColumn(name = "match_number", referencedColumnName = "number"),
        @PrimaryKeyJoinColumn(name = "game_id", referencedColumnName = "game_id")
})
public class MatchNormal extends Match {

//    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumns({
            @JoinColumn(name = "matchNumber", referencedColumnName = "number", nullable = false),
            @JoinColumn(name = "gameId", referencedColumnName = "gameId", nullable = false)
    })
    private Match match;

    @Column(name = "difficulty_level", nullable = false)
    private Integer difficultyLevel;

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