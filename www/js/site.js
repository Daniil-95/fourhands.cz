document.documentElement.classList.add('js');

const header = document.querySelector('[data-header]');
const menu = document.querySelector('[data-menu]');
const menuToggle = document.querySelector('[data-menu-toggle]');

document.body.classList.toggle('is-home', Boolean(document.querySelector('.hero')));

const updateHeader = () => header?.classList.toggle('is-scrolled', window.scrollY > 32);
updateHeader();
window.addEventListener('scroll', updateHeader, { passive: true });

menuToggle?.addEventListener('click', () => {
    const open = menu?.classList.toggle('is-open');
    menuToggle.setAttribute('aria-expanded', String(Boolean(open)));
});
menu?.querySelectorAll('a').forEach((link) => link.addEventListener('click', () => {
    menu.classList.remove('is-open');
    menuToggle?.setAttribute('aria-expanded', 'false');
}));

const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
        if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.12 });
document.querySelectorAll('.reveal').forEach((element) => observer.observe(element));

if (window.Swiper && document.querySelector('.video-swiper')) {
    new Swiper('.video-swiper', {
        slidesPerView: 1,
        spaceBetween: 16,
        navigation: { nextEl: '.video-next', prevEl: '.video-prev' },
        breakpoints: { 768: { slidesPerView: 2 }, 1200: { slidesPerView: 3 } },
    });
}
if (window.Swiper && document.querySelector('.reference-swiper')) {
    new Swiper('.reference-swiper', {
        slidesPerView: 1,
        spaceBetween: 16,
        pagination: { el: '.reference-swiper .swiper-pagination', clickable: true },
        breakpoints: { 768: { slidesPerView: 2 }, 1200: { slidesPerView: 3 } },
    });
}

const lightbox = document.querySelector('[data-lightbox-dialog]');
document.querySelectorAll('[data-lightbox]').forEach((item) => item.addEventListener('click', () => {
    lightbox.querySelector('img').src = item.dataset.lightbox;
    lightbox.showModal();
}));
document.querySelector('[data-lightbox-close]')?.addEventListener('click', () => lightbox.close());
