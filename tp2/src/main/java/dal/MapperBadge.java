package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Badge;
import model.BadgeId;



public class MapperBadge  implements IMapper <Badge, BadgeId> {

    @Override
    public BadgeId create(Badge e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            em.persist(e);
            ds.validateWork();

            return e.getId();
        }
    }

    @Override
    public Badge read(BadgeId k) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // � necess�rio para o pr�ximo find encontrar o registo caso ele tenha sido criado neste transa��o
            Badge b = em.find(Badge.class, k, LockModeType.PESSIMISTIC_READ);
            ds.validateWork();
            return b;

        }
    }

    @Override
    public void update(Badge e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            Badge b = em.find(Badge.class, e.getId(), LockModeType.PESSIMISTIC_READ);
            if(b == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");

            b.setUrl(e.getUrl());
            b.setPointsLimit(e.getPointsLimit());

            ds.validateWork();

        }
    }

    @Override
    public void delete(Badge e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            Badge b = em.find(Badge.class, e.getId(), LockModeType.PESSIMISTIC_READ);
            if (b == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");
            em.remove(b);

            ds.validateWork();

        }
    }
}
