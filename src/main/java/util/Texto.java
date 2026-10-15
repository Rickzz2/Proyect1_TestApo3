package util;

public class Texto {

    // Escapa texto antes de mostrarlo en una página, para que un nombre
    // como <script> se vea como texto y no se ejecute.
    public static String esc(String s) {
        if (s == null) {
            return "";
        }
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
}
