# NeoCade Design Tokens — Phase 4 Implementation Contract

**Status:** APPROVED — Phase 3.4 user-approval gate closed 2026-05-06.
**Version:** 1.1 (docs sync, 2026-05-13).
**Architecture:** Single concrete `NeoCadeTheme` class + one canonical `addons/neocade_theme/neocade_theme.tres` resource with built-in styles selected by `NeoCadeTheme.Style`.
**Consumed by:** Phase 4 (`addons/neocade_theme/scripts/neocade_theme.gd` + canonical `.tres`), Phases 5-7 (Control coverage), Phase 8 (mobile branch), Phase 9 (showcase), Phase 12 (signature visual moves), Phase 13 (role variations).
**Hard precondition:** Phase 4 may NOT begin until `/gsd-verify-work` of Phase 3.4 passes.

This document is the **single source of truth** for token values, formulas, and the `NeoCadeTheme` class contract. It reflects the current implementation as of 2026-05-13: 12 public exports, one canonical resource, five built-in styles, and additive Phase 12/13 visual-role work. Historical Phase 4 text that referred to five peer `.tres` files is superseded here.

**Implemented color-identity rework note (2026-05-13):** the public color contract is now `style + source_color`. The old `base_color` / `accent_color` public API was removed intentionally without backwards compatibility. `.planning/research/THEME-COLOR-IDENTITY-RETHINK.md` and `.planning/phases/14-source-color-role-palette-rework/14-IMPLEMENTATION-PLAN.md` are the active authorities for color generation, preset `source_color` values, fill roles, and contrast-safe `on_*` foregrounds. Older base/accent tables and formulas in this document are historical unless explicitly restated in the Phase 14 source-color materials. Shape, spacing, flat/raised constraints, no-texture rules, and single-resource architecture remain binding until explicitly changed.

---

## §1 Provenance and approval gate

**Phase 3.4 final approval (gate closure):** 2026-05-06. Documented in `.planning/mockups/3.4/final-approval.md` (frontmatter `gate: phase-3.4-plan-03-task-4`, `status: closed`, `selection_kind: all-five-ship + recommended-starter`).

**Approval boundary:** the Phase 3.4 mockup gate is a hard `[x]` PROJECT.md constraint. Phase 4 production `.tres` styling commits cannot occur on the branch until the gate is closed AND this document is written.

### Source artifacts (Phase 3.4 outputs that fed this contract)

| Artifact | Purpose |
|---|---|
| `.planning/mockups/3.4/final-approval.md` | gate-closure record; approved themes + recommended starter |
| `.planning/mockups/3.4/finalist-gallery.html` | Pulse 4-grid (flat × raised × desktop × mobile) + 3 color overrides + embedded coverage matrix |
| `.planning/mockups/3.4/coverage-matrix.md` | 40 Godot 4.6 user-facing Control classes + Pitfall 1.1 state combos |
| `.planning/mockups/3.4/render-check.md` | anti-cyberpunk / anti-texture / mobile / `is_light` flag wiring audits |
| `.planning/mockups/3.4/data/directions.json` | per-direction `shape_language` blocks (10 axes per direction) |
| `.planning/mockups/3.4/src/neocade-mockups.js` | the renderer's surface-ramp + state-layer + tintTowardBase + is_light formulas (Phase 4 implementation reference) |

### Upstream research artifacts

| Artifact | Used for |
|---|---|
| `.planning/research/THEME-DIRECTIONS.md` (Revision Round 2/2 dark-only) | locked palettes for the 5 v1 directions |
| `.planning/research/MD3-RESEARCH.md` | M3 / MD3 Expressive grammar, type scale, role tokens, state layers |
| `.planning/research/FLAT-3D-UI-RESEARCH.md` | extruded-flat raised-mode StyleBoxFlat translation |
| `.planning/research/GODOT-DYNAMIC-THEME-RESEARCH.md` | Architecture Recipe for Phase 4 |
| `.planning/spikes/dynamic-theme/VERIFY-RESULTS.md` | Phase 3.2 6/6 strict feasibility gate PASS evidence |
| `.planning/research/MINIMAL-THEME-DISSECTION.md` | godot-minimal-theme `_get_base_color` formula reference |
| `.planning/research/FONT-REVIEW.md` (UD-4 Option D) | Inter Variable Roman bundling, no italics, no Outfit/Noto/JetBrains |
| `.planning/research/PITFALLS.md` Pitfall 1.1 | state-combo handling discipline |
| `.planning/research/CROSS-PLATFORM.md` | mobile sizing floors + per-target validation context |
| `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CONTEXT.md` | D-01..D-27 |
| `.planning/phases/03.4-visual-direction-flat-extruded-flat-mockup-approval-gate/03.4-CORRECTIVE-ADDENDUM.md` | D-28..D-31 binding (greyscale sufficiency, single-concrete-class, recommended-starter reframing) |

---

## §2 Approved final themes

All five candidate directions from Phase 3.3 (Revision Round 2/2 dark-only) are approved for v1 ship as **built-in styles** on the single concrete `NeoCadeTheme` class. None deferred. All five satisfy WCAG 2.1 AA at body text against `base_color`.

| Direction | base_color | accent_color | WCAG ratio (accent on base) | Personality | v1 ship status |
|---|---|---|---|---|---|
| Pulse    | `#151A2E` | `#8BFF6A` | 13.62:1 | Vibrant arcade hall — cabinet-bezel chrome, lit primaries, packed control deck | approved · **recommended starter** (Phase 4 implements first) |
| Slate    | `#111820` | `#8BD3FF` | 10.94:1 | Premium dark default — restrained accent, quiet confident rounded chrome | approved · v1 personality variation |
| Bubble   | `#241326` | `#FFB3E6` | 10.74:1 | Playful candy-counter at night — pillowy rounded chrome and cheerful warmth | approved · v1 personality variation |
| Daybreak | `#0B2420` | `#76F2D1` | 11.96:1 | Fresh evening lobby — dark teal surfaces with bright mint wayfinding, airy spacing | approved · v1 personality variation |
| Burst    | `#20112E` | `#FFD166` | 12.33:1 | Celebratory MD3 Expressive max — high-contrast statement primary, asymmetric mark, bold gold | approved · v1 personality variation |

The old "v1 ships N user-approved theme `.tres` files" wording is superseded: v1 ships **one** canonical `.tres` with **five** user-approved built-in styles.

**Direction integrity rule:** the five built-in style names, shape languages, spacing personalities, flat/raised behavior, no-texture constraints, and single-resource architecture remain locked. The historical `base_color`/`accent_color` palettes in this document describe the current shipped implementation, but they are no longer the authority for the approved color rework. `.planning/research/THEME-COLOR-IDENTITY-RETHINK.md` owns the next implementation's color generation, preset `source_color` values, and role-palette identity. Polish passes live in `STYLE_PERSONALITY` / `STYLE_EXPORTS` and BINDING_TABLE recipes, not as new public exports or ad hoc palette swaps.

---

## §3 Recommended starter designation

**The v1 recommended starter is Pulse.**

### What "recommended starter" means under D-31

CONTEXT.md D-16/D-17 originally said the Phase 3.4 user pick "becomes `NeoCadeTheme`'s defaults" (so `NeoCadeTheme.new()` would produce the picked direction's style). Track 5 / D-31 (2026-05-06e) rewrote that. Under the locked single-concrete-class architecture, the recommended starter has only **two soft commitments**:

1. **Canonical resource default** — `addons/neocade_theme/neocade_theme.tres` has `style = NeoCadeTheme.Style.PULSE`.
2. **Showcase scene default** — `showcase/showcase.gd` applies the canonical resource to the root Control, and the theme picker starts from the current target theme.
3. **README "try this first" suggestion** — addon README names Pulse as the suggested starting style for new consumers who don't have a preference.

### What "recommended starter" does NOT mean

- It does **NOT** give Pulse architectural privilege over Slate / Bubble / Daybreak / Burst; all five are peers behind `NeoCadeTheme.Style`.
- It does **NOT** require a separate "starter" file. There is no `recommended_starter_neocade_theme.tres` and no `pulse_neocade_theme.tres`; the role is performed by `neocade_theme.tres` with `style = PULSE`.

### Class default policy

`NeoCadeTheme` class `@export` defaults now match the canonical starter state: `style = PULSE`, `raised = false`, `platform = AUTO`, `source_color = Color("#3AA8FF")`, `corner_radius = 0`, `spacing = 14`, `raised_strength = 2`, `focus_thickness = 2`, `outline_width = 1`, `use_runtime_popup_selection_icons = true`, and `texture_cache = false`.

---

## §4 Shared `NeoCadeTheme` class contract

`addons/neocade_theme/scripts/neocade_theme.gd` is the **single, concrete, instantiable** `@tool class_name NeoCadeTheme extends Theme`. Users can duplicate the canonical resource or `NeoCadeTheme.new()` to author custom themes. Built-in direction values are applied through `NeoCadeTheme.Style` and the internal `STYLE_EXPORTS` / `STYLE_PERSONALITY` tables. **No `@abstract`, no per-direction `.gd` subclasses, no per-style `.tres` files, no class hierarchy.**

### 4.1 The 11 `@export` properties (current 2026-05-13)

The export set is **intentionally minimal** — limited to values consumers should be able to tune across the entire theme. Per-direction unique mood lives in internal style/personality tables, not in additional public exports.

| # | Property | Type | Group | Default | Range / Notes |
|---|---|---|---|---|---|
| 1 | `style` | `Style` enum | Top level | `Style.PULSE` | `{BUBBLE, BURST, DAYBREAK, PULSE, SLATE, CUSTOM}`; built-in styles apply export values and hidden personality. |
| 2 | `raised` | `bool` | Top level | `false` | `false` = flat MD3, `true` = extruded-flat where recipes opt in. |
| 3 | `platform` | `Platform` enum | Top level | `Platform.AUTO` | `{DESKTOP=0, MOBILE=1, AUTO=2}`; AUTO resolves via `OS.has_feature("mobile")`. |
| 4 | `source_color` | `Color` | Style Overrides | `#3AA8FF` | Single public color input; setter regenerates the per-style role palette and may switch to `CUSTOM` if it no longer matches a built-in style. |
| 5 | `corner_radius` | `int` | Style Overrides | `0` | px; integer pixels only. Built-in styles overwrite this through `STYLE_EXPORTS`. |
| 6 | `spacing` | `int` | Style Overrides | `14` | px; base spacing value; mobile branch scales through platform tokens. |
| 7 | `raised_strength` | `int` | Style Overrides | `2` | px multiplier for raised offsets when `raised=true`. |
| 8 | `focus_thickness` | `int` | Style Overrides | `2` | px; outer focus-ring thickness. |
| 9 | `outline_width` | `int` | Style Overrides | `1` | px; default outline/hairline width. |
| 10 | `use_runtime_popup_selection_icons` | `bool` | Advanced | `true` | Generates tiny PopupMenu check/radio icons at runtime so selection fills match current colors. |
| 11 | `texture_cache` | `bool` | Advanced | `false` | Keeps loaded/generated textures across regenerations when enabled; a temporary per-pass cache is still used when disabled. |

### 4.2 Naming discipline (current)

- `corner_radius_base` → `corner_radius` (no redundant `_base` suffix; the term IS the base radius).
- `base_spacing` → `spacing` (no redundant `base_` prefix).
- `raised_offset` → `raised_strength` (intuitive verb; "strength" implies the scalar from which regular offsets derive).
- Group label is `"Style Overrides"` for user-facing tunables. The older `"Shape"` group name is historical.
- `base_color` / `accent_color` were removed in Phase 14. Use `source_color`.
- `Vector2i` convention for any future paired x/y `@export` values (none currently).

### 4.3 The `is_light` flag (forward-compat for v2 light mode)

```gdscript
var is_light: bool

func _regenerate_theme() -> void:
    is_light = surface_fill.get_luminance() >= 0.5
    # ... rest of regeneration ...
```

- **NOT a `@export`.** Computed internally on every regeneration.
- **Dark is the project default**; `is_light` flags the deviation. (Renamed/inverted from godot-minimal-theme's `dark_theme` — semantically clearer for project-default-dark.)
- All conditional formulas in `_regenerate_theme()` branch on `is_light` (godot-minimal-theme line-56 pattern).
- v1 ships dark-first built-in styles, with Bubble intentionally using a dark shell plus light island surfaces. The flag is forward-compat: v2 can plug in formal light variants without changing the role-palette shape.
- Phase 3.4 Override C (`pulse-finalist-override-light.png`) demonstrates the flag wiring works in the renderer today; **Phase 4 MUST carry the same `is_light` branch into GDScript** so production matches the demo. See §6 (color formula contract) for the conditional formulas.

### 4.4 `_regenerate_theme()` lifecycle

Setters on every `@export` property trigger `_regenerate_theme()`:

```gdscript
@export var source_color: Color = Color("#3AA8FF"):
    set(value):
        source_color = value
        _regenerate_theme()
# ... same pattern for exported properties that affect generated entries ...
```

`_regenerate_theme()` clears and repopulates derived theme entry color/state/sizing values for the canonical 37 Control scorecard plus additive runtime/editor integration types. As of the Phase 14 source-color sync, the live implementation has `BINDING_TABLE.size() == 155` and `TYPE_VARIATIONS.size() == 67`.

### 4.5 What does NOT live in `@export`

- Per-direction unique mood (rounded chip shape, primary button color strategy, tab indicator behavior, surface alpha policy, kicker style, raised lifts list, etc.) — lives in `STYLE_PERSONALITY` and related internal recipes.
- Type scale font sizes — derived from `platform` branch in `_regenerate_theme()`, not exported.
- WCAG-driven text colors — derived per fill through contrast-safe `on_*` roles in `_regenerate_theme()`, not exported.
- State-layer overlay opacities — fixed M3 values (hover 8%, focus 12%, pressed 12%, dragged 16%, disabled 38%) hard-coded in `_regenerate_theme()`, not exported.

---

## §5 Built-in style recipes

Each entry below is the current built-in style recipe stored in `STYLE_EXPORTS` plus personality intent stored in `STYLE_PERSONALITY`. These are **not** separate `.tres` resources anymore; users select them through the `style` export on the canonical resource.

The style export values below are translated from `.planning/mockups/3.4/data/directions.json` plus later Phase 12 tuning:
- `base_color` / `accent_color` from §2 (locked palettes).
- `corner_radius` = `axis_1_corner_radius_base_px` from `directions.json`.
- `spacing` = current style export value used by the platform token branch.
- `raised_strength` = current style export value; hidden per-style `shape.raised_depth_scale` and `shape.raised_depth_darken` handle Phase 12 depth personality.
- `focus_thickness` = `axis_6_focus_thickness_px`.
- `outline_width` = `1` (universal v1 default; per-control outline tuning is internal recipe/personality data).

### 5.1 Pulse — `Style.PULSE`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#151A2E")` |
| `accent_color` | `Color("#8BFF6A")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `0` |
| `spacing` | `14` |
| `raised_strength` | `2` |
| `focus_thickness` | `2` |
| `outline_width` | `1` |

**Internal personality intent (Pulse, not extra public exports):**
- Brand mark: square cabinet-bezel; mark radius 0; size desktop 54 / mobile 42.
- Buttons: rectangular (radius 0); padding 14×10 (desktop), expanded for mobile per platform branch; primary strategy = "bold-accent-fill-dark-text"; ghost strategy = "accent-outlined-accent-text".
- Tabs: rectangular strip (radius 0); selected indicator = accent fill + 2px bottom rule.
- Chips: rectangular (radius 0).
- Density: 18px padding, 10px inter-control gap; "arcade-dense" feel.
- Surface ramp: 4 stops, "wide" spread (`spreadFactor = 1.3`).
- State-layer deltas: hover +6%, pressed −10%, disabled opacity 0.42.
- Raised lifts (when `raised=true`): buttons and panels get hard offset depth; tabs and passive rows stay flat per the Phase 12 raised invariant.
- Surface alpha: all 1.00 (cabinet hardware is solid; translucency reads as glass UI = wrong personality).
- Typography: H1 weight 800; H2 weight 740; kicker = "uppercase-tracked-accent".
- Focus style: "tight-cabinet-ring" (`focus_offset = 0`).

**Phase 4 implementation order:** Pulse FIRST (recommended-starter); Slate / Bubble / Daybreak / Burst follow.

### 5.2 Slate — `Style.SLATE`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#111820")` |
| `accent_color` | `Color("#8BD3FF")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `8` |
| `spacing` | `16` |
| `raised_strength` | `2` |
| `focus_thickness` | `2` |
| `outline_width` | `1` |

**Internal personality intent (Slate):**
- Brand mark: rounded-square (radius 8); size desktop 54 / mobile 42.
- Buttons: rounded (radius 8); shared desktop padding; primary strategy = "quiet-pill-primary"; ghost strategy = "thin-accent-outline".
- Tabs: quiet rounded chrome (radius 8); selected indicator = restrained accent stripe.
- Chips: rounded chrome (radius 8).
- Density: 22px padding, 14px inter-control gap; "spacious-premium-quiet" feel.
- Surface ramp: 3 stops, "narrow" spread (`spreadFactor = 0.7`).
- State-layer deltas: hover +4%, pressed −6%, disabled opacity 0.50.
- Raised lifts: buttons and panels get restrained hard offset depth; tabs and passive rows stay flat per the Phase 12 raised invariant.
- Surface alpha: popup_surface 0.92, panels 1.00, buttons 1.00, chrome 1.00 (iOS-premium mood; 8% bleed-through on popup overlay matches iOS NavigationBar/Sheet/modal-backdrop translucency without sliding into glassmorphism).
- Typography: H1 weight 720; H2 weight 640; kicker = "small-caps-subtle".
- Focus style: "ios-style-offset" (`focus_offset = 2`).

### 5.3 Bubble — `Style.BUBBLE`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#241326")` |
| `accent_color` | `Color("#FFB3E6")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `24` |
| `spacing` | `16` |
| `raised_strength` | `3` |
| `focus_thickness` | `3` |
| `outline_width` | `1` |

**Internal personality intent (Bubble):**
- Brand mark: round squircle (radius 24); size desktop 54 / mobile 42.
- Buttons: heavily rounded (radius 24); shared desktop padding; primary strategy = "pillowy-rounded-primary"; ghost strategy = "rounded-ghost-thicker-outline".
- Tabs: rounded chrome capped at radius 12 so text tabs do not become pills; selected indicator = restrained accent stripe.
- Chips: heavily rounded chrome (radius 24).
- Density: 22px padding, 14px inter-control gap; "friendly-airy-generous" feel.
- Surface ramp: 3 stops, "medium" spread (`spreadFactor = 1.0`).
- State-layer deltas: hover +8%, pressed −10%, disabled opacity 0.45.
- Raised lifts: buttons and panels get the chunkiest Bubble hard offset depth; tabs and passive rows stay flat per the Phase 12 raised invariant.
- Surface alpha: all 1.00 (candy is opaque; translucent candy reads as ice/gelatin = wrong personality).
- Typography: H1 weight 800; H2 weight 760; kicker = "uppercase-tracked-accent".
- Focus style: "cheerful-chunky-ring" (`focus_offset = 2`).

### 5.4 Daybreak — `Style.DAYBREAK`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#0B2420")` |
| `accent_color` | `Color("#76F2D1")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `4` |
| `spacing` | `16` |
| `raised_strength` | `3` |
| `focus_thickness` | `2` |
| `outline_width` | `1` |

**Internal personality intent (Daybreak):**
- Brand mark: rounded-square (radius 4); size desktop 54 / mobile 42.
- Buttons: gently rounded (radius 4); shared desktop padding; primary strategy = "friendly-primary-generous-breathing"; ghost strategy = "soft-outline-ghost".
- Tabs: rounded-rect (radius 4); selected indicator = restrained accent stripe.
- Chips: rounded-rect (radius 4).
- Density: 24px padding, 16px inter-control gap; "airy-breathing" feel.
- Surface ramp: 4 stops, "medium" spread.
- State-layer deltas: hover +6%, pressed −6%, disabled opacity 0.50.
- Raised lifts: buttons and panels get gentle hard offset depth; tabs and passive rows stay flat per the Phase 12 raised invariant.
- Surface alpha: popup_surface 0.90, panels 0.96, buttons 1.00, chrome 1.00 (airy welcoming-lobby mood; 4% bleed on container panels + 10% on popup overlay = airy lift without visual weakness; buttons stay solid for tappability).
- Typography: H1 weight 720; H2 weight 660; kicker = "sentence-case-accent".
- Focus style: airy fresh ring with flat outline language (`focus_offset = 2`), no glow/halo.

### 5.5 Burst — `Style.BURST`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#20112E")` |
| `accent_color` | `Color("#FFD166")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `12` |
| `spacing` | `16` |
| `raised_strength` | `3` |
| `focus_thickness` | `3` |
| `outline_width` | `1` |

**Internal personality intent (Burst):**
- Brand mark: chunky asymmetric badge (radius 12); size desktop 60 / mobile 48 (the only direction with above-baseline mark size — emphasises celebratory brand presence).
- Buttons: bold rounded (radius 12); shared desktop padding; primary strategy = "statement-primary"; ghost strategy = "normal-accent-ghost".
- Tabs: rounded-rect (radius 12); selected indicator = restrained accent stripe.
- Chips: rounded (radius 12).
- Density: 22px padding, 14px inter-control gap; "event-spread-hierarchy-amplified" feel.
- Surface ramp: 4 stops, "wide" spread.
- State-layer deltas: hover +8%, pressed −12%, disabled opacity 0.45.
- Raised lifts: buttons and panels get bold hard offset depth; tabs and passive rows stay flat per the Phase 12 raised invariant.
- Surface alpha: all 1.00 (celebration posters are solid; translucent achievement surfaces feel weak = wrong personality).
- Typography: H1 weight 820; H2 weight 780; kicker = "uppercase-bold-larger-scale".
- Focus style: "dramatic-event-ring" (`focus_offset = 1`).

---

## §6 Color formula and surface ramp contract

These formulas are the production reference. They are translated from `.planning/mockups/3.4/src/neocade-mockups.js`'s `deriveSurfaceRamp(direction)` and `deriveTokens(direction, platform, raised)` functions and represent the visual contract approved at the Phase 3.4 final-approval gate. Phase 4 ports them into GDScript verbatim — same mix targets, same coefficients, same `is_light` branching.

### 6.1 Color mixing helpers (Phase 4 GDScript ports)

```gdscript
# Linear RGB mix (matches the renderer's hexToRgb + rgbToHex pipeline).
func _mix(a: Color, b: Color, amount: float) -> Color:
    return Color(
        a.r + (b.r - a.r) * amount,
        a.g + (b.g - a.g) * amount,
        a.b + (b.b - a.b) * amount,
        1.0
    )

# Element shifted partway toward base — preserves hue at every brightness.
# Replaces HSL-darken (which floors at L=0 and produces near-black on already-
# dark surfaces). Default ratio 0.40 per MOCKUP-REVISION-3-HANDOFF.md.
func _tint_toward_base(element: Color, base_c: Color, ratio: float = 0.40) -> Color:
    return _mix(element, base_c, ratio)
```

### 6.2 Surface ramp (5 stops + outline)

Driven by `base_color` + the `axis_8_surface_spread` factor from `directions.json` (`narrow=0.7`, `medium=1.0`, `wide=1.3`). The `is_light` flag flips the elevated tier's mix target so containers stay distinguishable from the page color in both modes.

```gdscript
# In _regenerate_theme():
var spread_factor: float = _resolve_spread_factor(direction_spread)  # narrow|medium|wide
var elevate_target: Color = Color.BLACK if is_light else Color.WHITE

var surface_base: Color    = base_color
var surface_low: Color     = _mix(base_color, Color.BLACK, 0.18 * spread_factor)
var surface_panel: Color   = _mix(base_color, elevate_target, 0.06 * spread_factor)
var surface_high: Color    = _mix(base_color, elevate_target, 0.13 * spread_factor)
var surface_overlay: Color = _mix(base_color, elevate_target, 0.20 * spread_factor)
var outline_color: Color   = _mix(base_color, elevate_target, 0.24 * spread_factor)
```

**Why `surface_low` always mixes with BLACK** (regardless of `is_light`): `surface_low` is the recessed/shadow color. It reads as "below" the page in both modes. Outline + the elevated-tier surfaces flip target with `is_light`.

**Friendlier aliases (5-stop M3 tonal ramp per TOKEN-01):** `surface_base` = M3 surface; `surface_low` = surface-container-low; `surface_panel` = surface-container; `surface_high` = surface-container-high; `surface_overlay` = surface-container-highest.

### 6.3 Raised depth-edge color tokens (raised mode)

When `raised = true`, raised elements use a hard bottom extrusion, not a soft shadow. Neutral/surface elements keep the rev-3 tinted-offset behavior: same family as the face, shifted toward `base_color` so panels and quiet chrome never collapse to near-black.

```gdscript
var accent_offset: Color          = _tint_toward_base(accent_color, base_color)
var surface_high_offset: Color    = _tint_toward_base(surface_high, base_color)
var surface_panel_offset: Color   = _tint_toward_base(surface_panel, base_color)
var surface_overlay_offset: Color = _tint_toward_base(surface_overlay, base_color)
var surface_low_offset: Color     = _tint_toward_base(surface_low, base_color)
```

Colored interactive and semantic faces use HSV value-darken for the raised depth edge instead of tinting toward the page base. Hue/saturation stay fixed while value is reduced by `shape.raised_depth_darken`; this preserves the candy-flat button read from the HCGames-style reference without producing black/muddy undersides.

```gdscript
var raised_depth_darken: float = shape.raised_depth_darken
var primary_button_offset: Color = _raised_depth_color(primary_button_normal, base_color, raised_depth_darken)
var role_danger_offset: Color = _raised_depth_color(role_danger, base_color, raised_depth_darken)
```

These offset colors back the StyleBoxFlat bottom border on raised elements (see §9 raised variation contract). A panel (surface_panel fill) uses `surface_panel_offset`; a colored primary/danger/semantic button uses the HSV-darkened offset for its depth edge.

### 6.4 Text colors with `is_light` flip

```gdscript
var text_strong: Color  # text on surface (highest contrast)
var text_default: Color
var text_muted: Color

if is_light:
    text_strong  = Color("#1B2230")  # near-ink
    text_default = Color("#1B2230")
    text_muted   = Color("#5A6478")  # mid grey-blue
else:
    text_strong  = Color("#F7F8FB")  # near-white
    text_default = Color("#F7F8FB")
    text_muted   = Color("#B9C1D0")  # pale grey-blue
```

These satisfy WCAG 2.1 AA against the surface ramp in both `is_light` modes (verified at 4.5:1 floor in `wcag-palette-audit.md`).

### 6.5 State-layer overlays (M3 deterministic + `is_light` flip on hover)

Hover lightens (toward white on dark base) → on light base it darkens (toward black on light base) per M3's "on-surface tint" rule. Pressed always darkens further regardless of `is_light` (canonical "press" cue). Disabled is opacity, not color.

```gdscript
# Per-direction state-layer deltas come from directions.json axis_9.
var hover_pct: float = direction_hover_pct      # e.g., 6 for Pulse, 8 for Bubble/Burst
var pressed_pct: float = direction_pressed_pct  # negative; e.g., -10 for Pulse, -12 for Burst
var disabled_opacity: float = direction_disabled_opacity  # e.g., 0.42 for Pulse

var state_hover_target: Color = Color.BLACK if is_light else Color.WHITE
var state_hover: Color = _mix(base_color, state_hover_target, abs(hover_pct) / 100.0)
var state_pressed: Color = _mix(base_color, Color.BLACK, abs(pressed_pct) / 100.0)
# disabled: applied as theme_color.a = disabled_opacity in disabled stylebox/font_color slots.
```

---

## §7 Accent, semantic role, and state-layer contract

### 7.1 Semantic role tokens (TOKEN-02 baseline)

| Role | Source | Notes |
|---|---|---|
| `role.primary` | `accent_color` (per-direction) | Drives primary buttons, focus rings, selected tabs/rows, caret, progress fill |
| `role.success` | derived green | Default `Color("#5CC971")`; styles may override internally |
| `role.warning` | derived amber | Default `Color("#FFD166")`; directions may override |
| `role.danger` | derived red | Default `Color("#FF6E6E")`; directions may override |
| `role.info` | derived cyan/blue | Default `Color("#5FE3FF")`; directions may override |

`accent_offset`, `accent_rim` (= `_mix(accent_color, Color.WHITE, 0.5)`), and per-role raised depth offsets are derived in `_regenerate_theme()` for raised-mode Control authoring.

**Pending source-color rework token additions:** if `.planning/research/THEME-COLOR-IDENTITY-RETHINK.md` is approved, the semantic layer expands beyond the TOKEN-02 baseline. Add explicit `role.positive` / `role.positive_container` for affirmative action controls, keep `role.success` for feedback state, and use a small control-facing alias vocabulary instead of one token per Godot slot: `surface_fill`, `panel_fill`, `popup_shell`, `dialog_header`, `action_fill`, `menu_fill`, `input_fill`, `selection_fill`, `tab_selected_fill`, `range_fill`, `toggle_fill`, `positive_fill`, `danger_fill`, `separator_fill`, `link_text`, `focus_ring`, `raised_offset_*`, and conditional `success_fill`, `warning_fill`, `info_fill`. Slot-specific hover/pressed/disabled/read-only/scrollbar/check states derive from those aliases unless visual tests prove a new alias is necessary. These are pending rework tokens, not current shipped TOKEN-02 values.

### 7.2 M3 state-layer constants

Per TOKEN-09 + MD3-RESEARCH.md the M3 deterministic state-layer model is:

| State | Layer opacity | Where applied |
|---|---|---|
| hover | 8% (overlay; specific delta per direction in §6.5) | `Button.hover` stylebox bg, `Tree.hover` stylebox, etc. |
| focus | 12% overlay + 2px outer ring in `role.primary` | OUTSIDE corner radius (PITFALLS 1.1) |
| pressed | 12% overlay (specific delta per direction in §6.5) | `Button.pressed`, etc. |
| dragged | 16% overlay | drag-source styling (Tree, ItemList, etc.) |
| disabled | 38% text / 12% container | `font_color_disabled = text * 0.38`; container opacity 0.12 |

Per-direction `axis_9` deltas in §5 modulate hover and pressed magnitudes within these ceilings; the 8%/12%/12%/16%/38% M3 baselines hold across all directions.

### 7.3 Pitfall 1.1 state combinations (focus + state)

`focus` is an **outer ring**, NOT a fill replacement (PITFALLS 1.1). Combinations that must render correctly without disappearing:

- `pressed_focus` — focus ring layered OVER pressed bg.
- `checked_focus` — focus ring layered OVER checked bg.
- `hover_pressed` — hover layer composed OVER pressed bg without producing a third color shift.

Phase 4 implements these in `_regenerate_theme()` by populating the explicit theme entries (`Button.pressed_focus_stylebox`, `Button.checked_focus_stylebox`, etc.) where Godot supports them, OR by keeping the focus ring stylebox in a separate visual layer that doesn't get replaced by state styleboxes.

---

## §8 Shape, outline, spacing, and typography contract

### 8.1 Corner radius semantic

`corner_radius` is the per-style **base radius**. Built-in styles set this through `STYLE_EXPORTS`; per-control radius variations live in `STYLE_PERSONALITY` and BINDING_TABLE recipes, not extra public exports. Sentinel `999` remains available internally for true circular controls, but text-bearing chrome should avoid pill clamping unless explicitly designed for it. Current v1 radius ladder is Pulse 0, Daybreak 4, Slate 8, Burst 12, Bubble 24. Tabs read `shape.tab_radius` but clamp to `12` so Bubble keeps round buttons/panels without turning tab labels into capsules. `TabContainer.side_margin` follows `corner_radius` so the first tab clears rounded panel shoulders without adding fake margins to `tabbar_background`.

### 8.2 Focus ring construction

- `focus_thickness` = ring thickness in px (per-direction; 2 for Pulse/Slate/Daybreak, 3 for Bubble/Burst).
- `focus_offset` (internal style personality) = gap between bg edge and ring start. 0 for Pulse (tight cabinet ring); 2 for Slate/Bubble/Daybreak; 1 for Burst.
- Ring color = `accent_color` (= `role.primary`).
- Ring stylebox = `StyleBoxFlat` with transparent bg, `border_width_*` = `focus_thickness`, border color = `accent_color`, `expand_margin_*` = `focus_offset`. Drawn OUTSIDE corner radius bounds (PITFALLS 1.1).

### 8.3 Outline width

`outline_width` = base outline width on `StyleBoxFlat` borders for inputs / chip outlines / ghost button outlines (default 1px, integer). Per-control outline tuning (e.g., danger button thicker outline, ghost button thicker outline for Bubble strategy) lives in internal recipes/personality, not extra public exports.

### 8.4 Spacing scale

`spacing` is the per-direction density baseline (in px). It maps to TOKEN-06's 8-step scale: `space.0=0`, `space.1=spacing/4` (rounded), `space.2=spacing/2`, `space.3=spacing*0.75`, `space.4=spacing` (the baseline), `space.5=spacing*1.5`, `space.6=spacing*2`, `space.7=spacing*3`, `space.8=spacing*4`. The desktop branch uses these directly. The mobile branch scales `space.4+` ×1.5 (per architecture revision 2026-05-04 + CROSS-PLATFORM.md mobile floors).

### 8.5 Typography (Inter Variable Roman ONLY — UD-4 Option D)

**v1 ships exactly one font: Inter Variable Roman** (`Inter-Variable.ttf` from Inter v4.x, OFL 1.1). No Outfit. No Noto Sans bundled. No JetBrains Mono bundled. No Inter Italic bundled (synthetic italic transform per FONT-07). Reserved Font Name preserved (file NOT renamed). Imported as `FontFile.tres` referenced by `uid://`. `default_font.allow_system_fallback = true` for non-Latin scripts via OS system fonts.

#### M3 type scale (TOKEN-10, mapped to Godot font sizes)

| M3 token | Inter `wght` | Inter `opsz` | Desktop size | Mobile size | Godot binding |
|---|---|---|---|---|---|
| display-small | 800 | 32 | 36 | 36 | HeaderLarge type variation |
| headline-small | 700 | 32 | 22 | 22 | HeaderMedium type variation |
| title-large | 600 | 24 | 22 | 22 | HeaderSmall type variation |
| title-medium | 600 | — | 16 | 18 | (button labels in primary roles) |
| body-large | 400 | — | 16 | 16 | RichTextLabel default |
| body-medium | 400 | — | 14 | 16 | Label / Button default |
| body-small | 400 | — | 12 | 14 | Caption type variation |
| label-large | 500 | — | 14 | 14 | (control affordance labels) |
| label-small | 500 | — | 11 | 13 | (kicker / small caps) |
| code | (consumer-supplied) | — | 13 | 14 | CodeLabel + CodeEdit (consumer override per FONT-04 / FONT-09(b)) |

Heading discrimination uses Inter's `opsz` axis + heavier `wght`, NOT a separate display family (per FONT-REVIEW.md Option D).

#### PITFALLS 1.2 — type variations don't inherit fonts

Per Pitfall 1.2, type variations DO NOT inherit fonts from base type. Phase 4 sets `font` EXPLICITLY on every type variation (HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, etc.) — verified under runtime QA, not editor preview.

### 8.6 Per-direction kicker style (internal style personality)

| Direction | Kicker style |
|---|---|
| Pulse | uppercase-tracked-accent |
| Slate | small-caps-subtle |
| Bubble | uppercase-tracked-accent |
| Daybreak | sentence-case-accent |
| Burst | uppercase-bold-larger-scale |

These are internal style/personality decisions applied to the `Kicker` Label type variation.

---

## §9 Flat/raised variation contract

### 9.1 `raised = false` (flat — project default)

- Every `StyleBoxFlat`'s `shadow_size = -1` (the disable value per Godot #98162; per TOKEN-08 and SUMMARY Conflict 3 — no drop shadows in v1).
- Elevation is conveyed via tonal surface ramp ONLY (TOKEN-08; no shadows).
- No top-bevel border. No glow. No texture. No pattern.
- All controls render as solid surface fills + 1px hairline outlines + state-layer overlays.

### 9.2 `raised = true` (extruded-flat)

Translates the mockup CSS `box-shadow: 0 raised_strength 0 0 var(--{element}-offset)` hard-offset pattern into Godot StyleBoxFlat border depth, not soft shadows:

```gdscript
# For each raised-eligible Control's stylebox:
sb.shadow_size = 0
sb.shadow_offset = Vector2.ZERO
depth_width = ceil(raised_strength * shape.raised_depth_scale * shape.raised_lifts.<family> / 3.0)
sb.border_color = element_offset_color  # per §6.3; surface tint or HSV depth-darken
sb.border_width_bottom = max(depth_width, face_edge_width + 1)
sb.content_margin_bottom += max(0, sb.border_width_bottom - face_edge_width)

# CRITICAL: do NOT add bevel gradients, texture, glow, or soft drop shadow.
# raised = solid top shape + hard offset darker shape duplicate. That is it.
```

### 9.3 Per-Control raised behavior (PITFALLS-aligned)

Raised intensity by Control family per FLAT-3D-UI-RESEARCH.md + per-direction `axis_10_raised_lifts`:

| Family | Raised behavior |
|---|---|
| Buttons (primary/regular/ghost) | strongest — normalized from the 0-3 family lift scale, then multiplied by per-direction `shape.raised_depth_scale` so each style gets an intentional underside thickness |
| Selected tabs / chips | medium or flat; tabs do not gain extra bottom depth because they must stay connected to the panel |
| Range handles (slider grabber, scrollbar grabber) | subtle — small hard offset only |
| Panels / dialogs | subtle — normalized from the 0-3 family lift scale (panels lift to convey card-like depth, but flat fill content) |
| Lists / tree / item rows | absent or very subtle — most directions: rows do NOT lift (only Bubble + Daybreak + Slate + Burst's selected rows lift; Pulse rows stay flat) |
| Popup/dialog shells | rare — Phase 4 may opt to keep popup shells flat regardless of `raised` to preserve readability |
| Passive labels / separators | NEVER lift (passive elements have no affordance) |

Per-style lift intent is summarized in §5 and implemented through `STYLE_PERSONALITY` / BINDING_TABLE recipe fields.

Built-in raised depth-edge tuning for common button chrome:

| Direction | Primary/danger bottom edge | Regular/OptionButton bottom edge | Depth darken |
|---|---:|---:|---:|
| Pulse | 3px | 2px | 38% |
| Slate | 3px | 2px | 30% |
| Bubble | 5px | 4px | 32% |
| Daybreak | 2px | 1px | 34% |
| Burst | 4px | 3px | 42% |

Bubble intentionally gets the chunkiest 5px/4px candy-game underside, but the 32% value darken is softer than Burst so it stays playful rather than heavy. Burst remains high-energy through stronger color contrast, oversized CTA rhythm, and darker depth color rather than being the physically deepest style. Daybreak is the gentlest raised style.

### 9.4 Optional top rim highlight (raised primary buttons)

Per MOCKUP-REVISION-2-HANDOFF.md Issue 2 optional recommendation, raised primary buttons MAY use a 1px lighter top rim (`accent_rim = _mix(accent_color, Color.WHITE, 0.5)`) for an "inner highlight" reading. Implemented as `border_width_top = 1` + `border_color = accent_rim`. Optional; Phase 4 evaluates per-direction whether the rim improves readability or competes with the focus ring.

---

## §10 Desktop/mobile/AUTO variation contract

### 10.1 Platform tokens (from `PLATFORM_TOKENS` in `neocade-mockups.js`)

| Token | DESKTOP | MOBILE | Notes |
|---|---|---|---|
| `buttonMin` | 36 | 48 | Steam settings vs M3 + iOS HIG 44pt + WCAG 2.5.5 AAA |
| `primaryButtonMin` | 44 | 56 | Battle.net Play hero vs M3 Extended FAB |
| `inputMin` | 34 | 56 | Steam search input vs M3 filled text field |
| `toggleMin` | 22 | 32 | Steam-comparable vs M3 Switch |
| `checkboxSize` | 18 | 20 | (mobile: + tapPadding for full 48dp target) |
| `body` | 14 | 16 | Steam/Discord vs M3 Body Large |
| `label_` | 12 | 14 | supporting labels |
| `h1` | 36 | 32 | (mobile slightly smaller — tighter screen) |
| `h2` | 22 | 22 | (mobile keeps same H2 size) |
| `kicker` | 12 | 13 | M3 Label Small floor |
| `rowMin` | 36 | 56 | Steam list-row vs M3 list-item-one-line |
| `tabMin` | 32 | 48 | M3 Tabs default |
| `tapPadding` | 8 | 12 | hit-area expansion around small interactives |
| `densityScale` | 1.0 | 1.5 | +50% inter-control gap on `space.4+` (architecture revision 2026-05-04) |

### 10.2 `platform = AUTO` resolution

```gdscript
func _resolve_platform() -> Platform:
    if platform == Platform.AUTO:
        return Platform.MOBILE if OS.has_feature("mobile") else Platform.DESKTOP
    return platform
```

Per Phase 3.2 strict feasibility verifier (VERIFY-RESULTS.md), `web_android` / `web_ios` resolve to MOBILE; `web_windows` resolves to DESKTOP; ambiguous `web` resolves to MOBILE-preferred. Native platforms use Godot's `OS.has_feature("mobile")` directly.

### 10.3 Platform branch in `_regenerate_theme()`

```gdscript
func _regenerate_theme() -> void:
    is_light = base_color.get_luminance() >= 0.5
    var p: Platform = _resolve_platform()
    var tokens: Dictionary = _platform_tokens(p)  # returns table from §10.1
    # ... use tokens.buttonMin, tokens.body, etc. when authoring entries ...
```

Corner radii (`corner_radius`, per-direction) DO NOT scale with platform — brand identity stays consistent across desktop/mobile (CONTEXT.md D-23). Spacing scales: `space.4+` × `densityScale` per platform.

### 10.4 No separate mobile or per-style `.tres`

Per architecture revision 2026-05-04, 2026-05-08 style consolidation, and 2026-05-09 advanced-export update, **there is no `neocade_mobile_theme.tres` and no per-style `.tres` set**. Mobile is `platform=MOBILE` on the single concrete class. One `.gd` + one canonical `.tres` covers all built-in styles across flat/raised and desktop/mobile/AUTO configurations.

---

## §11 Accessibility and anti-texture rules

### 11.1 WCAG 2.1 contrast floors

| Tier | Ratio | Where enforced |
|---|---|---|
| AA body text | 4.5:1 | text_default / text_strong on every surface ramp stop; verified in `wcag-palette-audit.md` |
| AA large text | 3:1 | display-* / headline-* sizes |
| AAA body text | 7:1 | aspirational; Pulse 13.62:1, Slate 10.94:1, Bubble 10.74:1, Daybreak 11.96:1, Burst 12.33:1 — all directions exceed AAA on accent-on-base |

### 11.2 Tap-target floors (mobile)

48px minimum on both axes for every interactive Control under `platform=MOBILE`. Hit-area expansion via `tapPadding` (12px on mobile) wraps small visual controls (toggle, checkbox).

### 11.3 anti-texture / anti-cyberpunk hard rules (PROJECT.md + Phase 3 redirect)

**Hard rules (locked 2026-05-04):**
- NO textures.
- NO patterns.
- NO embossing.
- NO painterly / leather / wood / grunge backgrounds.
- NO gradients on chrome.
- NO drop shadows in v1 (TOKEN-08 + SUMMARY Conflict 3 + GL Compatibility issue #23640).
- NO glow.
- NO neon.
- NO synthwave.
- NO neon-noir.
- NO dystopian.

**Allowed:**
- Solid fills (StyleBoxFlat).
- Tonal surface ramp (color-only elevation).
- Hard offset darker shape duplicates (raised mode ONLY; no blur, no soft shadow).
- 1px lighter top-bevel border on raised primary buttons (optional, per §9.4).
- Anti-aliased corner radius on StyleBoxFlat.

### 11.4 Identity preservation

The anti-cyberpunk discipline is preserved (Phase 3 redirect 2026-05-04). The earlier "neo/neon arcade hall by day" framing is HISTORICAL — see `.planning/phases/03-visual-direction-mockup-approval-gate/REDIRECTED.md`.

---

## §12 Current implementation handoff

### 12.1 Files that exist now

1. `addons/neocade_theme/scripts/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme` with the 11 `@export` properties, setters → `_regenerate_theme()`, `is_light` derivation, `STYLE_EXPORTS`, `STYLE_PERSONALITY`, source-color role strategies, `TYPE_VARIATIONS`, and `BINDING_TABLE`.
2. `addons/neocade_theme/neocade_theme.tres` — canonical `NeoCadeTheme` resource with `style = PULSE` and the 12 serialized exports.
3. `addons/neocade_theme/scripts/neocade_theme_option_button.gd` — reusable style picker that duplicates the canonical resource, sets `style`, applies it to a target Control, and can emit `null` for the `None` entry.
4. `addons/neocade_theme/scripts/neocade_theme_autoload.gd` — optional drop-in autoload that calls `NeoCadeTheme.apply_globally()` and merges the canonical theme into `ThemeDB.default_theme`.

Plus package metadata files (`LICENSE.md`, `README.md`, `docs/usage.md`, `CHANGELOG.md`, `VERSION`) and bundled font license `addons/neocade_theme/fonts/inter_ofl.txt` per FOUND-01.

### 12.2 Files that must not exist

- No per-direction `.gd` files.
- No per-style `.tres` resources such as `pulse_neocade_theme.tres`.
- No `themes/` subfolder.
- No `_dev/` subfolder. (Spike artifacts at `.planning/spikes/dynamic-theme/` stay in `.planning/`, not under `addons/`.)
- No `neocade_mobile_theme.tres`. Mobile is a `platform=MOBILE` toggle.
- No `plugin.cfg` (per STACK Decision 5 — not an editor plugin).

### 12.3 Verification checkpoints

The implementation is considered current when:
- All 12 `@export` properties exist on `NeoCadeTheme` with the correct types, defaults, group labels, and setter wiring.
- `is_light` flag is computed correctly from `base_color.get_luminance()` and branches all conditional formulas.
- `_regenerate_theme()` populates entries for the canonical 37-row Control scorecard plus additive runtime/editor integration types without errors.
- The canonical `.tres` loads as `NeoCadeTheme`, defaults to Pulse, and can switch to Slate/Bubble/Daybreak/Burst/Custom through `style`.
- Toggling `style` / `raised` / `platform` / `base_color` / `accent_color` produces correctly regenerated entries.
- No theme-default-overlay errors at editor or runtime load time.
- WCAG audit re-runs against the implemented theme produce the same ratios as `wcag-palette-audit.md`.

### 12.4 Cross-phase consumer references

| Phase | Uses DESIGN_TOKENS.md for |
|---|---|
| 4 | Class contract + canonical resource + formula ports + forbidden-file list |
| 5 | TYPEVAR-01..05 type variation authoring (Button + Label + RichTextLabel + Panel families) |
| 6 | Tree / ItemList / TabBar / Range Control entries (formulas in §6 + raised behavior in §9) |
| 7 | Popup-class theming + ColorPicker icons + Graph theming (§7 role tokens + §8 typography) |
| 8 | Mobile branch validation against §10 platform tokens; tap-target audit against §11.2 |
| 9 | Showcase scene applies canonical starter (§3); theme picker cycles all 5 built-in styles + `None` |
| 12 | Signature visual moves and raised-depth tuning; export contract superseded by Phase 14 |
| 14 | Source-color role palette rework; public color API is `style + source_color` |
| 13 | Opt-in role Label/Panel variations and the 10th showcase tab |

---

**End of DESIGN_TOKENS.md.** Historical Phase 4 handoff wording has been updated to match the current canonical-resource implementation.
