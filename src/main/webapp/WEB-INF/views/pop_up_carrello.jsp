<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String messaggio = (String) session.getAttribute("pop_up_carrello");
    
    if (messaggio != null) {
%>	
    <link rel="stylesheet" href="./css/pop_up_carrello.css">
    <div id="retro-pop_up" class="retro-pop_up">
        <span>🎮 <%= messaggio %></span>
    </div>
    <script src="./js/pop_up_carrello.js"></script>
<%
        session.removeAttribute("pop_up_carrello"); 
    }
%>