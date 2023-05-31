package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="match_normal")
@NamedQuery(name="NormalMatch.findAll", query="SELECT r FROM MATCH_NORMAL r")
public class NormalMatch implements Serializable {
    //TODO: VERIFICAR QUE ISTO FUNCTIONA
    @Id
    @OneToOne(mappedBy = "match_number, game_id")
    private Match match;


    @Column(name = "difficulty_level")
    private int difficultyLevel;

    public NormalMatch() {}

    public Match getMatch() {
        return match;
    }

    public void setMatch(Match match) {
        this.match = match;
    }

    public int getDifficultyLevel() {
        return difficultyLevel;
    }

    public void setDifficultyLevel(int difficultyLevel) {
        this.difficultyLevel = difficultyLevel;
    }
}
