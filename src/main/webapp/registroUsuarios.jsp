<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Registro de Cliente</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        String error = request.getParameter("error");
        String mensajeError = null;
        if ("correo".equals(error)) {
            mensajeError = "Ese correo ya está registrado. Usa otro correo.";
        } else if ("bd".equals(error)) {
            mensajeError = "No se pudo guardar el cliente. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
    %>
    <div class="container">
        <h2>Registro de Cliente</h2>
        <% if (mensajeError != null) { %>
        <p style="color:#b30000; font-weight:bold;"><%= mensajeError %></p>
        <% } %>
        <form action="guardarCliente.jsp" method="post">
            <div class="form-group">
                <label>Nombre:</label>
                <input type="text" name="nombre" maxlength="100" required>
            </div>
            <div class="form-group">
                <label>Apellidos:</label>
                <input type="text" name="apellidos" maxlength="100" required>
            </div>
            <div class="form-group">
                <label>Correo electrónico:</label>
                <input type="email" name="correo" maxlength="150" required>
            </div>
            <div class="form-group">
                <label>Contraseña:</label>
                <input type="password" name="password" minlength="6" required>
            </div>
            <div class="form-group">
                <label>Teléfono:</label>
                <input type="tel" name="telefono" maxlength="20">
            </div>
            <div class="form-group">
                <label>Dirección:</label>
                <textarea name="direccion" rows="3"></textarea>
            </div>
            <button type="submit" class="btn">Guardar Cliente</button>
        </form>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
