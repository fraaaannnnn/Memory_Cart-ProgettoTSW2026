<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.bean.ProdottoBean" %>
<%@ page import="com.bean.RecensioneBean" %>
<%
    ProdottoBean prodotto = (ProdottoBean) request.getAttribute("dettaglioProdotto");
    
    if(prodotto == null) {
        response.sendRedirect("Home");
        return;
    }
    
    String[] prezzoSplit = String.format(java.util.Locale.ITALY, "%.2f", prodotto.getPrezzo()).split(",");
    String parteIntera = prezzoSplit[0];
    String decimali = prezzoSplit.length > 1 ? prezzoSplit[1] : "00";
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= prodotto.getNome() %> | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/prodotto.css">
    
    <script src="./js/home.js" defer></script> 
</head>
<body>
    <%@include file="header.jsp"%>
    
    <main class="product-page-wrapper">
        <section class="product-top-section">
            <div class="product-image-gallery">
                <img src="<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>" id="mainImage" style="overflow: hidden;">
            </div>
            
            <div class="product-core-info">
                <h1 class="product-title-large"><%= prodotto.getNome() %></h1>
                
                <div class="product-rating product-page-stars">
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
                    <span class="stars"><%= stelle %></span>
                </div>
                	<p style="font-size: 10px; transform: translateY(20%)">
                        Totale recensioni: <%=prodotto.getNumeroRecensioni() %>
                    </p> 
                
                <div class="product-price-large">
                <% 
                if(prodotto.getQuantita() > 0) {
                %>
                    <span class="currency">€</span>
                    <span class="whole"><%= parteIntera %></span>
                    <span class="fraction"><%= decimali %></span>
				<%} else {
					%>
					<span class="whole">SOLD OUT</span>
				<%} %>
                </div>                
                <p style="font-size: 10px; transform: translateY(20%)">
                        Quantità: <%=prodotto.getQuantita() %>
                    </p> 
                <form action="Carrello" method="post" class="add-to-cart-form">
				    <input type="hidden" name="action" value="add">
				    <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>">
				    <input type="hidden" name="quantita" value="1">
				    <%if(prodotto.getQuantita() > 0) {%>				    
				    <button type="submit" class="btn-primary btn-add-cart">Aggiungi al Carrello</button>
                    <button type="submit" class="btn-wishlist" formaction="AggiungiPreferito">❤</button>
				    <%} else { %>
				    <button type="submit" class="btn-primary btn-add-cart" disabled>Aggiungi al Carrello</button>
					<%} %>
				</form>
            </div>
        </section>

        <section class="product-tabs-section">
            <div class="tabs">
                <button class="tab-btn active">Descrizione</button>
            </div>
            <div class="tab-content active">
                <p><%= prodotto.getDescrizione() %></p>
                <p><strong>Stato:</strong> Usato Garantito</p>
            </div>
        </section>

        <aside class="product-sidebar">
            <h3 class="sidebar-title">Ti potrebbe interessare</h3>
            <div class="suggested-grid">
                <% 
                   java.util.List<ProdottoBean> suggeriti = (java.util.List<ProdottoBean>) request.getAttribute("prodottiSuggeriti");
                   if(suggeriti != null) {
                       for(ProdottoBean sugg : suggeriti) {
                           if(sugg.getId() != prodotto.getId()) {
                %>
                <div class="mini-product-card">
                    <a href="Prodotto?id=<%= sugg.getId() %>">
                        <img src="<%= sugg.getImmagine() %>" alt="<%= sugg.getNome() %>" style="overflow: hidden">
                        <h4 class="mini-title"><%= sugg.getNome() %></h4>
                        <span class="mini-price">€<%= String.format("%.2f", sugg.getPrezzo()) %></span>
                    </a>
                </div>
                <% 
                           }
                       }
                   } 
                %>
            </div>
        </aside>
        
        <section class="product-reviews-section">
        	<div class="top-section">
            <h3 style="color: var(--8bit-teal); font-family: 'Press Start 2P', monospace; font-size: 0.8rem;">Recensioni Utenti</h3> 
            <button class="tab-btn active" id="mostra-form-btn">Aggiungi Recensione</button>
        	<button class="tab-btn active hidden-item" id="invia-recensione-btn" form="form-recensione">Invia</button>
        	</div>
            <br>
            <div class = "add-review-form hidden-item">
                <form id="form-recensione" action="Recensione" method="POST">
                <div class ="stars-container">
                	<input type="hidden" name="id_gioco" value="<%= prodotto.getId() %>">
	                <input type="radio" id="star5" name="rating" value="5" class="review-radio">
	                <label for="star5">★</label>
	                <input type="radio" id="star4" name="rating" value="4" class="review-radio">
	                <label for="star4">★</label>
	                <input type="radio" id="star3" name="rating" value="3" class="review-radio">
	                <label for="star3">★</label>
	                <input type="radio" id="star2" name="rating" value="2" class="review-radio">
	                <label for="star2">★</label>
	                <input type="radio" id="star1" name="rating" value="1" class="review-radio">
	                <label for="star1">★</label>
                </div>
                
                <textarea id="recensioneUtente" name="testo_utente" rows="5" cols="40" placeholder="Press X to Start"></textarea>
                </form>
			</div>
                       <% 
                       java.util.List<RecensioneBean> recensioni = (java.util.List<RecensioneBean>) request.getAttribute("recensioniProdotto");    
                       if(recensioni != null && !recensioni.isEmpty()) {
                           for(RecensioneBean recensione : recensioni) {
                       %>
                       
            <div class="review-card">
                <div class="user-email-img">
                    <div class="user_img"><img class="user_img_img" src="./images/user/utente_propic.png" alt="propic.png"></div>
                    <div class="user-email"><p><%=recensione.getNicknameUtente() %></p></div>
                </div>
                <div class="review-stars">
                    <%  
                    stelle = "";
                    int nstelle = recensione.getStelle();
                    for(int i = 0; i < nstelle; i++) { 
                        stelle += "★";
                    }
                    
                    for(int i = 0; i < 5 - nstelle; i++) {
                        stelle += "☆";
                    }
                    %>
                    <%= stelle%>
                </div>
                <p class="review-text"><%= recensione.getRecensione() %></p>
            </div>
                       <%  
                           }
                       } else {
                       %>    
                <p style="color: var(--classic-white); font-family: 'Press Start 2P', monospace;">Questo Prodotto non ha recensioni</p>
               <%  }%>
        </section>

    </main>
	<%@include file="footer.jsp"%>
	<%@include file="pop_up_carrello.jsp"%>
    <script src="./js/product.js"></script>
</body>
</html>