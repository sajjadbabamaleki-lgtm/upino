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
    if (reduce) { node.textContent = eur(to); return; }
    if (!G) {
      const t0 = performance.now();
      const step = (t) => {
        const k = Math.min(1, (t - t0) / (dur * 1000));
        node.textContent = eur(from + (to - from) * (1 - Math.pow(1 - k, 3)));
        if (k < 1) node._count = requestAnimationFrame(step);
      };
      cancelAnimationFrame(node._count);
      node._count = requestAnimationFrame(step);
      return;
    }
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

  /* ── hero: the product as tiles ───────────────────────────────────
     The pay period's 30 days (18 gone, 12 left), and a Move that changes
     every number depending on it. */
  (function hero() {
    const sec = $(".hero");
    const bento = $("#heroBento");
    if (!sec || !bento) return;
    const days = $(".bt__days", bento);
    for (let i = 0; i < 30; i++) { const d = document.createElement("i"); if (i >= 18) d.className = "left"; days.appendChild(d); }

    // the nav reads light while it sits over this hero
    const nav = $("#nav");
    if ("IntersectionObserver" in window) {
      new IntersectionObserver(([e]) => nav.classList.toggle("is-dark", e.isIntersecting), { rootMargin: "-40px 0px -95% 0px" }).observe(sec);
    } else nav.classList.add("is-dark");

    // Move €180 to Travel: Safe to Spend and the goal change together
    const btn = $("#heroMove"), fig = $("#heroFigure");
    let moved = false;
    btn.addEventListener("click", () => {
      moved = !moved;
      countTo(fig, moved ? 1284 : 1104, moved ? 1104 : 1284, 0.5);
      $("#heroGoalPct").textContent = moved ? "75%" : "72%";
      $("#heroGoalBar").style.setProperty("--p", moved ? 0.75 : 0.72);
      $("#heroGoalText").textContent = moved ? "June 2027 · ahead of plan" : "June 2027 · on track";
      $("#heroMoveK").textContent = moved ? "Done" : "Next best move";
      $("#heroMoveText").innerHTML = moved ? 'Moved <b class="num">€180</b> to Travel' : 'Move <b class="num">€180</b> to Travel';
      btn.textContent = moved ? "Undo" : "Move";
      if (!reduce) $$(".bt--sts, .bt--goal", bento).forEach((t) => { t.classList.remove("flash"); void t.offsetWidth; t.classList.add("flash"); });
    });

    if (animate) {
      G.timeline({ defaults: { ease: "power3.out" } })
        .from(".hero__title", { y: 18, opacity: 0, duration: 0.8 })
        .from(".hero__side", { y: 12, opacity: 0, duration: 0.6 }, "-=0.5")
        .from(".bt", { y: 18, opacity: 0, duration: 0.6, stagger: 0.07, clearProps: "transform,opacity" }, "-=0.4")
        .add(() => countTo(fig, 0, 1284, 1.1), "<0.1");
    }
  })();

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
    const box = $("#askChart");
    const MAX = 2700;
    // each day's bar is the chosen scenario; behind it, hatched, the day without the laptop
    const cols = [];
    for (let d = 0; d <= 40; d++) {
      const c = document.createElement("span");
      c.className = "abars__col" + (d === 0 ? " is-now" : "");
      c.style.setProperty("--g", (baseline(d) / MAX).toFixed(4));
      c.innerHTML = '<i class="abars__ghost"></i><i class="abars__bar"></i>' + (d === 10 ? '<span class="abars__pay">Pay</span>' : "");
      box.appendChild(c);
      cols.push(c);
    }
    let mix = 0; // 0 = buy today, 1 = wait
    function render() {
      cols.forEach((c, d) => c.style.setProperty("--v", ((buyNow(d) * (1 - mix) + waitPay(d) * mix) / MAX).toFixed(4)));
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
      mix = target; render();
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
    if (!reduce) { box.classList.add("is-pre"); onEnter(box, () => box.classList.remove("is-pre")); }
  })();

  /* ── Financial timeline, by the week ───────────────────────────────
     Thirteen weeks, Sep 15 to Dec 14. Each bar is the lowest Safe to Spend
     of its week: grey behind today, blue for this week, pale ahead. Weeks
     with income carry a Pay mark. With the laptop, the weeks it touches
     shrink and the money it takes stays visible as a hatched cap. */
  (function timeline() {
    const box = $("#tlBars");
    if (!box) return;
    const card = box.closest(".tl");
    const tip = $("#tlTip");
    const note = $("#tlNote");
    const buy = $("#tlBuy");
    const MAX = 2700;
    const weeks = [];
    for (let w = 0; w < 13; w++) {
      const from = -30 + w * 7, to = Math.min(60, from + 6);
      const ds = []; for (let d = from; d <= to; d++) ds.push(d);
      const lowOf = (fn) => ds.reduce((m, d) => (fn(d) < m.v ? { v: fn(d), d } : m), { v: Infinity, d: from });
      weeks.push({ from, to, base: lowOf(baseline), buy: lowOf((d) => (d < 0 ? baseline(d) : buyNow(d))),
        now: from <= 0 && 0 <= to, past: to < 0, pay: PAYS.some((p) => p >= from && p <= to),
        events: EVENTS.filter((e) => e.d >= from && e.d <= to) });
    }
    const cols = weeks.map((w, i) => {
      const c = document.createElement("div");
      c.className = "tlb__col" + (w.past ? " is-past" : "") + (w.now ? " is-now" : "") + (w.buy.v < w.base.v - 1 ? " is-hit" : "");
      c.tabIndex = 0;
      c.innerHTML = `<div class="tlb__plot"><i class="tlb__ghost"></i><i class="tlb__bar"></i>${w.pay ? '<span class="tlb__pay">Pay</span>' : ""}</div>` +
        `<span class="tlb__lab">${w.now ? "This week" : fmtDate(w.from)}</span>`;
      c.style.setProperty("--g", (w.base.v / MAX).toFixed(4));
      box.appendChild(c);
      return c;
    });
    let bought = false;
    const low = (w) => (bought ? w.buy : w.base);
    function paint() {
      weeks.forEach((w, i) => cols[i].style.setProperty("--v", (low(w).v / MAX).toFixed(4)));
      card.classList.toggle("is-buy", bought);
      $("#tlToday").textContent = eur(bought ? buyNow(0) : baseline(0));
      let m = { v: Infinity, d: 0 };
      for (let d = 0; d < 10; d++) { const v = bought ? buyNow(d) : baseline(d); if (v < m.v) m = { v, d }; }
      $("#tlLow").textContent = `${eur(m.v)}, ${fmtDate(m.d)}`;
      if (shown !== null) show(shown);
    }
    let shown = null;
    function show(i) {
      shown = i;
      const w = weeks[i], l = low(w);
      const when = w.now ? "This week" : `${fmtDate(w.from)} to ${fmtDate(w.to)}`;
      const evs = w.events.map((e) => `<span>${e.text}</span>`).join("");
      tip.innerHTML = `<span class="tip-date">${when}</span><b>${eur(l.v)}</b><span>lowest, on ${fmtDate(l.d)}</span>${evs}`;
      tip.hidden = false;
      const cb = cols[i].getBoundingClientRect(), pb = card.getBoundingClientRect();
      const bar = cols[i].querySelector(".tlb__bar").getBoundingClientRect();
      const tw = tip.offsetWidth, th = tip.offsetHeight;
      let left = cb.right - pb.left + 8;
      if (left + tw > pb.width - 8) left = cb.left - pb.left - tw - 8;
      tip.style.left = Math.max(8, left) + "px";
      tip.style.top = Math.max(8, bar.top - pb.top - th / 2) + "px";
    }
    const hide = () => { shown = null; tip.hidden = true; };
    cols.forEach((c, i) => {
      c.addEventListener("pointerenter", () => show(i));
      c.addEventListener("focus", () => show(i));
      c.addEventListener("pointerleave", hide);
      c.addEventListener("blur", hide);
    });
    buy.addEventListener("change", () => {
      bought = buy.checked;
      note.innerHTML = bought
        ? 'The laptop takes the hatched part of the next two weeks. Travel reaches its target on <b class="shift">June 30, 2027</b>, 18 days later. Obligations stay covered.'
        : "Each bar is the lowest point of a week. Travel reaches its target on <b>June 12, 2027</b>.";
      paint();
    });
    paint();
    if (!reduce) {
      box.classList.add("is-pre");
      cols.forEach((c, i) => { c.querySelector(".tlb__bar").style.transitionDelay = `0ms, ${i * 45}ms, 0ms`; });
      onEnter(box, () => box.classList.remove("is-pre"));
    }
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

  /* ── See, decide, act, learn: the loop goes round once on arrival ── */
  (function cycle() {
    // See, Decide, Act, Learn follow the scroll: the rail fills as you read
    // down, the step at the reading line is lit, the ones behind stay lit
    const box = $("#cycle");
    const steps = $$("#cycle .lp");
    if (!box || !steps.length) return;
    const n = $("#loopN");
    if (reduce) return;
    box.classList.add("is-scroll");
    let at = -2, queued = false, counted = false;
    const mq = window.matchMedia("(max-width: 720px)");
    const update = () => {
      queued = false;
      const vh = window.innerHeight;
      const line = vh * (mq.matches ? 0.55 : 0.7);
      let p, i;
      if (mq.matches) {
        // vertical: the rail runs beside the list
        const r = box.getBoundingClientRect();
        p = Math.min(1, Math.max(0, (line - r.top) / (r.height * 0.86)));
        i = -1;
        steps.forEach((st, k) => { if (st.getBoundingClientRect().top < line) i = k; });
      } else {
        // horizontal: one reading of the section moves the rail across
        const r = box.getBoundingClientRect();
        p = Math.min(1, Math.max(0, (line - r.top) / (vh * 0.5)));
        i = Math.min(steps.length - 1, Math.floor(p * steps.length - 0.001));
      }
      box.style.setProperty("--p", p.toFixed(4));
      if (i === at) return;
      at = i;
      steps.forEach((st, k) => {
        st.classList.toggle("is-on", k === i);
        st.classList.toggle("is-ahead", k > i);
      });
      if (i === steps.length - 1 && n && !counted) { counted = true; countTo(n, 1284, 1104, 0.9); }
      if (i < steps.length - 1) counted = false;
    };
    const queue = () => { if (!queued) { queued = true; requestAnimationFrame(update); } };
    window.addEventListener("scroll", queue, { passive: true });
    window.addEventListener("resize", queue, { passive: true });
    update();
  })();

  /* ── motion for the product sections: each thing moves once, when it
     arrives, and what moves is what the section is about ──────────── */
  (function arrivals() {
    // the eleven days of waiting
    const wait = $(".op-wait");
    if (wait && !wait.children.length) for (let i = 0; i < 11; i++) wait.appendChild(document.createElement("i"));
    if (reduce) { $$(".op-wait i").forEach((d) => d.classList.add("on")); return; }
    const seq = (root, sel, cls, gap, start = 0) => $$(sel, root).forEach((n, i) => setTimeout(() => n.classList.add(cls), start + i * gap));
    const arrive = (sel, fn) => { const n = $(sel); if (n) { n.classList.add("is-pre"); onEnter(n, () => { n.classList.remove("is-pre"); fn && fn(n); }); } };
    $$("#pnAmt, .mb__legend b").forEach((b) => { b.textContent = "€0"; });
    arrive(".pn", () => { const n = $("#pnAmt"); if (n) setTimeout(() => countTo(n, 0, 1284, 1.1), 700); });
    arrive(".mb", (n) => $$(".mb__legend b", n).forEach((b, i) => setTimeout(() => countTo(b, 0, +b.dataset.v, 0.9), i * 150)));
    const ops = $(".ops");
    if (ops) ops.classList.add("is-seq");
    arrive(".ops", (n) => {
      seq(n, ".op-wait i", "on", 110, 500);
      seq(n, ".op-track li", "on", 380, 600);
    });
    arrive(".lf2");
    arrive(".loopw");
    arrive(".mc__cols");
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

  /* ── section rules: the line draws itself when its section arrives ── */
  (function rules() {
    if (reduce || !("IntersectionObserver" in window)) return;
    const io = new IntersectionObserver((es) => es.forEach((e) => {
      if (!e.isIntersecting) return;
      io.unobserve(e.target);
      e.target.classList.remove("is-pre");
    }), { rootMargin: "0px 0px -15% 0px" });
    $$(".rule").forEach((r) => { r.classList.add("is-pre"); io.observe(r); });
  })();

  /* ── Footer: the name set exactly as wide as the page ─────────────── */
  (function footerWord() {
    const box = $("#footerWord");
    const word = box && box.firstElementChild;
    if (!word) return;
    const fit = () => {
      box.style.fontSize = "100px";
      const w = word.getBoundingClientRect().width;
      if (w) box.style.fontSize = (100 * box.clientWidth / w).toFixed(2) + "px";
    };
    fit();
    if (document.fonts && document.fonts.ready) document.fonts.ready.then(fit);
    window.addEventListener("resize", fit, { passive: true });
  })();

  const yr = $("#year");
  if (yr) yr.textContent = String(new Date().getFullYear());
})();
