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
            List<Badge> l = em.createNamedQuery("Badge.findAll", Badge.class)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

    @Override
    public Badge find(BadgeId k) throws Exception {
        return find(k, false);
    }
    public Badge find(BadgeId k, boolean optimisticLocking) throws Exception {
        MapperBadge m = new MapperBadge();
        LockModeType lM = LockModeType.PESSIMISTIC_WRITE;
        if(optimisticLocking) lM = LockModeType.OPTIMISTIC;
        System.out.println("LOCKMODE : " + lM.name());
        return m.read(k, lM);
    }

    public Badge find(String bName, String gId, boolean optimisticLocking) throws Exception {
        BadgeId id = new BadgeId();

        id.setGameId(gId);
        id.setBName(bName);
        System.out.println(gId + " " + bName);
        return find(id, optimisticLocking);
    }

    public Badge find(String bName, String gId) throws Exception {
        return find(bName, gId, false);
    }

    @Override
    public void add(Badge entity) throws Exception {
        MapperBadge m = new MapperBadge();

        m.create(entity);
    }

    @Override
    public void delete(Badge entity) throws Exception {
        MapperBadge m = new MapperBadge();

        m.delete(entity);
    }

    @Override
    public void save(Badge e) throws Exception {
        save(e, false);
    }

    public void save(Badge e, boolean optimisticLocking) throws Exception {
        MapperBadge m = new MapperBadge();

        LockModeType lM = LockModeType.PESSIMISTIC_WRITE;
        if(optimisticLocking) lM = LockModeType.OPTIMISTIC;

        m.update(e, lM);
    }

}
