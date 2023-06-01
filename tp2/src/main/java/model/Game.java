package model;

import jakarta.persistence.*;

@Entity
@Table(name = "game", indexes = {
        @Index(name = "game_g_name_key", columnList = "g_name", unique = true)
})
public class Game {
    @Id
    @Column(name = "id", nullable = false, length = 10)
    private String id;

    @Column(name = "g_name", nullable = false, length = 20)
    private String gName;

    @Column(name = "url", length = 100)
    private String url;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getGName() {
        return gName;
    }

    public void setGName(String gName) {
        this.gName = gName;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

}