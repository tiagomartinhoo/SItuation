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
import dal.RepositoryPlayer;
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
	public void test1() {

        try (DataScope ds = new DataScope()) { // Automatically calls DataScope.close() so no need to manage that

            RepositoryGame gameRepo = new RepositoryGame();

            List<Game> games = gameRepo.getAll();

            for (Game game: games) {
                System.out.println(game.getId() + ": " + game.getGName() + " " + game.getUrl());
            }
        } catch(Exception e) {
        	System.out.println(e.getMessage());
        }

    }

    public void banUser(int id) {
        //TODO
    }

    public void deactivateUser(int id) {
        //TODO
    }

    public int totalUserPoints(int id) {
        try (DataScope ds = new DataScope()) {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.totalPlayerPoints(id);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return -1;
        }
    }
}
