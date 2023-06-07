/*
 Walter Vieira (2022-04-22)
 Sistemas de Informação - projeto JPAAulas_ex1
 Código desenvolvido para iulustração dos conceitos sobre acesso a dados, concretizados com base na especificação JPA.
 Todos os exemplos foram desenvolvidos com EclipseLinlk (3.1.0-M1), usando o ambientre Eclipse IDE versão 2022-03 (4.23.0).
 
Não existe a pretensão de que o código estaja completo.

Embora tenha sido colocado um esforço significativo na correção do código, não há garantias de que ele não contenha erros que possam 
acarretar problemas vários, em particular, no que respeita à consistência dos dados.  
 
*/

package businessLogic;

import java.util.List;

import dal.DataScope;
import dal.RepositoryGame;
import jakarta.persistence.*;

import entityManagerFactory.EnvironmentalEntityManagerFactory;
import model.Game;
import org.glassfish.jaxb.core.v2.TODO;

/**
 * Hello world!
 *
 */
public class BLService 
{
    //@SuppressWarnings("unchecked")
	public void test1() throws Exception {

        try (DataScope ds = new DataScope()) { // Automatically calls DataScope.close() so no need to manage that
            EntityManager em = ds.getEntityManager();

            RepositoryGame gameRepo = new RepositoryGame();

            List<Game> games = gameRepo.getAll();

            for (Game game: games) {
                System.out.println(game.getId() + ": " + game.getGName() + " " + game.getUrl());
            }
        }
        catch(Exception e)
        {
        	System.out.println(e.getMessage());
        	throw e;
        }

    }

    @SuppressWarnings("preview")
    public void test2() throws Exception
    { //
        EntityManager em = EnvironmentalEntityManagerFactory.createEntityManager("JPAEx");
//        EntityManagerFactory emf = Persistence.createEntityManagerFactory("JPAEx");
//        System.out.println("PROPERTIES");
//        System.out.println(emf.getProperties().size());
//        System.out.println(emf.getProperties().toString());
//
//        EntityManager em = emf.createEntityManager();
        try
        {
//            System.out.println("Ler um cacifo");
//            EntityTransaction trans = em.getTransaction();
//
//            trans.begin();
//
//            String sql = "SELECT c FROM Cacifo c WHERE c.numCac = 3";
//            Query query = em.createQuery(sql);
//            List<Cacifo> la = query.getResultList();
//
//            for (Cacifo c : la)
//            {
//                System.out.printf("%d \n", c.getNumCac());
//                System.out.printf("%s \n", c.getDescrCac());
//                System.out.printf("%s \n", c.getAluno().getNomeal());
//
//                c.setDescrCac("Test");
//                System.out.printf("%s \n", c.getDescrCac());
//            }
//
//            trans.commit();
        }
        catch(Exception e)
        {
            System.out.println(e.getMessage());
            throw e;
        }
        finally
        {
            em.close();
//            emf.close();
        }
    }

    public void banUser(int id) {
        //TODO
    }

    public void deactivateUser(int id) {
        //TODO
    }
}
