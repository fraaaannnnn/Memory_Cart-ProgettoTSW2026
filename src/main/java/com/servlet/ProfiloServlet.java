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
import com.bean.OrdineBean;
import com.dao.OrdineDAO;

@WebServlet("/Profilo")
public class ProfiloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        UtenteBean utente = (session != null) ? (UtenteBean) session.getAttribute("utenteLoggato") : null;
        
        if (utente != null) {
            OrdineDAO ordineDAO = new OrdineDAO();
            List<OrdineBean> listaOrdini = ordineDAO.getOrdiniByUtente(utente.getId());
            
            double totaleSpeso = 0;
            int totaleOrdini = 0;
            
            if (listaOrdini != null) {
                totaleOrdini = listaOrdini.size();
                
                for (OrdineBean ordine : listaOrdini) {
                    if (ordine.getStato() != OrdineBean.Stato.ANNULLATO) {
                        totaleSpeso += ordine.getTotaleOrdine();
                    }
                }
            }
            
            int xpTotali = (int) (totaleSpeso * 10);
            
            int xpPerLivello = 500;
            int livelloAttuale = xpTotali / xpPerLivello; 
            int xpNelLivelloCorrente = xpTotali % xpPerLivello; 
            int xpMancanti = xpPerLivello - xpNelLivelloCorrente;
            
            int percentualeBarra = (xpNelLivelloCorrente * 100) / xpPerLivello;
            
            request.setAttribute("listaOrdini", listaOrdini);
            request.setAttribute("totaleOrdini", totaleOrdini);
            request.setAttribute("xpTotali", xpTotali);
            request.setAttribute("livelloAttuale", livelloAttuale);
            request.setAttribute("xpMancanti", xpMancanti);
            request.setAttribute("percentualeBarra", percentualeBarra);
        }
        
        request.getRequestDispatcher("/WEB-INF/views/profilo.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}