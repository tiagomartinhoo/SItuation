package model;


import jakarta.persistence.*;

import java.io.Serializable;

@Entity
@Table(name="region")
@NamedQuery(name="Region.findAll", query="SELECT r FROM REGION r")
public class Region implements Serializable {

    public Region(){}

    @Id
    @Column(name = "r_name")
    private String rName;

    public String getrName() {
        return rName;
    }

    public void setrName(String rName) {
        this.rName = rName;
    }
}
