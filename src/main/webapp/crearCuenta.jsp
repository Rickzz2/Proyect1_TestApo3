<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Crear cuenta</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css">
</head>
<body>
    <%
        String error = request.getParameter("error");
        String mensajeError = null;
        if ("correo".equals(error)) {
            mensajeError = "Ese correo ya está registrado. Usa otro o inicia sesión.";
        } else if ("clave".equals(error)) {
            mensajeError = "La contraseña debe tener al menos 6 caracteres.";
        } else if ("bd".equals(error)) {
            mensajeError = "No se pudo crear la cuenta. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
    %>
    <%@include file="lib/header.jsp" %>
    <div class="container auth-card">
        <h2>Crear cuenta</h2>
        <% if (mensajeError != null) { %>
        <p class="mensaje-error"><%= mensajeError %></p>
        <% } %>
        <form action="guardarCuenta.jsp" method="post">
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
                <label>Contraseña (mínimo 6 caracteres):</label>
                <input type="password" name="password" minlength="6" required>
            </div>
            <div class="form-group">
                <label>Teléfono:</label>
                <input type="tel" name="telefono" maxlength="20">
            </div>
            <div class="form-group">
                <label>Dirección:</label>
                <textarea name="direccion" rows="2"></textarea>
            </div>
            <button type="submit" class="btn">Crear cuenta</button>
        </form>
        <a href="login.jsp" class="enlace-secundario">¿Ya tienes cuenta? Inicia sesión</a>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
