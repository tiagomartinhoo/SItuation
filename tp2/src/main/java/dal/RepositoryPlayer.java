package dal;

import jakarta.persistence.*;
import model.Player;
import org.eclipse.persistence.queries.StoredFunctionCall;
import org.postgresql.core.NativeQuery;

import java.util.List;

public class RepositoryPlayer implements IRepository <Player, Integer> {


    public int totalPlayerPoints(Integer id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            //em.flush();  // � necess�rio para a pr�xima query encontrar os registos caso eles tenham sido criados neste transa��o
            // com queries o flush � feito automaticamente.
            StoredProcedureQuery q = em.createStoredProcedureQuery("totalPontosJogador", Integer.class)
                    .registerStoredProcedureParameter(1, Integer.class, ParameterMode.OUT)
                    .registerStoredProcedureParameter(2, Integer.class, ParameterMode.IN);

            q.setParameter(2, id).execute();
            Integer points = (Integer) q.getOutputParameterValue(1);
//            int points = (Integer) em.createNativeQuery("SELECT * FROM totalPontosJogador(" + id +")", Player.class)
//                    .getSingleResult();

            ds.validateWork();
            return points;
        }
    }

    public Player find(Integer Id) throws Exception {
        MapperPlayer m = new MapperPlayer();

        return m.read(Id);
    }


    //Nota: optou-se por usar pessimistic locking  nas leituras
    //      Poderia fazer sentido ter uma versão das laituras com optimistic locking
    public  List<Player> getAll() throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            //em.flush();  // � necess�rio para a pr�xima query encontrar os registos caso eles tenham sido criados neste transa��o
            // com queries o flush � feito automaticamente.
            List<Player> l = em.createNamedQuery("Game.findAll", Player.class)
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
//            Query q1 = em.createNativeQuery("call associarCrachá(?1 , ?2 , ?3)");

//             StoredProcedureQuery q = em.createStoredProcedureQuery("associarCrachá")
//                    .registerStoredProcedureParameter(1, Integer.class, ParameterMode.IN)
//                    .registerStoredProcedureParameter(2, String.class, ParameterMode.IN)
//                    .registerStoredProcedureParameter(3, String.class, ParameterMode.IN);
            Query q = em.createNativeQuery("call associarCrachá( ? , ? , ? )");

            q.setParameter(1, pId)
                    .setParameter(2, gId)
                    .setParameter(3, badge)
                    .executeUpdate();
            em.getTransaction().commit();
//                    ;
//            q.getSingleResult();
//            em.flush();
            ds.validateWork();
            return true;
        }
    }
}
