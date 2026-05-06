"use strict";

/* NeoCade Phase 3.4 mockup renderer — re-execution 2026-05-06b
 *
 * Loads each direction's `shape_language` block from data/directions.json
 * (mirrored inline below for file:// runtime, kept in sync intentionally) and
 * emits an artboard whose CSS variables and data-attributes drive per-direction
 * shape language. The shared artboard CSS does NOT hard-code shape-language
 * tokens — every value flows through this renderer.
 *
 * Authoritative spec: image-prompts/direction-shape-language-spec.md
 */

const NEOCADE_DIRECTIONS = [
  {
    name: "Pulse",
    fileStem: "pulse_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/pulse-desktop-flat.png",
      mobileFlat: "concepts/pulse-mobile-flat.png",
      mobileRaised: "concepts/pulse-mobile-raised.png"
    },
    base_color: "#151A2E",
    accent_color: "#8BFF6A",
    contrast: "13.62:1",
    summary: "Vibrant arcade hall by day — cabinet-bezel chrome, lit primary actions, packed control deck.",
    target: "Multiplayer arcade lobbies, action menus, streamer-friendly tool surfaces.",
    flat: "Solid tonal surfaces; bright green accent reserved for primary actions, selected tabs, focus.",
    raised: "Filled buttons and selected tabs gain small extruded offsets; panels stay flat for density.",
    mobile: "44pt / 48dp targets; bright accent restrained to action and focus roles.",
    shape: {
      r_base: 5, r_chip: 4, r_button: 5, r_button_primary: 5,
      r_tab: 4, r_mark: 4,
      btn_pad_h: 14, btn_pad_v: 10, btn_pad_h_primary: 14, btn_pad_v_primary: 10,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 18, density_gap: 10, card_gap: 14,
      focus_thickness: 2, focus_offset: 0,
      h1_weight: 800, h2_weight: 740, kicker: "uppercase-tracked-accent",
      surface_stops: 4, surface_spread: "wide",
      hover_pct: 6, pressed_pct: -10, disabled_opacity: 0.42,
      raised_primary: 3, raised_tab: 2, raised_row: 0, raised_secondary: 0,
      lift_tabs: true, lift_rows: false, lift_secondary: false,
      tab_shape: "rectangular-strip",
      mark_shape: "square-cabinet-bezel",
      primary_strategy: "bold-accent-fill-dark-text",
      ghost_strategy: "accent-outlined-accent-text",
      focus_style: "tight-cabinet-ring"
    }
  },
  {
    name: "Slate",
    fileStem: "slate_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/slate-desktop-flat.png",
      mobileFlat: "concepts/slate-mobile-flat.png",
      mobileRaised: "concepts/slate-mobile-raised.png"
    },
    base_color: "#111820",
    accent_color: "#8BD3FF",
    contrast: "10.94:1",
    summary: "Premium dark default — iOS-pill polish, restrained accent, quiet confident chrome.",
    target: "Desktop tools, settings-heavy launchers, premium dark defaults.",
    flat: "Subtle tonal separation; sky-blue accent only on primary, focus, selection, important toggles.",
    raised: "Restrained 1-2px hard offset on primary buttons only; tabs and rows stay flat.",
    mobile: "Quiet palette with expanded button targets and high-contrast focus rings.",
    shape: {
      r_base: 11, r_chip: 999, r_button: 11, r_button_primary: 11,
      r_tab: 999, r_mark: 11,
      btn_pad_h: 16, btn_pad_v: 11, btn_pad_h_primary: 18, btn_pad_v_primary: 12,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 22, density_gap: 14, card_gap: 18,
      focus_thickness: 2, focus_offset: 2,
      h1_weight: 720, h2_weight: 640, kicker: "small-caps-subtle",
      surface_stops: 3, surface_spread: "narrow",
      hover_pct: 4, pressed_pct: -6, disabled_opacity: 0.50,
      raised_primary: 2, raised_tab: 0, raised_row: 0, raised_secondary: 0,
      lift_tabs: false, lift_rows: false, lift_secondary: false,
      tab_shape: "rounded-pill",
      mark_shape: "rounded-square",
      primary_strategy: "quiet-pill-primary",
      ghost_strategy: "thin-accent-outline",
      focus_style: "ios-style-offset"
    }
  },
  {
    name: "Bubble",
    fileStem: "bubble_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/bubble-desktop-flat.png",
      mobileFlat: "concepts/bubble-mobile-flat.png",
      mobileRaised: "concepts/bubble-mobile-raised.png"
    },
    base_color: "#241326",
    accent_color: "#FFB3E6",
    contrast: "10.74:1",
    summary: "Playful candy-counter at night — pillowy chrome, fully-rounded chips, tactile cheerful warmth.",
    target: "Casual games, cozy menus, family-friendly mobile-first UI, tutorial-heavy flows.",
    flat: "Rounded dark berry surfaces; cheerful pink accent placement is sparse and meaningful.",
    raised: "Buttons, selected tabs, selected rows and chips get 3-5px extruded offsets — pokes-out.",
    mobile: "Larger button targets, thicker focus rings, bouncy hover feel.",
    shape: {
      r_base: 18, r_chip: 999, r_button: 20, r_button_primary: 999,
      r_tab: 999, r_mark: 22,
      btn_pad_h: 20, btn_pad_v: 14, btn_pad_h_primary: 22, btn_pad_v_primary: 15,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 22, density_gap: 14, card_gap: 18,
      focus_thickness: 3, focus_offset: 2,
      h1_weight: 800, h2_weight: 760, kicker: "uppercase-tracked-accent",
      surface_stops: 3, surface_spread: "medium",
      hover_pct: 8, pressed_pct: -10, disabled_opacity: 0.45,
      raised_primary: 5, raised_tab: 3, raised_row: 2, raised_secondary: 2,
      lift_tabs: true, lift_rows: true, lift_secondary: true,
      tab_shape: "fully-rounded-pill-large",
      mark_shape: "circle-or-squircle",
      primary_strategy: "pillowy-fully-rounded-primary",
      ghost_strategy: "rounded-ghost-thicker-outline",
      focus_style: "cheerful-chunky-ring"
    }
  },
  {
    name: "Daybreak",
    fileStem: "daybreak_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/daybreak-desktop-flat.png",
      mobileFlat: "concepts/daybreak-mobile-flat.png",
      mobileRaised: "concepts/daybreak-mobile-raised.png"
    },
    base_color: "#0B2420",
    accent_color: "#76F2D1",
    contrast: "11.96:1",
    summary: "Fresh evening lobby — dark teal surfaces with bright mint wayfinding and airy spacing.",
    target: "Community hubs, onboarding flows, family-friendly settings, bright mobile experiences.",
    flat: "Dark teal tonal surfaces; high-contrast mint accent for primary, focus, selection.",
    raised: "Primary actions and selected tabs lift; ordinary panels and lists stay flat for readability.",
    mobile: "Generous breathing room around touch clusters, mint glow on focus.",
    shape: {
      r_base: 13, r_chip: 12, r_button: 13, r_button_primary: 13,
      r_tab: 12, r_mark: 13,
      btn_pad_h: 18, btn_pad_v: 12, btn_pad_h_primary: 20, btn_pad_v_primary: 13,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 24, density_gap: 16, card_gap: 20,
      focus_thickness: 2, focus_offset: 2,
      h1_weight: 720, h2_weight: 660, kicker: "sentence-case-accent",
      surface_stops: 4, surface_spread: "medium",
      hover_pct: 6, pressed_pct: -6, disabled_opacity: 0.50,
      raised_primary: 3, raised_tab: 2, raised_row: 0, raised_secondary: 0,
      lift_tabs: true, lift_rows: false, lift_secondary: false,
      tab_shape: "rounded-rect",
      mark_shape: "rounded-square-with-halo",
      primary_strategy: "friendly-primary-generous-breathing",
      ghost_strategy: "soft-outline-ghost",
      focus_style: "airy-fresh-ring-with-mint-halo"
    }
  },
  {
    name: "Burst",
    fileStem: "burst_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/burst-desktop-flat.png",
      mobileFlat: "concepts/burst-mobile-flat.png",
      mobileRaised: "concepts/burst-mobile-raised.png"
    },
    base_color: "#20112E",
    accent_color: "#FFD166",
    contrast: "12.33:1",
    summary: "Celebratory MD3 Expressive max — oversized statement primary, asymmetric brand mark, bold gold.",
    target: "Mini-game launchers, achievement screens, party-game menus, brand-forward showcases.",
    flat: "Disciplined dark surface ladder; gold accent for critical action, focus, progress.",
    raised: "Stronger 4-6px offsets on primary; smaller offsets on secondary; rows lift on selected.",
    mobile: "Large touch affordances; gold confined to high-value action and focus roles.",
    shape: {
      r_base: 16, r_chip: 14, r_button: 16, r_button_primary: 22,
      r_tab: 14, r_mark: 16,
      btn_pad_h: 20, btn_pad_v: 14, btn_pad_h_primary: 24, btn_pad_v_primary: 16,
      mark_size_desktop: 60, mark_size_mobile: 48,
      density_padding: 22, density_gap: 14, card_gap: 20,
      focus_thickness: 3, focus_offset: 1,
      h1_weight: 820, h2_weight: 780, kicker: "uppercase-bold-larger-scale",
      surface_stops: 4, surface_spread: "wide",
      hover_pct: 8, pressed_pct: -12, disabled_opacity: 0.45,
      raised_primary: 5, raised_tab: 3, raised_row: 2, raised_secondary: 2,
      lift_tabs: true, lift_rows: true, lift_secondary: true,
      tab_shape: "rounded-rect-asymmetric-on-selected",
      mark_shape: "chunky-asymmetric-badge",
      primary_strategy: "oversized-statement-primary",
      ghost_strategy: "normal-accent-ghost",
      focus_style: "dramatic-event-ring"
    }
  }
];

const PLATFORM_TOKENS = {
  desktop: { label: "platform=DESKTOP", buttonMin: 44, body: 14 },
  mobile: { label: "platform=MOBILE", buttonMin: 48, body: 13 }
};

const CONCEPT_VARIANTS = [
  { key: "desktopFlat", label: "Desktop flat", platform: "desktop", raised: false },
  { key: "mobileFlat", label: "Mobile flat", platform: "mobile", raised: false },
  { key: "mobileRaised", label: "Mobile raised", platform: "mobile", raised: true }
];

/* --- color utilities ------------------------------------------------------- */

function hexToRgb(hex) {
  const c = hex.replace("#", "");
  return {
    r: parseInt(c.slice(0, 2), 16),
    g: parseInt(c.slice(2, 4), 16),
    b: parseInt(c.slice(4, 6), 16)
  };
}

function rgbToHex({ r, g, b }) {
  const clamp = (v) => Math.max(0, Math.min(255, Math.round(v)));
  return `#${[r, g, b].map((v) => clamp(v).toString(16).padStart(2, "0")).join("")}`;
}

function mix(a, b, amount) {
  const ca = hexToRgb(a);
  const cb = hexToRgb(b);
  return rgbToHex({
    r: ca.r + (cb.r - ca.r) * amount,
    g: ca.g + (cb.g - ca.g) * amount,
    b: ca.b + (cb.b - ca.b) * amount
  });
}

function luminance(hex) {
  const { r, g, b } = hexToRgb(hex);
  const ch = (v) => {
    const n = v / 255;
    return n <= 0.04045 ? n / 12.92 : Math.pow((n + 0.055) / 1.055, 2.4);
  };
  return ch(r) * 0.2126 + ch(g) * 0.7152 + ch(b) * 0.0722;
}

/* --- token derivation per direction + platform ----------------------------- */

function spreadFactor(spread) {
  if (spread === "narrow") return 0.7;
  if (spread === "medium") return 1.0;
  if (spread === "wide") return 1.3;
  return 1.0;
}

function deriveSurfaceRamp(direction) {
  const base = direction.base_color;
  const f = spreadFactor(direction.shape.surface_spread);
  return {
    surface_base: base,
    surface_low: mix(base, "#000000", 0.18 * f),
    surface_panel: mix(base, "#ffffff", 0.06 * f),
    surface_high: mix(base, "#ffffff", 0.13 * f),
    surface_overlay: mix(base, "#ffffff", 0.20 * f),
    outline: mix(base, "#ffffff", 0.24 * f),
    offset: mix(base, "#000000", 0.55)
  };
}

function deriveTokens(direction, platformName, raisedFlag) {
  const base = direction.base_color;
  const accent = direction.accent_color;
  const ink = "#F7F8FB";
  const muted = "#B9C1D0";
  const ramp = deriveSurfaceRamp(direction);
  const s = direction.shape;
  const platform = PLATFORM_TOKENS[platformName];
  const markSize = platformName === "mobile" ? s.mark_size_mobile : s.mark_size_desktop;

  return {
    "--base": base,
    "--accent": accent,
    "--ink": ink,
    "--muted": muted,
    "--surface-base": ramp.surface_base,
    "--surface-low": ramp.surface_low,
    "--surface-panel": ramp.surface_panel,
    "--surface-high": ramp.surface_high,
    "--surface-overlay": ramp.surface_overlay,
    "--outline": ramp.outline,
    "--offset": ramp.offset,
    "--state-hover": mix(base, "#ffffff", Math.abs(s.hover_pct) / 100),
    "--state-pressed": mix(base, "#000000", Math.abs(s.pressed_pct) / 100),
    "--disabled-opacity": String(s.disabled_opacity),

    "--radius-base": `${s.r_base}px`,
    "--radius-chip": s.r_chip >= 999 ? "999px" : `${s.r_chip}px`,
    "--radius-button": s.r_button >= 999 ? "999px" : `${s.r_button}px`,
    "--radius-button-primary": s.r_button_primary >= 999 ? "999px" : `${s.r_button_primary}px`,
    "--radius-tab": s.r_tab >= 999 ? "999px" : `${s.r_tab}px`,
    "--radius-mark": `${s.r_mark}px`,

    "--button-pad-h": `${s.btn_pad_h}px`,
    "--button-pad-v": `${s.btn_pad_v}px`,
    "--button-pad-h-primary": `${s.btn_pad_h_primary}px`,
    "--button-pad-v-primary": `${s.btn_pad_v_primary}px`,

    "--mark-size": `${markSize}px`,

    "--density-padding": `${s.density_padding}px`,
    "--density-gap": `${s.density_gap}px`,
    "--card-gap": `${s.card_gap}px`,

    "--focus-thickness": `${s.focus_thickness}px`,
    "--focus-offset": `${s.focus_offset}px`,
    "--focus-color": accent,

    "--h1-weight": String(s.h1_weight),
    "--h2-weight": String(s.h2_weight),

    "--raised-primary-offset": `${s.raised_primary}px`,
    "--raised-tab-offset": `${s.raised_tab}px`,
    "--raised-row-offset": `${s.raised_row}px`,
    "--raised-secondary-offset": `${s.raised_secondary}px`,

    "--body-size": `${platform.body}px`,
    "--button-min": `${platform.buttonMin}px`
  };
}

function styleVars(tokens) {
  return Object.entries(tokens).map(([k, v]) => `${k}: ${v}`).join("; ");
}

/* --- artboard markup ------------------------------------------------------- */

function findDirection(name) {
  return NEOCADE_DIRECTIONS.find((d) => d.name.toLowerCase() === String(name).toLowerCase());
}

function conceptArtboard(direction, platformName, raisedFlag) {
  const tokens = deriveTokens(direction, platformName, raisedFlag);
  const platform = PLATFORM_TOKENS[platformName];
  const variantLabel = `${platformName === "mobile" ? "Mobile" : "Desktop"} ${raisedFlag ? "raised" : "flat"}`;
  const s = direction.shape;
  const dataAttrs = [
    `data-direction="${direction.name}"`,
    `data-platform="${platformName}"`,
    `data-raised="${raisedFlag}"`,
    `data-tab-shape="${s.tab_shape}"`,
    `data-mark-shape="${s.mark_shape}"`,
    `data-primary-strategy="${s.primary_strategy}"`,
    `data-ghost-strategy="${s.ghost_strategy}"`,
    `data-focus-style="${s.focus_style}"`,
    `data-kicker-style="${s.kicker}"`,
    `data-lift-tabs="${s.lift_tabs}"`,
    `data-lift-rows="${s.lift_rows}"`,
    `data-lift-secondary="${s.lift_secondary}"`
  ].join(" ");

  return `
    <article class="nc-artboard ${platformName} ${raisedFlag ? "mode-raised" : "mode-flat"}" ${dataAttrs} style="${styleVars(tokens)}">
      <header class="nc-art-top">
        <div class="nc-art-brand">
          <span class="nc-art-mark"></span>
          <div class="nc-art-brand-text">
            <b>${direction.name}</b>
            <small>${variantLabel} / ${platform.label} / ${direction.contrast}</small>
          </div>
        </div>
        <nav class="nc-art-tabs" aria-label="Top nav">
          <span class="nc-tab selected">Lobby</span>
          <span class="nc-tab">Cabinets</span>
          <span class="nc-tab">Profile</span>
          <span class="nc-tab">Settings</span>
        </nav>
      </header>

      <div class="nc-art-grid">
        <section class="nc-art-card nc-art-actions">
          <h2>01 Action panel</h2>
          <div class="nc-art-button-row">
            <span class="nc-art-button primary">Start</span>
            <span class="nc-art-button">Options</span>
            <span class="nc-art-button ghost">Cancel</span>
          </div>
          <label class="nc-art-label">Input focus</label>
          <div class="nc-art-input focused">Player alias</div>
          <div class="nc-art-toggle-line">
            <span class="nc-art-check"></span>
            <span>Checked</span>
            <span class="nc-art-switch"><i></i></span>
            <span>Voice</span>
          </div>
        </section>

        <section class="nc-art-card nc-art-dialog-stack">
          <h2>02 Dialog stack</h2>
          <div class="nc-art-segments">
            <span class="nc-tab selected">Lobby</span>
            <span class="nc-tab">Match</span>
            <span class="nc-tab">Audio</span>
          </div>
          <div class="nc-art-dialog">
            <b>Popup surface</b>
            <p>Primary action, secondary action, stable text field, and focus ring.</p>
            <div class="nc-art-progress"><span></span></div>
            <div class="nc-art-button-row">
              <span class="nc-art-button primary">Confirm</span>
              <span class="nc-art-button ghost">Back</span>
            </div>
          </div>
        </section>

        <section class="nc-art-card nc-art-list-tree">
          <h2>03 List / tree</h2>
          <div class="nc-art-list">
            <div class="nc-art-list-row selected"><span class="nc-dot"></span><b>Cabinet A</b><small>ready</small></div>
            <div class="nc-art-list-row"><span class="nc-dot"></span><b>Mini-game list</b><small>3 new</small></div>
            <div class="nc-art-list-row"><span class="nc-dot"></span><b>Settings row</b><small>stable</small></div>
          </div>
          <div class="nc-art-scrollbar"><i></i></div>
        </section>
      </div>

      <footer class="nc-art-bottom">
        <div class="nc-art-states">
          <span>normal</span>
          <span class="hover">hover</span>
          <span class="focus">focus</span>
          <span class="pressed">pressed</span>
          <span class="disabled">disabled</span>
        </div>
        <div class="nc-art-palette">
          <span style="background: var(--surface-low)"></span>
          <span style="background: var(--surface-panel)"></span>
          <span style="background: var(--surface-high)"></span>
          <span style="background: var(--accent)"></span>
        </div>
      </footer>
    </article>
  `;
}

/* --- gallery (concept page) ------------------------------------------------ */

function conceptFigure(direction, variant) {
  const src = direction.conceptImages[variant.key];
  const raisedLabel = variant.raised ? "raised=true" : "raised=false";
  return `
    <figure class="nc-concept-card" data-concept-variant="${variant.key}">
      <img src="${src}" alt="${direction.name} ${variant.label} fixed-layout dark UI mockup">
      <figcaption>${variant.label} / ${raisedLabel}</figcaption>
    </figure>
  `;
}

function conceptBrief(direction) {
  return `
    <div class="nc-title-row">
      <h2>${direction.name}</h2>
      <span class="nc-chip">base ${direction.base_color}</span>
      <span class="nc-chip">accent ${direction.accent_color}</span>
      <span class="nc-chip">WCAG ${direction.contrast}</span>
    </div>
    <p class="nc-board-copy">${direction.summary}</p>
    <div class="nc-specs">
      <div><b>Target use</b><span>${direction.target}</span></div>
      <div><b>Flat behavior</b><span>${direction.flat}</span></div>
      <div><b>Raised behavior</b><span>${direction.raised}</span></div>
      <div><b>Mobile note</b><span>${direction.mobile}</span></div>
    </div>
  `;
}

function fillDirectionSection(section, direction) {
  const conceptImages = section.querySelector("[data-concept-images]");
  const brief = section.querySelector("[data-concept-brief]");
  if (conceptImages && conceptImages.children.length === 0) {
    conceptImages.innerHTML = CONCEPT_VARIANTS.map((v) => conceptFigure(direction, v)).join("");
  }
  if (brief) {
    brief.innerHTML = conceptBrief(direction);
  }
}

function directionConcept(direction) {
  return `
    <section class="nc-direction-section" data-direction="${direction.name}">
      <div class="nc-concept-layout">
        <div class="nc-concept-image-grid" data-concept-images>
          ${CONCEPT_VARIANTS.map((v) => conceptFigure(direction, v)).join("")}
        </div>
        <div class="nc-concept-brief">
          ${conceptBrief(direction)}
        </div>
      </div>
    </section>
  `;
}

function renderConceptGallery() {
  const target = document.getElementById("conceptBoards");
  if (!target) return;
  const staticSections = [...target.querySelectorAll(".nc-direction-section[data-direction]")];
  if (staticSections.length > 0) {
    staticSections.forEach((section) => {
      const direction = findDirection(section.dataset.direction);
      if (direction) fillDirectionSection(section, direction);
    });
    return;
  }
  target.innerHTML = NEOCADE_DIRECTIONS.map(directionConcept).join("");
}

function renderConceptImage() {
  const target = document.getElementById("conceptImageMount");
  if (!target) return;
  const params = new URLSearchParams(window.location.search);
  const direction = findDirection(params.get("direction")) || NEOCADE_DIRECTIONS[0];
  const platformName = params.get("platform") === "mobile" ? "mobile" : "desktop";
  const raisedFlag = params.get("raised") === "true";
  target.innerHTML = conceptArtboard(direction, platformName, raisedFlag);
}

function renderFinalistPlaceholder() {
  const target = document.getElementById("finalistBoards");
  if (!target) return;
  target.innerHTML = `
    <section class="nc-empty">
      <h2>Plan 03 waits for finalist-selection.md</h2>
      <p>Once the user gate selects 1-3 finalists, this page will render each finalist in the full 4-grid: raised=false desktop, raised=false mobile, raised=true desktop, raised=true mobile, plus base_color and accent_color override previews.</p>
    </section>
  `;
}

function boot() {
  const page = document.querySelector("[data-gallery]");
  if (!page) return;
  if (page.dataset.gallery === "concept") renderConceptGallery();
  if (page.dataset.gallery === "concept-image") renderConceptImage();
  if (page.dataset.gallery === "finalist") renderFinalistPlaceholder();
}

if (typeof window !== "undefined") boot();
