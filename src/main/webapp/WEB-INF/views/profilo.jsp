<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.bean.UtenteBean" %>
<%
    UtenteBean utente = (UtenteBean) session.getAttribute("utenteLoggato");
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
                   
                    <h3><%= utente != null ? utente.getUserName() : "Guest" %></h3>
                    
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
                        <span class="stat-value">LV 00</span>
                    </div>
                    <div class="stat-row">
                        <span>TOTAL XP:</span>
                        <span class="stat-value">0 pts</span>
                    </div>
                    <div class="xp-bar-container">
                        <div class="xp-bar-fill" style="width: 0%;"></div>
                    </div>
                    <p class="xp-next-level">100 XP al prossimo livello</p>
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
                                <input type="text" id="username" name="username" value="<%= utente != null ? utente.getUserName() : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label for="email">E-mail</label>
                                <input type="email" id="email" name="email" value="<%= utente != null ? utente.getEmail() : "" %>" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Nuova Password</label>
                                <input type="password" id="password" name="password" placeholder="••••••••">
                            </div>
                            <div class="form-group">
                                <label for="indirizzo">Indirizzo Spedizione</label>
                                <input type="text" id="indirizzo" name="indirizzo" value="<%= (utente != null && utente.getIndirizzo() != null) ? utente.getIndirizzo() : "" %>">
                            </div>
                        </div>
                        <button type="submit" class="btn-primary save-btn">SALVA MODIFICHE</button>
                    </form>
                </div>

                <div class="profile-card-section">
                    <h3>LOG MISSIONI (CRONOLOGIA ORDINI)</h3>
                    
                    <div class="orders-table-container">
                        <table class="retro-table">
                            <thead>
                                <tr>
                                    <th>ID ORDINE</th>
                                    <th>DATA</th>
                                    <th>TOTALE</th>
                                    <th>STATO MISSIONE</th>
                                </tr>
                            </thead>
                            <!--  esempio visivo cronologia ordini
                            <tbody>
                                <tr>
                                    <td class="order-id">#MC-8492</td>
                                    <td>15/06/2026</td>
                                    <td>€ 45.00</td>
                                    <td><span class="status-badge completed">COMPLETATA</span></td>
                                </tr>
                                <tr>
                                    <td class="order-id">#MC-7210</td>
                                    <td>28/05/2026</td>
                                    <td>€ 120.00</td>
                                    <td><span class="status-badge completed">COMPLETATA</span></td>
                                </tr>
                                <tr>
                                    <td class="order-id">#MC-9901</td>
                                    <td>23/06/2026</td>
                                    <td>€ 80.00</td>
                                    <td><span class="status-badge processing">IN CORSO</span></td>
                                </tr>
                            </tbody>
                            -->
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