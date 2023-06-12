package presentation;

import java.util.List;
import java.util.Scanner;

import businessLogic.*;
import dal.DataScope;
import dal.IsolationLevel;
import model.JogadorTotalInfo;
import utils.IOUtils;
import utils.TablePrinter;

import static utils.IOUtils.*;

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
				Integer opt = readOption(new Scanner(System.in));
				if (opt == null || opt > 9) {
					System.out.println("Invalid command.");
					continue;
				}
				if (opt == 9) break;
				option(opt, services);
				System.in.read();
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
		Integer opt = readOption(new Scanner(System.in));
		if (opt != null)
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
		else
			ds.cancelWork(); // Likewise cancelWork makes it rollback
	}

	public static void printCommands() {
		System.out.println("\nCommands:");
		System.out.println("1. Create/Ban/Deactivate player"); //d
		System.out.println("2. Get total points for player"); //e
		System.out.println("3. Get amount of games played for player"); //f
		System.out.println("4. Get total points for game per player");//g
		System.out.println("5. Associate badge");//h
		System.out.println("6. Chat options");//i, j, k
		System.out.println("7. Get total players info");//l
		System.out.println("8. Increase badge points by 20%");
		System.out.println("9. Exit");
		printPrompt();
	}

	public static void option(Integer number, BLService services) {
		Scanner scanner = new Scanner(System.in);
		switch (number) {
			case 1 -> playerOptions(services, scanner);
			case 2 -> {
				System.out.print("\nInsert player id to obtain points: ");
				Integer id = IOUtils.nextIntOrNull(scanner);
				if (id == null || id <= 0) {
					System.out.println("Invalid id.");
					break;
				}

				Integer points = services.totalUserPoints(id);
				if (points != null)
					printResult("Player with id: " + id + " has a total of " + points + " points");
			}
			case 3 -> {
				System.out.print("\nInsert player id to obtain games: ");
				Integer id = IOUtils.nextIntOrNull(scanner);
				if (id == null || id <= 0) {
					System.out.println("Invalid player id.");
					break;
				}

				Integer games = services.totalUserGames(id);
				if (games != null)
					printResult("Player with id: " + id + " has a total of " + games + " games");
			}
			case 4 -> {
				System.out.print("Insert game id to obtain the total points for game per player: ");
				String g_id = scanner.next();
				if (g_id.length() != 10) {
					System.out.println("Invalid id.");
					break;
				}

				List<Object[]> retList = services.totalPointsForGamePerPlayer(g_id);
				printResult("Total points per player in the specific game");
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

				printResult("Total info per player");
				System.out.println("------------------------------------------------------------------------------------------");

				TablePrinter.printTable(list);
			}
			case 8 -> {
				increaseBadgePointsOptions(services, scanner);
			}
		}
	}

	private static void increaseBadgePointsOptions(BLService services, Scanner scanner) {
		System.out.println("\n1. with Optimisic locking");
		System.out.println("2. with Pessismistic locking");
		printPrompt();

		Integer opt = readOption(scanner);
		if (opt == null || opt > 2) {
			System.out.println("Invalid command.");
			return;
		}

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
		System.out.println("\n1. With procedure");
		System.out.println("2. Without procedure");
		printPrompt();

		Integer opt = readOption(scanner);
		if (opt == null || opt > 2) {
			System.out.println("Invalid command.");
			return;
		}

		System.out.print("Player id: ");
		Integer pId = IOUtils.nextIntOrNull(scanner);
		if (pId == null || pId <= 0) {
			System.out.println("Invalid player id.");
			return;
		}

		System.out.print("Game id: ");
		String gId = scanner.next();
		if (gId.length() != 10) {
			System.out.println("Invalid game id.");
			return;
		}

		System.out.print("Badge name: ");
		String badge = scanner.next();
		if (badge.length() > 20) {
			System.out.println("Invalid badge name.");
			return;
		}

		switch (opt) {
			case 1 -> {
				Boolean associated = services.associateBadgeWithProc(pId, gId, badge);
				if (associated != null)
					printResult("Successfully associated");
			}
			case 2 -> {
				Boolean associated = services.associateBadgeWithoutProc(pId, gId, badge);
				if (associated != null)
					printResult("Successfully associated");
			}
		}
	}

	private static void chatOptions(BLService services, Scanner scanner) {
		System.out.println("\n1. Iniciar Conversa");
		System.out.println("2. Juntar a uma Conversa");
		System.out.println("3. Enviar mensagem para uma Conversa");
		printPrompt();

		Integer opt = readOption(scanner);
		if (opt == null || opt > 3) {
			System.out.println("Invalid command.");
			return;
		}

		System.out.print("Player id: ");
		Integer pId = IOUtils.nextIntOrNull(scanner);
		if (pId == null || pId <= 0) {
			System.out.println("Invalid player id.");
			return;
		}

		switch (opt) {
			case 1 -> {
				System.out.print("Chat name: ");
				String cName = scanner.next();
				if (cName.length() > 20) {
					System.out.println("Invalid chat name.");
					return;
				}

				Integer created = services.createChat(pId, cName);
				if(created != null)
					printResult("Player started chat successfully with id " + created);
			}
			case 2 -> {
				System.out.print("Chat id: ");
				Integer cId = IOUtils.nextIntOrNull(scanner);
				if (cId == null || cId <= 0) {
					System.out.println("Invalid chat id.");
					return;
				}

				Boolean joined = services.joinChat(pId, cId);
				if (joined != null)
					printResult("Player joined chat successfully");
			}
			case 3 -> {
				System.out.print("Chat id: ");
				Integer cId = IOUtils.nextIntOrNull(scanner);
				if (cId == null || cId <= 0) {
					System.out.println("Invalid player id.");
					return;
				}

				System.out.print("Message: ");
				String msg = scanner.next();

				Boolean sent = services.sendMessage(pId, cId, msg);
				if (sent != null)
					printResult("Message sent successfully.");
			}
		}
	}

	private static void playerOptions(BLService services, Scanner scanner) {
		System.out.println("\n1. Create a player");
		System.out.println("2. Ban player");
		System.out.println("3. Deactivate player");
		printPrompt();

		Integer opt = readOption(scanner);
		if (opt == null || opt > 3) {
			System.out.println("Invalid command.");
			return;
		}

		switch (opt) {
			case 1: {
				System.out.println("\nTo create a player you need and email, username the activity state and the region he belongs to");

				System.out.print("Insert the player email: ");
				scanner.nextLine();
				String email = scanner.nextLine();
				System.out.print("Insert the player username: ");
				String username = scanner.nextLine();
				System.out.print("Insert the player region: ");
				String region = scanner.nextLine();

				Boolean userCreated = services.createUser(email,username,region);
				if (userCreated != null)
					printResult("User created successfully.");
				break;
			}
			case 2: {
				System.out.print("Insert player id to ban: ");
				Integer id = IOUtils.nextIntOrNull(scanner);
				if (id == null || id <= 0) {
					System.out.println("Invalid player id.");
					break;
				}

				Boolean userBanned = services.banUser(id);
				if (userBanned != null)
					printResult("User " + id + " banned successfully.");
				break;
			}
			case 3: {
				System.out.print("Insert player id to deactivate: ");
				Integer id = IOUtils.nextIntOrNull(scanner);
				if (id == null || id <= 0) {
					System.out.println("Invalid player id.");
					break;
				}

				Boolean userDeactivated = services.deactivateUser(id);
				if (userDeactivated != null)
					printResult("User " + id + " deactivated successfully.");
				break;
			}
			default: break;
		}
	}

	public static Integer readOption(Scanner scanner) {
		Integer cmd = IOUtils.nextIntOrNull(scanner);
		if (cmd == null || cmd <= 0) return null;
		return cmd;
	}
}

