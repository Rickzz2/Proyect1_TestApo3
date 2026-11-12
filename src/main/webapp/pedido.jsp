<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.ArrayList,java.util.List,java.util.Locale,modelo.Cliente,modelo.DetalleVenta,modelo.Producto,modelo.Venta,gestion.GestionarProducto,gestion.GestionarVenta,gestion.GestionException,util.Texto"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>RICKZ - Hacer pedido</title>
    <link rel="stylesheet" type="text/css" href="styles/styles.css?v=2">
    <link rel="stylesheet" type="text/css" href="styles/extra.css?v=5">
</head>
<body>
    <%@include file="lib/header.jsp" %>
    <%
        Cliente cliente = (Cliente) session.getAttribute("usuario");
        List<Producto> disponibles = new ArrayList<>();
        List<Venta> misPedidos = new ArrayList<>();
        String errorLectura = null;
        try {
            for (Producto p : new GestionarProducto().listar()) {
                if (p.isDisponibilidad() && p.getCantidadStock() > 0) {
                    disponibles.add(p);
                }
            }
            misPedidos = new GestionarVenta().listarDeCliente(cliente.getIdCliente());
        } catch (GestionException e) {
            errorLectura = e.getMessage();
        }
        // Si el servlet devolvió un error, se conserva lo que el cliente había elegido
        String tipoElegido = request.getParameter("tipoPedido");
        // Datos de entrega: lo que se envió (si hubo error) o, si no, lo guardado en la cuenta del cliente
        boolean reenviado = tipoElegido != null;
        String vNombre = reenviado ? request.getParameter("nombreReceptor")
                : cliente.getNombre() + " " + cliente.getApellidos();
        String vTelefono = reenviado ? request.getParameter("telefonoContacto") : cliente.getTelefono();
        String vDireccion = reenviado ? request.getParameter("direccionEntrega") : cliente.getDireccion();
        String vDistrito = reenviado ? request.getParameter("distrito") : "";
        String vReferencia = reenviado ? request.getParameter("referencia") : "";
    %>
    <div class="container container-ancho">
        <h2>Haz tu pedido</h2>
        <p class="subtitulo-pagina">Elige la cantidad de cada plato y confirma. El pedido se registra a tu nombre: <strong><%= Texto.esc(cliente.getNombre()) %> <%= Texto.esc(cliente.getApellidos()) %></strong>.</p>
        <%@include file="lib/mensajes.jsp" %>
        <% if (errorLectura != null) { %>
        <p class="mensaje-error"><%= Texto.esc(errorLectura) %></p>
        <% } %>

        <% if (disponibles.isEmpty()) { %>
        <p class="mensaje-error">Por ahora no hay platos disponibles para pedir. Vuelve en unos minutos.</p>
        <% } else { %>
        <form action="ServletPedidos" method="post" id="formPedido">
            <div class="menu-lista menu-pedido">
                <% for (Producto p : disponibles) {
                    String enviada = request.getParameter("cant_" + p.getIdProducto());
                    String valor = (enviada == null || enviada.trim().isEmpty()) ? "0" : enviada; %>
                <div class="menu-item">
                    <div class="menu-img">
                        <% if (p.tieneImagen()) { %>
                        <img src="<%= Texto.esc(p.getImagenUrl().trim()) %>" alt="<%= Texto.esc(p.getNombre()) %>" loading="lazy" onerror="this.remove()">
                        <% } %>
                    </div>
                    <div class="menu-body">
                        <span class="menu-categoria"><%= Texto.esc(p.getNombreCategoria()) %></span>
                        <h3><%= Texto.esc(p.getNombre()) %></h3>
                        <p><%= Texto.esc(p.getDescripcion()) %></p>
                        <div class="menu-precio">S/. <%= String.format(Locale.US, "%.2f", p.getPrecio()) %></div>
                        <div class="selector-cantidad">
                            <button type="button" class="menos" aria-label="Quitar uno">−</button>
                            <input type="number" class="campo-cantidad" name="cant_<%= p.getIdProducto() %>"
                                   min="0" max="<%= p.getCantidadStock() %>" step="1"
                                   value="<%= Texto.esc(valor) %>"
                                   data-precio="<%= String.format(Locale.US, "%.2f", p.getPrecio()) %>">
                            <button type="button" class="mas" aria-label="Agregar uno">+</button>
                        </div>
                    </div>
                </div>
                <% } %>
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

            <div class="barra-pedido">
                <div class="form-group barra-tipo">
                    <label>¿Cómo lo quieres?</label>
                    <select name="tipoPedido" required>
                        <option value="Mesa" <%= "Mesa".equals(tipoElegido) ? "selected" : "" %>>Para comer aquí (Mesa)</option>
                        <option value="Llevar" <%= "Llevar".equals(tipoElegido) ? "selected" : "" %>>Para llevar</option>
                        <option value="Domicilio" <%= "Domicilio".equals(tipoElegido) ? "selected" : "" %>>A domicilio</option>
                    </select>
                </div>
                <div class="barra-total">
                    <span id="resumenItems">0 platos</span>
                    <p class="total-venta">Total: <strong id="totalVenta">S/. 0.00</strong></p>
                </div>
                <button type="submit" class="btn btn-grande" id="btnPedir">Confirmar pedido</button>
            </div>
        </form>
        <% } %>

        <h3 class="titulo-seccion" id="mis-pedidos">Mis pedidos</h3>
        <div class="tabla-scroll">
            <table>
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Fecha</th>
                        <th>Tipo</th>
                        <th>Estado</th>
                        <th>Detalle</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (misPedidos.isEmpty()) { %>
                    <tr><td colspan="6">Todavía no has hecho pedidos.</td></tr>
                    <% } else {
                        for (Venta v : misPedidos) { %>
                    <tr>
                        <td><%= v.getIdVenta() %></td>
                        <td><%= Texto.esc(v.getFecha()) %></td>
                        <td><%= Texto.esc(v.getTipoPedido()) %>
                            <% if (v.esDomicilio() && v.getDireccionEntrega() != null) { %>
                            <span class="dato-entrega"><%= Texto.esc(v.getDireccionEntrega()) %>, <%= Texto.esc(v.getDistrito()) %></span>
                            <% } %>
                        </td>
                        <td><span class="etiqueta"><%= Texto.esc(v.getEstado()) %></span></td>
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
            var resumen = document.getElementById('resumenItems');
            var boton = document.getElementById('btnPedir');
            if (!total) { return; }
            function leer(campo) {
                var n = parseInt(campo.value, 10);
                return n > 0 ? n : 0;
            }
            function calcular() {
                var suma = 0, items = 0;
                campos.forEach(function (campo) {
                    var n = leer(campo);
                    items += n;
                    suma += n * parseFloat(campo.getAttribute('data-precio'));
                });
                total.textContent = 'S/. ' + suma.toFixed(2);
                resumen.textContent = items + (items === 1 ? ' plato' : ' platos');
                boton.disabled = items === 0;
            }
            document.querySelectorAll('.selector-cantidad').forEach(function (grupo) {
                var campo = grupo.querySelector('input');
                var max = parseInt(campo.getAttribute('max'), 10);
                grupo.querySelector('.menos').addEventListener('click', function () {
                    campo.value = Math.max(0, leer(campo) - 1);
                    calcular();
                });
                grupo.querySelector('.mas').addEventListener('click', function () {
                    campo.value = Math.min(max, leer(campo) + 1);
                    calcular();
                });
            });
            campos.forEach(function (campo) { campo.addEventListener('input', calcular); });
            calcular();
        })();
    </script>
    <%@include file="lib/footer.jsp" %>
</body>
</html>
