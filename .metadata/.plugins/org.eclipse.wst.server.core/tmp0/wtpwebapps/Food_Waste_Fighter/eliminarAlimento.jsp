<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Eliminar Alimento</title>
</head>
<body>
    <h1>Confirmar Eliminación</h1>
    
    <p>¿Está seguro de que desea eliminar el siguiente alimento?</p>
    
    <table border="1">
        <tr>
            <th>Nombre</th>
            <td>${alimento.nombre}</td>
        </tr>
        <tr>
            <th>Categoría</th>
            <td>${alimento.categoria.nombre}</td>
        </tr>
        <tr>
            <th>Fecha de Caducidad</th>
            <td><fmt:formatDate value="${alimento.fechaCaducidad}" pattern="dd/MM/yyyy"/></td>
        </tr>
        <tr>
            <th>Cantidad</th>
            <td>${alimento.cantidad}</td>
        </tr>
    </table>
    
    <br>
    
    <form action="AlimentoController" method="post">
        <input type="hidden" name="accion" value="confirmar">
        <input type="hidden" name="idAlimento" value="${alimento.idAlimento}">
        
        <button type="submit">Confirmar Eliminación</button>
        <a href="AlimentoController?accion=listar">Cancelar</a>
    </form>
</body>
</html>
