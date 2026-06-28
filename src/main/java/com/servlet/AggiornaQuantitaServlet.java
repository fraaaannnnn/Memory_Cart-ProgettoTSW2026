package com.servlet;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.bean.UtenteBean;
import com.dao.CarrelloDAO;

@WebServlet("/AggiornaQuantita")
public class AggiornaQuantitaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String idProdottoStr = request.getParameter("idProdotto");
        String azione = request.getParameter("azione");

        if (idProdottoStr != null && azione != null) {
            try {
                int idProdotto = Integer.parseInt(idProdottoStr);
                UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
                CarrelloDAO carrelloDAO = new CarrelloDAO();

                if (utenteLoggato != null) {
                    Map<Integer, Integer> carrelloAttuale = carrelloDAO.getCarrelloUtente(utenteLoggato.getId());
                    int quantitaAttuale = carrelloAttuale.getOrDefault(idProdotto, 1);
                    
                    if ("aumenta".equals(azione)) {
                        carrelloDAO.aggiornaQuantita(utenteLoggato.getId(), idProdotto, quantitaAttuale + 1);
                    } else if ("diminuisci".equals(azione)) {
                        if (quantitaAttuale > 1) {
                            carrelloDAO.aggiornaQuantita(utenteLoggato.getId(), idProdotto, quantitaAttuale - 1);
                        } else {
                            carrelloDAO.rimuoviProdotto(utenteLoggato.getId(), idProdotto);
                        }
                    }
                } else {
                    Map<Integer, Integer> carrelloOspite = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
                    
                    if (carrelloOspite != null && carrelloOspite.containsKey(idProdotto)) {
                        int quantitaAttuale = carrelloOspite.get(idProdotto);
                        
                        if ("aumenta".equals(azione)) {
                            carrelloOspite.put(idProdotto, quantitaAttuale + 1);
                        } else if ("diminuisci".equals(azione)) {
                            if (quantitaAttuale > 1) {
                                carrelloOspite.put(idProdotto, quantitaAttuale - 1);
                            } else {
                                carrelloOspite.remove(idProdotto);
                            }
                        }
                        session.setAttribute("carrelloOspite", carrelloOspite);
                    }
                }
            } catch (NumberFormatException e) {
                System.err.println("Errore aggiornamento quantità: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/Carrello");
    }
}