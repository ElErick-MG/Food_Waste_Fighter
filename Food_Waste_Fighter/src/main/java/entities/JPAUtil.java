package entities;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

/**
 * Utility class for JPA EntityManager management.
 */
public class JPAUtil {
    
    private static EntityManagerFactory emf = null;
    
    static {
        try {
            emf = Persistence.createEntityManagerFactory("InventarioPU");
        } catch (Exception e) {
            System.err.println("Error initializing EntityManagerFactory: " + e.getMessage());
            e.printStackTrace();
        }
    }

    /**
     * Gets a new EntityManager instance.
     * @return EntityManager
     */
    public static EntityManager getEntityManager() {
        if (emf == null) {
            throw new IllegalStateException("EntityManagerFactory not initialized. Check database connection.");
        }
        return emf.createEntityManager();
    }

    /**
     * Closes the EntityManagerFactory.
     * Should be called when the application shuts down.
     */
    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
    
    /**
     * Checks if the EntityManagerFactory is available.
     * @return true if EMF is initialized and open
     */
    public static boolean isAvailable() {
        return emf != null && emf.isOpen();
    }
}
