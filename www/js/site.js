document.documentElement.classList.add('js');

const header = document.querySelector('[data-header]');
const menu = document.querySelector('[data-menu]');
const menuToggle = document.querySelector('[data-menu-toggle]');
const backdrop = document.querySelector('[data-menu-backdrop]');

document.body.classList.toggle('is-home', Boolean(document.querySelector('.hero')));

// ─── Header scroll effect ────────────────────────────────
const updateHeader = () => header?.classList.toggle('is-scrolled', window.scrollY > 32);
updateHeader();
window.addEventListener('scroll', updateHeader, { passive: true });

// ─── Mobile menu ─────────────────────────────────────────
const openMenu = () => {
    menu?.classList.add('is-open');
    backdrop?.classList.add('is-visible');
    menuToggle?.setAttribute('aria-expanded', 'true');
    document.body.style.overflow = 'hidden';
};

const closeMenu = () => {
    menu?.classList.remove('is-open');
    backdrop?.classList.remove('is-visible');
    menuToggle?.setAttribute('aria-expanded', 'false');
    document.body.style.overflow = '';
};

menuToggle?.addEventListener('click', () => {
    const isOpen = menu?.classList.contains('is-open');
    isOpen ? closeMenu() : openMenu();
});

backdrop?.addEventListener('click', closeMenu);

document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape' && menu?.classList.contains('is-open')) {
        closeMenu();
    }
});

menu?.querySelectorAll('a').forEach((link) => link.addEventListener('click', closeMenu));

// ─── Scroll-triggered reveal animations ──────────────────
const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
        if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.12 });
document.querySelectorAll('.reveal').forEach((element) => observer.observe(element));

// ─── Swiper: Video carousel ──────────────────────────────
if (window.Swiper && document.querySelector('.video-swiper')) {
    new Swiper('.video-swiper', {
        slidesPerView: 1,
        spaceBetween: 16,
        navigation: { nextEl: '.video-next', prevEl: '.video-prev' },
        breakpoints: { 768: { slidesPerView: 2 }, 1200: { slidesPerView: 3 } },
    });
}

// ─── Fancybox: Homepage gallery ─────────────────────────
if (window.Fancybox && document.querySelector('[data-fancybox="homepage-gallery"]')) {
    Fancybox.bind('[data-fancybox="homepage-gallery"]', {
        Thumbs: { autoStart: false },
        Toolbar: { display: ['zoom', 'fullscreen', 'thumbs', 'close'] },
        Images: { zoom: true },
        Carousel: { infinite: true },
    });
}

// ─── Swiper: Reference carousel ──────────────────────────
if (window.Swiper && document.querySelector('.reference-swiper')) {
    new Swiper('.reference-swiper', {
        slidesPerView: 1,
        spaceBetween: 16,
        pagination: { el: '.reference-swiper .swiper-pagination', clickable: true },
        breakpoints: { 768: { slidesPerView: 2 }, 1200: { slidesPerView: 3 } },
    });
}

// ─── Lightbox ────────────────────────────────────────────
const lightbox = document.querySelector('[data-lightbox-dialog]');
if (lightbox) {
    document.querySelectorAll('[data-lightbox]').forEach((item) => item.addEventListener('click', () => {
        const img = lightbox.querySelector('img');
        if (img) img.src = item.dataset.lightbox;
        lightbox.showModal();
        document.body.style.overflow = 'hidden';
    }));

    lightbox.addEventListener('close', () => {
        document.body.style.overflow = '';
    });

    lightbox.addEventListener('click', (e) => {
        if (e.target === lightbox) lightbox.close();
    });

    const closeBtn = document.querySelector('[data-lightbox-close]');
    closeBtn?.addEventListener('click', () => lightbox.close());
}
