package dao;

import gestion.GestionException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import modelo.DatosEntrega;
import modelo.DetalleVenta;
import modelo.Venta;

// Una venta usa las tablas pedido y detalle_pedido que ya existían en la BD.
public class VentaDAO {

    // Registra la venta completa en UNA transacción: si algo falla (por ejemplo
    // no hay stock de un plato) no se guarda nada y el stock queda intacto.
    // items: id_producto -> cantidad. Devuelve el id de la venta creada.
    public int registrar(int idCliente, String tipoPedido, Map<Integer, Integer> items, DatosEntrega entrega)
            throws SQLException, GestionException {
        try (Connection cn = Conexion.getConexion()) {
            cn.setAutoCommit(false);
            try {
                int idRestaurante = obtenerRestaurante(cn);
                int idPedido = crearPedido(cn, idCliente, idRestaurante, tipoPedido, entrega);
                BigDecimal total = BigDecimal.ZERO;
                for (Map.Entry<Integer, Integer> e : items.entrySet()) {
                    total = total.add(agregarLinea(cn, idPedido, e.getKey(), e.getValue()));
                }
                try (PreparedStatement ps = cn.prepareStatement("UPDATE pedido SET total = ? WHERE id_pedido = ?")) {
                    ps.setBigDecimal(1, total);
                    ps.setInt(2, idPedido);
                    ps.executeUpdate();
                }
                cn.commit();
                return idPedido;
            } catch (SQLException | GestionException ex) {
                cn.rollback();
                throw ex;
            } finally {
                cn.setAutoCommit(true);
            }
        }
    }

    // La tabla pedido exige un restaurante. Se usa el primero que exista y,
    // si la tabla está vacía, se crea uno por defecto.
    private int obtenerRestaurante(Connection cn) throws SQLException {
        try (PreparedStatement ps = cn.prepareStatement("SELECT TOP 1 id_restaurante FROM restaurante ORDER BY id_restaurante");
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        String sql = "INSERT INTO restaurante (nombre, tipo_establecimiento, direccion) VALUES ('RICKZ', 'Restaurante', 'Sede principal')";
        try (PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return keys.getInt(1);
            }
        }
    }

    private int crearPedido(Connection cn, int idCliente, int idRestaurante, String tipo, DatosEntrega entrega)
            throws SQLException {
        String sql = "INSERT INTO pedido (id_cliente, id_restaurante, tipo_pedido, total, "
                + "nombre_receptor, direccion_entrega, distrito, referencia, telefono_contacto) "
                + "VALUES (?, ?, ?, 0, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, idCliente);
            ps.setInt(2, idRestaurante);
            ps.setString(3, tipo);
            // Los datos de entrega solo se guardan en pedidos a domicilio
            boolean domicilio = "Domicilio".equals(tipo) && entrega != null;
            ps.setString(4, domicilio ? vacioANulo(entrega.getNombreReceptor()) : null);
            ps.setString(5, domicilio ? vacioANulo(entrega.getDireccion()) : null);
            ps.setString(6, domicilio ? vacioANulo(entrega.getDistrito()) : null);
            ps.setString(7, domicilio ? vacioANulo(entrega.getReferencia()) : null);
            ps.setString(8, domicilio ? vacioANulo(entrega.getTelefono()) : null);
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                keys.next();
                return keys.getInt(1);
            }
        }
    }

    private static String vacioANulo(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }

    // Lee el precio y el stock REALES desde la BD (no se confía en lo que mande
    // el navegador), guarda la línea y descuenta el stock. Devuelve el subtotal.
    private BigDecimal agregarLinea(Connection cn, int idPedido, int idProducto, int cantidad)
            throws SQLException, GestionException {
        String nombre;
        BigDecimal precio;
        int stock;
        boolean disponible;
        String sel = "SELECT nombre, precio, cantidad_stock, disponibilidad "
                + "FROM producto WITH (UPDLOCK, ROWLOCK) WHERE id_producto = ?";
        try (PreparedStatement ps = cn.prepareStatement(sel)) {
            ps.setInt(1, idProducto);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    throw new GestionException("Uno de los productos ya no existe.");
                }
                nombre = rs.getString("nombre");
                precio = rs.getBigDecimal("precio");
                stock = rs.getInt("cantidad_stock");
                disponible = rs.getBoolean("disponibilidad");
            }
        }
        if (!disponible || stock < cantidad) {
            throw new GestionException("No hay stock suficiente de \"" + nombre + "\" (quedan " + stock + ").");
        }
        String ins = "INSERT INTO detalle_pedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = cn.prepareStatement(ins)) {
            ps.setInt(1, idPedido);
            ps.setInt(2, idProducto);
            ps.setInt(3, cantidad);
            ps.setBigDecimal(4, precio);
            ps.executeUpdate();
        }
        String upd = "UPDATE producto SET cantidad_stock = cantidad_stock - ?, "
                + "disponibilidad = CASE WHEN cantidad_stock - ? > 0 THEN 1 ELSE 0 END "
                + "WHERE id_producto = ?";
        try (PreparedStatement ps = cn.prepareStatement(upd)) {
            ps.setInt(1, cantidad);
            ps.setInt(2, cantidad);
            ps.setInt(3, idProducto);
            ps.executeUpdate();
        }
        return precio.multiply(BigDecimal.valueOf(cantidad));
    }

    // Las últimas ventas, cada una con su detalle.
    public List<Venta> listar() throws SQLException {
        return listar(null);
    }

    // Las últimas ventas de UN cliente (para la sección "Mis pedidos").
    public List<Venta> listarPorCliente(int idCliente) throws SQLException {
        return listar(idCliente);
    }

    private List<Venta> listar(Integer idCliente) throws SQLException {
        Map<Integer, Venta> porId = new LinkedHashMap<>();
        SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy HH:mm");
        String sql = "SELECT TOP 100 p.id_pedido, p.id_cliente, c.nombre, c.apellidos, p.fecha, p.estado, p.tipo_pedido, p.total, "
                + "p.nombre_receptor, p.direccion_entrega, p.distrito, p.referencia, p.telefono_contacto "
                + "FROM pedido p JOIN cliente c ON c.id_cliente = p.id_cliente "
                + (idCliente == null ? "" : "WHERE p.id_cliente = ? ")
                + "ORDER BY p.id_pedido DESC";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            if (idCliente != null) {
                ps.setInt(1, idCliente);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Venta v = new Venta();
                v.setIdVenta(rs.getInt("id_pedido"));
                v.setIdCliente(rs.getInt("id_cliente"));
                v.setNombreCliente(rs.getString("nombre") + " " + rs.getString("apellidos"));
                v.setFecha(rs.getTimestamp("fecha") == null ? "" : formato.format(rs.getTimestamp("fecha")));
                v.setEstado(rs.getString("estado"));
                v.setTipoPedido(rs.getString("tipo_pedido"));
                v.setTotal(rs.getBigDecimal("total").doubleValue());
                v.setNombreReceptor(rs.getString("nombre_receptor"));
                v.setDireccionEntrega(rs.getString("direccion_entrega"));
                v.setDistrito(rs.getString("distrito"));
                v.setReferencia(rs.getString("referencia"));
                v.setTelefonoContacto(rs.getString("telefono_contacto"));
                porId.put(v.getIdVenta(), v);
            }
            rs.close();
            if (porId.isEmpty()) {
                return new ArrayList<>();
            }
            String det = "SELECT d.id_pedido, d.id_producto, pr.nombre, d.cantidad, d.precio_unitario, d.subtotal "
                    + "FROM detalle_pedido d JOIN producto pr ON pr.id_producto = d.id_producto "
                    + "ORDER BY d.id_detalle";
            try (PreparedStatement ps2 = cn.prepareStatement(det);
                 ResultSet rs2 = ps2.executeQuery()) {
                while (rs2.next()) {
                    Venta v = porId.get(rs2.getInt("id_pedido"));
                    if (v == null) {
                        continue; // venta más antigua que las 100 mostradas
                    }
                    DetalleVenta d = new DetalleVenta();
                    d.setIdProducto(rs2.getInt("id_producto"));
                    d.setNombreProducto(rs2.getString("nombre"));
                    d.setCantidad(rs2.getInt("cantidad"));
                    d.setPrecioUnitario(rs2.getBigDecimal("precio_unitario").doubleValue());
                    d.setSubtotal(rs2.getBigDecimal("subtotal").doubleValue());
                    v.getDetalles().add(d);
                }
            }
        }
        return new ArrayList<>(porId.values());
    }
}
