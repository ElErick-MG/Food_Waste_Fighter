package control;

import DAO.InventarioDAO;
import DAO.RecetaDAO;
import entities.Alimento;
import entities.Ingrediente;
import entities.Inventario;
import entities.Receta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

/**
 * Controller for Dashboard operations.
 * Handles: CU Ver Dashboard
 * - Shows 3 most critical alimentos about to expire
 * - Shows 2 suggested recipes based on ingredients about to expire
 * 
 * Optimización v2.0:
 * - Extiende BaseController para heredar doGet() y doPost()
 * - Implementa procesarPeticion() con la lógica específica
 */
@WebServlet(name = "DashboardController", urlPatterns = {"/DashboardController"})
public class DashboardController extends BaseController {

    @Override
    protected void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // DashboardController solo tiene una acción: mostrar
        mostrarDashboard(request, response);
    }

    /**
     * CU VER DASHBOARD
     * Paso 1: Usuario solicita verDashboard()
     * Paso 2: obtenerAlimentosProximosCaducar() - obtiene los 3 más críticos
     * Paso 3: obtenerRecetasSugeridas() - obtiene 2 recetas basadas en ingredientes próximos a caducar
     * Paso 4: mostrarDashboard(alimentos, recetas)
     */
    private void mostrarDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InventarioDAO inventarioDAO = null;
        RecetaDAO recetaDAO = null;
        
        try {
            HttpSession session = request.getSession();
            Inventario inventario = (Inventario) session.getAttribute("inventario");
            
            if (inventario == null) {
                response.sendRedirect("AuthController?accion=login");
                return;
            }

            inventarioDAO = new InventarioDAO();
            recetaDAO = new RecetaDAO();

            // Paso 2: obtenerAlimentosProximosCaducar() - Los 3 más críticos
            List<Alimento> alimentosProximos = obtenerTresAlimentosMasProximos(inventarioDAO, inventario);

            // Paso 3: obtenerRecetasSugeridas() - 2 recetas basadas en ingredientes próximos a caducar
            List<RecetaSugerida> recetasSugeridas = obtenerDosRecetasSugeridas(
                recetaDAO, 
                inventario, 
                alimentosProximos
            );

            // Paso 4: mostrarDashboard(alimentos, recetas)
            request.setAttribute("alimentosProximos", alimentosProximos);
            request.setAttribute("recetasSugeridas", recetasSugeridas);
            request.getRequestDispatcher("dashboard.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error showing dashboard: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AuthController?accion=login");
        } finally {
            if (inventarioDAO != null) inventarioDAO.cerrar();
            if (recetaDAO != null) recetaDAO.cerrar();
        }
    }

    /**
     * Obtiene los 3 alimentos más próximos a caducar del inventario.
     * Ordena todos los alimentos por fecha de caducidad y retorna los 3 primeros.
     */
    private List<Alimento> obtenerTresAlimentosMasProximos(InventarioDAO inventarioDAO, Inventario inventario) {
        List<Alimento> todosAlimentos = inventarioDAO.obtenerAlimentos(inventario);
        
        if (todosAlimentos.isEmpty()) {
            return new ArrayList<>();
        }

        // Ordenar por fecha de caducidad (más próxima primero)
        return todosAlimentos.stream()
                .sorted(Comparator.comparing(Alimento::getFechaCaducidad))
                .limit(3)
                .collect(Collectors.toList());
    }

    /**
     * Obtiene 2 recetas sugeridas basadas en los ingredientes que están próximos a caducar.
     * Algoritmo:
     * 1. Para cada receta, cuenta cuántos ingredientes próximos a caducar contiene
     * 2. Ordena las recetas por número de coincidencias (mayor a menor)
     * 3. Retorna las 2 primeras recetas con más coincidencias
     */
    private List<RecetaSugerida> obtenerDosRecetasSugeridas(
            RecetaDAO recetaDAO, 
            Inventario inventario, 
            List<Alimento> alimentosProximos) {
        
        List<RecetaSugerida> recetasSugeridas = new ArrayList<>();
        
        if (alimentosProximos.isEmpty()) {
            return recetasSugeridas;
        }

        // Obtener todas las recetas
        List<Receta> todasRecetas = recetaDAO.obtenerTodasLasRecetas();
        
        if (todasRecetas.isEmpty()) {
            return recetasSugeridas;
        }

        // Calcular puntuación de cada receta basada en ingredientes próximos a caducar
        Map<Receta, Integer> puntuacionRecetas = new HashMap<>();
        
        for (Receta receta : todasRecetas) {
            int coincidencias = 0;
            List<Ingrediente> ingredientes = recetaDAO.obtenerIngredientes(receta.getIdReceta());
            
            // Contar cuántos ingredientes de la receta están en los alimentos próximos a caducar
            for (Ingrediente ingrediente : ingredientes) {
                for (Alimento alimento : alimentosProximos) {
                    // Comparación case-insensitive y flexible
                    if (alimento.getNombre().toLowerCase().contains(ingrediente.getNombre().toLowerCase()) ||
                        ingrediente.getNombre().toLowerCase().contains(alimento.getNombre().toLowerCase())) {
                        coincidencias++;
                        break;
                    }
                }
            }
            
            if (coincidencias > 0) {
                puntuacionRecetas.put(receta, coincidencias);
            }
        }

        // Si no hay recetas con ingredientes próximos a caducar, tomar las 2 primeras recetas disponibles
        if (puntuacionRecetas.isEmpty()) {
            for (int i = 0; i < Math.min(2, todasRecetas.size()); i++) {
                Receta receta = todasRecetas.get(i);
                recetasSugeridas.add(new RecetaSugerida(receta, 0, new ArrayList<>()));
            }
            return recetasSugeridas;
        }

        // Ordenar recetas por puntuación (mayor a menor) y tomar las 2 primeras
        List<Map.Entry<Receta, Integer>> recetasOrdenadas = puntuacionRecetas.entrySet()
                .stream()
                .sorted(Map.Entry.<Receta, Integer>comparingByValue().reversed())
                .limit(2)
                .collect(Collectors.toList());

        // Crear objetos RecetaSugerida con la información de ingredientes coincidentes
        for (Map.Entry<Receta, Integer> entry : recetasOrdenadas) {
            Receta receta = entry.getKey();
            List<String> ingredientesCoincidentes = obtenerIngredientesCoincidentes(
                recetaDAO, 
                receta, 
                alimentosProximos
            );
            recetasSugeridas.add(new RecetaSugerida(
                receta, 
                entry.getValue(), 
                ingredientesCoincidentes
            ));
        }

        return recetasSugeridas;
    }

    /**
     * Obtiene la lista de nombres de ingredientes que coinciden con alimentos próximos a caducar.
     */
    private List<String> obtenerIngredientesCoincidentes(
            RecetaDAO recetaDAO, 
            Receta receta, 
            List<Alimento> alimentosProximos) {
        
        List<String> coincidentes = new ArrayList<>();
        List<Ingrediente> ingredientes = recetaDAO.obtenerIngredientes(receta.getIdReceta());
        
        for (Ingrediente ingrediente : ingredientes) {
            for (Alimento alimento : alimentosProximos) {
                if (alimento.getNombre().toLowerCase().contains(ingrediente.getNombre().toLowerCase()) ||
                    ingrediente.getNombre().toLowerCase().contains(alimento.getNombre().toLowerCase())) {
                    coincidentes.add(alimento.getNombre());
                    break;
                }
            }
        }
        
        return coincidentes;
    }

    /**
     * Calcula los días restantes hasta la fecha de caducidad.
     */
    private long calcularDiasRestantes(Date fechaActual, Date fechaCaducidad) {
        if (fechaCaducidad == null) {
            return Long.MAX_VALUE;
        }
        long diferencia = fechaCaducidad.getTime() - fechaActual.getTime();
        return TimeUnit.DAYS.convert(diferencia, TimeUnit.MILLISECONDS);
    }

    /**
     * Clase interna para representar una receta sugerida con información adicional.
     */
    public static class RecetaSugerida {
        private Receta receta;
        private int numeroIngredientesCoincidentes;
        private List<String> ingredientesCoincidentes;

        public RecetaSugerida(Receta receta, int numeroIngredientesCoincidentes, List<String> ingredientesCoincidentes) {
            this.receta = receta;
            this.numeroIngredientesCoincidentes = numeroIngredientesCoincidentes;
            this.ingredientesCoincidentes = ingredientesCoincidentes;
        }

        public Receta getReceta() {
            return receta;
        }

        public int getNumeroIngredientesCoincidentes() {
            return numeroIngredientesCoincidentes;
        }

        public List<String> getIngredientesCoincidentes() {
            return ingredientesCoincidentes;
        }

        public String getIngredientesCoincidentesTexto() {
            if (ingredientesCoincidentes.isEmpty()) {
                return "";
            }
            return String.join(", ", ingredientesCoincidentes);
        }
    }
}