package DAO;

import entities.Alimento;
import entities.Inventario;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class InventarioDAO {

    private EntityManagerFactory emf;
    private EntityManager em;

    public InventarioDAO() {
        emf = Persistence.createEntityManagerFactory("InventarioPU");
        em = emf.createEntityManager();
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

    public void cerrar() {
        if (em != null && em.isOpen()) {
            em.close();
        }
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
