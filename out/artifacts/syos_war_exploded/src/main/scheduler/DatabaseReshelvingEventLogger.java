package main.scheduler;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class DatabaseReshelvingEventLogger implements ReshelvingEventLogger {
    private static final String INSERT_EVENT_SQL =
            "INSERT INTO reshelvingevents (item_code, quantity, reshelved_date) VALUES (?, ?, CURRENT_TIMESTAMP)";

    private final Connection connection;

    public DatabaseReshelvingEventLogger(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void logReshelvingEvent(String item_code, int quantity) {
        try (PreparedStatement stmt = connection.prepareStatement(INSERT_EVENT_SQL)) {
            stmt.setString(1, item_code);
            stmt.setInt(2, quantity);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
