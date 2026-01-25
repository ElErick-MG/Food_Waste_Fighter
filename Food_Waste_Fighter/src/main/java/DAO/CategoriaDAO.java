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

    /**
     * Obtiene todas las categorías disponibles.
     * Usado en CU Registrar Alimento y Editar Alimento
     */
    public List<Categoria> obtenerCategorias() {
        return em.createQuery("SELECT c FROM Categoria c ORDER BY c.nombre", Categoria.class)
                .getResultList();
    }
    
    /**
     * Busca una categoría por su ID.
     */
    public Categoria buscarPorID(Long idCategoria) {
        return em.find(Categoria.class, idCategoria);
    }

    /**
     * Cierra el EntityManager asociado a este DAO.
     */
    public void cerrar() {
        if (em != null && em.isOpen()) {
            em.close();
        }
    }
}
