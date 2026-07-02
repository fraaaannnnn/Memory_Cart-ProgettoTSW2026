<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bean.ProdottoBean" %>
<%@ page import="java.util.Map" %>
<% 
    ProdottoBean p = (ProdottoBean) request.getAttribute("prodottoDaModificare"); 
    Map<Integer, String> categorie = (Map<Integer, String>) request.getAttribute("listaCategorie");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= (p != null) ? "Modifica Articolo" : "Nuovo Articolo" %> | Admin</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/admin_prodotto.css">
</head>
<body>

    <%-- <%@include file="header.jsp" %> --%>

    <main class="admin-main-container">
        <div class="form-container">
            <h2 class="admin-title"><%= (p != null) ? "MODIFICA ARTICOLO" : "NUOVO ARTICOLO" %></h2>
            
            <form action="./<%= (p != null) ? "AdminModificaProdotto" : "AdminAggiungiProdotto" %>" method="POST" enctype="multipart/form-data" class="retro-form">
                
                <% if (p != null) { %>
                    <input type="hidden" name="id" value="<%= p.getId() %>">
                    <input type="hidden" name="immagineVecchia" value="<%= p.getImmagine() %>">
                <% } %>

                <div class="input-group">
                    <label>Nome Prodotto:</label>
                    <input type="text" name="nome" value="<%= (p != null) ? p.getNome() : "" %>" required>
                </div>

                <div class="form-row">
                    <div class="input-group half-width">
                        <label>Prezzo (€):</label>
                        <input type="number" step="0.01" name="prezzo" value="<%= (p != null) ? p.getPrezzo() : "" %>" required>
                    </div>

                    <div class="input-group half-width">
                        <label>Quantità Magazzino:</label>
                        <input type="number" name="quantita" value="<%= (p != null) ? p.getQuantita() : "" %>" required>
                    </div>
                </div>

                <div class="input-group">
                    <label>Categoria:</label>
                    <select name="idTipo" required>
                        <option value="" disabled <%= (p == null) ? "selected" : "" %>>Seleziona una categoria...</option>
                        <% if (categorie != null) {
                            for (Map.Entry<Integer, String> entry : categorie.entrySet()) {
                                boolean selected = (p != null && p.getIdTipo() == entry.getKey()); %>
                                <option value="<%= entry.getKey() %>" <%= selected ? "selected" : "" %>><%= entry.getValue() %></option>
                        <%  } 
                        } %>
                    </select>
                </div>

                <div class="input-group">
                    <label>Carica Immagine:</label>
                    <% if (p != null && p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
                        <span class="img-attuale">Attuale: <%= p.getImmagine() %></span>
                    <% } %>
                    <input type="file" name="immagine" class="retro-file-input" accept="image/*" <%= (p == null) ? "required" : "" %>>
                </div>

                <div class="input-group">
                    <label>Descrizione:</label>
                    <textarea name="descrizione" rows="5" required><%= (p != null) ? p.getDescrizione() : "" %></textarea>
                </div>

                <button type="submit" class="btn-submit">SALVA DATI</button>
            </form>
            
            <a href="./AdminDashboard" class="back-link">⬅ TORNA ALLA DASHBOARD</a>
        </div>
    </main>

</body>
</html>