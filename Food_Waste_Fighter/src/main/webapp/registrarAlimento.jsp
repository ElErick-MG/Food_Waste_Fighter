<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Registrar Alimento</title>
</head>
<body>
    <h1>Registrar Nuevo Alimento</h1>
    
    <form action="AlimentoController" method="post">
        <input type="hidden" name="accion" value="guardar">
        
        <label for="nombre">Nombre:</label><br>
        <input type="text" id="nombre" name="nombre" required><br><br>
        
        <label for="categoria">Categoría:</label><br>
        <select id="categoria" name="categoria" required>
            <option value="">Seleccione una categoría</option>
            <c:forEach var="cat" items="${categorias}">
                <option value="${cat.idCategoria}">${cat.nombre}</option>
            </c:forEach>
        </select><br><br>
        
        <label for="fechaCaducidad">Fecha de Caducidad:</label><br>
        <input type="date" id="fechaCaducidad" name="fechaCaducidad" required><br><br>
        
        <label for="cantidad">Cantidad:</label><br>
        <input type="text" id="cantidad" name="cantidad" required><br><br>
        
        <button type="submit">Guardar</button>
        <a href="AlimentoController?accion=listar">Cancelar</a>
    </form>
</body>
</html>
