package model;

import jakarta.persistence.*;

import java.io.Serializable;

// TODO: FOREIGN KEY DINGS
@Entity
@Table(name="chat_lookup")
@NamedQuery(name="ChatLookup.findAll", query="SELECT cl FROM CHAT_LOOKUP cl")
public class ChatLookup implements Serializable {

    @Id
    @Column(name="chat_id")
    private int chatId;

    @Id
    @Column(name = "player_id")
    private int playerId;

    public ChatLookup(){}

    public int getChatId() {
        return chatId;
    }

    public void setChatId(int chatId) {
        this.chatId = chatId;
    }

    public int getPlayerId() {
        return playerId;
    }

    public void setPlayerId(int playerId) {
        this.playerId = playerId;
    }
}
