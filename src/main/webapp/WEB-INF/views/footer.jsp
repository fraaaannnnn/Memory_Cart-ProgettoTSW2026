<%@ page import="java.util.Calendar" %>
    <footer>
        <% int year = Calendar.getInstance().get(Calendar.YEAR); %>
        <p style="font-family: 'Press Start 2P', monospace; color: var(--8bit-teal); font-size: 0.7rem;">&copy; <%= year %> MEMORY_CART - PRESS X TO START</p>
    </footer>