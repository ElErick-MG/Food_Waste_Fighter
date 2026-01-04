package DAO;

import entities.Alimento;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;

public class AlimentoDAO {

    private EntityManagerFactory emf;
    private EntityManager em;

    public AlimentoDAO() {
        emf = Persistence.createEntityManagerFactory("InventarioPU");
        em = emf.createEntityManager();
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

    public void cerrar() {
        if (em != null && em.isOpen()) {
            em.close();
        }
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
