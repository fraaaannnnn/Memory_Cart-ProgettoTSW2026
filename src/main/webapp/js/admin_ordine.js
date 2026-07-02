 let formToSubmit = null; 

        function openRetroModal(formId, message) {
            formToSubmit = document.getElementById(formId); 
            document.getElementById('retro-modal-message').innerText = message;
            document.getElementById('retro-alert-modal').style.display = 'flex'; 
        }

        function closeRetroModal() {
            formToSubmit = null; 
            document.getElementById('retro-alert-modal').style.display = 'none';
        }

        function confirmRetroAction() {
            if (formToSubmit) {
                formToSubmit.submit(); 
            }
        }