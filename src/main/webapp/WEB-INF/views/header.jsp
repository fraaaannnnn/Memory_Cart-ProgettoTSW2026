<%@ page import="java.util.Map" %>
<%@ page import="com.bean.UtenteBean" %>
<%@ page import="com.dao.CarrelloDAO" %>
<%
    int badgeCount = 0;
    UtenteBean utenteBadge = (UtenteBean) session.getAttribute("utenteLoggato");

    if (utenteBadge != null) {
        CarrelloDAO badgeDao = new CarrelloDAO();
        Map<Integer, Integer> carrelloDB = badgeDao.getCarrelloUtente(utenteBadge.getId());
        if (carrelloDB != null) {
            for (int qty : carrelloDB.values()) {
                badgeCount += qty;
            }
        }
    } else {
        @SuppressWarnings("unchecked")
        Map<Integer, Integer> carrelloSessione = (Map<Integer, Integer>) session.getAttribute("carrelloOspite");
        if (carrelloSessione != null) {
            for (int qty : carrelloSessione.values()) {
                badgeCount += qty;
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
            <li><a href="/Memory_Cart/Console">Catalogo</a></li>
            <li><a href="/Memory_Cart/Arcade">Console</a></li>
            <li><a href="/Memory_Cart/Cartucce">Giochi</a></li>
            
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