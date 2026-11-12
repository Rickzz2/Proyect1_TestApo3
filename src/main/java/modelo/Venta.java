package modelo;

import java.util.ArrayList;
import java.util.List;

// Una venta = una fila de la tabla pedido + sus filas de detalle_pedido.
// Es la clase que RELACIONA a Cliente con Producto.
public class Venta {
    private int idVenta;
    private int idCliente;
    private String nombreCliente;
    private String fecha;
    private String estado;
    private String tipoPedido;
    private double total;
    private String nombreReceptor;
    private String direccionEntrega;
    private String distrito;
    private String referencia;
    private String telefonoContacto;
    private final List<DetalleVenta> detalles = new ArrayList<>();

    public Venta() {
    }

    public int getIdVenta() { return idVenta; }
    public void setIdVenta(int idVenta) { this.idVenta = idVenta; }

    public int getIdCliente() { return idCliente; }
    public void setIdCliente(int idCliente) { this.idCliente = idCliente; }

    public String getNombreCliente() { return nombreCliente; }
    public void setNombreCliente(String nombreCliente) { this.nombreCliente = nombreCliente; }

    public String getFecha() { return fecha; }
    public void setFecha(String fecha) { this.fecha = fecha; }

    public String getEstado() { return estado; }
    public void setEstado(String estado) { this.estado = estado; }

    public String getTipoPedido() { return tipoPedido; }
    public void setTipoPedido(String tipoPedido) { this.tipoPedido = tipoPedido; }

    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }

    public String getNombreReceptor() { return nombreReceptor; }
    public void setNombreReceptor(String nombreReceptor) { this.nombreReceptor = nombreReceptor; }

    public String getDireccionEntrega() { return direccionEntrega; }
    public void setDireccionEntrega(String direccionEntrega) { this.direccionEntrega = direccionEntrega; }

    public String getDistrito() { return distrito; }
    public void setDistrito(String distrito) { this.distrito = distrito; }

    public String getReferencia() { return referencia; }
    public void setReferencia(String referencia) { this.referencia = referencia; }

    public String getTelefonoContacto() { return telefonoContacto; }
    public void setTelefonoContacto(String telefonoContacto) { this.telefonoContacto = telefonoContacto; }

    public boolean esDomicilio() { return "Domicilio".equals(tipoPedido); }

    public List<DetalleVenta> getDetalles() { return detalles; }
}
