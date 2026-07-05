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
import com.bean.ProdottoBean;
import com.dao.CarrelloDAO;
import com.dao.ProdottoDAO;
import com.dao.OrdineDAO;

@WebServlet("/ConfermaOrdine")
public class ConfermaOrdineServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
        
        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String indirizzo = request.getParameter("indirizzo");
        String citta = request.getParameter("citta");
        String cap = request.getParameter("cap");
        if (nome == null || nome.trim().isEmpty() ||
            cognome == null || cognome.trim().isEmpty() ||
            indirizzo == null || indirizzo.trim().isEmpty() ||
            citta == null || citta.trim().isEmpty() ||
            cap == null || cap.trim().isEmpty()) {
            session.setAttribute("erroreCarrello", "Dati di spedizione incompleti. Compila tutti i campi.");
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        CarrelloDAO carrelloDAO = new CarrelloDAO();
        Map<Integer, Integer> carrello = null;
        try {
            carrello = carrelloDAO.getCarrelloUtente(utenteLoggato.getId());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("erroreCarrello", "Errore nel recupero del carrello.");
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        if (carrello == null || carrello.isEmpty()) {
            session.setAttribute("erroreCarrello", "Il carrello è vuoto.");
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        ProdottoDAO prodottoDAO = new ProdottoDAO();
        double totaleCarrello = 0.0;
        boolean stockSufficiente = true;

        for (Map.Entry<Integer, Integer> entry : carrello.entrySet()) {
            ProdottoBean p = null;
            try {
                p = prodottoDAO.prodottoDaId(entry.getKey());
            } catch (Exception e) {
                e.printStackTrace();
                session.setAttribute("erroreCarrello", "Errore nel recupero del prodotto.");
                response.sendRedirect(request.getContextPath() + "/Carrello");
                return;
            }
            if (p != null) {
                int quantitaRichiesta = entry.getValue();
                int quantitaDisponibile = p.getQuantita();
                int quantitaEffettiva = quantitaRichiesta;
                if (quantitaRichiesta > quantitaDisponibile) {
                    quantitaEffettiva = quantitaDisponibile;
                    stockSufficiente = false;
                }
                totaleCarrello += (p.getPrezzo() * quantitaEffettiva);
            } else {
                session.setAttribute("erroreCarrello", "Prodotto non trovato: ID " + entry.getKey());
                response.sendRedirect(request.getContextPath() + "/Carrello");
                return;
            }
        }

        double spedizione = 5.00;
        if (totaleCarrello == 0 || utenteLoggato.getAbbonato()) {
            spedizione = 0.0;
        }
        double totaleFinale = totaleCarrello + spedizione;
        OrdineDAO ordineDAO = new OrdineDAO();
        boolean successo = false;
        try {
            successo = ordineDAO.salvaOrdineCompleto(
                utenteLoggato.getId(), carrello, totaleFinale, nome, cognome, indirizzo, citta, cap
            );
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("erroreCarrello", "Errore durante il salvataggio dell'ordine: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/Carrello");
            return;
        }

        if (successo) {
            session.removeAttribute("carrello");
            request.getRequestDispatcher("./WEB-INF/views/successo.jsp").forward(request, response);
        } else {
            session.setAttribute("erroreCarrello", "Errore critico: Uno o più prodotti sono andati esauriti prima della conferma.");
            response.sendRedirect(request.getContextPath() + "/Carrello");
        }
    }
}