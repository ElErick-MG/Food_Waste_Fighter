package DAO;

import entities.Categoria;
import entities.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;

/**
 * DAO para gestionar operaciones de la entidad Categoria.
 */
public class CategoriaDAO {

    private EntityManager em;

    /**
     * Constructor que obtiene el EntityManager desde JPAUtil
     */
    public CategoriaDAO() {
        this.em = JPAUtil.getEntityManager();
    }

    // Método usado en CU Registrar Alimento y Editar Alimento (diagramas de robustez 1 y 2)
    public List<Categoria> obtenerCategorias() {
        return em.createQuery("SELECT c FROM Categoria c", Categoria.class).getResultList();
    }

    /**
     * Cierra el EntityManager asociado a este DAO.
     * IMPORTANTE: Solo cierra el EntityManager, NO el EntityManagerFactory.
     */
    public void cerrar() {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
}