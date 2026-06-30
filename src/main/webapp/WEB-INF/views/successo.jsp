<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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

    <main class="shop-container success-container">
        <div class="success-card">
            <div class="trophy-icon">🏆</div>
            <h2 class="success-title">LEVEL CLEARED!</h2>
            <p class="success-subtitle">Missione compiuta. Il tuo ordine è stato ricevuto con successo.</p>
            
            <div class="order-details-box">
                <p><strong>Numero Ordine:</strong> #MC-2026-0042</p>
                <p><strong>Status:</strong> In preparazione</p>
                <p><strong>Email di conferma:</strong> inviata al tuo indirizzo</p>
            </div>

            <div class="success-actions">
                <a href="catalogo.html" class="btn-primary">TORNA AL CATALOGO</a>
                <a href="profilo.html" class="btn-secondary">VEDI I TUOI ORDINI</a>
            </div>
        </div>
    </main>

    <%@include file="footer.jsp"%>
<div id="toast-container" class="toast-container"></div>
</body>
</html>