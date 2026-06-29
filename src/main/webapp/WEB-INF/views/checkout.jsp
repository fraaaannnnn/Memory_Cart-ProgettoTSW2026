<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="com.bean.UtenteBean" %>
<%@ page import="com.bean.ProdottoBean" %>
<%@ page import="com.dao.CarrelloDAO" %>
<%@ page import="com.dao.ProdottoDAO" %>
<%
    UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
    Map<Integer, Integer> carrelloDaMostrare = new HashMap<>();

    if (utenteLoggato != null) {
        CarrelloDAO carrelloDAO = new CarrelloDAO();
        carrelloDaMostrare = carrelloDAO.getCarrelloUtente(utenteLoggato.getId());
    } else {
        carrelloDaMostrare = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
        if (carrelloDaMostrare == null) {
            carrelloDaMostrare = new HashMap<>();
        }
    }

    ProdottoDAO prodottoDAO = new ProdottoDAO(); 
    double totaleCarrello = 0.0;
    double spedizione = 5.00;
    boolean isAbbonato = utenteLoggato != null && utenteLoggato.getAbbonato();
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Checkout | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/checkout.css">
</head>
<body>

    <%@include file="header.jsp" %>
    <main class="shop-container">
        <h2 class="page-title">CHECKOUT</h2>

        <form action="#" method="post" class="checkout-form-wrapper">
            
            <div class="checkout-layout">
                
                <div class="checkout-card">
                    <h3>1. INDIRIZZO DI SPEDIZIONE</h3>
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nome">Nome</label>
                            <input type="text" id="nome" name="nome" placeholder="Mario" required>
                        </div>
                        <div class="form-group">
                            <label for="cognome">Cognome</label>
                            <input type="text" id="cognome" name="cognome" placeholder="Bros" required>
                        </div>
                        <div class="form-group full-width">
                            <label for="indirizzo">Indirizzo completo</label>
                            <input type="text" id="indirizzo" name="indirizzo" placeholder="Via dei Funghi, 1" required>
                        </div>
                        <div class="form-group">
                            <label for="citta">Città</label>
                            <input type="text" id="citta" name="citta" placeholder="Milano" required>
                        </div>
                        <div class="form-group">
                            <label for="cap">CAP</label>
                            <input type="text" id="cap" name="cap" placeholder="20100" required>
                        </div>
                    </div>
                </div>

                <div class="checkout-card">
                    <h3>2. METODO DI PAGAMENTO</h3>
                    
                    <div class="payment-methods">
                        <label class="payment-option">
                            <input type="radio" name="pagamento" value="carta" checked>
                            <span class="option-content">
                                <span class="option-title">Carta di Credito / Debito</span>
                                <span class="option-icons">💳</span>
                            </span>
                        </label>
                    </div>

                    <div class="form-grid mt-20">
					    <div class="form-group full-width">
					        <label for="numero_carta">Numero Carta</label>
					        <input type="text" id="numero_carta" name="numero_carta" placeholder="0000 0000 0000 0000">
					    </div>
					    <div class="form-group">
					        <label for="scadenza">Scadenza (MM/AA)</label>
					        <input type="text" id="scadenza" name="scadenza" placeholder="12/28">
					    </div>
					    <div class="form-group">
					        <label for="cvv">CVV</label>
					        <input type="text" id="cvv" name="cvv" placeholder="123">
					    </div>
					</div>
                </div>

                <div class="checkout-summary-section">
                    <h3>RIEPILOGO MISSIONE</h3>
                    
					<div class="summary-items">
					    <% 
					    if (carrelloDaMostrare.isEmpty()) { 
					    %>
					        <p style="color: var(--8bit-teal); font-family: 'Press Start 2P', monospace; font-size: 0.6rem; text-align: center;">Nessun articolo in missione.</p>
					    <% 
					    } else { 
					        for (Map.Entry<Integer, Integer> entry : carrelloDaMostrare.entrySet()) {
					            int idProdotto = entry.getKey();
					            int quantita = entry.getValue();
					            ProdottoBean prodotto = prodottoDAO.prodottoDaId(idProdotto);
					            
					            if (prodotto != null) {
					                totaleCarrello += (prodotto.getPrezzo() * quantita);
					    %>
					        <div class="summary-item-card">
					            <div class="summary-item-info">
					                <span class="item-name"><%= prodotto.getNome() %> (x<%= quantita %>)</span>
					                <span class="item-price">€ <%= String.format("%.2f", prodotto.getPrezzo() * quantita) %></span>
					            </div>
					        </div>
					    <% 
					            } 
					        } 
					    }					    
					    if(totaleCarrello == 0 || isAbbonato) { 
					        spedizione = 0; 
					    } 
					    %>
					</div>
					
					<hr class="neon-divider">
					
					<div class="summary-row">
					    <span>Subtotale</span>
					    <span>€ <%= String.format("%.2f", totaleCarrello) %></span>
					</div>
					<div class="summary-row">
					    <span>Spedizione</span>
					    <% if (isAbbonato) { %>
					        <span class="custom-strike"><%= String.format("%.2f", spedizione + 5) %></span>
					        <span style="color: var(--insert-coin-pink)">€ <%= String.format("%.2f", spedizione) %></span>
					    <% } else { %>
					        <span>€ <%= String.format("%.2f", spedizione) %></span>
					    <% } %>
					</div>
		
				<hr class="neon-divider">

                    <button type="submit" class="btn-primary checkout-btn">CONFERMA ORDINE</button>	
                </div>

            </div>
        </form>
    </main>
    <%@include file="footer.jsp" %>
    <script src="./js/checkout.js"></script>
</body>
</html>