package main.domain.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

import main.domain.model.ItemStock;
import main.observer.Observer;

public class StockDAOImpl implements StockDAO {
    private static final String FIND_STOCK_BY_ITEM_CODE_SQL =
            "SELECT s.id, s.item_code, i.item_name, s.date_of_purchase, s.quantity, s.expiry_date " +
                    "FROM itemstock s JOIN items i ON s.item_code = i.item_code WHERE s.item_code = ?";

    private static final String UPDATE_STOCK_QUANTITY_SQL =
            "UPDATE itemstock SET quantity = ? WHERE id = ?";

    private static final String GET_ITEM_CODE_BY_ID_SQL =
            "SELECT item_code FROM itemstock WHERE id = ?";

    private static final String GET_TOTAL_AVAILABLE_QUANTITY_SQL =
            "SELECT SUM(quantity) AS TotalQuantity FROM (SELECT quantity FROM shelves WHERE item_code = ? UNION ALL SELECT quantity FROM itemstock WHERE item_code = ?) AS Total";

    private static final String FIND_STOCK_BELOW_REORDER_LEVEL_SQL =
            "SELECT i.item_code AS item_code, i.item_name AS item_name, SUM(s.quantity) AS TotalQuantity " +
                    "FROM items i JOIN itemstock s ON i.item_code = s.item_code " +
                    "GROUP BY i.item_code, i.item_name HAVING SUM(s.quantity) < ?";

    private static final String FIND_ALL_STOCK_DETAILS_SQL =
            "SELECT s.id, s.item_code, i.item_name, s.date_of_purchase, s.quantity, s.expiry_date " +
                    "FROM itemstock s JOIN items i ON s.item_code = i.item_code";

    private static final String FIND_EXPIRED_STOCK_SQL =
            "SELECT itemstock.*, items.item_name FROM itemstock " +
                    "JOIN items ON itemstock.item_code = items.item_code " +
                    "WHERE itemstock.expiry_date < CURRENT_DATE";

    private static final String DELETE_EXPIRED_STOCK_SQL =
            "DELETE FROM itemstock WHERE id = ?";

    private static final String DELETE_STOCK_SQL =
            "DELETE FROM itemstock WHERE id = ?";

    private final Connection connection;
    private final List<Observer> observers = new CopyOnWriteArrayList<>();

    public StockDAOImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public void addObserver(Observer observer) {
        observers.add(observer);
    }

    @Override
    public void removeObserver(Observer observer) {
        observers.remove(observer);
    }

    @Override
    public void notifyObservers(String itemCode, int newQuantity) {
        if (observers.isEmpty()) {
            System.out.println("No observers registered to notify.");
            return;
        }
        for (Observer observer : observers) {
            observer.update(itemCode, newQuantity);
        }
    }

    @Override
    public List<ItemStock> findStockByItemCode(String itemCode) {
        return queryStock(FIND_STOCK_BY_ITEM_CODE_SQL, itemCode);
    }

    private List<ItemStock> queryStock(String sql, String... params) {
        List<ItemStock> stocks = new ArrayList<>();
        try (PreparedStatement stmt = createPreparedStatement(sql, params);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                if (sql.equals(FIND_STOCK_BELOW_REORDER_LEVEL_SQL)) {
                    stocks.add(new ItemStock(
                            rs.getString("item_code"),
                            rs.getString("item_name"),
                            rs.getInt("TotalQuantity")));
                } else {
                    stocks.add(new ItemStock(
                            rs.getInt("id"),
                            rs.getString("item_code"),
                            rs.getString("item_name"),
                            rs.getInt("quantity"),
                            rs.getDate("date_of_purchase"),
                            rs.getDate("expiry_date")));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stocks;
    }

    @Override
    public void updateStockQuantity(int itemStockID, int newQuantity) {
        try {
            connection.setAutoCommit(false); // Start transaction

            if (newQuantity <= 0) {
                removeStockById(itemStockID);
            } else {
                try (PreparedStatement stmt = connection.prepareStatement(UPDATE_STOCK_QUANTITY_SQL)) {
                    stmt.setInt(1, newQuantity);
                    stmt.setInt(2, itemStockID);
                    stmt.executeUpdate();
                }
            }

            // Notify observers of the updated quantity
            String itemCode = getItemCodeById(itemStockID);
            notifyObservers(itemCode, newQuantity);

            connection.commit(); // Commit transaction
        } catch (SQLException e) {
            try {
                connection.rollback(); // Rollback transaction on error
            } catch (SQLException rollbackEx) {
                e.printStackTrace();
            }
            throw new StockDAOException("Failed to update stock quantity", e);
        } finally {
            try {
                connection.setAutoCommit(true); // Reset auto-commit
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }

    private String getItemCodeById(int itemStockID) {
        try (PreparedStatement stmt = connection.prepareStatement(GET_ITEM_CODE_BY_ID_SQL)) {
            stmt.setInt(1, itemStockID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("item_code");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int getTotalAvailableQuantity(String itemCode) {
        try (PreparedStatement stmt = createPreparedStatement(GET_TOTAL_AVAILABLE_QUANTITY_SQL, itemCode, itemCode);
             ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt("TotalQuantity");
            } else {
                return 0; // No records found, item is unavailable
            }
        } catch (SQLException e) {
            throw new StockDAOException("Failed to get available quantity", e);
        }
    }

    @Override
    public List<ItemStock> findStockBelowReorderLevel(int reorderLevel) {
        return queryStock(FIND_STOCK_BELOW_REORDER_LEVEL_SQL, String.valueOf(reorderLevel));
    }

    @Override
    public List<ItemStock> findAllStockDetails() {
        return queryStock(FIND_ALL_STOCK_DETAILS_SQL);
    }

    @Override
    public List<ItemStock> findExpiredStock() {
        return queryStock(FIND_EXPIRED_STOCK_SQL);
    }

    @Override
    public void removeExpiredStock(List<ItemStock> expiredStocks) {
        try (PreparedStatement stmt = connection.prepareStatement(DELETE_EXPIRED_STOCK_SQL)) {
            for (ItemStock stock : expiredStocks) {
                stmt.setInt(1, stock.getItemStockID());
                stmt.executeUpdate();
                System.out.println("Removed expired stock: " + stock.getCode() + ", Quantity: " + stock.getQuantity());
            }
        } catch (SQLException e) {
            throw new StockDAOException("Failed to remove expired stock", e);
        }
    }

    @Override
    public void removeStockById(int itemStockID) {
        try (PreparedStatement stmt = connection.prepareStatement(DELETE_STOCK_SQL)) {
            stmt.setInt(1, itemStockID);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new StockDAOException("Failed to remove stock entry", e);
        }
    }

    private PreparedStatement createPreparedStatement(String sql, String... params) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            stmt.setString(i + 1, params[i]);
        }
        return stmt;
    }

    public static class StockDAOException extends RuntimeException {
        public StockDAOException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
