<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.bean.UtenteBean" %>
<%@ page import="com.bean.ProdottoBean" %>
<%@ page import="com.dao.CarrelloDAO" %>
<%@ page import="com.dao.ProdottoDAO" %> <%
    UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
    Map<Integer, Integer> carrelloDaMostrare = new HashMap<>();
	boolean isAbbonato = false;
    if (utenteLoggato != null) {
        CarrelloDAO carrelloDAO = new CarrelloDAO();
        carrelloDaMostrare = carrelloDAO.getCarrelloUtente(utenteLoggato.getId());
        isAbbonato = utenteLoggato.getAbbonato();
    } else {
        carrelloDaMostrare = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
        if (carrelloDaMostrare == null) {
            carrelloDaMostrare = new HashMap<>();
        }
    }

    ProdottoDAO prodottoDAO = new ProdottoDAO(); 
    double totaleCarrello = 0.0;
    double spedizione = 5.00;
%>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Carrello | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/carrello.css">
</head>
<body>

    <%@ include file="header.jsp"%>

    <main class="shop-container">
        <h2 class="page-title">IL TUO CARRELLO</h2>

        <div class="cart-layout">
            
            <div class="cart-items-section">
                
                <% 
                if (carrelloDaMostrare.isEmpty()) { 
                %>
                    <div style="text-align: center; padding: 50px 0; color: white; font-family: 'Press Start 2P', monospace;">
                        <p>IL CARRELLO E' VUOTO</p>
                        <p style="font-size: 0.6rem; margin-top: 20px; color: var(--8bit-teal);">INSERISCI UN GETTONE PER INIZIARE</p>
                    </div>
                <% 
                } else { 
                    for (Map.Entry<Integer, Integer> entry : carrelloDaMostrare.entrySet()) {
                        int idProdotto = entry.getKey();
                        int quantita = entry.getValue();
                        
                        ProdottoBean prodotto = prodottoDAO.prodottoDaId(idProdotto);
                        
                        if (prodotto != null) {
                            totaleCarrello += (prodotto.getPrezzo() * quantita);
                %>
                
                <div class="cart-item-card">
                    <div class="cart-img-box">
                        <img src="<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>">
                    </div>
                    <div class="cart-item-details">
    					<a href="DettaglioProdotto?id=<%= idProdotto %>" class="item-name"><%= prodotto.getNome() %></a>
					    <span class="item-reviews" style="font-size: 0.8rem; color: #ffcc00; margin-top: 5px; display: block;">
					        <% if (prodotto.getNumeroRecensioni() > 0) { %>
					            ⭐ <%= String.format("%.1f", prodotto.getMediaStelle()) %> 
					            <span style="color: #888; font-size: 0.7rem;">(<%= prodotto.getNumeroRecensioni() %>)</span>
					        <% } else { %>
					            <span style="color: #888; font-style: italic;">Nessuna recensione</span>
					        <% } %>
					    </span>
					</div>
                    <div class="cart-item-actions">
                        <div class="quantity-control">
                            <form action="AggiornaQuantita" method="post" style="display: flex;">
                                <input type="hidden" name="idProdotto" value="<%= idProdotto %>">
                                
                                <button type="submit" name="azione" value="diminuisci" class="qty-btn">-</button>
                                <input type="number" name="quantita" value="<%= quantita %>" readonly>
                                <button type="submit" name="azione" value="aumenta" class="qty-btn">+</button>
                            </form>
                        </div>
                        <div class="item-price">
                            <span class="price-value">€ <%= String.format("%.2f", prodotto.getPrezzo() * quantita) %></span>
                        </div>
                        
                        <form action="RimuoviDalCarrello" method="post" style="margin: 0;">
                            <input type="hidden" name="idProdotto" value="<%= idProdotto %>">
                            <button type="submit" class="remove-btn" title="Rimuovi articolo">✕</button>
                        </form>
                    </div>
                </div>
                
                <% 
                        } 
                    } 
                %>

                <div class="cart-bottom-actions">
                    <form action="SvuotaCarrello" method="post" id="emptyCartForm">
                        <button type="submit" class="btn-empty-cart">🗑️ SVUOTA CARRELLO</button>
                    </form>
                </div>
                
                <% 
                } 
                %>
            </div>

            <div class="cart-summary-section">
                <h3>RIEPILOGO MISSIONE</h3>
                
                <hr class="neon-divider">

                <div class="summary-row">
                    <span>Subtotale</span>
                    <span>€ <%= String.format("%.2f", totaleCarrello) %></span>
                </div>
                <div class="summary-row">
                    <span>Spedizione</span>
                    <% if(totaleCarrello == 0 || isAbbonato){ spedizione = 0; } 
                    %>
                    <%if (isAbbonato) {%>
                    <span class="custom-strike"><%= String.format("%.2f", spedizione + 5) %></span><span style="color: var(--insert-coin-pink)">€ <%= String.format("%.2f", spedizione) %></span>
                	<%} else { %>
                	<span>€ <%= String.format("%.2f", spedizione) %></span>
                	<%} %>
                </div>
                <hr class="neon-divider">
                
                <div class="summary-row total">
                    <span>TOTALE (EUR)</span>
                    <span>€ <%= String.format("%.2f", totaleCarrello + spedizione) %></span>
                </div>

                <% if(totaleCarrello > 0) { %>
                    <a href="Checkout" class="btn-primary checkout-btn" style="text-decoration: none;">PROCEDI AL CHECKOUT</a>
                <% } else { %>
                    <button class="btn-primary checkout-btn" style="opacity: 0.5; cursor: not-allowed;" disabled>CARRELLO VUOTO</button>
                <% } %>
            </div>

        </div>
    </main>

    <div id="toast-container" class="toast-container"></div>
    <%@ include file="footer.jsp"%>
</body>
</html>