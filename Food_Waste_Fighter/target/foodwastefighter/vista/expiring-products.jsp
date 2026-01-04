<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Productos por Caducar - Food Waste Fighter</title>
    
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
                    <a href="AlimentoServlet?action=porCaducar" class="text-green-600 font-semibold">
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
            <div class="flex justify-between items-center mb-6">
                <h1 class="text-3xl font-bold">Productos por Caducar</h1>
                <div class="text-sm text-gray-600">
                    <span class="font-semibold">Ordenados por fecha de caducidad</span>
                </div>
            </div>

            <!-- Leyenda de colores -->
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

            <!-- Tabla de Productos por Caducar -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden">
                <div class="overflow-x-auto table-responsive">
                    <c:choose>
                        <c:when test="${empty alimentos}">
                            <div class="p-8 text-center">
                                <svg class="w-16 h-16 mx-auto text-gray-300 mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                                <h3 class="text-xl font-semibold text-gray-700 mb-2">¡Excelente!</h3>
                                <p class="text-gray-500">No hay productos próximos a caducar en los próximos 30 días</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="w-full min-w-full divide-y-2 divide-gray-200">
                                <thead class="bg-gray-50">
                                    <tr>
                                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Producto</th>
                                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Categoría</th>
                                        <th class="px-6 py-4 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Fecha de Caducidad</th>
                                    </tr>
                                </thead>
                                <tbody class="bg-white divide-y divide-gray-200">
                                    <c:forEach var="alimento" items="${alimentos}">
                                        <tr class="${alimento.colorClase} hover:opacity-75 transition-colors">
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <div class="flex items-center gap-3">
                                                    <div class="w-1 h-12 ${alimento.colorBorde} rounded-full"></div>
                                                    <span class="font-semibold ${alimento.colorTexto}">${alimento.nombre}</span>
                                                </div>
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap text-gray-600">
                                                ${alimento.categoria.nombre}
                                            </td>
                                            <td class="px-6 py-4 whitespace-nowrap">
                                                <span class="font-semibold ${alimento.colorTexto}">
                                                    <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd 'de' MMMM 'de' yyyy" />
                                                </span>
                                                <span class="${alimento.colorTexto} text-sm font-medium ml-2">
                                                    (${alimento.diasParaCaducar} 
                                                    <c:choose>
                                                        <c:when test="${alimento.diasParaCaducar == 1}">día</c:when>
                                                        <c:otherwise>días</c:otherwise>
                                                    </c:choose>)
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Mensaje informativo -->
            <div class="mt-6 bg-blue-50 border-l-4 border-blue-500 p-4 rounded-lg">
                <div class="flex items-start gap-3">
                    <svg class="w-6 h-6 text-blue-500 flex-shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                    </svg>
                    <div>
                        <h3 class="font-semibold text-blue-900 mb-1">Consejo</h3>
                        <p class="text-blue-800 text-sm">Prioriza consumir los productos marcados en rojo y amarillo. Visita el Dashboard para ver recetas sugeridas que te ayuden a aprovechar estos ingredientes.</p>
                    </div>
                </div>
            </div>
        </div>
    </main>

</body>
</html>
