<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Editar Alimento</title>
</head>
<body>
    <h1>Editar Alimento</h1>
    
    <form action="AlimentoController" method="post">
        <input type="hidden" name="accion" value="guardar">
        <input type="hidden" name="idAlimento" value="${alimento.idAlimento}">
        
        <label for="nombre">Nombre:</label><br>
        <input type="text" id="nombre" name="nombre" value="${alimento.nombre}" required><br><br>
        
        <label for="categoria">Categoría:</label><br>
        <select id="categoria" name="categoria" required>
            <c:forEach var="cat" items="${categorias}">
                <option value="${cat.idCategoria}" 
                    <c:if test="${cat.idCategoria == alimento.categoria.idCategoria}">selected</c:if>>
                    ${cat.nombre}
                </option>
            </c:forEach>
        </select><br><br>
        
        <label for="fechaCaducidad">Fecha de Caducidad:</label><br>
        <fmt:formatDate value="${alimento.fechaCaducidad}" pattern="yyyy-MM-dd" var="fechaFormateada"/>
        <input type="date" id="fechaCaducidad" name="fechaCaducidad" value="${fechaFormateada}" required><br><br>
        
        <label for="cantidad">Cantidad:</label><br>
        <input type="text" id="cantidad" name="cantidad" value="${alimento.cantidad}" required><br><br>
        
        <button type="submit">Guardar Cambios</button>
        <a href="AlimentoController?accion=listar">Cancelar</a>
    </form>
</body>
</html>
