package model;

import jakarta.persistence.*;

@Entity
@Table(name = "player", indexes = {
        @Index(name = "player_username_key", columnList = "username", unique = true),
        @Index(name = "player_email_key", columnList = "email", unique = true)
})
@NamedQuery(name = "Player.findAll", query="SELECT p FROM Player p")
public class Player {
    @Id
    @Column(name = "id", nullable = false)
    private Integer id;

    @Column(name = "email", nullable = false, length = 50)
    private String email;

    @Column(name = "username", nullable = false, length = 20)
    private String username;

    @Column(name = "activity_state", length = 10)
    private String activityState;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "region_name", nullable = false)
    private Region regionName;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

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

    public Region getRegionName() {
        return regionName;
    }

    public void setRegionName(Region regionName) {
        this.regionName = regionName;
    }

}