package DAO;

import entities.Alimento;
import entities.Inventario;
import entities.JPAUtil;
import jakarta.persistence.EntityManager;
import java.util.List;

/**
 * DAO para gestionar operaciones de la entidad Inventario.
 */
public class InventarioDAO {

    private EntityManager em;

    /**
     * Constructor que obtiene el EntityManager desde JPAUtil
     */
    public InventarioDAO() {
        this.em = JPAUtil.getEntityManager();
    }

    // Método usado en CU Registrar Alimento (diagrama de robustez 1)
    public void agregar(Alimento alimento) {
        try {
            em.getTransaction().begin();
            Inventario inventario = alimento.getInventario();
            if (!em.contains(inventario)) {
                inventario = em.merge(inventario);
            }
            inventario.getAlimentos().add(alimento);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    // Método usado en CU Registrar, Editar, Eliminar Alimento y Consultar Fechas de Caducidad
    // (diagramas de robustez 1, 2, 3 y 4)
    public List<Alimento> obtenerAlimentos(Inventario inventario) {
        return em.createQuery(
                "SELECT a FROM Alimento a WHERE a.inventario = :inventario", Alimento.class)
                .setParameter("inventario", inventario)
                .getResultList();
    }

    public Inventario buscarPorID(Long idInventario) {
        return em.find(Inventario.class, idInventario);
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