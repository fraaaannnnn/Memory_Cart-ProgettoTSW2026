<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.UtenteBean" %>
<%@ page import="com.bean.OrdineBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
    
    @SuppressWarnings("unchecked")
    List<OrdineBean> listaOrdini = (List<OrdineBean>) request.getAttribute("listaOrdini");
    
    Integer totaleOrdini = (Integer) request.getAttribute("totaleOrdini");
    Integer xpTotali = (Integer) request.getAttribute("xpTotali");
    Integer livelloAttuale = (Integer) request.getAttribute("livelloAttuale");
    Integer xpMancanti = (Integer) request.getAttribute("xpMancanti");
    Integer percentualeBarra = (Integer) request.getAttribute("percentualeBarra");
    
    if(totaleOrdini == null) totaleOrdini = 0;
    if(xpTotali == null) xpTotali = 0;
    if(livelloAttuale == null) livelloAttuale = 0;
    if(xpMancanti == null) xpMancanti = 500;
    if(percentualeBarra == null) percentualeBarra = 0;
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profilo Giocatore | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/profilo.css">
</head>
<body>

    <%@include file="header.jsp" %>

    <main class="shop-container">
        <h2 class="page-title">PLAYER 1 PROFILE</h2>

        <div class="profile-layout">
            <aside class="profile-sidebar">
                <div class="avatar-container">
                    <div class="avatar-pixel">
                        <span class="p1-badge">P1</span>
                    </div>
                    
                    <% if (utente != null && utente.getAbbonato()) { %>
                        <p class="rank-title">PRO GAMER</p>
                    <% } else { %>
                        <p class="rank-title" style="color: #bbb;">PLAYER 1</p>
                    <% } %>
                </div>

                <div class="stats-box">
                    <h4>ARCADE STATS</h4>
                    <div class="stat-row">
                        <span>LIVELLO:</span>
                        <span class="stat-value">LV <%= String.format("%02d", livelloAttuale) %></span>
                    </div>
                    <div class="stat-row">
                        <span>TOTAL XP:</span>
                        <span class="stat-value"><%= xpTotali %> pts</span>
                    </div>
                    <div class="xp-bar-container">
                        <div class="xp-bar-fill" style="width: <%= percentualeBarra %>%;"></div>
                    </div>
                    <p class="xp-next-level"><%= xpMancanti %> XP al prossimo livello</p>
                </div>

               <div class="stats-box" style="margin-top: 20px; text-align: center;">
                    <h4 style="color: var(--insert-coin-pink); margin-bottom: 15px;">ARCADE CLUB</h4>
                    
                    <% if (utente != null && utente.getAbbonato()) { %>
                        <form action="DisdiciAbbonamento" method="post">
                            <button type="submit" class="btn-primary" style="width: 100%; font-family: 'Press Start 2P', monospace; padding: 10px; font-size: 0.7rem; background-color: #d32f2f; border-color: #d32f2f; cursor: pointer;">
                                DISDICI ABBONAMENTO
                            </button>
                        </form>
                    <% } else { %>
                        <a href="Abbonamento" class="btn-primary" style="display: block; text-align: center; width: 100%; box-sizing: border-box; padding: 10px; font-size: 0.7rem;">
                            DIVENTA PRO GAMER
                        </a>
                    <% } %>
                </div>
            </aside>

            <section class="profile-main-content">
                
                <div class="profile-card-section">
                    <h3>DATI UTENTE (IMPOSTAZIONI)</h3>
                    
                    <form action="AggiornaProfilo" method="post" class="retro-form">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="username">Nome Utente</label>
                                <input type="text" id="username" name="username" value="<%= utente != null && utente.getUserName() != null ? utente.getUserName() : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label for="email">E-mail</label>
                                <input type="email" id="email" name="email" value="<%= utente != null && utente.getEmail() != null ? utente.getEmail() : "" %>" required>
                            </div>
                            <div class="form-group full-width">
                                <label for="password">Nuova Password</label>
                                <input type="password" id="password" name="password" placeholder="••••••••">
                            </div>
                        </div>
                        <button type="submit" class="btn-primary save-btn">SALVA MODIFICHE</button>
                    </form>
                </div>

                <div class="profile-card-section">
                    <div class="orders-header-flex">
                        <h3 style="margin-bottom: 0;">LOG MISSIONI (CRONOLOGIA ORDINI)</h3>
                    </div>
                    <br>
                    
                    <div class="orders-table-container">
                        <table class="retro-table">
                            <thead>
                                <tr>
                                    <th>ID ORDINE</th>
                                    <th>DATA</th>
                                    <th>TOTALE</th>
                                    <th>STATO MISSIONE</th>
                                    <th>FATTURA</th> 
                                </tr>
                            </thead>
                            <tbody>
                                <% 
                                if (listaOrdini != null && !listaOrdini.isEmpty()) { 
                                    for (OrdineBean ordine : listaOrdini) {
                                        String dataFormat = ordine.getDataOrdine() != null ? sdf.format(ordine.getDataOrdine()) : "N/D";
                                        String totaleFormat = String.format("%.2f", ordine.getTotaleOrdine()).replace(",", ".");
                                        
                                        String classeBadge = "processing";
                                        String testoStato = "IN CORSO";
                                        
                                        if (ordine.getStato() != null) {
                                            switch (ordine.getStato()) {
                                                case CONSEGNATO: classeBadge = "completed"; testoStato = "COMPLETATA"; break;
                                                case SPEDITO: classeBadge = "processing"; testoStato = "IN VIAGGIO"; break;
                                                case ANNULLATO: classeBadge = "cancelled"; testoStato = "ANNULLATA"; break;
                                                case IN_PREPARAZIONE: default: classeBadge = "processing"; testoStato = "IN CORSO"; break;
                                            }
                                        }
                                %>
                                <tr>
                                    <td class="order-id">#MC-<%= ordine.getIdOrdine() %></td>
                                    <td><%= dataFormat %></td>
                                    <td>€ <%= totaleFormat %></td>
                                    <td><span class="status-badge <%= classeBadge %>"><%= testoStato %></span></td>
                                    <td>
                                        <a href="Fattura?id=<%= ordine.getIdOrdine() %>" class="btn-primary" style="padding: 5px 10px; font-size: 0.6rem; text-decoration: none; display: inline-block;">
                                            ⬇ PDF
                                        </a>
                                    </td>
                                </tr>
                                <% 
                                    } 
                                } else { 
                                %>
                                <tr>
                                    <td colspan="5" style="text-align: center; padding: 20px;">Nessuna missione registrata nei server.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                </div>

            </section>
        </div>
    </main>

    <%@include file="footer.jsp" %>
<div id="toast-container" class="toast-container"></div>
</body>
</html>