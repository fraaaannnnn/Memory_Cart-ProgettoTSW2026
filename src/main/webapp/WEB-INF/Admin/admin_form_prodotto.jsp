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
    <title><%= (p != null) ? "Modifica Articolo" : "Nuovo Articolo" %> | Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Press+Start+2P&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/admin_prodotto.css">
</head>
<body>

<div class="form-container">
    <h2><%= (p != null) ? "MODIFICA ARTICOLO" : "NUOVO ARTICOLO" %></h2>
    
    <form action="./<%= (p != null) ? "AdminModificaProdotto" : "AdminAggiungiProdotto" %>" method="POST" enctype="multipart/form-data">
        
        <% if (p != null) { %>
            <input type="hidden" name="id" value="<%= p.getId() %>">
            <input type="hidden" name="immagineVecchia" value="<%= p.getImmagine() %>">
        <% } %>

        <label>Nome Prodotto:</label>
        <input type="text" name="nome" value="<%= (p != null) ? p.getNome() : "" %>" required>

        <label>Prezzo (€):</label>
        <input type="number" step="0.01" name="prezzo" value="<%= (p != null) ? p.getPrezzo() : "" %>" required>

        <label>Categoria:</label>
        <select name="idTipo" required>
            <% if (categorie != null) {
                for (Map.Entry<Integer, String> entry : categorie.entrySet()) {
                    boolean selected = (p != null && p.getIdTipo() == entry.getKey()); %>
                    <option value="<%= entry.getKey() %>" <%= selected ? "selected" : "" %>><%= entry.getValue() %></option>
            <%  } 
            } %>
        </select>

        <label>Carica Immagine:</label>
        <% if (p != null && p.getImmagine() != null && !p.getImmagine().isEmpty()) { %>
            <span class="img-attuale">Attuale: <%= p.getImmagine() %></span>
        <% } %>
        <input type="file" name="immagine" accept="image/*" <%= (p == null) ? "required" : "" %>>

        <label>Quantità Magazzino:</label>
        <input type="number" name="quantita" value="<%= (p != null) ? p.getQuantita() : "" %>" required>

        <label>Descrizione:</label>
        <textarea name="descrizione" rows="5" required><%= (p != null) ? p.getDescrizione() : "" %></textarea>

        <button type="submit">SALVA DATI</button>
    </form>
    
    <a href="./AdminDashboard" style="display:block; text-align:center; margin-top:20px; font-size: 0.5rem; text-decoration:none; color: #32e0c4;">TORNA INDIETRO</a>
</div>

</body>
</html>