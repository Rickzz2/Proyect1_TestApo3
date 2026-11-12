package Servlet;

import gestion.GestionException;
import gestion.GestionarProducto;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import modelo.Producto;

// Recibe los formularios de addItems.jsp y listItems.jsp y los pasa a GestionarProducto.
// Solo el admin llega aquí (AutenticacionFilter lo bloquea para los demás).
@WebServlet("/ServletProductos")
public class ServletProductos extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect("listItems.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        if (accion == null) {
            accion = "";
        }
        HttpSession sesion = request.getSession();
        GestionarProducto gestor = new GestionarProducto();

        switch (accion) {
            case "agregar":
                try {
                    gestor.agregar(leerProducto(request, 0));
                    sesion.setAttribute("msgOk", "Producto agregado correctamente.");
                    response.sendRedirect("listItems.jsp");
                } catch (GestionException ex) {
                    request.setAttribute("msgError", ex.getMessage());
                    request.getRequestDispatcher("addItems.jsp").forward(request, response);
                }
                break;

            case "actualizar":
                int idEditar = leerEntero(request, "id", -1);
                try {
                    gestor.actualizar(leerProducto(request, idEditar));
                    sesion.setAttribute("msgOk", "Producto actualizado correctamente.");
                    response.sendRedirect("listItems.jsp");
                } catch (GestionException ex) {
                    sesion.setAttribute("msgError", ex.getMessage());
                    response.sendRedirect("listItems.jsp?editar=" + idEditar);
                }
                break;

            case "eliminar":
                try {
                    gestor.eliminar(leerEntero(request, "id", -1));
                    sesion.setAttribute("msgOk", "Producto eliminado.");
                } catch (GestionException ex) {
                    sesion.setAttribute("msgError", ex.getMessage());
                }
                response.sendRedirect("listItems.jsp");
                break;

            default:
                response.sendRedirect("listItems.jsp");
        }
    }

    // Si el precio o el stock no son números, quedan en valores inválidos
    // (-1) y GestionarProducto los rechaza con su mensaje.
    private Producto leerProducto(HttpServletRequest request, int id) {
        Producto p = new Producto();
        p.setIdProducto(id);
        p.setCodigo(request.getParameter("codigo"));
        p.setNombre(request.getParameter("nombre"));
        p.setDescripcion(request.getParameter("descripcion"));
        p.setIdCategoria(leerEntero(request, "idCategoria", 0));
        try {
            p.setPrecio(Double.parseDouble(request.getParameter("precio")));
        } catch (NumberFormatException | NullPointerException ex) {
            p.setPrecio(-1);
        }
        p.setCantidadStock(leerEntero(request, "cantidadStock", -1));
        p.setImagenUrl(request.getParameter("imagenUrl"));
        return p;
    }

    private int leerEntero(HttpServletRequest request, String nombre, int porDefecto) {
        try {
            return Integer.parseInt(request.getParameter(nombre).trim());
        } catch (NumberFormatException | NullPointerException ex) {
            return porDefecto;
        }
    }
}
