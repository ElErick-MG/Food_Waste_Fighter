<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${receta.nombre} - Food Waste Fighter</title>
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
    <main class="max-w-4xl mx-auto p-4 sm:p-6 lg:p-8">
        <div class="page-transition">
            <!-- Back Button -->
            <a href="${pageContext.request.contextPath}/RecetaController?accion=listar" class="inline-flex items-center gap-2 text-green-600 hover:text-green-700 font-medium mb-6">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                </svg>
                Volver a Recetas
            </a>

            <!-- Recipe Image -->
            <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
                <img src="${receta.imagenUrl}" alt="${receta.nombre}" class="w-full h-80 object-cover">
            </div>

            <!-- Title and Description -->
            <div class="recipe-card">
                <h1 class="text-4xl font-bold mb-4">${receta.nombre}</h1>
                <p class="text-gray-600 text-lg mb-6">${receta.descripcion}</p>
                
                <!-- Quick Info -->
                <div class="grid grid-cols-3 gap-4 pt-6 border-t border-gray-200">
                    <div class="quick-info-item">
                        <svg class="quick-info-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <p class="font-semibold text-gray-800">${receta.tiempoPreparacion} min</p>
                        <p class="text-sm text-gray-600">Preparación</p>
                    </div>
                    <div class="quick-info-item">
                        <svg class="quick-info-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <p class="font-semibold text-gray-800">${receta.porciones} porción<c:if test="${receta.porciones > 1}">es</c:if></p>
                        <p class="text-sm text-gray-600">Rinde</p>
                    </div>
                    <div class="quick-info-item">
                        <svg class="quick-info-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
                        </svg>
                        <p class="font-semibold text-gray-800">${receta.dificultad}</p>
                        <p class="text-sm text-gray-600">Dificultad</p>
                    </div>
                </div>
            </div>

            <!-- Ingredients -->
            <div class="recipe-card">
                <h2 class="text-2xl font-bold mb-4 flex items-center gap-2">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-6 9l2 2 4-4"/>
                    </svg>
                    Ingredientes
                </h2>
                <p class="text-sm text-gray-600 mb-4">Los ingredientes marcados con ✓ están disponibles en tu inventario</p>
                
                <ul class="space-y-3">
                    <c:forEach var="ingrediente" items="${ingredientes}">
                        <li class="ingredient-item">
                            <c:choose>
                                <c:when test="${ingredientesDisponibles[ingrediente.idIngrediente]}">
                                    <span class="ingredient-check available">
                                        <svg fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                        </svg>
                                    </span>
                                    <span class="text-gray-700">${ingrediente.cantidad} de <strong>${ingrediente.nombre}</strong> (de tu inventario)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="ingredient-check unavailable">
                                        <svg fill="currentColor" viewBox="0 0 20 20">
                                            <path fill-rule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clip-rule="evenodd"/>
                                        </svg>
                                    </span>
                                    <span class="text-gray-700">${ingrediente.cantidad} de ${ingrediente.nombre}</span>
                                </c:otherwise>
                            </c:choose>
                        </li>
                    </c:forEach>
                </ul>
            </div>

            <!-- Preparation Steps -->
            <div class="recipe-card">
                <h2 class="text-2xl font-bold mb-6 flex items-center gap-2">
                    <svg class="w-6 h-6 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                    </svg>
                    Preparación
                </h2>
                
                <div class="space-y-6">
                    <c:forEach var="paso" items="${pasos}">
                        <div class="preparation-step">
                            <div class="step-number">${paso.numeroPaso}</div>
                            <div class="flex-1 pt-1">
                                <h3 class="font-semibold text-lg mb-2">${paso.titulo}</h3>
                                <p class="text-gray-600">${paso.descripcion}</p>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Nutritional Information -->
            <c:if test="${not empty infoNutricional}">
                <div class="recipe-card">
                    <h2 class="text-2xl font-bold mb-6">Información Nutricional (por porción)</h2>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-6">
                        <div class="nutrition-item">
                            <p class="nutrition-value">${infoNutricional.calorias}</p>
                            <p class="nutrition-label">Calorías</p>
                        </div>
                        <div class="nutrition-item">
                            <p class="nutrition-value">${infoNutricional.grasas}g</p>
                            <p class="nutrition-label">Grasas</p>
                        </div>
                        <div class="nutrition-item">
                            <p class="nutrition-value">${infoNutricional.carbohidratos}g</p>
                            <p class="nutrition-label">Carbohidratos</p>
                        </div>
                        <div class="nutrition-item">
                            <p class="nutrition-value">${infoNutricional.proteinas}g</p>
                            <p class="nutrition-label">Proteínas</p>
                        </div>
                    </div>
                </div>
            </c:if>

            <!-- Tips Card -->
            <div class="tips-card">
                <h2 class="text-2xl font-bold mb-4 flex items-center gap-2 text-green-800">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9.663 17h4.673M12 3v1m6.364 1.636l-.707.707M21 12h-1M4 12H3m3.343-5.657l-.707-.707m2.828 9.9a5 5 0 117.072 0l-.548.547A3.374 3.374 0 0014 18.469V19a2 2 0 11-4 0v-.531c0-.895-.356-1.754-.988-2.386l-.548-.547z"/>
                    </svg>
                    Consejo
                </h2>
                <p class="text-gray-700">
                    Esta receta te ayuda a aprovechar los ingredientes de tu inventario que están próximos a caducar. 
                    Al preparar esta receta, estarás contribuyendo a reducir el desperdicio de alimentos y ahorrando dinero.
                </p>
            </div>

        </div>
    </main>

</body>
</html>
