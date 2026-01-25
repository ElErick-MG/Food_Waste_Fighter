<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos por Caducar - Food Waste Fighter</title>
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
                    <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=consultar" class="text-green-600 font-semibold">Por Caducar</a>
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
        <div class="flex justify-between items-center mb-6">
            <h1 class="text-3xl font-bold">Productos por Caducar</h1>
        </div>

        <!-- Legend -->
        <div class="bg-white rounded-xl shadow-sm p-4 mb-6 flex flex-wrap gap-4 items-center">
            <span class="text-sm font-medium text-gray-700">Leyenda:</span>
            <div class="flex items-center gap-2">
                <div class="w-4 h-4 bg-red-100 border-l-4 border-red-500"></div>
                <span class="text-sm text-gray-600">Crítico (1-2 días)</span>
            </div>
            <div class="flex items-center gap-2">
                <div class="w-4 h-4 bg-yellow-50 border-l-4 border-yellow-500"></div>
                <span class="text-sm text-gray-600">Advertencia (3-5 días)</span>
            </div>
            <div class="flex items-center gap-2">
                <div class="w-4 h-4 bg-white border-l-4 border-gray-300"></div>
                <span class="text-sm text-gray-600">Normal (6+ días)</span>
            </div>
        </div>

        <!-- Empty state -->
        <c:if test="${empty alimentosRojos and empty alimentosAmarillos and empty alimentosGrises}">
            <div class="bg-white rounded-xl shadow-lg p-8 text-center">
                <svg class="w-16 h-16 text-green-500 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
                <h3 class="text-xl font-semibold text-gray-700 mb-2">No hay productos registrados</h3>
                <p class="text-gray-500 mb-4">Añade productos a tu inventario para ver sus fechas de caducidad</p>
                <a href="${pageContext.request.contextPath}/AlimentoController?accion=registrar" 
                    class="inline-flex items-center gap-2 bg-green-600 text-white px-6 py-3 rounded-lg font-medium hover:bg-green-700 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Añadir Producto
                </a>
            </div>
        </c:if>

        <!-- Table -->
        <c:if test="${not empty alimentosRojos or not empty alimentosAmarillos or not empty alimentosGrises}">
            <div class="bg-white rounded-xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full">
                        <thead class="bg-gray-50 border-b">
                            <tr>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase">Producto</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase">Categoría</th>
                                <th class="px-6 py-4 text-left text-xs font-semibold text-gray-500 uppercase">Fecha de Caducidad</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200">
                            
                            <!-- Critical (1-2 days) - RED -->
                            <c:forEach var="alimento" items="${alimentosRojos}">
                                <tr class="bg-red-50 hover:bg-red-100 transition-colors">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center gap-3">
                                            <div class="w-1 h-10 bg-red-500 rounded-full"></div>
                                            <span class="font-semibold text-red-700">${alimento.nombre}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-gray-600">${alimento.categoria.nombre}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="font-semibold text-red-700">
                                            <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/>
                                        </span>
                                        <span class="text-red-600 text-sm font-medium ml-2">(Crítico)</span>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <!-- Warning (3-5 days) - YELLOW -->
                            <c:forEach var="alimento" items="${alimentosAmarillos}">
                                <tr class="bg-yellow-50 hover:bg-yellow-100 transition-colors">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center gap-3">
                                            <div class="w-1 h-10 bg-yellow-500 rounded-full"></div>
                                            <span class="font-semibold text-yellow-700">${alimento.nombre}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-gray-600">${alimento.categoria.nombre}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="font-semibold text-yellow-700">
                                            <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/>
                                        </span>
                                        <span class="text-yellow-600 text-sm font-medium ml-2">(Advertencia)</span>
                                    </td>
                                </tr>
                            </c:forEach>

                            <!-- Normal (6+ days) - GRAY -->
                            <c:forEach var="alimento" items="${alimentosGrises}">
                                <tr class="hover:bg-gray-50 transition-colors">
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <div class="flex items-center gap-3">
                                            <div class="w-1 h-10 bg-gray-300 rounded-full"></div>
                                            <span class="font-medium text-gray-900">${alimento.nombre}</span>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4 whitespace-nowrap text-gray-600">${alimento.categoria.nombre}</td>
                                    <td class="px-6 py-4 whitespace-nowrap">
                                        <span class="font-medium">
                                            <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/>
                                        </span>
                                        <span class="text-gray-500 text-sm ml-2">(Normal)</span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Tip -->
            <div class="mt-6 bg-blue-50 border-l-4 border-blue-500 p-4 rounded-lg">
                <div class="flex items-start gap-3">
                    <svg class="w-6 h-6 text-blue-500 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <div>
                        <h3 class="font-semibold text-blue-900 mb-1">Consejo</h3>
                        <p class="text-blue-800 text-sm">Prioriza consumir los productos marcados en rojo y amarillo para evitar el desperdicio de alimentos.</p>
                    </div>
                </div>
            </div>
        </c:if>
    </main>

</body>
</html>
