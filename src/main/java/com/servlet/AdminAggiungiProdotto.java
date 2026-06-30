package com.servlet;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.bean.ProdottoBean;
import com.dao.ProdottoDAO;

@WebServlet("/AdminAggiungiProdotto")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2,
                 maxFileSize = 1024 * 1024 * 10,    
                 maxRequestSize = 1024 * 1024 * 50) 
public class AdminAggiungiProdotto extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ProdottoDAO dao = new ProdottoDAO();
        request.setAttribute("listaCategorie", dao.getCategorie());
        request.getRequestDispatcher("/WEB-INF/Admin/admin_form_prodotto.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String nome = request.getParameter("nome");
            String prezzo = request.getParameter("prezzo");
            String quantita = request.getParameter("quantita");
            String descrizione = request.getParameter("descrizione");
            String idTipo = request.getParameter("idTipo");

            Part filePart = request.getPart("immagine"); 
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "product";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            
            filePart.write(uploadPath + File.separator + fileName);
            
            String percorsoDB = "./images/product/" + fileName; 

            ProdottoBean p = new ProdottoBean();
            p.setNome(nome);
            p.setPrezzo(Double.parseDouble(prezzo));
            p.setImmagine(percorsoDB);
            p.setQuantita(Integer.parseInt(quantita));
            p.setDescrizione(descrizione);
            p.setIdTipo(Integer.parseInt(idTipo));

            ProdottoDAO dao = new ProdottoDAO();
            dao.salvaProdotto(p);
            
            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
            
        } catch (Exception e) {
            e.printStackTrace(); 
        }
    }
}