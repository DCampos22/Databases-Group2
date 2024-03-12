import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Create_DB {
    public static void main(String[] args) {
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
            while (resultSet.next()) {
                // Retrieve and print values from the result set
                int id = resultSet.getInt("EmployeeId");
                String firstname = resultSet.getString("EmployeeFirstName");
                String lastname = resultSet.getString("EmployeeLastName");
                System.out.println("ID: " + id + ", First name: " + firstname + ", Last name: " + lastname);
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
}
