package com.filter;

import java.io.IOException;
import java.util.List;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import com.bean.UtenteBean;
import com.dao.UtenteDAO;

@WebFilter("/*")
public class RememberMeFilter implements Filter {

    @Override
    public void init(FilterConfig fConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpSession session = httpRequest.getSession();

        if (session.getAttribute("utenteLoggato") == null) {
            
            Cookie[] cookies = httpRequest.getCookies();
            String valoreCookie = null;

            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if ("remember_me".equals(cookie.getName())) {
                        valoreCookie = cookie.getValue();
                        break;
                    }
                }
            }

            if (valoreCookie != null && valoreCookie.contains(":")) {
                String[] parti = valoreCookie.split(":", 2);
                String email = parti[0];
                String tokenInChiaro = parti[1];

                UtenteDAO utenteDAO = new UtenteDAO();
                
                List<String> tokenHashati = utenteDAO.getTokensByEmail(email);
                
                boolean tokenValido = false;

                for (String hashDalDB : tokenHashati) {
                    if (BCrypt.checkpw(tokenInChiaro, hashDalDB)) {
                        tokenValido = true;
                        break;
                    }
                }

                if (tokenValido) {
                    UtenteBean utente = utenteDAO.getUtenteByEmail(email);
                    if (utente != null) {
                        session.setAttribute("utenteLoggato", utente);
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}