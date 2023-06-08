package dal;

import jakarta.persistence.*;
import model.Player;

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
        catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }

    public Player find(Integer Id) throws Exception {
        MapperPlayer m = new MapperPlayer();

        try {
            return m.read(Id);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }


    //Nota: optou-se por usar pessimistic locking  nas leituras
    //      Poderia fazer sentido ter uma versão das laituras com optimistic locking
    public  List<Player> getAll() throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            //em.flush();  // � necess�rio para a pr�xima query encontrar os registos caso eles tenham sido criados neste transa��o
            // com queries o flush � feito automaticamente.
            List<Player> l = em.createNamedQuery("Game.findAll",Player.class)
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


    public void add(Player a) throws Exception {
        MapperPlayer m = new MapperPlayer();

        try {
            m.create(a);

        }
        catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }



    public void save(Player a) throws Exception {
        MapperPlayer m = new MapperPlayer();

        try {
            m.update(a);
        }
        catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }

    public void delete(Player a) throws Exception {
        MapperPlayer m = new MapperPlayer();

        try {
            m.delete(a);;
        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }
}
