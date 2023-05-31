package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="match_multiplayer")
@NamedQuery(name="MultiplayerMatch.findAll", query="SELECT r FROM MATCH_MULTIPLAYER r")
public class MultiplayerMatch implements Serializable {
    //TODO: VERIFICAR QUE ISTO FUNCTIONA
    @Id
    @OneToOne(mappedBy = "match_number, game_id")
    private Match match;

    private String state;

}
