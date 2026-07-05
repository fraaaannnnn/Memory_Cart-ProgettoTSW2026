package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import org.mindrot.jbcrypt.BCrypt;
import com.bean.UtenteBean;
import java.util.*;

public class UtenteDAO {

    public boolean salvaUtente(UtenteBean utente) {
        boolean salvataggioCompletato = false;
        String query = "INSERT INTO utenti (email, nickname, pw, Abbonato, Admin) VALUES (?, ?, ?, ?, ?)";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, utente.getEmail());
            preparedStatement.setString(2, utente.getUserName());
            preparedStatement.setString(3, utente.getPw());
            preparedStatement.setBoolean(4, utente.getAbbonato());
            preparedStatement.setBoolean(5, utente.getAdmin());
            
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
    
    public boolean aggiornaAbbonamento(int idUtente, boolean statoAbbonamento) {
        String query = "UPDATE utenti SET Abbonato = ? WHERE id_utente = ?";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setBoolean(1, statoAbbonamento);
            preparedStatement.setInt(2, idUtente);
            
            int righeModificate = preparedStatement.executeUpdate();
            return righeModificate > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public boolean aggiornaDatiUtente(int idUtente, String username, String email, String hashPassword) {
        boolean cambiaPassword = (hashPassword != null);
        String query = cambiaPassword 
            ? "UPDATE utenti SET nickname = ?, Email = ?, Pw = ? WHERE id_utente = ?" 
            : "UPDATE utenti SET nickname = ?, Email = ? WHERE id_utente = ?";

        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement ps = connection.prepareStatement(query)) {
             
            ps.setString(1, username);
            ps.setString(2, email);
            
            if (cambiaPassword) {
                ps.setString(3, hashPassword);
                ps.setInt(4, idUtente);
            } else {
                ps.setInt(3, idUtente);
            }
            
            int righeModificate = ps.executeUpdate();
            return righeModificate > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
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
                        bean.setAdmin(resultSet.getBoolean("Admin"));
                        bean.setAbbonato(resultSet.getBoolean("Abbonato"));
                        bean.setUserName(resultSet.getString("nickname"));
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
    
    public boolean aggiungiAuthToken(String email, String tokenHashato) {
        boolean aggiunto = false;
        String query = "INSERT INTO authtokens (email, token) VALUES (?, ?)";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, tokenHashato);
            
            int righeModificate = preparedStatement.executeUpdate();
            if (righeModificate > 0) {
                aggiunto = true;
            }
        } catch (SQLException e) {
            System.err.println("Errore durante il salvataggio del token: " + e.getMessage());
            e.printStackTrace();
        }
        return aggiunto;
    }

    public List<String> getTokensByEmail(String email) {
        List<String> tokens = new ArrayList<>();
        String query = "SELECT token FROM authtokens WHERE email = ?";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, email);
            
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    tokens.add(resultSet.getString("token"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Errore nel recupero dei token: " + e.getMessage());
            e.printStackTrace();
        }
        return tokens;
    }

    public boolean eliminaAuthTokenSpecifico(String email, String tokenHashato) {
        boolean eliminato = false;
        String query = "DELETE FROM authtokens WHERE email = ? AND token = ?";
        
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, tokenHashato);
            
            int righeModificate = preparedStatement.executeUpdate();
            if (righeModificate > 0) {
                eliminato = true;
            }
        } catch (SQLException e) {
            System.err.println("Errore nell'eliminazione del token specifico: " + e.getMessage());
            e.printStackTrace();
        }
        return eliminato;
    }

    public UtenteBean getUtenteByEmail(String email) {
        UtenteBean bean = null;
        String query = "SELECT * FROM utenti WHERE email = ?";
        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
            preparedStatement.setString(1, email);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    bean = new UtenteBean();
                    bean.setId(resultSet.getInt("id_utente")); 
                    bean.setEmail(resultSet.getString("email"));
                    bean.setAdmin(resultSet.getBoolean("Admin"));
                    bean.setAbbonato(resultSet.getBoolean("Abbonato"));
                    bean.setUserName(resultSet.getString("nickname"));
                    bean.setPw(resultSet.getString("pw"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bean;
    }
}