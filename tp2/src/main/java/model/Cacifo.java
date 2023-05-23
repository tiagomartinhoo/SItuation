package model;

import java.io.Serializable;
import jakarta.persistence.*;


/**
 * The persistent class for the cacifos database table.
 *
 */
@Entity
@Table(name="cacifos")
@NamedQuery(name="Cacifo.findAll", query="SELECT c FROM Cacifo c")
public class Cacifo implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    private long numCac;

    private String descrCac;

    @OneToOne(mappedBy = "cacifo")
    private Aluno aluno;

    public Cacifo() {
    }

    public long getNumCac() {
        return this.numCac;
    }

    public void setNumCac(long numCac) {
        this.numCac = numCac;
    }

    public String getDescrCac() {
        return this.descrCac;
    }

    public void setDescrCac(String descrCac) {
        this.descrCac = descrCac;
    }

    public Aluno getAluno() {
        return this.aluno;
    }

    public void setAluno(Aluno aluno) {
        this.aluno = aluno;
    }

}