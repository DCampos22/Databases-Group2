import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.BorderLayout; // Import BorderLayout
import java.sql.*;

public class DatabaseViewer extends JFrame {
    private DefaultTableModel tableModel;
    private JTable resultTable;
    private JButton executeButton;
    private JTextField queryField;
    private JComboBox<String> databaseComboBox;
    private final String[] DATABASES = {"AdventureWorks2017", "AdventureWorksDW2017", "WideWorldImporters", "WideWorldImportersDW", "Northwinds2022TSQLV7"};

    public DatabaseViewer() {
        super("Database Viewer");

        // Create table model and table
        tableModel = new DefaultTableModel();
        resultTable = new JTable(tableModel);
        JScrollPane scrollPane = new JScrollPane(resultTable);
        add(scrollPane);

        // Create query field, execute button, and database selection combo box
        queryField = new JTextField(50);
        executeButton = new JButton("Execute");
        databaseComboBox = new JComboBox<>(DATABASES);
        JPanel queryPanel = new JPanel();
        queryPanel.add(new JLabel("Database:"));
        queryPanel.add(databaseComboBox);
        queryPanel.add(new JLabel("Enter SQL Query:"));
        queryPanel.add(queryField);
        queryPanel.add(executeButton);
        add(queryPanel, BorderLayout.SOUTH);

        // Execute button action listener
        executeButton.addActionListener(e -> {
            String selectedDatabase = (String) databaseComboBox.getSelectedItem();
            String sqlQuery = queryField.getText().trim();
            executeQuery(selectedDatabase, sqlQuery);
        });

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
    }

    private void executeQuery(String databaseName, String sqlQuery) {
        tableModel.setRowCount(0); // Clear existing table data

        // JDBC URL for SQL Server
        String url = "jdbc:sqlserver://localhost:13001;databaseName=" + databaseName + ";encrypt=false;";
        String username = "sa";
        String password = "PH@123456789";

        try (Connection connection = DriverManager.getConnection(url, username, password);
             Statement statement = connection.createStatement();
             ResultSet resultSet = statement.executeQuery(sqlQuery)) {

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

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(DatabaseViewer::new);
    }
}
