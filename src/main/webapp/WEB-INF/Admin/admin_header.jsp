<%@ page import="com.bean.UtenteBean" %>
<%
    boolean isLoggato = (session != null && session.getAttribute("utenteLoggato") != null);
%>

<header class="admin-header">
    <a href=""><h1>memory_cart <span style="font-size: 0.5em; color: #ff4757;">ADMIN</span></h1></a>
    
    <button class="hamburger" id="hamburgerBtn" aria-label="Toggle Menu">
        <span></span>
        <span></span>
        <span></span>
    </button>

    <nav id="mainNav">
        <ul>
            <li><a href="/Memory_Cart/AdminDashboard">Prodotti</a></li>
            <li><a href="/Memory_Cart/AdminOrdini">Ordini</a></li>
            
            <% if(!isLoggato) { %>
                <li class="mobile-login"><a href="/Memory_Cart/Login">Login</a></li>
            <% } else { %>
                <li class="mobile-login"><a href="/Memory_Cart/LogOut" id="logout-btn">Logout</a></li>
            <% } %>
        </ul>
    </nav>
    
    <div class="desktop-actions">
        <% if(!isLoggato) { %>
            <a href="/Memory_Cart/Login" class="btn-primary desktop-login" style="padding: 8px 16px; font-size: 0.7rem;">LOGIN</a>
        <% } else { %>
            <div class="user-dropdown-container desktop-login">
                <img src="/Memory_Cart/images/user/utente_propic.png" class="user_img_img" alt="Profilo Admin" id="userProfileBtn" style="cursor: pointer;">
                
                <div class="user-dropdown-menu" id="userDropdown">
                    <a href="/Memory_Cart/LogOut">Logout</a>
                </div>
            </div>
        <% } %>
    </div>
    
    <script src="/Memory_Cart/js/header.js" defer></script>
</header>