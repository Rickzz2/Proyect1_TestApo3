package modelo;

// Datos que hacen falta para llevar un pedido a domicilio.
public class DatosEntrega {
    private String nombreReceptor;
    private String direccion;
    private String distrito;
    private String referencia;
    private String telefono;

    public DatosEntrega() {
    }

    public DatosEntrega(String nombreReceptor, String direccion, String distrito, String referencia, String telefono) {
        this.nombreReceptor = limpiar(nombreReceptor);
        this.direccion = limpiar(direccion);
        this.distrito = limpiar(distrito);
        this.referencia = limpiar(referencia);
        this.telefono = limpiar(telefono);
    }

    private static String limpiar(String s) {
        return s == null ? "" : s.trim();
    }

    public String getNombreReceptor() { return nombreReceptor; }
    public String getDireccion() { return direccion; }
    public String getDistrito() { return distrito; }
    public String getReferencia() { return referencia; }
    public String getTelefono() { return telefono; }
}
