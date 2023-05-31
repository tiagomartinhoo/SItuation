package model;

import jakarta.persistence.*;

import java.io.Serializable;
import java.sql.Timestamp;

@Entity
@Table(name="purchase")
@NamedQuery(name="Purchase.findAll", query="SELECT p FROM PURCHASE p")
public class Purchase implements Serializable {
    @Id
    @Column(name = "player_id")
    private int playerId;

    @Id
    @Column(name = "game_id")
    private String gameId;

    @Column(name = "p_date")
    private Timestamp pDate;

    private int price;

    public Purchase(){}

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }
}
