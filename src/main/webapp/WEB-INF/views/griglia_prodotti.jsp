<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bean.ProdottoBean" %>

<%
    List<ProdottoBean> listaProdotti = (List<ProdottoBean>) request.getAttribute("prodotti");

    if (listaProdotti == null || listaProdotti.isEmpty()) {
%>
        <div style="width: 100%; text-align: center; padding: 50px; color: #bbb; font-family: 'Press Start 2p', monospace; grid-column: 1 / -1;">
            Nessun prodotto trovato per i filtri selezionati. Prova a modificare la ricerca!
        </div>
<%
    } else {
        for (ProdottoBean prodotto : listaProdotti) {
            String prezzoFormat = String.format("%.2f", prodotto.getPrezzo()).replace(",", ".");
            String[] prezzoSplit = prezzoFormat.split("\\.");
            String whole = prezzoSplit[0];
            String fraction = prezzoSplit.length > 1 ? prezzoSplit[1] : "00";
%>
            <div class="product-card">
                <div class="product-image">
                    <img src="<%= request.getContextPath() %>/<%= prodotto.getImmagine() %>" alt="<%= prodotto.getNome() %>">
                </div>
                <div class="product-info">
                    <a href="Prodotto?id=<%= prodotto.getId() %>" class="product-title"><%= prodotto.getNome() %></a>
                    
                    <div class="product-rating">
                        <% if(prodotto.getNumeroRecensioni() > 0) { %>
                            <span class="stars" style="color: #ffcc00;">⭐ <%= String.format("%.1f", prodotto.getMediaStelle()) %></span>
                            <span class="rating-count">(<%= prodotto.getNumeroRecensioni() %>)</span>
                        <% } else { %>
                            <span class="rating-count" style="font-style: italic;">Nuovo arrivo</span>
                        <% } %>
                    </div>  
                    
                    <div class="product-price">
                    <%if(prodotto.getQuantita() > 0) {
                    	%>
                        <span class="currency">€</span><span class="whole"><%= whole %></span><span class="fraction"><%= fraction %></span>
                    <%} else {
                    	%>
                        <span class="currency"></span><span class="whole">SOLD OUT</span>
                    <%} %>
                    </div>
                    <form action="Carrello" method="post" class="product-form">
                        <input type="hidden" name="idProdotto" value="<%= prodotto.getId() %>">
                        <input type="hidden" name="quantita" value="1">
                    <%if(prodotto.getQuantita() > 0 ) { %>
                        <button type="submit" class="btn-cart">AGGIUNGI AL CARRELLO</button>                    
                    <%} else { %>
                    	<button type="submit" class="btn-cart" disabled>AGGIUNGI AL CARRELLO</button>                    
                    <% } %>
                    </form>
                </div>
            </div>
<%
        }
        // Recuperiamo le informazioni sulla paginazione dalla Servlet
        Integer paginaCorrente = (Integer) request.getAttribute("paginaCorrente");
        Integer totalePagine = (Integer) request.getAttribute("totalePagine");

        if (totalePagine != null && totalePagine > 1) {
    %>
        <div class="pagination" style="width: 100%; grid-column: 1 / -1; display: flex; justify-content: center; margin-top: 40px;">
            <% if (paginaCorrente > 1) { %>
                <a href="#" class="page-link" data-page="<%= paginaCorrente - 1 %>">&lt;</a>
            <% } %>

            <% for (int i = 1; i <= totalePagine; i++) { %>
                <a href="#" class="page-link <%= (i == paginaCorrente) ? "active" : "" %>" data-page="<%= i %>"><%= i %></a>
            <% } %>

            <% if (paginaCorrente < totalePagine) { %>
                <a href="#" class="page-link" data-page="<%= paginaCorrente + 1 %>">&gt;</a>
            <% } %>
        </div>
    <%
        }
    } 
%>