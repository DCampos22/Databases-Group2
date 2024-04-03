import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*; // Import BorderLayout
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class DatabaseViewer extends JFrame {
    private DefaultTableModel tableModel;
    private JTable resultTable;
    private JButton executeButton;
    private JButton connectButton; // New Connect button
    private JTextArea queryField; // Change to JTextArea
    private JTextField usernameField; // New username field --> sa
    private JPasswordField passwordField; // New password field --> PH@123456789
    private JComboBox<String> databaseComboBox;
    private final String[] DATABASES = {"AdventureWorks2017", "AdventureWorksDW2017", "BIClass", "WideWorldImporters", "WideWorldImportersDW", "Northwinds2022TSQLV7"};

    public DatabaseViewer() {
        super("Database Viewer");

        // Create table model and table
        tableModel = new DefaultTableModel();
        resultTable = new JTable(tableModel);
        JScrollPane scrollPane = new JScrollPane(resultTable);
        add(scrollPane);

        // Create query field, execute button, and database selection combo box
        queryField = new JTextArea(5, 50); // Change to JTextArea
        executeButton = new JButton("Execute");
        connectButton = new JButton("Connect"); // New Connect button
        usernameField = new JTextField(20); // New username field
        passwordField = new JPasswordField(20); // New password field
        databaseComboBox = new JComboBox<>(DATABASES);
        JPanel queryPanel = new JPanel();
        queryPanel.add(new JLabel("Username:")); // New label for username
        queryPanel.add(usernameField); // New username field
        queryPanel.add(new JLabel("Password:")); // New label for password
        queryPanel.add(passwordField); // New password field
        queryPanel.add(new JLabel("Database:"));
        queryPanel.add(databaseComboBox);
        queryPanel.add(new JLabel("Enter SQL Query:"));
        queryPanel.add(new JScrollPane(queryField)); // Wrap JTextArea in JScrollPane
        queryPanel.add(executeButton);
        queryPanel.add(connectButton); // New Connect button
        queryPanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10)); // Add padding to the panel

        add(queryPanel, BorderLayout.SOUTH);

        // Execute button action listener
        executeButton.addActionListener(e -> {
            String selectedDatabase = (String) databaseComboBox.getSelectedItem();
            String sqlQuery = queryField.getText().trim();
            String username = usernameField.getText(); // Get username from username field
            String password = new String(passwordField.getPassword()); // Get password from password field
            executeQuery(selectedDatabase, sqlQuery, username, password);
        });

        // Connect button action listener
        connectButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                String selectedDatabase = (String) databaseComboBox.getSelectedItem();
                String username = usernameField.getText(); // Get username from username field
                String password = new String(passwordField.getPassword()); // Get password from password field
                connectToDatabase(selectedDatabase, username, password);
            }
        });

        setPreferredSize(new Dimension(850,600));
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); 
        pack();
        setLocationRelativeTo(null); // Center the frame
        setVisible(true);

        // Load the JDBC driver
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            return;
        }
    }

     private void executeQuery(String databaseName, String sqlQuery, String username, String password) {
        tableModel.setRowCount(0);
        tableModel.setColumnCount(0);

        String url = "jdbc:sqlserver://localhost:13001;databaseName=" + databaseName + ";encrypt=false;";

        try (Connection connection = DriverManager.getConnection(url, username, password);
             Statement statement = connection.createStatement()) {

            // Split SQL queries by semicolon
            String[] queries = sqlQuery.split(";");

            for (String query : queries) {
                if (!query.trim().isEmpty()) {
                    statement.execute(query);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    


    private void connectToDatabase(String databaseName, String username, String password) {
        // JDBC URL for SQL Server
        String url = "jdbc:sqlserver://localhost:13001;databaseName=" + databaseName + ";encrypt=false;";

        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            JOptionPane.showMessageDialog(this, "Connected to database successfully!");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Failed to connect to database: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(DatabaseViewer::new);
    }
}
