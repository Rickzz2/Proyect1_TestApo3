package gestion;

import dao.VentaDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import modelo.Venta;

// Gestiona las ventas: la clase que RELACIONA un cliente con varios productos.
public class GestionarVenta {

    public static final Set<String> TIPOS = Set.of("Mesa", "Llevar", "Domicilio");

    private final VentaDAO dao = new VentaDAO();
    private final List<Venta> ventas = new ArrayList<>();
    private boolean cargado = false;

    public void cargar() throws GestionException {
        try {
            List<Venta> deBd = dao.listar();
            ventas.clear();
            ventas.addAll(deBd);
            cargado = true;
        } catch (SQLException e) {
            e.printStackTrace();
            throw new GestionException("No se pudo leer la lista de ventas. Revisa que SQL Server esté encendido.", e);
        }
    }

    public List<Venta> listar() throws GestionException {
        if (!cargado) {
            cargar();
        }
        return new ArrayList<>(ventas);
    }

    // cantidades: id_producto -> cantidad pedida (las de 0 o menos se ignoran).
    public int registrar(int idCliente, String tipoPedido, Map<Integer, Integer> cantidades) throws GestionException {
        if (idCliente <= 0) {
            throw new GestionException("Elige un cliente.");
        }
        if (tipoPedido == null || !TIPOS.contains(tipoPedido)) {
            throw new GestionException("Elige el tipo de pedido (Mesa, Llevar o Domicilio).");
        }
        Map<Integer, Integer> items = new LinkedHashMap<>();
        for (Map.Entry<Integer, Integer> e : cantidades.entrySet()) {
            if (e.getValue() != null && e.getValue() > 0) {
                items.put(e.getKey(), e.getValue());
            }
        }
        if (items.isEmpty()) {
            throw new GestionException("Agrega al menos un producto con cantidad mayor a 0.");
        }
        try {
            return dao.registrar(idCliente, tipoPedido, items);
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 547) {
                throw new GestionException("El cliente elegido ya no existe.", e);
            }
            throw new GestionException("No se pudo registrar la venta. Revisa que SQL Server esté encendido.", e);
        }
    }
}
