package control;

import DAO.UsuarioDAO;
import entities.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controller for authentication operations: login, register, logout.
 * 
 * Optimización v2.0:
 * - Extiende BaseController para heredar doGet() y doPost()
 * - Implementa procesarPeticion() con la lógica específica
 */
@WebServlet(name = "AuthController", urlPatterns = {"/AuthController"})
public class AuthController extends BaseController {

    @Override
    protected void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = obtenerAccion(request, "login");

        switch (accion) {
            case "logout":
                logout(request, response);
                break;
            case "registro":
                mostrarRegistro(request, response);
                break;
            case "autenticar":
                entrar(request, response);
                break;
            case "registrar":
                registrar(request, response);
                break;
            case "login":
            default:
                iniciarSesion(request, response);
                break;
        }
    }

    /**
     * Shows the login page.
     */
    private void iniciarSesion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // If already logged in, redirect to dashboard
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("usuario") != null) {
            response.sendRedirect(request.getContextPath() + "/DashboardController?accion=mostrar");
            return;
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }

    /**
     * Shows the registration page.
     */
    private void mostrarRegistro(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("registro.jsp").forward(request, response);
    }

    /**
     * Authenticates user credentials.
     */
    private void entrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String contrasena = request.getParameter("contrasena");
        
        UsuarioDAO usuarioDAO = null;
        
        try {
            usuarioDAO = new UsuarioDAO();
            Usuario usuario = usuarioDAO.autenticar(email, contrasena);
            
            if (usuario != null) {
                // Authentication successful - create session
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", usuario);
                session.setAttribute("inventario", usuario.getInventario());
                session.setMaxInactiveInterval(30 * 60); // 30 minutes
                
                System.out.println("User logged in: " + usuario.getEmail());
                
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/DashboardController?accion=mostrar");
            } else {
                // Authentication failed
                request.setAttribute("error", "Email o contraseña incorrectos");
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error during authentication: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al iniciar sesión. Intente de nuevo.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        } finally {
            if (usuarioDAO != null) {
                usuarioDAO.cerrar();
            }
        }
    }

    /**
     * Registers a new user.
     */
    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String contrasena = request.getParameter("contrasena");
        String confirmarContrasena = request.getParameter("confirmarContrasena");
        
        // Validate passwords match
        if (!contrasena.equals(confirmarContrasena)) {
            request.setAttribute("error", "Las contraseñas no coinciden");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }
        
        // Validate password length
        if (contrasena.length() < 6) {
            request.setAttribute("error", "La contraseña debe tener al menos 6 caracteres");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
            return;
        }
        
        UsuarioDAO usuarioDAO = null;
        
        try {
            usuarioDAO = new UsuarioDAO();
            
            // Create new user (in production, hash the password!)
            Usuario usuario = new Usuario(nombre, email, contrasena);
            Usuario registrado = usuarioDAO.registrar(usuario);
            
            if (registrado != null) {
                // Registration successful - auto-login
                HttpSession session = request.getSession(true);
                session.setAttribute("usuario", registrado);
                session.setAttribute("inventario", registrado.getInventario());
                session.setMaxInactiveInterval(30 * 60);
                
                System.out.println("New user registered: " + registrado.getEmail());
                
                // Redirect to dashboard
                response.sendRedirect(request.getContextPath() + "/DashboardController?accion=mostrar");
            } else {
                // Registration failed (probably email already exists)
                request.setAttribute("error", "El email ya está registrado");
                request.getRequestDispatcher("registro.jsp").forward(request, response);
            }
            
        } catch (Exception e) {
            System.err.println("Error during registration: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Error al registrar. Intente de nuevo.");
            request.getRequestDispatcher("registro.jsp").forward(request, response);
        } finally {
            if (usuarioDAO != null) {
                usuarioDAO.cerrar();
            }
        }
    }

    /**
     * Logs out the current user.
     */
    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            System.out.println("User logged out: " + 
                ((Usuario) session.getAttribute("usuario")).getEmail());
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/landing.html");
    }
}
