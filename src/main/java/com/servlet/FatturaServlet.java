package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.bean.OrdineBean;
import com.dao.OrdineDAO;

@WebServlet("/Fattura")
public class FatturaServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID Ordine mancante.");
            return;
        }

        int idOrdine = Integer.parseInt(idParam);
        OrdineDAO ordineDAO = new OrdineDAO();
        OrdineBean ordine = ordineDAO.getOrdineById(idOrdine);

        if (ordine == null || (ordine.getIdUtente() != utenteLoggato.getId() && !utenteLoggato.getAdmin())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Non sei autorizzato a vedere questa ricevuta.");
            return;
        }

        request.setAttribute("ordine", ordine);
        
        request.getRequestDispatcher("/WEB-INF/views/fattura.jsp").forward(request, response);
    }
}