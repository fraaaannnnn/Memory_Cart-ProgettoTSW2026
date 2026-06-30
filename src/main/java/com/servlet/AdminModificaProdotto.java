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

@WebServlet("/AdminModificaProdotto")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, 
                 maxFileSize = 1024 * 1024 * 10,      
                 maxRequestSize = 1024 * 1024 * 50)   
public class AdminModificaProdotto extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("idProdotto"));
        ProdottoDAO dao = new ProdottoDAO();
        
        ProdottoBean p = dao.prodottoDaId(id);
        
        request.setAttribute("listaCategorie", dao.getCategorie());
        request.setAttribute("prodottoDaModificare", p);
        request.getRequestDispatcher("/WEB-INF/Admin/admin_form_prodotto.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String nome = request.getParameter("nome");
            double prezzo = Double.parseDouble(request.getParameter("prezzo"));
            int quantita = Integer.parseInt(request.getParameter("quantita"));
            String descrizione = request.getParameter("descrizione");
            int idTipo = Integer.parseInt(request.getParameter("idTipo"));

            String percorsoDB = request.getParameter("immagineVecchia"); 
            
            Part filePart = request.getPart("immagine");
            
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images" + File.separator + "product";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                filePart.write(uploadPath + File.separator + fileName);
                
                percorsoDB = "./images/product/" + fileName;
            }

            ProdottoBean p = new ProdottoBean();
            p.setId(id);
            p.setNome(nome);
            p.setPrezzo(prezzo);
            p.setImmagine(percorsoDB);
            p.setQuantita(quantita);
            p.setDescrizione(descrizione);
            p.setIdTipo(idTipo);

            ProdottoDAO dao = new ProdottoDAO();
            dao.modificaProdotto(p); 

            response.sendRedirect(request.getContextPath() + "/AdminDashboard");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
