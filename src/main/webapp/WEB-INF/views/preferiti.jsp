<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bean.ProdottoBean" %>
<%@ page import="com.bean.UtenteBean" %>
<% 
UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
@SuppressWarnings("unchecked")
List<ProdottoBean> listaPreferiti = (List<ProdottoBean>) request.getAttribute("listaPreferiti");
%>    
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Preferiti | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/carrello.css">
</head>
<body>

   <%@ include file="header.jsp"%>

    <main class="shop-container">
        <h2 class="page-title">I TUOI PREFERITI</h2>

        <% if (listaPreferiti == null || listaPreferiti.isEmpty()) { %>
            <div style="width: 100%; text-align: center; margin: 50px 0; padding: 20px; display: block;">
                
                <h2 style="font-family: 'Press Start 2P', monospace; color: #ff0075; font-size: 1.5rem; margin: 0 auto 20px auto; display: block; max-width: 800px;">
                    I TUOI PREFERITI SONO VUOTI
                </h2>
                
                <p style="font-family: 'Press Start 2P', monospace; color: #32e0c4; font-size: 0.8rem; margin: 0 auto 30px auto; display: block; max-width: 600px; line-height: 1.5;">
                    INSERISCI UN GETTONE PER INIZIARE<br>
                    (AGGIUNGI AI PREFERITI)
                </p>
                
                <a href="${pageContext.request.contextPath}/Catalogo" class="btn-primary" style="text-decoration: none; padding: 15px 30px; display: inline-block;">
                    VAI AL CATALOGO
                </a>
            </div>
        <% } else { %>
            <div class="product-grid">
                <% for (ProdottoBean prodotto : listaPreferiti) { 
                    String prezzoFormat = String.format("%.2f", prodotto.getPrezzo()).replace(",", ".");
                    String[] prezzoSplit = prezzoFormat.split("\\.");
                    String parteIntera = prezzoSplit[0];
                    String decimali = prezzoSplit.length > 1 ? prezzoSplit[1] : "00";
                %>
                    <div class="product-card wishlist-card" style="position: relative;">
                        
                        <form action="${pageContext.request.contextPath}/RimuoviPreferito" method="post" class="remove-wishlist-form">
                            <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>">
                            <button type="submit" class="remove-btn-corner" title="Rimuovi">✖</button>
                        </form>

                        <div class="product-image">
                            <img src="<%= request.getContextPath() %>/<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>">
                        </div>
                        
                        <div class="product-info">
                            <a href="Prodotto?id=<%= prodotto.getId() %>" class="product-title"><%= prodotto.getNome() %></a>
                            
                            <div class="product-rating">
                                <% if(prodotto.getNumeroRecensioni() > 0) { %>
                                    <span class="stars" style="color: #ffcc00;">⭐ <%= String.format("%.1f", prodotto.getMediaStelle()) %></span>
                                    <span class="rating-count">(<%= prodotto.getNumeroRecensioni() %>)</span>
                                <% } else { %>
                                    <span class="rating-count" style="font-style: italic;">Nuovo arrivo</span>
                                <% } %>
                            </div>  

                            <div class="product-price">
                                <span class="currency">€</span><span class="whole"><%= parteIntera %></span><span class="fraction"><%= decimali %></span>
                            </div>
                            
                            <form action="${pageContext.request.contextPath}/SpostaNelCarrello" method="post" class="product-form">
                                <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>">
                                <button type="submit" class="btn-cart">SPOSTA NEL CARRELLO</button>
                            </form>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </main>

    <%@ include file="footer.jsp"%>
<div id="toast-container" class="toast-container"></div>
</body>
</html>