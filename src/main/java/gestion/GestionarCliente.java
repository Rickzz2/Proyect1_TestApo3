package gestion;

import dao.ClienteDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;
import modelo.Cliente;

// Gestiona la colección de clientes (un ArrayList) y la mantiene sincronizada
// con SQL Server a través de ClienteDAO.
// CRUD: agregar, actualizar, eliminar, filtrar por un campo y listar todos.
public class GestionarCliente {

    private static final Pattern CODIGO = Pattern.compile("^[A-Za-z0-9_-]{3,20}$");
    private static final Pattern CORREO = Pattern.compile("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$");

    private final ClienteDAO dao = new ClienteDAO();
    private final List<Cliente> clientes = new ArrayList<>();
    private boolean cargado = false;

    // Llena el ArrayList con lo que hay en la base de datos.
    public void cargar() throws GestionException {
        try {
            List<Cliente> deBd = dao.listar();
            clientes.clear();
            clientes.addAll(deBd);
            cargado = true;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new GestionException("No se pudo leer la lista de clientes. Revisa que SQL Server esté encendido.", e);
        }
    }

    private void asegurarCargado() throws GestionException {
        if (!cargado) {
            cargar();
        }
    }

    // ---------------- Listar / buscar / filtrar ----------------

    public List<Cliente> listar() throws GestionException {
        asegurarCargado();
        return new ArrayList<>(clientes);
    }

    public Cliente buscarPorId(int id) throws GestionException {
        asegurarCargado();
        for (Cliente c : clientes) {
            if (c.getIdCliente() == id) {
                return c;
            }
        }
        return null;
    }

    // campo: codigo, nombre, apellidos o correo. Busca texto contenido, sin importar mayúsculas.
    public List<Cliente> filtrar(String campo, String texto) throws GestionException {
        asegurarCargado();
        if (texto == null || texto.trim().isEmpty()) {
            return listar();
        }
        String buscado = texto.trim().toLowerCase();
        List<Cliente> resultado = new ArrayList<>();
        for (Cliente c : clientes) {
            String valor;
            switch (campo == null ? "" : campo) {
                case "codigo":    valor = c.getCodigo();    break;
                case "apellidos": valor = c.getApellidos(); break;
                case "correo":    valor = c.getCorreo();    break;
                default:          valor = c.getNombre();    break;
            }
            if (valor != null && valor.toLowerCase().contains(buscado)) {
                resultado.add(c);
            }
        }
        return resultado;
    }

    // ---------------- Agregar ----------------

    public void agregar(Cliente c, String password) throws GestionException {
        asegurarCargado();
        normalizar(c);
        validar(c);
        if (password == null || password.length() < 6) {
            throw new GestionException("La contraseña debe tener al menos 6 caracteres.");
        }
        verificarUnicos(c);
        try {
            int id = dao.insertar(c, password);
            c.setIdCliente(id);
            c.setRol("cliente");
            clientes.add(c);
        } catch (SQLException e) {
            throw traducir(e, "No se pudo guardar el cliente.");
        }
    }

    // ---------------- Actualizar ----------------

    // passwordNueva vacía = no cambiar la contraseña.
    public void actualizar(Cliente c, String passwordNueva) throws GestionException {
        asegurarCargado();
        Cliente actual = buscarPorId(c.getIdCliente());
        if (actual == null) {
            throw new GestionException("El cliente que intentas editar ya no existe.");
        }
        normalizar(c);
        validar(c);
        if (passwordNueva != null && !passwordNueva.isEmpty() && passwordNueva.length() < 6) {
            throw new GestionException("La contraseña nueva debe tener al menos 6 caracteres.");
        }
        verificarUnicos(c);
        try {
            dao.actualizar(c, passwordNueva);
            c.setRol(actual.getRol());
            clientes.set(clientes.indexOf(actual), c);
        } catch (SQLException e) {
            throw traducir(e, "No se pudo actualizar el cliente.");
        }
    }

    // ---------------- Eliminar ----------------

    public void eliminar(int id, int idUsuarioEnSesion) throws GestionException {
        asegurarCargado();
        if (id == idUsuarioEnSesion) {
            throw new GestionException("No puedes eliminar tu propia cuenta mientras estás conectado.");
        }
        Cliente actual = buscarPorId(id);
        if (actual == null) {
            throw new GestionException("El cliente ya no existe.");
        }
        try {
            dao.eliminar(id);
            clientes.remove(actual);
        } catch (SQLException e) {
            throw traducir(e, "No se pudo eliminar el cliente.");
        }
    }

    // ---------------- Validaciones ----------------

    private void normalizar(Cliente c) {
        c.setCodigo(limpiar(c.getCodigo()).toUpperCase());
        c.setNombre(limpiar(c.getNombre()));
        c.setApellidos(limpiar(c.getApellidos()));
        c.setCorreo(limpiar(c.getCorreo()));
        c.setTelefono(limpiar(c.getTelefono()));
        c.setDireccion(limpiar(c.getDireccion()));
    }

    private String limpiar(String s) {
        return s == null ? "" : s.trim();
    }

    private void validar(Cliente c) throws GestionException {
        if (!CODIGO.matcher(c.getCodigo()).matches()) {
            throw new GestionException("El código debe tener de 3 a 20 caracteres: letras, números, guion o guion bajo.");
        }
        if (c.getNombre().isEmpty() || c.getApellidos().isEmpty()) {
            throw new GestionException("El nombre y los apellidos son obligatorios.");
        }
        if (c.getNombre().length() > 100 || c.getApellidos().length() > 100) {
            throw new GestionException("El nombre y los apellidos admiten máximo 100 caracteres.");
        }
        if (!CORREO.matcher(c.getCorreo()).matches() || c.getCorreo().length() > 150) {
            throw new GestionException("Escribe un correo electrónico válido.");
        }
        if (c.getTelefono().length() > 20) {
            throw new GestionException("El teléfono admite máximo 20 caracteres.");
        }
    }

    // Código y correo no pueden repetirse (se ignora el propio cliente al editar).
    private void verificarUnicos(Cliente c) throws GestionException {
        for (Cliente otro : clientes) {
            if (otro.getIdCliente() == c.getIdCliente()) {
                continue;
            }
            if (c.getCodigo().equalsIgnoreCase(otro.getCodigo())) {
                throw new GestionException("El código \"" + c.getCodigo() + "\" ya está en uso. Elige otro.");
            }
            if (c.getCorreo().equalsIgnoreCase(otro.getCorreo())) {
                throw new GestionException("Ese correo ya está registrado.");
            }
        }
    }

    // Respaldo: si dos personas guardan a la vez, la BD también rechaza los repetidos.
    private GestionException traducir(SQLException e, String general) {
        e.printStackTrace();
        String detalle = String.valueOf(e.getMessage());
        if (e.getErrorCode() == 2627 || e.getErrorCode() == 2601) {
            if (detalle.contains("UQ_cliente_codigo")) {
                return new GestionException("Ese código ya está en uso. Elige otro.", e);
            }
            return new GestionException("Ese correo ya está registrado.", e);
        }
        if (e.getErrorCode() == 547) {
            return new GestionException("No se puede eliminar: el cliente tiene ventas registradas.", e);
        }
        return new GestionException(general + " Revisa que SQL Server esté encendido.", e);
    }
}
