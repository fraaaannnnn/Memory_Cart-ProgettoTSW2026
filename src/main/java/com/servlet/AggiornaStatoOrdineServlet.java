package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.dao.OrdineDAO;

@WebServlet("/AggiornaStatoOrdine")
public class AggiornaStatoOrdineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idOrdineStr = request.getParameter("idOrdine");
        String nuovoStato = request.getParameter("nuovoStato");
        
        if (idOrdineStr != null && nuovoStato != null) {
            try {
                int idOrdine = Integer.parseInt(idOrdineStr);
                OrdineDAO ordineDAO = new OrdineDAO();
                
                ordineDAO.aggiornaStatoOrdine(idOrdine, nuovoStato);
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/GestioneOrdini");
    }
}