<%-- Muestra (y borra) los mensajes de éxito o error que dejan los servlets --%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="util.Texto"%>
<%
    String msgOkFlash = (String) session.getAttribute("msgOk");
    session.removeAttribute("msgOk");
    String msgErrorFlash = (String) request.getAttribute("msgError");
    if (msgErrorFlash == null) {
        msgErrorFlash = (String) session.getAttribute("msgError");
    }
    session.removeAttribute("msgError");
%>
<% if (msgOkFlash != null) { %>
<p class="mensaje-ok"><%= Texto.esc(msgOkFlash) %></p>
<% } %>
<% if (msgErrorFlash != null) { %>
<p class="mensaje-error"><%= Texto.esc(msgErrorFlash) %></p>
<% } %>
