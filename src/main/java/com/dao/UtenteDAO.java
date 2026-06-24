package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import com.bean.UtenteBean;

public class UtenteDAO {

    public boolean salvaUtente(UtenteBean utente) {
        boolean salvataggioCompletato = false;
        String query = "INSERT INTO utenti (email, pw, isAdmin) VALUES (?, ?, ?)";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, utente.getEmail());
            preparedStatement.setString(2, utente.getPw());
            preparedStatement.setBoolean(3, utente.getAdmin());
            
            int righeModificate = preparedStatement.executeUpdate();

            if (righeModificate > 0) {
                salvataggioCompletato = true;
            }

        } catch (SQLException e) {
            System.err.println("Errore durante la registrazione dell'utente: " + e.getMessage());
            e.printStackTrace();
        }
        
        return salvataggioCompletato;
    }

    public UtenteBean loginUtente(String email, String passwordInChiaro) {
        UtenteBean bean = null;
        
        String query = "SELECT * FROM utenti WHERE email = ?";

        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, email);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    String hashSalvato = resultSet.getString("pw");
                    
                    if (BCrypt.checkpw(passwordInChiaro, hashSalvato)) {
                        
                        bean = new UtenteBean();
                        bean.setId(resultSet.getInt("id_utente")); 
                        bean.setEmail(resultSet.getString("email"));
                        bean.setPw(hashSalvato); 
                        bean.setAdmin(resultSet.getBoolean("isAdmin"));
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante il login: " + e.getMessage());
            e.printStackTrace();
        }
        
        return bean; 
    }

    public boolean emailEsistente(String email) {
        boolean exists = false;
        String query = "SELECT email FROM utenti WHERE email = ?";

        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, email);

            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    exists = true;
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante la verifica dell'email: " + e.getMessage());
            e.printStackTrace();
        }
        
        return exists;
    }
    
    public boolean salvaRememberToken(String email, String token) {
        boolean aggiornato = false;
        
        String query = "UPDATE utenti SET remember_token = ? WHERE email = ?";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, token);
            preparedStatement.setString(2, email);
            
            int righeModificate = preparedStatement.executeUpdate();
            if (righeModificate > 0) {
                aggiornato = true;
            }
            
        } catch (SQLException e) {
            System.err.println("Errore durante il salvataggio del token: " + e.getMessage());
            e.printStackTrace();
        }
        
        return aggiornato;
    }
}