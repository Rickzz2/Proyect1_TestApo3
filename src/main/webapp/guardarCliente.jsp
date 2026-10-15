<%@page import="java.sql.SQLException,modelo.Cliente,dao.ClienteDAO"%>
<%
    request.setCharacterEncoding("UTF-8");

    if (request.getParameter("nombre") == null || request.getParameter("password") == null) {
        response.sendRedirect("registroUsuarios.jsp");
        return;
    }

    Cliente c = new Cliente();
    c.setNombre(request.getParameter("nombre").trim());
    c.setApellidos(request.getParameter("apellidos").trim());
    c.setCorreo(request.getParameter("correo").trim());
    c.setTelefono(request.getParameter("telefono"));
    c.setDireccion(request.getParameter("direccion"));

    try {
        new ClienteDAO().insertar(c, request.getParameter("password"));
        response.sendRedirect("adminUsuarios.jsp");
    } catch (SQLException ex) {
        ex.printStackTrace();
        // 2627 y 2601 = correo repetido (columna única en la tabla cliente)
        if (ex.getErrorCode() == 2627 || ex.getErrorCode() == 2601) {
            response.sendRedirect("registroUsuarios.jsp?error=correo");
        } else {
            response.sendRedirect("registroUsuarios.jsp?error=bd");
        }
    }
%>
