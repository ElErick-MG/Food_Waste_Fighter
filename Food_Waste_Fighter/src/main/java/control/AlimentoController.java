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

@WebServlet(name = "AlimentoController", urlPatterns = {"/AlimentoController"})
public class AlimentoController extends HttpServlet {

    private AlimentoDAO alimentoDAO;
    private CategoriaDAO categoriaDAO;
    private InventarioDAO inventarioDAO;

    @Override
    public void init() throws ServletException {
        alimentoDAO = new AlimentoDAO();
        categoriaDAO = new CategoriaDAO();
        inventarioDAO = new InventarioDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        if (accion == null) {
            accion = "listar";
        }

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
            case "listar":
            default:
                listarAlimentos(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String accion = request.getParameter("accion");

        switch (accion) {
            case "guardar":
                guardar(request, response);
                break;
            case "actualizar":
                actualizar(request, response);
                break;
            case "confirmar":
                confirmar(request, response);
                break;
            default:
                listarAlimentos(request, response);
                break;
        }
    }

    // CU REGISTRAR ALIMENTO - Paso 1,2,3: desplegarFormulario(Categorias)
    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("registrarAlimento.jsp").forward(request, response);
    }

    // CU REGISTRAR ALIMENTO - Paso 4,5,6,7: crear, agregar, obtenerAlimentos, mostrar
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        Long idCategoria = Long.parseLong(request.getParameter("categoria"));
        String fechaCaducidadStr = request.getParameter("fechaCaducidad");
        String cantidad = request.getParameter("cantidad");

        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");

        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        Categoria categoriaSeleccionada = null;
        for (Categoria cat : categorias) {
            if (cat.getIdCategoria().equals(idCategoria)) {
                categoriaSeleccionada = cat;
                break;
            }
        }

        Date fechaCaducidad = parsearFecha(fechaCaducidadStr);

        Alimento alimento = new Alimento(nombre, categoriaSeleccionada, fechaCaducidad, cantidad, inventario);
        alimentoDAO.crear(alimento);
        inventarioDAO.agregar(alimento);

        response.sendRedirect("AlimentoController?accion=listar");
    }

    // CU EDITAR ALIMENTO - Paso 1,2,3,4: buscarPorID, obtenerCategorias, desplegarFormulario
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long idAlimento = Long.parseLong(request.getParameter("id"));
        Alimento alimento = alimentoDAO.buscarPorID(idAlimento);
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();

        request.setAttribute("alimento", alimento);
        request.setAttribute("categorias", categorias);
        request.getRequestDispatcher("editarAlimento.jsp").forward(request, response);
    }

    // CU EDITAR ALIMENTO - Paso 5,6,7: actualizar, obtenerAlimentos, mostrar
    private void actualizar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long idAlimento = Long.parseLong(request.getParameter("idAlimento"));
        String nombre = request.getParameter("nombre");
        Long idCategoria = Long.parseLong(request.getParameter("categoria"));
        String fechaCaducidadStr = request.getParameter("fechaCaducidad");
        String cantidad = request.getParameter("cantidad");

        Alimento alimento = alimentoDAO.buscarPorID(idAlimento);

        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        Categoria categoriaSeleccionada = null;
        for (Categoria cat : categorias) {
            if (cat.getIdCategoria().equals(idCategoria)) {
                categoriaSeleccionada = cat;
                break;
            }
        }

        Date fechaCaducidad = parsearFecha(fechaCaducidadStr);

        alimento.setNombre(nombre);
        alimento.setCategoria(categoriaSeleccionada);
        alimento.setFechaCaducidad(fechaCaducidad);
        alimento.setCantidad(cantidad);

        alimentoDAO.actualizar(alimento);
        response.sendRedirect("AlimentoController?accion=listar");
    }

    // CU ELIMINAR ALIMENTO - Paso 1,2,3: buscarPorID, desplegarConfirmacion
    private void eliminar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long idAlimento = Long.parseLong(request.getParameter("id"));
        Alimento alimento = alimentoDAO.buscarPorID(idAlimento);
        request.setAttribute("alimento", alimento);
        request.getRequestDispatcher("eliminarAlimento.jsp").forward(request, response);
    }

    // CU ELIMINAR ALIMENTO - Paso 4,5,6,7: confirmar, eliminar, obtenerAlimentos, mostrar
    private void confirmar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long idAlimento = Long.parseLong(request.getParameter("idAlimento"));
        Alimento alimento = alimentoDAO.buscarPorID(idAlimento);
        alimentoDAO.eliminar(alimento);
        response.sendRedirect("AlimentoController?accion=listar");
    }

    // Listar alimentos del inventario
    private void listarAlimentos(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");
        
        List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
        request.setAttribute("alimentos", alimentos);
        request.getRequestDispatcher("listarAlimentos.jsp").forward(request, response);
    }

    private Date parsearFecha(String fechaStr) {
        Date fecha = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            fecha = sdf.parse(fechaStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        return fecha;
    }

    @Override
    public void destroy() {
        if (alimentoDAO != null) alimentoDAO.cerrar();
        if (categoriaDAO != null) categoriaDAO.cerrar();
        if (inventarioDAO != null) inventarioDAO.cerrar();
    }
}
