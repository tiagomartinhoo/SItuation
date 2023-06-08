package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.Badge;
import model.BadgeId;
import model.Game;

import java.util.List;

public class RepositoryBadge implements IRepository <Badge, BadgeId> {
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
    public Badge find(BadgeId k) throws Exception {
        MapperBadge m = new MapperBadge();

        return m.read(k);
    }


    public Badge find(String bName, String gId) throws Exception {
        BadgeId id = new BadgeId();

        id.setGameId(gId);
        id.setBName(bName);
        System.out.println(gId + " " + bName);
        return find(id);
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
