<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Recetas - Food Waste Fighter</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- NAVBAR -->
    <jsp:include page="components/navbar.jsp" />

    <!-- MAIN CONTENT -->
    <main class="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
        <div class="page-transition">
            <!-- Header -->
            <div class="mb-8">
                <h1 class="text-3xl font-bold mb-2">Recetas Sugeridas</h1>
                <p class="text-gray-600">Recetas personalizadas que puedes preparar. Los ingredientes que tienes en tu inventario aparecerán marcados.</p>
            </div>

            <!-- Empty state -->
            <c:if test="${empty recetas}">
                <div class="bg-white rounded-xl shadow-lg p-8 text-center">
                    <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                    <h3 class="text-xl font-semibold text-gray-700 mb-2">No hay recetas disponibles</h3>
                    <p class="text-gray-500">Por favor contacta al administrador</p>
                </div>
            </c:if>

            <!-- Recipes Grid -->
            <c:if test="${not empty recetas}">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                    <c:forEach var="receta" items="${recetas}">
                        <a href="${pageContext.request.contextPath}/RecetaController?accion=detalle&id=${receta.idReceta}" 
                           class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow block">
                            <img src="${receta.imagenUrl}" alt="${receta.nombre}" class="w-full h-48 object-cover">
                            <div class="p-5">
                                <h3 class="font-bold text-xl mb-2">${receta.nombre}</h3>
                                <p class="text-gray-600 text-sm mb-3 line-clamp-2">${receta.descripcion}</p>
                                
                                <!-- Quick Info -->
                                <div class="flex items-center gap-4 text-xs text-gray-500 mb-3">
                                    <div class="flex items-center gap-1">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        <span>${receta.tiempoPreparacion} min</span>
                                    </div>
                                    <div class="flex items-center gap-1">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                                        </svg>
                                        <span>${receta.porciones} porción<c:if test="${receta.porciones > 1}">es</c:if></span>
                                    </div>
                                    <div class="flex items-center gap-1">
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                                        </svg>
                                        <span>${receta.dificultad}</span>
                                    </div>
                                </div>
                                
                                <p class="text-green-600 font-medium flex items-center gap-1">
                                    Ver receta completa
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                                    </svg>
                                </p>
                            </div>
                        </a>
                    </c:forEach>
                </div>

                <!-- Info Message -->
                <div class="mt-10 bg-green-50 border border-green-200 rounded-2xl p-6 flex items-start gap-4">
                    <svg class="w-8 h-8 text-green-600 flex-shrink-0 mt-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
                    </svg>
                    <div>
                        <h3 class="font-bold text-lg text-green-800">¿Sabías que...?</h3>
                        <p class="text-green-700 mt-1">Al ver los detalles de cada receta, los ingredientes que ya tienes en tu inventario aparecerán marcados. ¡Cocinar estas recetas te ayudará a reducir el desperdicio de alimentos!</p>
                    </div>
                </div>
            </c:if>
        </div>
    </main>

</body>
</html>
