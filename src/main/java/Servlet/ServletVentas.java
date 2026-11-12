package Servlet;

import gestion.GestionException;
import gestion.GestionarProducto;
import gestion.GestionarVenta;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;
import modelo.Producto;

// Recibe el formulario de venta.jsp: un cliente + varias cantidades (cant_<idProducto>).
@WebServlet("/ServletVentas")
public class ServletVentas extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect("venta.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        try {
            int idCliente = leerEntero(request.getParameter("idCliente"));
            Map<Integer, Integer> cantidades = new LinkedHashMap<>();
            // Solo se leen cantidades de productos que existen, así no se aceptan ids inventados
            for (Producto p : new GestionarProducto().listar()) {
                int cantidad = leerEntero(request.getParameter("cant_" + p.getIdProducto()));
                if (cantidad > 0) {
                    cantidades.put(p.getIdProducto(), cantidad);
                }
            }
            int idVenta = new GestionarVenta().registrar(idCliente, request.getParameter("tipoPedido"), cantidades);
            request.getSession().setAttribute("msgOk", "Venta #" + idVenta + " registrada correctamente.");
            response.sendRedirect("venta.jsp");
        } catch (GestionException ex) {
            // Se vuelve al formulario conservando lo que el usuario había elegido
            request.setAttribute("msgError", ex.getMessage());
            request.getRequestDispatcher("venta.jsp").forward(request, response);
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
