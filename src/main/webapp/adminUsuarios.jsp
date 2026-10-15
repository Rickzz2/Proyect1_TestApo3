<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List,modelo.Cliente,dao.ClienteDAO,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Administración de Usuarios</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        List<Cliente> clientes = null;
        String errorBd = null;
        try {
            clientes = new ClienteDAO().listar();
        } catch (Exception e) {
            e.printStackTrace();
            errorBd = "No se pudo leer la lista de clientes. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
    %>
    <div class="container">
        <h2>Administración de Clientes / Usuarios</h2>
        <a href="registroUsuarios.jsp" class="btn">+ Nuevo Cliente</a>
        <% if (errorBd != null) { %>
        <p style="color:#b30000; font-weight:bold;"><%= errorBd %></p>
        <% } %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Apellidos</th>
                    <th>Correo</th>
                    <th>Teléfono</th>
                    <th>Dirección</th>
                </tr>
            </thead>
            <tbody>
                <% if (clientes == null || clientes.isEmpty()) { %>
                <tr>
                    <td colspan="6">Aún no hay clientes registrados.</td>
                </tr>
                <% } else {
                    for (Cliente c : clientes) { %>
                <tr>
                    <td><%= c.getIdCliente() %></td>
                    <td><%= Texto.esc(c.getNombre()) %></td>
                    <td><%= Texto.esc(c.getApellidos()) %></td>
                    <td><%= Texto.esc(c.getCorreo()) %></td>
                    <td><%= Texto.esc(c.getTelefono()) %></td>
                    <td><%= Texto.esc(c.getDireccion()) %></td>
                </tr>
                <%  }
                   } %>
            </tbody>
        </table>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
