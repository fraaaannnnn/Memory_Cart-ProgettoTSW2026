<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.UtenteBean" %>
<%
    UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
    boolean isLogged = (utente != null);
    String linkRegistrazione = isLogged ? "/Memory_Cart/" : "Register"; 
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Arcade Club - Pro Gamer | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/abbonamento.css">
</head>
<body>

    <%@include file="header.jsp" %>
    <main class="shop-container club-container">
        
        <div class="club-header">
            <h2 class="club-title">ARCADE CLUB</h2>
            <p class="club-subtitle">Scegli il tuo livello di potenza. Sblocca vantaggi esclusivi e diventa una leggenda del retrogaming.</p>
        </div>

        <div class="pricing-grid">
            
            <div class="pricing-card basic-tier">
                <div class="tier-header">
                    <h3 class="tier-name">PLAYER 1</h3>
                    <div class="tier-price">
                        <span class="currency">€</span><span class="amount">0</span><span class="period">/mese</span>
                    </div>
                    <p class="tier-desc">Per i videogiocatori occasionali.</p>
                </div>
                
               <ul class="tier-features">
                    <li><span class="check">✓</span> <span>Accesso a tutto il catalogo</span></li>
                    <li><span class="check">✓</span> <span>Creazione Wishlist</span></li>
                    <li><span class="check">✓</span> <span>Storico degli ordini</span></li>
                    <li class="disabled"><span class="cross">✕</span> <span>Spedizione Gratuita</span></li>
                    <li class="disabled"><span class="cross">✕</span> <span>Accesso anticipato ai rari</span></li>
                </ul>

                <div class="tier-action">
                    <a href="<%= linkRegistrazione %>" class="btn-secondary">REGISTRATI GRATIS</a>
                </div>
            </div>

            <div class="pricing-card pro-tier">
                <div class="pro-badge">CONSIGLIATO</div>
                <div class="tier-header">
                    <h3 class="tier-name">PRO GAMER</h3>
                    <div class="tier-price highlight-price">
                        <span class="currency">€</span><span class="amount">4.99</span><span class="period">/mese</span>
                    </div>
                    <p class="tier-desc">L'esperienza definitiva per veri collezionisti.</p>
                </div>
                
              <ul class="tier-features">
                    <li><span class="check">✓</span> <span>Tutti i vantaggi del Player 1</span></li>
                    <li><span class="check highlight-check">✓</span> <span><strong>Spedizione Gratuita</strong> su tutti gli ordini</span></li>
                    <li><span class="check highlight-check">✓</span> <span>Accesso <strong>anticipato di 24h</strong> ai giochi rari</span></li>
                    <li><span class="check highlight-check">✓</span> <span>Badge "Pro Gamer" sul profilo</span></li>
                </ul>

                <div class="tier-action">
                    <% 
                        if (isLogged && utente.getAbbonato()) {
                    %>
                        <button type="button" class="btn-primary" style="background-color: var(--8bit-teal); border: 2px solid var(--8bit-teal); cursor: default; width: 100%;">PIANO ATTIVO</button>
                    <% 
                        } else {
                    %>
                        <form action="abbonamento" method="post">
                            <input type="hidden" name="tier" value="progamer">
                            <button type="submit" class="btn-primary upgrade-btn">INSERT COIN (ABBONATI)</button>
                        </form>
                    <% 
                        } 
                    %>
                </div>
            </div>

        </div>

        <div class="faq-section">
            <h4 style="font-family: 'Press Start 2P', monospace; color: var(--8bit-teal); font-size: 0.9rem; text-align: center; margin-bottom: 20px;">FAQ</h4>
            <p style="text-align: center; color: #bbb; font-family: 'Inter', sans-serif; font-size: 0.9rem;">Puoi annullare l'abbonamento PRO GAMER in qualsiasi momento direttamente dalla tua area privata.</p>
        </div>
        
        <div id="toast-container" class="toast-container"></div>
    </main>

    <%@include file="footer.jsp" %>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <% 
        String success = request.getParameter("success");
        if ("true".equals(success)) { 
    %>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            showRetroToast('LEVEL UP! Abbonamento PRO GAMER attivato.', 'wishlist');
        });
    </script>
    <% } %>

</body>
</html>