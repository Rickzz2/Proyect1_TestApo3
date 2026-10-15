<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,java.util.Locale,modelo.Producto,dao.ProductoDAO,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Administración de Productos</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
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
            errorBd = "No se pudo leer la lista de productos. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
    %>
    <div class="container">
        <h2>Administración de Productos</h2>
        <a href="registroProductos.jsp" class="btn">+ Nuevo Producto</a>
        <% if (errorBd != null) { %>
        <p style="color:#b30000; font-weight:bold;"><%= errorBd %></p>
        <% } %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Categoría</th>
                    <th>Descripción</th>
                    <th>Precio</th>
                    <th>Stock</th>
                    <th>Disponible</th>
                </tr>
            </thead>
            <tbody>
                <% if (productos == null || productos.isEmpty()) { %>
                <tr>
                    <td colspan="7">Aún no hay productos registrados.</td>
                </tr>
                <% } else {
                    for (Producto p : productos) { %>
                <tr>
                    <td><%= p.getIdProducto() %></td>
                    <td><%= Texto.esc(p.getNombre()) %></td>
                    <td><%= Texto.esc(p.getNombreCategoria()) %></td>
                    <td><%= Texto.esc(p.getDescripcion()) %></td>
                    <td><%= String.format(Locale.US, "%.2f", p.getPrecio()) %></td>
                    <td><%= p.getCantidadStock() %></td>
                    <td><%= p.isDisponibilidad() ? "Sí" : "No" %></td>
                </tr>
                <%  }
                   } %>
            </tbody>
        </table>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
