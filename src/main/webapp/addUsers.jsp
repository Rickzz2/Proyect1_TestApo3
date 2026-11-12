<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Agregar usuario</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=3">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <div class="container">
        <h2>Agregar cliente / usuario</h2>
        <%@include file="lib/mensajes.jsp" %>
        <%-- Si el servlet encontró un error vuelve aquí y los campos conservan lo escrito --%>
        <form action="ServletClientes" method="post">
            <input type="hidden" name="accion" value="agregar">
            <div class="form-group">
                <label>Código único del usuario (3 a 20 letras, números o guiones):</label>
                <input type="text" name="codigo" maxlength="20" minlength="3" pattern="[A-Za-z0-9_\-]{3,20}"
                       title="De 3 a 20 caracteres: letras, números, guion o guion bajo" placeholder="USR-001"
                       value="<%= Texto.esc(request.getParameter("codigo")) %>" required>
            </div>
            <div class="form-group">
                <label>Nombre:</label>
                <input type="text" name="nombre" maxlength="100" value="<%= Texto.esc(request.getParameter("nombre")) %>" required>
            </div>
            <div class="form-group">
                <label>Apellidos:</label>
                <input type="text" name="apellidos" maxlength="100" value="<%= Texto.esc(request.getParameter("apellidos")) %>" required>
            </div>
            <div class="form-group">
                <label>Correo electrónico:</label>
                <input type="email" name="correo" maxlength="150" value="<%= Texto.esc(request.getParameter("correo")) %>" required>
            </div>
            <div class="form-group">
                <label>Contraseña (mínimo 6 caracteres):</label>
                <input type="password" name="password" minlength="6" required>
            </div>
            <div class="form-group">
                <label>Teléfono:</label>
                <input type="tel" name="telefono" maxlength="20" value="<%= Texto.esc(request.getParameter("telefono")) %>">
            </div>
            <div class="form-group">
                <label>Dirección:</label>
                <textarea name="direccion" rows="3"><%= Texto.esc(request.getParameter("direccion")) %></textarea>
            </div>
            <button type="submit" class="btn">Guardar cliente</button>
            <a href="listUsers.jsp" class="enlace-secundario">Volver al listado</a>
        </form>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
