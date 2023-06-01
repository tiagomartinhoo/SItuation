package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class FriendshipId implements Serializable {
    private static final long serialVersionUID = -2369901841956297031L;
    @Column(name = "player1_id", nullable = false)
    private Integer player1Id;

    @Column(name = "player2_id", nullable = false)
    private Integer player2Id;

    public Integer getPlayer1Id() {
        return player1Id;
    }

    public void setPlayer1Id(Integer player1Id) {
        this.player1Id = player1Id;
    }

    public Integer getPlayer2Id() {
        return player2Id;
    }

    public void setPlayer2Id(Integer player2Id) {
        this.player2Id = player2Id;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FriendshipId entity = (FriendshipId) o;
        return Objects.equals(this.player1Id, entity.player1Id) &&
                Objects.equals(this.player2Id, entity.player2Id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(player1Id, player2Id);
    }

}