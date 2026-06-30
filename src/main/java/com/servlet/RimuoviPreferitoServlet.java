package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.dao.PreferitiDAO;

@WebServlet("/RimuoviPreferito")
public class RimuoviPreferitoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        try {
            int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
            
            PreferitiDAO dao = new PreferitiDAO();
            dao.RimuoviPreferito(utente.getId(), idProdotto);
            
            response.sendRedirect(request.getContextPath() + "/Preferiti");
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/Preferiti");
        }
    }
}