document.addEventListener('DOMContentLoaded', function() {
        const form = document.querySelector('.checkout-form-wrapper');

        form.addEventListener('submit', function(e) {
            let isValid = true;
            
            const requiredInputs = form.querySelectorAll('input[required]');
            requiredInputs.forEach(function(input) {
                if (input.value.trim() === '') {
                    triggerError(input);
                    isValid = false;
                }
            });

            const metodoPagamento = document.querySelector('input[name="pagamento"]:checked').value;
            
            if (metodoPagamento === 'carta') {
                const inputCarta = document.getElementById('numero_carta');
                const inputScadenza = document.getElementById('scadenza');
                const inputCvv = document.getElementById('cvv');

                const numeroPulito = inputCarta.value.replace(/\s+/g, '');

                const regexCarta = /^[0-9]{16}$/;
                if (!regexCarta.test(numeroPulito)) {
                    triggerError(inputCarta);
                    isValid = false;
                }

                const regexScadenza = /^(0[1-9]|1[0-2])\/([0-9]{2})$/;
                if (!regexScadenza.test(inputScadenza.value)) {
                    triggerError(inputScadenza);
                    isValid = false;
                }

                const regexCvv = /^[0-9]{3}$/;
                if (!regexCvv.test(inputCvv.value)) {
                    triggerError(inputCvv);
                    isValid = false;
                }
            }
            
            if (!isValid) {
                e.preventDefault();
            }
        });

        function triggerError(inputElement) {
            inputElement.classList.add('error-shake');
            
            setTimeout(function() {
                inputElement.classList.remove('error-shake');
            }, 400);
        }
    });