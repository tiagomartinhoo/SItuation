package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Player;
import model.PlayerBadge;
import model.PlayerBadgeId;

public class MapperPlayerBadge implements IMapper <PlayerBadge, PlayerBadgeId>  {
    @Override
    public PlayerBadgeId create(PlayerBadge e) throws Exception {
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
    public PlayerBadge read(PlayerBadgeId id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            PlayerBadge p = em.find(PlayerBadge.class, id, LockModeType.PESSIMISTIC_WRITE);
            ds.validateWork();
            return p;
        }
    }

    @Override
    public void update(PlayerBadge e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            PlayerBadge p1 = em.find(PlayerBadge.class, e.getId(), LockModeType.WRITE);
            if(p1 == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");

            // Set values of persistent data (except id)
            p1.setBadge(e.getBadge());

            ds.validateWork();
        }
    }

    @Override
    public void delete(PlayerBadge e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            PlayerBadge p1 = em.find(PlayerBadge.class, e.getId(), LockModeType.PESSIMISTIC_WRITE);
            if (p1 == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");
            em.remove(p1);

            ds.validateWork();
        }
    }
}
