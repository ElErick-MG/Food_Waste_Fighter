<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Añadir Producto - Food Waste Fighter</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- NAVBAR -->
    <nav class="bg-white shadow-sm sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/DashboardController?accion=mostrar" class="flex items-center gap-2 text-green-600 font-bold text-xl">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                        </svg>
                        Food Waste Fighter
                    </a>
                </div>
                <div class="flex items-center gap-6">
                    <a href="${pageContext.request.contextPath}/DashboardController?accion=mostrar" class="text-gray-600 hover:text-green-600 font-medium">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar" class="text-gray-600 hover:text-green-600 font-medium">Mi Inventario</a>
                    <a href="${pageContext.request.contextPath}/RecetaController?accion=listar" class="text-gray-600 hover:text-green-600 font-medium">Recetas</a>
                    <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=consultar" class="text-gray-600 hover:text-green-600 font-medium">Por Caducar</a>
                </div>
                <div class="flex items-center gap-4">
                    <div class="flex items-center gap-2 text-gray-600">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                        </svg>
                        <span class="font-medium">${sessionScope.usuario.nombre}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/AuthController?accion=logout" class="text-red-600 hover:text-red-700 font-medium">Cerrar Sesión</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- MAIN CONTENT -->
    <main class="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
        <!-- Back button -->
        <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar" class="inline-flex items-center gap-2 text-green-600 hover:text-green-700 font-medium mb-6">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
            </svg>
            Volver al Inventario
        </a>

        <h1 class="text-3xl font-bold text-center mb-8">Añadir Producto</h1>
        
        <div class="max-w-lg mx-auto">
            <div class="bg-white p-8 rounded-xl shadow-lg">
                <form action="${pageContext.request.contextPath}/AlimentoController" method="post">
                    <input type="hidden" name="accion" value="guardar">
                    
                    <h3 class="text-xl font-semibold mb-6">Información del Producto</h3>
                    
                    <div class="mb-4">
                        <label for="nombre" class="block text-sm font-medium text-gray-700 mb-1">Nombre del Producto</label>
                        <input type="text" id="nombre" name="nombre" required 
                            placeholder="ej. Leche, Manzanas, Pollo"
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>

                    <div class="mb-4">
                        <label for="categoria" class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
                        <select id="categoria" name="categoria" required 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
                            <option value="">Selecciona una categoría</option>
                            <c:forEach var="cat" items="${categorias}">
                                <option value="${cat.idCategoria}">${cat.nombre}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="fechaCaducidad" class="block text-sm font-medium text-gray-700 mb-1">Fecha de Caducidad</label>
                        <input type="date" id="fechaCaducidad" name="fechaCaducidad" required 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>

                    <div class="mb-6">
                        <label for="cantidad" class="block text-sm font-medium text-gray-700 mb-1">Cantidad</label>
                        <input type="text" id="cantidad" name="cantidad" required
                            placeholder="ej. 2 litros, 5 unidades, 1 kg" 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>

                    <div class="flex gap-3">
                        <button type="submit" class="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition-colors">
                            Guardar Producto
                        </button>
                        <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar" 
                            class="flex-1 bg-gray-200 text-gray-700 py-3 rounded-lg font-semibold hover:bg-gray-300 transition-colors text-center">
                            Cancelar
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </main>

</body>
</html>
