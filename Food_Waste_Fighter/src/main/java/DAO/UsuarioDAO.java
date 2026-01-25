package DAO;

import entities.Inventario;
import entities.Usuario;
import entities.JPAUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;

/**
 * DAO for Usuario authentication and management operations.
 */
public class UsuarioDAO {

    private EntityManager em;

    public UsuarioDAO() {
        this.em = JPAUtil.getEntityManager();
    }

    /**
     * Registers a new user and creates their inventory.
     * @param usuario The user to register
     * @return The registered user with ID, or null if email already exists
     */
    public Usuario registrar(Usuario usuario) {
        try {
            // Check if email already exists
            if (buscarPorEmail(usuario.getEmail()) != null) {
                return null; // Email already registered
            }
            
            em.getTransaction().begin();
            
            // Persist the user
            em.persist(usuario);
            
            // Create inventory for the user
            Inventario inventario = new Inventario(usuario);
            em.persist(inventario);
            
            // Set bidirectional relationship
            usuario.setInventario(inventario);
            
            em.getTransaction().commit();
            return usuario;
            
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            e.printStackTrace();
            return null;
        }
    }

    /**
     * Authenticates a user by email and password.
     * @param email User's email
     * @param contrasena User's password
     * @return The authenticated user, or null if credentials are invalid
     */
    public Usuario autenticar(String email, String contrasena) {
        try {
            Usuario usuario = em.createQuery(
                    "SELECT u FROM Usuario u WHERE u.email = :email AND u.contrasena = :contrasena", 
                    Usuario.class)
                    .setParameter("email", email)
                    .setParameter("contrasena", contrasena)
                    .getSingleResult();
            return usuario;
        } catch (NoResultException e) {
            return null; // Invalid credentials
        }
    }

    /**
     * Finds a user by their email address.
     * @param email The email to search for
     * @return The user if found, null otherwise
     */
    public Usuario buscarPorEmail(String email) {
        try {
            return em.createQuery(
                    "SELECT u FROM Usuario u WHERE u.email = :email", 
                    Usuario.class)
                    .setParameter("email", email)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Finds a user by their ID.
     * @param idUsuario The user ID
     * @return The user if found, null otherwise
     */
    public Usuario buscarPorID(Long idUsuario) {
        return em.find(Usuario.class, idUsuario);
    }

    /**
     * Gets a user with their inventory loaded.
     * @param idUsuario The user ID
     * @return The user with inventory, or null if not found
     */
    public Usuario buscarConInventario(Long idUsuario) {
        try {
            return em.createQuery(
                    "SELECT u FROM Usuario u LEFT JOIN FETCH u.inventario WHERE u.idUsuario = :id", 
                    Usuario.class)
                    .setParameter("id", idUsuario)
                    .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }

    /**
     * Updates user information.
     * @param usuario The user to update
     */
    public void actualizar(Usuario usuario) {
        try {
            em.getTransaction().begin();
            em.merge(usuario);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    /**
     * Closes the EntityManager.
     */
    public void cerrar() {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
}
