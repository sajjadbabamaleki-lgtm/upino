/* Upino pricing.
   The section's figures all come from PRICING below. To change a price,
   add a region or end the launch offer, edit the data; the component reads
   whatever is here and writes every label, saving and renewal line from it.

   Analytics: the component announces what people do through `track()`,
   which dispatches a `upino:analytics` event on window and calls
   window.upinoAnalytics(name, props) if one is installed. No provider is
   loaded here. `trial_started` is reserved for when checkout confirms a
   trial; a click on the button is `pricing_cta_clicked` and nothing more. */
(() => {
  "use strict";

  const PRICING = {
    region: "US",
    platform: "web",
    currency: "USD",
    locale: "en-US",
    trialDays: 14,
    defaultPeriod: "annual",
    bestValue: "annual",
    periods: {
      monthly: { amount: 11.99, months: 1 },
      quarterly: { amount: 29.99, months: 3 },
      annual: { amount: 79.99, months: 12 },
    },
    // The launch offer. Set enabled: false to end it; nothing else changes.
    promotion: {
      enabled: true,
      id: "founding_member",
      label: "Founding member",
      shortLabel: "Founding",
      period: "annual",
      firstTermAmount: 59.99,
    },
  };

  /* A preview aid: #pricing-regular shows the page without the launch
     offer, #pricing-founding with it. Only bare anchors, no query strings. */
  const h = location.hash;
  if (h === "#pricing-regular") PRICING.promotion.enabled = false;
  if (h === "#pricing-founding") PRICING.promotion.enabled = true;

  /* ── analytics, provider-free ─────────────────────────────────────── */
  function track(name, props = {}) {
    const detail = { name, ...props, region: PRICING.region, currency: PRICING.currency, platform: PRICING.platform };
    window.dispatchEvent(new CustomEvent("upino:analytics", { detail }));
    if (typeof window.upinoAnalytics === "function") {
      try { window.upinoAnalytics(name, detail); } catch (_) { /* never break the page */ }
    }
  }

  /* ── money ────────────────────────────────────────────────────────── */
  const money = new Intl.NumberFormat(PRICING.locale, { style: "currency", currency: PRICING.currency });
  const fmt = (n) => money.format(n);
  const whole = new Intl.NumberFormat(PRICING.locale, { style: "currency", currency: PRICING.currency, maximumFractionDigits: 0 });
  const monthlyBase = PRICING.periods.monthly.amount;
  const perMonth = (p) => PRICING.periods[p].amount / PRICING.periods[p].months;
  const saving = (p) => Math.round((1 - perMonth(p) / monthlyBase) * 100);
  const promoFor = (p) => (PRICING.promotion.enabled && PRICING.promotion.period === p ? PRICING.promotion : null);

  /** The big figure, split so the symbol and the cents sit smaller. */
  function amountHTML(n) {
    const parts = money.formatToParts(n);
    let out = "";
    for (const part of parts) {
      if (part.type === "currency") out += `<span class="cur">${part.value}</span>`;
      else out += part.value;
    }
    return out;
  }

  const WORDS = {
    monthly: { per: "per month", every: "Every month", then: (a) => `Then ${a}/month. Cancel anytime.`, billed: "billed monthly" },
    quarterly: { per: "every 3 months", every: "Every 3 months", then: (a) => `Then ${a} every 3 months. Cancel anytime.`, billed: "billed every 3 months" },
    annual: { per: "per year", every: "Every year", then: (a) => `Then ${a}/year. Cancel anytime.`, billed: "billed once a year" },
  };

  /* ── the component ────────────────────────────────────────────────── */
  const root = document.getElementById("plan");
  if (!root) return;
  const section = document.getElementById("pricing");
  const opts = Array.from(root.querySelectorAll(".period__opt"));
  const $id = (id) => document.getElementById(id);
  const reduce = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  const G = window.gsap;
  const ORDER = ["monthly", "quarterly", "annual"];

  // Savings labels on the selector, from the data.
  root.querySelectorAll("[data-save]").forEach((n) => {
    const p = n.dataset.save;
    const promo = promoFor(p);
    n.textContent = promo ? promo.shortLabel : `Save ${saving(p)}%`;
  });
  $id("trialBtn").textContent = `Start ${PRICING.trialDays}-day free trial`;

  let current = null;
  let shownAmount = null;

  /** Swap a line's text with a short blur, or at once when motion is off. */
  function swap(node, html) {
    if (node.innerHTML === html) return;
    if (reduce) { node.innerHTML = html; return; }
    node.classList.add("swap", "is-out");
    setTimeout(() => { node.innerHTML = html; node.classList.remove("is-out"); }, 150);
  }

  function setAmount(to) {
    const node = $id("quoteAmount");
    if (shownAmount === null || reduce || !G) { node.innerHTML = amountHTML(to); shownAmount = to; return; }
    const o = { v: shownAmount };
    G.to(o, { v: to, duration: 0.42, ease: "power3.out", overwrite: true,
      onUpdate: () => { node.innerHTML = amountHTML(Math.round(o.v * 100) / 100); } });
    shownAmount = to;
  }

  /* ── the first 12 months, drawn ───────────────────────────────────
     The track holds the 14 free days and then twelve months. Each block
     is one payment, as wide as the time it covers. */
  function drawYear(period, charged) {
    const track = $id("yearTrack");
    if (!track) return;
    const p = PRICING.periods[period];
    const promo = promoFor(period);
    // drawn a little wider than to scale, so the free days stay readable
    const trialMonths = Math.max(PRICING.trialDays / 30.4, 0.9);
    const span = trialMonths + 12;
    const pct = (m) => (m / span) * 100;
    const gap = 0.35; // % between blocks
    const blocks = [];
    for (let m = 0; m < 12; m += p.months) {
      const amount = promo && m === 0 ? promo.firstTermAmount : p.amount;
      blocks.push({ start: trialMonths + m, len: Math.min(p.months, 12 - m), amount });
    }
    const total = blocks.reduce((a, b) => a + b.amount, 0);
    track.innerHTML = "";
    const trial = document.createElement("span");
    trial.className = "ytrial";
    trial.style.width = `calc(${pct(trialMonths)}% - 10px)`;
    trial.textContent = "Free";
    track.appendChild(trial);
    blocks.forEach((b, i) => {
      const n = document.createElement("span");
      n.className = "yblk" + (period === "annual" ? (promo ? " yblk--promo" : " yblk--annual") : "");
      n.style.left = `calc(${pct(b.start)}% + ${i === 0 ? 2 : gap * 4}px)`;
      n.style.width = `calc(${pct(b.len)}% - ${i === 0 ? 10 : gap * 8}px)`;
      if (b.len >= 3) n.textContent = fmt(b.amount);
      if (!reduce) {
        n.classList.add("is-entering");
        n.style.transitionDelay = `${Math.min(i * 35, 400)}ms`;
      }
      track.appendChild(n);
    });
    if (!reduce) requestAnimationFrame(() => requestAnimationFrame(() =>
      track.querySelectorAll(".is-entering").forEach((n) => n.classList.remove("is-entering"))));
    $id("yearTotal").textContent = fmt(Math.round(total * 100) / 100);
    const monthlyYear = PRICING.periods.monthly.amount * 12;
    const kept = Math.round((monthlyYear - total) * 100) / 100;
    $id("yearCompare").innerHTML = period === "monthly"
      ? `${blocks.length} payments of ${fmt(p.amount)}, after ${PRICING.trialDays} free days.`
      : `Monthly for the same year: ${fmt(monthlyYear)}. You keep <b>${fmt(kept)}</b>.`;
    track.setAttribute("aria-label", period === "monthly"
      ? `${PRICING.trialDays} free days, then ${blocks.length} monthly payments of ${fmt(p.amount)}, ${fmt(total)} in total.`
      : `${PRICING.trialDays} free days, then ${blocks.length === 1 ? "one payment" : blocks.length + " payments"} totalling ${fmt(total)} for the year.`);
  }

  function render(period, via) {
    const p = PRICING.periods[period];
    const promo = promoFor(period);
    const w = WORDS[period];
    const charged = promo ? promo.firstTermAmount : p.amount;

    root.dataset.period = period;
    root.dataset.promo = promo ? "on" : "off";
    root.style.setProperty("--i", ORDER.indexOf(period));
    opts.forEach((o) => {
      const on = o.dataset.period === period;
      o.setAttribute("aria-checked", String(on));
      o.tabIndex = on ? 0 : -1;
    });
    root.querySelector(".period__thumb").style.setProperty("--i", ORDER.indexOf(period));

    // tag
    const tag = $id("quoteTag");
    const tagText = promo ? promo.label : period === PRICING.bestValue ? "Best value" : "";
    tag.classList.toggle("is-empty", !tagText);
    swap(tag.querySelector(".quote__tagtext"), tagText || "&nbsp;");

    // price: the amount actually charged is always the big number
    setAmount(charged);
    swap($id("quotePer"), promo ? "for your first year" : w.per);

    // context line
    let ctx;
    if (promo) {
      ctx = `Regularly <b>${fmt(p.amount)}</b> a year. Less than <b>${whole.format(Math.ceil(charged / 12))}</b> a month in your first year.`;
    } else if (period === "monthly") {
      ctx = `Billed monthly. The full product, month to month.`;
    } else {
      ctx = `<b>${fmt(perMonth(period))}</b> a month, ${w.billed}. <span class="quote__save">Save ${saving(period)}%</span>`;
    }
    swap($id("quoteContext"), ctx);

    drawYear(period, charged);

    // what happens, on which day
    swap($id("billWhen2"), `Day ${PRICING.trialDays}`);
    swap($id("billWhat2"), promo ? "First year" : "First payment");
    swap($id("billAmt2"), fmt(charged));
    swap($id("billWhen3"), promo ? "From year two" : w.every);
    swap($id("billWhat3"), "Renews");
    swap($id("billAmt3"), fmt(p.amount));

    // under the button: exactly what will be charged, and what it renews at
    swap($id("planThen"), promo
      ? `Then ${fmt(charged)} for your first year. Renews at ${fmt(p.amount)}/year unless cancelled.`
      : w.then(fmt(p.amount)));

    if (via) {
      track("billing_period_selected", { period, via });
      track(`${period}_selected`, { via });
    }
    if (promo && current !== period && viewed) track("founding_offer_viewed", { period });
    current = period;
  }

  // selector: click, and arrow keys as a radio group should
  opts.forEach((o) => {
    o.addEventListener("click", () => { if (o.dataset.period !== current) render(o.dataset.period, "click"); });
    o.addEventListener("keydown", (e) => {
      const i = ORDER.indexOf(current);
      let next = null;
      if (e.key === "ArrowRight" || e.key === "ArrowDown") next = ORDER[(i + 1) % 3];
      else if (e.key === "ArrowLeft" || e.key === "ArrowUp") next = ORDER[(i + 2) % 3];
      else if (e.key === "Home") next = ORDER[0];
      else if (e.key === "End") next = ORDER[2];
      if (!next) return;
      e.preventDefault();
      render(next, "keyboard");
      root.querySelector(`[data-period="${next}"]`).focus();
    });
  });

  $id("trialBtn").addEventListener("click", () => {
    const promo = promoFor(current);
    track("pricing_cta_clicked", {
      period: current,
      amount: promo ? promo.firstTermAmount : PRICING.periods[current].amount,
      renewal: PRICING.periods[current].amount,
      promotion: promo ? promo.id : null,
      trialDays: PRICING.trialDays,
    });
  });

  let viewed = false;
  if ("IntersectionObserver" in window) {
    const io = new IntersectionObserver((es) => {
      if (!es.some((e) => e.isIntersecting)) return;
      io.disconnect();
      viewed = true;
      track("pricing_section_viewed", { period: current });
      if (promoFor(current)) track("founding_offer_viewed", { period: current });
    }, { threshold: 0.4 });
    io.observe(section);
  }

  render(PRICING.defaultPeriod);

  // exposed for later wiring (checkout, regional overrides)
  window.UpinoPricing = { config: PRICING, select: (p) => render(p, "api"), track };
})();
