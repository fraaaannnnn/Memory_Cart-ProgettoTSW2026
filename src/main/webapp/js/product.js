document.addEventListener("DOMContentLoaded", function() {
    const mostraBtn = document.getElementById("mostra-form-btn");
    const inviaBtn = document.getElementById("invia-recensione-btn");
    const formDiv = document.querySelector(".add-review-form");
    
    if (mostraBtn && inviaBtn && formDiv) {
        mostraBtn.addEventListener("click", function() {
            
            const isHidden = formDiv.classList.contains("hidden-item");
            
            if (isHidden) {
                formDiv.classList.remove("hidden-item");
                inviaBtn.classList.remove("hidden-item");
                
                mostraBtn.textContent = "Annulla";
                mostraBtn.classList.remove("active");
                
            } else {
                formDiv.classList.add("hidden-item");
                inviaBtn.classList.add("hidden-item");
                
                mostraBtn.textContent = "Aggiungi Recensione";
                mostraBtn.classList.add("active");
            }
        });
    }
});
function openTab(tabName) {
            var i, tabcontent, tablinks;
            tabcontent = document.getElementsByClassName("tab-content");
            for (i = 0; i < tabcontent.length; i++) {
                tabcontent[i].style.display = "none";
                tabcontent[i].classList.remove("active");
            }
            tablinks = document.getElementsByClassName("tab-btn");
            for (i = 0; i < tablinks.length; i++) {
                tablinks[i].classList.remove("active");
            }
            document.getElementById(tabName).style.display = "block";
            event.currentTarget.classList.add("active");
        }