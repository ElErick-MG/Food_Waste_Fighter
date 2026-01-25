package control;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Clase base abstracta para todos los Controllers de la aplicación.
 * Implementa el patrón Template Method para rutear peticiones GET y POST
 * a un método centralizado.
 * 
 * Ventajas:
 * - Elimina duplicación de código en doGet() y doPost()
 * - Centraliza el manejo de peticiones HTTP
 * - Facilita el mantenimiento
 * - Todos los controllers tienen comportamiento consistente
 * 
 * Uso:
 * 1. Tu controller debe extender esta clase
 * 2. Implementa el método abstracto procesarPeticion()
 * 3. En procesarPeticion() maneja las acciones con switch/if
 * 
 * @author Food Waste Fighter Team
 * @version 2.0
 */
public abstract class BaseController extends HttpServlet {

    /**
     * Maneja peticiones HTTP GET.
     * Delega al método procesarPeticion() implementado por las subclases.
     */
    @Override
    protected final void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarPeticion(request, response);
    }

    /**
     * Maneja peticiones HTTP POST.
     * Delega al método procesarPeticion() implementado por las subclases.
     */
    @Override
    protected final void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        procesarPeticion(request, response);
    }

    /**
     * Método abstracto que debe ser implementado por cada controller.
     * Aquí es donde cada controller define su lógica de ruteo y acciones.
     * 
     * @param request  HttpServletRequest con los datos de la petición
     * @param response HttpServletResponse para enviar la respuesta
     * @throws ServletException si ocurre un error en el servlet
     * @throws IOException      si ocurre un error de I/O
     */
    protected abstract void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException;

    /**
     * Método utilitario para obtener el parámetro "accion" con un valor por defecto.
     * Simplifica el código en las subclases.
     * 
     * @param request      HttpServletRequest
     * @param defaultValue Valor por defecto si "accion" es null
     * @return El valor del parámetro "accion" o el valor por defecto
     */
    protected String obtenerAccion(HttpServletRequest request, String defaultValue) {
        String accion = request.getParameter("accion");
        return (accion != null && !accion.isEmpty()) ? accion : defaultValue;
    }

    /**
     * Método utilitario para obtener el parámetro "accion".
     * Usa "listar" como valor por defecto.
     * 
     * @param request HttpServletRequest
     * @return El valor del parámetro "accion" o "listar"
     */
    protected String obtenerAccion(HttpServletRequest request) {
        return obtenerAccion(request, "listar");
    }
}
