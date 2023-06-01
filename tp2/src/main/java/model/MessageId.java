package model;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;

import java.io.Serializable;
import java.util.Objects;

@Embeddable
public class MessageId implements Serializable {
    private static final long serialVersionUID = -4510947160541572781L;
    @Column(name = "n_order", nullable = false)
    private Integer nOrder;

    @Column(name = "chat_id", nullable = false)
    private Integer chatId;

    public Integer getNOrder() {
        return nOrder;
    }

    public void setNOrder(Integer nOrder) {
        this.nOrder = nOrder;
    }

    public Integer getChatId() {
        return chatId;
    }

    public void setChatId(Integer chatId) {
        this.chatId = chatId;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        MessageId entity = (MessageId) o;
        return Objects.equals(this.nOrder, entity.nOrder) &&
                Objects.equals(this.chatId, entity.chatId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(nOrder, chatId);
    }

}