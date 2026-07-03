package com.dao;

import com.bean.ProdottoBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ProdottoDAO {

    private static final String NOME_TABELLA = "prodotti";

    public List<ProdottoBean> getProdottiInEvidenza(int limit) {
        List<ProdottoBean> prodotti = new ArrayList<>();
        
        String query = "SELECT * FROM " + NOME_TABELLA + " WHERE quantita_magazzino > 0 ORDER BY id DESC LIMIT ?";

        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, limit);
            
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                    ProdottoBean bean = new ProdottoBean();
                    
                    bean.setId(resultSet.getInt("id"));
                    bean.setNome(resultSet.getString("nome"));
                    bean.setDescrizione(resultSet.getString("descrizione"));
                    bean.setPrezzo(resultSet.getDouble("prezzo"));
                    bean.setImmagine(resultSet.getString("immagine"));
                    bean.setMediaStelle(resultSet.getDouble("media_stelle"));
                    bean.setNumeroRecensioni(resultSet.getInt("totale_recensioni"));
                    bean.setQuantita(resultSet.getInt("quantita_magazzino"));
                    prodotti.add(bean);
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante l'estrazione dei prodotti in evidenza: " + e.getMessage());
        }

        return prodotti;
    }
    
    public ProdottoBean prodottoDaId(int id) {
        ProdottoBean bean = null;
        String query = "SELECT * FROM " + NOME_TABELLA + " WHERE id = ?";

        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, id);
            
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                if (resultSet.next()) {
                    bean = new ProdottoBean();
                    bean.setId(resultSet.getInt("id"));
                    bean.setNome(resultSet.getString("nome"));
                    bean.setDescrizione(resultSet.getString("descrizione"));
                    bean.setPrezzo(resultSet.getDouble("prezzo"));
                    bean.setImmagine(resultSet.getString("immagine"));
                    bean.setMediaStelle(resultSet.getDouble("media_stelle"));
                    bean.setNumeroRecensioni(resultSet.getInt("totale_recensioni"));
                    bean.setQuantita(resultSet.getInt("quantita_magazzino"));	
                    bean.setIdTipo(resultSet.getInt("id_tipo"));
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante l'estrazione del prodotto per ID: " + e.getMessage());
        }

        return bean;
    }
    
    public List<ProdottoBean> getProdottiFiltrati(String[] categorie, String prezzoMax, String sort, String searchQuery, int limit, int offset) {
        List<ProdottoBean> lista = new ArrayList<>();
        
        StringBuilder query = new StringBuilder("SELECT * FROM prodotti WHERE 1=1");
        
        if (categorie != null && categorie.length > 0) {
            query.append(" AND id_tipo IN (");
            for (int i = 0; i < categorie.length; i++) {
                query.append("?");
                if (i < categorie.length - 1) {
                    query.append(",");
                }
            }
            query.append(")");
        }
        
        if (prezzoMax != null && !prezzoMax.trim().isEmpty()) {
            query.append(" AND prezzo <= ?");
        }
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND nome LIKE ?");
        }
        
        
        if (sort != null) {
            switch (sort) {
                case "price_asc":
                    query.append(" ORDER BY prezzo ASC");
                    break;
                case "price_desc":
                    query.append(" ORDER BY prezzo DESC");
                    break;
                case "name_asc":
                    query.append(" ORDER BY nome ASC");
                    break;
                case "new":
                default:
                    query.append(" ORDER BY id DESC");
                    break;
            }
        } else {
            query.append(" ORDER BY id DESC"); 
        }
        query.append(" LIMIT ? OFFSET ?");
        
        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1; 
            
            if (categorie != null && categorie.length > 0) {
                for (String cat : categorie) {
                    ps.setInt(paramIndex++, Integer.parseInt(cat));
                }
            }
            
            if (prezzoMax != null && !prezzoMax.trim().isEmpty()) {
                ps.setDouble(paramIndex++, Double.parseDouble(prezzoMax));
            }
            
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery.trim() + "%"); 
            }
            
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                ProdottoBean bean = new ProdottoBean();
                bean.setId(rs.getInt("id"));
                bean.setNome(rs.getString("nome"));
                bean.setPrezzo(rs.getDouble("prezzo"));
                bean.setImmagine(rs.getString("immagine"));
                bean.setMediaStelle(rs.getDouble("media_stelle"));
                bean.setNumeroRecensioni(rs.getInt("totale_recensioni"));
                bean.setQuantita(rs.getInt("quantita_magazzino"));
                lista.add(bean);
            }
        } catch (SQLException e) {
            System.err.println("Errore query filtrata: " + e.getMessage());
        }
        
        return lista;
    }
    
    public void salvaProdotto(ProdottoBean p) {
        String query = "INSERT INTO prodotti (nome, prezzo, immagine, quantita_magazzino, descrizione, id_tipo) VALUES (?, ?, ?, ?, ?, ?)";
        
        try (java.sql.Connection con = ConnessioneDB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPrezzo());
            ps.setString(3, p.getImmagine());
            ps.setInt(4, p.getQuantita());
            ps.setString(5, p.getDescrizione());
            ps.setInt(6, p.getIdTipo()); 
            
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void modificaProdotto(ProdottoBean p) {
        String query = "UPDATE prodotti SET nome = ?, prezzo = ?, immagine = ?, quantita_magazzino = ?, descrizione = ?, id_tipo = ? WHERE id = ?";
        
        try (java.sql.Connection con = ConnessioneDB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setString(1, p.getNome());
            ps.setDouble(2, p.getPrezzo());
            ps.setString(3, p.getImmagine());
            ps.setInt(4, p.getQuantita());
            ps.setString(5, p.getDescrizione());
            ps.setInt(6, p.getIdTipo());
            ps.setInt(7, p.getId());
            
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
    }
    
    public void eliminaProdotto(int id) {
        String query = "DELETE FROM prodotti WHERE id = ?";
        try (Connection con = ConnessioneDB.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public Map<Integer, String> getCategorie() {
        Map<Integer, String> categorie = new LinkedHashMap<>();
        String query = "SELECT id, descrizione FROM tipo_prodotto"; 
        
        try (Connection con = ConnessioneDB.getConnection();
             PreparedStatement ps = con.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categorie.put(rs.getInt("id"), rs.getString("descrizione"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categorie;
    }
    
    public List<ProdottoBean> ProdottiAdmin() {
        List<ProdottoBean> lista = new ArrayList<>();
        String query = "SELECT * FROM prodotti"; 
        
        try (java.sql.Connection con = ConnessioneDB.getConnection();
             java.sql.PreparedStatement ps = con.prepareStatement(query);
             java.sql.ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                ProdottoBean p = new ProdottoBean();
                p.setId(rs.getInt("id"));
                p.setNome(rs.getString("nome"));
                p.setPrezzo(rs.getDouble("prezzo"));
                p.setImmagine(rs.getString("immagine"));
                p.setQuantita(rs.getInt("quantita_magazzino"));
                lista.add(p);
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return lista;
    }

    public int contaProdottiFiltrati(String[] categorie, String prezzoMax, String searchQuery) {
        int totale = 0;
        StringBuilder query = new StringBuilder("SELECT COUNT(*) FROM prodotti WHERE 1=1");
        
        if (categorie != null && categorie.length > 0) {
            query.append(" AND id_tipo IN (");
            for (int i = 0; i < categorie.length; i++) {
                query.append("?");
                if (i < categorie.length - 1) query.append(",");
            }
            query.append(")");
        }
        
        if (prezzoMax != null && !prezzoMax.trim().isEmpty()) {
            query.append(" AND prezzo <= ?");
        }
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            query.append(" AND nome LIKE ?");
        }

        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
            int paramIndex = 1;
            
            if (categorie != null && categorie.length > 0) {
                for (String cat : categorie) {
                    ps.setInt(paramIndex++, Integer.parseInt(cat));
                }
            }
            if (prezzoMax != null && !prezzoMax.trim().isEmpty()) {
                ps.setDouble(paramIndex++, Double.parseDouble(prezzoMax));
            }
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                ps.setString(paramIndex++, "%" + searchQuery.trim() + "%"); 
            }
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                totale = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totale;
    }
    
    public boolean aggiornaMagazzinoDopoAcquisto(int idProdotto, int quantitaAcquistata) {
        String query = "UPDATE prodotti SET quantita_magazzino = quantita_magazzino - ? WHERE id = ? AND quantita_magazzino >= ?";
        
        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            
            ps.setInt(1, quantitaAcquistata);
            ps.setInt(2, idProdotto);
            ps.setInt(3, quantitaAcquistata);
            
            int righeAggiornate = ps.executeUpdate();
            
             return righeAggiornate > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
	