package model;

import jakarta.persistence.*;
import java.sql.Timestamp;
import java.io.Serializable;

// TODO: FOREIGN KEY DINGS
@Entity
@Table(name="message")
@NamedQuery(name="Message.findAll", query="SELECT m FROM MESSAGE m")
public class Message implements Serializable {
    @Id
    @Column(name = "n_order")
    private int nOrder;

    @Id
    @Column(name = "chat_id")
    private int chatId;

    @Column(name = "player_id")
    private int playerId;

    @Column(name = "m_time")
    private Timestamp mTime;

    @Column(name = "m_text")
    private String mText;

    public Message() {}

    public int getnOrder() {
        return nOrder;
    }

    public void setnOrder(int nOrder) {
        this.nOrder = nOrder;
    }

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

    public Timestamp getmTime() {
        return mTime;
    }

    public void setmTime(Timestamp mTime) {
        this.mTime = mTime;
    }

    public String getmText() {
        return mText;
    }

    public void setmText(String mText) {
        this.mText = mText;
    }
}
