<%-- 
    Document   : index
    Created on : 30 set. 2026, 10:00:05 p. m.
    Author     : rickn
--%>
<%-- 
    Document   : index
    Created on : 30 set. 2026, 10:00:05 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Inicio</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%@page import="modelo.Cliente"%>
    <%
        Cliente usuario = (Cliente) session.getAttribute("usuario");
        boolean esAdmin = usuario != null && usuario.esAdmin();
    %>

    <section class="hero">
        <img class="hero-img" src="images/lomoSaltado.webp" alt="Lomo saltado">
        <div class="hero-content">
            <h2>Bienvenido a RICKZ</h2>
            <p>Plataforma inteligente para la gestión de restaurantes, menús digitales y pedidos personalizados.</p>
            <% if (esAdmin) { %>
            <a href="adminProductos.jsp" class="btn-pill btn-claro">Ver productos</a>
            <a href="adminUsuarios.jsp" class="btn-pill btn-borde">Ver usuarios</a>
            <% } else { %>
            <a href="menu.jsp" class="btn-pill btn-claro">Ver menú</a>
            <% } %>
        </div>
    </section>

    <% if (esAdmin) { %>
    <section class="banda">
        <span class="banda-texto">Panel de administración</span>
        <a href="registroUsuarios.jsp" class="btn-pill btn-claro">Registrar Cliente</a>
        <a href="registroProductos.jsp" class="btn-pill btn-claro">Registrar Producto</a>
    </section>
    <% } else { %>
    <section class="banda">
        <span class="banda-texto">¿Con hambre?</span>
        <a href="menu.jsp" class="btn-pill btn-claro">Ver el menú</a>
    </section>
    <% } %>

    <section class="seccion">
        <h2>Nuestros favoritos</h2>
        <p class="subtitulo">Los platos más pedidos</p>
        <div class="cards">
            <div class="card">
                <img src="images/papaAlaHuancaina.webp" alt="Papa a la huancaína">
                <div class="card-title">Papa a la Huancaína</div>
            </div>
            <div class="card">
                <img src="images/papaRellena.webp" alt="Papa rellena">
                <div class="card-title">Papa Rellena</div>
            </div>
            <div class="card">
                <img src="images/lomoSaltado.webp" alt="Lomo saltado">
                <div class="card-title">Lomo Saltado</div>
            </div>
        </div>
    </section>

    <%@include file="lib/footer.jsp" %>
</body>
</html>