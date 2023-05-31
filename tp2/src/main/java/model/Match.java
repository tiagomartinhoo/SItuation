package model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Table(name="Match")
@NamedQuery(name="Match.findAll", query="SELECT r FROM MATCH r")
public class Match implements Serializable {

    @Id
    private int number;

    @Id
    @OneToOne(mappedBy = "game_id")
    private Game game;

    @OneToOne(mappedBy = "region_name")
    private Region region;

    @Column(name = "dt_start")
    private Timestamp dtStart;

    @Column(name = "dt_end")
    private Timestamp dtEnd;

    public Match() {}

    public int getNumber() {
        return number;
    }

    public void setNumber(int number) {
        this.number = number;
    }

    public Game getGame() {
        return game;
    }

    public void setGame(Game game) {
        this.game = game;
    }

    public Timestamp getDtStart() {
        return dtStart;
    }

    public void setDtStart(Timestamp dtStart) {
        this.dtStart = dtStart;
    }

    public Timestamp getDtEnd() {
        return dtEnd;
    }

    public void setDtEnd(Timestamp dtEnd) {
        this.dtEnd = dtEnd;
    }
}
