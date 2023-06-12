package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Game;
import model.PlayerScore;
import model.PlayerScoreId;

public class MapperPlayerScore implements IMapper<PlayerScore, PlayerScoreId> {
    @Override
    public PlayerScoreId create(PlayerScore e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            em.persist(e);
            ds.validateWork();
            return e.getId();
        }
    }

    @Override
    public PlayerScore read(PlayerScoreId k) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            PlayerScore s = em.find(PlayerScore.class, k, LockModeType.PESSIMISTIC_READ);
            ds.validateWork();
            return s;
        }
    }

    @Override
    public void update(PlayerScore e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            PlayerScore s = em.find(PlayerScore.class, e.getId(), LockModeType.WRITE);
            if(s == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");

            s.setScore(e.getScore());
            s.setMatch(e.getMatch());

            ds.validateWork();
        }
    }

    @Override
    public void delete(PlayerScore e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            PlayerScore s = em.find(PlayerScore.class, e.getId(), LockModeType.PESSIMISTIC_WRITE);
            if (s == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");

            em.remove(s);

            ds.validateWork();
        }
    }
}
