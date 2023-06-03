/*
 Walter Vieira (2022-04-22)
 Sistemas de Informa��o - projeto JPAAulas_ex6
 C�digo desenvolvido para iulustra��o dos conceitos sobre acesso a dados, concretizados com base na especifica��o JPA.
 Todos os exemplos foram desenvolvidos com EclipseLinlk (3.1.0-M1), usando o ambientre Eclipse IDE vers�o 2022-03 (4.23.0).
 
N�o existe a pretens�o de que o c�digo estaja completo.

Embora tenha sido colocado um esfor�o significativo na corre��o do c�digo, n�o h� garantias de que ele n�o contenha erros que possam 
acarretar problemas v�rios, em particular, no que respeita � consist�ncia dos dados.  
 
*/

package dal;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Game;


public class RepositoryGame implements IRepository <Game, String> {
	
	public Game find(String Id) throws Exception {
		MapperGame m = new MapperGame();

		try {
			return m.read(Id);
		} catch(Exception e) {
			System.out.println(e.getMessage());
			throw e;
		}
	}


	//Nota: optou-se por usar pessimistic locking  nas leituras
	//      Poderia fazer sentido ter uma versão das laituras com optimistic locking
	public  List<Game> getAll() throws Exception {
		try (DataScope ds = new DataScope()) {
			EntityManager em = ds.getEntityManager();
			//em.flush();  // � necess�rio para a pr�xima query encontrar os registos caso eles tenham sido criados neste transa��o
			// com queries o flush � feito automaticamente.
			List<Game> l = em.createNamedQuery("Game.findAll",Game.class)
					.setLockMode(LockModeType.PESSIMISTIC_READ)
					.getResultList();
			ds.validateWork();
			return l;
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			throw e;
		}
	}
	
	
	public void add(Game a) throws Exception {
        MapperGame m = new MapperGame();
        
		try {
			m.create(a);

		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			throw e;
		}
    }
    
    
	    
	public void save(Game a) throws Exception {
		MapperGame m = new MapperGame();

		try {
			m.update(a);
		}
		catch(Exception e) {
			System.out.println(e.getMessage());
			throw e;
		}
	}
	    
	public void delete(Game a) throws Exception {
		MapperGame m = new MapperGame();

		try {
			m.delete(a);;
		} catch(Exception e) {
			System.out.println(e.getMessage());
			throw e;
		}
	}

}
