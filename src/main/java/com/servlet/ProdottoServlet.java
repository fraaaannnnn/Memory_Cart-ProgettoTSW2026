package com.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bean.ProdottoBean;
import com.dao.ProdottoDAO;
import com.bean.RecensioneBean;
import com.dao.RecensioneDAO;

@WebServlet("/Prodotto")
public class ProdottoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String idParam = request.getParameter("id");
        if (idParam != null && !idParam.trim().isEmpty()) {
            try {
                int idProdotto = Integer.parseInt(idParam);
                
                ProdottoDAO prodottoDAO = new ProdottoDAO();
                ProdottoBean prodotto = prodottoDAO.prodottoDaId(idProdotto);
                RecensioneDAO recensioneDAO = new RecensioneDAO();
				List<RecensioneBean>recensione = recensioneDAO.recensioneDaIdProdotto(idProdotto, 3);
                
                if (prodotto != null) {
                    request.setAttribute("dettaglioProdotto", prodotto);
                    request.setAttribute("prodottiSuggeriti", prodottoDAO.getProdottiInEvidenza(6));
					request.setAttribute("recensioniProdotto", recensione);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/views/prodotto.jsp");
                    dispatcher.forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                System.out.println("Errore: Formato ID non valido");
            } catch (Exception e) {
                System.out.println("Errore Database: " + e.getMessage());
            }
        }
        
        response.sendRedirect("/Memory_Cart/");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
