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

import java.util.Collections;
import java.util.List;

import dal.*;
import model.*;
import utils.ServiceWrapper;

public class BLService 
{
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

    public Boolean createUser(String email, String username, String activity_state, String region){
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.createPlayer(email, username, activity_state, region);
        });
    }

    public Boolean banUser(int p_id) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.banUser(p_id);
        });
    }

    public Boolean deactivateUser(int p_id) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.deactivateUser(p_id);
        });
    }

    public Integer totalUserPoints(int id) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.totalPlayerPoints(id);
        });
    }

    public Integer totalUserGames(int id) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.totalPlayerGames(id);
        });
    }

    public List<JogadorTotalInfo> totalUserInfo() {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.getAllTotalInfo();
        });
    }

    public List<Object[]> totalPointsForGamePerPlayer(String g_id) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayerScore repo = new RepositoryPlayerScore();

            return repo.totalPointsForGamePerPlayer(g_id);
        });
    }

    public Boolean associateBadgeWithProc(int pId, String gId, String badge) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.associateBadge(pId, gId, badge);
        });
    }

    public Boolean associateBadgeWithoutProc(int pId, String gId, String badge) {
        return ServiceWrapper.runAndCatch((arg) -> {
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
        });
    }

    public Integer createChat(int player_id, String chat_name) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryChatLookUp repo = new RepositoryChatLookUp();

            return repo.createChat(player_id, chat_name);
        });
    }

    public Boolean joinChat(int player_id, int chat_id) {
        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryChatLookUp repo = new RepositoryChatLookUp();

            return repo.joinChat(player_id, chat_id);
        });
    }

    public void sendMessage(int pId, int cId, String msg) {
        ServiceWrapper.runAndCatch((arg) -> {
            MapperChatLookup clM = new MapperChatLookup();
            ChatLookupId clId = new ChatLookupId();
            clId.setChatId(cId);
            clId.setPlayerId(pId);

            // If this throws IllegalAccessException, then user does not have
            // access to the chat
            clM.read(clId);

            RepositoryPlayer repo = new RepositoryPlayer();

            repo.sendMessage(pId, cId, msg);
            return null;
        });
    }

    public void increaseBadgePoints(String badge, String gId) {
        increaseBadgePoints(badge, gId, false);
    }

    public void increaseBadgePoints(String bName, String gId, boolean optimisticLocking) {
        ServiceWrapper.runAndCatch((arg) -> {
            RepositoryBadge repo = new RepositoryBadge();

            Badge badge = repo.find(bName, gId, optimisticLocking);
            if(badge == null) {
                System.out.println("Could not find specified badge");
                return null;
            }
            int orig = badge.getPointsLimit();
            System.out.println("OLD VALUE: " + orig);
            int newValue = Math.round(orig * 1.2f);
            System.out.println("NEW VALUE: " + newValue);

            badge.setPointsLimit(newValue);
            repo.save(badge, optimisticLocking);
            return null;
        });
    }

}
