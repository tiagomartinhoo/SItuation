package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Game;

public class MapperGame implements IMapper <Game, String> {

    public String create(Game a) throws Exception {
        try (DataScope ds = new DataScope()) {

            EntityManager em = ds.getEntityManager();
            //em.getTransaction().begin();
            em.persist(a);
            ds.validateWork();
            return a.getId();
//            if(a.getNumal() != 1221L)
//                ds.validateWork();
//            return a.getNumal();

        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }

    public Game read(String id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // � necess�rio para o pr�ximo find encontrar o registo caso ele tenha sido criado neste transa��o
            Game g = em.find(Game.class, id, LockModeType.OPTIMISTIC);
            ds.validateWork();
            return g;
//            Aluno a =  em.find(Aluno.class, id,LockModeType.PESSIMISTIC_READ );
//            ds.validateWork();
//            return a;

        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
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

//            Aluno a1 = em.find(Aluno.class, a.getNumal(),LockModeType.PESSIMISTIC_WRITE );
//            if (a1 == null)
//                throw new java.lang.IllegalAccessException("Entidade inexistente");
//            a1.setNomeal(a.getNomeal());
//            a1.setHobbies(a.getHobbies());
            ds.validateWork();

        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }

    }

    public void delete(Game a) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
//            Aluno a1 = em.find(Aluno.class, a.getNumal(),LockModeType.PESSIMISTIC_WRITE );
//            if (a1 == null)
//                throw new java.lang.IllegalAccessException("Entidade inexistente");
//            em.remove(a1);
            ds.validateWork();

        } catch(Exception e) {
            System.out.println(e.getMessage());
            throw e;
        }
    }
}
