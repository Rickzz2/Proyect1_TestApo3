<%-- 
    Document   : index
    Created on : 30 set. 2026, 10:00:05 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>RICKZ - Inicio</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <div class="container">
        <h2>Bienvenido a RICKZ</h2>
        <p>Plataforma inteligente para la gestión de restaurantes, menús digitales y pedidos personalizados.</p>
        <div style="margin-top: 20px;">
            <a href="registroUsuarios.jsp" class="btn">Registrar Cliente</a>
            <a href="registroProductos.jsp" class="btn">Registrar Producto</a>
        </div>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>