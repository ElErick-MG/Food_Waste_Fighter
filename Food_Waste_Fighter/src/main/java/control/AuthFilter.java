package control;

import entities.Usuario;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter that protects application routes requiring authentication.
 * Redirects unauthenticated users to the login page.
 */
@WebFilter(urlPatterns = {
    "/AlimentoController",
    "/GestorCaducidadController",
    "/dashboard.jsp",
    "/listarAlimentos.jsp",
    "/registrarAlimento.jsp",
    "/editarAlimento.jsp",
    "/eliminarAlimento.jsp",
    "/productosACaducar.jsp"
})
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Nothing to initialize
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        HttpSession session = httpRequest.getSession(false);
        
        // Check if user is authenticated
        boolean isLoggedIn = (session != null && session.getAttribute("usuario") != null);
        
        if (isLoggedIn) {
            // User is authenticated - allow access
            Usuario usuario = (Usuario) session.getAttribute("usuario");
            
            // Ensure inventory is in session
            if (session.getAttribute("inventario") == null && usuario.getInventario() != null) {
                session.setAttribute("inventario", usuario.getInventario());
            }
            
            chain.doFilter(request, response);
        } else {
            // User is not authenticated - redirect to login
            System.out.println("Unauthorized access attempt to: " + httpRequest.getRequestURI());
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/AuthController?accion=login");
        }
    }

    @Override
    public void destroy() {
        // Nothing to destroy
    }
}
