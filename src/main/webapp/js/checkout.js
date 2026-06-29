document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('.checkout-form-wrapper');

        form.addEventListener('submit', function(e) {
            let isValid = true;
            
            // 1. Controllo base: nessun campo required deve essere vuoto
            const requiredInputs = form.querySelectorAll('input[required]');
            requiredInputs.forEach(function(input) {
                if (input.value.trim() === '') {
                    triggerError(input);
                    isValid = false;
                }
            });

            // 2. Controllo Metodo di Pagamento
            const metodoPagamento = document.querySelector('input[name="pagamento"]:checked').value;
            
            if (metodoPagamento === 'carta') {
                const inputCarta = document.getElementById('numero_carta');
                const inputScadenza = document.getElementById('scadenza');
                const inputCvv = document.getElementById('cvv');

                // Puliamo gli spazi dal numero inserito dall'utente
                const numeroPulito = inputCarta.value.replace(/\s+/g, '');

                // REGEX CARTA: Esattamente 16 cifre numeriche (da 0 a 9)
                const regexCarta = /^[0-9]{16}$/;
                if (!regexCarta.test(numeroPulito)) {
                    triggerError(inputCarta);
                    isValid = false;
                }

                // REGEX SCADENZA: Mese da 01 a 12, barra (/), e 2 cifre per l'anno
                const regexScadenza = /^(0[1-9]|1[0-2])\/([0-9]{2})$/;
                if (!regexScadenza.test(inputScadenza.value)) {
                    triggerError(inputScadenza);
                    isValid = false;
                }

                // REGEX CVV: Esattamente 3 cifre numeriche
                const regexCvv = /^[0-9]{3}$/;
                if (!regexCvv.test(inputCvv.value)) {
                    triggerError(inputCvv);
                    isValid = false;
                }
            }
            
            // Se almeno un controllo è fallito, blocca l'invio del form
            if (!isValid) {
                e.preventDefault();
            }
        });

        // Funzione per l'effetto tremolio (stile Arcade Error)
        function triggerError(inputElement) {
            inputElement.classList.add('error-shake');
            
            // Rimuove la classe dopo l'animazione per permettere di ripeterla
            setTimeout(function() {
                inputElement.classList.remove('error-shake');
            }, 400);
        }
    });