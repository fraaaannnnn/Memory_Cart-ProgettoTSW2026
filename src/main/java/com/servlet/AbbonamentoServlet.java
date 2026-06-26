package com.servlet;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.dao.UtenteDAO;

@WebServlet("/abbonamento")
public class AbbonamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        // PATH CORRETTO: Punta a WEB-INF/views/abbonamento.jsp come da tua struttura
        request.getRequestDispatcher("/WEB-INF/views/abbonamento.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            System.out.println("DEBUG: Utente non trovato in sessione!");
            response.sendRedirect("Login");
            return;
        }

        String tier = request.getParameter("tier");
        System.out.println("DEBUG: Richiesta ricevuta per tier: " + tier);

        if ("progamer".equals(tier)) {
            UtenteDAO utenteDAO = new UtenteDAO();
            
            // Eseguiamo l'aggiornamento
            boolean successo = utenteDAO.aggiornaAbbonamento(utente.getId(), true);
            
            System.out.println("DEBUG: Risultato DB: " + successo);
            
            if (successo) {
                utente.setAbbonato(true);
                session.setAttribute("utenteLoggato", utente);
                
                // FORZIAMO il redirect alla pagina abbonamento con il parametro
                System.out.println("DEBUG: Redirecting to abbonamento?success=true");
                response.sendRedirect("abbonamento?success=true");
            } else {
                System.out.println("DEBUG: Errore nel DB!");
                response.sendRedirect("abbonamento?error=true");
            }
        } else {
            System.out.println("DEBUG: Tier non riconosciuto, mando alla home");
            response.sendRedirect("/Memory_Cart/");
        }
    }
}