<%@page import="java.sql.SQLException,modelo.Producto,dao.ProductoDAO"%>
<%
    request.setCharacterEncoding("UTF-8");

    if (request.getParameter("nombre") == null) {
        response.sendRedirect("registroProductos.jsp");
        return;
    }

    Producto p = new Producto();
    try {
        p.setNombre(request.getParameter("nombre").trim());
        p.setDescripcion(request.getParameter("descripcion"));
        p.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
        p.setPrecio(Double.parseDouble(request.getParameter("precio")));
        p.setCantidadStock(Integer.parseInt(request.getParameter("cantidadStock")));
        p.setDisponibilidad(p.getCantidadStock() > 0);
    } catch (NumberFormatException ex) {
        response.sendRedirect("registroProductos.jsp?error=datos");
        return;
    }

    try {
        new ProductoDAO().insertar(p);
        response.sendRedirect("adminProductos.jsp");
    } catch (SQLException ex) {
        ex.printStackTrace();
        response.sendRedirect("registroProductos.jsp?error=bd");
    }
%>
