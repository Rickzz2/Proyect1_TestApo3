package gestion;

import dao.VentaDAO;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import modelo.DatosEntrega;
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

    // Los pedidos de un solo cliente (lo que ve el cliente en "Mis pedidos").
    public List<Venta> listarDeCliente(int idCliente) throws GestionException {
        try {
            return dao.listarPorCliente(idCliente);
        } catch (SQLException e) {
            e.printStackTrace();
            throw new GestionException("No se pudieron leer tus pedidos. Revisa que SQL Server esté encendido.", e);
        }
    }

    // cantidades: id_producto -> cantidad pedida (las de 0 o menos se ignoran).
    public int registrar(int idCliente, String tipoPedido, Map<Integer, Integer> cantidades,
            DatosEntrega entrega) throws GestionException {
        if (idCliente <= 0) {
            throw new GestionException("Elige un cliente.");
        }
        if (tipoPedido == null || !TIPOS.contains(tipoPedido)) {
            throw new GestionException("Elige el tipo de pedido (Mesa, Llevar o Domicilio).");
        }
        if ("Domicilio".equals(tipoPedido)) {
            validarEntrega(entrega);
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
            return dao.registrar(idCliente, tipoPedido, items, entrega);
        } catch (SQLException e) {
            e.printStackTrace();
            if (e.getErrorCode() == 547) {
                throw new GestionException("El cliente elegido ya no existe.", e);
            }
            throw new GestionException("No se pudo registrar la venta. Revisa que SQL Server esté encendido.", e);
        }
    }

    // Para un pedido a domicilio hay que saber a quién, dónde y cómo contactarlo.
    private void validarEntrega(DatosEntrega e) throws GestionException {
        if (e == null || e.getNombreReceptor().isEmpty()) {
            throw new GestionException("Indica quién recibirá el pedido.");
        }
        if (e.getDireccion().length() < 5) {
            throw new GestionException("Escribe la dirección de entrega (calle, número, piso/depto).");
        }
        if (e.getDistrito().isEmpty()) {
            throw new GestionException("Indica el distrito o barrio de entrega.");
        }
        String digitos = e.getTelefono().replaceAll("[\\s+()-]", "");
        if (!digitos.matches("\\d{7,15}")) {
            throw new GestionException("Escribe un teléfono de contacto válido (7 a 15 dígitos).");
        }
        if (e.getNombreReceptor().length() > 150 || e.getDireccion().length() > 250
                || e.getDistrito().length() > 100 || e.getReferencia().length() > 250
                || e.getTelefono().length() > 20) {
            throw new GestionException("Alguno de los datos de entrega es demasiado largo.");
        }
    }
}
