import javax.swing.*;
import java.sql.*;

public class DatabaseViewer extends JFrame {
    private JTextArea resultArea;

    public DatabaseViewer() {
        super("Database Viewer");
        resultArea = new JTextArea(10, 50);
        resultArea.setEditable(false);
        JScrollPane scrollPane = new JScrollPane(resultArea);

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
            ResultSet resultSet = statement.executeQuery("SELECT TOP 5 * FROM HumanResources.Employee");

            // Display results in the GUI
            StringBuilder resultText = new StringBuilder();
            while (resultSet.next()) {
                int id = resultSet.getInt("EmployeeId");
                String firstname = resultSet.getString("EmployeeFirstName");
                String lastname = resultSet.getString("EmployeeLastName");
                resultText.append("ID: ").append(id).append(", First name: ").append(firstname)
                        .append(", Last name: ").append(lastname).append("\n");
            }

            resultArea.setText(resultText.toString());

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
