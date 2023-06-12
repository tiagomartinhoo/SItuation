package utils;

import java.util.Scanner;

public class IOUtils {

    public static String EMAIL_REGEX = "^[A-Za-z0-9+_.-]+@(.+)$";


    /**
     * Cleans the console after performing the operation.
     */
    public static void printResult(String message) {
        clearConsole();
        System.out.println(message);
    }

    /**
     * Cleans the console after performing the operation.
     */
    public static void clearConsole() {
        for (int y = 0; y < 5; y++)
            System.out.println("\n");
    }

    public static void printPrompt() {
        System.out.print("> ");
    }

    public static Integer nextIntOrNull(Scanner scanner) {
        try {
            return scanner.nextInt();
        } catch (Exception e) {
            return null;
        }
    }
}
