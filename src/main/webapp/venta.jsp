<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList,java.util.List,java.util.Locale,modelo.Cliente,modelo.DetalleVenta,modelo.Producto,modelo.Venta,gestion.GestionarCliente,gestion.GestionarProducto,gestion.GestionarVenta,gestion.GestionException,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Ventas</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=5">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        List<Cliente> clientes = new ArrayList<>();
        List<Producto> disponibles = new ArrayList<>();
        List<Venta> ventas = new ArrayList<>();
        String errorLectura = null;
        try {
            clientes = new GestionarCliente().listar();
            for (Producto p : new GestionarProducto().listar()) {
                if (p.isDisponibilidad() && p.getCantidadStock() > 0) {
                    disponibles.add(p);
                }
            }
            ventas = new GestionarVenta().listar();
        } catch (GestionException e) {
            errorLectura = e.getMessage();
        }
        // Si el servlet devolvió un error, se conserva lo que el usuario había elegido
        String clienteElegido = request.getParameter("idCliente");
        String tipoElegido = request.getParameter("tipoPedido");
        String vNombre = request.getParameter("nombreReceptor") == null ? "" : request.getParameter("nombreReceptor");
        String vTelefono = request.getParameter("telefonoContacto") == null ? "" : request.getParameter("telefonoContacto");
        String vDireccion = request.getParameter("direccionEntrega") == null ? "" : request.getParameter("direccionEntrega");
        String vDistrito = request.getParameter("distrito") == null ? "" : request.getParameter("distrito");
        String vReferencia = request.getParameter("referencia") == null ? "" : request.getParameter("referencia");
    %>
    <div class="container container-ancho">
        <h2>Registrar venta</h2>
        <p class="subtitulo-pagina">Asocia un cliente con los productos que compra. El stock se descuenta automáticamente.</p>
        <%@include file="lib/mensajes.jsp" %>
        <% if (errorLectura != null) { %>
        <p class="mensaje-error"><%= Texto.esc(errorLectura) %></p>
        <% } %>

        <% if (clientes.isEmpty() || disponibles.isEmpty()) { %>
        <p class="mensaje-error">
            Para registrar una venta necesitas al menos un cliente
            (<a href="addUsers.jsp">agregar cliente</a>) y un producto con stock
            (<a href="addItems.jsp">agregar ítem</a>).
        </p>
        <% } else { %>
        <form action="ServletVentas" method="post">
            <div class="form-grid">
                <div class="form-group">
                    <label>Cliente:</label>
                    <select name="idCliente" required>
                        <option value="">Seleccione...</option>
                        <% for (Cliente c : clientes) { %>
                        <option value="<%= c.getIdCliente() %>" <%= String.valueOf(c.getIdCliente()).equals(clienteElegido) ? "selected" : "" %>><%= Texto.esc(c.getCodigo()) %> - <%= Texto.esc(c.getNombre()) %> <%= Texto.esc(c.getApellidos()) %></option>
                        <% } %>
                    </select>
                </div>
                <div class="form-group">
                    <label>Tipo de pedido:</label>
                    <select name="tipoPedido" required>
                        <option value="Mesa" <%= "Mesa".equals(tipoElegido) ? "selected" : "" %>>Mesa</option>
                        <option value="Llevar" <%= "Llevar".equals(tipoElegido) ? "selected" : "" %>>Para llevar</option>
                        <option value="Domicilio" <%= "Domicilio".equals(tipoElegido) ? "selected" : "" %>>Domicilio</option>
                    </select>
                </div>
            </div>

            <div class="entrega" id="datosEntrega" hidden>
                <h3>Datos de entrega</h3>
                <p class="nota-entrega">Necesitamos estos datos para llevarte el pedido.</p>
                <div class="form-grid">
                    <div class="form-group">
                        <label for="nombreReceptor">¿Quién recibe? *</label>
                        <input type="text" id="nombreReceptor" name="nombreReceptor" maxlength="150"
                               value="<%= Texto.esc(vNombre) %>">
                    </div>
                    <div class="form-group">
                        <label for="telefonoContacto">Teléfono de contacto *</label>
                        <input type="tel" id="telefonoContacto" name="telefonoContacto" maxlength="20"
                               value="<%= Texto.esc(vTelefono) %>">
                    </div>
                    <div class="form-group ancho-completo">
                        <label for="direccionEntrega">Dirección de entrega *</label>
                        <input type="text" id="direccionEntrega" name="direccionEntrega" maxlength="250"
                               placeholder="Calle / avenida, número, piso o departamento"
                               value="<%= Texto.esc(vDireccion) %>">
                    </div>
                    <div class="form-group">
                        <label for="distrito">Distrito / barrio *</label>
                        <input type="text" id="distrito" name="distrito" maxlength="100"
                               value="<%= Texto.esc(vDistrito) %>">
                    </div>
                    <div class="form-group">
                        <label for="referencia">Referencia (opcional)</label>
                        <input type="text" id="referencia" name="referencia" maxlength="250"
                               placeholder="Ej: frente al parque, casa de reja negra"
                               value="<%= Texto.esc(vReferencia) %>">
                    </div>
                </div>
            </div>

            <div class="tabla-scroll">
                <table>
                    <thead>
                        <tr>
                            <th>Código</th>
                            <th>Producto</th>
                            <th>Categoría</th>
                            <th>Precio</th>
                            <th>Stock</th>
                            <th>Cantidad</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (Producto p : disponibles) {
                            String enviada = request.getParameter("cant_" + p.getIdProducto()); %>
                        <tr>
                            <td><%= Texto.esc(p.getCodigo()) %></td>
                            <td><%= Texto.esc(p.getNombre()) %></td>
                            <td><%= Texto.esc(p.getNombreCategoria()) %></td>
                            <td>S/. <%= String.format(Locale.US, "%.2f", p.getPrecio()) %></td>
                            <td><%= p.getCantidadStock() %></td>
                            <td>
                                <input type="number" class="campo-cantidad" name="cant_<%= p.getIdProducto() %>"
                                       min="0" max="<%= p.getCantidadStock() %>" step="1"
                                       value="<%= Texto.esc(enviada == null ? "0" : enviada) %>"
                                       data-precio="<%= String.format(Locale.US, "%.2f", p.getPrecio()) %>">
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>

            <p class="total-venta">Total: <strong id="totalVenta">S/. 0.00</strong></p>
            <button type="submit" class="btn">Registrar venta</button>
        </form>
        <% } %>

        <h3 class="titulo-seccion">Ventas registradas</h3>
        <div class="tabla-scroll">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Fecha</th>
                        <th>Cliente</th>
                        <th>Tipo</th>
                        <th>Estado</th>
                        <th>Detalle</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (ventas.isEmpty()) { %>
                    <tr>
                        <td colspan="7">Aún no hay ventas registradas.</td>
                    </tr>
                    <% } else {
                        for (Venta v : ventas) { %>
                    <tr>
                        <td><%= v.getIdVenta() %></td>
                        <td><%= Texto.esc(v.getFecha()) %></td>
                        <td><%= Texto.esc(v.getNombreCliente()) %></td>
                        <td><%= Texto.esc(v.getTipoPedido()) %>
                            <% if (v.esDomicilio() && v.getDireccionEntrega() != null) { %>
                            <span class="dato-entrega">
                                <%= Texto.esc(v.getNombreReceptor()) %> · <%= Texto.esc(v.getTelefonoContacto()) %><br>
                                <%= Texto.esc(v.getDireccionEntrega()) %>, <%= Texto.esc(v.getDistrito()) %>
                                <% if (v.getReferencia() != null) { %><br>Ref: <%= Texto.esc(v.getReferencia()) %><% } %>
                            </span>
                            <% } %>
                        </td>
                        <td><%= Texto.esc(v.getEstado()) %></td>
                        <td>
                            <% for (DetalleVenta d : v.getDetalles()) { %>
                            <%= d.getCantidad() %> x <%= Texto.esc(d.getNombreProducto()) %> (S/. <%= String.format(Locale.US, "%.2f", d.getSubtotal()) %>)<br>
                            <% } %>
                        </td>
                        <td>S/. <%= String.format(Locale.US, "%.2f", v.getTotal()) %></td>
                    </tr>
                    <%  }
                       } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        (function () {
            var tipo = document.querySelector('select[name="tipoPedido"]');
            var caja = document.getElementById('datosEntrega');
            if (!tipo || !caja) { return; }
            var obligatorios = ['nombreReceptor', 'telefonoContacto', 'direccionEntrega', 'distrito'];
            function actualizar() {
                var domicilio = tipo.value === 'Domicilio';
                caja.hidden = !domicilio;
                obligatorios.forEach(function (id) {
                    document.getElementById(id).required = domicilio;
                });
            }
            tipo.addEventListener('change', actualizar);
            actualizar();
        })();
        (function () {
            var campos = document.querySelectorAll('input.campo-cantidad');
            var total = document.getElementById('totalVenta');
            if (!total) { return; }
            function calcular() {
                var suma = 0;
                campos.forEach(function (campo) {
                    var cantidad = parseInt(campo.value, 10);
                    if (cantidad > 0) {
                        suma += cantidad * parseFloat(campo.getAttribute('data-precio'));
                    }
                });
                total.textContent = 'S/. ' + suma.toFixed(2);
            }
            campos.forEach(function (campo) { campo.addEventListener('input', calcular); });
            calcular();
        })();
    </script>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
