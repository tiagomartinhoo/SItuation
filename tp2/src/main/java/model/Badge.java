package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="badge")
@NamedQuery(name="Badge.findAll", query="SELECT r FROM BADGE r")
public class Badge implements Serializable {

    @Id
    @Column(name = "b_name")
    private String bName;

    @Id
    @Column(name="game_id")
    private String gameId;

    @Column(name = "points_limit")
    private int pointsLimit;

    private String url;

    public Badge(){}

    public String getbName() {
        return bName;
    }

    public void setbName(String bName) {
        this.bName = bName;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public int getPointsLimit() {
        return pointsLimit;
    }

    public void setPointsLimit(int pointsLimit) {
        this.pointsLimit = pointsLimit;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public String getUrl() {
        return url;
    }
}
