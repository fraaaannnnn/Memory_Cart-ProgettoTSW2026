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

@WebServlet("/AdminOrdini")
public class AdminOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

        if (utenteLoggato == null || !utenteLoggato.getAdmin()) {
            response.sendRedirect(request.getContextPath() + "/");
            return;
        }

        String dataInizio = request.getParameter("dataInizio");
        String dataFine = request.getParameter("dataFine");
        String idUtente = request.getParameter("idUtente");

        OrdineDAO ordineDAO = new OrdineDAO();
        List<OrdineBean> ordiniAdmin = ordineDAO.getOrdiniFiltratiAdmin(dataInizio, dataFine, idUtente);

        request.setAttribute("filtroDataInizio", dataInizio);
        request.setAttribute("filtroDataFine", dataFine);
        request.setAttribute("filtroIdUtente", idUtente);
        request.setAttribute("listaOrdiniAdmin", ordiniAdmin);

        request.getRequestDispatcher("./WEB-INF/Admin/admin_ordini.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}