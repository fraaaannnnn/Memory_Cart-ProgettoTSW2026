<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bean.ProdottoBean" %>
<% 
    @SuppressWarnings("unchecked")
    List<ProdottoBean> prodotti = (List<ProdottoBean>) request.getAttribute("prodottiAdmin"); 
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/admin.css"> 
</head>
<body>

    <%@ include file="admin_header.jsp"%> 
    
    <main class="admin-main-container">
        <div class="dashboard-wrapper">
            
            <div class="dashboard-header">
                <div class="dashboard-titles">
                    <h2 class="admin-title">PANNELLO DI CONTROLLO</h2>
                    <p class="admin-subtitle">&gt; GESTIONE CATALOGO PRODOTTI</p>
                </div>
                <div class="dashboard-actions">
                    <a href="${pageContext.request.contextPath}/AdminAggiungiProdotto" class="btn-add-new">
                        + NUOVO ARTICOLO
                    </a>
                </div>
            </div>

            <div class="admin-table-wrapper">
                <table class="retro-table admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>FOTO</th>
                            <th>NOME GIOCO</th>
                            <th>PREZZO</th>
                            <th>QTÀ</th>
                            <th>COMANDI</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (prodotti != null && !prodotti.isEmpty()) { 
                            for (ProdottoBean p : prodotti) { %>
                            <tr>
                                <td class="text-center">#<%= p.getId() %></td>
                                <td class="text-center">
                                    <img src="./<%= p.getImmagine() %>" alt="img" class="admin-thumb">
                                </td>
                                <td class="product-name-cell"><%= p.getNome() %></td>
                                <td class="price-cell">€ <%= String.format("%.2f", p.getPrezzo()) %></td>
                                <td class="text-center">
                                    <% if(p.getQuantita() > 0) { %>
                                        <span class="qty-ok"><%= p.getQuantita() %></span>
                                    <% } else { %>
                                        <span class="qty-empty">ESAURITO</span>
                                    <% } %>
                                </td>
                                <td>
                                    <div class="action-buttons-cell">
                                        <form action="./AdminModificaProdotto" method="GET">
                                            <input type="hidden" name="idProdotto" value="<%= p.getId() %>">
                                            <button type="submit" class="admin-action-btn btn-edit">MODIFICA</button>
                                        </form>
                                        
                                        <form action="./AdminEliminaProdotto" method="POST" id="form-delete-<%= p.getId() %>">
                                             <input type="hidden" name="idProdotto" value="<%= p.getId() %>">
                                             <button type="button" class="admin-action-btn btn-delete" onclick="openRetroModal('form-delete-<%= p.getId() %>')">ELIMINA</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="6" class="empty-db-msg">
                                    IL DATABASE È VUOTO. INSERISCI UN GIOCO.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/footer.jsp"%>
    
    <div id="retro-alert-modal" class="retro-modal-overlay">
        <div class="retro-modal-box">
            <h3 class="retro-modal-title">WARNING!</h3>
            <p class="retro-modal-text">Sei sicuro di voler eliminare definitivamente questo articolo dal database?</p>
            <div class="retro-modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="closeRetroModal()">ANNULLA</button>
                <button type="button" class="btn-modal-confirm" onclick="confirmRetroDelete()">ELIMINA</button>
            </div>
        </div>
    </div>
    <script src="./js/admin_prodotti.js"></script>
</body>
</html>