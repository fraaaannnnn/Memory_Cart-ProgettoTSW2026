package com.servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.mindrot.jbcrypt.BCrypt;
import com.bean.UtenteBean;
import com.dao.UtenteDAO;

@WebServlet("/Register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public RegisterServlet() {
        super();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
    	HttpSession session = request.getSession();
    	if(session.getAttribute("utenteLoggato") != null) {
            response.sendRedirect("/Memory_Cart/"); 
    	} else {
    		request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);    		
    	}
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nomeForm = request.getParameter("nome");
        String emailForm = request.getParameter("email");
        String passwordInChiaro = request.getParameter("password");
        String confermaPassword = request.getParameter("confirm-password");

        if (nomeForm == null || nomeForm.trim().isEmpty() || 
            emailForm == null || emailForm.trim().isEmpty() || 
            passwordInChiaro == null || passwordInChiaro.isEmpty()) {
            
            request.setAttribute("erroreRegistrazione", "Tutti i campi sono obbligatori.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        if (!passwordInChiaro.equals(confermaPassword)) {
            request.setAttribute("erroreRegistrazione", "Le password inserite non coincidono.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        UtenteDAO utenteDAO = new UtenteDAO();

        if (utenteDAO.emailEsistente(emailForm)) {
            request.setAttribute("erroreRegistrazione", "Questa email è già registrata. Prova ad accedere.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        String passwordHashata = BCrypt.hashpw(passwordInChiaro, BCrypt.gensalt());

        UtenteBean nuovoUtente = new UtenteBean();
        nuovoUtente.setEmail(emailForm);
        nuovoUtente.setUserName(nomeForm); 
        nuovoUtente.setPw(passwordHashata); 
        nuovoUtente.setAbbonato(false);     
        nuovoUtente.setAdmin(false);    

        boolean inserimentoCompletato = utenteDAO.salvaUtente(nuovoUtente);

        if (inserimentoCompletato) {
            request.setAttribute("messaggioSuccesso", "Nuovo account creato! Effettua il login per iniziare.");
            request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
        } else {
            request.setAttribute("erroreRegistrazione", "Errore nel salvataggio dei dati. Riprova.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}