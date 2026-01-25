package DAO;

import entities.*;
import jakarta.persistence.EntityManager;
import java.util.List;

/**
 * DAO para gestionar operaciones de la entidad Receta.
 */
public class RecetaDAO {

    private EntityManager em;

    /**
     * Constructor que obtiene el EntityManager desde JPAUtil
     */
    public RecetaDAO() {
        this.em = JPAUtil.getEntityManager();
    }

    /**
     * Obtiene todas las recetas disponibles.
     * Usado en CU Ver Recetas
     */
    public List<Receta> obtenerTodasLasRecetas() {
        return em.createQuery(
                "SELECT r FROM Receta r ORDER BY r.nombre", 
                Receta.class)
                .getResultList();
    }

    /**
     * Busca una receta por su ID con todos sus datos cargados (ingredientes, pasos, info nutricional).
     * Usado en CU Ver Detalle de Receta
     */
    public Receta obtenerRecetaCompleta(Long idReceta) {
        Receta receta = em.createQuery(
                "SELECT r FROM Receta r " +
                "LEFT JOIN FETCH r.ingredientes " +
                "LEFT JOIN FETCH r.pasos " +
                "LEFT JOIN FETCH r.informacionNutricional " +
                "WHERE r.idReceta = :id", 
                Receta.class)
                .setParameter("id", idReceta)
                .getSingleResult();
        
        return receta;
    }

    /**
     * Obtiene los ingredientes de una receta ordenados.
     */
    public List<Ingrediente> obtenerIngredientes(Long idReceta) {
        return em.createQuery(
                "SELECT i FROM Ingrediente i WHERE i.receta.idReceta = :id ORDER BY i.orden", 
                Ingrediente.class)
                .setParameter("id", idReceta)
                .getResultList();
    }

    /**
     * Obtiene los pasos de preparación de una receta ordenados.
     */
    public List<PasoPreparacion> obtenerPasos(Long idReceta) {
        return em.createQuery(
                "SELECT p FROM PasoPreparacion p WHERE p.receta.idReceta = :id ORDER BY p.numeroPaso", 
                PasoPreparacion.class)
                .setParameter("id", idReceta)
                .getResultList();
    }

    /**
     * Obtiene la información nutricional de una receta.
     */
    public InformacionNutricional obtenerInformacionNutricional(Long idReceta) {
        try {
            return em.createQuery(
                    "SELECT i FROM InformacionNutricional i WHERE i.receta.idReceta = :id", 
                    InformacionNutricional.class)
                    .setParameter("id", idReceta)
                    .getSingleResult();
        } catch (Exception e) {
            return null;
        }
    }

    /**
     * Busca una receta por su ID (sin cargar relaciones).
     */
    public Receta buscarPorID(Long idReceta) {
        return em.find(Receta.class, idReceta);
    }

    /**
     * Verifica si un ingrediente de la receta está disponible en el inventario del usuario.
     * Compara el nombre del ingrediente con los nombres de alimentos en el inventario (case-insensitive).
     */
    public boolean ingredienteDisponibleEnInventario(String nombreIngrediente, Long idInventario) {
        Long count = em.createQuery(
                "SELECT COUNT(a) FROM Alimento a " +
                "WHERE a.inventario.idInventario = :idInventario " +
                "AND LOWER(a.nombre) LIKE LOWER(CONCAT('%', :nombreIngrediente, '%'))", 
                Long.class)
                .setParameter("idInventario", idInventario)
                .setParameter("nombreIngrediente", nombreIngrediente)
                .getSingleResult();
        
        return count > 0;
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