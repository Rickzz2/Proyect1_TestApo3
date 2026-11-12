package dao;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Cliente;

public class ClienteDAO {

    // El rol no se manda aquí: la base de datos le pone 'cliente' por defecto.
    // Así nadie puede crearse una cuenta de admin desde un formulario.
    // Si el cliente no trae código (registro público), se genera uno automático.
    // Devuelve el id que le asignó SQL Server.
    public int insertar(Cliente c, String passwordPlano) throws SQLException {
        String sql = "INSERT INTO cliente (codigo, nombre, apellidos, correo, password_hash, telefono, direccion) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        if (c.getCodigo() == null || c.getCodigo().trim().isEmpty()) {
            c.setCodigo("USR-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
        }
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, c.getCodigo());
            ps.setString(2, c.getNombre());
            ps.setString(3, c.getApellidos());
            ps.setString(4, c.getCorreo());
            ps.setString(5, hashPassword(passwordPlano));
            ps.setString(6, c.getTelefono());
            ps.setString(7, c.getDireccion());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }

    // Si passwordNueva viene vacía, la contraseña actual no se toca.
    // El rol tampoco se modifica desde aquí.
    public void actualizar(Cliente c, String passwordNueva) throws SQLException {
        boolean cambiaClave = passwordNueva != null && !passwordNueva.isEmpty();
        String sql = "UPDATE cliente SET codigo = ?, nombre = ?, apellidos = ?, correo = ?, "
                + "telefono = ?, direccion = ?" + (cambiaClave ? ", password_hash = ?" : "")
                + " WHERE id_cliente = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            int i = 1;
            ps.setString(i++, c.getCodigo());
            ps.setString(i++, c.getNombre());
            ps.setString(i++, c.getApellidos());
            ps.setString(i++, c.getCorreo());
            ps.setString(i++, c.getTelefono());
            ps.setString(i++, c.getDireccion());
            if (cambiaClave) {
                ps.setString(i++, hashPassword(passwordNueva));
            }
            ps.setInt(i, c.getIdCliente());
            ps.executeUpdate();
        }
    }

    public void eliminar(int idCliente) throws SQLException {
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement("DELETE FROM cliente WHERE id_cliente = ?")) {
            ps.setInt(1, idCliente);
            ps.executeUpdate();
        }
    }

    public List<Cliente> listar() throws SQLException {
        String sql = "SELECT id_cliente, codigo, nombre, apellidos, correo, telefono, direccion, rol "
                + "FROM cliente ORDER BY id_cliente";
        List<Cliente> lista = new ArrayList<>();
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                lista.add(leerCliente(rs));
            }
        }
        return lista;
    }

    // Devuelve el cliente si el correo y la contraseña son correctos; si no, null.
    // No distingue entre "correo no existe" y "contraseña mala" a propósito.
    public Cliente autenticar(String correo, String passwordPlano) throws SQLException {
        String sql = "SELECT id_cliente, codigo, nombre, apellidos, correo, telefono, direccion, rol, password_hash "
                + "FROM cliente WHERE correo = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, correo);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && verificarPassword(passwordPlano, rs.getString("password_hash"))) {
                    return leerCliente(rs);
                }
            }
        }
        return null;
    }

    private Cliente leerCliente(ResultSet rs) throws SQLException {
        Cliente c = new Cliente(
                rs.getInt("id_cliente"),
                rs.getString("nombre"),
                rs.getString("apellidos"),
                rs.getString("correo"),
                rs.getString("telefono"),
                rs.getString("direccion"));
        c.setCodigo(rs.getString("codigo"));
        c.setRol(rs.getString("rol"));
        return c;
    }

    // ---------- Contraseñas: se guarda "sal:hash", nunca la contraseña ----------

    public static String hashPassword(String plano) {
        try {
            byte[] sal = new byte[16];
            new SecureRandom().nextBytes(sal);
            return aHex(sal) + ":" + aHex(sha256(sal, plano));
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        }
    }

    public static boolean verificarPassword(String plano, String guardado) {
        if (plano == null || guardado == null) {
            return false;
        }
        try {
            String[] partes = guardado.split(":");
            if (partes.length != 2) {
                return false;
            }
            byte[] sal = deHex(partes[0]);
            return aHex(sha256(sal, plano)).equals(partes[1]);
        } catch (NoSuchAlgorithmException e) {
            throw new IllegalStateException(e);
        } catch (NumberFormatException e) {
            return false; // el valor guardado no tiene el formato de la aplicación
        }
    }

    private static byte[] sha256(byte[] sal, String plano) throws NoSuchAlgorithmException {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        md.update(sal);
        return md.digest(plano.getBytes(StandardCharsets.UTF_8));
    }

    private static String aHex(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    private static byte[] deHex(String hex) {
        byte[] out = new byte[hex.length() / 2];
        for (int i = 0; i < out.length; i++) {
            out[i] = (byte) Integer.parseInt(hex.substring(2 * i, 2 * i + 2), 16);
        }
        return out;
    }
}
