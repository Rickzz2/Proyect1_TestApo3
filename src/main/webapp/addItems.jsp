<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList,java.util.List,modelo.Categoria,gestion.GestionarProducto,gestion.GestionException,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Agregar ítem</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=3">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        List<Categoria> categorias = new ArrayList<>();
        String errorCategorias = null;
        try {
            categorias = new GestionarProducto().listarCategorias();
        } catch (GestionException e) {
            errorCategorias = e.getMessage();
        }
        String categoriaElegida = request.getParameter("idCategoria");
    %>
    <div class="container">
        <h2>Agregar ítem / producto</h2>
        <%@include file="lib/mensajes.jsp" %>
        <% if (errorCategorias != null) { %>
        <p class="mensaje-error"><%= Texto.esc(errorCategorias) %></p>
        <% } else if (categorias.isEmpty()) { %>
        <p class="mensaje-error">No hay categorías en la base de datos. Agrega al menos una en la tabla categoria y recarga esta página.</p>
        <% } %>
        <form action="ServletProductos" method="post">
            <input type="hidden" name="accion" value="agregar">
            <div class="form-group">
                <label>Código único del ítem (3 a 20 letras, números o guiones):</label>
                <input type="text" name="codigo" maxlength="20" minlength="3" pattern="[A-Za-z0-9_\-]{3,20}"
                       title="De 3 a 20 caracteres: letras, números, guion o guion bajo" placeholder="ITM-001"
                       value="<%= Texto.esc(request.getParameter("codigo")) %>" required>
            </div>
            <div class="form-group">
                <label>Nombre del producto:</label>
                <input type="text" name="nombre" maxlength="150" value="<%= Texto.esc(request.getParameter("nombre")) %>" required>
            </div>
            <div class="form-group">
                <label>Descripción:</label>
                <textarea name="descripcion" rows="3"><%= Texto.esc(request.getParameter("descripcion")) %></textarea>
            </div>
            <div class="form-group">
                <label>Categoría:</label>
                <select name="idCategoria" required>
                    <option value="">Seleccione...</option>
                    <% for (Categoria cat : categorias) { %>
                    <option value="<%= cat.getIdCategoria() %>" <%= String.valueOf(cat.getIdCategoria()).equals(categoriaElegida) ? "selected" : "" %>><%= Texto.esc(cat.getNombre()) %></option>
                    <% } %>
                </select>
            </div>
            <div class="form-group">
                <label>Precio:</label>
                <input type="number" step="0.01" min="0" name="precio" value="<%= Texto.esc(request.getParameter("precio")) %>" required>
            </div>
            <div class="form-group">
                <label>Cantidad en stock:</label>
                <input type="number" min="0" step="1" name="cantidadStock" value="<%= Texto.esc(request.getParameter("cantidadStock")) %>" required>
            </div>
            <div class="form-group">
                <label>Imagen (opcional): archivo de la carpeta images o enlace https</label>
                <input type="text" name="imagenUrl" maxlength="255" placeholder="images/ceviche.jpg" value="<%= Texto.esc(request.getParameter("imagenUrl")) %>">
            </div>
            <button type="submit" class="btn">Guardar producto</button>
            <a href="listItems.jsp" class="enlace-secundario">Volver al listado</a>
        </form>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
