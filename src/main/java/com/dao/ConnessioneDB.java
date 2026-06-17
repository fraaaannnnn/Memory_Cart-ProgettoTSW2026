package com.dao;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class ConnessioneDB {

    private static DataSource ds;

    static {
        try {
            Context initCtx = new InitialContext();
            
            Context envCtx = (Context) initCtx.lookup("java:comp/env");

            ds = (DataSource) envCtx.lookup("jdbc/jdbc/MemoryCartDB");
            
        } catch (NamingException e) {
            System.err.println("Errore critico: impossibile trovare la risorsa DB nel context.xml. " + e.getMessage());
        }
    }

    public static Connection getConnection() throws SQLException {
        if (ds == null) {
            throw new SQLException("Il DataSource non è stato inizializzato. Controlla la sintassi del tuo context.xml e assicurati che sia nella cartella META-INF.");
        }
        
        return ds.getConnection();
    }
}
