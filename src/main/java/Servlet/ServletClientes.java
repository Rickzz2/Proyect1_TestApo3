package Servlet;

import gestion.GestionException;
import gestion.GestionarCliente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import modelo.Cliente;

// Recibe los formularios de addUsers.jsp y listUsers.jsp y los pasa a GestionarCliente.
// Solo el admin llega aquí (AutenticacionFilter lo bloquea para los demás).
@WebServlet("/ServletClientes")
public class ServletClientes extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.sendRedirect("listUsers.jsp");
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
        GestionarCliente gestor = new GestionarCliente();

        switch (accion) {
            case "agregar":
                try {
                    gestor.agregar(leerCliente(request, 0), request.getParameter("password"));
                    sesion.setAttribute("msgOk", "Cliente agregado correctamente.");
                    response.sendRedirect("listUsers.jsp");
                } catch (GestionException ex) {
                    // Se vuelve al formulario con lo que el usuario ya había escrito
                    request.setAttribute("msgError", ex.getMessage());
                    request.getRequestDispatcher("addUsers.jsp").forward(request, response);
                }
                break;

            case "actualizar":
                int idEditar = leerId(request);
                try {
                    gestor.actualizar(leerCliente(request, idEditar), request.getParameter("password"));
                    sesion.setAttribute("msgOk", "Cliente actualizado correctamente.");
                    response.sendRedirect("listUsers.jsp");
                } catch (GestionException ex) {
                    sesion.setAttribute("msgError", ex.getMessage());
                    response.sendRedirect("listUsers.jsp?editar=" + idEditar);
                }
                break;

            case "eliminar":
                Cliente enSesion = (Cliente) sesion.getAttribute("usuario");
                try {
                    gestor.eliminar(leerId(request), enSesion == null ? -1 : enSesion.getIdCliente());
                    sesion.setAttribute("msgOk", "Cliente eliminado.");
                } catch (GestionException ex) {
                    sesion.setAttribute("msgError", ex.getMessage());
                }
                response.sendRedirect("listUsers.jsp");
                break;

            default:
                response.sendRedirect("listUsers.jsp");
        }
    }

    private Cliente leerCliente(HttpServletRequest request, int id) {
        Cliente c = new Cliente();
        c.setIdCliente(id);
        c.setCodigo(request.getParameter("codigo"));
        c.setNombre(request.getParameter("nombre"));
        c.setApellidos(request.getParameter("apellidos"));
        c.setCorreo(request.getParameter("correo"));
        c.setTelefono(request.getParameter("telefono"));
        c.setDireccion(request.getParameter("direccion"));
        return c;
    }

    private int leerId(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("id"));
        } catch (NumberFormatException ex) {
            return -1;
        }
    }
}
