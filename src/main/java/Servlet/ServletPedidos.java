package Servlet;

import gestion.GestionException;
import gestion.GestionarProducto;
import gestion.GestionarVenta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import modelo.DatosEntrega;
import modelo.Cliente;
import modelo.Producto;

// Recibe el pedido que hace un CLIENTE desde pedido.jsp.
// A diferencia de ServletVentas (solo admin), aquí el cliente NO elige a nombre de
// quién se hace el pedido: siempre es el usuario que inició sesión.
@WebServlet("/ServletPedidos")
public class ServletPedidos extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect("pedido.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession sesion = request.getSession(false);
        Cliente usuario = (sesion == null) ? null : (Cliente) sesion.getAttribute("usuario");
        if (usuario == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            Map<Integer, Integer> cantidades = new LinkedHashMap<>();
            for (Producto p : new GestionarProducto().listar()) {
                int cantidad = leerEntero(request.getParameter("cant_" + p.getIdProducto()));
                if (cantidad > 0) {
                    cantidades.put(p.getIdProducto(), cantidad);
                }
            }
            DatosEntrega entrega = new DatosEntrega(
                    request.getParameter("nombreReceptor"), request.getParameter("direccionEntrega"),
                    request.getParameter("distrito"), request.getParameter("referencia"),
                    request.getParameter("telefonoContacto"));
            int idPedido = new GestionarVenta().registrar(
                    usuario.getIdCliente(), request.getParameter("tipoPedido"), cantidades, entrega);
            sesion.setAttribute("msgOk", "¡Pedido #" + idPedido + " enviado! Lo estamos preparando.");
            response.sendRedirect("pedido.jsp#mis-pedidos");
        } catch (GestionException ex) {
            // Se vuelve al formulario conservando las cantidades que ya había elegido
            request.setAttribute("msgError", ex.getMessage());
            request.getRequestDispatcher("pedido.jsp").forward(request, response);
        }
    }

    private int leerEntero(String s) {
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException | NullPointerException ex) {
            return 0;
        }
    }
}
