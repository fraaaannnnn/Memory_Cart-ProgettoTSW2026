package com.servlet;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bean.ProdottoBean;
import com.dao.ProdottoDAO;

@WebServlet("/FiltroCatalogoServlet")
public class FiltroCatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String[] categorie = request.getParameterValues("categoria"); 
        String prezzoMax = request.getParameter("prezzoMax");
        String sort = request.getParameter("sort");
        
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            page = Integer.parseInt(pageStr);
        }
        
        int prodottiPerPagina = 6; 
        int offset = (page - 1) * prodottiPerPagina;
        
        ProdottoDAO dao = new ProdottoDAO();
        
        List<ProdottoBean> listaFiltrata = dao.getProdottiFiltrati(categorie, prezzoMax, sort, prodottiPerPagina, offset);
        
        int totaleProdotti = dao.contaProdottiFiltrati(categorie, prezzoMax);
        
        int totalePagine = (int) Math.ceil((double) totaleProdotti / prodottiPerPagina);
        
        request.setAttribute("prodotti", listaFiltrata);
        request.setAttribute("paginaCorrente", page);
        request.setAttribute("totalePagine", totalePagine);
        
        request.getRequestDispatcher("/WEB-INF/views/griglia_prodotti.jsp").forward(request, response);
    }
}