package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.*;
import com.bean.ProdottoBean;
import com.bean.OrdineBean;

public class OrdineDAO {

    public boolean salvaOrdineCompleto(int idUtente, Map<Integer, Integer> carrello, double totale, String nome, String cognome, String indirizzo, String citta, String cap) {
        Connection conn = null;
        
        try {
            conn = ConnessioneDB.getConnection(); 
            conn.setAutoCommit(false); 

            String sqlOrdine = "INSERT INTO ordini (id_utente, totale_ordine, nome_spedizione, cognome_spedizione, indirizzo_spedizione, citta_spedizione, cap_spedizione) VALUES (?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement psOrdine = conn.prepareStatement(sqlOrdine, Statement.RETURN_GENERATED_KEYS);
            psOrdine.setInt(1, idUtente);
            psOrdine.setDouble(2, totale);
            psOrdine.setString(3, nome);
            psOrdine.setString(4, cognome);
            psOrdine.setString(5, indirizzo);
            psOrdine.setString(6, citta);
            psOrdine.setString(7, cap);
            psOrdine.executeUpdate();

            ResultSet rs = psOrdine.getGeneratedKeys();
            int idOrdine = 0;
            if (rs.next()) {
                idOrdine = rs.getInt(1);
            }

            String sqlDettaglio = "INSERT INTO dettagli_ordine (id_ordine, id_prodotto, quantita, prezzo_acquisto) VALUES (?, ?, ?, ?)";
            String sqlAggiornaStock = "UPDATE prodotti SET quantita_magazzino = quantita_magazzino - ? WHERE id = ? AND quantita_magazzino >= ?";
            
            PreparedStatement psDettaglio = conn.prepareStatement(sqlDettaglio);
            PreparedStatement psAggiornaStock = conn.prepareStatement(sqlAggiornaStock);
            ProdottoDAO prodottoDAO = new ProdottoDAO();

            for (Map.Entry<Integer, Integer> entry : carrello.entrySet()) {
                int idProdotto = entry.getKey();
                int quantitaAcquistata = entry.getValue();
                ProdottoBean bean = prodottoDAO.prodottoDaId(idProdotto);

                psDettaglio.setInt(1, idOrdine);
                psDettaglio.setInt(2, idProdotto);
                psDettaglio.setInt(3, quantitaAcquistata);
                psDettaglio.setDouble(4, bean.getPrezzo());
                psDettaglio.executeUpdate();

                psAggiornaStock.setInt(1, quantitaAcquistata);
                psAggiornaStock.setInt(2, idProdotto);
                psAggiornaStock.setInt(3, quantitaAcquistata);
                int righeAggiornate = psAggiornaStock.executeUpdate();

                if (righeAggiornate == 0) {
                    conn.rollback();
                    return false;
                }
            }

            String sqlSvuotaCarrello = "DELETE FROM carrello WHERE id_utente = ?";
            PreparedStatement psSvuota = conn.prepareStatement(sqlSvuotaCarrello);
            psSvuota.setInt(1, idUtente);
            psSvuota.executeUpdate();

            conn.commit(); 
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (conn != null) {
                try { 
                    conn.setAutoCommit(true);
                    conn.close(); 
                } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }
    public List<OrdineBean> getOrdiniByUtente(int idUtente) {
        List<OrdineBean> ordini = new ArrayList<>();
        String sql = "SELECT * FROM ordini WHERE id_utente = ? ORDER BY data_ordine DESC, id_ordine DESC";
        
        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setInt(1, idUtente);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrdineBean ordine = new OrdineBean();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setIdUtente(rs.getInt("id_utente"));
                    ordine.setDataOrdine(rs.getDate("data_ordine"));
                    ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                    String statoDb = rs.getString("stato");
                    if (statoDb != null) {
                        String statoPulito = statoDb.trim().toUpperCase().replace(" ", "_");
                        try {
                            ordine.setStato(com.bean.OrdineBean.Stato.valueOf(statoPulito));
                        } catch (IllegalArgumentException e) {
                            ordine.setStato(com.bean.OrdineBean.Stato.IN_PREPARAZIONE);
                        }
                    } else {
                        ordine.setStato(com.bean.OrdineBean.Stato.IN_PREPARAZIONE);
                    }
                    
                    ordini.add(ordine);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ordini;
    }
    
    public com.bean.OrdineBean getOrdineById(int idOrdine) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        com.bean.OrdineBean ordine = null;

        String sql = "SELECT * FROM ordini WHERE id_ordine = ?";
        
        try {
            conn = ConnessioneDB.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idOrdine);
            rs = ps.executeQuery();

            if (rs.next()) {
                ordine = new com.bean.OrdineBean();
                ordine.setIdOrdine(rs.getInt("id_ordine"));
                ordine.setIdUtente(rs.getInt("id_utente"));
                ordine.setDataOrdine(rs.getDate("data_ordine"));
                ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                
                String statoDb = rs.getString("stato");
                if (statoDb != null) {
                    ordine.setStato(com.bean.OrdineBean.Stato.valueOf(statoDb.toUpperCase()));
                }
                
                ordine.setNomeSpedizione(rs.getString("nome_spedizione"));
                ordine.setCognomeSpedizione(rs.getString("cognome_spedizione"));
                ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                ordine.setCittaSpedizione(rs.getString("citta_spedizione"));
                ordine.setCapSpedizione(rs.getString("cap_spedizione"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return ordine;
    }
    
    public com.bean.OrdineBean getUltimoOrdineUtente(int idUtente) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        com.bean.OrdineBean ordine = null;

        String sql = "SELECT * FROM ordini WHERE id_utente = ? ORDER BY id_ordine DESC LIMIT 1";

        try {
            conn = ConnessioneDB.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, idUtente);
            rs = ps.executeQuery();

            if (rs.next()) {
                ordine = new com.bean.OrdineBean();
                ordine.setIdOrdine(rs.getInt("id_ordine"));
                ordine.setIdUtente(rs.getInt("id_utente"));
                ordine.setDataOrdine(rs.getDate("data_ordine"));
                ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                
                String statoDb = rs.getString("stato");
                if (statoDb != null) {
                    try {
                        ordine.setStato(com.bean.OrdineBean.Stato.valueOf(statoDb.toUpperCase()));
                    } catch (IllegalArgumentException e) {
                        ordine.setStato(com.bean.OrdineBean.Stato.IN_PREPARAZIONE);
                    }
                } else {
                    ordine.setStato(com.bean.OrdineBean.Stato.IN_PREPARAZIONE);
                }
                
                ordine.setNomeSpedizione(rs.getString("nome_spedizione"));
                ordine.setCognomeSpedizione(rs.getString("cognome_spedizione"));
                ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                ordine.setCittaSpedizione(rs.getString("citta_spedizione"));
                ordine.setCapSpedizione(rs.getString("cap_spedizione"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception e) {}
            try { if (ps != null) ps.close(); } catch (Exception e) {}
            try { if (conn != null) conn.close(); } catch (Exception e) {}
        }
        return ordine;
    }
    
    public List<com.bean.ProdottoBean> getProdottiOrdine(int idOrdine) {
        List<com.bean.ProdottoBean> prodotti = new ArrayList<>();
        String sql = "SELECT p.id, p.nome, p.immagine, d.quantita, d.prezzo_acquisto " +
                     "FROM dettagli_ordine d " +
                     "INNER JOIN prodotti p ON d.id_prodotto = p.id " +
                     "WHERE d.id_ordine = ?";

        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, idOrdine);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    com.bean.ProdottoBean p = new com.bean.ProdottoBean();
                    p.setId(rs.getInt("id"));
                    p.setNome(rs.getString("nome"));
                    p.setImmagine(rs.getString("immagine"));
                    p.setQuantita(rs.getInt("quantita")); 
                    p.setPrezzo(rs.getDouble("prezzo_acquisto"));
                    
                    prodotti.add(p);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return prodotti;
    }

    public void aggiornaStatoOrdine(int idOrdine, String nuovoStato) {
        String sql = "UPDATE ordini SET stato = ? WHERE id_ordine = ?";
        
        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
             
            ps.setString(1, nuovoStato);
            ps.setInt(2, idOrdine);
            ps.executeUpdate();
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    public List<OrdineBean> getOrdiniFiltratiAdmin(String dataInizio, String dataFine, String idUtenteParam) {
        List<OrdineBean> ordini = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT * FROM ordini WHERE 1=1");
        
        if (dataInizio != null && !dataInizio.trim().isEmpty()) {
            query.append(" AND data_ordine >= ?");
        }
        if (dataFine != null && !dataFine.trim().isEmpty()) {
            query.append(" AND data_ordine <= ?");
        }
        if (idUtenteParam != null && !idUtenteParam.trim().isEmpty()) {
            query.append(" AND id_utente = ?");
        }
        
        query.append(" ORDER BY data_ordine DESC, id_ordine DESC");

        try (Connection conn = ConnessioneDB.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            
        	int paramIndex = 1;
            
            if (dataInizio != null && !dataInizio.trim().isEmpty()) {
                ps.setDate(paramIndex++, java.sql.Date.valueOf(dataInizio)); 
            }
            if (dataFine != null && !dataFine.trim().isEmpty()) {
                ps.setDate(paramIndex++, java.sql.Date.valueOf(dataFine));
            }
            if (idUtenteParam != null && !idUtenteParam.trim().isEmpty()) {
                ps.setInt(paramIndex++, Integer.parseInt(idUtenteParam));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrdineBean ordine = new OrdineBean();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setIdUtente(rs.getInt("id_utente"));
                    ordine.setDataOrdine(rs.getDate("data_ordine"));
                    ordine.setTotaleOrdine(rs.getDouble("totale_ordine"));
                    
                    String statoDb = rs.getString("stato");
                    if (statoDb != null) {
                        try {
                            ordine.setStato(OrdineBean.Stato.valueOf(statoDb.toUpperCase()));
                        } catch (IllegalArgumentException e) {
                            ordine.setStato(OrdineBean.Stato.IN_PREPARAZIONE);
                        }
                    } else {
                        ordine.setStato(OrdineBean.Stato.IN_PREPARAZIONE);
                    }
                    ordini.add(ordine);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ordini;
    }
    
}