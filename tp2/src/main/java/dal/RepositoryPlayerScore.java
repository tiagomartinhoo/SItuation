package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import jakarta.persistence.ParameterMode;
import jakarta.persistence.StoredProcedureQuery;
import model.PlayerScore;

import java.util.List;

public class RepositoryPlayerScore {


    public List<Object[]> totalPointsForGamePerPlayer(String g_id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            StoredProcedureQuery q = em.createStoredProcedureQuery("pontosJogoPorJogador")
                    .registerStoredProcedureParameter(2, String.class, ParameterMode.IN);

            q.setParameter(2, g_id).execute();

            List<Object[]> result = q.getResultList();

            ds.validateWork();
            return result;
        }
    }

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
