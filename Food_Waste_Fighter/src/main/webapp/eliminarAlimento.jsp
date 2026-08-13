<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Eliminar Producto - Food Waste Fighter</title>
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

        <div class="max-w-lg mx-auto">
            <div class="bg-white p-8 rounded-xl shadow-lg">
                <!-- Warning icon -->
                <div class="flex justify-center mb-6">
                    <div class="bg-red-100 p-4 rounded-full">
                        <svg class="w-12 h-12 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                        </svg>
                    </div>
                </div>
                
                <h1 class="text-2xl font-bold text-center mb-2">¿Eliminar Producto?</h1>
                <p class="text-gray-600 text-center mb-6">Esta acción no se puede deshacer</p>
                
                <!-- Product details -->
                <div class="bg-gray-50 rounded-xl p-4 mb-6">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <p class="text-sm text-gray-500">Nombre</p>
                            <p class="font-semibold">${alimento.nombre}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Categoría</p>
                            <p class="font-semibold">${alimento.categoria.nombre}</p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Fecha de Caducidad</p>
                            <p class="font-semibold"><fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></p>
                        </div>
                        <div>
                            <p class="text-sm text-gray-500">Cantidad</p>
                            <p class="font-semibold">${alimento.cantidad}</p>
                        </div>
                    </div>
                </div>
                
                <!-- Action buttons -->
                <form action="${pageContext.request.contextPath}/AlimentoController" method="post">
                    <input type="hidden" name="accion" value="confirmar">
                    <input type="hidden" name="idAlimento" value="${alimento.idAlimento}">
                    
                    <div class="flex gap-3">
                        <button type="submit" class="flex-1 bg-red-600 text-white py-3 rounded-lg font-semibold hover:bg-red-700 transition-colors">
                            Sí, Eliminar
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
