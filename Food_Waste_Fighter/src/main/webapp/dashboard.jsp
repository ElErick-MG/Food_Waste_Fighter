<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - Food Waste Fighter</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
        }
    </style>
</head>

<body class="bg-gray-50 text-gray-800">

    <!-- NAVBAR -->
    <jsp:include page="components/navbar.jsp" />

    <!-- MAIN CONTENT -->
    <main class="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
        <!-- Welcome message -->
        <div class="mb-6">
            <h1 class="text-3xl font-bold">¡Hola, ${sessionScope.usuario.nombre}!</h1>
            <p class="text-gray-600">Este es el resumen de tu inventario</p>
        </div>

        <!-- Alertas de Caducidad - Los 3 más próximos -->
        <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4">Alertas de Caducidad</h2>

            <c:choose>
                <c:when test="${empty alimentosProximos}">
                    <!-- Empty state -->
                    <div class="bg-white p-6 rounded-xl shadow-lg border-l-4 border-green-500">
                        <div class="flex items-center gap-4">
                            <div class="bg-green-100 p-3 rounded-full">
                                <svg class="w-8 h-8 text-green-500" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                            </div>
                            <div>
                                <h3 class="font-bold text-lg">¡Tu inventario está vacío!</h3>
                                <p class="text-gray-600">
                                    <a href="${pageContext.request.contextPath}/AlimentoController?accion=registrar"
                                        class="text-green-600 hover:underline font-medium">
                                        Añade tu primer producto →
                                    </a>
                                </p>
                            </div>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Mostrar los 3 alimentos más próximos a caducar -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <c:forEach var="alimento" items="${alimentosProximos}" varStatus="status">
                            <c:set var="fechaActual" value="<%= new java.util.Date() %>" />
                            <c:set var="diferenciaMilis" value="${alimento.fechaCaducidad.time - fechaActual.time}" />
                            <c:set var="diasRestantes" value="${diferenciaMilis / (1000 * 60 * 60 * 24)}" />

                            <c:choose>
                                <c:when test="${diasRestantes <= 2}">
                                    <!-- Crítico (Rojo) -->
                                    <div
                                        class="bg-white p-4 rounded-xl shadow-lg border-l-4 border-red-500 flex items-center gap-4">
                                        <div class="bg-red-100 p-2 rounded-full">
                                            <svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor"
                                                viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                                            </svg>
                                        </div>
                                        <div>
                                            <h3 class="font-bold text-red-700">${alimento.nombre}</h3>
                                            <p class="text-sm text-gray-600">Caduca:
                                                <fmt:formatDate value="${alimento.fechaCaducidad}"
                                                    pattern="dd/MM/yyyy" />
                                            </p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:when test="${diasRestantes <= 5}">
                                    <!-- Advertencia (Amarillo) -->
                                    <div
                                        class="bg-white p-4 rounded-xl shadow-lg border-l-4 border-yellow-500 flex items-center gap-4">
                                        <div class="bg-yellow-100 p-2 rounded-full">
                                            <svg class="w-6 h-6 text-yellow-500" fill="none" stroke="currentColor"
                                                viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>
                                        </div>
                                        <div>
                                            <h3 class="font-bold text-yellow-700">${alimento.nombre}</h3>
                                            <p class="text-sm text-gray-600">Caduca:
                                                <fmt:formatDate value="${alimento.fechaCaducidad}"
                                                    pattern="dd/MM/yyyy" />
                                            </p>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <!-- Normal (Gris) -->
                                    <div
                                        class="bg-white p-4 rounded-xl shadow-lg border-l-4 border-gray-300 flex items-center gap-4">
                                        <div class="bg-gray-100 p-2 rounded-full">
                                            <svg class="w-6 h-6 text-gray-500" fill="none" stroke="currentColor"
                                                viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>
                                        </div>
                                        <div>
                                            <h3 class="font-bold">${alimento.nombre}</h3>
                                            <p class="text-sm text-gray-600">Caduca:
                                                <fmt:formatDate value="${alimento.fechaCaducidad}"
                                                    pattern="dd/MM/yyyy" />
                                            </p>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

        <!-- Recetas Sugeridas - 2 recetas basadas en ingredientes próximos a caducar -->
        <section class="mb-8">
            <h2 class="text-2xl font-semibold mb-4">Recetas Sugeridas</h2>

            <c:choose>
                <c:when test="${empty recetasSugeridas}">
                    <!-- Empty state -->
                    <div class="bg-white p-6 rounded-xl shadow-lg">
                        <div class="text-center">
                            <svg class="w-16 h-16 text-gray-400 mx-auto mb-4" fill="none" stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
                            </svg>
                            <h3 class="font-semibold text-lg text-gray-700 mb-2">No hay recetas disponibles
                            </h3>
                            <p class="text-gray-600">Añade productos a tu inventario para ver recetas
                                sugeridas</p>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Mostrar 2 recetas sugeridas -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <c:forEach var="recetaSugerida" items="${recetasSugeridas}">
                            <a href="${pageContext.request.contextPath}/RecetaController?accion=detalle&id=${recetaSugerida.receta.idReceta}"
                                class="bg-white rounded-2xl shadow-lg overflow-hidden hover:shadow-xl transition-shadow block">
                                <img src="${recetaSugerida.receta.imagenUrl}" alt="${recetaSugerida.receta.nombre}"
                                    class="w-full h-48 object-cover">
                                <div class="p-5">
                                    <h3 class="font-bold text-xl mb-2">${recetaSugerida.receta.nombre}</h3>

                                    <c:if test="${recetaSugerida.numeroIngredientesCoincidentes > 0}">
                                        <div class="bg-green-50 border border-green-200 rounded-lg p-2 mb-3">
                                            <p class="text-sm text-green-800">
                                                <strong>✓ Usa ingredientes próximos a caducar:</strong>
                                                ${recetaSugerida.ingredientesCoincidentesTexto}
                                            </p>
                                        </div>
                                    </c:if>

                                    <p class="text-gray-600 text-sm mb-3 line-clamp-2">
                                        ${recetaSugerida.receta.descripcion}</p>

                                    <!-- Quick Info -->
                                    <div class="flex items-center gap-4 text-xs text-gray-500 mb-3">
                                        <div class="flex items-center gap-1">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                                            </svg>
                                            <span>${recetaSugerida.receta.tiempoPreparacion} min</span>
                                        </div>
                                        <div class="flex items-center gap-1">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                                            </svg>
                                            <span>${recetaSugerida.receta.porciones} porción<c:if
                                                    test="${recetaSugerida.receta.porciones > 1}">es</c:if>
                                            </span>
                                        </div>
                                    </div>

                                    <p class="text-green-600 font-medium flex items-center gap-1">
                                        Ver receta completa
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M9 5l7 7-7 7" />
                                        </svg>
                                    </p>
                                </div>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </section>

    </main>

</body>

</html>