package DAO;

import entities.Alimento;
import entities.JPAUtil;
import jakarta.persistence.EntityManager;

/**
 * DAO para gestionar operaciones CRUD de la entidad Alimento.
 */
public class AlimentoDAO {

    private EntityManager em;

    /**
     * Constructor que obtiene el EntityManager desde JPAUtil
     */
    public AlimentoDAO() {
        this.em = JPAUtil.getEntityManager();
    }

    // Método usado en CU Registrar Alimento (diagrama de robustez 1)
    public void crear(Alimento alimento) {
        try {
            em.getTransaction().begin();
            em.persist(alimento);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    // Método usado en CU Editar Alimento (diagrama de robustez 2)
    public Alimento buscarPorID(Long idAlimento) {
        return em.find(Alimento.class, idAlimento);
    }

    // Método usado en CU Editar Alimento (diagrama de robustez 2)
    public void actualizar(Alimento alimento) {
        try {
            em.getTransaction().begin();
            em.merge(alimento);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    // Método usado en CU Eliminar Alimento (diagrama de robustez 3)
    public void eliminar(Alimento alimento) {
        try {
            em.getTransaction().begin();
            if (!em.contains(alimento)) {
                alimento = em.merge(alimento);
            }
            em.remove(alimento);
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
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