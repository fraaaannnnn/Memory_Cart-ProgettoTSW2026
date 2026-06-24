package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;
import com.dao.UtenteDAO;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String keepMeLoggedIn = request.getParameter("keep_me_logged_in");

        UtenteDAO utenteDAO = new UtenteDAO();
        UtenteBean utente = utenteDAO.loginUtente(email, password);

        if (utente != null) {
            
            HttpSession session = request.getSession();
            
            session.setAttribute("utenteLoggato", utente);

            if (keepMeLoggedIn != null) {
                Cookie userCookie = new Cookie("userEmail", utente.getEmail());
                userCookie.setMaxAge(60 * 60 * 24 * 30); 
                response.addCookie(userCookie);
            }

            response.sendRedirect("Home"); 
            
        } else {
            request.setAttribute("erroreLogin", "Email o password errati. Riprova.");
            
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        }
    }
}