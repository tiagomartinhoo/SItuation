package model;

import jakarta.persistence.*;

import java.io.Serializable;

// TODO: FOREIGN KEY DINGS
@Entity
@Table(name="chat")
@NamedQuery(name="Chat.findAll", query="SELECT c FROM CHAT c")
public class Chat implements Serializable {

    @Id
    private int id;

    @Column(name="c_name")
    private String cName;

    public Chat(){}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getcName() {
        return cName;
    }

    public void setcName(String cName) {
        this.cName = cName;
    }
}
