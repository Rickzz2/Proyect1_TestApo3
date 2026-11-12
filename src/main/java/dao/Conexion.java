package dao;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class Conexion {

    private static final Properties CONFIG = new Properties();

    static {
        // En tu PC la configuración sale de db.properties.
        // En la nube ese archivo no existe: se usan las variables de entorno.
        try (InputStream in = Conexion.class.getResourceAsStream("/db.properties")) {
            if (in != null) {
                CONFIG.load(in);
            }
        } catch (IOException e) {
            throw new IllegalStateException("No se pudo leer db.properties", e);
        }
    }

    // Las variables de entorno (DB_URL, DB_USER, DB_PASSWORD) tienen prioridad.
    private static String valor(String variableEntorno, String clave) {
        String v = System.getenv(variableEntorno);
        return (v != null && !v.isBlank()) ? v : CONFIG.getProperty(clave);
    }

    public static Connection getConexion() throws SQLException {
        String url = valor("DB_URL", "db.url");
        if (url == null) {
            throw new SQLException("Falta la configuración de la base de datos: "
                    + "crea db.properties o define DB_URL, DB_USER y DB_PASSWORD");
        }
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Falta el driver de SQL Server: agrega mssql-jdbc al pom.xml", e);
        }
        return DriverManager.getConnection(
                url,
                valor("DB_USER", "db.user"),
                valor("DB_PASSWORD", "db.password"));
    }
}
