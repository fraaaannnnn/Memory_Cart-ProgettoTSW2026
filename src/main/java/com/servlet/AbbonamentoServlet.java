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

@WebServlet("/Abbonamento")
public class AbbonamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
            
        request.getRequestDispatcher("/WEB-INF/views/abbonamento.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect("Login");
            return;
        }

        String tier = request.getParameter("tier");

        if ("progamer".equals(tier)) {
            UtenteDAO utenteDAO = new UtenteDAO();
            
            boolean successo = utenteDAO.aggiornaAbbonamento(utente.getId(), true);
            
            
            if (successo) {
                utente.setAbbonato(true);
                session.setAttribute("utenteLoggato", utente);
                response.sendRedirect("Abbonamento?success=true");
            } else {
                response.sendRedirect("Abbonamento?error=true");
            }
        } else {
            response.sendRedirect("/Memory_Cart/");
        }
    }
}