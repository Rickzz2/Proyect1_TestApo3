<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList,java.util.List,modelo.Cliente,gestion.GestionarCliente,gestion.GestionException,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Usuarios</title>
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
        List<Cliente> clientes = new ArrayList<>();
        Cliente editando = null;
        String errorLectura = null;
        try {
            GestionarCliente gestor = new GestionarCliente();
            clientes = gestor.filtrar(campo, q);
            String idEditar = request.getParameter("editar");
            if (idEditar != null) {
                try {
                    editando = gestor.buscarPorId(Integer.parseInt(idEditar));
                } catch (NumberFormatException ex) {
                    editando = null;
                }
            }
        } catch (GestionException e) {
            errorLectura = e.getMessage();
        }
    %>
    <div class="container container-ancho">
        <h2>Clientes / Usuarios</h2>
        <%@include file="lib/mensajes.jsp" %>
        <% if (errorLectura != null) { %>
        <p class="mensaje-error"><%= Texto.esc(errorLectura) %></p>
        <% } %>

        <% if (editando != null) { %>
        <div class="panel-edicion">
            <h3>Editar cliente #<%= editando.getIdCliente() %></h3>
            <form action="ServletClientes" method="post">
                <input type="hidden" name="accion" value="actualizar">
                <input type="hidden" name="id" value="<%= editando.getIdCliente() %>">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Código único:</label>
                        <input type="text" name="codigo" maxlength="20" minlength="3" pattern="[A-Za-z0-9_\-]{3,20}"
                               title="De 3 a 20 caracteres: letras, números, guion o guion bajo"
                               value="<%= Texto.esc(editando.getCodigo()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Nombre:</label>
                        <input type="text" name="nombre" maxlength="100" value="<%= Texto.esc(editando.getNombre()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Apellidos:</label>
                        <input type="text" name="apellidos" maxlength="100" value="<%= Texto.esc(editando.getApellidos()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Correo electrónico:</label>
                        <input type="email" name="correo" maxlength="150" value="<%= Texto.esc(editando.getCorreo()) %>" required>
                    </div>
                    <div class="form-group">
                        <label>Teléfono:</label>
                        <input type="tel" name="telefono" maxlength="20" value="<%= Texto.esc(editando.getTelefono()) %>">
                    </div>
                    <div class="form-group">
                        <label>Contraseña nueva (déjala vacía para no cambiarla):</label>
                        <input type="password" name="password" minlength="6">
                    </div>
                </div>
                <div class="form-group">
                    <label>Dirección:</label>
                    <textarea name="direccion" rows="2"><%= Texto.esc(editando.getDireccion()) %></textarea>
                </div>
                <button type="submit" class="btn">Guardar cambios</button>
                <a href="listUsers.jsp" class="enlace-secundario">Cancelar</a>
            </form>
        </div>
        <% } %>

        <div class="barra-herramientas">
            <form action="listUsers.jsp" method="get" class="form-inline">
                <label>Filtrar por:</label>
                <select name="campo">
                    <option value="codigo" <%= "codigo".equals(campo) ? "selected" : "" %>>Código</option>
                    <option value="nombre" <%= "nombre".equals(campo) ? "selected" : "" %>>Nombre</option>
                    <option value="apellidos" <%= "apellidos".equals(campo) ? "selected" : "" %>>Apellidos</option>
                    <option value="correo" <%= "correo".equals(campo) ? "selected" : "" %>>Correo</option>
                </select>
                <input type="text" name="q" value="<%= Texto.esc(q) %>" placeholder="Texto a buscar">
                <button type="submit" class="btn btn-sm">Filtrar</button>
                <a href="listUsers.jsp" class="enlace-secundario">Limpiar</a>
            </form>
            <a href="addUsers.jsp" class="btn">+ Nuevo cliente</a>
        </div>

        <p class="conteo"><%= clientes.size() %> cliente(s)</p>
        <div class="tabla-scroll">
            <table>
                <thead>
                    <tr>
                        <th>Código</th>
                        <th>Nombre</th>
                        <th>Apellidos</th>
                        <th>Correo</th>
                        <th>Teléfono</th>
                        <th>Dirección</th>
                        <th>Rol</th>
                        <th>Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (clientes.isEmpty()) { %>
                    <tr>
                        <td colspan="8">No hay clientes que coincidan.</td>
                    </tr>
                    <% } else {
                        for (Cliente c : clientes) { %>
                    <tr>
                        <td><%= Texto.esc(c.getCodigo()) %></td>
                        <td><%= Texto.esc(c.getNombre()) %></td>
                        <td><%= Texto.esc(c.getApellidos()) %></td>
                        <td><%= Texto.esc(c.getCorreo()) %></td>
                        <td><%= Texto.esc(c.getTelefono()) %></td>
                        <td><%= Texto.esc(c.getDireccion()) %></td>
                        <td><%= Texto.esc(c.getRol()) %></td>
                        <td class="acciones">
                            <a href="listUsers.jsp?editar=<%= c.getIdCliente() %>" class="btn btn-sm">Editar</a>
                            <form action="ServletClientes" method="post" class="form-inline"
                                  onsubmit="return confirm('¿Eliminar a este cliente? Esta acción no se puede deshacer.');">
                                <input type="hidden" name="accion" value="eliminar">
                                <input type="hidden" name="id" value="<%= c.getIdCliente() %>">
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
