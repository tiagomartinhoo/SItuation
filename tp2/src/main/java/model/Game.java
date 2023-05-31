package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="game")
@NamedQuery(name="Game.findAll", query="SELECT g FROM GAME g")
public class Game implements Serializable {

    @Id
    private String id;

    @Column(name = "g_name")
    private String gName;

    private String url;

    public Game(){}

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getgName() {
        return gName;
    }

    public void setgName(String gName) {
        this.gName = gName;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }
}
