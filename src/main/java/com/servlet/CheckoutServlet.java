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
import com.bean.ProdottoBean;
import com.dao.CarrelloDAO;
import com.dao.ProdottoDAO;

@WebServlet("/Checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
        
        CarrelloDAO carrelloDAO = new CarrelloDAO();
        ProdottoDAO prodottoDAO = new ProdottoDAO();
        
        Map<Integer, Integer> carrelloMap = new HashMap<>();

        if (utenteLoggato != null) {
            carrelloMap = carrelloDAO.getCarrelloUtente(utenteLoggato.getId());
        } else {
            @SuppressWarnings("unchecked")
            Map<Integer, Integer> carrelloOspite = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
            if (carrelloOspite != null) {
                carrelloMap = carrelloOspite;
            }
        }

        boolean carrelloModificato = false;
        
        for (Map.Entry<Integer, Integer> entry : carrelloMap.entrySet()) {
            int idProdotto = entry.getKey();
            int quantitaRichiesta = entry.getValue();
            
            ProdottoBean prodotto = prodottoDAO.prodottoDaId(idProdotto);
            
            if (prodotto != null && quantitaRichiesta > prodotto.getQuantita()) {
                
                int quantitaCorretta = Math.max(0, prodotto.getQuantita()); 
                entry.setValue(quantitaCorretta);
                carrelloModificato = true;
                
                if (utenteLoggato != null) {
                    carrelloDAO.aggiornaQuantita(utenteLoggato.getId(), idProdotto, quantitaCorretta);
                }
            }
        }

        if (carrelloModificato) {
            if (utenteLoggato == null) {
                session.setAttribute("carrelloOspite", carrelloMap);
            }
            session.setAttribute("erroreCarrello", "Attenzione: alcune quantità sono state ridotte al limite massimo delle nostre scorte in magazzino.");
        }

        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}