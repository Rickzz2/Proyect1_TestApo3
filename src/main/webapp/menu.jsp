<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Locale,modelo.Producto,dao.ProductoDAO,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Menú</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        List<Producto> productos = null;
        String errorBd = null;
        try {
            productos = new ProductoDAO().listar();
        } catch (Exception e) {
            e.printStackTrace();
            errorBd = "No se pudo cargar el menú. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
        int disponibles = 0;
        if (productos != null) {
            for (Producto p : productos) {
                if (p.isDisponibilidad()) {
                    disponibles++;
                }
            }
        }
    %>
    <section class="seccion">
        <h2>Nuestro menú</h2>
        <% if (errorBd != null) { %>
        <p class="mensaje-error"><%= errorBd %></p>
        <% } else if (disponibles == 0) { %>
        <p style="text-align:center;">El menú todavía no tiene platos disponibles.</p>
        <% } else { %>
        <div class="menu-lista">
            <% for (Producto p : productos) {
                if (!p.isDisponibilidad()) {
                    continue;
                } %>
            <div class="menu-item">
                <span class="menu-categoria"><%= Texto.esc(p.getNombreCategoria()) %></span>
                <h3><%= Texto.esc(p.getNombre()) %></h3>
                <p><%= Texto.esc(p.getDescripcion()) %></p>
                <div class="menu-precio">$ <%= String.format(Locale.US, "%.2f", p.getPrecio()) %></div>
            </div>
            <% } %>
        </div>
        <% } %>
    </section>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
