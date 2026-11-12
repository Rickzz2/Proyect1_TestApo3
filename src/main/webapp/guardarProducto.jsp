<%@page import="java.sql.SQLException,modelo.Producto,dao.ProductoDAO"%>
<%
    request.setCharacterEncoding("UTF-8");

    if (request.getParameter("nombre") == null) {
        response.sendRedirect("registroProductos.jsp");
        return;
    }

    // Imagen opcional: un archivo de la carpeta images/ o un enlace https://
    String imagen = request.getParameter("imagenUrl");
    imagen = (imagen == null) ? "" : imagen.trim();
    if (!imagen.isEmpty()) {
        boolean local = imagen.matches("images/[A-Za-z0-9_./-]+") && !imagen.contains("..");
        boolean externa = imagen.matches("https://[^\\s\"'<>]+");
        if ((!local && !externa) || imagen.length() > 255) {
            response.sendRedirect("registroProductos.jsp?error=imagen");
            return;
        }
    }

    Producto p = new Producto();
    try {
        p.setNombre(request.getParameter("nombre").trim());
        p.setDescripcion(request.getParameter("descripcion"));
        p.setIdCategoria(Integer.parseInt(request.getParameter("idCategoria")));
        p.setPrecio(Double.parseDouble(request.getParameter("precio")));
        p.setCantidadStock(Integer.parseInt(request.getParameter("cantidadStock")));
        p.setDisponibilidad(p.getCantidadStock() > 0);
        p.setImagenUrl(imagen.isEmpty() ? null : imagen);
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
