"use strict";

const NEOCADE_DIRECTIONS = [
  {
    name: "Pulse",
    className: "PulseNeoCadeTheme",
    fileStem: "pulse_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/pulse-desktop-flat.png",
      mobileFlat: "concepts/pulse-mobile-flat.png",
      mobileRaised: "concepts/pulse-mobile-raised.png"
    },
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
    conceptImages: {
      desktopFlat: "concepts/slate-desktop-flat.png",
      mobileFlat: "concepts/slate-mobile-flat.png",
      mobileRaised: "concepts/slate-mobile-raised.png"
    },
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
    conceptImages: {
      desktopFlat: "concepts/bubble-desktop-flat.png",
      mobileFlat: "concepts/bubble-mobile-flat.png",
      mobileRaised: "concepts/bubble-mobile-raised.png"
    },
    base_color: "#241326",
    accent_color: "#FFB3E6",
    contrast: "10.74:1",
    radius: 16,
    raisedOffset: 5,
    summary: "Friendly mobile-game brightness on a dark berry arcade base with light pink actions.",
    target: "Casual games, cozy menus, tutorials, family-friendly mobile-first UI.",
    flat: "Rounded dark berry solid fills, generous state contrast, cheerful but sparse pink accent placement.",
    raised: "Buttons and selected playful affordances get 3-5px hard offsets; fields stay flat.",
    mobile: "Larger buttons and toggles with 44pt / 48dp minimum target thinking."
  },
  {
    name: "Daybreak",
    className: "DaybreakNeoCadeTheme",
    fileStem: "daybreak_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/daybreak-desktop-flat.png",
      mobileFlat: "concepts/daybreak-mobile-flat.png",
      mobileRaised: "concepts/daybreak-mobile-raised.png"
    },
    base_color: "#0B2420",
    accent_color: "#76F2D1",
    contrast: "11.96:1",
    radius: 12,
    raisedOffset: 3,
    summary: "Welcoming daylight arcade mood reworked as dark teal surfaces with mint wayfinding.",
    target: "Community hubs, onboarding flows, cozy game menus, bright mobile experiences.",
    flat: "Dark teal tonal surfaces with high-contrast mint for primary/focus/selection.",
    raised: "Primary actions and cards-as-actions lift; ordinary panels, lists, and fields stay flat.",
    mobile: "44pt / 48dp floors with extra breathing room around touch clusters."
  },
  {
    name: "Burst",
    className: "BurstNeoCadeTheme",
    fileStem: "burst_neocade_theme",
    conceptImages: {
      desktopFlat: "concepts/burst-desktop-flat.png",
      mobileFlat: "concepts/burst-mobile-flat.png",
      mobileRaised: "concepts/burst-mobile-raised.png"
    },
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

const CONCEPT_VARIANTS = [
  {
    key: "desktopFlat",
    label: "Desktop flat",
    platform: "desktop",
    raised: false
  },
  {
    key: "mobileFlat",
    label: "Mobile flat",
    platform: "mobile",
    raised: false
  },
  {
    key: "mobileRaised",
    label: "Mobile raised",
    platform: "mobile",
    raised: true
  }
];

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
    return normalized <= 0.04045
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

function controlPanel(direction, mode, platformName = "desktop", compact = false) {
  const platform = PLATFORM_TOKENS[platformName] || PLATFORM_TOKENS.desktop;
  const raisedFlag = mode === "raised";
  return `
    <article class="nc-board mode-${mode}${compact ? " compact" : ""}" style="${styleVars(deriveTokens(direction, platformName))}" data-direction="${direction.name}" data-raised="${raisedFlag}" data-platform="${platformName}">
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

function findDirection(name) {
  return NEOCADE_DIRECTIONS.find((direction) => direction.name.toLowerCase() === String(name).toLowerCase());
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
      <div><b>Future class</b><span>${direction.className}</span></div>
      <div><b>Target</b><span>${direction.target}</span></div>
      <div><b>Flat behavior</b><span>${direction.flat}</span></div>
      <div><b>Raised behavior</b><span>${direction.raised}</span></div>
    </div>
  `;
}

function fillDirectionSection(section, direction) {
  section.setAttribute("style", styleVars(deriveTokens(direction, "desktop")));
  const conceptImages = section.querySelector("[data-concept-images]");
  const brief = section.querySelector("[data-concept-brief]");
  const variants = section.querySelector("[data-variant-pair]");
  if (conceptImages && conceptImages.children.length === 0) {
    conceptImages.innerHTML = CONCEPT_VARIANTS.map((variant) => conceptFigure(direction, variant)).join("");
  }
  if (brief) {
    brief.innerHTML = conceptBrief(direction);
  }
  if (variants) {
    variants.innerHTML = `
      ${controlPanel(direction, "flat", "desktop", true)}
      ${controlPanel(direction, "raised", "desktop", true)}
    `;
  }
}

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

function directionConcept(direction) {
  const tokens = deriveTokens(direction, "desktop");
  return `
    <section class="nc-direction-section" style="${styleVars(tokens)}" data-direction="${direction.name}">
      <div class="nc-concept-layout">
        <div class="nc-concept-image-grid" data-concept-images>
          ${CONCEPT_VARIANTS.map((variant) => conceptFigure(direction, variant)).join("")}
        </div>
        <div class="nc-concept-brief">
          ${conceptBrief(direction)}
        </div>
      </div>
      <div class="nc-variant-pair">
        ${controlPanel(direction, "flat", "desktop", true)}
        ${controlPanel(direction, "raised", "desktop", true)}
      </div>
    </section>
  `;
}

function conceptArtboard(direction, platformName = "desktop", raisedFlag = false) {
  const tokens = deriveTokens(direction, platformName);
  const platform = PLATFORM_TOKENS[platformName] || PLATFORM_TOKENS.desktop;
  const variantLabel = `${platformName === "mobile" ? "Mobile" : "Desktop"} ${raisedFlag ? "raised" : "flat"}`;
  return `
    <article class="nc-artboard ${platformName} ${raisedFlag ? "mode-raised" : "mode-flat"}" style="${styleVars(tokens)}" data-direction="${direction.name}" data-platform="${platformName}" data-raised="${raisedFlag}" data-fixed-control-order="header-tabs action-panel input-toggle dialog-stack list-tree states-palette">
      <header class="nc-art-top">
        <div class="nc-art-brand">
          <span class="nc-art-mark"></span>
          <div>
            <b>${direction.name}</b>
            <small>${variantLabel} / ${platform.label} / ${direction.contrast}</small>
          </div>
        </div>
        <nav class="nc-art-tabs" aria-label="Fixed tabs">
          <span class="selected">Lobby</span>
          <span>Cabinets</span>
          <span>Profile</span>
          <span>Settings</span>
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
            <span class="selected">Lobby</span>
            <span>Match</span>
            <span>Audio</span>
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
          <div class="nc-art-list-row selected"><span></span><b>Cabinet A</b><small>ready</small></div>
          <div class="nc-art-list-row"><span></span><b>Mini-game list</b><small>3 new</small></div>
          <div class="nc-art-list-row"><span></span><b>Settings row</b><small>stable</small></div>
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
          <span style="background: var(--accent_color)"></span>
        </div>
      </footer>
    </article>
  `;
}

function renderConceptGallery() {
  const target = document.getElementById("conceptBoards");
  if (!target) return;
  const staticSections = [...target.querySelectorAll(".nc-direction-section[data-direction]")];
  if (staticSections.length > 0) {
    staticSections.forEach((section) => {
      const direction = findDirection(section.dataset.direction);
      if (direction) {
        fillDirectionSection(section, direction);
      }
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
  if (page.dataset.gallery === "concept-image") {
    renderConceptImage();
  }
  if (page.dataset.gallery === "finalist") {
    renderFinalistPlaceholder();
  }
}

boot();
