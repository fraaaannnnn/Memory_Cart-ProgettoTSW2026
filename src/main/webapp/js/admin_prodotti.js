let formToSubmit = null; 

        function openRetroModal(formId) {
            formToSubmit = document.getElementById(formId); 
            document.getElementById('retro-alert-modal').style.display = 'flex'; 
        }

        function closeRetroModal() {
            formToSubmit = null;
            document.getElementById('retro-alert-modal').style.display = 'none';
        }

        function confirmRetroDelete() {
            if (formToSubmit) {
                formToSubmit.submit(); 
            }
        }