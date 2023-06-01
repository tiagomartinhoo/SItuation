package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class ChatLookupId implements Serializable {
    private static final long serialVersionUID = 1832736778673004818L;
    @Column(name = "chat_id", nullable = false)
    private Integer chatId;

    @Column(name = "player_id", nullable = false)
    private Integer playerId;

    public Integer getChatId() {
        return chatId;
    }

    public void setChatId(Integer chatId) {
        this.chatId = chatId;
    }

    public Integer getPlayerId() {
        return playerId;
    }

    public void setPlayerId(Integer playerId) {
        this.playerId = playerId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ChatLookupId entity = (ChatLookupId) o;
        return Objects.equals(this.chatId, entity.chatId) &&
                Objects.equals(this.playerId, entity.playerId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(chatId, playerId);
    }

}