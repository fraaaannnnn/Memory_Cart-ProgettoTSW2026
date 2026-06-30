package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import com.bean.ProdottoBean;

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
}