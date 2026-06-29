<%@ page import="java.util.Map" %>
<%@ page import="com.bean.UtenteBean" %>
<%@ page import="com.bean.ProdottoBean" %>
<%@ page import="com.dao.CarrelloDAO" %>
<%@ page import="com.dao.ProdottoDAO" %>
<%
    int badgeCount = 0;
    UtenteBean utenteBadge = (UtenteBean) session.getAttribute("utenteLoggato");

    // Inizializziamo i DAO
    CarrelloDAO badgeDao = new CarrelloDAO();
    ProdottoDAO badgeProdottoDao = new ProdottoDAO();
    
    Map<Integer, Integer> carrelloDaContare = null;

    if (utenteBadge != null) {
        carrelloDaContare = badgeDao.getCarrelloUtente(utenteBadge.getId());
    } else {
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> carrelloSessione = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
        carrelloDaContare = carrelloSessione;
    }

    // Se c'è un carrello, contiamo i pezzi rispettando i limiti reali
    if (carrelloDaContare != null) {
        for (Map.Entry<Integer, Integer> entry : carrelloDaContare.entrySet()) {
            int idProdotto = entry.getKey();
            int quantitaNelDB = entry.getValue();
            
            ProdottoBean p = badgeProdottoDao.prodottoDaId(idProdotto);
            
            if (p != null) {
                // Il FIX: Se la quantità nel DB supera le scorte reali, conta solo le scorte
                if (quantitaNelDB > p.getQuantita()) {
                    badgeCount += p.getQuantita();
                } else {
                    badgeCount += quantitaNelDB;
                }
            }
        }
    }
    
    boolean isLoggato = (session != null && session.getAttribute("utenteLoggato") != null);
%>

<header>
    <a href="/Memory_Cart/"><h1>memory_cart</h1></a>
    
    <button class="hamburger" id="hamburgerBtn" aria-label="Toggle Menu">
        <span></span>
        <span></span>
        <span></span>
    </button>

    <nav id="mainNav">
        <ul>
            <li><a href="/Memory_Cart/Catalogo">Catalogo</a></li>
            <li><a href="/Memory_Cart/Catalogo?categoria=2">Console</a></li>
            <li><a href="/Memory_Cart/Catalogo?categoria=1">Giochi</a></li>
            
            <li class="mobile-action"><a href="/Memory_Cart/Preferiti">Preferiti</a></li>
            <li class="mobile-action"><a href="/Memory_Cart/Carrello">Carrello</a></li>
            
            <% if(!isLoggato) { %>
                <li class="mobile-login"><a href="/Memory_Cart/Login">Login</a></li>
            <% } else { %>
                <li class="mobile-login"><a href="Profilo">Profilo</a></li>
                <li class="mobile-login"><a href="/Memory_Cart/LogOut" id="logout-btn">Logout</a></li>
            <% } %>
        </ul>
    </nav>
    
    <div class="desktop-actions">
        <a href="/Memory_Cart/Preferiti" class="action-icon" title="Preferiti">
            <img src="/Memory_Cart/images/whishlist.png" alt="Preferiti" class="nav-icon">
        </a>

        <a href="/Memory_Cart/Carrello" class="action-icon" title="Carrello">
            <img src="/Memory_Cart/images/cart.png" alt="Carrello" class="nav-icon">
            <span class="cart-badge"><%=badgeCount %></span>
        </a>
        
        <% if(!isLoggato) { %>
            <a href="/Memory_Cart/Login" class="btn-primary desktop-login" style="padding: 8px 16px; font-size: 0.7rem;">LOGIN</a>
        <% } else { %>
            <div class="user-dropdown-container desktop-login">
                <img src="/Memory_Cart/images/user/utente_propic.png" class="user_img_img" alt="Profilo" id="userProfileBtn" style="cursor: pointer;">
                
                <div class="user-dropdown-menu" id="userDropdown">
                    <a href="/Memory_Cart/Profilo">Profilo</a>
                    <a href="/Memory_Cart/LogOut">Logout</a>
                </div>
            </div>
        <% } %>
    </div>
    
    <script src="/Memory_Cart/js/header.js" defer></script>
</header>