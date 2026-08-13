<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Producto - Food Waste Fighter</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="bg-gray-50 text-gray-800">

    <!-- NAVBAR -->
    <jsp:include page="components/navbar.jsp" />

    <!-- MAIN CONTENT -->
    <main class="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
        <!-- Back button -->
        <a href="${pageContext.request.contextPath}/AlimentoController?accion=listar" class="inline-flex items-center gap-2 text-green-600 hover:text-green-700 font-medium mb-6">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
            </svg>
            Volver al Inventario
        </a>

        <h1 class="text-3xl font-bold text-center mb-8">Editar Producto</h1>
        
        <div class="max-w-lg mx-auto">
            <div class="bg-white p-8 rounded-xl shadow-lg">
                <form action="${pageContext.request.contextPath}/AlimentoController" method="post">
                    <input type="hidden" name="accion" value="actualizar">
                    <input type="hidden" name="idAlimento" value="${alimento.idAlimento}">
                    
                    <h3 class="text-xl font-semibold mb-6">Modificar Información del Producto</h3>
                    
                    <div class="mb-4">
                        <label for="nombre" class="block text-sm font-medium text-gray-700 mb-1">Nombre del Producto</label>
                        <input type="text" id="nombre" name="nombre" value="${alimento.nombre}" required 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>

                    <div class="mb-4">
                        <label for="categoria" class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
                        <select id="categoria" name="categoria" required 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500 bg-white">
                            <option value="">Selecciona una categoría</option>
                            <c:forEach var="cat" items="${categorias}">
                                <option value="${cat.idCategoria}" 
                                    <c:if test="${cat.idCategoria == alimento.categoria.idCategoria}">selected</c:if>>
                                    ${cat.nombre}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <div class="mb-4">
                        <label for="fechaCaducidad" class="block text-sm font-medium text-gray-700 mb-1">Fecha de Caducidad</label>
                        <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="yyyy-MM-dd" var="fechaFormateada"/>
                        <input type="date" id="fechaCaducidad" name="fechaCaducidad" value="${fechaFormateada}" required 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>

                    <div class="mb-6">
                        <label for="cantidad" class="block text-sm font-medium text-gray-700 mb-1">Cantidad</label>
                        <input type="text" id="cantidad" name="cantidad" value="${alimento.cantidad}" 
                            placeholder="ej. 2 litros, 5 unidades" 
                            class="w-full px-4 py-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-green-500">
                    </div>

                    <div class="flex gap-3">
                        <button type="submit" class="flex-1 bg-green-600 text-white py-3 rounded-lg font-semibold hover:bg-green-700 transition-colors">
                            Guardar Cambios
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
