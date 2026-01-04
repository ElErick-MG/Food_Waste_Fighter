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

@WebServlet(name = "GestorCaducidadController", urlPatterns = {"/GestorCaducidadController"})
public class GestorCaducidadController extends HttpServlet {

    private InventarioDAO inventarioDAO;

    @Override
    public void init() throws ServletException {
        inventarioDAO = new InventarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "consultar";
        }

        switch (accion) {
            case "dashboard":
                dashboard(request, response);
                break;
            case "consultar":
            default:
                consultar(request, response);
                break;
        }
    }

    // Dashboard - muestra resumen de alertas de caducidad
    private void dashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");

        List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);

        List<Alimento> alimentosRojos = new ArrayList<>();
        List<Alimento> alimentosAmarillos = new ArrayList<>();
        List<Alimento> alimentosGrises = new ArrayList<>();

        verificarFechasCaducidad(alimentos, alimentosRojos, alimentosAmarillos, alimentosGrises);

        request.setAttribute("alimentosRojos", alimentosRojos);
        request.setAttribute("alimentosAmarillos", alimentosAmarillos);
        request.setAttribute("alimentosGrises", alimentosGrises);

        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }

    // CU CONSULTAR FECHAS DE CADUCIDAD
    // Paso 1: Usuario solicita consultar()
    // Paso 2: obtenerAlimentos()
    // Paso 3: verificarFechasCaducidad(alimentos)
    // Paso 4: mostrar(alimentos) en ProductosACaducar
    // Paso 5: mostrarProximosACaducar(alimentos) en Dashboard
    private void consultar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");

        // Paso 2: obtenerAlimentos()
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
    }

    // Clasifica los alimentos segun proximidad a fecha de caducidad
    // Rojo: 1-2 dias, Amarillo: 3-5 dias, Gris: 6+ dias
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

    private long calcularDiasRestantes(Date fechaActual, Date fechaCaducidad) {
        long diferencia = fechaCaducidad.getTime() - fechaActual.getTime();
        return TimeUnit.DAYS.convert(diferencia, TimeUnit.MILLISECONDS);
    }

    @Override
    public void destroy() {
        if (inventarioDAO != null) {
            inventarioDAO.cerrar();
        }
    }
}
