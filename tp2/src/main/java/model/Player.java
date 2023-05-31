package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="player")
@NamedQuery(name="Player.findAll", query="SELECT p FROM PLAYER p")
public class Player implements Serializable {
    private static final long serialVersionUID = 1L;

    public Player(){}

    @Id
    private long id;

    private String email;

    private String username;

    @Column(name = "activity_state")
    private String activityState;

    @OneToOne(mappedBy = "region_name")
    private Region region;

    public long getId() { return id; }

    public void setId(long id) { this.id = id; }

    public String getEmail() { return email; }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getActivityState() {
        return activityState;
    }

    public void setActivityState(String activityState) {
        this.activityState = activityState;
    }

    public Region getRegion() {
        return region;
    }

    public void setRegion(Region region) {
        this.region = region;
    }
}