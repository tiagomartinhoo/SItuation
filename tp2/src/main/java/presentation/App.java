/*
 Walter Vieira (2022-04-22)
 Sistemas de Informação - projeto JPAAulas_ex3
 Código desenvolvido para iulustração dos conceitos sobre acesso a dados, concretizados com base na especificação JPA.
 Todos os exemplos foram desenvolvidos com EclipseLinlk (3.1.0-M1), usando o ambientre Eclipse IDE versão 2022-03 (4.23.0).
 
Não existe a pretensão de que o código estaja completo.

Embora tenha sido colocado um esforço significativo na correção do código, não há garantias de que ele não contenha erros que possam 
acarretar problemas vários, em particular, no que respeita à consistência dos dados.  
 
*/

package presentation;

import java.util.List;
import java.util.Scanner;

import businessLogic.*;
import dal.DataScope;
import dal.IsolationLevel;
import model.JogadorTotalInfo;
import utils.TablePrinter;


/**
 * Hello world!
 *
 */

public class App 
{
	

	public static void main( String[] args ) throws Exception {
		start();
   	}

	public static void start() {
	   // Top-level DataScope, is in charge of commit/rollback
		try(DataScope ds = new DataScope()) {
			BLService services = new BLService();
			pickTransLevel(ds);
			while (true) {
				printCommands();
				int opt = readOption(new Scanner(System.in));
				if (opt == 9) break;
				option(opt, services);
			}
			confirmTransaction(ds);
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		}
	}

	private static void pickTransLevel(DataScope ds) throws Exception {
		System.out.println("\n1. READ_UNCOMMITED");
		System.out.println("2. READ_COMMITED");
		System.out.println("3. REPEATABLE_READ");
		System.out.println("4. SERIALIZABLE");
		System.out.println("Any: default");
		printPrompt();
		int opt = readOption(new Scanner(System.in));
		switch (opt) {
			case 1 -> ds.setIsolationLevel(IsolationLevel.READ_UNCOMMITED);
			case 2 -> ds.setIsolationLevel(IsolationLevel.READ_COMMITED);
			case 3 -> ds.setIsolationLevel(IsolationLevel.REPEATABLE_READ);
			case 4 -> ds.setIsolationLevel(IsolationLevel.SERIALIZABLE);
		}
	}

	private static void confirmTransaction(DataScope ds) {
		System.out.println("Would you like to commit changes? (Y/N)");
		printPrompt();

		String opt = new Scanner(System.in).nextLine().toUpperCase();

		if(opt.equalsIgnoreCase("Y"))
			ds.validateWork();  // Set work as valid, which means it commits on main DataScope instance close
		else {
			ds.cancelWork(); // Likewise cancelWork makes it rollback
		}

	}

	public static void printCommands() {
		System.out.println("\nCommands:");
		System.out.println("1.Create/Ban/Deactivate player"); //d
		System.out.println("2.Get total points for player"); //e
		System.out.println("3.Get amount of games played for player"); //f
		System.out.println("4.Get total points for game per player");//g
		System.out.println("5.Associate badge");//h
		System.out.println("6.Chat options");//i, j, k
		System.out.println("7.Get total player info");//l
		System.out.println("8.Increase badge points by 20%");
//        System.out.println("8.Send message in chat");//
		System.out.println("9.Exit");
		printPrompt();
	}

	public static void option(Integer number, BLService services) {
		Scanner scanner = new Scanner(System.in);
		switch (number) {
			case 1 -> playerOptions(services, scanner);
			case 2 -> {
				System.out.print("\nInsert player id to obtain points: ");
				int id = scanner.nextInt();
				int p = services.totalUserPoints(id);
				if (p >= 0)
					System.out.println("\nPlayer with id: " + id + " has a total of " + p + " points");
			}
			case 3 -> {
				System.out.print("\nInsert player id to obtain games: ");
				int id = scanner.nextInt();
				int games = services.totalUserGames(id);
				if (games >= 0)
					System.out.println("\nPlayer with id: " + id + " has a total of " + games + " games");
			}
			case 4 -> {
				System.out.print("Insert game id to obtain the total points for game per player: ");
				String g_id = scanner.next();

				List<Object[]> retList = services.totalPointsForGamePerPlayer(g_id);
				System.out.println("Total points per player in the specific game");
				System.out.println("--------------------------------------------");
				System.out.println("Player | Score");

				for (Object[] playerScoreTable : retList) {
					System.out.println("  " + playerScoreTable[0] + "    |   " + playerScoreTable[1]);
				}
			}
			case 5 -> {
				associateBadgeOptions(services, scanner);
			}
			case 6 -> {
				chatOptions(services, scanner);
			}
			case 7 -> {
				List<JogadorTotalInfo> list = services.totalUserInfo();

				System.out.println("\nTotal info per player");
				System.out.println("------------------------------------------------------------------------------------------");

				TablePrinter.printTable(list);
			}
			case 8 -> {
				increaseBadgePointsOptions(services, scanner);
			}
		}
	}

	private static void increaseBadgePointsOptions(BLService services, Scanner scanner) {
		System.out.println("1. with Optimisic locking");
		System.out.println("2. with Pessismistic locking");
		printPrompt();
		int opt = scanner.nextInt();

		//No point in asking more stuff, code is organized this way for efficiency and clarity
		if (opt != 1 && opt !=2) return;

		System.out.print("Badge name: ");
		String badge = scanner.next();
		System.out.print("Game id: ");
		String gId = scanner.next();
		switch (opt) {
			case 1 -> services.increaseBadgePoints(badge, gId, true);
			case 2 -> services.increaseBadgePoints(badge, gId, false);
		}
	}

	private static void associateBadgeOptions(BLService services, Scanner scanner) {
		System.out.println("1. With procedure");
		System.out.println("2. Without procedure");
		printPrompt();
		int opt = scanner.nextInt();

		//No point in asking more stuff, code is organized this way for efficiency and clarity
		if (opt != 1 && opt !=2) return;

		System.out.print("Player id: ");
		int pId = scanner.nextInt();
		System.out.print("Game id: ");
		String gId = scanner.next();
		System.out.print("Badge name: ");
		String badge = scanner.next();

		switch (opt) {
			case 1 -> {
				if (services.associateBadgeWithProc(pId, gId, badge)) {
					System.out.println("Successfully associated");
				} else System.out.println("Could not associate");
			}
			case 2 -> {
				if (services.associateBadgeWithoutProc(pId, gId, badge)) {
					System.out.println("Successfully associated");
				} else System.out.println("Could not associate");
			}
		}
	}

	private static void chatOptions(BLService services, Scanner scanner) {
		System.out.println("1. Iniciar Conversa");
		System.out.println("2. Juntar a uma Conversa");
		System.out.println("3. Enviar mensagem para uma Conversa");
		int opt = readOption(scanner);
		switch (opt) {
			case 1 -> {
				System.out.print("Player id:");
				int pId = scanner.nextInt();
				System.out.print("Chat name:");
				String cName = scanner.next();
				if(services.createChat(pId, cName) >= 0){
					System.out.println("Player started chat successfully");
				}else{
					System.out.println("Player has not able to join the chat");
				}
			}
			case 2 -> {
				System.out.print("Player id:");
				int pId = scanner.nextInt();
				System.out.print("Chat id:");
				int cId = scanner.nextInt();
				if(services.joinChat(pId,cId)){
					System.out.println("Player joined chat successfully");
				}else{
					System.out.println("Player has not able to join the chat");
				}
			}
			case 3 -> {
				System.out.print("Player id: ");
				int pId = scanner.nextInt();
				System.out.print("Chat id: ");
				int cId = scanner.nextInt();
				System.out.print("Message: ");
				String msg = scanner.next();
				services.sendMessage(pId, cId, msg);
			}
		}
	}

	private static void playerOptions(BLService services, Scanner scanner) {
		System.out.println("1. Create a player");
		System.out.println("2. Ban player");
		System.out.println("3. Deactivate player");
		int opt = readOption(scanner);
		switch (opt) {
			case 1: {
				System.out.println("To create a player you need and email, username the activity state and the region he belongs to");
				System.out.print("Insert the player email: ");
				String email = scanner.next();
				System.out.print("Insert the player username: ");
				String username = scanner.next();
				System.out.print("Insert the player activity state (Active, Inactive or Banned): ");
				String activity_state = scanner.next();
				System.out.print("Insert the player region: ");
				String region = scanner.next();
				if(services.createUser(email,username,activity_state,region)){
					System.out.println("User Created successfully");
				}else {
					System.out.println("User was not created");
				}
				break;
			}
			case 2: {
				System.out.print("Insert player id to ban: ");
				int id = scanner.nextInt();
				services.banUser(id);
				break;
			}
			case 3: {
				System.out.print("Insert player id to deactivate: ");
				int id = scanner.nextInt();
				services.deactivateUser(id);
				break;
			}
			default: break;
		}
	}


	public static int readOption(Scanner scanner) {
		return scanner.nextInt();
	}

	public static void printPrompt() {
		System.out.print("> ");
	}
}

