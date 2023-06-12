package dal;

import jakarta.persistence.EntityManager;
import jakarta.persistence.LockModeType;
import model.ChatLookup;
import model.ChatLookupId;

public class MapperChatLookup implements IMapper<ChatLookup, ChatLookupId> {
    @Override
    public ChatLookupId create(ChatLookup e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            em.persist(e);
            ds.validateWork();
            return e.getId();
        }
    }

    @Override
    public ChatLookup read(ChatLookupId k) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush();  // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação
            ChatLookup cl = em.find(ChatLookup.class, k, LockModeType.PESSIMISTIC_WRITE);
            ds.validateWork();
            return cl;
        }
    }

    @Override
    public void update(ChatLookup e) throws Exception {
        // Does nothing because it doesn't make sense to update an entry in a lookup table
        // You either add or delete (perhaps both)
    }

    @Override
    public void delete(ChatLookup e) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();
            em.flush(); // É necessário para o próximo find encontrar o registo caso ele tenha sido criado neste transação

            ChatLookup cl = em.find(ChatLookup.class, e.getId(), LockModeType.PESSIMISTIC_WRITE);
            if (cl == null)
                throw new java.lang.IllegalAccessException("Entidade inexistente");
            em.remove(cl);

            ds.validateWork();

        }
    }
}
