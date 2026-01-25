package control;

import DAO.AlimentoDAO;
import DAO.CategoriaDAO;
import DAO.InventarioDAO;
import entities.Alimento;
import entities.Categoria;
import entities.Inventario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

/**
 * Controller for Alimento (Food) CRUD operations.
 * Handles: Registrar, Editar, Eliminar, Listar Alimentos
 * 
 * Optimización v2.0:
 * - Extiende BaseController para heredar doGet() y doPost()
 * - Implementa procesarPeticion() con la lógica específica
 */
@WebServlet(name = "AlimentoController", urlPatterns = {"/AlimentoController"})
public class AlimentoController extends BaseController {

    @Override
    protected void procesarPeticion(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String accion = obtenerAccion(request, "listar");

        switch (accion) {
            case "registrar":
                registrar(request, response);
                break;
            case "editar":
                editar(request, response);
                break;
            case "eliminar":
                eliminar(request, response);
                break;
            case "guardar":
                guardar(request, response);
                break;
            case "actualizar":
                actualizar(request, response);
                break;
            case "confirmar":
                confirmar(request, response);
                break;
            case "listar":
            default:
                listarAlimentos(request, response);
                break;
        }
    }

    /**
     * CU REGISTRAR ALIMENTO - Paso 1,2,3: desplegarFormulario(Categorias)
     */
    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        CategoriaDAO categoriaDAO = null;
        try {
            categoriaDAO = new CategoriaDAO();
            List<Categoria> categorias = categoriaDAO.obtenerCategorias();
            request.setAttribute("categorias", categorias);
            request.getRequestDispatcher("registrarAlimento.jsp").forward(request, response);
        } finally {
            if (categoriaDAO != null) categoriaDAO.cerrar();
        }
    }

    /**
     * CU REGISTRAR ALIMENTO - Paso 4,5,6,7: crear, agregar, obtenerAlimentos, mostrar
     */
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AlimentoDAO alimentoDAO = null;
        CategoriaDAO categoriaDAO = null;
        
        try {
            String nombre = request.getParameter("nombre");
            Long idCategoria = Long.parseLong(request.getParameter("categoria"));
            String fechaCaducidadStr = request.getParameter("fechaCaducidad");
            String cantidad = request.getParameter("cantidad");

            HttpSession session = request.getSession();
            Inventario inventario = (Inventario) session.getAttribute("inventario");

            categoriaDAO = new CategoriaDAO();
            Categoria categoriaSeleccionada = categoriaDAO.buscarPorID(idCategoria);

            Date fechaCaducidad = parsearFecha(fechaCaducidadStr);

            Alimento alimento = new Alimento(nombre, categoriaSeleccionada, fechaCaducidad, cantidad, inventario);
            
            alimentoDAO = new AlimentoDAO();
            alimentoDAO.crear(alimento);

            response.sendRedirect("AlimentoController?accion=listar");
            
        } catch (Exception e) {
            System.err.println("Error saving alimento: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AlimentoController?accion=listar&error=save");
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (categoriaDAO != null) categoriaDAO.cerrar();
        }
    }

    /**
     * CU EDITAR ALIMENTO - Paso 1,2,3,4: buscarPorID, obtenerCategorias, desplegarFormulario
     */
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AlimentoDAO alimentoDAO = null;
        CategoriaDAO categoriaDAO = null;
        
        try {
            Long idAlimento = Long.parseLong(request.getParameter("id"));
            
            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(idAlimento);
            
            categoriaDAO = new CategoriaDAO();
            List<Categoria> categorias = categoriaDAO.obtenerCategorias();

            request.setAttribute("alimento", alimento);
            request.setAttribute("categorias", categorias);
            request.getRequestDispatcher("editarAlimento.jsp").forward(request, response);
            
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (categoriaDAO != null) categoriaDAO.cerrar();
        }
    }

    /**
     * CU EDITAR ALIMENTO - Paso 5,6,7: actualizar, obtenerAlimentos, mostrar
     */
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AlimentoDAO alimentoDAO = null;
        CategoriaDAO categoriaDAO = null;
        
        try {
            Long idAlimento = Long.parseLong(request.getParameter("idAlimento"));
            String nombre = request.getParameter("nombre");
            Long idCategoria = Long.parseLong(request.getParameter("categoria"));
            String fechaCaducidadStr = request.getParameter("fechaCaducidad");
            String cantidad = request.getParameter("cantidad");

            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(idAlimento);

            categoriaDAO = new CategoriaDAO();
            Categoria categoriaSeleccionada = categoriaDAO.buscarPorID(idCategoria);

            Date fechaCaducidad = parsearFecha(fechaCaducidadStr);

            alimento.setNombre(nombre);
            alimento.setCategoria(categoriaSeleccionada);
            alimento.setFechaCaducidad(fechaCaducidad);
            alimento.setCantidad(cantidad);

            alimentoDAO.actualizar(alimento);
            response.sendRedirect("AlimentoController?accion=listar");
            
        } catch (Exception e) {
            System.err.println("Error updating alimento: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AlimentoController?accion=listar&error=update");
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (categoriaDAO != null) categoriaDAO.cerrar();
        }
    }

    /**
     * CU ELIMINAR ALIMENTO - Paso 1,2,3: buscarPorID, desplegarConfirmacion
     */
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AlimentoDAO alimentoDAO = null;
        
        try {
            Long idAlimento = Long.parseLong(request.getParameter("id"));
            
            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(idAlimento);
            
            request.setAttribute("alimento", alimento);
            request.getRequestDispatcher("eliminarAlimento.jsp").forward(request, response);
            
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
        }
    }

    /**
     * CU ELIMINAR ALIMENTO - Paso 4,5,6,7: confirmar, quitar, eliminar, obtenerAlimentos, mostrar
     */
    private void confirmar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        AlimentoDAO alimentoDAO = null;
        InventarioDAO inventarioDAO = null;
        
        try {
            Long idAlimento = Long.parseLong(request.getParameter("idAlimento"));
            
            alimentoDAO = new AlimentoDAO();
            Alimento alimento = alimentoDAO.buscarPorID(idAlimento);

            inventarioDAO = new InventarioDAO();
            inventarioDAO.quitar(alimento);

            alimentoDAO.eliminar(alimento);
            
            response.sendRedirect("AlimentoController?accion=listar");
            
        } catch (Exception e) {
            System.err.println("Error deleting alimento: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("AlimentoController?accion=listar&error=delete");
        } finally {
            if (alimentoDAO != null) alimentoDAO.cerrar();
            if (inventarioDAO != null) inventarioDAO.cerrar();
        }
    }

    /**
     * Listar alimentos del inventario
     */
    private void listarAlimentos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        InventarioDAO inventarioDAO = null;
        
        try {
            HttpSession session = request.getSession();
            Inventario inventario = (Inventario) session.getAttribute("inventario");
            
            if (inventario == null) {
                response.sendRedirect("AuthController?accion=login");
                return;
            }
            
            inventarioDAO = new InventarioDAO();
            List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
            
            request.setAttribute("alimentos", alimentos);
            request.getRequestDispatcher("listarAlimentos.jsp").forward(request, response);
            
        } finally {
            if (inventarioDAO != null) inventarioDAO.cerrar();
        }
    }

    /**
     * Parse date string to Date object
     */
    private Date parsearFecha(String fechaStr) {
        Date fecha = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            fecha = sdf.parse(fechaStr);
        } catch (ParseException e) {
            System.err.println("Error parsing date: " + fechaStr);
            e.printStackTrace();
        }
        return fecha;
    }
}
