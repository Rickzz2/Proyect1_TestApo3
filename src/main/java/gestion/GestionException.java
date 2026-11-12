package gestion;

// Error "esperado" de la lógica (dato inválido, código repetido, sin stock...).
// El mensaje está pensado para mostrarse tal cual al usuario.
public class GestionException extends Exception {

    public GestionException(String mensaje) {
        super(mensaje);
    }

    public GestionException(String mensaje, Throwable causa) {
        super(mensaje, causa);
    }
}
