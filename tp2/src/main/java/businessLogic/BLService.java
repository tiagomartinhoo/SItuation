/*
 Walter Vieira (2022-04-22)
 Sistemas de Informa��o - projeto JPAAulas_ex1
 C�digo desenvolvido para iulustra��o dos conceitos sobre acesso a dados, concretizados com base na especifica��o JPA.
 Todos os exemplos foram desenvolvidos com EclipseLinlk (3.1.0-M1), usando o ambientre Eclipse IDE vers�o 2022-03 (4.23.0).
 
N�o existe a pretens�o de que o c�digo estaja completo.

Embora tenha sido colocado um esfor�o significativo na corre��o do c�digo, n�o h� garantias de que ele n�o contenha erros que possam 
acarretar problemas v�rios, em particular, no que respeita � consist�ncia dos dados.  
 
*/

package businessLogic;

import java.util.List;

import dal.*;
import jakarta.persistence.*;

import entityManagerFactory.EnvironmentalEntityManagerFactory;
import model.*;
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

    public boolean associateBadgeWithProc(int pId, String gId, String badge) {
        try (DataScope ds = new DataScope()) {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.associateBadge(pId, gId, badge);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public boolean associateBadgeWithoutProc(int pId, String gId, String badge) {
        try {
            // This should all belong to a RepositoryPlayerBadge but me lazy rn
            RepositoryPlayer playerRepo = new RepositoryPlayer();

            Player p = playerRepo.find(pId);
            System.out.println(p);

            RepositoryGame gameRepo = new RepositoryGame();

            Game g = gameRepo.find(gId);
            System.out.println(g);

            RepositoryBadge badgeRepo = new RepositoryBadge();

            Badge b = badgeRepo.find(badge);

            MapperPlayerBadge mapper = new MapperPlayerBadge();
            PlayerBadge pb = new PlayerBadge();
            PlayerBadgeId pbId = new PlayerBadgeId();
            pbId.setPlayerId(p.getId());
            pbId.setBadgeId(b.getId());
            pb.setPlayer(p);
            pb.setBadge(b);
            pb.setId(pbId);

            mapper.create(pb);
            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }
}
