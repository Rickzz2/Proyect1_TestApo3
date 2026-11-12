<%-- 
    Document   : index
    Created on : 30 set. 2026, 10:00:05 p. m.
    Author     : rickn
--%>
<%-- 
    Document   : index
    Created on : 30 set. 2026, 10:00:05 p. m.
    Author     : rickn
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Inicio</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=4">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%@page import="modelo.Cliente,modelo.Venta,modelo.DetalleVenta,gestion.GestionarVenta,util.Texto,java.util.List,java.util.ArrayList,java.util.Locale"%>
    <%
        Cliente usuario = (Cliente) session.getAttribute("usuario");
        boolean esAdmin = usuario != null && usuario.esAdmin();

        // Últimos pedidos del cliente (si falla la BD, la página igual carga)
        List<Venta> recientes = new ArrayList<>();
        if (usuario != null && !esAdmin) {
            try {
                List<Venta> todos = new GestionarVenta().listarDeCliente(usuario.getIdCliente());
                recientes = todos.size() > 3 ? todos.subList(0, 3) : todos;
            } catch (Exception e) {
                recientes = new ArrayList<>();
            }
        }
    %>

    <section class="hero">
        <img class="hero-img" src="images/lomoSaltado.webp" alt="Lomo saltado">
        <div class="hero-content">
            <h2>Hola, <%= usuario == null ? "" : Texto.esc(usuario.getNombre()) %></h2>
            <p>Plataforma inteligente para la gestión de restaurantes, menús digitales y pedidos personalizados.</p>
            <% if (esAdmin) { %>
            <a href="listItems.jsp" class="btn-pill btn-claro">Ver productos</a>
            <a href="listUsers.jsp" class="btn-pill btn-borde">Ver usuarios</a>
            <% } else { %>
            <a href="pedido.jsp" class="btn-pill btn-claro">Hacer pedido</a>
            <a href="menu.jsp" class="btn-pill btn-borde">Ver menú</a>
            <% } %>
        </div>
    </section>

    <% if (esAdmin) { %>
    <section class="banda">
        <span class="banda-texto">Panel de administración</span>
        <a href="addUsers.jsp" class="btn-pill btn-claro">Registrar Cliente</a>
        <a href="addItems.jsp" class="btn-pill btn-claro">Registrar Producto</a>
        <a href="venta.jsp" class="btn-pill btn-claro">Registrar Venta</a>
    </section>
    <% } else { %>
    <section class="banda">
        <span class="banda-texto">¿Con hambre?</span>
        <a href="pedido.jsp" class="btn-pill btn-claro">Pedir ahora</a>
    </section>
    <% } %>

    <% if (!esAdmin) { %>
    <section class="seccion">
        <h2>Pide en 3 pasos</h2>
        <p class="subtitulo">Rápido, fácil y sin llamadas</p>
        <div class="pasos">
            <div class="paso"><div class="paso-num">1</div><h3>Elige tus platos</h3><p>Explora el menú y selecciona lo que se te antoja.</p></div>
            <div class="paso"><div class="paso-num">2</div><h3>Escoge cómo recibirlo</h3><p>En mesa, para llevar o a domicilio.</p></div>
            <div class="paso"><div class="paso-num">3</div><h3>Confirma y listo</h3><p>Tu pedido llega a la cocina al instante.</p></div>
        </div>
    </section>

    <section class="seccion">
        <h2>Tus últimos pedidos</h2>
        <% if (recientes.isEmpty()) { %>
        <div class="vacio-pedidos">
            <p>Aún no has hecho ningún pedido.</p>
            <a href="pedido.jsp" class="btn">Hacer mi primer pedido</a>
        </div>
        <% } else { %>
        <div class="pedidos-resumen">
            <% for (Venta v : recientes) { %>
            <div class="pedido-card">
                <div class="pedido-cab">
                    <strong>Pedido #<%= v.getIdVenta() %></strong>
                    <span class="etiqueta"><%= Texto.esc(v.getEstado()) %></span>
                </div>
                <div class="pedido-fecha"><%= Texto.esc(v.getFecha()) %> · <%= Texto.esc(v.getTipoPedido()) %></div>
                <ul>
                    <% for (DetalleVenta d : v.getDetalles()) { %>
                    <li><%= d.getCantidad() %> x <%= Texto.esc(d.getNombreProducto()) %></li>
                    <% } %>
                </ul>
                <div class="pedido-total">S/. <%= String.format(Locale.US, "%.2f", v.getTotal()) %></div>
            </div>
            <% } %>
        </div>
        <p style="text-align:center;"><a href="pedido.jsp#mis-pedidos" class="enlace-secundario">Ver todos mis pedidos</a></p>
        <% } %>
    </section>
    <% } %>

    <section class="seccion">
        <h2>Nuestros favoritos</h2>
        <p class="subtitulo">Los platos más pedidos</p>
        <div class="cards">
            <div class="card">
                <img src="images/papaAlaHuancaina.webp" alt="Papa a la huancaína">
                <div class="card-title">Papa a la Huancaína</div>
            </div>
            <div class="card">
                <img src="images/papaRellena.webp" alt="Papa rellena">
                <div class="card-title">Papa Rellena</div>
            </div>
            <div class="card">
                <img src="images/lomoSaltado.webp" alt="Lomo saltado">
                <div class="card-title">Lomo Saltado</div>
            </div>
        </div>
    </section>

    <%@include file="lib/footer.jsp" %>
</body>
</html>