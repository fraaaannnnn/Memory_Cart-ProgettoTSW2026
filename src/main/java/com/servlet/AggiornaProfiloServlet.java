package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import com.bean.UtenteBean;
import com.dao.UtenteDAO;

@WebServlet("/AggiornaProfilo")
public class AggiornaProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        String nuovoUsername = request.getParameter("username");
        String nuovaEmail = request.getParameter("email");
        String nuovoIndirizzo = request.getParameter("indirizzo");
        String nuovaPassword = request.getParameter("password"); 
        String hashPassword = null;
        if (nuovaPassword != null && !nuovaPassword.trim().isEmpty()) {
            hashPassword = BCrypt.hashpw(nuovaPassword, BCrypt.gensalt());
        }

        UtenteDAO dao = new UtenteDAO();
        boolean successo = dao.aggiornaDatiUtente(utente.getId(), nuovoUsername, nuovaEmail, hashPassword, nuovoIndirizzo);
        if (successo) {
            utente.setUserName(nuovoUsername);
            utente.setEmail(nuovaEmail);
            utente.setIndirizzo(nuovoIndirizzo);
            session.setAttribute("utenteLoggato", utente);
            
            response.sendRedirect(request.getContextPath() + "/Profilo?update=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/Profilo?update=error");
        }
    }
}