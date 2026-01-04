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
            case "consultar":
                consultar(request, response);
                break;
            default:
                consultar(request, response);
                break;
        }
    }

    // CU Consultar Fechas de Caducidad - Paso 1: Usuario solicita consultar()
    private void consultar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");

        // Paso 2: obtenerAlimentos() - obtener alimentos del inventario
        List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);

        // Paso 3: verificarFechasCaducidad(alimentos) - clasificar por proximidad de caducidad
        List<Alimento> alimentosRojos = new ArrayList<>();    // 1-2 días
        List<Alimento> alimentosAmarillos = new ArrayList<>(); // 3-5 días
        List<Alimento> alimentosGrises = new ArrayList<>();    // más de 6 días

        verificarFechasCaducidad(alimentos, alimentosRojos, alimentosAmarillos, alimentosGrises);

        request.setAttribute("alimentosRojos", alimentosRojos);
        request.setAttribute("alimentosAmarillos", alimentosAmarillos);
        request.setAttribute("alimentosGrises", alimentosGrises);

        // Paso 4: mostrar(alimentos) - mostrar en ProductosACaducar
        request.getRequestDispatcher("productosACaducar.jsp").forward(request, response);

        // Paso 5: mostrarProximosACaducar(alimentos) - mostrar en Dashboard
        // Este paso se ejecuta cuando se redirige al dashboard
    }

    // Método que clasifica los alimentos según su proximidad a la fecha de caducidad
    private void verificarFechasCaducidad(List<Alimento> alimentos,
            List<Alimento> rojos, List<Alimento> amarillos, List<Alimento> grises) {

        Date fechaActual = new Date();

        for (Alimento alimento : alimentos) {
            long diasRestantes = calcularDiasRestantes(fechaActual, alimento.getFechaCaducidad());

            if (diasRestantes <= 2) {
                // Etiqueta roja: 1-2 días para caducar
                rojos.add(alimento);
            } else if (diasRestantes <= 5) {
                // Etiqueta amarilla: 3-5 días para caducar
                amarillos.add(alimento);
            } else {
                // Etiqueta gris: más de 6 días para caducar
                grises.add(alimento);
            }
        }
    }

    // Calcula los días restantes hasta la fecha de caducidad
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
