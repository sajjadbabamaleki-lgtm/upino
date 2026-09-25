/* Upino site: the shared bits for pages other than the homepage
   (the nav, the footer name, the year). */
(() => {
  "use strict";
  const $ = (s, r = document) => r.querySelector(s);

  const nav = $("#nav");
  const menuBtn = $("#menuBtn");
  const menu = $("#mobileMenu");
  if (nav) {
    const setCompact = () => nav.classList.toggle("is-compact", window.scrollY > 40);
    setCompact();
    window.addEventListener("scroll", setCompact, { passive: true });
  }
  if (nav && menuBtn && menu) {
    const closeMenu = () => {
      menu.hidden = true; menuBtn.setAttribute("aria-expanded", "false");
      menuBtn.setAttribute("aria-label", "Open menu"); nav.classList.remove("is-open");
    };
    menuBtn.addEventListener("click", () => {
      const open = menu.hidden;
      menu.hidden = !open;
      menuBtn.setAttribute("aria-expanded", String(open));
      menuBtn.setAttribute("aria-label", open ? "Close menu" : "Open menu");
      nav.classList.toggle("is-open", open);
    });
    menu.querySelectorAll("a").forEach((a) => a.addEventListener("click", closeMenu));
    document.addEventListener("keydown", (e) => { if (e.key === "Escape" && !menu.hidden) { closeMenu(); menuBtn.focus(); } });
  }

  // the footer name, set exactly as wide as the page
  const box = $("#footerWord");
  const word = box && box.firstElementChild;
  if (word) {
    const fit = () => {
      box.style.fontSize = "100px";
      const w = word.getBoundingClientRect().width;
      if (w) box.style.fontSize = (100 * box.clientWidth / w).toFixed(2) + "px";
    };
    fit();
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(fit);
    window.addEventListener("resize", fit, { passive: true });
  }

  const yr = $("#year");
  if (yr) yr.textContent = String(new Date().getFullYear());
})();
