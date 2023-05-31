package model;

import jakarta.persistence.Column;
import jakarta.persistence.Id;

public class PlayerBadge {

    @Id
    @Column(name = "player_id")
    private int playerId;

    @Id
    @Column(name = "b_name")
    private String bName;

    @Id
    @Column(name = "game_id")
    private String gameId;

    public PlayerBadge() {}

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }

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
}
