<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrazione | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/auth.css">
</head>
<body>

    <%@include file="header.jsp" %>

    <main class="shop-container auth-wrapper">
        <div class="auth-card">
            <h2 class="auth-title">NEW CHALLENGER</h2>
            <p class="auth-subtitle">Crea il tuo profilo giocatore</p>

            <form action="Register" method="post" id="signupForm" class="retro-form">
               	<div class="form-group">
					<label for="nome">User</label>
					<input type="text" id="nome" name="nome" placeholder="Mario" required>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="player1@arcade.it" required>
                    <span id="email-error" style="color: var(--insert-coin-pink); font-family: 'Inter', sans-serif; font-size: 0.8rem; display: none; margin-top: 5px;">
                    </span>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" placeholder="Min. 8 caratteri" required>
                </div>

                <div class="form-group">
                    <label for="confirm-password">Conferma Password</label>
                    <input type="password" id="confirm-password" name="confirm-password" placeholder="Ripeti password" required>
                </div>

                <button type="submit" class="btn-primary auth-btn">CREA ACCOUNT</button>
            </form>

            <div class="auth-footer-text">
                <p>Hai già un salvataggio?</p><br>
                <p><a href="Login" class="auth-link highlight">Accedi qui</a></p>
            </div>
        </div>
    </main>

    <%@include file="footer.jsp" %>


<div id="toast-container" class="toast-container"></div>
<script>
document.getElementById("email").addEventListener("blur", function() {
    var emailInserita = this.value.trim();
    var errorSpan = document.getElementById("email-error");
    var submitBtn = document.querySelector(".auth-btn");

    if (emailInserita === "") {
        errorSpan.style.style.display = "none";
        return;
    }

    var url = "<%= request.getContextPath() %>/CheckEmail?email=" + encodeURIComponent(emailInserita);

    fetch(url)
        .then(response => response.text()) 
        .then(esiste => {
            if (esiste === "true") {
                errorSpan.style.display = "block";
                errorSpan.style.fontFamily = "'Press Start 2P', monospace";
                errorSpan.textContent = "ATTENZIONE: Questa email è già in uso da un altro giocatore!";
                
                submitBtn.disabled = true;
                submitBtn.style.opacity = "0.5";
                submitBtn.style.cursor = "not-allowed";
            } else {
                errorSpan.style.display = "none";
                submitBtn.disabled = false;
                submitBtn.style.opacity = "1";
                submitBtn.style.cursor = "pointer";
            }
        })
        .catch(error => {
            console.error("Errore durante il controllo AJAX dell'email:", error);
        });
});
</script>
</body>
</html>