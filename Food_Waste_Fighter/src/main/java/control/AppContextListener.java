package control;

import entities.JPAUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

/**
 * Application lifecycle listener.
 * Closes JPA EntityManagerFactory when the application shuts down.
 */
@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Food Waste Fighter - Application starting...");
        
        // Test database connection
        try {
            if (JPAUtil.isAvailable()) {
                System.out.println("Database connection established successfully.");
            } else {
                System.err.println("WARNING: Database connection not available.");
            }
        } catch (Exception e) {
            System.err.println("ERROR: Failed to connect to database: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Food Waste Fighter - Application shutting down...");
        
        try {
            JPAUtil.close();
            System.out.println("JPA EntityManagerFactory closed.");
        } catch (Exception e) {
            System.err.println("Error closing EntityManagerFactory: " + e.getMessage());
        }
    }
}
