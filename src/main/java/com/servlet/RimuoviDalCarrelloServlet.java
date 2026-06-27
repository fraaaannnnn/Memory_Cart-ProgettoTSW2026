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

@WebServlet("/RimuoviDalCarrello")
public class RimuoviDalCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String idProdottoStr = request.getParameter("idProdotto");

        if (idProdottoStr != null) {
            try {
                int idProdotto = Integer.parseInt(idProdottoStr);
                UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

                if (utenteLoggato != null) {
                    CarrelloDAO carrelloDAO = new CarrelloDAO();
                    carrelloDAO.rimuoviProdotto(utenteLoggato.getId(), idProdotto);
                } else {
                    Map<Integer, Integer> carrelloOspite = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
                    if (carrelloOspite != null) {
                        carrelloOspite.remove(idProdotto);
                        session.setAttribute("carrelloOspite", carrelloOspite);
                    }
                }
            } catch (NumberFormatException e) {
                System.err.println("Errore rimozione prodotto: " + e.getMessage());
            }
        }
        response.sendRedirect(request.getContextPath() + "/Carrello");
    }
}