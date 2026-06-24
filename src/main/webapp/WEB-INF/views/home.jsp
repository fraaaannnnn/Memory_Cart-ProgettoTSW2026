<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.List" %>
<%@ page import="java.lang.Math"%>
<%@ page import="com.bean.ProdottoBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>memory_cart | Retro Gaming Store</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css?v=2">
    <link rel="stylesheet" href="./css/home.css">
    
    <script src="./js/home.js" defer></script>
</head>
<body>

    <%@include file="header.jsp"%>

    <section class="carousel-container">
        <div class="carousel-track" id="carouselTrack">
            <!-- immagini placeholder del carousel banner -->
            <div class="carousel-slide">
                <img src="https://images.unsplash.com/photo-1550745165-9bc0b252726f?q=80&w=2070&auto=format&fit=crop" alt="Retro Gaming">
                <div class="slide-content">
                    <h2>READY PLAYER ONE?</h2>
                    <p>Le migliori console degli anni '80 e '90, restaurate e pronte a giocare.</p>
                    <a href="#" class="btn-primary">Sfoglia Catalogo</a>
                </div>
            </div>

            <div class="carousel-slide">
                <img src="https://images.unsplash.com/photo-1555864326-5cf22ef123cf?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTR8fHJldHJvJTIwZ2FtZXxlbnwwfHwwfHx8MA%3D%3D?q=80&w=2012&auto=format&fit=crop" alt="Arcade Cabinet">
                <div class="slide-content">
                    <h2>INSERT COIN</h2>
                    <p>Unisciti all'Arcade Club e accumula punti XP per sbloccare sconti leggendari.</p>
                    <a href="#" class="btn-primary">Unisciti Ora</a>
                </div>
            </div>

            <div class="carousel-slide">
                <img src="https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto=format&fit=crop" alt="Game Cartridges">
                <div class="slide-content">
                    <h2>8-BIT DREAMS</h2>
                    <p>Oltre 1000 titoli originali in cartuccia. Trova il pezzo mancante alla tua collezione.</p>
                    <a href="#" class="btn-primary">Vedi Giochi</a>
                </div>
            </div>

        </div>

        <button class="carousel-btn prev" id="prevBtn">&#10094;</button>
        <button class="carousel-btn next" id="nextBtn">&#10095;</button>
    </section>

    <section class="products-section">
        <h2 class="section-title">SUGGERITI PER TE</h2>
        <div class="product-grid">

            <%
                List<ProdottoBean> prodotti = (List<ProdottoBean>) request.getAttribute("prodottiVetrina");
                if (prodotti != null && !prodotti.isEmpty()) {
                    for (ProdottoBean prodotto : prodotti) {
                        String[] prezzoSplit = String.format("%.2f", prodotto.getPrezzo()).split(",");
                        String parteIntera = prezzoSplit[0];
                        String decimali = prezzoSplit.length > 1 ? prezzoSplit[1] : "00";
            %>
            
            <div class="product-card">
                <div class="product-image">
                    <img src="<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>">
                </div>
                <div class="product-info">
                
                
                <a href="Prodotto?id=<%= prodotto.getId() %>" class="product-title"><%= prodotto.getNome() %></a>
                        
               <div class="product-rating">
                        	<%
                        		String stelle = "";
                        		int mediaStelle = (int) Math.floor(prodotto.getMediaStelle());
                        		for(int i = 0; i < mediaStelle; i++) {
                        			stelle += "★";
                        		}
                        		for(int i = 0; i < 5 - mediaStelle; i++) {
                        			stelle += "☆";
                        		}
                        	
                        	%>
                        <span class="stars"><%=stelle %>
                        </span> 
                        <span class="rating-count"><%=prodotto.getNumeroRecensioni() %> recensioni</span>
                    </div>  
  
                    <div class="product-price">
                        <span class="currency">€</span>
                        <span class="whole"><%= parteIntera %></span>
                        <span class="fraction"><%= decimali %></span>
                    </div>
                    
                    
                    
                    <form action="CarrelloServlet" method="get" class="product-form">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="id" value="<%= prodotto.getId() %>">
                        <button type="submit" class="btn-cart">AGGIUNGI AL CARRELLO</button>
                    </form>
                </div>
            </div>
            
            <%
                    }
                } else {
            %>
                <p style="text-align: left; width: 100%; color: var(--8bit-teal);">Nessun prodotto disponibile al momento.</p>
            <%
                }
            %>

        </div>
    </section>

    
	<%@include file="footer.jsp"%>

</body>
</html>