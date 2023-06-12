package dal;

import jakarta.persistence.*;
import model.JogadorTotalInfo;
import model.Player;
import java.util.List;

public class RepositoryPlayer implements IRepository <Player, Integer> {


    public boolean createPlayer(String email, String username, String activity_state, String region) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManagerFactory ef = ds.getEntityManagerFactory();
            EntityManager em = ef.createEntityManager();
            em.getTransaction().begin();

            Query q = em.createNativeQuery("call criarJogador( ? , ? , ?, ? )");

            q.setParameter(1, email)
                    .setParameter(2, username)
                    .setParameter(3, activity_state)
                    .setParameter(4, region)
                    .executeUpdate();
            em.getTransaction().commit();
            em.close();

            return true;
        }
    }

    public boolean banUser(int player_id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManagerFactory ef = ds.getEntityManagerFactory();
            EntityManager em = ef.createEntityManager();
            em.getTransaction().begin();

            Query q = em.createNativeQuery("call banirJogador( ? )");

            q.setParameter(1, player_id)
                    .executeUpdate();
            em.getTransaction().commit();
            em.close();

            return true;
        }
    }

    public boolean deactivateUser(int player_id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManagerFactory ef = ds.getEntityManagerFactory();
            EntityManager em = ef.createEntityManager();
            em.getTransaction().begin();

            Query q = em.createNativeQuery("call desativarJogador( ? )");

            q.setParameter(1, player_id)
                    .executeUpdate();
            em.getTransaction().commit();
            em.close();

            return true;
        }
    }
    public int totalPlayerPoints(Integer id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            StoredProcedureQuery q = em.createStoredProcedureQuery("totalPontosJogador", Integer.class)
                    .registerStoredProcedureParameter(1, Integer.class, ParameterMode.OUT)
                    .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN);

            q.setParameter(2, id).execute();
            Integer points = (Integer) q.getOutputParameterValue(1);

            if (points == null) points = 0;

            ds.validateWork();
            return points;
        }
    }

    public long totalPlayerPointsInGame(Integer pId, String gId) throws Exception {

        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            Query q = em.createQuery("SELECT SUM(p.score) FROM PlayerScore p" +
                    " WHERE p.id.playerId = ?1 AND p.id.matchId.gameId = ?2", Integer.class);


            q.setParameter(1, pId).setParameter(2, gId);

            Long points = (Long) q.getSingleResult();

            ds.validateWork();
            return points;
        }
    }

    public int totalPlayerGames(Integer id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            StoredProcedureQuery q = em.createStoredProcedureQuery("totalJogosJogador", Integer.class)
                    .registerStoredProcedureParameter(1, Integer.class, ParameterMode.OUT)
                    .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN);

            q.setParameter(2, id).execute();
            Integer games = (Integer) q.getOutputParameterValue(1);

            ds.validateWork();
            return games;
        }
    }

    public  List<JogadorTotalInfo> getAllTotalInfo() throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            List<JogadorTotalInfo> l = em.createNamedQuery("JogadorTotalInfo.findAll", JogadorTotalInfo.class)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

    public Player find(Integer Id) throws Exception {
        MapperPlayer m = new MapperPlayer();

        return m.read(Id);
    }

    public  List<Player> getAll() throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            List<Player> l = em.createNamedQuery("Player.findAll", Player.class)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

    public void add(Player a) throws Exception {
        MapperPlayer m = new MapperPlayer();

        m.create(a);
    }

    public void save(Player a) throws Exception {
        MapperPlayer m = new MapperPlayer();
        m.update(a);
    }

    public void delete(Player a) throws Exception {
        MapperPlayer m = new MapperPlayer();

        m.delete(a);;

    }

    public boolean associateBadge(int pId, String gId, String badge) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManagerFactory ef = ds.getEntityManagerFactory();
            EntityManager em = ef.createEntityManager();
            em.getTransaction().begin();

            Query q = em.createNativeQuery("call associarCrachá( ? , ? , ? )");

            q.setParameter(1, pId)
                    .setParameter(2, gId)
                    .setParameter(3, badge)
                    .executeUpdate();
            em.getTransaction().commit();
            em.close();

            return true;
        }
    }

    public void sendMessage(int pId, int cId, String msg) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManagerFactory ef = ds.getEntityManagerFactory();
            EntityManager em = ef.createEntityManager();
            em.getTransaction().begin();

            Query q = em.createNativeQuery("call enviarMensagem( ? , ? , ? )");

            q.setParameter(1, pId)
                    .setParameter(2, cId)
                    .setParameter(3, msg)
                    .executeUpdate();
            em.getTransaction().commit();
            em.close();
        }
    }
}
