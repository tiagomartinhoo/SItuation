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
import java.util.Set;

import businessLogic.*;

import java.util.ArrayList;


import dal.DataScope;
import model.*;


/**
 * Hello world!
 *
 */

public class App 
{
	
   @SuppressWarnings("unchecked")
	public static void main( String[] args ) throws Exception {
		start();
   	}

	public static void start() {
	   // Top-level DataScope, is in charge of commit/rollback
		try(DataScope ds = new DataScope()) {
			BLService services = new BLService();
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
		System.out.println("8. Associate badge without procedure");
//        System.out.println("8.Send message in chat");//
		System.out.println("9.Exit");
		printPrompt();
	}

	public static void option(Integer number, BLService services) {
		Scanner scanner = new Scanner(System.in);
		switch (number) {
			case 1 -> playerOptions(services, scanner);
			case 2 -> {
				System.out.print("Insert player id to obtain points: ");
				int id = scanner.nextInt();
				int p = services.totalUserPoints(id);
				System.out.println("Player with id: " + id + " has a total of " + p + " points");
			}
			case 3 -> {
			}
			case 4 -> {
			}
			case 5 -> {
				System.out.print("Player id: ");
				int pId = scanner.nextInt();
				System.out.print("Game id: ");
				String gId = scanner.next();
				System.out.print("Badge name: ");
				String badge = scanner.next();
				if (services.associateBadgeWithProc(pId, gId, badge)) {
					System.out.println("Successfully associated");
				} else System.out.println("Could not associate");
			}
			case 6 -> {
				chatOptions(services, scanner);

			}
			case 7 -> {
			}
			case 8 -> {
				System.out.print("Player id: ");
				int pId = scanner.nextInt();
				System.out.print("Game id: ");
				String gId = scanner.next();
				System.out.print("Badge name: ");
				String badge = scanner.next();
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
			}
			case 2 -> {
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
				//TODO: USER CREATION INPUTS
				break;
			}
			case 2: {
				System.out.print("Insert player id to ban: ");
				int id = scanner.nextInt();
				services.banUser(id);
			}
			case 3: {
				System.out.print("Insert player id to deactivate: ");
				int id = scanner.nextInt();
				services.deactivateUser(id);
			}
			default: break;
		}
	}


	public static int readOption(Scanner scanner) {
		return scanner.nextInt();
	}

	public static void printPrompt() {
		System.out.print(">");
	}
}

