package com.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.bean.ProdottoBean;
import com.dao.PreferitiDAO;

@WebServlet("/Preferiti")
public class PreferitiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;

        if (utente == null) {
            response.sendRedirect(request.getContextPath() + "/Login");
            return;
        }
        PreferitiDAO dao = new PreferitiDAO();
        List<ProdottoBean> listaPreferiti = dao.getPreferitiByUtente(utente.getId());
        request.setAttribute("listaPreferiti", listaPreferiti);

        request.getRequestDispatcher("/WEB-INF/views/preferiti.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}