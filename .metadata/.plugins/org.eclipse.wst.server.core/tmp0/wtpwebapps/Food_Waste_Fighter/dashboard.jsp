<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - Inventario de Alimentos</title>
    <style>
        .alerta-caducidad { 
            background-color: #ff6b6b; 
            padding: 15px; 
            border-radius: 5px; 
            margin: 10px 0;
        }
    </style>
</head>
<body>
    <h1>Dashboard - Inventario de Alimentos</h1>
    
    <nav>
        <a href="AlimentoController?accion=listar">Ver Lista de Alimentos</a> |
        <a href="AlimentoController?accion=registrar">Registrar Alimento</a> |
        <a href="GestorCaducidadController?accion=consultar">Productos por Caducar</a>
    </nav>
    
    <hr>
    
    <!-- Sección: Próximos a Caducar -->
    <c:if test="${not empty alimentosProximosACaducar}">
        <div class="alerta-caducidad">
            <h2>⚠️ Productos Próximos a Caducar</h2>
            <ul>
                <c:forEach var="alimento" items="${alimentosProximosACaducar}">
                    <li>
                        <strong>${alimento.nombre}</strong> - 
                        Caduca: <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/>
                    </li>
                </c:forEach>
            </ul>
            <a href="GestorCaducidadController?accion=consultar">Ver todos los productos por caducar</a>
        </div>
    </c:if>
</body>
</html>
