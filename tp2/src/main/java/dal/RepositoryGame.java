package dal;

import java.util.List;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Game;


public class RepositoryGame implements IRepository <Game, String> {
	
	public Game find(String Id) throws Exception {
		MapperGame m = new MapperGame();

		return m.read(Id);
	}


	//Nota: optou-se por usar pessimistic locking  nas leituras
	//      Poderia fazer sentido ter uma versão das laituras com optimistic locking
	public  List<Game> getAll() throws Exception {
		try (DataScope ds = new DataScope()) {
			EntityManager em = ds.getEntityManager();
			List<Game> l = em.createNamedQuery("Game.findAll", Game.class)
					.setLockMode(LockModeType.PESSIMISTIC_READ)
					.getResultList();
			ds.validateWork();
			return l;
		}
	}
	
	
	public void add(Game a) throws Exception {
        MapperGame m = new MapperGame();

		m.create(a);
    }
    
    
	    
	public void save(Game a) throws Exception {
		MapperGame m = new MapperGame();

		m.update(a);

	}
	    
	public void delete(Game a) throws Exception {
		MapperGame m = new MapperGame();

		m.delete(a);;
	}

}
