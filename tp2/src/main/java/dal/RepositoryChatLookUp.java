package dal;

import jakarta.persistence.*;
import model.ChatLookup;
import model.ChatLookupId;
import model.Game;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.util.List;

public class RepositoryChatLookUp implements IRepository <ChatLookup, ChatLookupId> {



    public ChatLookup find(ChatLookupId Id) throws Exception {
        MapperChatLookup m = new MapperChatLookup();

        return m.read(Id);
    }



    public void add(ChatLookup a) throws Exception {
        MapperChatLookup m = new MapperChatLookup();


        m.create(a);
    }


    @Override
    public List<ChatLookup> getAll() throws Exception {
        return null;
    }
    public void save(ChatLookup a) throws Exception {
        MapperChatLookup m = new MapperChatLookup();


        m.update(a);

    }

    public void delete(ChatLookup a) throws Exception {
        MapperChatLookup m = new MapperChatLookup();


        m.delete(a);;
    }

    public int createChat(int player_id, String chat_name) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManager em = ds.getEntityManager();

            Connection cn = em.unwrap(Connection.class);

            CallableStatement f = cn.prepareCall("call iniciarconversa(?,?,?)");

            f.registerOutParameter(3, Types.INTEGER);
            f.setInt(1, player_id);
            f.setString(2, chat_name);
            f.execute();

            em.getTransaction().commit();
            em.close();

            return f.getInt(3);
        }
    }



    public boolean joinChat(int player_id, int chat_id) throws Exception {
        try (DataScope ds = new DataScope()) {
            EntityManagerFactory ef = ds.getEntityManagerFactory();
            EntityManager em = ef.createEntityManager();
            em.getTransaction().begin();

            Query q = em.createNativeQuery("call juntarConversa( ? , ? )");

            q.setParameter(1, player_id)
                    .setParameter(2, chat_id)
                    .executeUpdate();
            em.getTransaction().commit();
            em.close();

            return true;
        }
    }

}
