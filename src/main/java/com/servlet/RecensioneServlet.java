package com.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bean.RecensioneBean;
import com.dao.RecensioneDAO;
import com.bean.UtenteBean;

@WebServlet("/Recensione")
public class RecensioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
    	HttpSession session = request.getSession(false);
    	String testoRecensione = request.getParameter("testo_utente");
    	UtenteBean user = (UtenteBean)session.getAttribute("utenteLoggato");
        String idProdottoStr = request.getParameter("id_gioco");
        String votoStelleStr = request.getParameter("rating");
        if(testoRecensione != null && !testoRecensione.trim().isEmpty() && idProdottoStr != null && !idProdottoStr.trim().isEmpty() &&
        		votoStelleStr != null && !votoStelleStr.trim().isEmpty()) {
        	try {
	        		int idUser = user.getId();
	        		int idProdotto = Integer.parseInt(idProdottoStr);
	        		int votoStelle = Integer.parseInt(votoStelleStr);
	        		RecensioneBean bean = new RecensioneBean();
	        		bean.setRecensione(testoRecensione);
	        		bean.setIdUtente(idUser);
	        		bean.setIdProdotto(idProdotto);
	        		bean.setStelle(votoStelle);
	        		RecensioneDAO recensione = new RecensioneDAO();
	        		boolean successo = recensione.salvaRecensione(bean);
	        		request.setAttribute("riuscitaInserimentoRecensione", successo);
	                response.sendRedirect("/Memory_Cart/Prodotto?id=" + idProdottoStr);
	        		return;
        	} catch (NumberFormatException e){
                	System.out.println("Errore: Formato non valido");
        	} catch (Exception e){
                System.out.println("Errore Database: " + e.getMessage());
        	}
        }
        return;
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
