package com.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bean.UtenteBean;

@WebFilter("/*")
public class AdminRedirectFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();
        String contextPath = req.getContextPath();
        String relativePath = path.substring(contextPath.length());

        if (relativePath.startsWith("/css/") || relativePath.startsWith("/images/") || relativePath.startsWith("/js/")) {
            chain.doFilter(request, response);
            return;
        }

        UtenteBean utente = null;
        if (session != null) {
            utente = (UtenteBean) session.getAttribute("utenteLoggato");
        }

        if (utente != null && utente.getAdmin()) {
            
            boolean isAllowedForAdmin = relativePath.contains("Admin") 
                                     || relativePath.contains("LogOut") 
                                     || relativePath.contains("Fattura");

            if (!isAllowedForAdmin) {
                res.sendRedirect(contextPath + "/AdminDashboard");
                return; 
            }
        }

        chain.doFilter(request, response);
    }

    public void init(FilterConfig fConfig) throws ServletException {}
    public void destroy() {}
}