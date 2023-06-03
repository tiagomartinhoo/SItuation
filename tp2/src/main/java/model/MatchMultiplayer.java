package model;

import jakarta.persistence.*;

@Entity
@Table(name = "match_multiplayer")
@PrimaryKeyJoinColumns ({
        @PrimaryKeyJoinColumn(name = "match_number", referencedColumnName = "number"),
        @PrimaryKeyJoinColumn(name = "game_id", referencedColumnName = "game_id")
})
public class MatchMultiplayer extends Match {


//    @MapsId
    @OneToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumns({
            @JoinColumn(name = "match_number", referencedColumnName = "number", nullable = false),
            @JoinColumn(name = "game_id", referencedColumnName = "game_id", nullable = false)
    })
    private Match match;

    @Column(name = "state", length = 20)
    private String state;

    public Match getMatch() {
        return match;
    }

    public void setMatch(Match match) {
        this.match = match;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }

}