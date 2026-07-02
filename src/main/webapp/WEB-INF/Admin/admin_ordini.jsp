<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.bean.OrdineBean" %>
<%@ page import="java.text.SimpleDateFormat" %>
<% 
    @SuppressWarnings("unchecked")
    List<OrdineBean> ordini = (List<OrdineBean>) request.getAttribute("listaOrdiniAdmin"); 
    
    String fDataInizio = (String) request.getAttribute("filtroDataInizio");
    String fDataFine = (String) request.getAttribute("filtroDataFine");
    String fIdUtente = (String) request.getAttribute("filtroIdUtente");

    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestione Ordini Globali | memory_cart</title>
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
                    <h2 class="admin-title">MONITOR ORDINI GLOBALI</h2>
                    <p class="admin-subtitle">&gt; LOG E FLUSSI DI CASSA DEGLI UTENTI</p>
                </div>
                <div class="dashboard-actions">
                    <a href="./AdminDashboard" class="btn-add-new" style="background-color: transparent; color: var(--8bit-teal); border-color: var(--8bit-teal);">
                        BACK TO PANEL
                    </a>
                </div>
            </div>

            <!-- --- PANNELLO FILTRI --- -->
            <div class="filter-panel">
                <form action="./AdminOrdini" method="GET" class="filter-form">
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label>Da Data:</label>
                            <input type="text" placeholder="dd/mm/yyyy" onfocus="(this.type='date')" onblur="if(!this.value)this.type='text'" name="dataInizio" value="<%= fDataInizio != null ? fDataInizio : "" %>">
                        </div>
                        <div class="filter-group">
                            <label>A Data:</label>
                            <input type="text" placeholder="dd/mm/yyyy" onfocus="(this.type='date')" onblur="if(!this.value)this.type='text'" name="dataFine" value="<%= fDataFine != null ? fDataFine : "" %>">
                        </div>
                        <div class="filter-group">
                            <label>ID Utente Giocatore:</label>
                            <input type="number" name="idUtente" placeholder="Es. 2" value="<%= fIdUtente != null ? fIdUtente : "" %>">
                        </div>
                    </div>
                    <div class="filter-actions-row">
                        <button type="submit" class="btn-filter-submit">APPLICA FILTRO</button>
                        <a href="./AdminOrdini" class="btn-filter-reset">RESET LOG</a>
                    </div>
                </form>
            </div>

            <!-- --- TABELLA DEGLI ORDINI --- -->
            <div class="admin-table-wrapper" style="margin-top: 20px;">
                <table class="retro-table admin-table">
                    <thead>
                        <tr>
                            <th>ID ORDINE</th>
                            <th>ID PLAYER</th>
                            <th>DATA ACQUISTO</th>
                            <th>TOTALE REALE</th>
                            <th>STATO MISSIONE</th>
                            <th class="text-center">AZIONI QUICK</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (ordini != null && !ordini.isEmpty()) { 
                            for (OrdineBean o : ordini) { 
                                String dataFormat = o.getDataOrdine() != null ? sdf.format(o.getDataOrdine()) : "N/D";
                                String totaleFormat = String.format("%.2f", o.getTotaleOrdine()).replace(",", ".");
                                
                                String classeBadge = "processing";
                                String testoStato = "IN CORSO";
                                if (o.getStato() != null) {
                                    switch (o.getStato()) {
                                        case CONSEGNATO: classeBadge = "qty-ok"; testoStato = "COMPLETATA"; break;
                                        case SPEDITO: classeBadge = "qty-ok"; testoStato = "IN VIAGGIO"; break;
                                        case ANNULLATO: classeBadge = "qty-empty"; testoStato = "ANNULLATA"; break;
                                        default: classeBadge = "processing"; testoStato = "IN PREPARAZIONE"; break;
                                    }
                                }
                        %>
                            <tr>
                                <td>#MC-<%= o.getIdOrdine() %></td>
                                <td>#<%= o.getIdUtente() %></td>
                                <td><%= dataFormat %></td>
                                <td class="price-cell">€ <%= totaleFormat %></td>
                                <td>
                                    <span class="<%= classeBadge %>" style="font-size: 0.65rem;"><%= testoStato %></span>
                                </td>
                                <td class="text-center">
                                    <div class="action-buttons-cell" style="justify-content: center; gap: 8px;">
                                        
                                        <% if (o.getStato() == OrdineBean.Stato.IN_PREPARAZIONE) { %>
                                            <!-- FORM SPEDIZIONE -->
                                            <form action="./AdminAggiornaStato" method="POST" id="form-ship-<%= o.getIdOrdine() %>" style="display:inline;">
                                                <input type="hidden" name="idOrdine" value="<%= o.getIdOrdine() %>">
                                                <input type="hidden" name="nuovoStato" value="SPEDITO">
                                                <!-- type="button" e onclick personalizzato -->
                                                <button type="button" class="admin-action-btn btn-ship" title="Segna come Spedito" onclick="openRetroModal('form-ship-<%= o.getIdOrdine() %>', 'Vuoi segnare la missione come SPEDITA?')">✔</button>
                                            </form>
                                            
                                            <!-- FORM ANNULLAMENTO -->
                                            <form action="./AdminAggiornaStato" method="POST" id="form-cancel-<%= o.getIdOrdine() %>" style="display:inline;">
                                                <input type="hidden" name="idOrdine" value="<%= o.getIdOrdine() %>">
                                                <input type="hidden" name="nuovoStato" value="ANNULLATO">
                                                <button type="button" class="admin-action-btn btn-delete" title="Annulla Ordine" onclick="openRetroModal('form-cancel-<%= o.getIdOrdine() %>', 'Sicuro di voler ANNULLARE questa missione?')">✖</button>
                                            </form>
                                            
                                        <% } else if (o.getStato() == OrdineBean.Stato.SPEDITO) { %>
                                            <!-- FORM CONSEGNA -->
                                            <form action="./AdminAggiornaStato" method="POST" id="form-deliver-<%= o.getIdOrdine() %>" style="display:inline;">
                                                <input type="hidden" name="idOrdine" value="<%= o.getIdOrdine() %>">
                                                <input type="hidden" name="nuovoStato" value="CONSEGNATO">
                                                <button type="button" class="admin-action-btn btn-deliver" title="Segna come Consegnato" onclick="openRetroModal('form-deliver-<%= o.getIdOrdine() %>', 'La merce è stata CONSEGNATA al giocatore?')">🏁</button>
                                            </form>
                                        <% } %>

                                        <a href="Fattura?id=<%= o.getIdOrdine() %>" target="_blank" class="admin-action-btn btn-edit" style="text-decoration:none; display: inline-flex; align-items: center; justify-content: center;">
                                            WEB
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="6" class="empty-db-msg">
                                    NESSUN LOG DI VENDITA CORRISPONDE AI FILTRI SELEZIONATI.
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
            <h3 class="retro-modal-title">SYSTEM PROMPT</h3>
            <p class="retro-modal-text" id="retro-modal-message">Sei sicuro?</p> 
            <div class="retro-modal-actions">
                <button type="button" class="btn-modal-cancel" onclick="closeRetroModal()">ANNULLA</button>
                <button type="button" class="btn-modal-confirm" onclick="confirmRetroAction()">CONFERMA</button>
            </div>
        </div>
    </div>

    <script src="./js/admin_ordine.js"> </script>
</body>
</html>