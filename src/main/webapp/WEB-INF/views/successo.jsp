<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.dao.OrdineDAO" %>
<%@ page import="com.bean.OrdineBean" %>
<%@ page import="com.bean.UtenteBean" %>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ordine Confermato | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/successo.css">
</head>
<body>

    <%@include file="header.jsp" %>

    <%
        UtenteBean utenteLoggato = (UtenteBean) session.getAttribute("utenteLoggato");

        String idOrdineStampare = "N/D";
        String statoStampare = "In preparazione";

        if (utenteLoggato != null) {
            int idUtente = utenteLoggato.getId();     

            OrdineDAO ordineDAO = new OrdineDAO();
            OrdineBean ultimoOrdine = ordineDAO.getUltimoOrdineUtente(idUtente);            
            if (ultimoOrdine != null) {
                idOrdineStampare = String.valueOf(ultimoOrdine.getIdOrdine());
                
                if (ultimoOrdine.getStato() != null) {
                    statoStampare = ultimoOrdine.getStato().toString().replace("_", " ").toLowerCase();
                    statoStampare = statoStampare.substring(0, 1).toUpperCase() + statoStampare.substring(1);
                }
            }
        }
    %>

    <main class="shop-container success-container">
        <div class="success-card">
            <div class="trophy-icon">🏆</div>
            <h2 class="success-title">LEVEL CLEARED!</h2>
            <p class="success-subtitle">Missione compiuta. Il tuo ordine è stato ricevuto con successo.</p>
            
            <div class="order-details-box">
                <p><strong>Numero Ordine:</strong> #<%= idOrdineStampare %></p>
                <p><strong>Status:</strong> <%= statoStampare %></p>
            </div>

            <div class="success-actions">
                <a href="Catalogo" class="btn-primary">TORNA AL CATALOGO</a>
                <a href="Profilo" class="btn-secondary">VEDI I TUOI ORDINI</a>
            </div>
        </div>
    </main>

    <%@include file="footer.jsp"%>
<div id="toast-container" class="toast-container"></div>
</body>
</html>