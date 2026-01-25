package rest;

import DAO.AlimentoDAO;
import DAO.CategoriaDAO;
import DAO.InventarioDAO;
import DAO.UsuarioDAO;
import entities.Alimento;
import entities.Categoria;
import entities.Inventario;
import entities.Usuario;
import rest.DTO.AlimentoDTO;
import rest.DTO.ApiResponse;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.List;
import java.util.stream.Collectors;

/**
 * REST Resource for Alimento CRUD operations.
 * 
 * Endpoints:
 * - GET    /api/alimentos          - List all alimentos
 * - GET    /api/alimentos/{id}     - Get alimento by ID
 * - POST   /api/alimentos          - Create new alimento
 * - PUT    /api/alimentos/{id}     - Update alimento
 * - DELETE /api/alimentos/{id}     - Delete alimento
 */
@Path("/alimentos")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class AlimentoResource {

    // API User email (fixed user for REST API)
    private static final String API_USER_EMAIL = "api@foodwastefighter.com";

    /**
     * GET /api/alimentos
     * Lists all alimentos in the API user's inventory.
     */
    @GET
    public Response listarAlimentos() {
        InventarioDAO inventarioDAO = null;
        
        try {
            Inventario inventario = obtenerInventarioAPI();
            if (inventario == null) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(ApiResponse.error("No se pudo obtener el inventario del API"))
                        .build();
            }
            
            inventarioDAO = new InventarioDAO();
            List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
            
            List<AlimentoDTO> alimentosDTO = alimentos.stream()
                    .map(AlimentoDTO::fromEntity)
                    .collect(Collectors.toList());
            
            return Response.ok(ApiResponse.success(alimentosDTO, "Alimentos obtenidos correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error listing alimentos: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al obtener alimentos: " + e.getMessage()))
                    .build();
        } finally {
            if (inventarioDAO != null) {
                inventarioDAO.cerrar();
            }
        }
    }

    /**
     * GET /api/alimentos/{id}
     * Gets a specific alimento by ID.
     */
    @GET
    @Path("/{id}")
    public Response obtenerAlimento(@PathParam("id") Long id) {
        AlimentoDAO alimentoDAO = null;
        
        try {
            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(id);
            
            if (alimento == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(ApiResponse.error("Alimento no encontrado con ID: " + id))
                        .build();
            }
            
            // Verify the alimento belongs to API inventory
            Inventario inventarioAPI = obtenerInventarioAPI();
            if (inventarioAPI == null || !alimento.getInventario().getIdInventario().equals(inventarioAPI.getIdInventario())) {
                return Response.status(Response.Status.FORBIDDEN)
                        .entity(ApiResponse.error("No tiene acceso a este alimento"))
                        .build();
            }
            
            AlimentoDTO dto = AlimentoDTO.fromEntity(alimento);
            return Response.ok(ApiResponse.success(dto, "Alimento obtenido correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error getting alimento: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al obtener alimento: " + e.getMessage()))
                    .build();
        } finally {
            if (alimentoDAO != null) {
                alimentoDAO.cerrar();
            }
        }
    }

    /**
     * POST /api/alimentos
     * Creates a new alimento.
     * 
     * Request body:
     * {
     *   "nombre": "Leche",
     *   "idCategoria": 3,
     *   "fechaCaducidad": "2025-02-15",
     *   "cantidad": "2 litros"
     * }
     */
    @POST
    public Response crearAlimento(AlimentoDTO dto) {
        AlimentoDAO alimentoDAO = null;
        CategoriaDAO categoriaDAO = null;
        
        try {
            // Get API inventory
            Inventario inventario = obtenerInventarioAPI();
            if (inventario == null) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(ApiResponse.error("No se pudo obtener el inventario del API"))
                        .build();
            }
            
            // Get category
            categoriaDAO = new CategoriaDAO();
            Categoria categoria = categoriaDAO.buscarPorID(dto.getIdCategoria());
            if (categoria == null) {
                return Response.status(Response.Status.BAD_REQUEST)
                        .entity(ApiResponse.error("Categoría no encontrada con ID: " + dto.getIdCategoria()))
                        .build();
            }
            
            // Create alimento
            Alimento alimento = new Alimento(
                    dto.getNombre(),
                    categoria,
                    dto.getFechaCaducidad(),
                    dto.getCantidad(),
                    inventario
            );
            
            alimentoDAO = new AlimentoDAO();
            alimentoDAO.crear(alimento);
            
            AlimentoDTO responseDTO = AlimentoDTO.fromEntity(alimento);
            return Response.status(Response.Status.CREATED)
                    .entity(ApiResponse.success(responseDTO, "Alimento creado correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error creating alimento: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al crear alimento: " + e.getMessage()))
                    .build();
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (categoriaDAO != null) categoriaDAO.cerrar();
        }
    }

    /**
     * PUT /api/alimentos/{id}
     * Updates an existing alimento.
     * 
     * Request body:
     * {
     *   "nombre": "Leche Deslactosada",
     *   "idCategoria": 3,
     *   "fechaCaducidad": "2025-02-20",
     *   "cantidad": "1 litro"
     * }
     */
    @PUT
    @Path("/{id}")
    public Response actualizarAlimento(@PathParam("id") Long id, AlimentoDTO dto) {
        AlimentoDAO alimentoDAO = null;
        CategoriaDAO categoriaDAO = null;
        
        try {
            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(id);
            
            if (alimento == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(ApiResponse.error("Alimento no encontrado con ID: " + id))
                        .build();
            }
            
            // Verify the alimento belongs to API inventory
            Inventario inventarioAPI = obtenerInventarioAPI();
            if (inventarioAPI == null || !alimento.getInventario().getIdInventario().equals(inventarioAPI.getIdInventario())) {
                return Response.status(Response.Status.FORBIDDEN)
                        .entity(ApiResponse.error("No tiene acceso a este alimento"))
                        .build();
            }
            
            // Update category if provided
            if (dto.getIdCategoria() != null) {
                categoriaDAO = new CategoriaDAO();
                Categoria categoria = categoriaDAO.buscarPorID(dto.getIdCategoria());
                if (categoria == null) {
                    return Response.status(Response.Status.BAD_REQUEST)
                            .entity(ApiResponse.error("Categoría no encontrada con ID: " + dto.getIdCategoria()))
                            .build();
                }
                alimento.setCategoria(categoria);
            }
            
            // Update fields
            if (dto.getNombre() != null) {
                alimento.setNombre(dto.getNombre());
            }
            if (dto.getFechaCaducidad() != null) {
                alimento.setFechaCaducidad(dto.getFechaCaducidad());
            }
            if (dto.getCantidad() != null) {
                alimento.setCantidad(dto.getCantidad());
            }
            
            alimentoDAO.actualizar(alimento);
            
            AlimentoDTO responseDTO = AlimentoDTO.fromEntity(alimento);
            return Response.ok(ApiResponse.success(responseDTO, "Alimento actualizado correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error updating alimento: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al actualizar alimento: " + e.getMessage()))
                    .build();
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (categoriaDAO != null) categoriaDAO.cerrar();
        }
    }

    /**
     * DELETE /api/alimentos/{id}
     * Deletes an alimento.
     */
    @DELETE
    @Path("/{id}")
    public Response eliminarAlimento(@PathParam("id") Long id) {
        AlimentoDAO alimentoDAO = null;
        InventarioDAO inventarioDAO = null;
        
        try {
            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(id);
            
            if (alimento == null) {
                return Response.status(Response.Status.NOT_FOUND)
                        .entity(ApiResponse.error("Alimento no encontrado con ID: " + id))
                        .build();
            }
            
            // Verify the alimento belongs to API inventory
            Inventario inventarioAPI = obtenerInventarioAPI();
            if (inventarioAPI == null || !alimento.getInventario().getIdInventario().equals(inventarioAPI.getIdInventario())) {
                return Response.status(Response.Status.FORBIDDEN)
                        .entity(ApiResponse.error("No tiene acceso a este alimento"))
                        .build();
            }
            
            // Remove from inventory and delete
            inventarioDAO = new InventarioDAO();
            inventarioDAO.quitar(alimento);
            alimentoDAO.eliminar(alimento);
            
            return Response.ok(ApiResponse.success(null, "Alimento eliminado correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error deleting alimento: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al eliminar alimento: " + e.getMessage()))
                    .build();
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (inventarioDAO != null) inventarioDAO.cerrar();
        }
    }

    /**
     * Gets the API user's inventory.
     */
    private Inventario obtenerInventarioAPI() {
        UsuarioDAO usuarioDAO = null;
        
        try {
            usuarioDAO = new UsuarioDAO();
            Usuario apiUser = usuarioDAO.buscarPorEmail(API_USER_EMAIL);
            
            if (apiUser != null) {
                return apiUser.getInventario();
            }
            
            return null;
        } finally {
            if (usuarioDAO != null) {
                usuarioDAO.cerrar();
            }
        }
    }
}