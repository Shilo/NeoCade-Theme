"use strict";

const NEOCADE_DIRECTIONS = [
  {
    name: "Pulse",
    className: "PulseNeoCadeTheme",
    fileStem: "pulse_neocade_theme",
    base_color: "#151A2E",
    accent_color: "#8BFF6A",
    contrast: "13.62:1",
    radius: 12,
    raisedOffset: 3,
    summary: "Dark saturated arcade energy with lively green action and focus roles.",
    target: "Multiplayer lobbies, action menus, active dark editor/runtime surfaces.",
    flat: "Solid tonal surfaces, accent reserved for primary actions and selected states.",
    raised: "Filled buttons and selected tabs gain small hard offsets; panels and inputs stay flat.",
    mobile: "44pt / 48dp target language with restrained bright accent use."
  },
  {
    name: "Slate",
    className: "SlateNeoCadeTheme",
    fileStem: "slate_neocade_theme",
    base_color: "#111820",
    accent_color: "#8BD3FF",
    contrast: "10.94:1",
    radius: 10,
    raisedOffset: 2,
    summary: "Calm modern minimal dark with sparse blue emphasis and polished rounding.",
    target: "Desktop tools, settings-heavy games, launchers, premium dark defaults.",
    flat: "Subtle tonal separation with accent only for primary, selection, caret, and focus.",
    raised: "Restrained 1-2px hard offset or stronger outline on primary button-like controls.",
    mobile: "Quiet palette with expanded button constants and high-contrast focus rings."
  },
  {
    name: "Bubble",
    className: "BubbleNeoCadeTheme",
    fileStem: "bubble_neocade_theme",
    base_color: "#FFF4FA",
    accent_color: "#7B1B55",
    contrast: "9.19:1",
    radius: 16,
    raisedOffset: 5,
    summary: "Friendly mobile-game brightness with soft candy-counter surfaces and berry actions.",
    target: "Casual games, cozy menus, tutorials, family-friendly mobile-first UI.",
    flat: "Rounded solid fills, generous state contrast, cheerful but sparse accent placement.",
    raised: "Buttons and selected playful affordances get 3-5px hard offsets; fields stay flat.",
    mobile: "Larger buttons and toggles with 44pt / 48dp minimum target thinking."
  },
  {
    name: "Daybreak",
    className: "DaybreakNeoCadeTheme",
    fileStem: "daybreak_neocade_theme",
    base_color: "#EAF7F1",
    accent_color: "#006A68",
    contrast: "5.85:1",
    radius: 12,
    raisedOffset: 3,
    summary: "Welcoming daylight arcade mood with mint surfaces and teal wayfinding.",
    target: "Community hubs, onboarding flows, cozy game menus, bright mobile experiences.",
    flat: "High-contrast teal for primary/focus/selection with quiet secondary surfaces.",
    raised: "Primary actions and cards-as-actions lift; ordinary panels, lists, and fields stay flat.",
    mobile: "44pt / 48dp floors with extra breathing room around touch clusters."
  },
  {
    name: "Burst",
    className: "BurstNeoCadeTheme",
    fileStem: "burst_neocade_theme",
    base_color: "#20112E",
    accent_color: "#FFD166",
    contrast: "12.33:1",
    radius: 14,
    raisedOffset: 4,
    summary: "Bold celebratory MD3 Expressive statement with deep plum and warm gold.",
    target: "Mini-game launchers, achievements, party-game menus, showcase scenes.",
    flat: "Disciplined dark surface ladder with accent for critical action, focus, and progress.",
    raised: "Stronger offsets on key buttons; dense rows, inputs, and range tracks stay stable.",
    mobile: "Large touch affordances with gold kept to high-value action and focus roles."
  }
];

const PLATFORM_TOKENS = {
  desktop: {
    label: "platform=DESKTOP",
    buttonMin: 40,
    body: 14,
    density: "dense desktop"
  },
  mobile: {
    label: "platform=MOBILE",
    buttonMin: 48,
    body: 16,
    density: "44pt / 48dp mobile"
  }
};

function hexToRgb(hex) {
  const clean = hex.replace("#", "");
  return {
    r: parseInt(clean.slice(0, 2), 16),
    g: parseInt(clean.slice(2, 4), 16),
    b: parseInt(clean.slice(4, 6), 16)
  };
}

function rgbToHex({ r, g, b }) {
  return `#${[r, g, b].map((v) => Math.round(v).toString(16).padStart(2, "0")).join("")}`;
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
  const channel = (value) => {
    const normalized = value / 255;
    return normalized <= 0.03928
      ? normalized / 12.92
      : Math.pow((normalized + 0.055) / 1.055, 2.4);
  };
  return channel(r) * 0.2126 + channel(g) * 0.7152 + channel(b) * 0.0722;
}

function deriveTokens(direction, platformName = "desktop") {
  const base = direction.base_color;
  const accent = direction.accent_color;
  const lightBase = luminance(base) > 0.56;
  const towardA = lightBase ? "#000000" : "#ffffff";
  const towardB = lightBase ? "#ffffff" : "#000000";
  const ink = lightBase ? "#17201C" : "#F7F8FB";
  const muted = lightBase ? "#52625B" : "#B9C1D0";
  const platform = PLATFORM_TOKENS[platformName] || PLATFORM_TOKENS.desktop;

  return {
    "--base_color": base,
    "--accent_color": accent,
    "--surface-base": base,
    "--surface-low": mix(base, towardB, lightBase ? 0.04 : 0.20),
    "--surface-panel": mix(base, towardA, lightBase ? 0.05 : 0.08),
    "--surface-high": mix(base, towardA, lightBase ? 0.12 : 0.16),
    "--surface-overlay": mix(base, towardA, lightBase ? 0.18 : 0.24),
    "--ink-local": ink,
    "--muted-local": muted,
    "--outline-local": mix(base, towardA, lightBase ? 0.28 : 0.30),
    "--offset-local": mix(base, "#000000", lightBase ? 0.18 : 0.42),
    "--state-hover": mix(base, accent, 0.16),
    "--state-pressed": mix(base, accent, 0.24),
    "--radius": `${direction.radius}px`,
    "--raised-offset": `${direction.raisedOffset}px`,
    "--body-size": `${platform.body}px`,
    "--button-min": `${platform.buttonMin}px`
  };
}

function styleVars(tokens) {
  return Object.entries(tokens).map(([key, value]) => `${key}: ${value}`).join("; ");
}

function controlPanel(direction, mode, platformName = "desktop") {
  const platform = PLATFORM_TOKENS[platformName] || PLATFORM_TOKENS.desktop;
  const raisedFlag = mode === "raised";
  return `
    <article class="nc-board mode-${mode}" style="${styleVars(deriveTokens(direction, platformName))}" data-direction="${direction.name}" data-raised="${raisedFlag}" data-platform="${platformName}">
      <div class="nc-board-head">
        <div>
          <div class="nc-title-row">
            <h2>${direction.name}</h2>
            <span class="nc-chip">${raisedFlag ? "raised=true" : "raised=false"}</span>
            <span class="nc-chip">${platform.label}</span>
          </div>
          <p class="nc-board-copy">${direction.summary}</p>
        </div>
        <div class="nc-specs">
          <div><b>base_color</b><span>${direction.base_color}</span></div>
          <div><b>accent_color</b><span>${direction.accent_color}</span></div>
          <div><b>Future class</b><span>${direction.className}</span></div>
          <div><b>Target</b><span>${direction.target}</span></div>
        </div>
      </div>
      <div class="nc-samples">
        <section class="nc-panel">
          <h3>Action hierarchy</h3>
          <div class="nc-actions">
            <span class="nc-button primary">Start</span>
            <span class="nc-button">Options</span>
            <span class="nc-button ghost">Cancel</span>
          </div>
          <div class="nc-control-stack">
            <div class="nc-field">
              <label>Input focus</label>
              <div class="nc-input focused">Player alias</div>
            </div>
            <div class="nc-toggle-row">
              <span class="nc-check"><span class="nc-box"></span>Checked</span>
              <span class="nc-toggle"><span class="nc-track"><span class="nc-thumb"></span></span>Voice</span>
            </div>
          </div>
        </section>
        <section class="nc-panel">
          <h3>Selection and dialog</h3>
          <div class="nc-tabs">
            <span class="nc-tab selected">Lobby</span>
            <span class="nc-tab">Cabinets</span>
            <span class="nc-tab">Profile</span>
          </div>
          <div class="nc-list">
            <div class="nc-list-row selected"><span class="nc-dot"></span><b>Cabinet A</b><small>ready</small></div>
            <div class="nc-list-row"><span class="nc-dot"></span><b>Mini-game list</b><small>3 new</small></div>
            <div class="nc-list-row"><span class="nc-dot"></span><b>Settings row</b><small>stable</small></div>
          </div>
          <div class="nc-dialog">
            <h3>Popup / dialog sample</h3>
            <p>Solid surface, readable state roles, action emphasis, no production implementation.</p>
            <div class="nc-actions">
              <span class="nc-button primary selected">Confirm</span>
              <span class="nc-button ghost">Back</span>
            </div>
          </div>
        </section>
        <section class="nc-panel">
          <h3>State samples</h3>
          <div class="nc-state-strip">
            <span class="nc-state">normal</span>
            <span class="nc-state hover">hover</span>
            <span class="nc-state focus">focus</span>
            <span class="nc-state pressed">pressed</span>
            <span class="nc-state disabled">disabled</span>
          </div>
          <div class="nc-swatch-grid">
            <div class="nc-swatch" style="background: var(--surface-low)"><b>surface low</b><span>${direction.fileStem}</span></div>
            <div class="nc-swatch" style="background: var(--surface-panel)"><b>surface panel</b><span>panel role</span></div>
            <div class="nc-swatch" style="background: var(--surface-high)"><b>surface high</b><span>raised role</span></div>
            <div class="nc-swatch" style="background: var(--accent_color); color: var(--surface-base)"><b>accent</b><span>focus/action</span></div>
          </div>
          <div class="nc-type"><b>Type and mobile</b><span>Inter roles, ${platform.density}, body ${platform.body}px, min target ${platform.buttonMin}px</span></div>
          <div class="nc-radius-row">
            <span class="nc-radius" style="border-radius: 4px"></span>
            <span class="nc-radius" style="border-radius: ${direction.radius}px"></span>
            <span class="nc-radius" style="border-radius: 999px"></span>
          </div>
        </section>
      </div>
    </article>
  `;
}

function renderConceptGallery() {
  const target = document.getElementById("conceptBoards");
  if (!target) return;
  target.innerHTML = NEOCADE_DIRECTIONS
    .flatMap((direction) => [
      controlPanel(direction, "flat", "desktop"),
      controlPanel(direction, "raised", "desktop")
    ])
    .join("");
}

function renderFinalistPlaceholder() {
  const target = document.getElementById("finalistBoards");
  if (!target) return;
  target.innerHTML = `
    <section class="nc-empty">
      <h2>Plan 03 waits for finalist-selection.md</h2>
      <p>Once the user gate selects 1-3 finalists, this page will render each finalist in the full 4-grid: raised=false desktop, raised=false mobile, raised=true desktop, raised=true mobile, plus base_color and accent_color override previews.</p>
      <div class="nc-actions">
        <span class="nc-button primary mobile-preview">platform=MOBILE preview target</span>
        <span class="nc-button ghost">raised=true support ready</span>
      </div>
    </section>
  `;
}

function boot() {
  const page = document.querySelector("[data-gallery]");
  if (!page) return;
  if (page.dataset.gallery === "concept") {
    renderConceptGallery();
  }
  if (page.dataset.gallery === "finalist") {
    renderFinalistPlaceholder();
  }
}

boot();
