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
      // Issue 3 (revision-2): radius spread is now 0/8/14/18/26 across the 5
      // directions. Pulse takes the 0px slot — cabinet hardware has square
      // edges and the most "sharp arcade" thing we can do is zero radius.
      r_base: 0, r_chip: 0, r_button: 0, r_button_primary: 0,
      r_tab: 0, r_mark: 0,
      btn_pad_h: 14, btn_pad_v: 10, btn_pad_h_primary: 14, btn_pad_v_primary: 10,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 18, density_gap: 10, card_gap: 14,
      focus_thickness: 2, focus_offset: 0,
      h1_weight: 800, h2_weight: 740, kicker: "uppercase-tracked-accent",
      surface_stops: 4, surface_spread: "wide",
      hover_pct: 6, pressed_pct: -10, disabled_opacity: 0.42,
      raised_primary: 3, raised_tab: 2, raised_row: 0, raised_secondary: 1,
      lift_tabs: true, lift_rows: false, lift_secondary: true,
      tab_shape: "rectangular-strip",
      mark_shape: "square-cabinet-bezel",
      primary_strategy: "bold-accent-fill-dark-text",
      ghost_strategy: "accent-outlined-accent-text",
      focus_style: "tight-cabinet-ring",
      // Rev-4 axis 11: surface alpha policy. Pulse stays 100% solid —
      // cabinet hardware, not glass UI.
      surface_alpha: { popup_surface: 1.00, panels: 1.00, buttons: 1.00, chrome: 1.00 }
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
      // Issue 3 (revision-2): bumped from 11 → 14 to lean further into the
      // "premium iPhone Settings panel" mood; sits between Daybreak (8) and
      // Burst (18) in the radius spread.
      r_base: 14, r_chip: 999, r_button: 14, r_button_primary: 14,
      r_tab: 999, r_mark: 14,
      btn_pad_h: 16, btn_pad_v: 11, btn_pad_h_primary: 18, btn_pad_v_primary: 12,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 22, density_gap: 14, card_gap: 18,
      focus_thickness: 2, focus_offset: 2,
      h1_weight: 720, h2_weight: 640, kicker: "small-caps-subtle",
      surface_stops: 3, surface_spread: "narrow",
      hover_pct: 4, pressed_pct: -6, disabled_opacity: 0.50,
      raised_primary: 2, raised_tab: 1, raised_row: 1, raised_secondary: 1,
      lift_tabs: true, lift_rows: true, lift_secondary: true,
      tab_shape: "rounded-pill",
      mark_shape: "rounded-square",
      primary_strategy: "quiet-pill-primary",
      ghost_strategy: "thin-accent-outline",
      focus_style: "ios-style-offset",
      // Rev-4 axis 11: 8% bleed-through on popup overlay only — iOS-premium
      // mood mirrors iOS NavigationBar/Sheet/modal-backdrop translucency
      // without sliding into glassmorphism (no backdrop blur in StyleBoxFlat).
      surface_alpha: { popup_surface: 0.92, panels: 1.00, buttons: 1.00, chrome: 1.00 }
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
    raised: "Buttons, selected tabs, selected rows and chips get 3-6px extruded offsets — pokes-out.",
    mobile: "Larger button targets, thicker focus rings, bouncy hover feel.",
    shape: {
      // Issue 3 (revision-2): bumped from 18 → 26 to push genuinely bubbly.
      // Combined with the per-color offset fix this should read as candy.
      // Brand mark uses 999 (true circle); primary button stays 999 (pill).
      r_base: 26, r_chip: 999, r_button: 26, r_button_primary: 999,
      r_tab: 999, r_mark: 999,
      btn_pad_h: 20, btn_pad_v: 14, btn_pad_h_primary: 22, btn_pad_v_primary: 15,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 22, density_gap: 14, card_gap: 18,
      focus_thickness: 3, focus_offset: 2,
      h1_weight: 800, h2_weight: 760, kicker: "uppercase-tracked-accent",
      surface_stops: 3, surface_spread: "medium",
      hover_pct: 8, pressed_pct: -10, disabled_opacity: 0.45,
      raised_primary: 6, raised_tab: 4, raised_row: 3, raised_secondary: 3,
      lift_tabs: true, lift_rows: true, lift_secondary: true,
      tab_shape: "fully-rounded-pill-large",
      mark_shape: "circle-or-squircle",
      primary_strategy: "pillowy-fully-rounded-primary",
      ghost_strategy: "rounded-ghost-thicker-outline",
      focus_style: "cheerful-chunky-ring",
      // Rev-4 axis 11: candy is opaque. Translucent candy reads as ice/gelatin.
      surface_alpha: { popup_surface: 1.00, panels: 1.00, buttons: 1.00, chrome: 1.00 }
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
      // Issue 3 (revision-2): trimmed from 13 → 8 to let halo decorations + airy
      // density + bright mint carry the daylight mood (not big radius).
      r_base: 8, r_chip: 8, r_button: 8, r_button_primary: 8,
      r_tab: 8, r_mark: 8,
      btn_pad_h: 18, btn_pad_v: 12, btn_pad_h_primary: 20, btn_pad_v_primary: 13,
      mark_size_desktop: 54, mark_size_mobile: 42,
      density_padding: 24, density_gap: 16, card_gap: 20,
      focus_thickness: 2, focus_offset: 2,
      h1_weight: 720, h2_weight: 660, kicker: "sentence-case-accent",
      surface_stops: 4, surface_spread: "medium",
      hover_pct: 6, pressed_pct: -6, disabled_opacity: 0.50,
      raised_primary: 3, raised_tab: 2, raised_row: 1, raised_secondary: 1,
      lift_tabs: true, lift_rows: true, lift_secondary: true,
      tab_shape: "rounded-rect",
      mark_shape: "rounded-square-with-halo",
      primary_strategy: "friendly-primary-generous-breathing",
      ghost_strategy: "soft-outline-ghost",
      focus_style: "airy-fresh-ring-with-mint-halo",
      // Rev-4 axis 11: airy welcoming-lobby mood. 4% bleed on panels + 10% on
      // popup overlay reads as airy lift; buttons stay solid for tappability.
      surface_alpha: { popup_surface: 0.90, panels: 0.96, buttons: 1.00, chrome: 1.00 }
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
      // Issue 3 (revision-2): base radius 18 (bold but not extreme); the drama
      // comes from the oversized primary radius (28), asymmetric tab, and chunky
      // brand mark — not from the base scalar.
      r_base: 18, r_chip: 16, r_button: 18, r_button_primary: 28,
      r_tab: 16, r_mark: 18,
      btn_pad_h: 20, btn_pad_v: 14, btn_pad_h_primary: 26, btn_pad_v_primary: 18,
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
      focus_style: "dramatic-event-ring",
      // Rev-4 axis 11: celebration posters are solid. Translucent achievement
      // surfaces feel weak — personality demands poster-grade opacity.
      surface_alpha: { popup_surface: 1.00, panels: 1.00, buttons: 1.00, chrome: 1.00 }
    }
  }
];

/* Platform sizing tokens — Issue 6 of MOCKUP-REVISION-2-HANDOFF.md.
 *
 * Desktop sits in the middle of "professional desktop game UI" density per
 * Steam (settings/library), Battle.net launcher, Epic Games Launcher, Discord,
 * Godot editor; mobile pulls floors directly from Material Design 3 component
 * specs (and is always >= iOS HIG floors so a single mobile artboard satisfies
 * both OSes).
 *
 * Sources verified at handoff time:
 *   https://m3.material.io/foundations/accessible-design/accessibility-basics
 *   https://m3.material.io/components/buttons/specs
 *   https://m3.material.io/components/text-fields/specs
 *   https://m3.material.io/components/lists/specs
 *   https://m3.material.io/styles/typography/type-scale-tokens
 *   https://developer.apple.com/design/human-interface-guidelines/buttons
 *   https://developer.apple.com/design/human-interface-guidelines/typography
 */
const PLATFORM_TOKENS = {
  desktop: {
    label: "platform=DESKTOP",
    buttonMin: 36,           // Steam settings buttons + Battle.net default chrome
    primaryButtonMin: 44,    // Battle.net Play / Steam Install hero button
    inputMin: 34,            // Steam-style search/filter input
    toggleMin: 22,           // Steam-comparable: small but visible
    checkboxSize: 18,        // standard desktop checkbox
    body: 14,                // Steam / Discord / Battle.net body
    label_: 12,              // smaller secondary labels (kicker, helper text)
    h1: 36,
    h2: 22,
    kicker: 12,
    rowMin: 36,              // Steam list-row density
    tabMin: 32,
    tapPadding: 8,
    densityScale: 1.0
  },
  mobile: {
    label: "platform=MOBILE",
    buttonMin: 48,           // M3 tap-target floor + WCAG 2.5.5 (AAA) + iOS HIG 44pt
    primaryButtonMin: 56,    // M3 Extended FAB height — primary-action emphasis
    inputMin: 56,            // M3 filled text field default
    toggleMin: 32,           // M3 Switch track height
    checkboxSize: 20,        // M3 visible box; full 48dp target via tapPadding
    body: 16,                // M3 Body Large (≈ iOS 17pt body @1x)
    label_: 14,              // M3 Label Medium (≈ iOS Footnote)
    h1: 32,                  // M3 Headline Large
    h2: 22,                  // M3 Title Large
    kicker: 13,              // M3 Label Small
    rowMin: 56,              // M3 list-item-one-line
    tabMin: 48,              // M3 Tabs default
    tapPadding: 12,          // hit-area expansion around small interactives
    densityScale: 1.5        // +50% inter-control gap on space.4+ (per architecture revision 2026-05-04)
  }
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

/**
 * Returns a CSS rgba() string for `hex` at the given alpha (0..1). Used for
 * rev-4 axis 11 selective-alpha tokens — Slate's popup overlay 92%, Daybreak's
 * popup 90% + panels 96%, others 100%. Anything at alpha=1.0 is visually
 * indistinguishable from the source hex; we still emit rgba() so downstream
 * CSS uses a single bg-token shape (no branching). See
 * MOCKUP-REVISION-4-HANDOFF.md "Tier 2 — per-direction subtle alpha".
 */
function rgba(hex, alpha) {
  const { r, g, b } = hexToRgb(hex);
  return `rgba(${r}, ${g}, ${b}, ${alpha})`;
}

function luminance(hex) {
  const { r, g, b } = hexToRgb(hex);
  const ch = (v) => {
    const n = v / 255;
    return n <= 0.04045 ? n / 12.92 : Math.pow((n + 0.055) / 1.055, 2.4);
  };
  return ch(r) * 0.2126 + ch(g) * 0.7152 + ch(b) * 0.0722;
}

/* HSL conversion + darken() helper — Issue 2 of MOCKUP-REVISION-2-HANDOFF.md.
 *
 * mix(hex, "#000000", pct) was producing "near-black" bottom edges on raised
 * elements regardless of element bg color (Neobrutalism look — explicitly
 * rejected by the user). Reducing HSL lightness preserves hue, so a pink
 * button gets a darker-pink offset (the user's PLAY-button reference).
 *
 * SUPERSEDED FOR OFFSET TOKENS by tintTowardBase() — see rev-3 handoff.
 * darken() relied on HSL lightness subtraction, which clamps to 0 on already-
 * dark surface colors (e.g. surface_panel ≈ L=10% minus 22 → L=0 → near-black).
 * tintTowardBase() mixes the element color toward the page base instead,
 * which never goes past the base lightness and preserves hue for both bright
 * accent fills AND already-dark surface colors. darken() is retained because
 * the legacy --offset alias (base_offset) still uses it for a distinct-from-
 * base sentinel color (no CSS rule actually consumes var(--offset) today). */
function rgbToHsl({ r, g, b }) {
  const rn = r / 255, gn = g / 255, bn = b / 255;
  const max = Math.max(rn, gn, bn);
  const min = Math.min(rn, gn, bn);
  const l = (max + min) / 2;
  let h = 0, s = 0;
  if (max !== min) {
    const d = max - min;
    s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
    switch (max) {
      case rn: h = (gn - bn) / d + (gn < bn ? 6 : 0); break;
      case gn: h = (bn - rn) / d + 2; break;
      case bn: h = (rn - gn) / d + 4; break;
    }
    h /= 6;
  }
  return { h, s, l };
}

function hslToRgb({ h, s, l }) {
  if (s === 0) {
    const v = Math.round(l * 255);
    return { r: v, g: v, b: v };
  }
  const hueToRgb = (p, q, t) => {
    if (t < 0) t += 1;
    if (t > 1) t -= 1;
    if (t < 1 / 6) return p + (q - p) * 6 * t;
    if (t < 1 / 2) return q;
    if (t < 2 / 3) return p + (q - p) * (2 / 3 - t) * 6;
    return p;
  };
  const q = l < 0.5 ? l * (1 + s) : l + s - l * s;
  const p = 2 * l - q;
  return {
    r: Math.round(hueToRgb(p, q, h + 1 / 3) * 255),
    g: Math.round(hueToRgb(p, q, h) * 255),
    b: Math.round(hueToRgb(p, q, h - 1 / 3) * 255)
  };
}

/**
 * Returns hex `color` with HSL lightness reduced by `percent` (0..100).
 * The bottom-edge offset of a raised element should be the SAME hue as the
 * element bg, just darker — never near-black. ~22% is the default per the
 * handoff; smaller for already-light surfaces (overlay) where 22% goes too far.
 *
 * NOTE (rev-3): no longer used for the per-color offset tokens. See
 * tintTowardBase() below. Retained for the legacy --offset alias.
 */
function darken(hex, percent) {
  const { h, s, l } = rgbToHsl(hexToRgb(hex));
  const newL = Math.max(0, l - percent / 100);
  return rgbToHex(hslToRgb({ h, s, l: newL }));
}

/**
 * Returns `elementHex` mixed `ratio` of the way toward `baseHex` — i.e., the
 * element's color shifted partway toward the page background. This is the
 * rev-3 replacement for `darken()` on the per-color offset tokens.
 *
 * Why mix-with-base, not HSL-darken:
 *   darken() floors at L=0, so already-dark surface colors (e.g., Bubble's
 *   surface_panel ≈ L=10%) lose hue and render near-black at -22%, which the
 *   user calls "Neobrutalism" and rejects. Mixing toward base preserves hue
 *   at every brightness — bright accents shift toward base (= darker accent in
 *   the same hue family), already-dark surfaces shift gently toward base
 *   (= subtly different in the same family, never past base, never black).
 *
 * Default ratio 0.40 per MOCKUP-REVISION-3-HANDOFF.md. Tune to 0.30..0.55 if
 * surface offsets read too prominent (lower) or too subtle (higher).
 */
function tintTowardBase(elementHex, baseHex, ratio = 0.40) {
  return mix(elementHex, baseHex, ratio);
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
  const accent = direction.accent_color;
  const f = spreadFactor(direction.shape.surface_spread);
  /* Luminance-derived light-mode flag — mirrors the production NeoCadeTheme
   * `var is_light: bool = base_color.get_luminance() >= 0.5` semantics from the
   * 2026-05-06f architecture revision. When base_color is light, the surface
   * ramp's "elevated container" tints flip from mix-with-white (lifts above
   * dark base) to mix-with-black (sinks below light base) so containers stay
   * distinguishable from the page color. surface_low remains mix-with-black in
   * both modes — it's the recessed shadow color and reads as "below" regardless
   * of mode. Outline flips with the elevated tier. */
  const isLight = luminance(base) >= 0.5;
  const elevateTarget = isLight ? "#000000" : "#ffffff";
  const surface_base = base;
  const surface_low = mix(base, "#000000", 0.18 * f);
  const surface_panel = mix(base, elevateTarget, 0.06 * f);
  const surface_high = mix(base, elevateTarget, 0.13 * f);
  const surface_overlay = mix(base, elevateTarget, 0.20 * f);
  const outline = mix(base, elevateTarget, 0.24 * f);
  return {
    surface_base,
    surface_low,
    surface_panel,
    surface_high,
    surface_overlay,
    outline,
    /* Per-color offset tokens (rev-3) — each raised element's bottom edge is a
     * tinted variant of its OWN bg, mixed 40% toward the page base. Preserves
     * hue at every brightness AND never goes past base on already-dark
     * surfaces (the rev-2 darken-floored-at-0 → near-black panel-edge bug
     * called out in MOCKUP-REVISION-3-HANDOFF.md). Verify visually: every
     * raised element's bottom edge sits in its own hue family, never black.
     *
     * base_offset is intentionally left on darken() — it backs the legacy
     * --offset alias and should remain distinct from base; tintTowardBase
     * (base, base, 0.40) would degenerate to base itself. No CSS rule consumes
     * var(--offset) today, but a future rule's fallback should not be the
     * exact page color. */
    accent_offset: tintTowardBase(accent, base, 0.40),
    surface_high_offset: tintTowardBase(surface_high, base, 0.40),
    surface_panel_offset: tintTowardBase(surface_panel, base, 0.40),
    surface_overlay_offset: tintTowardBase(surface_overlay, base, 0.40),
    surface_low_offset: tintTowardBase(surface_low, base, 0.40),
    base_offset: darken(base, 22)
  };
}

function deriveTokens(direction, platformName, raisedFlag) {
  const base = direction.base_color;
  const accent = direction.accent_color;
  /* Luminance-derived light-mode flag (matches production
   * `is_light: bool = base_color.get_luminance() >= 0.5`). v1 directions are
   * all dark; this branch only fires for color overrides that swap to a light
   * base. Ink and muted flip to dark so text remains legible on light bases.
   * Production NeoCadeTheme's text-color generator follows the same rule. */
  const isLight = luminance(base) >= 0.5;
  const ink = isLight ? "#1B2230" : "#F7F8FB";
  const muted = isLight ? "#5A6478" : "#B9C1D0";
  const ramp = deriveSurfaceRamp(direction);
  const s = direction.shape;
  const platform = PLATFORM_TOKENS[platformName];
  const markSize = platformName === "mobile" ? s.mark_size_mobile : s.mark_size_desktop;
  /* Inner-highlight rim color for raised primary buttons (Issue 2 optional rim
   * recommendation in the handoff). Half-mix with white reads as a 1px lighter
   * top edge — the "inner highlight" you see on the user's PLAY-button reference. */
  const accent_rim = mix(accent, "#ffffff", 0.5);
  /* Rev-4 axis 11: surface alpha policy. Default to fully solid if a direction
   * predates the axis (defensive — every direction in v1 declares it). Only
   * popup_surface and panels currently consume alpha; buttons + chrome are
   * fixed at 1.0 per handoff (Don't-do list — translucent buttons read as
   * outlined-ghost variants and conflict with all 5 v1 personalities). */
  const sa = s.surface_alpha || { popup_surface: 1.0, panels: 1.0, buttons: 1.0, chrome: 1.0 };

  return {
    "--base": base,
    "--accent": accent,
    "--accent-rim": accent_rim,
    "--ink": ink,
    "--muted": muted,
    "--surface-base": ramp.surface_base,
    "--surface-low": ramp.surface_low,
    "--surface-panel": ramp.surface_panel,
    "--surface-high": ramp.surface_high,
    "--surface-overlay": ramp.surface_overlay,
    "--outline": ramp.outline,
    /* Alpha-aware bg tokens (rev-4 axis 11). Consumed by `.nc-art-card` and
     * `.nc-art-dialog` to render at the per-direction surface_alpha policy.
     * The base hex tokens (--surface-panel, --surface-overlay) above remain
     * available for any rule that needs the SOLID color (e.g., the footer
     * palette swatches in the artboard, where the swatch shows the color
     * itself, not the rendered alpha). */
    "--popup-surface-bg": rgba(ramp.surface_overlay, sa.popup_surface),
    "--panel-surface-bg": rgba(ramp.surface_panel, sa.panels),
    "--popup-surface-alpha": String(sa.popup_surface),
    "--panel-surface-alpha": String(sa.panels),
    /* Per-color offset tokens — each raised element's bottom edge is a darker
     * variant of its own bg color (Issue 2). The legacy --offset alias is
     * retained at the base-darker variant for any rule that has not yet been
     * migrated; new raised CSS targets the per-color offsets directly. */
    "--accent-offset": ramp.accent_offset,
    "--surface-high-offset": ramp.surface_high_offset,
    "--surface-panel-offset": ramp.surface_panel_offset,
    "--surface-overlay-offset": ramp.surface_overlay_offset,
    "--surface-low-offset": ramp.surface_low_offset,
    "--offset": ramp.base_offset,
    /* State-layer mix targets flip on is_light. Dark mode: hover lightens
     * (toward white = "lift"), pressed darkens. Light mode: hover darkens
     * (toward black = "press"-style emphasis cue, matching M3 light spec where
     * state layers are on-surface tint = dark on light), pressed darkens
     * further. */
    "--state-hover": mix(base, isLight ? "#000000" : "#ffffff", Math.abs(s.hover_pct) / 100),
    "--state-pressed": mix(base, "#000000", Math.abs(s.pressed_pct) / 100),
    "--disabled-opacity": String(s.disabled_opacity),

    "--radius-base": `${s.r_base}px`,
    "--radius-chip": s.r_chip >= 999 ? "999px" : `${s.r_chip}px`,
    "--radius-button": s.r_button >= 999 ? "999px" : `${s.r_button}px`,
    "--radius-button-primary": s.r_button_primary >= 999 ? "999px" : `${s.r_button_primary}px`,
    "--radius-tab": s.r_tab >= 999 ? "999px" : `${s.r_tab}px`,
    "--radius-mark": s.r_mark >= 999 ? "999px" : `${s.r_mark}px`,

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

    /* Raised offset depths per axis-10 of the direction's shape language.
     * --raise-strength is the scalar; specific variant tokens are derived from
     * it in the artboard CSS (e.g., --raise-dialog = strength * 1.3). */
    "--raise-strength": `${s.raised_primary}px`,
    "--raised-primary-offset": `${s.raised_primary}px`,
    "--raised-tab-offset": `${s.raised_tab}px`,
    "--raised-row-offset": `${s.raised_row}px`,
    "--raised-secondary-offset": `${s.raised_secondary}px`,

    /* Platform sizing variables — Issue 6. The .nc-artboard.mobile selector
     * does NOT downward-override these; every variable carries the platform's
     * floor and the base CSS rule consumes them directly. */
    "--button-min": `${platform.buttonMin}px`,
    "--button-min-primary": `${platform.primaryButtonMin}px`,
    "--input-min": `${platform.inputMin}px`,
    "--toggle-min": `${platform.toggleMin}px`,
    "--checkbox-size": `${platform.checkboxSize}px`,
    "--body-size": `${platform.body}px`,
    "--label-size": `${platform.label_}px`,
    "--h1-size": `${platform.h1}px`,
    "--h2-size": `${platform.h2}px`,
    "--kicker-size": `${platform.kicker}px`,
    "--row-min": `${platform.rowMin}px`,
    "--tab-min": `${platform.tabMin}px`,
    "--tap-padding": `${platform.tapPadding}px`,
    "--density-scale": String(platform.densityScale)
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
  // No direction param = a human opened this internal render template directly.
  // Show a friendly redirect notice instead of silently defaulting to Pulse.
  if (!params.get("direction")) {
    target.innerHTML = `
      <section class="nc-empty" style="max-width: 720px; margin: 64px auto; padding: 32px;">
        <h2 style="margin: 0 0 12px;">This is an internal render template</h2>
        <p style="margin: 0 0 16px; color: var(--muted);">
          <code>concept-image.html</code> is a single-artboard mount used by
          <code>render.js</code> to render one direction at a time, parameterized via
          <code>?direction=&amp;platform=&amp;raised=</code>. It is not meant to be
          opened directly for review.
        </p>
        <p style="margin: 0 0 16px;">
          To review the 5 directions, open one of these instead:
        </p>
        <ul style="margin: 0 0 16px; padding-left: 20px; line-height: 1.7;">
          <li><a href="concept-gallery.html"><strong>concept-gallery.html</strong></a> — all 5 directions side-by-side with their briefs (richest review)</li>
          <li><code>concepts/*.png</code> — pre-rendered 15 PNGs (open in any image viewer)</li>
          <li><code>screenshots/color-overview.png</code> — composite of all 5 desktop-flat artboards</li>
          <li><code>screenshots/greyscale-sufficiency-test.png</code> — D-30 audit composite (greyscale)</li>
        </ul>
        <p style="margin: 0; color: var(--muted); font-size: 0.9rem;">
          If you really want to render a single direction here for debugging, append e.g.
          <code>?direction=Pulse&amp;platform=desktop&amp;raised=false</code> to the URL.
        </p>
      </section>
    `;
    return;
  }
  const direction = findDirection(params.get("direction")) || NEOCADE_DIRECTIONS[0];
  const platformName = params.get("platform") === "mobile" ? "mobile" : "desktop";
  const raisedFlag = params.get("raised") === "true";
  // Plan 03 (finalist 4-grid): optional base_color / accent_color overrides via
  // ?base=#RRGGBB&accent=#RRGGBB (URL-encoded if needed; %23 == "#"). When both
  // are supplied the artboard renders a color-override variant of the named
  // direction — same shape language, different palette. Demonstrates the
  // dynamic NeoCadeTheme @export base_color / accent_color contract for D-14.
  const baseOverride = params.get("base");
  const accentOverride = params.get("accent");
  let activeDirection = direction;
  if (baseOverride && /^#[0-9a-fA-F]{6}$/.test(baseOverride) &&
      accentOverride && /^#[0-9a-fA-F]{6}$/.test(accentOverride)) {
    activeDirection = Object.assign({}, direction, {
      base_color: baseOverride,
      accent_color: accentOverride,
      // Override label: distinguish color-override variants from the canonical
      // direction render. The variant label still includes Desktop/Mobile and
      // flat/raised so the artboard caption stays informative.
      contrast: `${baseOverride} / ${accentOverride}`
    });
  }
  target.innerHTML = conceptArtboard(activeDirection, platformName, raisedFlag);
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

/* Slideshow — Issue 4 of MOCKUP-REVISION-2-HANDOFF.md.
 *
 * Top-of-page A/B comparison view: ←/→ keys (or click) cycle through the 5
 * desktop-flat PNGs with NO transition (instant swap). All 5 PNGs are
 * preloaded on first paint so subsequent swaps are tab-cache fast.
 *
 * Per-direction "mood" phrases below are the *inspirational compass points*
 * from Issue 5 of the handoff — short labels that tell the reviewer what
 * vibe each direction is aiming for. They are not imitation contracts. */
const SLIDESHOW_MOODS = {
  Pulse: "cabinet control panel",
  Slate: "premium tool app",
  Bubble: "cozy mobile game",
  Daybreak: "community lobby",
  Burst: "achievement screen"
};

function bindSlideshow() {
  const root = document.querySelector("[data-slideshow]");
  if (!root) return;

  const directions = NEOCADE_DIRECTIONS;
  const img = root.querySelector("[data-slideshow-image]");
  const name = root.querySelector("[data-slideshow-name]");
  const mood = root.querySelector("[data-slideshow-mood]");
  const tabs = root.querySelector("[data-slideshow-tabs]");
  let i = 0;

  // Build tab buttons once per direction.
  directions.forEach((d, idx) => {
    const btn = document.createElement("button");
    btn.type = "button";
    btn.role = "tab";
    btn.textContent = d.name;
    btn.dataset.index = String(idx);
    btn.addEventListener("click", () => set(idx));
    tabs.appendChild(btn);
  });

  function set(next) {
    i = (next + directions.length) % directions.length;
    const d = directions[i];
    // Direct src swap — preloaded above, so the browser cache returns instantly.
    img.src = d.conceptImages.desktopFlat;
    img.alt = `${d.name} desktop flat mockup — ${SLIDESHOW_MOODS[d.name] || ""}`;
    name.textContent = d.name;
    mood.textContent = SLIDESHOW_MOODS[d.name] || "";
    tabs.querySelectorAll("button").forEach((b, idx) => {
      b.setAttribute("aria-selected", String(idx === i));
    });
  }

  root.querySelector("[data-slideshow-prev]").addEventListener("click", () => set(i - 1));
  root.querySelector("[data-slideshow-next]").addEventListener("click", () => set(i + 1));

  // Global ←/→ shortcuts (skip when an input is focused).
  document.addEventListener("keydown", (e) => {
    if (e.target.matches("input, textarea")) return;
    if (e.key === "ArrowLeft")  { e.preventDefault(); set(i - 1); }
    if (e.key === "ArrowRight") { e.preventDefault(); set(i + 1); }
  });

  // Pre-load all 5 desktop PNGs so future swaps are instant.
  directions.forEach((d) => {
    const pre = new Image();
    pre.src = d.conceptImages.desktopFlat;
  });

  set(0);
}

function boot() {
  const page = document.querySelector("[data-gallery]");
  if (!page) return;
  if (page.dataset.gallery === "concept") {
    renderConceptGallery();
    bindSlideshow();
  }
  if (page.dataset.gallery === "concept-image") renderConceptImage();
  if (page.dataset.gallery === "finalist") renderFinalistPlaceholder();
}

if (typeof window !== "undefined") boot();
