<%-- 
    Document   : adminUsuarios
    Created on : 30 set. 2026, 10:00:49 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>RICKZ - Administración de Usuarios</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <div class="container">
        <h2>Administración de Clientes / Usuarios</h2>
        <a href="registroUsuarios.jsp" class="btn">+ Nuevo Cliente</a>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Nombre</th>
                    <th>Apellidos</th>
                    <th>Correo</th>
                    <th>Teléfono</th>
                    <th>Acciones</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td>Ricky</td>
                    <td>Sánchez</td>
                    <td>ricky@ejemplo.com</td>
                    <td>987654321</td>
                    <td>
                        <button>Editar</button>
                        <button>Eliminar</button>
                    </td>
                </tr>
            </tbody>
        </table>
    </div>
    <%@include file="lib/footer.jsp" %>
</body>
</html>