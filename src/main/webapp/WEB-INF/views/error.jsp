<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isErrorPage="true" %>

<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorTitle = "ERRORE SCONOSCIUTO";
    String errorDesc = "SI E' VERIFICATO UN ERRORE ANOMALO NEL SISTEMA.";
    String errorCodeDisplay = (statusCode != null) ? String.valueOf(statusCode) : "???";

    if (statusCode != null) {
        switch (statusCode) {
            case 404:
                errorTitle = "GAME OVER";
                errorDesc = "LA MISSIONE E' FALLITA.<br>LA PAGINA CHE CERCHI E' STATA RISUCCHIATA IN UN BUCO NERO.";
                break;
            case 500:
                errorTitle = "GLITCH CRITICO";
                errorDesc = "DANNO STRUTTURALE RILEVATO.<br>IL SERVER HA SUBITO UN CRASH INTERNO IMPREVISTO.";
                break;
            case 403:
                errorTitle = "ACCESSO NEGATO";
                errorDesc = "ZONA PROIBITA.<br>NON HAI L'AUTORIZZAZIONE PER ENTRARE IN QUESTO LIVELLO.";
                break;
        }
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Errore <%= errorCodeDisplay %> | memory_cart</title>
    
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/errore.css">
</head>
<body>

    <%@ include file="header.jsp"%>

    <main class="error-container">
        <div class="error-content">
            <h1 class="glitch-text" data-text="<%= errorCodeDisplay %>"><%= errorCodeDisplay %></h1>
            
            <h2 class="error-title"><%= errorTitle %></h2>
            
            <p class="error-desc">
                <%= errorDesc %>
            </p>
            
            <p class="insert-coin-text blink-text">INSERT COIN TO CONTINUE...</p>

            <div class="error-actions">
                <a href="/Memory_Cart/" class="btn-primary return-home-btn">TORNA ALLA BASE</a>
            </div>
        </div>
    </main>

    <%@ include file="footer.jsp"%>    
    <script src="./js/main.js"></script>
</body>
</html>