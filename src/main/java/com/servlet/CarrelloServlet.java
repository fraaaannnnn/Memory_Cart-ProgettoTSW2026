package com.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.dao.CarrelloDAO;

@WebServlet("/Carrello")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/carrello.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        String idProdottoStr = request.getParameter("idProdotto");
        String quantitaStr = request.getParameter("quantita");

        if (idProdottoStr != null && !idProdottoStr.trim().isEmpty() && 
            quantitaStr != null && !quantitaStr.trim().isEmpty()) {
            
            try {
                int idProdotto = Integer.parseInt(idProdottoStr);
                int quantita = Integer.parseInt(quantitaStr);

                UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

                if (utenteLoggato != null) {
                    CarrelloDAO carrelloDAO = new CarrelloDAO();
                    carrelloDAO.salvaOIncrementa(utenteLoggato.getId(), idProdotto, quantita);
                } else {
                    @SuppressWarnings("unchecked")
                    Map<Integer, Integer> carrelloOspite = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
                    
                    if (carrelloOspite == null) {
                        carrelloOspite = new HashMap<>();
                    }
                    
                    int vecchiaQuantita = carrelloOspite.getOrDefault(idProdotto, 0);
                    carrelloOspite.put(idProdotto, vecchiaQuantita + quantita);
                    
                    session.setAttribute("carrelloOspite", carrelloOspite);
                }
                
                session.setAttribute("pop_up_carrello", "OGGETTO AGGIUNTO AL CARRELLO");
                
            } catch (NumberFormatException e) {
                System.err.println("Errore di parsing parametri Carrello: " + e.getMessage());
            }

            String referer = request.getHeader("referer");
            if (referer != null) {
                response.sendRedirect(referer);
            } else {
                response.sendRedirect(request.getContextPath() + "/Carrello");
            }
            
            return; 
        }

        response.sendRedirect(request.getContextPath() + "/Carrello");
    }
}