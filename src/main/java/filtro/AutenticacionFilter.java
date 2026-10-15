package filtro;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Set;
import modelo.Cliente;

// Se ejecuta antes de CADA página. Decide si el visitante puede verla.
@WebFilter("/*")
public class AutenticacionFilter implements Filter {

    // Páginas que se pueden ver sin iniciar sesión
    private static final Set<String> PUBLICAS = Set.of(
            "/login.jsp", "/procesarLogin.jsp", "/crearCuenta.jsp", "/guardarCuenta.jsp");

    // Páginas que solo puede ver el admin (además de todo lo que empiece con /admin)
    private static final Set<String> SOLO_ADMIN = Set.of(
            "/registroUsuarios.jsp", "/registroProductos.jsp",
            "/guardarCliente.jsp", "/guardarProducto.jsp");

    // Carpetas de recursos (estilos, imágenes, scripts): siempre accesibles
    private static final String[] RECURSOS = {"/styles/", "/images/", "/scripts/"};

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String ruta = request.getServletPath();

        if (esRecurso(ruta) || PUBLICAS.contains(ruta)) {
            chain.doFilter(req, res);
            return;
        }

        HttpSession sesion = request.getSession(false);
        Cliente usuario = (sesion == null) ? null : (Cliente) sesion.getAttribute("usuario");

        if (usuario == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        if (esSoloAdmin(ruta) && !usuario.esAdmin()) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        // Evita que el botón "atrás" muestre páginas privadas después de cerrar sesión
        response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        chain.doFilter(req, res);
    }

    private boolean esRecurso(String ruta) {
        for (String carpeta : RECURSOS) {
            if (ruta.startsWith(carpeta)) {
                return true;
            }
        }
        return false;
    }

    private boolean esSoloAdmin(String ruta) {
        return ruta.startsWith("/admin") || SOLO_ADMIN.contains(ruta);
    }
}
