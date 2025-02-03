package main.domain.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import main.domain.model.Shelf;

public class ShelvesDAOImpl implements ShelvesDAO {
    private static final String FIND_SHELVES_BY_ITEM_CODE_SQL = "SELECT * FROM Shelves WHERE item_code = ?";
    private static final String ADD_OR_UPDATE_SHELF_SQL = "INSERT INTO Shelves (item_code, quantity, moved_date, expiry_date) VALUES (?, ?, ?, ?) "
            +
            "ON DUPLICATE KEY UPDATE quantity = quantity + ?, moved_date = VALUES(moved_date), expiry_date = VALUES(expiry_date)";
    private static final String GET_ALL_ITEM_CODES_SQL = "SELECT DISTINCT item_code FROM Shelves";
    private static final String FIND_SHELF_BY_ITEM_CODE_AND_EXPIRY_DATE_SQL = "SELECT * FROM Shelves WHERE item_code = ? AND expiry_date = ?";
    private static final String UPDATE_SHELF_SQL = "UPDATE Shelves SET quantity = ?, moved_date = ?, expiry_date = ? WHERE item_code = ? AND expiry_date = ?";
    private static final String ADD_SHELF_SQL = "INSERT INTO Shelves (item_code, quantity, moved_date, expiry_date) VALUES (?, ?, ?, ?)";
    private static final String DELETE_SHELF_SQL = "DELETE FROM Shelves WHERE item_code = ? AND expiry_date = ?";
    private static final String FIND_EXPIRED_SHELVES_SQL = "SELECT * FROM Shelves WHERE expiry_date < CURRENT_DATE";
    private static final String REMOVE_EXPIRED_SHELVES_SQL = "DELETE FROM Shelves WHERE item_code = ? AND expiry_date = ?";

    private final Connection connection;

    public ShelvesDAOImpl(Connection connection) {
        this.connection = connection;
    }

    @Override
    public List<Shelf> findShelvesByItemCode(String itemCode) {
        return queryShelves(FIND_SHELVES_BY_ITEM_CODE_SQL, itemCode);
    }

    private List<Shelf> queryShelves(String sql, String... params) {
        List<Shelf> shelves = new ArrayList<>();
        try (PreparedStatement stmt = createPreparedStatement(sql, params);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                shelves.add(new Shelf(
                        rs.getString("item_code"), // ✅ Fixed column name
                        rs.getInt("quantity"),     // ✅ Fixed column name
                        rs.getDate("moved_date"),  // ✅ Fixed column name
                        rs.getDate("expiry_date")  // ✅ Fixed column name
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return shelves;
    }

    @Override
    public void addOrUpdateShelf(Shelf shelf) {
        try (PreparedStatement stmt = connection.prepareStatement(ADD_OR_UPDATE_SHELF_SQL)) {
            stmt.setString(1, shelf.getCode());
            stmt.setInt(2, shelf.getQuantity());
            stmt.setDate(3, shelf.getMovedDate());
            stmt.setDate(4, shelf.getExpiryDate());
            stmt.setInt(5, shelf.getQuantity());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ShelvesDAOException("Failed to add or update shelf", e);
        }
    }

    @Override
    public List<String> getAllItemCodes() {
        List<String> itemCodes = new ArrayList<>();
        try (PreparedStatement stmt = connection.prepareStatement(GET_ALL_ITEM_CODES_SQL);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                itemCodes.add(rs.getString("item_code")); // ✅ Fixed column name
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return itemCodes;
    }

    @Override
    public Shelf findShelfByItemCodeAndExpiryDate(String itemCode, Date expiryDate) {
        List<Shelf> shelves = queryShelves(FIND_SHELF_BY_ITEM_CODE_AND_EXPIRY_DATE_SQL, itemCode,
                expiryDate.toString());
        return shelves.isEmpty() ? null : shelves.get(0);
    }

    @Override
    public void updateShelf(Shelf shelf) {
        try (PreparedStatement stmt = connection.prepareStatement(UPDATE_SHELF_SQL)) {
            stmt.setInt(1, shelf.getQuantity());
            stmt.setDate(2, shelf.getMovedDate());
            stmt.setDate(3, shelf.getExpiryDate());
            stmt.setString(4, shelf.getCode());
            stmt.setDate(5, shelf.getExpiryDate());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ShelvesDAOException("Failed to update shelf", e);
        }
    }

    @Override
    public void addShelf(Shelf shelf) {
        if (shelf.getQuantity() > 0) {
            try (PreparedStatement stmt = connection.prepareStatement(ADD_SHELF_SQL)) {
                stmt.setString(1, shelf.getCode());
                stmt.setInt(2, shelf.getQuantity());
                stmt.setDate(3, shelf.getMovedDate());
                stmt.setDate(4, shelf.getExpiryDate());
                stmt.executeUpdate();
            } catch (SQLException e) {
                throw new ShelvesDAOException("Failed to add shelf", e);
            }
        }
    }

    @Override
    public void updateShelfQuantityAndRemoveIfZero(String itemCode, int quantitySold) {
        List<Shelf> shelves = findShelvesByItemCode(itemCode);
        shelves.sort(Comparator.comparing(Shelf::getExpiryDate)); // Sort by expiry date

        int totalAvailableQuantity = shelves.stream().mapToInt(Shelf::getQuantity).sum();

        // Debugging logs (optional)
        System.out.println("Total Available Stock for " + itemCode + ": " + totalAvailableQuantity);
        System.out.println("Quantity Sold for " + itemCode + ": " + quantitySold);

        if (quantitySold > totalAvailableQuantity) {
            throw new ShelvesDAOException("Quantity sold exceeds available stock for item: " + itemCode, null);
        }

        for (Shelf shelf : shelves) {
            if (quantitySold <= 0) {
                break;
            }

            int currentQuantity = shelf.getQuantity();
            if (currentQuantity <= quantitySold) {
                quantitySold -= currentQuantity;
                deleteShelf(shelf); // Delete shelf entry when quantity becomes zero
            } else {
                shelf.setQuantity(currentQuantity - quantitySold);
                updateShelf(shelf); // Update shelf entry with new quantity
                quantitySold = 0;
            }
        }
    }

    @Override
    public void deleteShelf(Shelf shelf) {
        try (PreparedStatement stmt = connection.prepareStatement(DELETE_SHELF_SQL)) {
            stmt.setString(1, shelf.getCode());
            stmt.setDate(2, shelf.getExpiryDate());
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ShelvesDAOException("Failed to delete shelf", e);
        }
    }

    @Override
    public List<Shelf> findExpiredShelves() {
        return queryShelves(FIND_EXPIRED_SHELVES_SQL);
    }

    @Override
    public void removeExpiredShelves(List<Shelf> expiredShelves) {
        try (PreparedStatement stmt = connection.prepareStatement(REMOVE_EXPIRED_SHELVES_SQL)) {
            for (Shelf shelf : expiredShelves) {
                stmt.setString(1, shelf.getCode());
                stmt.setDate(2, shelf.getExpiryDate());
                stmt.executeUpdate();
                System.out.println();
                System.out.println("Removed expired shelf: " + shelf.getCode() + ", Quantity: " + shelf.getQuantity());
            }
        } catch (SQLException e) {
            throw new ShelvesDAOException("Failed to remove expired shelves", e);
        }
    }

    private PreparedStatement createPreparedStatement(String sql, String... params) throws SQLException {
        PreparedStatement stmt = connection.prepareStatement(sql);
        for (int i = 0; i < params.length; i++) {
            stmt.setString(i + 1, params[i]);
        }
        return stmt;
    }

    public static class ShelvesDAOException extends RuntimeException {
        public ShelvesDAOException(String message, Throwable cause) {
            super(message, cause);
        }
    }
}
