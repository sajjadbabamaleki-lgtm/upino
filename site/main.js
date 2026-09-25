/* Upino site — interactions.
   Every demo draws from the one small model below, so the numbers on the
   page agree with each other. GSAP runs the scroll-linked and multi-step
   sequences; everything still works (without motion) if it fails to load
   or the visitor prefers reduced motion. */
(() => {
  "use strict";

  const $ = (s, r = document) => r.querySelector(s);
  const $$ = (s, r = document) => Array.from(r.querySelectorAll(s));
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const G = window.gsap;
  const ST = window.ScrollTrigger;
  if (G && ST) G.registerPlugin(ST);
  const animate = !!G && !reduce;

  const eur = (n) => "€" + Math.round(n).toLocaleString("en-US");
  const NS = "http://www.w3.org/2000/svg";
  const el = (tag, attrs = {}, parent) => {
    const n = document.createElementNS(NS, tag);
    for (const k in attrs) n.setAttribute(k, attrs[k]);
    if (parent) parent.appendChild(n);
    return n;
  };

  /** Tween a number shown in [node], or set it at once without motion. */
  function countTo(node, from, to, dur = 0.6) {
    if (!animate) { node.textContent = eur(to); return; }
    const o = { v: from };
    G.to(o, { v: to, duration: dur, ease: "power3.out", overwrite: true,
      onUpdate: () => { node.textContent = eur(o.v); } });
  }

  const onEnter = (target, fn) => {
    if (!target) return;
    if (!("IntersectionObserver" in window)) { fn(); return; }
    const io = new IntersectionObserver((es) => {
      if (es.some((e) => e.isIntersecting)) { io.disconnect(); fn(); }
    }, { threshold: 0.35 });
    io.observe(target);
  };

  /* ── the model ─────────────────────────────────────────────────────
     Day 0 is Oct 15. Income lands on the 25th. Safe to Spend falls as
     planned money is used and resets at each income; bills never touch it
     because their money was set aside already. */
  const DAY0 = new Date(2026, 9, 15);
  const PAYS = [-20, 10, 41];
  const dateOf = (d) => new Date(DAY0.getFullYear(), DAY0.getMonth(), DAY0.getDate() + d);
  const fmtDate = (d) => dateOf(d).toLocaleDateString("en-US", { month: "short", day: "numeric" });

  function baseline(d) {
    let v;
    if (d < -20) v = 1150 - 70 * (d + 30);
    else if (d < 10) v = 2550 - 70 * (d + 20);
    else if (d < 41) v = 2540 - 64 * (d - 10);
    else v = 2560 - 64 * (d - 41);
    if (d < 0) v += Math.sin(d * 1.7) * 38 + Math.sin(d * 0.53) * 26; // the past was lived, not planned
    return v;
  }
  /** Buying the €700 laptop today: the rest of this period shrinks. */
  function buyNow(d) {
    if (d >= 0 && d < 10) return 450 - 43 * d;
    return baseline(d);
  }
  /** Waiting: the laptop comes out of the next period instead. */
  function waitPay(d) {
    if (d >= 10 && d < 41) return 1840 - 41 * (d - 10);
    return baseline(d);
  }

  const EVENTS = [
    { d: -20, kind: "income", text: "Income €5,400" },
    { d: -20, kind: "goal", text: "€180 to Travel" },
    { d: -14, kind: "bill", text: "Rent €1,100, protected" },
    { d: -8, kind: "bill", text: "Phone €24, protected" },
    { d: 6, kind: "bill", text: "Subscriptions €18, protected" },
    { d: 10, kind: "income", text: "Income €5,400" },
    { d: 10, kind: "goal", text: "€180 to Travel" },
    { d: 10, kind: "annual", text: "Car tax fund €140" },
    { d: 13, kind: "bill", text: "Insurance €184, protected" },
    { d: 17, kind: "bill", text: "Rent €1,100, protected" },
    { d: 21, kind: "bill", text: "Card instalment €188, protected" },
    { d: 41, kind: "income", text: "Income €5,400" },
    { d: 41, kind: "goal", text: "€180 to Travel" },
    { d: 47, kind: "bill", text: "Rent €1,100, protected" },
    { d: 60, kind: "annual", text: "Car insurance €410, fully set aside" },
  ];

  /* ── nav ─────────────────────────────────────────────────────────── */
  const nav = $("#nav");
  const menuBtn = $("#menuBtn");
  const menu = $("#mobileMenu");
  const setCompact = () => nav.classList.toggle("is-compact", window.scrollY > 40);
  setCompact();
  window.addEventListener("scroll", setCompact, { passive: true });
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
  $$("#mobileMenu a").forEach((a) => a.addEventListener("click", closeMenu));
  document.addEventListener("keydown", (e) => { if (e.key === "Escape" && !menu.hidden) { closeMenu(); menuBtn.focus(); } });

  /* ── hero: the number arrives, then what it depends on ───────────── */
  if (animate) {
    const fig = $("#heroFigure");
    const tl = G.timeline({ defaults: { ease: "power3.out" } });
    tl.from(".hero__title", { y: 18, opacity: 0, duration: 0.8 })
      .from(".hero__lede, .hero__ctas", { y: 12, opacity: 0, duration: 0.6, stagger: 0.08 }, "-=0.5")
      .from(".device", { y: 24, opacity: 0, duration: 0.8 }, "-=0.6")
      .add(() => countTo(fig, 0, 1284, 1.1), "-=0.45")
      .from(".drow", { y: 10, opacity: 0, duration: 0.45, stagger: 0.09 }, "-=0.55");
  }

  /* ── Safe to Spend: money separates into its claims ──────────────── */
  (function sts() {
    const section = $(".sts");
    const figure = $("#stsFigure");
    const label = $("#stsLabel");
    const bar = $("#stsBar");
    const ledger = $("#stsLedger");
    const why = $("#whyBtn");
    const ORDER = ["obligations", "essentials", "annual", "goals", "other", "safe"];
    const AMOUNT = { obligations: 1640, essentials: 920, annual: 410, goals: 380, other: 186 };
    const NAME = { obligations: "After obligations", essentials: "After essentials", annual: "After annual costs", goals: "After hard goals", other: "After other protected money" };
    let shown = 4820;

    function show(step, instant) {
      // step 0: all available; 1–5: claims taken in turn; 6: resolved
      section.dataset.step = String(step);
      ORDER.forEach((k, i) => {
        const on = i < step;
        $$(`.seg[data-key="${k}"]`, bar).forEach((s) => s.classList.toggle("is-claimed", on));
        const row = $(`.lrow[data-key="${k}"]`, ledger);
        if (row) row.classList.toggle("is-on", on);
      });
      let left = 4820;
      for (let i = 0; i < Math.min(step, 5); i++) left -= AMOUNT[ORDER[i]];
      const resolved = step >= 6;
      section.classList.toggle("is-resolved", resolved);
      label.textContent = step === 0 ? "Available money" : resolved ? "Safe to spend" : NAME[ORDER[step - 1]];
      if (instant) figure.textContent = eur(left); else countTo(figure, shown, left, 0.5);
      shown = left;
    }

    // At rest the whole calculation is visible.
    show(6, true);

    why.addEventListener("click", () => {
      const open = why.getAttribute("aria-expanded") !== "true";
      why.setAttribute("aria-expanded", String(open));
      ledger.hidden = !open;
    });

    // Point at a slice or a line and the other lights up.
    const focusKey = (key) => {
      bar.classList.toggle("is-focus", !!key);
      $$(".seg", bar).forEach((s) => s.classList.toggle("is-hot", s.dataset.key === key));
      $$(".lrow", ledger).forEach((r) => r.classList.toggle("is-hot", r.dataset.key === key));
    };
    $$(".seg, .lrow", section).forEach((n) => {
      if (n.dataset.key === "available") return;
      n.addEventListener("pointerenter", () => focusKey(n.dataset.key));
      n.addEventListener("pointerleave", () => focusKey(null));
    });

    // The film: pinned while the visitor scrolls through each claim.
    if (!animate || !ST) return;
    const mm = G.matchMedia();
    mm.add("(min-width: 901px) and (min-height: 640px)", () => {
      show(0, true);
      let current = 0;
      const st = ST.create({
        trigger: section,
        pin: ".sts__pin",
        start: "top top",
        end: "+=1500",
        onUpdate: (self) => {
          const step = Math.min(6, Math.floor(self.progress * 7.2));
          if (step !== current) { current = step; show(step); }
        },
      });
      return () => { st.kill(); show(6, true); };
    });
  })();

  /* ── a small chart helper ───────────────────────────────────────── */
  function pathFrom(fn, from, to, x, y) {
    let d = "";
    for (let t = from; t <= to; t++) d += (t === from ? "M" : "L") + x(t).toFixed(1) + " " + y(fn(t)).toFixed(1);
    return d;
  }
  function drawOn(path, dur = 1.4) {
    if (!animate) return;
    const len = path.getTotalLength();
    G.fromTo(path, { strokeDasharray: len, strokeDashoffset: len },
      { strokeDashoffset: 0, duration: dur, ease: "power2.inOut",
        onComplete: () => { path.style.strokeDasharray = ""; path.style.strokeDashoffset = ""; } });
  }

  /* ── Ask before you spend ───────────────────────────────────────── */
  (function ask() {
    const svg = $("#askChart");
    const W = 560, H = 170, L = 8, R = 552, T = 14, B = 136;
    const x = (d) => L + (d / 40) * (R - L);
    const y = (v) => B - (Math.max(v, 0) / 2800) * (B - T);
    [0, 1000, 2000].forEach((v) => el("line", { x1: L, x2: R, y1: y(v), y2: y(v), class: v ? "grid-line" : "ax" }, svg));
    el("line", { x1: x(10), x2: x(10), y1: T, y2: B, class: "today-line" }, svg);
    const incLbl = el("text", { x: x(10) + 6, y: T + 10, class: "ax-label" }, svg);
    incLbl.textContent = "Income, Oct 25";
    const dayLbls = [[0, "Today"], [20, "Nov 4"], [40, "Nov 24"]];
    dayLbls.forEach(([d, t], i) => {
      const n = el("text", { x: x(d), y: H - 8, class: "ax-label", "text-anchor": i === 0 ? "start" : i === 2 ? "end" : "middle" }, svg);
      n.textContent = t;
    });
    const area = el("path", { class: "area" }, svg);
    const line = el("path", { class: "curve" }, svg);
    const buyDot = el("circle", { r: 5, class: "scrub-dot" }, svg);
    const buyLbl = el("text", { class: "ax-label" }, svg);

    const now = (d) => buyNow(d);
    const later = (d) => waitPay(d);
    let mix = 0; // 0 = buy today, 1 = wait
    function render() {
      const f = (d) => now(d) * (1 - mix) + later(d) * mix;
      const p = pathFrom(f, 0, 40, x, y);
      line.setAttribute("d", p);
      area.setAttribute("d", p + `L${x(40)} ${B}L${x(0)} ${B}Z`);
      const bd = mix < 0.5 ? 0 : 10;
      buyDot.setAttribute("cx", x(bd)); buyDot.setAttribute("cy", y(f(bd)));
      buyLbl.setAttribute("x", x(bd) + 9); buyLbl.setAttribute("y", y(f(bd)) - 9);
      buyLbl.textContent = "Laptop −€700";
    }
    render();

    const ctl = $(".seg-control");
    const sts = $("#askSts");
    const goal = $("#askGoal");
    const opts = $$(".seg-control__opt", ctl);
    function choose(which, focus) {
      ctl.dataset.value = which;
      opts.forEach((o) => {
        const on = o.dataset.scenario === which;
        o.setAttribute("aria-checked", String(on));
        o.tabIndex = on ? 0 : -1;
        if (on && focus) o.focus();
      });
      const target = which === "wait" ? 1 : 0;
      countTo(sts, which === "wait" ? 450 : 1150, which === "wait" ? 1150 : 450, 0.55);
      goal.innerHTML = which === "wait"
        ? '<span class="pill pill--ok">On schedule</span>'
        : '<span class="pill pill--warn">+18 days</span>';
      if (animate) {
        const o = { m: mix };
        G.to(o, { m: target, duration: 0.7, ease: "power3.inOut", overwrite: true,
          onUpdate: () => { mix = o.m; render(); } });
      } else { mix = target; render(); }
    }
    opts.forEach((o, i) => {
      o.tabIndex = i === 0 ? 0 : -1;
      o.addEventListener("click", () => choose(o.dataset.scenario));
      o.addEventListener("keydown", (e) => {
        if (["ArrowRight", "ArrowLeft", "ArrowUp", "ArrowDown"].includes(e.key)) {
          e.preventDefault();
          choose(o.dataset.scenario === "now" ? "wait" : "now", true);
        }
      });
    });
    onEnter(svg, () => drawOn(line, 1.1));
  })();

  /* ── Financial timeline ─────────────────────────────────────────── */
  (function timeline() {
    const svg = $("#tlChart");
    const wrap = $("#tlWrap");
    const tip = $("#tlTip");
    const note = $("#tlNote");
    const W = 1100, L = 56, R = 1080, T = 18, B = 262, LANE = 298;
    const D0 = -30, D1 = 60;
    const x = (d) => L + ((d - D0) / (D1 - D0)) * (R - L);
    const y = (v) => B - (Math.max(v, 0) / 3000) * (B - T);

    [0, 1000, 2000, 3000].forEach((v) => {
      el("line", { x1: L, x2: R, y1: y(v), y2: y(v), class: v ? "grid-line" : "ax" }, svg);
      const t = el("text", { x: L - 10, y: y(v) + 4, "text-anchor": "end", class: "ax-label" }, svg);
      t.textContent = v ? "€" + v / 1000 + "k" : "€0";
    });
    [[-30, "Sep 15"], [-14, "Oct 1"], [17, "Nov 1"], [47, "Dec 1"], [60, "Dec 14"]].forEach(([d, t]) => {
      const n = el("text", { x: x(d), y: 346, "text-anchor": d === 60 ? "end" : d === -30 ? "start" : "middle", class: "ax-label" }, svg);
      n.textContent = t;
    });
    el("line", { x1: L, x2: R, y1: LANE, y2: LANE, class: "grid-line" }, svg);
    const laneLbl = el("text", { x: L - 10, y: LANE + 4, "text-anchor": "end", class: "ax-label" }, svg);
    laneLbl.textContent = "Plan";

    el("line", { x1: x(0), x2: x(0), y1: T - 6, y2: LANE + 12, class: "today-line" }, svg);
    const todayT = el("text", { x: x(0) + 7, y: T + 6, class: "today-label" }, svg);
    todayT.textContent = "TODAY";

    const area = el("path", { class: "area" }, svg);
    const ghost = el("path", { class: "curve curve--ghost", opacity: 0 }, svg);
    const past = el("path", { class: "curve curve--past", d: pathFrom(baseline, D0, 0, x, y) }, svg);
    const future = el("path", { class: "curve" }, svg);
    ghost.setAttribute("d", pathFrom(baseline, 0, D1, x, y));

    // events sit on the plan lane: they are in the plan, not in the curve
    const stacks = {};
    EVENTS.forEach((e) => {
      const k = e.d; stacks[k] = (stacks[k] || 0) + 1;
      const cy = LANE - (stacks[k] - 1) * 14;
      const cx = x(e.d);
      if (e.kind === "income") el("circle", { cx, cy, r: 5, class: "ev-income" }, svg);
      else if (e.kind === "goal") el("circle", { cx, cy, r: 4.5, class: "ev-goal" }, svg);
      else if (e.kind === "annual") el("rect", { x: cx - 4.5, y: cy - 4.5, width: 9, height: 9, transform: `rotate(45 ${cx} ${cy})`, class: "ev-annual" }, svg);
      else el("rect", { x: cx - 4, y: cy - 4, width: 8, height: 8, rx: 1.5, class: "ev-bill" }, svg);
    });

    const scrub = el("line", { y1: T, y2: LANE, class: "scrub-line", opacity: 0 }, svg);
    const dot = el("circle", { r: 5.5, class: "scrub-dot", opacity: 0 }, svg);

    let mix = 0;
    const cur = (d) => (d < 0 ? baseline(d) : baseline(d) * (1 - mix) + buyNow(d) * mix);
    function render() {
      const p = pathFrom(cur, 0, D1, x, y);
      future.setAttribute("d", p);
      area.setAttribute("d", p + `L${x(D1)} ${B}L${x(0)} ${B}Z`);
      ghost.setAttribute("opacity", String(mix * 0.9));
    }
    render();

    const buy = $("#tlBuy");
    buy.addEventListener("change", () => {
      const target = buy.checked ? 1 : 0;
      note.innerHTML = buy.checked
        ? 'Travel reaches its target on <b class="shift">June 30, 2027</b>, 18 days later. Obligations stay covered.'
        : "Travel reaches its target on <b>June 12, 2027</b>.";
      if (animate) {
        const o = { m: mix };
        G.to(o, { m: target, duration: 0.8, ease: "power3.inOut", overwrite: true,
          onUpdate: () => { mix = o.m; render(); } });
      } else { mix = target; render(); }
      if (active !== null) place(active);
    });

    // scrubbing: instant, it follows the hand
    let active = null;
    function place(d) {
      active = d;
      const v = cur(d);
      scrub.setAttribute("x1", x(d)); scrub.setAttribute("x2", x(d)); scrub.setAttribute("opacity", 1);
      dot.setAttribute("cx", x(d)); dot.setAttribute("cy", y(v)); dot.setAttribute("opacity", 1);
      const evs = EVENTS.filter((e) => e.d === d).map((e) => `<span>${e.text}</span>`).join("");
      const when = d === 0 ? "Today" : d < 0 ? fmtDate(d) : fmtDate(d) + " · projected";
      tip.innerHTML = `<span class="tip-date">${when}</span><b>${eur(v)}</b><span>safe to spend</span>${evs}`;
      tip.hidden = false;
      const box = svg.getBoundingClientRect();
      const px = (x(d) / W) * box.width;
      const tw = tip.offsetWidth;
      const left = Math.min(Math.max(px + 14, 0), box.width - tw);
      tip.style.left = (px + 14 + tw > box.width ? px - tw - 14 : left) + "px";
    }
    function clear() {
      active = null; tip.hidden = true;
      scrub.setAttribute("opacity", 0); dot.setAttribute("opacity", 0);
    }
    svg.addEventListener("pointermove", (e) => {
      const box = svg.getBoundingClientRect();
      const vx = ((e.clientX - box.left) / box.width) * W;
      const d = Math.round(D0 + ((vx - L) / (R - L)) * (D1 - D0));
      place(Math.max(D0, Math.min(D1, d)));
    });
    svg.addEventListener("pointerleave", clear);
    svg.addEventListener("focus", () => place(0));
    svg.addEventListener("blur", clear);
    svg.addEventListener("keydown", (e) => {
      const step = e.shiftKey ? 7 : 1;
      if (e.key === "ArrowRight") { e.preventDefault(); place(Math.min(D1, (active ?? 0) + step)); }
      else if (e.key === "ArrowLeft") { e.preventDefault(); place(Math.max(D0, (active ?? 0) - step)); }
      else if (e.key === "Home") { e.preventDefault(); place(0); }
    });
    svg.setAttribute("aria-description", "Use the left and right arrow keys to move through the days.");

    onEnter(wrap, () => { drawOn(past, 0.9); setTimeout(() => drawOn(future, 1.1), animate ? 700 : 0); });
  })();

  /* ── Goal projection ────────────────────────────────────────────── */
  (function goals() {
    const proj = $(".proj");
    const marker = $("#projMarker");
    const date = $("#goalDate");
    const chips = $$(".goal__choices .chip");
    // Oct 2026 → Oct 2027 across the track
    const X = { wait: (8 + 12 / 30) / 12, buy: (9 + 14 / 31) / 12 };
    const TEXT = { wait: "June 2027", buy: "July 2027" };
    const size = () => proj.style.setProperty("--proj-w", proj.clientWidth + "px");
    size();
    window.addEventListener("resize", size, { passive: true });
    marker.style.setProperty("--x", X.wait);

    function choose(which, focus) {
      chips.forEach((c) => {
        const on = c.dataset.goal === which;
        c.setAttribute("aria-checked", String(on)); c.tabIndex = on ? 0 : -1;
        if (on && focus) c.focus();
      });
      marker.style.setProperty("--x", X[which]);
      if (!animate) { date.textContent = TEXT[which]; date.classList.toggle("is-later", which === "buy"); return; }
      date.classList.add("is-swapping");
      setTimeout(() => {
        date.textContent = TEXT[which];
        date.classList.toggle("is-later", which === "buy");
        date.classList.remove("is-swapping");
      }, 200);
    }
    chips.forEach((c, i) => {
      c.tabIndex = i === 0 ? 0 : -1;
      c.addEventListener("click", () => choose(c.dataset.goal));
      c.addEventListener("keydown", (e) => {
        if (["ArrowRight", "ArrowLeft"].includes(e.key)) { e.preventDefault(); choose(c.dataset.goal === "wait" ? "buy" : "wait", true); }
      });
    });

    if (animate) {
      onEnter($(".goal"), () => {
        const pct = $("#goalPct");
        const o = { v: 0 };
        G.from(".goal__fill", { scaleX: 0, duration: 1.2, ease: "power3.out" });
        G.to(o, { v: 72, duration: 1.2, ease: "power3.out", onUpdate: () => { pct.textContent = Math.round(o.v); } });
      });
    }
  })();

  /* ── Intelligence: insight → the layer it came from ─────────────── */
  (function intel() {
    const layers = $(".layers");
    const layerEls = $$(".layer", layers);
    const trace = (src) => {
      layers.classList.toggle("is-tracing", src !== null);
      layerEls.forEach((l) => {
        const n = +l.dataset.layer;
        l.classList.toggle("is-hot", src !== null && (n === src || n === 3));
      });
    };
    $$(".insight", layers).forEach((i) => {
      i.tabIndex = 0;
      const src = +i.dataset.src;
      i.addEventListener("pointerenter", () => trace(src));
      i.addEventListener("pointerleave", () => trace(null));
      i.addEventListener("focus", () => trace(src));
      i.addEventListener("blur", () => trace(null));
    });
    // once, on arrival: the numbers travel up from the engine to the words
    if (animate) {
      onEnter(layers, () => {
        const tl = G.timeline();
        layerEls.forEach((l, i) => {
          tl.call(() => { layers.classList.add("is-tracing"); layerEls.forEach((x) => x.classList.toggle("is-hot", x === l)); }, null, i * 0.32);
        });
        tl.call(() => { layers.classList.remove("is-tracing"); layerEls.forEach((x) => x.classList.remove("is-hot")); }, null, layerEls.length * 0.32 + 0.2);
      });
    }
  })();

  /* ── Personal inflation ─────────────────────────────────────────── */
  (function inflation() {
    const svg = $("#inflChart");
    const you = [100, 100.6, 101.5, 102.1, 103.0, 103.8, 104.9, 105.6, 106.3, 107.2, 107.9, 108.4];
    const off = [100, 100.2, 100.5, 100.8, 101.1, 101.4, 101.8, 102.1, 102.4, 102.7, 102.9, 103.1];
    const months = ["Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct"];
    const L = 36, R = 488, T = 12, B = 226;
    const x = (i) => L + (i / 11) * (R - L);
    const y = (v) => B - ((v - 99) / 11) * (B - T);
    [100, 105, 110].forEach((v) => {
      el("line", { x1: L, x2: R, y1: y(v), y2: y(v), class: v === 100 ? "ax" : "grid-line" }, svg);
      const t = el("text", { x: L - 8, y: y(v) + 4, "text-anchor": "end", class: "ax-label" }, svg);
      t.textContent = v;
    });
    months.forEach((m, i) => {
      if (i % 2) return;
      const t = el("text", { x: x(i), y: B + 22, "text-anchor": "middle", class: "ax-label" }, svg);
      t.textContent = m;
    });
    const line = (arr) => arr.map((v, i) => (i ? "L" : "M") + x(i).toFixed(1) + " " + y(v).toFixed(1)).join("");
    const gap = line(you) + off.slice().reverse().map((v, i) => "L" + x(11 - i).toFixed(1) + " " + y(v).toFixed(1)).join("") + "Z";
    el("path", { d: gap, class: "gap-area" }, svg);
    const pOff = el("path", { d: line(off), class: "line-off" }, svg);
    const pYou = el("path", { d: line(you), class: "line-you" }, svg);
    el("circle", { cx: x(11), cy: y(you[11]), r: 4.5, fill: "var(--accent)" }, svg);
    el("circle", { cx: x(11), cy: y(off[11]), r: 4, fill: "var(--text-3)" }, svg);
    const a = el("text", { x: x(11) + 10, y: y(you[11]) + 4, class: "end-label", fill: "var(--accent)" }, svg);
    a.textContent = "+8.4%";
    const b = el("text", { x: x(11) + 10, y: y(off[11]) + 4, class: "end-label", fill: "var(--text-2)" }, svg);
    b.textContent = "+3.1%";
    onEnter(svg, () => { drawOn(pOff, 1.2); drawOn(pYou, 1.4); });
  })();

  /* ── Upcoming claims on a 30-day line ───────────────────────────── */
  (function claims() {
    const axis = $("#clAxis");
    const rows = $$("#clList li");
    const ticks = rows.map((r) => {
      const d = +getComputedStyle(r).getPropertyValue("--d");
      const t = document.createElement("span");
      t.className = "cl__tick";
      t.dataset.kind = r.dataset.kind;
      if (r.textContent.includes("1,100")) t.classList.add("cl__tick--big");
      t.style.left = (d / 30) * 100 + "%";
      axis.appendChild(t);
      const hot = (on) => { r.classList.toggle("is-hot", on); t.style.outline = on ? "2px solid var(--accent)" : ""; t.style.outlineOffset = "2px"; };
      r.addEventListener("pointerenter", () => hot(true));
      r.addEventListener("pointerleave", () => hot(false));
      return t;
    });
    if (animate) onEnter(axis, () => G.from(ticks, { y: 10, opacity: 0, duration: 0.45, stagger: 0.06, ease: "power3.out" }));
  })();

  /* ── See, decide, act, learn: the step in view is lit ───────────── */
  (function loop() {
    const steps = $$(".loop__step");
    if (!("IntersectionObserver" in window)) { steps.forEach((s) => s.classList.add("is-on")); return; }
    const io = new IntersectionObserver((es) => {
      es.forEach((e) => e.target.classList.toggle("is-on", e.isIntersecting));
    }, { rootMargin: "-45% 0px -45% 0px" });
    steps.forEach((s) => io.observe(s));
  })();

  /* ── Company: the thesis fills in, the layers pass the numbers up ── */
  (function company() {
    const sec = $(".company");
    if (!sec) return;
    const line = $(".lf__line", sec);
    const size = () => line && line.style.setProperty("--lf-w", line.clientWidth + "px");
    size();
    window.addEventListener("resize", size, { passive: true });
    const layers = $$(".tstack li", sec);
    const run = () => {
      if (reduce) return;
      layers.forEach((l, i) => {
        setTimeout(() => {
          layers.forEach((x) => x.classList.toggle("is-lit", x === l));
          if (i === layers.length - 1) setTimeout(() => l.classList.remove("is-lit"), 900);
        }, i * 360);
      });
    };
    if (!reduce) sec.classList.add("is-waiting");
    onEnter(sec, () => {
      requestAnimationFrame(() => sec.classList.remove("is-waiting"));
      sec.classList.add("is-live");
      setTimeout(run, 500);
    });
    const tech = $(".tile--tech", sec);
    if (tech) tech.addEventListener("pointerenter", run);
  })();

  /* ── Team: the strip you point at opens ──────────────────────────── */
  (function team() {
    const strips = $$(".strip");
    if (!strips.length) return;
    const fine = window.matchMedia("(hover: hover) and (pointer: fine)");
    let current = 0;
    function open(i) {
      if (i === current) return;
      strips.forEach((st, n) => {
        const on = n === i;
        st.classList.toggle("is-open", on);
        $(".strip__hit", st).setAttribute("aria-expanded", String(on));
      });
      current = i;
    }
    strips.forEach((st, i) => {
      const hit = $(".strip__hit", st);
      hit.addEventListener("click", () => open(i));
      hit.addEventListener("focus", () => open(i));
      st.addEventListener("pointerenter", () => { if (fine.matches) open(i); });
    });
  })();

  const yr = $("#year");
  if (yr) yr.textContent = String(new Date().getFullYear());
})();
