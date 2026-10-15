<%-- 
    Document   : header
    Created on : 30 set. 2026, 9:55:55 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="modelo.Cliente,util.Texto"%>
<%
    Cliente usuarioNav = (Cliente) session.getAttribute("usuario");
    boolean esAdminNav = usuarioNav != null && usuarioNav.esAdmin();
%>
<header class="main-header">
    <div class="logo-container">
        <h1>RICKZ</h1>
        <span>Plataforma de Gestión de Restaurantes</span>
    </div>
    <nav class="main-nav">
        <ul>
            <% if (usuarioNav == null) { %>
            <li><a href="login.jsp">Iniciar Sesión</a></li>
            <li><a href="crearCuenta.jsp">Crear cuenta</a></li>
            <% } else { %>
            <li><a href="index.jsp">Inicio</a></li>
            <li><a href="menu.jsp">Menú</a></li>
            <% if (esAdminNav) { %>
            <li><a href="adminUsuarios.jsp">Usuarios</a></li>
            <li><a href="adminProductos.jsp">Productos</a></li>
            <% } %>
            <li><span style="color:#666;">Hola, <%= Texto.esc(usuarioNav.getNombre()) %></span></li>
            <li><a href="logout.jsp">Cerrar sesión</a></li>
            <% } %>
        </ul>
    </nav>
</header>
