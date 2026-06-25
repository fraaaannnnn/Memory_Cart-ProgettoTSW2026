
document.addEventListener("DOMContentLoaded", () => {
    

    const track = document.getElementById('carouselTrack');
    const slides = document.querySelectorAll('.carousel-slide');
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    
    if (track && slides.length > 0) {
        let slideIndex = 0;
        let slideTimer;

        function updateSlidePosition() {
            const amountToMove = slideIndex * -100;
            track.style.transform = 'translateX(' + amountToMove + '%)';
        }

        function moveSlide(n) {
            slideIndex += n;
            
            if (slideIndex >= slides.length) {
                slideIndex = 0;
            } else if (slideIndex < 0) {
                slideIndex = slides.length - 1;
            }
            
            updateSlidePosition();
        }

        function startTimer() {
            slideTimer = setInterval(function() {
                moveSlide(1);
            }, 4000);
        }

        function manualMove(n) {
            moveSlide(n);
            clearInterval(slideTimer); 
            startTimer();              
        }

        if (prevBtn && nextBtn) {
            prevBtn.addEventListener('click', () => manualMove(-1));
            nextBtn.addEventListener('click', () => manualMove(1));
        }

        startTimer();
    }
});