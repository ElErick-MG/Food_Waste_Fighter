<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar Producto - Food Waste Fighter</title>
    
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
                    <a href="AlimentoServlet?action=nuevo" class="text-gray-600 hover:text-green-600 font-medium">
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
            <!-- Botón Volver -->
            <a href="AlimentoServlet?action=listar" class="inline-flex items-center gap-2 text-green-600 hover:text-green-700 font-medium mb-6">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                </svg>
                Volver al Inventario
            </a>

            <h1 class="text-3xl font-bold text-center mb-8">Eliminar Producto</h1>
            
            <div class="max-w-lg mx-auto">
                <div class="bg-white p-8 rounded-2xl shadow-lg">
                    <!-- Advertencia -->
                    <div class="mb-6 bg-red-50 border-l-4 border-red-500 p-4 rounded-lg">
                        <div class="flex items-start gap-3">
                            <svg class="w-6 h-6 text-red-500 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                            </svg>
                            <div>
                                <h3 class="font-semibold text-red-900 mb-1">¡Atención!</h3>
                                <p class="text-red-800 text-sm">Esta acción no se puede deshacer. ¿Estás seguro de que deseas eliminar este producto?</p>
                            </div>
                        </div>
                    </div>

                    <!-- Información del producto -->
                    <div class="mb-6 bg-gray-50 p-4 rounded-lg">
                        <h3 class="text-lg font-semibold mb-3">Información del Producto</h3>
                        <div class="space-y-2">
                            <div class="flex justify-between">
                                <span class="text-gray-600">Nombre:</span>
                                <span class="font-semibold">${alimento.nombre}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Categoría:</span>
                                <span class="font-semibold">${alimento.categoria.nombre}</span>
                            </div>
                            <div class="flex justify-between">
                                <span class="text-gray-600">Fecha de Caducidad:</span>
                                <span class="font-semibold">
                                    <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy" />
                                </span>
                            </div>
                            <c:if test="${not empty alimento.cantidad}">
                                <div class="flex justify-between">
                                    <span class="text-gray-600">Cantidad:</span>
                                    <span class="font-semibold">${alimento.cantidad}</span>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Formulario de confirmación -->
                    <form action="AlimentoServlet" method="post">
                        <input type="hidden" name="action" value="confirmarEliminar">
                        <input type="hidden" name="id" value="${alimento.id}">
                        
                        <div class="flex gap-3">
                            <button type="submit" 
                                class="flex-1 bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition-colors">
                                Sí, eliminar producto
                            </button>
                            <a href="AlimentoServlet?action=listar" 
                                class="flex-1 bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-colors text-center leading-relaxed">
                                No, cancelar
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </main>

</body>
</html>
