<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,modelo.Categoria,dao.CategoriaDAO,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Registro de Producto</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        List<Categoria> categorias = null;
        String mensajeError = null;
        try {
            categorias = new CategoriaDAO().listar();
        } catch (Exception e) {
            e.printStackTrace();
            mensajeError = "No se pudieron cargar las categorías. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }

        String error = request.getParameter("error");
        if ("datos".equals(error)) {
            mensajeError = "El precio o el stock no son válidos. Escribe solo números.";
        } else if ("bd".equals(error)) {
            mensajeError = "No se pudo guardar el producto. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
    %>
    <div class="container">
        <h2>Registro de Producto / Plato</h2>
        <% if (mensajeError != null) { %>
        <p style="color:#b30000; font-weight:bold;"><%= mensajeError %></p>
        <% } %>
        <% if (categorias != null && categorias.isEmpty()) { %>
        <p style="color:#b30000; font-weight:bold;">No hay categorías en la base de datos. Agrega al menos una en la tabla categoria y recarga esta página.</p>
        <% } %>
        <form action="guardarProducto.jsp" method="post">
            <div class="form-group">
                <label>Nombre del producto:</label>
                <input type="text" name="nombre" maxlength="150" required>
            </div>
            <div class="form-group">
                <label>Descripción:</label>
                <textarea name="descripcion" rows="3"></textarea>
            </div>
            <div class="form-group">
                <label>Categoría:</label>
                <select name="idCategoria" required>
                    <option value="">Seleccione...</option>
                    <% if (categorias != null) {
                        for (Categoria cat : categorias) { %>
                    <option value="<%= cat.getIdCategoria() %>"><%= Texto.esc(cat.getNombre()) %></option>
                    <%  }
                       } %>
                </select>
            </div>
            <div class="form-group">
                <label>Precio:</label>
                <input type="number" step="0.01" min="0" name="precio" required>
            </div>
            <div class="form-group">
                <label>Cantidad en stock:</label>
                <input type="number" min="0" name="cantidadStock" required>
            </div>
            <button type="submit" class="btn">Guardar Producto</button>
        </form>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
