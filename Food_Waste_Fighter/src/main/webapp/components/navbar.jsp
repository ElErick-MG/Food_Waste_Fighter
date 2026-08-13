<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<% String uri = request.getServletPath(); %>
<!-- NAVBAR CENTRALIZADO -->
<nav class="bg-white shadow-sm sticky top-0 z-50">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between h-16">
            <div class="flex items-center">
                <a href="${pageContext.request.contextPath}/DashboardController?accion=mostrar"
                    class="flex items-center gap-2 text-green-600 font-bold text-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                    </svg>
                    <span class="hidden sm:inline">Food Waste Fighter</span>
                </a>
            </div>
            
            <!-- Desktop Menu -->
            <div class="hidden md:flex items-center gap-6">
                <a href="${pageContext.request.contextPath}/DashboardController?accion=mostrar"
                    class="<%= uri.equals("/dashboard.jsp") ? "text-green-600 font-semibold" : "text-gray-600 hover:text-green-600 font-medium" %>">Dashboard</a>
                <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar"
                    class="<%= (uri.equals("/listarAlimentos.jsp") || uri.equals("/registrarAlimento.jsp") || uri.equals("/editarAlimento.jsp") || uri.equals("/eliminarAlimento.jsp")) ? "text-green-600 font-semibold" : "text-gray-600 hover:text-green-600 font-medium" %>">Mi Inventario</a>
                <a href="${pageContext.request.contextPath}/RecetaController?accion=listar"
                    class="<%= (uri.equals("/recetas.jsp") || uri.equals("/detalleReceta.jsp")) ? "text-green-600 font-semibold" : "text-gray-600 hover:text-green-600 font-medium" %>">Recetas</a>
                <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=consultar"
                    class="<%= uri.equals("/productosACaducar.jsp") ? "text-green-600 font-semibold" : "text-gray-600 hover:text-green-600 font-medium" %>">Por Caducar</a>
            </div>
            
            <!-- Desktop User Info -->
            <div class="hidden md:flex items-center gap-4">
                <div class="flex items-center gap-2 text-gray-600">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    <span class="font-medium">${sessionScope.usuario.nombre}</span>
                </div>
                <a href="${pageContext.request.contextPath}/AuthController?accion=logout"
                    class="text-red-600 hover:text-red-700 font-medium">Cerrar Sesión</a>
            </div>

            <!-- Mobile menu button -->
            <div class="md:hidden flex items-center">
                <button id="mobile-menu-btn" class="text-gray-600 hover:text-green-600 focus:outline-none">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path id="menu-icon-open" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16" />
                        <path id="menu-icon-close" class="hidden" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                </button>
            </div>
        </div>
    </div>
    
    <!-- Mobile Menu -->
    <div id="mobile-menu" class="hidden md:hidden bg-white border-t border-gray-100 shadow-md absolute w-full">
        <div class="px-4 pt-2 pb-4 space-y-1">
            <a href="${pageContext.request.contextPath}/DashboardController?accion=mostrar" class="block px-3 py-2 rounded-md <%= uri.equals("/dashboard.jsp") ? "bg-green-50 text-green-600 font-semibold" : "text-gray-600 hover:bg-green-50 hover:text-green-600" %>">Dashboard</a>
            <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar" class="block px-3 py-2 rounded-md <%= (uri.equals("/listarAlimentos.jsp") || uri.equals("/registrarAlimento.jsp") || uri.equals("/editarAlimento.jsp") || uri.equals("/eliminarAlimento.jsp")) ? "bg-green-50 text-green-600 font-semibold" : "text-gray-600 hover:bg-green-50 hover:text-green-600" %>">Mi Inventario</a>
            <a href="${pageContext.request.contextPath}/RecetaController?accion=listar" class="block px-3 py-2 rounded-md <%= (uri.equals("/recetas.jsp") || uri.equals("/detalleReceta.jsp")) ? "bg-green-50 text-green-600 font-semibold" : "text-gray-600 hover:bg-green-50 hover:text-green-600" %>">Recetas</a>
            <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=consultar" class="block px-3 py-2 rounded-md <%= uri.equals("/productosACaducar.jsp") ? "bg-green-50 text-green-600 font-semibold" : "text-gray-600 hover:bg-green-50 hover:text-green-600" %>">Por Caducar</a>
            
            <div class="border-t border-gray-100 mt-4 pt-4">
                <div class="flex items-center gap-2 px-3 text-gray-600 mb-3">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    <span class="font-medium">${sessionScope.usuario.nombre}</span>
                </div>
                <a href="${pageContext.request.contextPath}/AuthController?accion=logout" class="block px-3 py-2 rounded-md text-red-600 hover:bg-red-50 hover:text-red-700 font-medium">Cerrar Sesión</a>
            </div>
        </div>
    </div>
</nav>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const btn = document.getElementById('mobile-menu-btn');
        const menu = document.getElementById('mobile-menu');
        const iconOpen = document.getElementById('menu-icon-open');
        const iconClose = document.getElementById('menu-icon-close');
        
        if(btn && menu) {
            btn.addEventListener('click', () => {
                menu.classList.toggle('hidden');
                iconOpen.classList.toggle('hidden');
                iconClose.classList.toggle('hidden');
            });
        }
    });
</script>
