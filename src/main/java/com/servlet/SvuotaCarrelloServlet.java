package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.bean.UtenteBean;
import com.dao.CarrelloDAO;

@WebServlet("/SvuotaCarrello")
public class SvuotaCarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

        if (utenteLoggato != null) {
            CarrelloDAO carrelloDAO = new CarrelloDAO();
            carrelloDAO.svuotaCarrello(utenteLoggato.getId());
        } else {
            session.removeAttribute("carrelloOspite");
        }

        response.sendRedirect(request.getContextPath() + "/Carrello");
    }
}