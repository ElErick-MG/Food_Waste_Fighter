package DAO;

import entities.Categoria;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import java.util.List;

public class CategoriaDAO {

    private EntityManagerFactory emf;
    private EntityManager em;

    public CategoriaDAO() {
        emf = Persistence.createEntityManagerFactory("InventarioPU");
        em = emf.createEntityManager();
    }

    // Método usado en CU Registrar Alimento y Editar Alimento (diagramas de robustez 1 y 2)
    public List<Categoria> obtenerCategorias() {
        return em.createQuery("SELECT c FROM Categoria c", Categoria.class).getResultList();
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
