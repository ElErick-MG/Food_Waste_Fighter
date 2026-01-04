<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Productos por Caducar</title>
    <style>
        .etiqueta-roja { background-color: #ff6b6b; }
        .etiqueta-amarilla { background-color: #ffd93d; }
        .etiqueta-gris { background-color: #d3d3d3; }
        table { border-collapse: collapse; width: 100%; margin-bottom: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        h2 { margin-top: 20px; }
    </style>
</head>
<body>
    <h1>Productos por Caducar</h1>
    
    <a href="AlimentoController?accion=listar">Volver a Lista de Alimentos</a>
    
    <!-- Productos con etiqueta ROJA (1-2 días) -->
    <h2 class="etiqueta-roja" style="padding: 10px;">⚠️ Caducidad Próxima (1-2 días)</h2>
    <table>
        <thead>
            <tr class="etiqueta-roja">
                <th>Producto</th>
                <th>Categoría</th>
                <th>Fecha de Caducidad</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="alimento" items="${alimentosRojos}">
                <tr class="etiqueta-roja">
                    <td>${alimento.nombre}</td>
                    <td>${alimento.categoria.nombre}</td>
                    <td><fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty alimentosRojos}">
                <tr><td colspan="3">No hay productos en esta categoría</td></tr>
            </c:if>
        </tbody>
    </table>
    
    <!-- Productos con etiqueta AMARILLA (3-5 días) -->
    <h2 class="etiqueta-amarilla" style="padding: 10px;">⏰ Caducidad Cercana (3-5 días)</h2>
    <table>
        <thead>
            <tr class="etiqueta-amarilla">
                <th>Producto</th>
                <th>Categoría</th>
                <th>Fecha de Caducidad</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="alimento" items="${alimentosAmarillos}">
                <tr class="etiqueta-amarilla">
                    <td>${alimento.nombre}</td>
                    <td>${alimento.categoria.nombre}</td>
                    <td><fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty alimentosAmarillos}">
                <tr><td colspan="3">No hay productos en esta categoría</td></tr>
            </c:if>
        </tbody>
    </table>
    
    <!-- Productos con etiqueta GRIS (más de 6 días) -->
    <h2 class="etiqueta-gris" style="padding: 10px;">✓ Caducidad Lejana (más de 6 días)</h2>
    <table>
        <thead>
            <tr class="etiqueta-gris">
                <th>Producto</th>
                <th>Categoría</th>
                <th>Fecha de Caducidad</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="alimento" items="${alimentosGrises}">
                <tr class="etiqueta-gris">
                    <td>${alimento.nombre}</td>
                    <td>${alimento.categoria.nombre}</td>
                    <td><fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty alimentosGrises}">
                <tr><td colspan="3">No hay productos en esta categoría</td></tr>
            </c:if>
        </tbody>
    </table>
</body>
</html>
