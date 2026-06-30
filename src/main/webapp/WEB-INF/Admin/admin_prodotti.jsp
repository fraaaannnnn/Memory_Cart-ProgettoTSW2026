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
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/carrello.css"> 
    <link rel="stylesheet" href="./css/admin.css"> 
    
    <style>
        * {
            font-family: 'Press Start 2P', monospace !important;
        }
        .retro-table td {
            font-size: 0.6rem !important;
            line-height: 1.5;
        }
        .retro-table th {
            font-size: 0.7rem !important;
        }
        .admin-action-btn {
            font-size: 0.5rem !important;
        }
    </style>
</head>
<body>

    <%@ include file="/WEB-INF/views/header.jsp"%> 
    
    <main class="shop-container">
        
        <h2 class="page-title" style="color: #ff0075;">PANNELLO DI CONTROLLO</h2>
        <p style="color: #ccc; font-size: 0.6rem; margin-bottom: 30px;">
            > GESTIONE CATALOGO PRODOTTI
        </p>

        <div style="text-align: right; width: 100%;">
            <a href="${pageContext.request.contextPath}/AdminAggiungiProdotto" class="btn-add-new">
                + NUOVO ARTICOLO
            </a>
        </div>

        <div class="admin-table-wrapper">
            <table class="retro-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Foto</th>
                        <th>Nome Gioco</th>
                        <th>Prezzo</th>
                        <th>Qtà</th>
                        <th>Comandi</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (prodotti != null && !prodotti.isEmpty()) { 
                        for (ProdottoBean p : prodotti) { %>
                        <tr>
                            <td><%= p.getId() %></td>
                            <td><img src="./<%= p.getImmagine() %>" alt="img" style="width: 60px; height: 60px; object-fit: cover; border: 1px solid #32e0c4;"></td>
                            <td><%= p.getNome() %></td>
                            <td style="color: #32e0c4;">€ <%= String.format("%.2f", p.getPrezzo()) %></td>
                            <td>
                                <% if(p.getQuantita() > 0) { %>
                                    <%= p.getQuantita() %>
                                <% } else { %>
                                    <span style="color: #ff0075;">ESAURITO</span>
                                <% } %>
                            </td>
                            <td>
                                <form action="./AdminModificaProdotto" method="GET" style="display:inline;">
                                    <input type="hidden" name="idProdotto" value="<%= p.getId() %>">
                                    <button type="submit" class="admin-action-btn btn-edit">MODIFICA</button>
                                </form>
                                
                                <form action="./AdminEliminaProdotto" method="POST" onsubmit="return confirm('Sicuro?');">
                                     <input type="hidden" name="idProdotto" value="<%= p.getId() %>">
                                     <button type="submit" class="admin-action-btn btn-delete">ELIMINA</button>
                                </form>
                            </td>
                        </tr>
                    <%  } 
                    } else { %>
                        <tr>
                            <td colspan="6" style="text-align:center; padding: 30px; color: #ff0075;">
                                IL DATABASE È VUOTO. INSERISCI UN GIOCO.
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </main>

    <%@ include file="/WEB-INF/views/footer.jsp"%>
</body>
</html>