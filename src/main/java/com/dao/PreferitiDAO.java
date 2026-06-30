package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.bean.ProdottoBean;

public class PreferitiDAO {

    public boolean AggiungiPreferito(int idUtente, int idProdotto) {
        String query = "INSERT IGNORE INTO preferiti (id_utente, id_prodotto) VALUES (?, ?)";
        try (Connection con = ConnessioneDB.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean RimuoviPreferito(int idUtente, int idProdotto) {
        String query = "DELETE FROM preferiti WHERE id_utente = ? AND id_prodotto = ?";
        try (Connection con = ConnessioneDB.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            ps.setInt(2, idProdotto);
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ProdottoBean> getPreferitiByUtente(int idUtente) {
        List<ProdottoBean> lista = new ArrayList<>();
        
        String query = "SELECT p.id, p.nome, p.prezzo, p.immagine, " +
                       "IFNULL(AVG(r.stelle), 0) AS media_stelle, " +
                       "COUNT(r.id_prodotto) AS num_recensioni " +
                       "FROM prodotti p " +
                       "JOIN preferiti w ON p.id = w.id_prodotto " +
                       "LEFT JOIN recensioni r ON p.id = r.id_prodotto " +
                       "WHERE w.id_utente = ? " +
                       "GROUP BY p.id, p.nome, p.prezzo, p.immagine";
        
        try (Connection con = ConnessioneDB.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, idUtente);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ProdottoBean prodotto = new ProdottoBean();
                    prodotto.setId(rs.getInt("id")); 
                    prodotto.setNome(rs.getString("nome"));
                    prodotto.setPrezzo(rs.getDouble("prezzo"));
                    prodotto.setImmagine(rs.getString("immagine"));
                    prodotto.setMediaStelle(rs.getDouble("media_stelle"));
                    prodotto.setNumeroRecensioni(rs.getInt("num_recensioni"));
                    
                    lista.add(prodotto);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }
}