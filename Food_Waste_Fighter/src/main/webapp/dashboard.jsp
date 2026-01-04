<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Food Waste Fighter</title>
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <!-- Fuente Inter -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- NAVBAR DE LA APP -->
    <nav class="bg-white shadow-sm">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between h-16">
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=dashboard" class="flex items-center gap-2 text-green-600 font-bold text-xl">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                        </svg>
                    </a>
                </div>
                <!-- Menú de navegación -->
                <div class="flex items-center gap-6">
                    <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=dashboard" class="text-green-600 font-semibold">
                        Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar" class="text-gray-600 hover:text-green-600 font-medium">
                        Mi Inventario
                    </a>
                    <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=consultar" class="text-gray-600 hover:text-green-600 font-medium">
                        Productos por Caducar
                    </a>
                    <a href="${pageContext.request.contextPath}/AlimentoController?accion=registrar" class="text-gray-600 hover:text-green-600 font-medium">
                        Añadir Producto
                    </a>
                </div>
                <div class="flex items-center">
                    <a href="${pageContext.request.contextPath}/landing.html" class="text-gray-600 hover:text-green-600 font-medium">
                        Cerrar Sesión
                    </a>
                </div>
            </div>
        </div>
    </nav>

    <!-- CONTENIDO PRINCIPAL -->
    <main class="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
        <div>
            <h1 class="text-3xl font-bold mb-6">Tu Dashboard</h1>
            
            <!-- Alertas de Caducidad -->
            <section>
                <h2 class="text-2xl font-semibold mb-4">Alertas de Caducidad</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    
                    <!-- Alertas Críticas (1-2 días) -->
                    <c:forEach var="alimento" items="${alimentosRojos}">
                        <div class="bg-white p-5 rounded-2xl shadow-lg border-l-4 border-red-500 flex items-center gap-4">
                            <svg class="w-8 h-8 text-red-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                            </svg>
                            <div>
                                <h3 class="font-bold text-lg">${alimento.nombre}</h3>
                                <p class="text-gray-600">Caduca: <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></p>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Alertas Advertencia (3-5 días) -->
                    <c:forEach var="alimento" items="${alimentosAmarillos}">
                        <div class="bg-white p-5 rounded-2xl shadow-lg border-l-4 border-yellow-500 flex items-center gap-4">
                            <svg class="w-8 h-8 text-yellow-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                            </svg>
                            <div>
                                <h3 class="font-bold text-lg">${alimento.nombre}</h3>
                                <p class="text-gray-600">Caduca: <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></p>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Alertas Normal (6+ días) - mostrar solo algunos -->
                    <c:forEach var="alimento" items="${alimentosGrises}" end="2">
                        <div class="bg-white p-5 rounded-2xl shadow-lg border-l-4 border-gray-300 flex items-center gap-4">
                            <svg class="w-8 h-8 text-gray-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <div>
                                <h3 class="font-bold text-lg">${alimento.nombre}</h3>
                                <p class="text-gray-600">Caduca: <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></p>
                            </div>
                        </div>
                    </c:forEach>
                    
                    <!-- Mensaje si no hay alimentos -->
                    <c:if test="${empty alimentosRojos and empty alimentosAmarillos and empty alimentosGrises}">
                        <div class="bg-white p-5 rounded-2xl shadow-lg border-l-4 border-green-500 flex items-center gap-4 col-span-3">
                            <svg class="w-8 h-8 text-green-500 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <div>
                                <h3 class="font-bold text-lg">¡Todo en orden!</h3>
                                <p class="text-gray-600">No tienes productos registrados. <a href="${pageContext.request.contextPath}/AlimentoController?accion=registrar" class="text-green-600 hover:underline">Añade tu primer producto</a></p>
                            </div>
                        </div>
                    </c:if>
                </div>
            </section>

            <!-- Acciones Rápidas -->
            <section class="mt-12">
                <h2 class="text-2xl font-semibold mb-4">Acciones Rápidas</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                    <a href="${pageContext.request.contextPath}/AlimentoController?accion=registrar" class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow block p-6">
                        <div class="flex items-center gap-4">
                            <div class="bg-green-100 p-3 rounded-full">
                                <svg class="w-8 h-8 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-xl">Añadir Producto</h3>
                                <p class="text-gray-600 mt-1">Registra un nuevo alimento en tu inventario</p>
                            </div>
                        </div>
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/GestorCaducidadController?accion=consultar" class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow block p-6">
                        <div class="flex items-center gap-4">
                            <div class="bg-yellow-100 p-3 rounded-full">
                                <svg class="w-8 h-8 text-yellow-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-xl">Ver Productos por Caducar</h3>
                                <p class="text-gray-600 mt-1">Consulta qué productos debes consumir pronto</p>
                            </div>
                        </div>
                    </a>
                </div>
            </section>
        </div>
    </main>

</body>
</html>
