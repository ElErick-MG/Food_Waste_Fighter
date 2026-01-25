package rest;

import DAO.InventarioDAO;
import DAO.UsuarioDAO;
import entities.Alimento;
import entities.Inventario;
import entities.Usuario;
import rest.DTO.AlimentoDTO;
import rest.DTO.ApiResponse;
import rest.DTO.CaducidadAlertaDTO;
import rest.DTO.InventarioDTO;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * REST Resource for Inventario operations.
 * 
 * Endpoints:
 * - GET /api/inventario            - Get inventory with all alimentos
 * - GET /api/inventario/caducidad  - Get alimentos grouped by expiration urgency
 */
@Path("/inventario")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class InventarioResource {

    // API User email (fixed user for REST API)
    private static final String API_USER_EMAIL = "api@foodwastefighter.com";

    /**
     * GET /api/inventario
     * Gets the API user's inventory with all alimentos.
     */
    @GET
    public Response obtenerInventario() {
        InventarioDAO inventarioDAO = null;
        UsuarioDAO usuarioDAO = null;
        
        try {
            // Get API user
            usuarioDAO = new UsuarioDAO();
            Usuario apiUser = usuarioDAO.buscarPorEmail(API_USER_EMAIL);
            
            if (apiUser == null) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(ApiResponse.error("Usuario API no encontrado"))
                        .build();
            }
            
            Inventario inventario = apiUser.getInventario();
            if (inventario == null) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(ApiResponse.error("Inventario API no encontrado"))
                        .build();
            }
            
            // Get alimentos
            inventarioDAO = new InventarioDAO();
            List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
            
            List<AlimentoDTO> alimentosDTO = alimentos.stream()
                    .map(AlimentoDTO::fromEntity)
                    .collect(Collectors.toList());
            
            InventarioDTO dto = InventarioDTO.fromEntity(inventario, alimentosDTO);
            
            return Response.ok(ApiResponse.success(dto, "Inventario obtenido correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error getting inventario: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al obtener inventario: " + e.getMessage()))
                    .build();
        } finally {
            if (inventarioDAO != null) inventarioDAO.cerrar();
            if (usuarioDAO != null) usuarioDAO.cerrar();
        }
    }

    /**
     * GET /api/inventario/caducidad
     * Gets alimentos grouped by expiration urgency:
     * - Críticos: 1-2 days (red)
     * - Advertencia: 3-5 days (yellow)
     * - Normales: 6+ days (gray)
     */
    @GET
    @Path("/caducidad")
    public Response obtenerAlertasCaducidad() {
        InventarioDAO inventarioDAO = null;
        
        try {
            Inventario inventario = obtenerInventarioAPI();
            if (inventario == null) {
                return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                        .entity(ApiResponse.error("No se pudo obtener el inventario del API"))
                        .build();
            }
            
            // Get alimentos
            inventarioDAO = new InventarioDAO();
            List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
            
            // Classify by expiration
            List<AlimentoDTO> criticos = new ArrayList<>();
            List<AlimentoDTO> advertencia = new ArrayList<>();
            List<AlimentoDTO> normales = new ArrayList<>();
            
            Date fechaActual = new Date();
            
            for (Alimento alimento : alimentos) {
                long diasRestantes = calcularDiasRestantes(fechaActual, alimento.getFechaCaducidad());
                AlimentoDTO dto = AlimentoDTO.fromEntity(alimento);
                
                if (diasRestantes <= 2) {
                    criticos.add(dto);
                } else if (diasRestantes <= 5) {
                    advertencia.add(dto);
                } else {
                    normales.add(dto);
                }
            }
            
            CaducidadAlertaDTO alertas = new CaducidadAlertaDTO(criticos, advertencia, normales);
            
            return Response.ok(ApiResponse.success(alertas, "Alertas de caducidad obtenidas correctamente"))
                    .build();
                    
        } catch (Exception e) {
            System.err.println("Error getting caducidad alerts: " + e.getMessage());
            e.printStackTrace();
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity(ApiResponse.error("Error al obtener alertas de caducidad: " + e.getMessage()))
                    .build();
        } finally {
            if (inventarioDAO != null) inventarioDAO.cerrar();
        }
    }

    /**
     * Calculates days remaining until expiration.
     */
    private long calcularDiasRestantes(Date fechaActual, Date fechaCaducidad) {
        if (fechaCaducidad == null) {
            return Long.MAX_VALUE;
        }
        long diferencia = fechaCaducidad.getTime() - fechaActual.getTime();
        return TimeUnit.DAYS.convert(diferencia, TimeUnit.MILLISECONDS);
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