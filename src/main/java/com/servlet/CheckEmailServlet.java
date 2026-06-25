package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.dao.UtenteDAO;

@WebServlet("/CheckEmail")
public class CheckEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        boolean esiste = false;

        if (email != null && !email.trim().isEmpty()) {
            UtenteDAO utenteDAO = new UtenteDAO();
            esiste = utenteDAO.emailEsistente(email);
        }

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        
        response.getWriter().write(String.valueOf(esiste));
    }
}