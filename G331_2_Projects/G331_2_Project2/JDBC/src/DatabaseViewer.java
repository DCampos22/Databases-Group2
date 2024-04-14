import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.*;

public class DatabaseViewer extends JFrame {
    private JComboBox<String> databaseComboBox;
    private JTextField queryField;
    private JTextField usernameField;
    private JPasswordField passwordField;
    private JButton connectButton;
    private JButton executeButton;
    private JPanel resultPanel;
    private final String[] DATABASES = {"BIClass", "AdventureWorks2017", "AdventureWorksDW2017", "WideWorldImporters", "WideWorldImportersDW", "Northwinds2022TSQLV7"};

    public DatabaseViewer() {
        super("Database Viewer");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(850, 800)); // Adjust the preferred height here

        databaseComboBox = new JComboBox<>(DATABASES);
        usernameField = new JTextField(20);
        passwordField = new JPasswordField(20);
        queryField = new JTextField(50);
        queryField.setPreferredSize(new Dimension(queryField.getPreferredSize().width, 200));
        executeButton = new JButton("Execute");
        connectButton = new JButton("Connect");
        resultPanel = new JPanel(new GridLayout(0, 1));

        JPanel queryPanel = new JPanel();
        queryPanel.setPreferredSize(new Dimension(800, 200)); // Adjust the height here
        queryPanel.add(new JLabel("Username:"));
        queryPanel.add(usernameField);
        queryPanel.add(new JLabel("Password:"));
        queryPanel.add(passwordField);
        queryPanel.add(new JLabel("Database:"));
        queryPanel.add(databaseComboBox);
        queryPanel.add(new JLabel("Enter SQL Query:"));
        queryPanel.add(queryField);
        queryPanel.add(executeButton);
        queryPanel.add(connectButton);

        JScrollPane scrollPane = new JScrollPane(resultPanel);
        add(queryPanel, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);

        connectButton.addActionListener(e -> connectToDatabase());
        executeButton.addActionListener(e -> executeQuery());

        pack();
        setLocationRelativeTo(null);
        setVisible(true);
    }


    private void connectToDatabase() {
        String databaseName = (String) databaseComboBox.getSelectedItem();
        String username = usernameField.getText();
        String password = new String(passwordField.getPassword());
        String url = "jdbc:sqlserver://localhost:13001;databaseName=" + databaseName + ";encrypt=false;";
        try (Connection connection = DriverManager.getConnection(url, username, password)) {
            JOptionPane.showMessageDialog(this, "Connected to database successfully!");
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Failed to connect to database: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        }
    }

    private void executeQuery() {
        String databaseName = (String) databaseComboBox.getSelectedItem();
        String username = usernameField.getText();
        String password = new String(passwordField.getPassword());
        String sqlQuery = queryField.getText().trim();
        String url = "jdbc:sqlserver://localhost:13001;databaseName=" + databaseName + ";encrypt=false;";
        try (Connection connection = DriverManager.getConnection(url, username, password);
             Statement statement = connection.createStatement()) {
            boolean hasResults = statement.execute(sqlQuery);
            int resultSetCount = 0;
            do {
                if (hasResults) {
                    ResultSet resultSet = statement.getResultSet();
                    displayResultSet(resultSet);
                    resultSetCount++;
                }
                hasResults = statement.getMoreResults();
            } while (hasResults || statement.getUpdateCount() != -1);
            if (resultSetCount == 0) {
                JOptionPane.showMessageDialog(this, "The query did not return any result set.");
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "SQL Error: " + e.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        }
    }

    private void displayResultSet(ResultSet resultSet) throws SQLException {
        if (resultSet != null) {
            ResultSetMetaData metaData = resultSet.getMetaData();
            int columnCount = metaData.getColumnCount();
            DefaultTableModel tableModel = new DefaultTableModel();
            for (int i = 1; i <= columnCount; i++) {
                tableModel.addColumn(metaData.getColumnName(i));
            }
            while (resultSet.next()) {
                Object[] rowData = new Object[columnCount];
                for (int i = 1; i <= columnCount; i++) {
                    rowData[i - 1] = resultSet.getObject(i);
                }
                tableModel.addRow(rowData);
            }
            JTable resultTable = new JTable(tableModel);
            resultPanel.add(new JScrollPane(resultTable));
            resultPanel.revalidate();
            resultPanel.repaint();
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(DatabaseViewer::new);
    }
}