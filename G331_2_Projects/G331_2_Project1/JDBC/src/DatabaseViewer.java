import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.sql.*;

public class DatabaseViewer extends JFrame {
    private DefaultTableModel tableModel;
    private JTable resultTable;

    public DatabaseViewer() {
        super("Database Viewer");

        // Create table model and table
        tableModel = new DefaultTableModel();
        resultTable = new JTable(tableModel);
        JScrollPane scrollPane = new JScrollPane(resultTable);
        add(scrollPane);

        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null); // Center the frame
        pack();
        setVisible(true);

        // Load the JDBC driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }

        // JDBC URL for SQL Server
        String url = "jdbc:sqlserver://localhost:13001;databaseName=Northwinds2022TSQLV7;encrypt=false;";
        String username = "sa";
        String password = "PH@123456789";

        try {
            // Establish connection to the database
            Connection connection = DriverManager.getConnection(url, username, password);
            System.out.println("Connected to the database");

            // Use the connection to execute SQL queries
            Statement statement = connection.createStatement();
            ResultSet resultSet = statement.executeQuery("SELECT TOP (5) EmployeeId, EmployeeLastName, EmployeeFirstName FROM HumanResources.Employee");

            // Populate table model with column names
            ResultSetMetaData metaData = resultSet.getMetaData();
            int columnCount = metaData.getColumnCount();
            for (int i = 1; i <= columnCount; i++) {
                tableModel.addColumn(metaData.getColumnName(i));
            }

            // Populate table model with data
            while (resultSet.next()) {
                Object[] rowData = new Object[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    rowData[i - 1] = resultSet.getObject(i);
                }
                tableModel.addRow(rowData);
            }

            // Close the result set, statement, and connection
            resultSet.close();
            statement.close();

            // Don't forget to close the connection when done
            connection.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(DatabaseViewer::new);
    }
}
