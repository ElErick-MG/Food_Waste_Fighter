<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lista de Alimentos</title>
</head>
<body>
    <h1>Lista de Alimentos</h1>
    
    <a href="AlimentoController?accion=registrar">Agregar Nuevo Alimento</a>
    <a href="GestorCaducidadController?accion=consultar">Ver Productos por Caducar</a>
    
    <br><br>
    
    <table border="1">
        <thead>
            <tr>
                <th>Nombre</th>
                <th>Categoría</th>
                <th>Fecha de Caducidad</th>
                <th>Cantidad</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="alimento" items="${alimentos}">
                <tr>
                    <td>${alimento.nombre}</td>
                    <td>${alimento.categoria.nombre}</td>
                    <td><fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></td>
                    <td>${alimento.cantidad}</td>
                    <td>
                        <a href="AlimentoController?accion=editar&id=${alimento.idAlimento}">Editar</a>
                        <a href="AlimentoController?accion=eliminar&id=${alimento.idAlimento}">Eliminar</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
