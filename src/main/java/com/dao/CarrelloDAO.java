package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

public class CarrelloDAO {

    public boolean salvaOIncrementa(int idUtente, int idProdotto, int quantita) {
        String query = "INSERT INTO carrello (id_utente, id_prodotto, quantita) VALUES (?, ?, ?) " +
                       "ON DUPLICATE KEY UPDATE quantita = quantita + ?";
        
        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            ps.setInt(3, quantita);
            ps.setInt(4, quantita);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Map<Integer, Integer> getCarrelloUtente(int idUtente) {
        Map<Integer, Integer> carrello = new HashMap<>();
        String query = "SELECT id_prodotto, quantita FROM carrello WHERE id_utente = ?";
        
        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    carrello.put(rs.getInt("id_prodotto"), rs.getInt("quantita"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return carrello;
    }
}