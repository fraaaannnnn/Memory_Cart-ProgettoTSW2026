package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.*;
import org.mindrot.jbcrypt.BCrypt;
import com.util.TokenUtil; 
import com.dao.UtenteDAO;

@WebServlet("/LogOut")
public class LogOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
            	if ("remember_me".equals(cookie.getName())) {
            	    String valoreCookie = cookie.getValue();
            	    
            	    if (valoreCookie != null && valoreCookie.contains(":")) {
            	        String[] parti = valoreCookie.split(":", 2);
            	        String email = parti[0];
            	        String tokenInChiaro = parti[1];
            	        
            	        UtenteDAO utenteDAO = new UtenteDAO();
            	        List<String> tokenHashati = utenteDAO.getTokensByEmail(email);
            	        
            	        for (String hashDalDB : tokenHashati) {
            	            if (BCrypt.checkpw(tokenInChiaro, hashDalDB)) {
            	                utenteDAO.eliminaAuthTokenSpecifico(email, hashDalDB);
            	                break; 
            	            }
            	        }
            	    }
            	    
            	    cookie.setMaxAge(0);
            	    cookie.setPath(request.getContextPath() + "/"); 
            	    response.addCookie(cookie);
            	    break;
            	}
            }
        }

        response.sendRedirect(request.getContextPath());
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}