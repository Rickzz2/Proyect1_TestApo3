<%-- 
    Document   : login
    Created on : 30 set. 2026, 10:00:32 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>RICKZ - Login</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <div class="container" style="max-width: 400px;">
        <h2>Iniciar Sesión</h2>
        <form action="index.jsp" method="post">
            <div class="form-group">
                <label>Correo Electrónico:</label>
                <input type="email" name="correo" required>
            </div>
            <div class="form-group">
                <label>Contraseña:</label>
                <input type="password" name="password" required>
            </div>
            <button type="submit" class="btn">Ingresar</button>
        </form>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>