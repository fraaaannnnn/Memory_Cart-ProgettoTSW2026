<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Header</title>
</head>
<body>
	<header>
        <a href="/Memory_Cart/"><h1>memory_cart</h1></a>
        
        <button class="hamburger" id="hamburgerBtn" aria-label="Toggle Menu">
            <span></span>
            <span></span>
            <span></span>
        </button>

        <nav id="mainNav">
            <ul>
                <li><a href="#">Console</a></li>
                <li><a href="#">Cartucce</a></li>
                <li><a href="#">Arcade Club</a></li>
                
                <li class="mobile-action"><a href="#">Preferiti</a></li>
                <li class="mobile-action"><a href="#">Carrello</a></li>
                
                <li class="mobile-login">
                    <a href="/Memory_Cart/Login" class="btn-primary" style="padding: 10px 20px; font-size: 0.8rem;">LOGIN</a>
                </li>
            </ul>
        </nav>
        
        <div class="desktop-actions">
    		<a href="#" class="action-icon" title="Preferiti">
        		<img src="./images/whishlist.png" alt="Preferiti" class="nav-icon">
    		</a>
    
    		<a href="#" class="action-icon" title="Carrello">
        		<img src="./images/cart.png" alt="Carrello" class="nav-icon">
        		<span class="cart-badge">0</span>
    		</a>
    
    		<a href="/Memory_Cart/Login" class="btn-primary desktop-login" style="padding: 8px 16px; font-size: 0.7rem;">LOGIN</a>
		</div>
    </header>
</body>
</html>