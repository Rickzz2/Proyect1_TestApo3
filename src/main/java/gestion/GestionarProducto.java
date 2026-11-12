package gestion;

import dao.CategoriaDAO;
import dao.ProductoDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import modelo.Categoria;
import modelo.Producto;

// Gestiona la colección de productos/ítems (un ArrayList) y la mantiene
// sincronizada con SQL Server a través de ProductoDAO.
// CRUD: agregar, actualizar, eliminar, filtrar por un campo y listar todos.
public class GestionarProducto {

    private static final Pattern CODIGO = Pattern.compile("^[A-Za-z0-9_-]{3,20}$");

    private final ProductoDAO dao = new ProductoDAO();
    private final List<Producto> productos = new ArrayList<>();
    private boolean cargado = false;

    public void cargar() throws GestionException {
        try {
            List<Producto> deBd = dao.listar();
            productos.clear();
            productos.addAll(deBd);
            cargado = true;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new GestionException("No se pudo leer la lista de productos. Revisa que SQL Server esté encendido.", e);
        }
    }

    private void asegurarCargado() throws GestionException {
        if (!cargado) {
            cargar();
        }
    }

    public List<Categoria> listarCategorias() throws GestionException {
        try {
            return new CategoriaDAO().listar();
        } catch (SQLException e) {
            e.printStackTrace();
            throw new GestionException("No se pudieron cargar las categorías. Revisa que SQL Server esté encendido.", e);
        }
    }

    // ---------------- Listar / buscar / filtrar ----------------

    public List<Producto> listar() throws GestionException {
        asegurarCargado();
        return new ArrayList<>(productos);
    }

    public Producto buscarPorId(int id) throws GestionException {
        asegurarCargado();
        for (Producto p : productos) {
            if (p.getIdProducto() == id) {
                return p;
            }
        }
        return null;
    }

    // campo: codigo, nombre o categoria. Busca texto contenido, sin importar mayúsculas.
    public List<Producto> filtrar(String campo, String texto) throws GestionException {
        asegurarCargado();
        if (texto == null || texto.trim().isEmpty()) {
            return listar();
        }
        String buscado = texto.trim().toLowerCase();
        List<Producto> resultado = new ArrayList<>();
        for (Producto p : productos) {
            String valor;
            switch (campo == null ? "" : campo) {
                case "codigo":    valor = p.getCodigo();          break;
                case "categoria": valor = p.getNombreCategoria(); break;
                default:          valor = p.getNombre();          break;
            }
            if (valor != null && valor.toLowerCase().contains(buscado)) {
                resultado.add(p);
            }
        }
        return resultado;
    }

    // ---------------- Agregar ----------------

    public void agregar(Producto p) throws GestionException {
        asegurarCargado();
        normalizar(p);
        validar(p);
        verificarCodigoUnico(p);
        try {
            int id = dao.insertar(p);
            p.setIdProducto(id);
            productos.add(p);
            completarCategoria(p);
        } catch (SQLException e) {
            throw traducir(e, "No se pudo guardar el producto.", "La categoría elegida no existe.");
        }
    }

    // ---------------- Actualizar ----------------

    public void actualizar(Producto p) throws GestionException {
        asegurarCargado();
        Producto actual = buscarPorId(p.getIdProducto());
        if (actual == null) {
            throw new GestionException("El producto que intentas editar ya no existe.");
        }
        normalizar(p);
        validar(p);
        verificarCodigoUnico(p);
        try {
            dao.actualizar(p);
            productos.set(productos.indexOf(actual), p);
            completarCategoria(p);
        } catch (SQLException e) {
            throw traducir(e, "No se pudo actualizar el producto.", "La categoría elegida no existe.");
        }
    }

    // ---------------- Eliminar ----------------

    public void eliminar(int id) throws GestionException {
        asegurarCargado();
        Producto actual = buscarPorId(id);
        if (actual == null) {
            throw new GestionException("El producto ya no existe.");
        }
        try {
            dao.eliminar(id);
            productos.remove(actual);
        } catch (SQLException e) {
            throw traducir(e, "No se pudo eliminar el producto.",
                    "No se puede eliminar: el producto ya aparece en ventas registradas. Ponle stock 0 para ocultarlo del menú.");
        }
    }

    // ---------------- Validaciones ----------------

    private void normalizar(Producto p) {
        p.setCodigo(limpiar(p.getCodigo()).toUpperCase());
        p.setNombre(limpiar(p.getNombre()));
        p.setDescripcion(limpiar(p.getDescripcion()));
        String img = limpiar(p.getImagenUrl());
        p.setImagenUrl(img.isEmpty() ? null : img);
        p.setDisponibilidad(p.getCantidadStock() > 0);
    }

    private String limpiar(String s) {
        return s == null ? "" : s.trim();
    }

    private void validar(Producto p) throws GestionException {
        if (!CODIGO.matcher(p.getCodigo()).matches()) {
            throw new GestionException("El código debe tener de 3 a 20 caracteres: letras, números, guion o guion bajo.");
        }
        if (p.getNombre().isEmpty() || p.getNombre().length() > 150) {
            throw new GestionException("El nombre es obligatorio (máximo 150 caracteres).");
        }
        if (p.getIdCategoria() <= 0) {
            throw new GestionException("Elige una categoría.");
        }
        if (p.getPrecio() < 0 || Double.isNaN(p.getPrecio()) || p.getPrecio() > 99999999) {
            throw new GestionException("El precio no es válido.");
        }
        if (p.getCantidadStock() < 0) {
            throw new GestionException("El stock no puede ser negativo.");
        }
        String img = p.getImagenUrl();
        if (img != null) {
            boolean local = img.matches("images/[A-Za-z0-9_./-]+") && !img.contains("..");
            boolean externa = img.matches("https://[^\\s\"'<>]+");
            if ((!local && !externa) || img.length() > 255) {
                throw new GestionException("La imagen debe ser un archivo de la carpeta images (ej. images/ceviche.jpg, sin espacios) o un enlace que empiece con https://");
            }
        }
    }

    private void verificarCodigoUnico(Producto p) throws GestionException {
        for (Producto otro : productos) {
            if (otro.getIdProducto() != p.getIdProducto() && p.getCodigo().equalsIgnoreCase(otro.getCodigo())) {
                throw new GestionException("El código \"" + p.getCodigo() + "\" ya está en uso. Elige otro.");
            }
        }
    }

    // El nombre de la categoría se muestra en la tabla; se toma de la lista de categorías.
    private void completarCategoria(Producto p) {
        try {
            for (Categoria c : new CategoriaDAO().listar()) {
                if (c.getIdCategoria() == p.getIdCategoria()) {
                    p.setNombreCategoria(c.getNombre());
                    return;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private GestionException traducir(SQLException e, String general, String mensaje547) {
        e.printStackTrace();
        if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
            return new GestionException("Ese código ya está en uso. Elige otro.", e);
        }
        if (e.getErrorCode() == 547) {
            return new GestionException(mensaje547, e);
        }
        return new GestionException(general + " Revisa que SQL Server esté encendido.", e);
    }
}
