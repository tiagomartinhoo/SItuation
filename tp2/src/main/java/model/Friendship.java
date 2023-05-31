package model;

import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="friendship")
@NamedQuery(name="Friendship.findAll", query="SELECT f FROM FRIENDSHIP f")
public class Friendship implements Serializable {
    @Id
    @OneToOne(mappedBy="player1_id")
    private Player player1;

    @Id
    @OneToOne(mappedBy="player2_id")
    private Player player2;

    public Friendship(){}

    public Player getPlayer1() { return player1; }

    public void setPlayer1(Player player1) { this.player1 = player1; }

    public Player getPlayer2() { return player2; }

    public void setPlayer2(Player player2) { this.player2 = player2;}
}
