package model;

import jakarta.persistence.*;

/**
 * Mapping for DB view
 */
@Entity
@Table(name = "jogadortotalinfo")
@NamedQuery(name = "JogadorTotalInfo.findAll", query="SELECT p FROM JogadorTotalInfo p")
public class JogadorTotalInfo {
    @Id
    @Column(name = "id")
    private Integer id;

    @Column(name = "activity_state", length = 100)
    private String activityState;

    @Column(name = "email", length = 50)
    private String email;

    @Column(name = "username", length = 20)
    private String username;

    @Column(name = "total_games")
    private Long totalGames;

    @Column(name = "total_matches")
    private Long totalMatches;

    @Column(name = "total_score")
    private Long totalScore;

    public Integer getId() {
        return id;
    }

    public String getActivityState() {
        return activityState;
    }

    public String getEmail() {
        return email;
    }

    public String getUsername() {
        return username;
    }

    public Long getTotalGames() {
        return totalGames;
    }

    public Long getTotalMatches() {
        return totalMatches;
    }

    public Long getTotalScore() {
        return totalScore;
    }

}