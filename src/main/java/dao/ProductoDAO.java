package dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import modelo.Producto;

public class ProductoDAO {

    // Devuelve el id que le asignó SQL Server.
    public int insertar(Producto p) throws SQLException {
        String sql = "INSERT INTO producto (codigo, id_categoria, nombre, descripcion, precio, cantidad_stock, disponibilidad, imagen_url) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, p.getCodigo());
            ps.setInt(2, p.getIdCategoria());
            ps.setString(3, p.getNombre());
            ps.setString(4, p.getDescripcion());
            ps.setBigDecimal(5, BigDecimal.valueOf(p.getPrecio()));
            ps.setInt(6, p.getCantidadStock());
            ps.setBoolean(7, p.isDisponibilidad());
            ps.setString(8, p.getImagenUrl());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                return keys.next() ? keys.getInt(1) : 0;
            }
        }
    }

    public void actualizar(Producto p) throws SQLException {
        String sql = "UPDATE producto SET codigo = ?, id_categoria = ?, nombre = ?, descripcion = ?, "
                + "precio = ?, cantidad_stock = ?, disponibilidad = ?, imagen_url = ? "
                + "WHERE id_producto = ?";
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql)) {
            ps.setString(1, p.getCodigo());
            ps.setInt(2, p.getIdCategoria());
            ps.setString(3, p.getNombre());
            ps.setString(4, p.getDescripcion());
            ps.setBigDecimal(5, BigDecimal.valueOf(p.getPrecio()));
            ps.setInt(6, p.getCantidadStock());
            ps.setBoolean(7, p.isDisponibilidad());
            ps.setString(8, p.getImagenUrl());
            ps.setInt(9, p.getIdProducto());
            ps.executeUpdate();
        }
    }

    public void eliminar(int idProducto) throws SQLException {
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement("DELETE FROM producto WHERE id_producto = ?")) {
            ps.setInt(1, idProducto);
            ps.executeUpdate();
        }
    }

    public List<Producto> listar() throws SQLException {
        String sql = "SELECT p.id_producto, p.codigo, p.id_categoria, c.nombre AS categoria, p.nombre, "
                + "p.descripcion, p.precio, p.cantidad_stock, p.disponibilidad, p.imagen_url "
                + "FROM producto p JOIN categoria c ON c.id_categoria = p.id_categoria "
                + "ORDER BY p.id_producto";
        List<Producto> lista = new ArrayList<>();
        try (Connection cn = Conexion.getConexion();
             PreparedStatement ps = cn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Producto p = new Producto();
                p.setIdProducto(rs.getInt("id_producto"));
                p.setCodigo(rs.getString("codigo"));
                p.setIdCategoria(rs.getInt("id_categoria"));
                p.setNombreCategoria(rs.getString("categoria"));
                p.setNombre(rs.getString("nombre"));
                p.setDescripcion(rs.getString("descripcion"));
                p.setPrecio(rs.getBigDecimal("precio").doubleValue());
                p.setCantidadStock(rs.getInt("cantidad_stock"));
                p.setDisponibilidad(rs.getBoolean("disponibilidad"));
                p.setImagenUrl(rs.getString("imagen_url"));
                lista.add(p);
            }
        }
        return lista;
    }
}
