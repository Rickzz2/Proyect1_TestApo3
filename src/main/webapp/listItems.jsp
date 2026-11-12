<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList,java.util.List,java.util.Locale,modelo.Categoria,modelo.Producto,gestion.GestionarProducto,gestion.GestionException,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Ítems</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=3">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        String campo = request.getParameter("campo");
        if (campo == null) {
            campo = "nombre";
        }
        String q = request.getParameter("q");
        if (q == null) {
            q = "";
        }
        List<Producto> productos = new ArrayList<>();
        List<Categoria> categorias = new ArrayList<>();
        Producto editando = null;
        String errorLectura = null;
        try {
            GestionarProducto gestor = new GestionarProducto();
            productos = gestor.filtrar(campo, q);
            String idEditar = request.getParameter("editar");
            if (idEditar != null) {
                try {
                    editando = gestor.buscarPorId(Integer.parseInt(idEditar));
                } catch (NumberFormatException ex) {
                    editando = null;
                }
                if (editando != null) {
                    categorias = gestor.listarCategorias();
                }
            }
        } catch (GestionException e) {
            errorLectura = e.getMessage();
        }
    %>
    <div class="container container-ancho">
        <h2>Ítems / Productos</h2>
        <%@include file="lib/mensajes.jsp" %>
        <% if (errorLectura != null) { %>
        <p class="mensaje-error"><%= Texto.esc(errorLectura) %></p>
        <% } %>

        <% if (editando != null) { %>
        <div class="panel-edicion">
            <h3>Editar ítem #<%= editando.getIdProducto() %></h3>
            <form action="ServletProductos" method="post">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="id" value="<%= editando.getIdProducto() %>">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Código único:</label>
                        <input type="text" name="codigo" maxlength="20" minlength="3" pattern="[A-Za-z0-9_\-]{3,20}"
                               title="De 3 a 20 caracteres: letras, números, guion o guion bajo"
                               value="<%= Texto.esc(editando.getCodigo()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Nombre:</label>
                        <input type="text" name="nombre" maxlength="150" value="<%= Texto.esc(editando.getNombre()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Categoría:</label>
                        <select name="idCategoria" required>
                            <% for (Categoria cat : categorias) { %>
                            <option value="<%= cat.getIdCategoria() %>" <%= cat.getIdCategoria() == editando.getIdCategoria() ? "selected" : "" %>><%= Texto.esc(cat.getNombre()) %></option>
                            <% } %>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Precio:</label>
                        <input type="number" step="0.01" min="0" name="precio" value="<%= String.format(Locale.US, "%.2f", editando.getPrecio()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Stock:</label>
                        <input type="number" min="0" step="1" name="cantidadStock" value="<%= editando.getCantidadStock() %>" required>
                    </div>
                    <div class="form-group">
                        <label>Imagen (images/archivo.jpg o https://...):</label>
                        <input type="text" name="imagenUrl" maxlength="255" value="<%= Texto.esc(editando.getImagenUrl()) %>">
                    </div>
                </div>
                <div class="form-group">
                    <label>Descripción:</label>
                    <textarea name="descripcion" rows="2"><%= Texto.esc(editando.getDescripcion()) %></textarea>
                </div>
                <button type="submit" class="btn">Guardar cambios</button>
                <a href="listItems.jsp" class="enlace-secundario">Cancelar</a>
            </form>
        </div>
        <% } %>

        <div class="barra-herramientas">
            <form action="listItems.jsp" method="get" class="form-inline">
                <label>Filtrar por:</label>
                <select name="campo">
                    <option value="codigo" <%= "codigo".equals(campo) ? "selected" : "" %>>Código</option>
                    <option value="nombre" <%= "nombre".equals(campo) ? "selected" : "" %>>Nombre</option>
                    <option value="categoria" <%= "categoria".equals(campo) ? "selected" : "" %>>Categoría</option>
                </select>
                <input type="text" name="q" value="<%= Texto.esc(q) %>" placeholder="Texto a buscar">
                <button type="submit" class="btn btn-sm">Filtrar</button>
                <a href="listItems.jsp" class="enlace-secundario">Limpiar</a>
            </form>
            <a href="addItems.jsp" class="btn">+ Nuevo ítem</a>
        </div>

        <p class="conteo"><%= productos.size() %> ítem(s)</p>
        <div class="tabla-scroll">
            <table>
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Nombre</th>
                        <th>Categoría</th>
                        <th>Descripción</th>
                        <th>Precio</th>
                        <th>Stock</th>
                        <th>Disponible</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (productos.isEmpty()) { %>
                    <tr>
                        <td colspan="8">No hay ítems que coincidan.</td>
                    </tr>
                    <% } else {
                        for (Producto p : productos) { %>
                    <tr>
                        <td><%= Texto.esc(p.getCodigo()) %></td>
                        <td><%= Texto.esc(p.getNombre()) %></td>
                        <td><%= Texto.esc(p.getNombreCategoria()) %></td>
                        <td><%= Texto.esc(p.getDescripcion()) %></td>
                        <td><%= String.format(Locale.US, "%.2f", p.getPrecio()) %></td>
                        <td><%= p.getCantidadStock() %></td>
                        <td><%= p.isDisponibilidad() ? "Sí" : "No" %></td>
                        <td class="acciones">
                            <a href="listItems.jsp?editar=<%= p.getIdProducto() %>" class="btn btn-sm">Editar</a>
                            <form action="ServletProductos" method="post" class="form-inline"
                                  onsubmit="return confirm('¿Eliminar este ítem? Esta acción no se puede deshacer.');">
                                <input type="hidden" name="accion" value="eliminar">
                                <input type="hidden" name="id" value="<%= p.getIdProducto() %>">
                                <button type="submit" class="btn btn-sm btn-peligro">Eliminar</button>
                            </form>
                        </td>
                    </tr>
                    <%  }
                       } %>
                </tbody>
            </table>
        </div>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
