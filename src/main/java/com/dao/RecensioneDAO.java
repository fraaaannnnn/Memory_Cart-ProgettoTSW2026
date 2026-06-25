package com.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;
import com.bean.RecensioneBean;


public class RecensioneDAO {

	
	public List<RecensioneBean>recensioneDaIdProdotto(int id, int limite) {
        List<RecensioneBean>recensioni = new ArrayList<>();
        String query = "SELECT r.id_recensione, r.descrizione, r.stelle, u.nickname "
        		+ "FROM recensioni r "
        		+ "JOIN utenti u ON r.id_utente = u.id_utente "
        		+ "WHERE r.id_prodotto = ? "
        		+ "ORDER BY r.id_recensione DESC LIMIT ?;";
        

        try (Connection connection = ConnessioneDB.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(query)) {
             
            preparedStatement.setInt(1, id);
            preparedStatement.setInt(2, limite);
            try (ResultSet resultSet = preparedStatement.executeQuery()) {
                while (resultSet.next()) {
                	RecensioneBean bean = new RecensioneBean();
                    bean.setIdRecensione(resultSet.getInt("id_recensione"));
                    bean.setStelle(resultSet.getInt("stelle"));
                    bean.setRecensione(resultSet.getString("descrizione"));
                    bean.setNicknameUtente(resultSet.getString("nickname"));
                    recensioni.add(bean);
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante l'estrazione della recensione: " + e.getMessage());
        }
        return recensioni;
    }
	
	public boolean salvaRecensione(RecensioneBean recensione) {
		boolean salvataggioCompletato = false;
		String query = "INSERT INTO recensioni (id_utente, id_prodotto, descrizione, stelle) VALUES (?, ?, ?, ?)";
		try (Connection connection = ConnessioneDB.getConnection();
	         PreparedStatement preparedStatement = connection.prepareStatement(query)) {
				preparedStatement.setInt(1, recensione.getIdUtente());
				preparedStatement.setInt(2, recensione.getIdProdotto());
				preparedStatement.setString(3, recensione.getRecensione());   
				preparedStatement.setInt(4, recensione.getStelle());       
	            int righeModificate = preparedStatement.executeUpdate();
	
	            if (righeModificate > 0) {
	                salvataggioCompletato = true;
	            }
				
			
		} catch (SQLException e) {
			 System.err.println("Errore durante la creazione della recensione: " + e.getMessage());
	         e.printStackTrace();   
		}
		
		
		return salvataggioCompletato;
}

}