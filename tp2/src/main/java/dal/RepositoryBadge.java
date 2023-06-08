package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Badge;
import model.Game;

import java.util.List;

public class RepositoryBadge implements IRepository <Badge, String> {
    @Override
    public List<Badge> getAll() throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            //em.flush();  // � necess�rio para a pr�xima query encontrar os registos caso eles tenham sido criados neste transa��o
            // com queries o flush � feito automaticamente.
            List<Badge> l = em.createNamedQuery("Badge.findAll", Badge.class)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

    @Override
    public Badge find(String k) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            //em.flush();  // � necess�rio para a pr�xima query encontrar os registos caso eles tenham sido criados neste transa��o
            // com queries o flush � feito automaticamente.
            Badge b = em.createNamedQuery("Badge.findByName", Badge.class)
                    .setParameter(1, k)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getSingleResult();
            ds.validateWork();
            return b;
        }
    }

    @Override
    public void add(Badge entity) throws Exception {
        MapperBadge m = new MapperBadge();

        m.create(entity);
    }

    @Override
    public void delete(Badge entity) throws Exception {
        MapperBadge m = new MapperBadge();

        m.update(entity);

    }

    @Override
    public void save(Badge e) throws Exception {
        MapperBadge m = new MapperBadge();

        m.delete(e);

    }
}
