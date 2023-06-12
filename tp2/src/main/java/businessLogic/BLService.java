package businessLogic;

import java.util.List;
import java.util.regex.Pattern;

import dal.*;
import model.*;
import utils.IOUtils;
import utils.ServiceWrapper;

public class BLService 
{

    public Boolean createUser(String email, String username, String region){
        if (!Pattern.matches(IOUtils.EMAIL_REGEX, email)) {
            IOUtils.printResult("Email format invalid.");
            return null;
        }
        if (username.length() > 20) {
            IOUtils.printResult("Username must be between 1 and 20 characters.");
            return null;
        }

        return ServiceWrapper.runAndCatch((arg) -> {

            RepositoryPlayer repo = new RepositoryPlayer();

            return repo.createPlayer(email, username, "Active", region);
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

    public Boolean sendMessage(int pId, int cId, String msg) {
        return ServiceWrapper.runAndCatch((arg) -> {
            MapperChatLookup clM = new MapperChatLookup();
            ChatLookupId clId = new ChatLookupId();
            clId.setChatId(cId);
            clId.setPlayerId(pId);

            // If this throws IllegalAccessException, then user does not have
            // access to the chat
            clM.read(clId);

            RepositoryPlayer repo = new RepositoryPlayer();

            repo.sendMessage(pId, cId, msg);
            return true;
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
