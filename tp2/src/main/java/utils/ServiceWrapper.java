package utils;

import dal.DataScope;
import jakarta.persistence.PersistenceException;
import org.postgresql.util.PSQLException;

/**
 * Deals with an instance of Unit of Work (DataScope) and exception handling.
 */
public class ServiceWrapper {

    public static <T, R, E extends Exception> R runAndCatch(ThrowingConsumer<T, R, E> function) {
        try (DataScope ds = new DataScope()) {
            return function.apply(null);
        }
        catch (PersistenceException pe) {
            try (DataScope ds = new DataScope()) {
                ds.resetTransaction();
            } catch (Exception ignored) {}

            Throwable cause = pe.getCause().getCause();

            if (cause instanceof PSQLException psqlException) {
                String errorMessage = psqlException.getLocalizedMessage();
                System.out.println("\n" + getPsqlErrorMessage(errorMessage));
            } else {
                pe.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    private static String getPsqlErrorMessage(String errorMessage) {
        String[] error = errorMessage.split(": ");
        return error[1].split("\n")[0];
    }

    @FunctionalInterface
    public interface ThrowingConsumer<T, R, E extends Exception> {
        R apply(T t) throws E;
    }
}
