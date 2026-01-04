<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Añadir Producto - Food Waste Fighter</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Fuente Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Estilos personalizados -->
    <link rel="stylesheet" href="css/styles.css">
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- NAVBAR DE LA APP -->
    <nav class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <a href="dashboard.html" class="flex items-center gap-2 text-green-600 font-bold text-xl">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                        </svg>
                    </a>
                </div>
                <!-- Menú de navegación -->
                <div class="flex items-center gap-6">
                    <a href="dashboard.html" class="text-gray-600 hover:text-green-600 font-medium">
                        Dashboard
                    </a>
                    <a href="AlimentoServlet?action=listar" class="text-gray-600 hover:text-green-600 font-medium">
                        Mi Inventario
                    </a>
                    <a href="AlimentoServlet?action=porCaducar" class="text-gray-600 hover:text-green-600 font-medium">
                        Productos por Caducar
                    </a>
                    <a href="AlimentoServlet?action=nuevo" class="text-green-600 font-semibold">
                        Añadir Producto
                    </a>
                </div>
                <div class="flex items-center">
                    <a href="landing.html" class="text-gray-600 hover:text-green-600 font-medium">
                        Cerrar Sesión
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <main class="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
        <div class="page-transition">
            <!-- Mensajes de error -->
            <c:if test="${not empty requestScope.error}">
                <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-lg">
                    <div class="flex items-center gap-3">
                        <svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <p class="text-red-800 font-medium">${requestScope.error}</p>
                    </div>
                </div>
            </c:if>
            
            <h1 class="text-3xl font-bold text-center mb-8">Añadir Nuevo Producto</h1>
            
            <div class="max-w-lg mx-auto">
                <div class="bg-white p-8 rounded-2xl shadow-lg">
                    <form action="AlimentoServlet" method="post">
                        <input type="hidden" name="action" value="guardar">
                        
                        <h3 class="text-xl font-semibold mb-6">Registrar Producto</h3>
                        
                        <div class="mb-4">
                            <label for="nombre" class="block text-sm font-medium text-gray-700 mb-1">
                                Nombre del Producto *
                            </label>
                            <input type="text" 
                                   id="nombre" 
                                   name="nombre" 
                                   placeholder="ej. Leche, Manzana, Pollo" 
                                   required 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        </div>

                        <div class="mb-4">
                            <label for="categoria" class="block text-sm font-medium text-gray-700 mb-1">
                                Categoría *
                            </label>
                            <select id="categoria" 
                                    name="categoria" 
                                    required 
                                    class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
                                <option value="">Selecciona una categoría</option>
                                <c:forEach var="cat" items="${categorias}">
                                    <option value="${cat.id}">${cat.nombre}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="mb-4">
                            <label for="fechaCaducidad" class="block text-sm font-medium text-gray-700 mb-1">
                                Fecha de Caducidad *
                            </label>
                            <input type="date" 
                                   id="fechaCaducidad" 
                                   name="fechaCaducidad" 
                                   required 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        </div>

                        <div class="mb-6">
                            <label for="cantidad" class="block text-sm font-medium text-gray-700 mb-1">
                                Cantidad
                            </label>
                            <input type="text" 
                                   id="cantidad" 
                                   name="cantidad" 
                                   placeholder="ej. 2 litros, 5 unidades" 
                                   class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                        </div>

                        <div class="flex gap-3">
                            <button type="submit" 
                                class="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition-colors btn-primary">
                                Guardar Producto
                            </button>
                            <a href="AlimentoServlet?action=listar" 
                                class="flex-1 bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-colors text-center leading-relaxed">
                                Cancelar
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

</body>
</html>
