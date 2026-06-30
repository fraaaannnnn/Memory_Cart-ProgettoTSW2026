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

@WebServlet("/AggiungiPreferito")
public class AggiungiPreferitoServlet extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/Catalogo");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }

        int idProdotto = Integer.parseInt(request.getParameter("idProdotto"));
        
        PreferitiDAO dao = new PreferitiDAO();
        dao.AggiungiPreferito(utente.getId(), idProdotto);
        
        response.sendRedirect(request.getContextPath() + "/Prodotto?id=" + idProdotto);
    }
}