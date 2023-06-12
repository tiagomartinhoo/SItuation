package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Player;

public class MapperPlayer implements IMapper <Player, Integer>  {
    @Override
    public Integer create(Player e) throws Exception {
        try (DataScope ds = new DataScope()) {

            EntityManager em = ds.getEntityManager();
            //em.getTransaction().begin();
            em.persist(e);
            ds.validateWork();
            return e.getId();
//            if(a.getNumal() != 1221L)
//                ds.validateWork();
//            return a.getNumal();

        }
    }

    @Override
    public Player read(Integer id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // � necess�rio para o pr�ximo find encontrar o registo caso ele tenha sido criado neste transa��o
            Player p = em.find(Player.class, id, LockModeType.PESSIMISTIC_WRITE);
            ds.validateWork();
            return p;
        }
    }

    @Override
    public void update(Player e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            Player p1 = em.find(Player.class, e.getId(), LockModeType.PESSIMISTIC_WRITE);
            if(p1 == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");

            // Set values of persistent data (except id)
            p1.setEmail(e.getEmail());
            p1.setActivityState(e.getActivityState());
            p1.setUsername(e.getUsername());
            p1.setRegionName(e.getRegionName());

            ds.validateWork();

        }
    }

    @Override
    public void delete(Player e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            Player p1 = em.find(Player.class, e.getId(), LockModeType.PESSIMISTIC_WRITE);
            if (p1 == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");
            em.remove(p1);

            ds.validateWork();

        }
    }
}
