package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.*;

import java.util.List;

public class RepositoryPlayerBadge implements IRepository<PlayerBadge, PlayerBadgeId> {


    @Override
    public List<PlayerBadge> getAll() throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            List<PlayerBadge> l = em.createNamedQuery("PlayerBadge.findAll", PlayerBadge.class)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

    @Override
    public PlayerBadge find(PlayerBadgeId k) throws Exception {
        MapperPlayerBadge m = new MapperPlayerBadge();

        return m.read(k);
    }

    public List<PlayerBadge> findByPlayer(Integer id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            List<PlayerBadge> l = em.createNamedQuery("PlayerBadge.findByPlayer", PlayerBadge.class)
                    .setParameter(1, id)
                    .setLockMode(LockModeType.PESSIMISTIC_READ)
                    .getResultList();
            ds.validateWork();
            return l;
        }
    }

    @Override
    public void add(PlayerBadge entity) throws Exception {
        MapperPlayerBadge m = new MapperPlayerBadge();

        m.create(entity);
    }

    public void add(int pId, String gId, String badge) throws Exception {

        RepositoryPlayer playerRepo = new RepositoryPlayer();

        Player p = playerRepo.find(pId);
        System.out.println(p);

        RepositoryGame gameRepo = new RepositoryGame();

        Game g = gameRepo.find(gId);
        System.out.println(g);

        RepositoryBadge badgeRepo = new RepositoryBadge();

        Badge b = badgeRepo.find(badge, gId);


        PlayerBadge pb = new PlayerBadge();
        PlayerBadgeId pbId = new PlayerBadgeId();
        pbId.setPlayerId(p.getId());
        pbId.setBadgeId(b.getId());
        pb.setPlayer(p);
        pb.setBadge(b);
        pb.setId(pbId);

        add(pb);
    }

    @Override
    public void delete(PlayerBadge entity) throws Exception {
        MapperPlayerBadge m = new MapperPlayerBadge();

        m.delete(entity);;
    }

    @Override
    public void save(PlayerBadge e) throws Exception {
        MapperPlayerBadge m = new MapperPlayerBadge();
        m.update(e);
    }
}

