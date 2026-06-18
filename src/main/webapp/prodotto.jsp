<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.bean.ProdottoBean" %>
<%
    ProdottoBean prodotto = (ProdottoBean) request.getAttribute("dettaglioProdotto");
    
    if(prodotto == null) {
        response.sendRedirect("Home");
        return;
    }
    
    String[] prezzoSplit = String.format("%.2f", prodotto.getPrezzo()).split(",");
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
    
    <link rel="stylesheet" href="./css/style.css?v=10">
    <link rel="stylesheet" href="./css/prodotto.css?v=3">
    
    <script src="./js/home.js" defer></script> 
</head>
<body>
    <header>
        <a href="Home"><h1>memory_cart</h1></a>
        
        <button class="hamburger" id="hamburgerBtn" aria-label="Toggle Menu">
            <span></span>
            <span></span>
            <span></span>
        </button>

        <nav id="mainNav">
            <ul>
                <li><a href="#">Console</a></li>
                <li><a href="#">Cartucce</a></li>
                <li><a href="#">Arcade Club</a></li>
                
                <li class="mobile-action"><a href="#">Preferiti</a></li>
                <li class="mobile-action"><a href="#">Carrello</a></li>
                
                <li class="mobile-login">
                    <a href="#" class="btn-primary" style="padding: 10px 20px; font-size: 0.8rem;">LOGIN</a>
                </li>
            </ul>
        </nav>
        
        <div class="desktop-actions">
            <a href="#" class="action-icon" title="Preferiti">
                <img src="./images/whishlist.png" alt="Preferiti" class="nav-icon">
            </a>
    
            <a href="#" class="action-icon" title="Carrello">
                <img src="./images/cart.png" alt="Carrello" class="nav-icon">
                <span class="cart-badge">0</span>
            </a>
    
            <a href="#" class="btn-primary desktop-login" style="padding: 8px 16px; font-size: 0.7rem;">LOGIN</a>
        </div>
    </header>
    
    <main class="product-page-wrapper">
        
        <section class="product-top-section">
            <div class="product-image-gallery">
                <img src="<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>" id="mainImage">
            </div>
            
            <div class="product-core-info">
                <h1 class="product-title-large"><%= prodotto.getNome() %></h1>
                
                <div class="product-rating-product-page-stars">
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
                
                <div class="product-price-large">
                    <span class="currency">€</span>
                    <span class="whole"><%= parteIntera %></span>
                    <span class="fraction"><%= decimali %></span>
                </div>
                
                <form action="CarrelloServlet" method="post" class="add-to-cart-form">
                    <input type="hidden" name="action" value="add">
                    <input type="hidden" name="id" value="<%= prodotto.getId() %>">
                    <button type="submit" class="btn-primary btn-add-cart">Aggiungi al Carrello</button>
                    <button type="button" class="btn-wishlist">❤</button>
                </form>
            </div>
        </section>

        <section class="product-tabs-section">
            <div class="tabs">
                <button class="tab-btn active">Descrizione</button>
                <button class="tab-btn">Scheda Tecnica</button>
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
                        <img src="<%= sugg.getImmagine() %>" alt="<%= sugg.getNome() %>">
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
            <h3 style="color: var(--8bit-teal); font-family: 'Press Start 2P', monospace; font-size: 0.8rem;">Recensioni Utenti</h3>
            <div class="review-card">
                <div class="review-stars" style="color: var(--8bit-teal); margin-bottom: 5px; font-size: 1.2rem;">★★★★★</div>
                <p class="review-text">Ottimo acquisto!</p>
            </div>
        </section>

    </main>
    
    <footer>
        <% int year = Calendar.getInstance().get(Calendar.YEAR); %>
        <p style="font-family: 'Press Start 2P', monospace; color: var(--8bit-teal); font-size: 0.7rem;">&copy; <%= year %> MEMORY_CART - PRESS X TO START</p>
    </footer>

    <script src="./js/product.js"></script>
</body>
</html>