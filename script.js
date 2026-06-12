const body = document.body;
const currentPage = body.dataset.page;
const glow = document.querySelector(".cursor-glow");
const nav = document.querySelector(".site-nav");
const toggle = document.querySelector(".nav-toggle");

document.querySelectorAll("[data-route]").forEach((link) => {
  if (link.dataset.route === currentPage) {
    link.classList.add("active");
  }
});

toggle?.addEventListener("click", () => {
  const isOpen = nav.classList.toggle("open");
  toggle.setAttribute("aria-expanded", String(isOpen));
});

document.addEventListener("pointermove", (event) => {
  if (!glow) return;
  glow.style.left = `${event.clientX}px`;
  glow.style.top = `${event.clientY}px`;
});

const observer = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("visible");
        observer.unobserve(entry.target);
      }
    });
  },
  { threshold: 0.16 }
);

document.querySelectorAll(".reveal").forEach((element) => observer.observe(element));
