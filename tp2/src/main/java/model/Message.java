package model;

import jakarta.persistence.*;

import java.time.Instant;

@Entity
@Table(name = "message")
public class Message {
    @EmbeddedId
    private MessageId id;

    @MapsId("chatId")
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "chat_id", nullable = false)
    private Chat chat;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "player_id", nullable = false)
    private Player player;

    @Column(name = "m_time", nullable = false)
    private Instant mTime;

    @Column(name = "m_text", nullable = false, length = 200)
    private String mText;

    public MessageId getId() {
        return id;
    }

    public void setId(MessageId id) {
        this.id = id;
    }

    public Chat getChat() {
        return chat;
    }

    public void setChat(Chat chat) {
        this.chat = chat;
    }

    public Player getPlayer() {
        return player;
    }

    public void setPlayer(Player player) {
        this.player = player;
    }

    public Instant getMTime() {
        return mTime;
    }

    public void setMTime(Instant mTime) {
        this.mTime = mTime;
    }

    public String getMText() {
        return mText;
    }

    public void setMText(String mText) {
        this.mText = mText;
    }

}