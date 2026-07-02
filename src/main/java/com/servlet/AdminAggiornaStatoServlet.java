package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.dao.OrdineDAO;

@WebServlet("/AdminAggiornaStato")
public class AdminAggiornaStatoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null || !utenteLoggato.getAdmin()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String idOrdineStr = request.getParameter("idOrdine");
        String nuovoStato = request.getParameter("nuovoStato");

        if (idOrdineStr != null && nuovoStato != null) {
            int idOrdine = Integer.parseInt(idOrdineStr);
            OrdineDAO ordineDAO = new OrdineDAO();
            
            ordineDAO.aggiornaStatoOrdine(idOrdine, nuovoStato);
        }

        response.sendRedirect(request.getContextPath() + "/AdminOrdini");
    }
}