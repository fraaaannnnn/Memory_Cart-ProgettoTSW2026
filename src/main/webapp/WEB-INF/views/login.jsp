<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/auth.css">
</head>
<body>

    <%@include file="header.jsp"%>

    <main class="shop-container auth-wrapper">
        <div class="auth-card">
            <h2 class="auth-title">INSERT COIN</h2>
            <%-- Se c'è un errore proveniente dalla Servlet, stampalo --%>
<% if (request.getAttribute("erroreLogin") != null) { %>
    <div style="background-color: rgba(255, 0, 117, 0.1); border: 1px solid var(--insert-coin-pink); color: var(--insert-coin-pink); padding: 10px; margin-bottom: 20px; border-radius: 4px; font-family: 'Inter', sans-serif; font-size: 0.9rem;">
        ⚠️ <%= request.getAttribute("erroreLogin") %>
    </div>
<% } %>
            <p class="auth-subtitle">Accedi al tuo account per continuare</p>

            <form action="Login" method="post" id="loginForm" class="retro-form">
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="player1@arcade.it" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="••••••••" required>
                </div>

                <div class="auth-options">
                    <label class="checkbox-label" for="keep-me-logged-in">
                        <input type="checkbox" name="keep_me_logged_in" id="keep-me-logged-in">
                        <span class="custom-checkbox"></span>
                        <span class="checkbox-text">Rimani collegato</span>
                    </label>
                </div>

                <button type="submit" class="btn-primary auth-btn">PRESS START (LOGIN)</button>
            </form>

            <div class="auth-footer-text">
                <p>Nuovo giocatore?</p><br><p><a href="signup.html" class="auth-link highlight">Registrati qui</a></p>
            </div>
        </div>
    </main>

    <%@include file="footer.jsp"%>

</body>
</html>