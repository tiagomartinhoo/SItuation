package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Game;

public class MapperGame implements IMapper <Game, String> {

    public String create(Game a) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            em.persist(a);
            ds.validateWork();
            return a.getId();
        }
    }

    public Game read(String id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            Game g = em.find(Game.class, id, LockModeType.PESSIMISTIC_READ);
            ds.validateWork();
            return g;
        }
    }

    public void update(Game g) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            Game g1 = em.find(Game.class, g.getId(), LockModeType.WRITE);
            if(g1 == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");

            g1.setGName(g.getGName());
            g1.setUrl(g.getUrl());

            ds.validateWork();
        }

    }

    public void delete(Game g) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            Game g1 = em.find(Game.class, g.getId(), LockModeType.PESSIMISTIC_WRITE);
            if (g1 == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");
            em.remove(g1);

            ds.validateWork();

        }
    }
}
