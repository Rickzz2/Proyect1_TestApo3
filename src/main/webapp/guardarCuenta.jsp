<%@page import="java.sql.SQLException,modelo.Cliente,dao.ClienteDAO"%>
<%
    request.setCharacterEncoding("UTF-8");

    String nombre = request.getParameter("nombre");
    String apellidos = request.getParameter("apellidos");
    String correo = request.getParameter("correo");
    String password = request.getParameter("password");

    if (nombre == null || apellidos == null || correo == null || password == null) {
        response.sendRedirect("crearCuenta.jsp");
        return;
    }
    if (password.length() < 6) {
        response.sendRedirect("crearCuenta.jsp?error=clave");
        return;
    }

    Cliente c = new Cliente();
    c.setNombre(nombre.trim());
    c.setApellidos(apellidos.trim());
    c.setCorreo(correo.trim());
    c.setTelefono(request.getParameter("telefono"));
    c.setDireccion(request.getParameter("direccion"));

    try {
        // Una cuenta creada aquí siempre queda con rol 'cliente'
        new ClienteDAO().insertar(c, password);
        response.sendRedirect("login.jsp?ok=cuenta");
    } catch (SQLException ex) {
        ex.printStackTrace();
        if (ex.getErrorCode() == 2627 || ex.getErrorCode() == 2601) {
            response.sendRedirect("crearCuenta.jsp?error=correo");
        } else {
            response.sendRedirect("crearCuenta.jsp?error=bd");
        }
    }
%>
