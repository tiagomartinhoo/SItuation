package model;

import java.io.Serializable;
import jakarta.persistence.*;


/**
 * The persistent class for the alunos database table.
 */
@Entity
@Table(name="alunos")
@NamedQuery(name="Aluno.findAll", query="SELECT a FROM Aluno a")
public class Aluno implements Serializable {
	private static final long serialVersionUID = 1L;

	@Id
	private long numal;

	private String nomeal;

	@OneToOne(cascade=CascadeType.PERSIST)
	@JoinColumn(name="aluga_cac", unique = true)
	private Cacifo cacifo;

	public Aluno() {
	}

	public long getNumal() {
		return this.numal;
	}

	public void setNumal(long numal) {
		this.numal = numal;
	}

	public String getNomeal() {
		return this.nomeal;
	}

	public void setNomeal(String nomeal) {
		this.nomeal = nomeal;
	}

	public Cacifo getCacifo() { return this.cacifo; }

	public void setCacifo(Cacifo cacifo) { this.cacifo = cacifo; }

}