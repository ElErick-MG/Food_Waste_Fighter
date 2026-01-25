package control;

import DAO.RecetaDAO;
import entities.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller for Receta operations.
 * Handles: Ver Recetas and Ver Detalle de Receta use cases.
 * 
 * Optimización v2.0:
 * - Extiende BaseController para heredar doGet() y doPost()
 * - Implementa procesarPeticion() con la lógica específica
 * - Código más limpio y mantenible
 */
@WebServlet(name = "RecetaController", urlPatterns = {"/RecetaController"})
public class RecetaController extends BaseController {

    /**
     * Procesa todas las peticiones HTTP (GET y POST).
     * Los métodos doGet() y doPost() son heredados de BaseController.
     * 
     * @param request  HttpServletRequest con los datos de la petición
     * @param response HttpServletResponse para enviar la respuesta
     */
    @Override
    protected void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Obtener acción usando método utilitario de la clase base
        String accion = obtenerAccion(request, "listar");

        // Rutear a los métodos correspondientes según la acción
        switch (accion) {
            case "detalle":
                verReceta(request, response);
                break;
            case "listar":
            default:
                listarRecetas(request, response);
                break;
        }
    }

    /**
     * CU VER RECETAS
     * Paso 1: Usuario solicita verRecetas()
     * Paso 2: obtenerRecetas()
     * Paso 3: mostrarRecetas(recetas)
     */
    private void listarRecetas(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RecetaDAO recetaDAO = null;
        
        try {
            // Paso 2: obtenerRecetas()
            recetaDAO = new RecetaDAO();
            List<Receta> recetas = recetaDAO.obtenerTodasLasRecetas();
            
            // Paso 3: mostrarRecetas(recetas)
            request.setAttribute("recetas", recetas);
            request.getRequestDispatcher("recetas.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error listing recetas: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/DashboardController?accion=mostrar&error=recetas");
        } finally {
            if (recetaDAO != null) {
                recetaDAO.cerrar();
            }
        }
    }

    /**
     * CU VER DETALLE DE RECETA
     * Paso 1: Usuario solicita verDetalleReceta()
     * Paso 2: obtenerRecetaCompleta()
     * Paso 3: obtenerListaIngredientes()
     * Paso 4: obtenerPasosPreparacion()
     * Paso 5: obtenerValoresNutricionales()
     * Paso 6: mostrarDetalleReceta()
     * 
     * Optimización: Solo usa idInventario de la sesión, no el objeto completo.
     * Esto evita cargar todos los alimentos en memoria de sesión.
     */
    private void verReceta(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RecetaDAO recetaDAO = null;
        
        try {
            Long idReceta = Long.parseLong(request.getParameter("id"));
            HttpSession session = request.getSession();
            
            // Optimización: Obtener solo el ID del inventario, no el objeto completo
            // Esto evita tener miles de alimentos cargados en memoria de sesión
            Long idInventario = null;
            Inventario inventarioSesion = (Inventario) session.getAttribute("inventario");
            if (inventarioSesion != null) {
                idInventario = inventarioSesion.getIdInventario();
            }
            
            // Si no hay inventario en sesión, redirigir a login
            if (idInventario == null) {
                response.sendRedirect(request.getContextPath() + "/AuthController?accion=login");
                return;
            }
            
            recetaDAO = new RecetaDAO();
            
            // Paso 2: obtenerRecetaCompleta()
            Receta receta = recetaDAO.obtenerRecetaCompleta(idReceta);
            
            if (receta == null) {
                response.sendRedirect(request.getContextPath() + "/RecetaController?accion=listar&error=not_found");
                return;
            }
            
            // Paso 3: obtenerListaIngredientes()
            List<Ingrediente> ingredientes = receta.getIngredientes();
            
            // Crear un mapa para indicar qué ingredientes están disponibles en el inventario
            // Consulta a la BD usando solo el ID, no carga todos los alimentos en memoria
            Map<Long, Boolean> ingredientesDisponibles = new HashMap<>();
            for (Ingrediente ingrediente : ingredientes) {
                boolean disponible = recetaDAO.ingredienteDisponibleEnInventario(
                    ingrediente.getNombre(), 
                    idInventario
                );
                ingredientesDisponibles.put(ingrediente.getIdIngrediente(), disponible);
            }
            
            // Paso 4: obtenerPasosPreparacion()
            List<PasoPreparacion> pasos = receta.getPasos();
            
            // Paso 5: obtenerValoresNutricionales()
            InformacionNutricional infoNutricional = receta.getInformacionNutricional();
            
            // Paso 6: mostrarDetalleReceta()
            request.setAttribute("receta", receta);
            request.setAttribute("ingredientes", ingredientes);
            request.setAttribute("ingredientesDisponibles", ingredientesDisponibles);
            request.setAttribute("pasos", pasos);
            request.setAttribute("infoNutricional", infoNutricional);
            
            request.getRequestDispatcher("detalleReceta.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            System.err.println("Invalid recipe ID format: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/RecetaController?accion=listar&error=invalid_id");
        } catch (Exception e) {
            System.err.println("Error viewing recipe detail: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/RecetaController?accion=listar&error=detail");
        } finally {
            if (recetaDAO != null) {
                recetaDAO.cerrar();
            }
        }
    }
}