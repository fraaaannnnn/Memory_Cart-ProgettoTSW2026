package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bean.RecensioneBean;
import com.dao.RecensioneDAO;
import com.bean.UtenteBean;

@WebServlet("/Recensione")
public class RecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        
        UtenteBean user = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String testoRecensione = request.getParameter("testo_utente");
        String idProdottoStr = request.getParameter("id_gioco");
        String votoStelleStr = request.getParameter("rating");

        if (idProdottoStr == null || idProdottoStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/Catalogo");
            return;
        }

        if (votoStelleStr == null || votoStelleStr.trim().isEmpty()) {
            session.setAttribute("toastTitle", "MISSION FAILED");
            session.setAttribute("toastMessage", "Devi selezionare un voto a stelle (da 1 a 5)!");
            session.setAttribute("toastError", true); // True genera il toast rosso
            response.sendRedirect(request.getContextPath() + "/Prodotto?id=" + idProdottoStr);
            return; // Blocchiamo l'esecuzione
        }

        if (testoRecensione == null || testoRecensione.trim().isEmpty()) {
            session.setAttribute("toastTitle", "MISSION FAILED");
            session.setAttribute("toastMessage", "Scrivi qualcosa prima di inviare la recensione!");
            session.setAttribute("toastError", true);
            response.sendRedirect(request.getContextPath() + "/Prodotto?id=" + idProdottoStr);
            return;
        }

        try {
            int idProdotto = Integer.parseInt(idProdottoStr);
            int votoStelle = Integer.parseInt(votoStelleStr);
            
            RecensioneBean bean = new RecensioneBean();
            bean.setRecensione(testoRecensione);
            bean.setIdUtente(user.getId());
            bean.setIdProdotto(idProdotto);
            bean.setStelle(votoStelle);
            
            RecensioneDAO recensioneDAO = new RecensioneDAO();
            boolean successo = recensioneDAO.salvaRecensione(bean);
            
            if (successo) {
                session.setAttribute("toastTitle", "RECENSIONE INVIATA");
                session.setAttribute("toastMessage", "Grazie per aver lasciato il tuo feedback! +50XP");
                session.setAttribute("toastError", false); 
            } else {
                session.setAttribute("toastTitle", "SYSTEM ERROR");
                session.setAttribute("toastMessage", "Impossibile salvare la recensione nel database.");
                session.setAttribute("toastError", true);
            }
            
            response.sendRedirect(request.getContextPath() + "/Prodotto?id=" + idProdottoStr);
            
        } catch (NumberFormatException e) {
            System.err.println("Errore: Formato non valido per ID o Stelle");
            response.sendRedirect(request.getContextPath() + "/Catalogo");
        } catch (Exception e) {
            System.err.println("Errore Servlet Recensione: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Catalogo");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Catalogo");
    }
}