package utils;

import java.lang.reflect.Field;
import java.util.ArrayList;
import java.util.List;

public class TablePrinter {
    public static <T> void printTable(List<T> objects) {
        if (objects.isEmpty()) {
            System.out.println("No data available.");
            return;
        }

        Class<?> clazz = objects.get(0).getClass();
        Field[] fields = clazz.getDeclaredFields();
        List<String> headers = new ArrayList<>();
        List<List<String>> rows = new ArrayList<>();

        // Obter os cabeçalhos dos campos
        for (Field field : fields) {
            headers.add(field.getName().toUpperCase());
        }

        // Obter os valores dos campos para cada objeto
        for (T obj : objects) {
            List<String> row = new ArrayList<>();
            for (Field field : fields) {
                field.setAccessible(true);
                try {
                    Object value = field.get(obj);
                    row.add(value != null ? value.toString() : "");
                } catch (IllegalAccessException e) {
                    row.add("N/A");
                }
            }
            rows.add(row);
        }

        // Determinar a largura de cada coluna
        int numColumns = headers.size();
        int[] columnWidths = new int[numColumns];
        for (int i = 0; i < numColumns; i++) {
            columnWidths[i] = Math.max(headers.get(i).length(), getMaxColumnWidth(rows, i));
        }

        // Imprimir o cabeçalho da tabela
        printRow(headers, columnWidths);

        // Imprimir os dados da tabela
        for (List<String> row : rows) {
            printRow(row, columnWidths);
        }
    }

    private static int getMaxColumnWidth(List<List<String>> rows, int columnIndex) {
        int max = 0;
        for (List<String> row : rows) {
            if (columnIndex < row.size()) {
                max = Math.max(max, row.get(columnIndex).length());
            }
        }
        return max;
    }

    private static void printRow(List<String> row, int[] columnWidths) {
        for (int i = 0; i < row.size(); i++) {
            String value = row.get(i);
            int width = columnWidths[i];
            System.out.printf("%-" + width + "s\t", value);
        }
        System.out.println();
    }
}
