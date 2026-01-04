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
            case "confirmar":
                confirmar(request, response);
                break;
            default:
                listarAlimentos(request, response);
                break;
        }
    }

    // CU Registrar Alimento - Paso 1: Usuario solicita registrar()
    // Muestra formulario con categorías (paso 3 del diagrama de robustez)
    private void registrar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Paso 2: obtenerCategorias() - obtener categorías para el formulario
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        request.setAttribute("categorias", categorias);
        
        // Paso 3: desplegarFormulario(Categorias) - mostrar formulario de registro
        request.getRequestDispatcher("registrarAlimento.jsp").forward(request, response);
    }

    // CU Registrar Alimento - Paso 3: Usuario solicita guardar()
    private void guardar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String nombre = request.getParameter("nombre");
        Long idCategoria = Long.parseLong(request.getParameter("categoria"));
        String fechaCaducidadStr = request.getParameter("fechaCaducidad");
        String cantidad = request.getParameter("cantidad");

        // Obtener inventario del usuario desde la sesión
        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");

        // Obtener la categoría seleccionada
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        Categoria categoriaSeleccionada = null;
        for (Categoria cat : categorias) {
            if (cat.getIdCategoria().equals(idCategoria)) {
                categoriaSeleccionada = cat;
                break;
            }
        }

        // Parsear fecha
        Date fechaCaducidad = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            fechaCaducidad = sdf.parse(fechaCaducidadStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // Paso 4: crear(nombre, categoria, fechaCaducidad, cantidad) - crear el alimento
        Alimento alimento = new Alimento(nombre, categoriaSeleccionada, fechaCaducidad, cantidad, inventario);
        alimentoDAO.crear(alimento);

        // Paso 5: agregar(alimento) - agregar al inventario
        inventarioDAO.agregar(alimento);

        // Paso 6: obtenerAlimentos() - obtener lista actualizada
        List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
        request.setAttribute("alimentos", alimentos);

        // Paso 7: mostrar(alimentos) - mostrar lista actualizada
        request.getRequestDispatcher("listarAlimentos.jsp").forward(request, response);
    }

    // CU Editar Alimento - Paso 1: Usuario solicita editar()
    private void editar(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long idAlimento = Long.parseLong(request.getParameter("id"));

        // Paso 2: buscarPorID(alimento) - buscar el alimento a editar
        Alimento alimento = alimentoDAO.buscarPorID(idAlimento);

        // Paso 3: obtenerCategorias() - obtener categorías para el formulario
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();

        request.setAttribute("alimento", alimento);
        request.setAttribute("categorias", categorias);

        // Paso 4: desplegarFormulario(alimento) - mostrar formulario de edición
        request.getRequestDispatcher("editarAlimento.jsp").forward(request, response);
    }

    // CU Editar Alimento - Paso 4: Usuario solicita guardar cambios
    // Se usa el mismo método guardar con lógica para actualizar
    private void actualizarAlimento(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Long idAlimento = Long.parseLong(request.getParameter("idAlimento"));
        String nombre = request.getParameter("nombre");
        Long idCategoria = Long.parseLong(request.getParameter("categoria"));
        String fechaCaducidadStr = request.getParameter("fechaCaducidad");
        String cantidad = request.getParameter("cantidad");

        // Buscar alimento existente
        Alimento alimento = alimentoDAO.buscarPorID(idAlimento);

        // Obtener la categoría seleccionada
        List<Categoria> categorias = categoriaDAO.obtenerCategorias();
        Categoria categoriaSeleccionada = null;
        for (Categoria cat : categorias) {
            if (cat.getIdCategoria().equals(idCategoria)) {
                categoriaSeleccionada = cat;
                break;
            }
        }

        // Parsear fecha
        Date fechaCaducidad = null;
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            fechaCaducidad = sdf.parse(fechaCaducidadStr);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        // Actualizar datos
        alimento.setNombre(nombre);
        alimento.setCategoria(categoriaSeleccionada);
        alimento.setFechaCaducidad(fechaCaducidad);
        alimento.setCantidad(cantidad);

        // Paso 5: actualizar(nombre, fechaCaducidad, categoria, cantidad)
        alimentoDAO.actualizar(alimento);

        // Paso 6: obtenerAlimentos() - obtener lista actualizada
        HttpSession session = request.getSession();
        Inventario inventario = (Inventario) session.getAttribute("inventario");
        List<Alimento> alimentos = inventarioDAO.obtenerAlimentos(inventario);
        request.setAttribute("alimentos", alimentos);

        // Paso 7: mostrar(alimentos) - mostrar lista actualizada
        request.getRequestDispatcher("listarAlimentos.jsp").forward(request, response);
    }

    @Override
    public void destroy() {
        if (alimentoDAO != null) {
            alimentoDAO.cerrar();
        }
        if (categoriaDAO != null) {
            categoriaDAO.cerrar();
        }
        if (inventarioDAO != null) {
            inventarioDAO.cerrar();
        }
    }
}
