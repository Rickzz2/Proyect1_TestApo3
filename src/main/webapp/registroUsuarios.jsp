<%-- 
    Document   : registroUsuarios
    Created on : 30 set. 2026, 10:01:01 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>RICKZ - Registro de Producto</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <div class="container">
        <h2>Registro de Producto / Plato</h2>
        <form action="adminProductos.jsp" method="get">
            <div class="form-group">
                <label>Nombre del Producto:</label>
                <input type="text" name="nombre" required>
            </div>
            <div class="form-group">
                <label>Descripción:</label>
                <textarea name="descripcion" rows="3"></textarea>
            </div>
            <div class="form-group">
                <label>Precio:</label>
                <input type="number" step="0.01" name="precio" required>
            </div>
            <div class="form-group">
                <label>Cantidad en Stock:</label>
                <input type="number" name="cantidadStock" required>
            </div>
            <button type="submit" class="btn">Guardar Producto</button>
        </form>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>