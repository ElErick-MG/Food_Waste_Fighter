package rest;

import DAO.CategoriaDAO;
import entities.Categoria;
import rest.DTO.ApiResponse;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

/**
 * REST Resource for Categoria operations.
 * 
 * Endpoints:
 * - GET /api/categorias       - List all categories
 * - GET /api/categorias/{id}  - Get category by ID
 */
@Path("/categorias")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CategoriaResource {

    /**
     * Simple DTO for Categoria.
     */
    public static class CategoriaDTO {
        private Long id;
        private String nombre;

        public CategoriaDTO() {}

        public CategoriaDTO(Long id, String nombre) {
            this.id = id;
            this.nombre = nombre;
        }

        public static CategoriaDTO fromEntity(Categoria categoria) {
            if (categoria == null) return null;
            return new CategoriaDTO(categoria.getIdCategoria(), categoria.getNombre());
        }

        public Long getId() { return id; }
        public void setId(Long id) { this.id = id; }
        public String getNombre() { return nombre; }
        public void setNombre(String nombre) { this.nombre = nombre; }
    }

    /**
     * GET /api/categorias
     * Lists all available categories.
     */
    @GET
    public Response listarCategorias() {
        CategoriaDAO categoriaDAO = null;
        
        try {
            categoriaDAO = new CategoriaDAO();
            List<Categoria> categorias = categoriaDAO.obtenerCategorias();
            
            List<CategoriaDTO> categoriasDTO = categorias.stream()
                    .map(CategoriaDTO::fromEntity)
                    .collect(Collectors.toList());
            
            return Response.ok(ApiResponse.success(categoriasDTO, "Categorías obtenidas correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error listing categorias: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al obtener categorías: " + e.getMessage()))
                    .build();
        } finally {
            if (categoriaDAO != null) {
                categoriaDAO.cerrar();
            }
        }
    }

    /**
     * GET /api/categorias/{id}
     * Gets a specific category by ID.
     */
    @GET
    @Path("/{id}")
    public Response obtenerCategoria(@PathParam("id") Long id) {
        CategoriaDAO categoriaDAO = null;
        
        try {
            categoriaDAO = new CategoriaDAO();
            Categoria categoria = categoriaDAO.buscarPorID(id);
            
            if (categoria == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(ApiResponse.error("Categoría no encontrada con ID: " + id))
                        .build();
            }
            
            CategoriaDTO dto = CategoriaDTO.fromEntity(categoria);
            return Response.ok(ApiResponse.success(dto, "Categoría obtenida correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error getting categoria: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al obtener categoría: " + e.getMessage()))
                    .build();
        } finally {
            if (categoriaDAO != null) {
                categoriaDAO.cerrar();
            }
        }
    }
}