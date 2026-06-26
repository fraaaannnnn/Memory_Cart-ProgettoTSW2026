document.addEventListener("DOMContentLoaded", function() {
            var pop_up = document.getElementById('retro-pop_up');
            if(pop_up) {
                setTimeout(function() {
                    pop_up.classList.add('show');
                }, 100);

                setTimeout(function() {
                    pop_up.classList.remove('show');
                    setTimeout(function() {
                        pop_up.remove();
                    }, 400); 
                }, 3500);
            }
        });