package com.dao;

import com.bean.ProdottoBean;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProdottoDAO {

    private static final String NOME_TABELLA = "prodotti";

    public List<ProdottoBean> getProdottiInEvidenza(int limit) {
        List<ProdottoBean> prodotti = new ArrayList<>();
        
        String query = "SELECT * FROM " + NOME_TABELLA + " ORDER BY id DESC LIMIT ?";

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
                    
                    prodotti.add(bean);
                }
            }

        } catch (SQLException e) {
            System.err.println("Errore durante l'estrazione dei prodotti in evidenza: " + e.getMessage());
        }

        return prodotti;
    }

}