package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Game;
import model.PlayerScore;

import java.util.List;

// TODO: REMOVE IF NOT NEEDED
public class RepositoryPlayerScore {

    public List<PlayerScore> getAllFrom(Integer k) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            List<PlayerScore> l = em.createNamedQuery("PlayerScore.findByPlayer", PlayerScore.class)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

//    public int getTotalScoreOf(Integer k) throws Exception {
//
//    }
}
