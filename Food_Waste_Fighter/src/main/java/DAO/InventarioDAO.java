package DAO;

import entities.Alimento;
import entities.Inventario;
import entities.JPAUtil;
import jakarta.persistence.EntityManager;
import rest.DTO.AlimentoDTO;
import java.util.List;
import java.util.stream.Collectors;

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

    /**
     * Agrega un alimento al inventario.
     * Usado en CU Registrar Alimento
     */
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

    /**
     * Quita un alimento del inventario.
     * Usado en CU Eliminar Alimento
     */
    public void quitar(Alimento alimento) {
        try {
            em.getTransaction().begin();

            Inventario inventario = alimento.getInventario();
            if (inventario != null) {
                if (!em.contains(inventario)) {
                    inventario = em.merge(inventario);
                }
                inventario.getAlimentos().remove(alimento);
            }

            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw e;
        }
    }

    /**
     * Obtiene todos los alimentos de un inventario.
     * Usado en todos los CU
     */
    public List<Alimento> obtenerAlimentos(Inventario inventario) {
        return em.createQuery(
                "SELECT a FROM Alimento a WHERE a.inventario.idInventario = :idInventario ORDER BY a.fechaCaducidad",
                Alimento.class)
                .setParameter("idInventario", inventario.getIdInventario())
                .getResultList();
    }

    /**
     * Obtiene todos los alimentos de un inventario por ID.
     * Sobrecarga del método (polimorfismo) - Versión optimizada.
     */
    public List<Alimento> obtenerAlimentos(Long idInventario) {
        return em.createQuery(
                "SELECT a FROM Alimento a WHERE a.inventario.idInventario = :idInventario ORDER BY a.fechaCaducidad",
                Alimento.class)
                .setParameter("idInventario", idInventario)
                .getResultList();
    }

    /**
     * Obtiene todos los alimentos de un inventario como DTOs (objetos ligeros).
     * Sobrecarga del método (polimorfismo) - Devuelve AlimentoDTO para optimizar memoria.
     * Usado cuando solo necesitamos datos de transferencia, no entidades JPA completas.
     */
    public List<AlimentoDTO> obtenerAlimentosDTO(Long idInventario) {
        List<Alimento> alimentos = obtenerAlimentos(idInventario);
        return alimentos.stream()
                .map(AlimentoDTO::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * Busca un inventario por su ID.
     */
    public Inventario buscarPorID(Long idInventario) {
        return em.find(Inventario.class, idInventario);
    }

    /**
     * Obtiene o crea el inventario demo (ID=1).
     */
    public Inventario obtenerInventarioDemo() {
        Inventario inventario = em.find(Inventario.class, 1L);
        if (inventario == null) {
            // Create demo inventory if it doesn't exist
            try {
                em.getTransaction().begin();
                inventario = new Inventario();
                em.persist(inventario);
                em.getTransaction().commit();
            } catch (Exception e) {
                if (em.getTransaction().isActive()) {
                    em.getTransaction().rollback();
                }
                throw e;
            }
        }
        return inventario;
    }

    /**
     * Refresca el EntityManager
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
