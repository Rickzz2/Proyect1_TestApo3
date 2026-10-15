package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import modelo.Producto;

public class ProductoDAO {

    public void insertar(Producto p) throws SQLException {
        String sql = "INSERT INTO producto (id_categoria, nombre, descripcion, precio, cantidad_stock, disponibilidad) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setInt(1, p.getIdCategoria());
            ps.setString(2, p.getNombre());
            ps.setString(3, p.getDescripcion());
            ps.setBigDecimal(4, BigDecimal.valueOf(p.getPrecio()));
            ps.setInt(5, p.getCantidadStock());
            ps.setBoolean(6, p.isDisponibilidad());
            ps.executeUpdate();
        }
    }

    public List<Producto> listar() throws SQLException {
        String sql = "SELECT p.id_producto, p.id_categoria, c.nombre AS categoria, p.nombre, "
                + "p.descripcion, p.precio, p.cantidad_stock, p.disponibilidad "
                + "FROM producto p JOIN categoria c ON c.id_categoria = p.id_categoria "
                + "ORDER BY p.id_producto";
        List<Producto> lista = new ArrayList<>();
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setNombreCategoria(rs.getString("categoria"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getBigDecimal("precio").doubleValue());
                p.setCantidadStock(rs.getInt("cantidad_stock"));
                p.setDisponibilidad(rs.getBoolean("disponibilidad"));
                lista.add(p);
            }
        }
        return lista;
    }
}
