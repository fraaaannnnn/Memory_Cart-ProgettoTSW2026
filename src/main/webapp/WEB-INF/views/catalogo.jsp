<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Catalogo | memory_cart</title>
    <link rel="icon" type="image/x-icon" href="./images/favicon.ico">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Press+Start+2P&display=swap" rel="stylesheet">
    
    <link rel="stylesheet" href="./css/style.css">
    <link rel="stylesheet" href="./css/catalogo.css">
</head>
<body>

    <%@include file="header.jsp"%>
    <main class="shop-container">
        
        <div class="breadcrumb">
            <a href="/Memory_Cart/">Home</a> &gt; <span id="breadcrumb-current">Catalogo</span>
        </div>

        <div class="catalog-layout">
            
            <aside class="catalog-sidebar" id="catalogSidebar">
                <button type="button" id="closeMobileFilters" class="close-filters-btn" aria-label="Chiudi filtri">✕</button>
                
                <form id="filterForm" class="filter-form">
                    
                    <h3 class="filter-title">FILTRA MISSIONI</h3>
                    
                    <div class="filter-group">
					    <h4>Categoria</h4>
					    <label class="filter-checkbox">
					        <input type="checkbox" name="categoria" value="2" id="cb-2">
					        <span class="custom-box"></span> Console Hardware
					    </label>
					    
					    <label class="filter-checkbox">
					        <input type="checkbox" name="categoria" value="1" id="cb-1">
					        <span class="custom-box"></span> Cartucce / Giochi
					    </label>
					    
					    <label class="filter-checkbox">
					        <input type="checkbox" name="categoria" value="3" id="cb-3">
					        <span class="custom-box"></span> Accessori
					    </label>
					</div>
                    <div class="filter-group">
                        <h4>Prezzo Max (€)</h4>
                        <input type="range" min="5" max="300" value="300" name="prezzoMax" class="price-slider" id="priceRange">
                        <div class="price-display">
                            Fino a: € <span id="priceVal">300</span>
                        </div>
                    </div>
                </form>
            </aside>

            <section class="catalog-main">
                
                <div class="catalog-top-bar">
                    <div class="top-bar-left">
                        <button id="filterToggleBtn" class="filter-toggle-btn">⚙ NASCONDI FILTRI</button>
                        <h2 class="page-title-left" id="main-catalog-title">TUTTI I PRODOTTI</h2>
                    </div>
                    
                    <div class="sort-box">
                        <label for="sort">Ordina per:</label>
                        <select id="sort" name="sort" class="retro-select" form="filterForm">
                            <option value="new">Più Recenti</option>
                            <option value="price_asc">Prezzo: Crescente</option>
                            <option value="price_desc">Prezzo: Decrescente</option>
                            <option value="name_asc">Nome: A-Z</option>
                        </select>
                    </div>
                </div>

                <div id="productGrid" class="product-grid catalog-grid">
                    <div style="width: 100%; text-align: center; padding: 50px; color: var(--8bit-teal); font-family: 'Press Start 2P', monospace;">
                        CARICAMENTO DATI IN CORSO...
                    </div>
                </div>
            </section>
        </div>
    </main>

	<%@include file="footer.jsp"%>
    <%@include file="pop_up_carrello.jsp" %>
	<script>
	document.addEventListener('DOMContentLoaded', () => {
        
        const filterForm = document.getElementById('filterForm');
        const productGrid = document.getElementById('productGrid');
        const priceRange = document.getElementById('priceRange');
        const priceVal = document.getElementById('priceVal');
        const sortSelect = document.getElementById('sort');

        const urlParams = new URLSearchParams(window.location.search);
        const initialCategoria = urlParams.get('categoria');

        if (initialCategoria) {
            const targetCheckbox = document.getElementById('cb-' + initialCategoria);
            if (targetCheckbox) {
                targetCheckbox.checked = true;
            }

            const mainTitle = document.getElementById('main-catalog-title');
            const breadcrumb = document.getElementById('breadcrumb-current');
            document.querySelectorAll('#mainNav a').forEach(link => link.classList.remove('active'));

            if (initialCategoria === '2') {
                mainTitle.innerText = 'CONSOLE HARDWARE';
                breadcrumb.innerText = 'Console';
            } else if (initialCategoria === '1') {
                mainTitle.innerText = 'CARTUCCE & GIOCHI';
                breadcrumb.innerText = 'Cartucce';
            }
        }
	
        let paginaCorrente = 1;

        function fetchFilteredProducts() {
            const formData = new FormData(filterForm);
            const searchParams = new URLSearchParams(formData);
            searchParams.append('sort', sortSelect.value);
            
            searchParams.append('page', paginaCorrente);

            productGrid.innerHTML = `<div style="width: 100%; text-align: center; padding: 50px; color: var(--insert-coin-pink); font-size: 0.8rem;">LOADING...</div>`;

            fetch('FiltroCatalogoServlet?' + searchParams.toString(), { method: 'GET' })
            .then(response => {
                if (!response.ok) throw new Error('Errore HTTP: ' + response.status);
                return response.text();
            })
            .then(htmlGeneratoDallaJsp => {
                productGrid.innerHTML = htmlGeneratoDallaJsp; 
            })
            .catch(error => {
                console.error('[DEBUG-AJAX] Errore:', error);
                productGrid.innerHTML = `<div style="width: 100%; text-align: center; padding: 50px; color: #bbb;">Errore di sistema.</div>`;
            });
        }

        
        const resetPageAndFetch = () => {
            paginaCorrente = 1;
            fetchFilteredProducts();
        };

        priceRange.addEventListener('input', (e) => { priceVal.innerText = e.target.value; });
        priceRange.addEventListener('change', resetPageAndFetch);
        filterForm.addEventListener('change', resetPageAndFetch);
        sortSelect.addEventListener('change', resetPageAndFetch);

        productGrid.addEventListener('click', function(e) {
            if (e.target.classList.contains('page-link')) {
                e.preventDefault(); // Evita che la pagina salti in alto
                paginaCorrente = parseInt(e.target.getAttribute('data-page'));
                fetchFilteredProducts();
                
                document.querySelector('.catalog-top-bar').scrollIntoView({ behavior: 'smooth' });
            }
        });

        fetchFilteredProducts();


        const filterToggleBtn = document.getElementById('filterToggleBtn');
        const catalogSidebar = document.getElementById('catalogSidebar');
        const closeMobileFilters = document.getElementById('closeMobileFilters');
        
        if (window.innerWidth <= 992 && filterToggleBtn) {
            filterToggleBtn.innerHTML = '⚙ MOSTRA FILTRI';
            filterToggleBtn.classList.add('closed-state');
        }

        function toggleFilters() {
            if (window.innerWidth <= 992) {
                catalogSidebar.classList.toggle('mobile-open');
                
                if (catalogSidebar.classList.contains('mobile-open')) {
                    filterToggleBtn.innerHTML = '⚙ NASCONDI FILTRI';
                    filterToggleBtn.classList.remove('closed-state');
                } else {
                    filterToggleBtn.innerHTML = '⚙ MOSTRA FILTRI';
                    filterToggleBtn.classList.add('closed-state');
                }
            } else {
                catalogSidebar.classList.toggle('closed');
                
                if (catalogSidebar.classList.contains('closed')) {
                    filterToggleBtn.innerHTML = '⚙ MOSTRA FILTRI';
                    filterToggleBtn.classList.add('closed-state');
                } else {
                    filterToggleBtn.innerHTML = '⚙ NASCONDI FILTRI';
                    filterToggleBtn.classList.remove('closed-state');
                }
            }
        }

        if(filterToggleBtn) filterToggleBtn.addEventListener('click', toggleFilters);
        if(closeMobileFilters) closeMobileFilters.addEventListener('click', toggleFilters);
    });
	</script>
</body>
</html>