<%@page import="java.sql.SQLException,modelo.Cliente,dao.ClienteDAO"%>
<%
    request.setCharacterEncoding("UTF-8");

    String correo = request.getParameter("correo");
    String password = request.getParameter("password");

    if (correo == null || password == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    try {
        Cliente c = new ClienteDAO().autenticar(correo.trim(), password);
        if (c == null) {
            response.sendRedirect("login.jsp?error=credenciales");
            return;
        }
        // Sesión nueva en cada login (evita reutilizar una sesión ajena)
        session.invalidate();
        request.getSession(true).setAttribute("usuario", c);
        response.sendRedirect("index.jsp");
    } catch (SQLException ex) {
        ex.printStackTrace();
        response.sendRedirect("login.jsp?error=bd");
    }
%>
