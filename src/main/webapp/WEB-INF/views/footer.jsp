<%@ page import="java.util.Calendar" %>
    <footer>
        <% int year = Calendar.getInstance().get(Calendar.YEAR); %>
        <p style="font-family: 'Press Start 2P', monospace; color: var(--8bit-teal); font-size: 0.7rem;">&copy; <%= year %> MEMORY_CART - PRESS X TO START</p>
    </footer>
   <script>
// Portiamo la funzione FUORI, così è globale e chiunque può usarla!
function showRetroToast(title, message, isError = false) {
    let container = document.getElementById('toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'toast-container';
        container.className = 'toast-container';
        document.body.appendChild(container);
    }

    const toast = document.createElement('div');
    toast.className = 'retro-toast ' + (isError ? 'toast-error' : 'toast-success');
    
    toast.innerHTML = 
        '<div class="toast-header-bar">' + title + '</div>' +
        '<div class="toast-body-text">' + message + '</div>';

    container.appendChild(toast);

    setTimeout(() => {
        toast.style.animation = 'toastFadeOut 0.5s ease forwards';
        setTimeout(() => { toast.remove(); }, 500);
    }, 4000);
}

document.addEventListener('DOMContentLoaded', () => {
    // Il nostro vecchio amico AJAX per l'aggiunta al carrello rapida
    document.addEventListener('submit', function(e) {
        if (e.target && e.target.tagName === 'FORM') {
            const form = e.target;
            let actionAttr = form.getAttribute('action');
            
            if (e.submitter && e.submitter.hasAttribute('formaction')) {
                actionAttr = e.submitter.getAttribute('formaction');
            }
            
            if (window.location.pathname.toLowerCase().includes('carrello')) return; 
            
            if (actionAttr && actionAttr.includes('Carrello') && !actionAttr.includes('SpostaNelCarrello')) {
                e.preventDefault(); 
                const formData = new URLSearchParams(new FormData(form));
                
                fetch(actionAttr, {
                    method: 'POST',
                    headers: { 'Accept': 'application/json', 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: formData.toString()
                })
                .then(response => {
                    if(!response.ok) throw new Error('Errore di rete');
                    return response.text(); 
                })
                .then(rawText => {
                    const data = JSON.parse(rawText);
                    if (data.success) {
                        showRetroToast("INVENTARIO AGGIORNATO", "Item inserito nel carrello con successo!");
                        const badge = document.querySelector('.cart-badge'); 
                        if (badge) {
                            let quantitaAggiunta = parseInt(formData.get('quantita')) || 1;
                            let contoAttuale = parseInt(badge.innerText) || 0;
                            badge.innerText = contoAttuale + quantitaAggiunta;
                            badge.style.display = 'inline-block';
                        }
                    } else {
                        showRetroToast("MISSION FAILED", "Impossibile aggiornare il carrello.", true);
                    }
                })
                .catch(error => {
                    showRetroToast("SYSTEM ERROR", "Connessione ai server interrotta.", true);
                });
            }
        }
    });
});
</script>

<%
    String toastTitle = (String) session.getAttribute("toastTitle");
    String toastMessage = (String) session.getAttribute("toastMessage");
    Boolean toastError = (Boolean) session.getAttribute("toastError");

    if (toastMessage != null) {
        session.removeAttribute("toastTitle");
        session.removeAttribute("toastMessage");
        session.removeAttribute("toastError");
        
        boolean isError = (toastError != null && toastError);
%>
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            showRetroToast("<%= toastTitle %>", "<%= toastMessage %>", <%= isError %>);
        });
    </script>
<%
    }
%>