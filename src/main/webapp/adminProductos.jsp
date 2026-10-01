<%-- 
    Document   : adminProductos
    Created on : 30 set. 2026, 10:01:21 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>RICKZ - Administración de Productos</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <div class="container">
        <h2>Administración de Productos</h2>
        <a href="registroProductos.jsp" class="btn">+ Nuevo Producto</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Descripción</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Lomo Saltado RICKZ</td>
                    <td>Plato de fondo tradicional</td>
                    <td>38.00</td>
                    <td>40</td>
                    <td>
                        <button>Editar</button>
                        <button>Eliminar</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>