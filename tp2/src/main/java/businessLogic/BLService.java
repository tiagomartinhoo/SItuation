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

import model.*;

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

    public boolean createUser(String email, String username, String activity_state, String region){
        try (DataScope ds = new DataScope()) {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.createPlayer(email, username, activity_state, region);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }
    public boolean banUser(int p_id) {
        try (DataScope ds = new DataScope()) {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.banUser(p_id);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public boolean deactivateUser(int p_id) {
        try (DataScope ds = new DataScope()) {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.deactivateUser(p_id);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
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

    public List<Object[]> totalPointsForGamePerPlayer(String g_id) {
        try {
            RepositoryPlayerScore repo = new RepositoryPlayerScore();

            return repo.totalPointsForGamePerPlayer(g_id);

        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

        return null;
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
            RepositoryBadge badgeRepo = new RepositoryBadge();

            Badge b = badgeRepo.find(badge, gId); //Obtain badge information

            RepositoryPlayer playerRepo = new RepositoryPlayer();

            long points = playerRepo.totalPlayerPointsInGame(pId, gId);

            if (points == -1){
                System.out.println("Couldn't find specified user");
                return false;
            }
            if(b == null) {
                System.out.println("Couldn't find specified badge");
                return false;
            }
            if(points < b.getPointsLimit()) {
                System.out.println("User does not have enough points for this badge");
                return false;
            }

            RepositoryPlayerBadge repo = new RepositoryPlayerBadge();

            repo.add(pId, gId, badge);
            return true;
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return false;
    }

    public boolean joinChat(int player_id, int chat_id) {
        try (DataScope ds = new DataScope()) {

            RepositoryChatLookUp repo = new RepositoryChatLookUp();

            return repo.joinChat(player_id, chat_id);
        } catch(Exception e) {
            System.out.println(e.getMessage());
            return false;
        }
    }

    public void sendMessage(int pId, int cId, String msg) {
        try {
            MapperChatLookup clM = new MapperChatLookup();
            ChatLookupId clId = new ChatLookupId();
            clId.setChatId(cId);
            clId.setPlayerId(pId);

            // If this throws IllegalAccessException, then user does not have
            // access to the chat
            clM.read(clId);

            RepositoryPlayer repo = new RepositoryPlayer();

            repo.sendMessage(pId, cId, msg);

        } catch (IllegalAccessException ex) {
            System.out.println("User does not have access to that chat");
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
    }

    public void increaseBadgePoints(String badge, String gId) {
        increaseBadgePoints(badge, gId, false);
    }

    public void increaseBadgePoints(String bName, String gId, boolean optimisticLocking) {
        try {
            RepositoryBadge repo = new RepositoryBadge();

            Badge badge = repo.find(bName, gId, optimisticLocking);
            if(badge == null) {
                System.out.println("Could not find specified badge");
                return;
            }
            int orig = badge.getPointsLimit();
            System.out.println("OLD VALUE: " + orig);
            int newValue = Math.round(orig * 1.2f);
            System.out.println("NEW VALUE: " + orig * 1.2f);

            badge.setPointsLimit(newValue);
            repo.save(badge, optimisticLocking);
        } catch (Exception ex) {
            System.out.println(ex.getMessage());
        }

    }
}
