<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.OrdineBean" %>
<%@ page import="com.bean.UtenteBean" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    OrdineBean ordine = (OrdineBean) request.getAttribute("ordine");
    UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");
    
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
    
    String dataFormat = (ordine != null && ordine.getDataOrdine() != null) ? sdf.format(ordine.getDataOrdine()) : "N/D";
    String totaleFormat = (ordine != null) ? String.format("%.2f", ordine.getTotaleOrdine()).replace(",", ".") : "0.00";
    String statoFormat = (ordine != null && ordine.getStato() != null) ? ordine.getStato().toString() : "IN PREPARAZIONE";
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ricevuta Missione #MC-<%= ordine != null ? ordine.getIdOrdine() : "N/D" %> | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/fattura.css">
</head>
<body>

    <%@include file="header.jsp" %>

    <main class="invoice-wrapper">
        <% if (ordine != null) { %>
            <div class="invoice-container">
                <div class="invoice-header">
                    <h1 class="invoice-title">MEMORY_CART</h1>
                    <p class="invoice-subtitle">RICEVUTA FISCALE</p>
                </div>
                
                <div class="details-grid">
                    <div class="section-box">
                        <h4>INFO LOG</h4>
                        <p><strong>ID Ordine:</strong> #MC-<%= ordine.getIdOrdine() %></p>
                        <p><strong>Data Emissione:</strong> <%= dataFormat %></p>
                        <p><strong>Stato Corrente:</strong> <%= statoFormat %></p>
                    </div>
                    <div class="section-box">
                        <h4>PLAYER INFO</h4>
                        <p><strong>ID Player:</strong> #<%= utenteLoggato != null ? utenteLoggato.getId() : "N/D" %></p>
                        <p><strong>E-mail:</strong> <span style="text-transform: lowercase;"><%= utenteLoggato != null ? utenteLoggato.getEmail() : "N/D" %></span></p>
                    </div>
                </div>
                
                <table class="invoice-table">
                    <thead>
                        <tr>
                            <th>LOG DESCRIZIONE OPERAZIONE</th>
                            <th style="text-align: right; width: 150px;">SCORE (PREZZO)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Acquisto hardware / oggettistica dal catalogo memory_cart</td>
                            <td style="text-align: right;">€ <%= totaleFormat %></td>
                        </tr>
                        <tr class="total-row">
                            <td style="text-align: right; border-right: none;">TOTAL SCORE:</td>
                            <td style="text-align: right; border-left: none;">€ <%= totaleFormat %></td>
                        </tr>
                    </tbody>
                </table>
                
                <div class="invoice-footer">
                    Grazie per aver completato la missione su memory_cart!<br>
                    I dati sono stati sincronizzati nei database centrali.<br>
                </div>
            </div>
            
        <% } else { %>
            <div style="text-align: center; margin-top: 50px;">
                <h2 style="font-family: 'Press Start 2P', monospace; color: var(--insert-coin-pink);">ERRORE 404: DATA NOT FOUND</h2>
                <p>Impossibile recuperare i dati del log di questa missione.</p>
            </div>
        <% } %>
    </main>

    <%@include file="footer.jsp" %>
    <div id="toast-container" class="toast-container"></div>
    
</body>
</html>