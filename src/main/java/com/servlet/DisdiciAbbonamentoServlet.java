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

@WebServlet("/DisdiciAbbonamento")
public class DisdiciAbbonamentoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        UtenteDAO dao = new UtenteDAO();
        
        boolean successo = dao.aggiornaAbbonamento(utente.getId(), false);
        
        if (successo) {
            utente.setAbbonato(false);
            session.setAttribute("utenteLoggato", utente);
        }
        
        response.sendRedirect(request.getContextPath() + "/Profilo");
    }
}