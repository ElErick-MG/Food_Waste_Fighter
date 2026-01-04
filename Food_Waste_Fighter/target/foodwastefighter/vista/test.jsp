<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Test de Configuración</title>
</head>
<body>
    <h1>✅ El servidor está funcionando correctamente</h1>
    <p><strong>Context Path:</strong> <%= request.getContextPath() %></p>
    <p><strong>Server Info:</strong> <%= application.getServerInfo() %></p>
    <p><strong>Real Path:</strong> <%= application.getRealPath("/") %></p>
    
    <h2>Enlaces de prueba:</h2>
    <ul>
        <li><a href="<%= request.getContextPath() %>/AlimentoServlet?action=listar">Ver Inventario</a></li>
        <li><a href="<%= request.getContextPath() %>/AlimentoServlet?action=nuevo">Añadir Producto</a></li>
        <li><a href="<%= request.getContextPath() %>/AlimentoServlet?action=porCaducar">Productos por Caducar</a></li>
    </ul>
</body>
</html>