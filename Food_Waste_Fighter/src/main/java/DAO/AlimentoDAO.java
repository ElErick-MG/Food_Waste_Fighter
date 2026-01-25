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

    /**
     * Crea un nuevo alimento en la base de datos.
     * Usado en CU Registrar Alimento
     */
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

    /**
     * Busca un alimento por su ID.
     * Usado en CU Editar Alimento y Eliminar Alimento
     */
    public Alimento buscarPorID(Long idAlimento) {
        return em.find(Alimento.class, idAlimento);
    }

    /**
     * Actualiza un alimento existente.
     * Usado en CU Editar Alimento
     */
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

    /**
     * Elimina un alimento de la base de datos.
     * Usado en CU Eliminar Alimento
     */
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
     * Refresca el EntityManager para obtener datos actualizados
     */
    public void refrescar() {
        if (em != null && em.isOpen()) {
            em.clear();
        }
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
