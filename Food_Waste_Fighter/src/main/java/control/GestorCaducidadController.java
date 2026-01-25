package control;

import DAO.InventarioDAO;
import entities.Alimento;
import entities.Inventario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.TimeUnit;

/**
 * Controller for managing expiration date alerts.
 * Handles: CU Consultar Fechas de Caducidad (Vista "Por Caducar")
 * 
 * Optimización v2.0:
 * - Extiende BaseController para heredar doGet() y doPost()
 * - Implementa procesarPeticion() con la lógica específica
 */
@WebServlet(name = "GestorCaducidadController", urlPatterns = {"/GestorCaducidadController"})
public class GestorCaducidadController extends BaseController {

    @Override
    protected void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // GestorCaducidadController solo tiene una acción: consultar
        consultarFechasCaducidad(request, response);
    }

    /**
     * CU CONSULTAR FECHAS DE CADUCIDAD
     * Paso 1: Usuario solicita consultar()
     * Paso 2: obtenerAlimentos()
     * Paso 3: verificarFechasCaducidad(alimentos)
     * Paso 4: mostrar(alimentos) en ProductosACaducar
     * 
     * Esta vista muestra TODOS los alimentos clasificados por nivel de urgencia:
     * - Críticos (Rojos): 1-2 días
     * - Advertencia (Amarillos): 3-5 días
     * - Normales (Grises): 6+ días
     */
    private void consultarFechasCaducidad(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        InventarioDAO inventarioDAO = null;
        
        try {
            HttpSession session = request.getSession();
            Inventario inventario = (Inventario) session.getAttribute("inventario");
            
            if (inventario == null) {
                response.sendRedirect("AuthController?accion=login");
                return;
            }

            // Paso 2: obtenerAlimentos()
            inventarioDAO = new InventarioDAO();
            List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);

            // Paso 3: verificarFechasCaducidad(alimentos)
            List<Alimento> alimentosRojos = new ArrayList<>();
            List<Alimento> alimentosAmarillos = new ArrayList<>();
            List<Alimento> alimentosGrises = new ArrayList<>();

            verificarFechasCaducidad(alimentos, alimentosRojos, alimentosAmarillos, alimentosGrises);

            request.setAttribute("alimentosRojos", alimentosRojos);
            request.setAttribute("alimentosAmarillos", alimentosAmarillos);
            request.setAttribute("alimentosGrises", alimentosGrises);

            // Paso 4: mostrar(alimentos)
            request.getRequestDispatcher("productosACaducar.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error consulting expiration dates: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("DashboardController?accion=mostrar");
        } finally {
            if (inventarioDAO != null) inventarioDAO.cerrar();
        }
    }

    /**
     * Clasifica los alimentos por proximidad de fecha de caducidad.
     * Rojo: 1-2 días, Amarillo: 3-5 días, Gris: 6+ días
     */
    private void verificarFechasCaducidad(List<Alimento> alimentos,
            List<Alimento> rojos, List<Alimento> amarillos, List<Alimento> grises) {

        Date fechaActual = new Date();

        for (Alimento alimento : alimentos) {
            long diasRestantes = calcularDiasRestantes(fechaActual, alimento.getFechaCaducidad());

            if (diasRestantes <= 2) {
                rojos.add(alimento);
            } else if (diasRestantes <= 5) {
                amarillos.add(alimento);
            } else {
                grises.add(alimento);
            }
        }
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
}