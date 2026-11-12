<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Iniciar Sesión</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=4">
</head>
<body>
    <%
        if (session.getAttribute("usuario") != null) {
            response.sendRedirect("index.jsp");
            return;
        }
        String error = request.getParameter("error");
        String mensajeError = null;
        if ("credenciales".equals(error)) {
            mensajeError = "Correo o contraseña incorrectos.";
        } else if ("bd".equals(error)) {
            mensajeError = "No se pudo conectar con la base de datos. Revisa que SQL Server esté encendido y que la clave en db.properties sea correcta.";
        }
        String mensajeOk = "cuenta".equals(request.getParameter("ok"))
                ? "Cuenta creada. Ya puedes iniciar sesión." : null;
    %>
    <%@include file="lib/header.jsp" %>
    <main class="auth-layout">
        <section class="auth-brand">
            <img src="images/logo-rickz.png" alt="Logo RICKZ" class="auth-logo">
            <h2>Bienvenido a RICKZ</h2>
            <p>Plataforma inteligente para restaurantes, menús digitales y pedidos personalizados.</p>
            <ul class="auth-ventajas">
                <li><span>🍽️</span> Mira el menú con fotos y precios</li>
                <li><span>🛵</span> Pide en mesa, para llevar o a domicilio</li>
                <li><span>📋</span> Revisa el estado de tus pedidos</li>
            </ul>
        </section>
        <section class="container auth-card">
            <h2>Iniciar Sesión</h2>
            <p class="auth-sub">Ingresa con tu cuenta para continuar</p>
            <% if (mensajeError != null) { %>
            <p class="mensaje-error"><%= mensajeError %></p>
            <% } %>
            <% if (mensajeOk != null) { %>
            <p class="mensaje-ok"><%= mensajeOk %></p>
            <% } %>
            <form action="procesarLogin.jsp" method="post">
                <div class="form-group">
                    <label>Correo electrónico:</label>
                    <input type="email" name="correo" required>
                </div>
                <div class="form-group">
                    <label>Contraseña:</label>
                    <input type="password" name="password" required>
                </div>
                <button type="submit" class="btn btn-block">Ingresar</button>
            </form>
            <a href="crearCuenta.jsp" class="enlace-secundario">¿No tienes cuenta? Crea una</a>
        </section>
    </main>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
