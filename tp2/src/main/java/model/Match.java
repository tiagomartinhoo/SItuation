package model;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "match")
@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(discriminatorType = DiscriminatorType.STRING,
        name = "discr")
public class Match {
    @EmbeddedId
    private MatchId id;

    @MapsId("gameId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "game_id", nullable = false)
    private Game game;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "region_name", nullable = false)
    private Region regionName;

    @Column(name = "dt_start", nullable = false)
    private Instant dtStart;

    @Column(name = "dt_end")
    private Instant dtEnd;

    private String discr;

    public String getDiscr() {
        return discr;
    }

    public MatchId getId() {
        return id;
    }

    public void setId(MatchId id) {
        this.id = id;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Region getRegionName() {
        return regionName;
    }

    public void setRegionName(Region regionName) {
        this.regionName = regionName;
    }

    public Instant getDtStart() {
        return dtStart;
    }

    public void setDtStart(Instant dtStart) {
        this.dtStart = dtStart;
    }

    public Instant getDtEnd() {
        return dtEnd;
    }

    public void setDtEnd(Instant dtEnd) {
        this.dtEnd = dtEnd;
    }

}