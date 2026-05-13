# NeoCade Design Tokens — Phase 4 Implementation Contract

**Status:** APPROVED — Phase 3.4 user-approval gate closed 2026-05-06.
**Version:** 1.0 (Plan 04 closeout, 2026-05-06).
**Architecture:** Single concrete `NeoCadeTheme` class + 5 data-only `.tres` peers (CORRECTIVE-ADDENDUM D-31, finalized 2026-05-06f).
**Consumed by:** Phase 4 (`addons/neocade_theme/scripts/neocade_theme.gd` + 5 `.tres`), Phases 5-7 (Control coverage), Phase 8 (mobile branch), Phase 9 (showcase).
**Hard precondition:** Phase 4 may NOT begin until `/gsd-verify-work` of Phase 3.4 passes.

This document is the **single source of truth** for token values, formulas, and the `NeoCadeTheme` class contract. It is implementation-ready: every `@export` value, every formula, every per-Control intent that Phase 4 needs is recorded here. No further visual-direction decisions are required — Phase 4 imports values, ports formulas, and authors per-direction Theme Editor overrides.

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

All five candidate directions from Phase 3.3 (Revision Round 2/2 dark-only) are approved for v1 ship as **data-only `.tres` peers** of the single concrete `NeoCadeTheme` class. None deferred. All five satisfy WCAG 2.1 AA at body text against `base_color`.

| Direction | base_color | accent_color | WCAG ratio (accent on base) | Personality | v1 ship status |
|---|---|---|---|---|---|
| Pulse    | `#151A2E` | `#8BFF6A` | 13.62:1 | Vibrant arcade hall — cabinet-bezel chrome, lit primaries, packed control deck | approved · **recommended starter** (Phase 4 implements first) |
| Slate    | `#111820` | `#8BD3FF` | 10.94:1 | Premium dark default — iOS-pill polish, restrained accent, quiet confident chrome | approved · v1 personality variation |
| Bubble   | `#241326` | `#FFB3E6` | 10.74:1 | Playful candy-counter at night — pillowy chrome, fully-rounded chips, cheerful warmth | approved · v1 personality variation |
| Daybreak | `#0B2420` | `#76F2D1` | 11.96:1 | Fresh evening lobby — dark teal surfaces with bright mint wayfinding, airy spacing | approved · v1 personality variation |
| Burst    | `#20112E` | `#FFD166` | 12.33:1 | Celebratory MD3 Expressive max — oversized statement primary, asymmetric mark, bold gold | approved · v1 personality variation |

CLAUDE.md "v1 ships N user-approved theme `.tres` files" resolves to **N = 5** for v1.

**Direction integrity rule:** Phase 4 MUST NOT rename, recolor, or re-derive any of the five directions. Their identity is locked here. Polish passes (e.g., Pulse colorfulness pass, surface-concern fixes) are **v1.x backlog** and live in Theme Editor entry overrides per `.tres`, not as new exports or palette swaps.

---

## §3 Recommended starter designation

**The v1 recommended starter is Pulse.**

### What "recommended starter" means under D-31

CONTEXT.md D-16/D-17 originally said the Phase 3.4 user pick "becomes `NeoCadeTheme`'s defaults" (so `NeoCadeTheme.new()` would produce the picked direction's style). Track 5 / D-31 (2026-05-06e) rewrote that. Under the locked single-concrete-class architecture, the recommended starter has only **two soft commitments**:

1. **Showcase scene default** — Phase 9's `showcase/showcase.tscn` preloads `res://addons/neocade_theme/pulse_neocade_theme.tres` as the project/scene theme.
2. **README "try this first" suggestion** — addon README names Pulse as the suggested starting direction for new consumers who don't have a preference.

### What "recommended starter" does NOT mean

- It does **NOT** bake values into `NeoCadeTheme` class `@export` defaults.
- It does **NOT** give Pulse architectural privilege over Slate / Bubble / Daybreak / Burst — all five ship as **peer** data-only `.tres` files.
- It does **NOT** require Phase 4 to ship a separate "starter" file. There is no `recommended_starter_neocade_theme.tres`. The role is performed by `pulse_neocade_theme.tres` plus the README + scene preload.

### Class default policy

`NeoCadeTheme` class `@export` defaults are sensible **placeholders** picked for "what the user sees when they instance the class via `NeoCadeTheme.new()` and have not yet loaded a direction `.tres`." They are NOT Pulse's values. Phase 4 picks defaults that produce a recognizable, working dark theme so an empty instance is debuggable, but the defaults are intentionally **generic**, not Pulse-flavored. Recommended class defaults: `base_color = Color("#111820")` (Slate-ish neutral dark), `accent_color = Color("#8BD3FF")`, `raised = false`, `platform = AUTO`, `corner_radius = 12`, `spacing = 4`, `raised_strength = 3`, `focus_thickness = 2`, `outline_width = 1`. These are mutable in Phase 4 if a more neutral default is preferred.

---

## §4 Shared `NeoCadeTheme` class contract

`addons/neocade_theme/scripts/neocade_theme.gd` is the **single, concrete, instantiable** `@tool class_name NeoCadeTheme extends Theme`. Users can `NeoCadeTheme.new()` directly to author custom themes. Each shipped direction is a `[gd_resource type="NeoCadeTheme" format=3]` `.tres` with that direction's `@export` values + Theme Editor entry overrides for personality. **No `@abstract`, no per-direction `.gd` subclasses, no class hierarchy.**

### 4.1 The 9 `@export` properties (locked 2026-05-06f)

The export set is **intentionally minimal** — limited to values that should be consistent across the entire theme. Per-direction unique mood lives in **Theme Editor entry overrides per `.tres`**, NOT in additional `@export` properties.

| # | Property | Type | Group | Default | Range / Notes |
|---|---|---|---|---|---|
| 1 | `base_color` | `Color` | Core | `#111820` (sensible neutral dark — see §3) | Any color; setter triggers `_regenerate_theme()` |
| 2 | `accent_color` | `Color` | Core | `#8BD3FF` | Any color; setter triggers `_regenerate_theme()` |
| 3 | `raised` | `bool` | Core | `false` | `false` = flat MD3 (project default), `true` = extruded-flat |
| 4 | `platform` | `Platform` enum | Core | `Platform.AUTO` | `{ DESKTOP=0, MOBILE=1, AUTO=2 }`; AUTO resolves at runtime |
| 5 | `corner_radius` | `int` | Shape | `12` | px; integer pixels only (PITFALLS 1.6 — no fractional widths under GL Compatibility) |
| 6 | `spacing` | `int` | Shape | `4` | px; base spacing unit; mobile branch scales `space.4+` ×1.5 |
| 7 | `raised_strength` | `int` | Shape | `3` | px; primary raised offset; secondary/tab/row offsets derive from this in `_regenerate_theme()` |
| 8 | `focus_thickness` | `int` | Shape | `2` | px; outer focus-ring thickness (PITFALLS 1.1 — focus is OUTSIDE corner radius bounds) |
| 9 | `outline_width` | `int` | Shape | `1` | px; default StyleBoxFlat outline width; per-Control outline tuning lives in Theme Editor overrides |

### 4.2 Naming discipline (cleaned 2026-05-06f)

- `corner_radius_base` → `corner_radius` (no redundant `_base` suffix; the term IS the base radius).
- `base_spacing` → `spacing` (no redundant `base_` prefix).
- `raised_offset` → `raised_strength` (intuitive verb; "strength" implies the scalar from which secondary offsets derive).
- Group label is `"Shape"` (not `"Shape Language"` — too verbose for the inspector).
- `Vector2i` convention for any future paired x/y `@export` values (none currently).

### 4.3 The `is_light` flag (forward-compat for v2 light mode)

```gdscript
var is_light: bool

func _regenerate_theme() -> void:
    is_light = base_color.get_luminance() >= 0.5
    # ... rest of regeneration ...
```

- **NOT a `@export`.** Computed internally on every regeneration.
- **Dark is the project default**; `is_light` flags the deviation. (Renamed/inverted from godot-minimal-theme's `dark_theme` — semantically clearer for project-default-dark.)
- All conditional formulas in `_regenerate_theme()` branch on `is_light` (godot-minimal-theme line-56 pattern).
- v1 ships dark-only — all 5 v1 `.tres` files have dark `base_color` (luminance < 0.5 → `is_light = false`). The flag is forward-compat: v2 can plug in light variants like `light_pulse_neocade_theme.tres` via two `@export` values (light `base_color`, dark-enough `accent_color`) without code changes.
- Phase 3.4 Override C (`pulse-finalist-override-light.png`) demonstrates the flag wiring works in the renderer today; **Phase 4 MUST carry the same `is_light` branch into GDScript** so production matches the demo. See §6 (color formula contract) for the conditional formulas.

### 4.4 `_regenerate_theme()` lifecycle

Setters on every `@export` property trigger `_regenerate_theme()`:

```gdscript
@export var base_color: Color = Color("#111820"):
    set(value):
        base_color = value
        _regenerate_theme()
# ... same pattern for all 9 exports ...
```

`_regenerate_theme()` populates derived theme entry color/state/sizing values for ALL 37 Control rows + 13 type variations (per Phase 4 success criteria #7). Per-`.tres` Theme Editor entry overrides are stored as additional sections in the `.tres` and survive `_regenerate_theme()` if Phase 4 designs the regenerate logic to skip flagged-as-overridden entries (Phase 4 implementation detail; see GODOT-DYNAMIC-THEME-RESEARCH.md "Architecture Recipe").

### 4.5 What does NOT live in `@export`

- Per-direction unique mood (chip pill shape, brand mark style, primary button radius oversizing, asymmetric tab indicator behavior, surface alpha policy, kicker style, raised lifts list, etc.) — lives in Theme Editor entry overrides per `.tres`.
- Type scale font sizes — derived from `platform` branch in `_regenerate_theme()`, not exported.
- WCAG-driven text colors — derived from `is_light` + `base_color` in `_regenerate_theme()`, not exported.
- State-layer overlay opacities — fixed M3 values (hover 8%, focus 12%, pressed 12%, dragged 16%, disabled 38%) hard-coded in `_regenerate_theme()`, not exported.

---

## §5 Per-theme data-resource recipes

Each entry below is the Phase 4 authoring checklist for one direction's `.tres` file. Phase 4 right-clicks in FileSystem → New Resource → NeoCadeTheme, sets the 9 `@export` values per the table, saves as `{stem}_neocade_theme.tres` at the addon root, then authors Theme Editor entry overrides for the personality details documented in "Theme Editor override intent."

The `@export` defaults below are translated from `.planning/mockups/3.4/data/directions.json` `shape_language` blocks, mapped as follows:
- `base_color` / `accent_color` from §2 (locked palettes).
- `corner_radius` = `axis_1_corner_radius_base_px` from `directions.json`.
- `spacing` = `axis_5_density_padding_px` from `directions.json` (the per-direction density commit; the `_regenerate_theme()` mobile branch scales this for `space.4+` per platform).
- `raised_strength` = `axis_10_raised_primary_offset_px` (the most prominent raised offset axis; secondary/tab/row offsets derive from this scalar in `_regenerate_theme()`).
- `focus_thickness` = `axis_6_focus_thickness_px`.
- `outline_width` = `1` (universal v1 default; per-Control outline tuning is Theme Editor override territory, not `@export`).

### 5.1 Pulse — `pulse_neocade_theme.tres`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#151A2E")` |
| `accent_color` | `Color("#8BFF6A")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `0` |
| `spacing` | `18` |
| `raised_strength` | `3` |
| `focus_thickness` | `2` |
| `outline_width` | `1` |

**Theme Editor override intent (Pulse personality, NOT in `@export`):**
- Brand mark: square cabinet-bezel; mark radius 0; size desktop 54 / mobile 42.
- Buttons: rectangular (radius 0); padding 14×10 (desktop), expanded for mobile per platform branch; primary strategy = "bold-accent-fill-dark-text"; ghost strategy = "accent-outlined-accent-text".
- Tabs: rectangular strip (radius 0); selected indicator = accent fill + 2px bottom rule.
- Chips: rectangular (radius 0).
- Density: 18px padding, 10px inter-control gap; "arcade-dense" feel.
- Surface ramp: 4 stops, "wide" spread (`spreadFactor = 1.3`).
- State-layer deltas: hover +6%, pressed −10%, disabled opacity 0.42.
- Raised lifts (when `raised=true`): primary buttons (offset 3), secondary buttons (1), ghost buttons (1), selected tabs (2), unselected tabs (2), panels (3 × 1.0), dialogs, lists, brand mark, chips. Rows do NOT lift.
- Surface alpha: all 1.00 (cabinet hardware is solid; translucency reads as glass UI = wrong personality).
- Typography: H1 weight 800; H2 weight 740; kicker = "uppercase-tracked-accent".
- Focus style: "tight-cabinet-ring" (`focus_offset = 0`).

**Phase 4 implementation order:** Pulse FIRST (recommended-starter); Slate / Bubble / Daybreak / Burst follow.

### 5.2 Slate — `slate_neocade_theme.tres`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#111820")` |
| `accent_color` | `Color("#8BD3FF")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `14` |
| `spacing` | `22` |
| `raised_strength` | `2` |
| `focus_thickness` | `2` |
| `outline_width` | `1` |

**Theme Editor override intent (Slate personality):**
- Brand mark: rounded-square (radius 14); size desktop 54 / mobile 42.
- Buttons: rounded (radius 14); padding 16×11 (desktop) / 18×12 primary; primary strategy = "quiet-pill-primary"; ghost strategy = "thin-accent-outline".
- Tabs: quiet rounded chrome (radius 14, matching Slate's base radius); selected indicator = restrained accent stripe.
- Chips: full pill (radius 999).
- Density: 22px padding, 14px inter-control gap; "spacious-premium-quiet" feel.
- Surface ramp: 3 stops, "narrow" spread (`spreadFactor = 0.7`).
- State-layer deltas: hover +4%, pressed −6%, disabled opacity 0.50.
- Raised lifts: primary (2), secondary (1), ghost (1), selected tabs (1), unselected tabs (1), panels (2 × 1.0), dialogs, lists, brand mark, selected rows (1), chips.
- Surface alpha: popup_surface 0.92, panels 1.00, buttons 1.00, chrome 1.00 (iOS-premium mood; 8% bleed-through on popup overlay matches iOS NavigationBar/Sheet/modal-backdrop translucency without sliding into glassmorphism).
- Typography: H1 weight 720; H2 weight 640; kicker = "small-caps-subtle".
- Focus style: "ios-style-offset" (`focus_offset = 2`).

### 5.3 Bubble — `bubble_neocade_theme.tres`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#241326")` |
| `accent_color` | `Color("#FFB3E6")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `26` |
| `spacing` | `22` |
| `raised_strength` | `6` |
| `focus_thickness` | `3` |
| `outline_width` | `1` |

**Theme Editor override intent (Bubble personality):**
- Brand mark: circle/squircle (radius 999); size desktop 54 / mobile 42.
- Buttons: heavily rounded (radius 26); padding 20×14 (desktop) / 22×15 primary; primary strategy = "pillowy-fully-rounded-primary" (radius 999 on primary specifically); ghost strategy = "rounded-ghost-thicker-outline".
- Tabs: fully-rounded pill large (radius 999); selected indicator = "accent-fill-plus-raised-offset-on-selected".
- Chips: full pill (radius 999).
- Density: 22px padding, 14px inter-control gap; "friendly-airy-generous" feel.
- Surface ramp: 3 stops, "medium" spread (`spreadFactor = 1.0`).
- State-layer deltas: hover +8%, pressed −10%, disabled opacity 0.45.
- Raised lifts: primary (6), secondary (3), ghost (3), selected tabs (4), unselected tabs (4), panels (6 × 1.0), dialogs, lists, brand mark, selected rows (3), chips.
- Surface alpha: all 1.00 (candy is opaque; translucent candy reads as ice/gelatin = wrong personality).
- Typography: H1 weight 800; H2 weight 760; kicker = "uppercase-tracked-accent".
- Focus style: "cheerful-chunky-ring" (`focus_offset = 2`).

### 5.4 Daybreak — `daybreak_neocade_theme.tres`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#0B2420")` |
| `accent_color` | `Color("#76F2D1")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `8` |
| `spacing` | `24` |
| `raised_strength` | `3` |
| `focus_thickness` | `2` |
| `outline_width` | `1` |

**Theme Editor override intent (Daybreak personality):**
- Brand mark: rounded-square-with-halo (radius 8); size desktop 54 / mobile 42.
- Buttons: gently rounded (radius 8); padding 18×12 (desktop) / 20×13 primary; primary strategy = "friendly-primary-generous-breathing"; ghost strategy = "soft-outline-ghost".
- Tabs: rounded-rect (radius 8); selected indicator = "accent-fill-with-mint-halo-behind".
- Chips: rounded-rect (radius 8).
- Density: 24px padding, 16px inter-control gap; "airy-breathing" feel.
- Surface ramp: 4 stops, "medium" spread.
- State-layer deltas: hover +6%, pressed −6%, disabled opacity 0.50.
- Raised lifts: primary (3), secondary (1), ghost (1), selected tabs (2), unselected tabs (2), panels (3 × 1.0), dialogs, lists, brand mark, selected rows (1), chips.
- Surface alpha: popup_surface 0.90, panels 0.96, buttons 1.00, chrome 1.00 (airy welcoming-lobby mood; 4% bleed on container panels + 10% on popup overlay = airy lift without visual weakness; buttons stay solid for tappability).
- Typography: H1 weight 720; H2 weight 660; kicker = "sentence-case-accent".
- Focus style: "airy-fresh-ring-with-mint-halo" (`focus_offset = 2`).

### 5.5 Burst — `burst_neocade_theme.tres`

| `@export` | Value |
|---|---|
| `base_color` | `Color("#20112E")` |
| `accent_color` | `Color("#FFD166")` |
| `raised` | `false` |
| `platform` | `Platform.AUTO` |
| `corner_radius` | `18` |
| `spacing` | `22` |
| `raised_strength` | `5` |
| `focus_thickness` | `3` |
| `outline_width` | `1` |

**Theme Editor override intent (Burst personality):**
- Brand mark: chunky asymmetric badge (radius 18); size desktop 60 / mobile 48 (the only direction with above-baseline mark size — emphasises celebratory brand presence).
- Buttons: bold rounded (radius 18); primary radius 28 (oversized); padding 20×14 (desktop) / 26×18 primary; primary strategy = "oversized-statement-primary"; ghost strategy = "normal-accent-ghost".
- Tabs: rounded-rect, asymmetric on selected (radius 16); selected indicator = "accent-fill-plus-bigger-size-on-selected".
- Chips: rounded (radius 16).
- Density: 22px padding, 14px inter-control gap; "event-spread-hierarchy-amplified" feel.
- Surface ramp: 4 stops, "wide" spread.
- State-layer deltas: hover +8%, pressed −12%, disabled opacity 0.45.
- Raised lifts: primary (5), secondary (2), ghost (2), selected tabs (3), unselected tabs (3), panels (5 × 1.0), dialogs, lists, brand mark, selected rows (2), chips.
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

### 6.3 Per-color tinted offset tokens (raised mode)

When `raised = true`, every raised element's bottom-edge shadow is the SAME hue as the element bg, just shifted toward `base_color` — **never near-black**. This is the rev-3 fix (handoff at `MOCKUP-REVISION-3-HANDOFF.md`) for the rev-2 darken-floored-at-0 bug.

```gdscript
var accent_offset: Color          = _tint_toward_base(accent_color, base_color)
var surface_high_offset: Color    = _tint_toward_base(surface_high, base_color)
var surface_panel_offset: Color   = _tint_toward_base(surface_panel, base_color)
var surface_overlay_offset: Color = _tint_toward_base(surface_overlay, base_color)
var surface_low_offset: Color     = _tint_toward_base(surface_low, base_color)
```

These offset colors back the StyleBoxFlat shadow on raised elements (see §9 raised variation contract). Each raised Control's offset stylebox uses the matching offset color: a primary button (accent fill) uses `accent_offset` for its bottom edge; a panel (surface_panel fill) uses `surface_panel_offset`.

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
| `role.success` | derived green (per-`.tres` Theme Editor override) | Default `Color("#5CC971")`; directions may override |
| `role.warning` | derived amber | Default `Color("#FFD166")`; directions may override |
| `role.danger` | derived red | Default `Color("#FF6E6E")`; directions may override |
| `role.info` | derived cyan/blue | Default `Color("#5FE3FF")`; directions may override |

`accent_offset`, `accent_rim` (= `_mix(accent_color, Color.WHITE, 0.5)`), and `accent_offset` are derived in `_regenerate_theme()` for raised-mode Control authoring.

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

`corner_radius` is the per-direction **base radius**. Direction `.tres` files override this. Per-Control radius variations (chip = 999, primary button possibly different from base, brand mark, tab) live in Theme Editor entry overrides per `.tres` — they do NOT bake into `@export`. Sentinel `999` = full pill (Theme Editor reads `corner_radius_top_left = 999` etc. and Godot caps at min(width,height)/2). Current v1 radius ladder is Pulse 0, Daybreak 8, Slate 14, Burst 16 tabs / 18 base chrome, Bubble 26 base / 999 pill tabs. `TabContainer.side_margin` follows `corner_radius` so the first tab clears rounded panel shoulders without adding fake margins to `tabbar_background`.

### 8.2 Focus ring construction

- `focus_thickness` = ring thickness in px (per-direction; 2 for Pulse/Slate/Daybreak, 3 for Bubble/Burst).
- `focus_offset` (Theme Editor override per `.tres`) = gap between bg edge and ring start. 0 for Pulse (tight cabinet ring); 2 for Slate/Bubble/Daybreak; 1 for Burst.
- Ring color = `accent_color` (= `role.primary`).
- Ring stylebox = `StyleBoxFlat` with transparent bg, `border_width_*` = `focus_thickness`, border color = `accent_color`, `expand_margin_*` = `focus_offset`. Drawn OUTSIDE corner radius bounds (PITFALLS 1.1).

### 8.3 Outline width

`outline_width` = base outline width on `StyleBoxFlat` borders for inputs / chip outlines / ghost button outlines (default 1px, integer). Per-Control outline tuning (e.g., danger button thicker outline, ghost button thicker outline for "rounded-ghost-thicker-outline" Bubble strategy) lives in Theme Editor entry overrides per `.tres`, NOT in `@export`.

### 8.4 Spacing scale

`spacing` is the per-direction density baseline (in px). It maps to TOKEN-06's 8-step scale: `space.0=0`, `space.1=spacing/4` (rounded), `space.2=spacing/2`, `space.3=spacing*0.75`, `space.4=spacing` (the baseline), `space.5=spacing*1.5`, `space.6=spacing*2`, `space.7=spacing*3`, `space.8=spacing*4`. The desktop branch uses these directly. The mobile branch scales `space.4+` ×1.5 (per architecture revision 2026-05-04 + CROSS-PLATFORM.md mobile floors).

### 8.5 Typography (Inter Variable Roman ONLY — UD-4 Option D)

**v1 ships exactly one font: Inter Variable Roman** (`Inter-Variable.ttf` from Inter v4.x, OFL 1.1). No Outfit. No Noto Sans bundled. No JetBrains Mono bundled. No Inter Italic bundled (synthetic italic transform per FONT-07). Reserved Font Name preserved (file NOT renamed). Imported as `FontFile.tres` referenced by `uid://`. `default_font.allow_system_fallback = true` for non-Latin scripts via OS system fonts.

#### M3 type scale (TOKEN-10, mapped to Godot font sizes)

| M3 token | Inter `wght` | Inter `opsz` | Desktop size | Mobile size | Godot binding |
|---|---|---|---|---|---|
| display-small | 800 | 32 | 36 | 32 | HeaderLarge type variation |
| headline-small | 700 | 32 | 24 | 28 | HeaderMedium type variation |
| title-large | 600 | 24 | 20 | 22 | HeaderSmall type variation |
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

### 8.6 Per-direction kicker style (Theme Editor override territory)

| Direction | Kicker style |
|---|---|
| Pulse | uppercase-tracked-accent |
| Slate | small-caps-subtle |
| Bubble | uppercase-tracked-accent |
| Daybreak | sentence-case-accent |
| Burst | uppercase-bold-larger-scale |

These are Theme Editor entry overrides on the `.kicker` Label type variation (not yet defined in TOKEN-10 — Phase 5 defines the kicker variation; for now, recorded here as a Phase 5 todo).

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
depth_width = ceil(raised_strength * shape.raised_lifts.<family> / 3.0)
sb.border_color = element_offset_color  # per §6.3
sb.border_width_bottom = max(depth_width, face_edge_width + 1)
sb.content_margin_bottom += max(0, sb.border_width_bottom - face_edge_width)

# CRITICAL: do NOT add bevel gradients, texture, glow, or soft drop shadow.
# raised = solid top shape + hard offset darker shape duplicate. That is it.
```

### 9.3 Per-Control raised behavior (PITFALLS-aligned)

Raised intensity by Control family per FLAT-3D-UI-RESEARCH.md + per-direction `axis_10_raised_lifts`:

| Family | Raised behavior |
|---|---|
| Buttons (primary/secondary/ghost) | strongest — normalized from the 0-3 family lift scale; built-in primary/danger bottoms cap at a crisp 3px |
| Selected tabs / chips | medium or flat; tabs do not gain extra bottom depth because they must stay connected to the panel |
| Range handles (slider grabber, scrollbar grabber) | subtle — small hard offset only |
| Panels / dialogs | subtle — normalized from the 0-3 family lift scale (panels lift to convey card-like depth, but flat fill content) |
| Lists / tree / item rows | absent or very subtle — most directions: rows do NOT lift (only Bubble + Daybreak + Slate + Burst's selected rows lift; Pulse rows stay flat) |
| Popup/dialog shells | rare — Phase 4 may opt to keep popup shells flat regardless of `raised` to preserve readability |
| Passive labels / separators | NEVER lift (passive elements have no affordance) |

Per-direction lift list is in §5 (each direction's "Theme Editor override intent" → "Raised lifts" line).

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
| `label_` | 12 | 14 | secondary labels |
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

### 10.4 No separate mobile `.tres`

Per architecture revision 2026-05-04 + flat-layout 2026-05-06d, **there is no `neocade_mobile_theme.tres`**. Mobile is an `@export platform=MOBILE` toggle on the same single class. One `.gd` + 5 `.tres` covers all 4 export-state configurations (flat × raised × desktop × mobile) per direction.

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

## §12 Phase 4 implementation handoff

### 12.1 Files Phase 4 MUST create

1. `addons/neocade_theme/scripts/neocade_theme.gd` — `@tool class_name NeoCadeTheme extends Theme` with the 9 `@export` properties, setters → `_regenerate_theme()`, `is_light` derivation, full theme-entry population logic ported from godot-minimal-theme's `_get_base_color` + entry-population pattern (driven by `@export` reads, not `EditorSettings`).
2. `addons/neocade_theme/pulse_neocade_theme.tres` — `[gd_resource type="NeoCadeTheme" format=3]` with §5.1 values + Pulse Theme Editor entry overrides.
3. `addons/neocade_theme/slate_neocade_theme.tres` — §5.2 values + Slate overrides.
4. `addons/neocade_theme/bubble_neocade_theme.tres` — §5.3 values + Bubble overrides.
5. `addons/neocade_theme/daybreak_neocade_theme.tres` — §5.4 values + Daybreak overrides.
6. `addons/neocade_theme/burst_neocade_theme.tres` — §5.5 values + Burst overrides.

Plus package metadata files (`LICENSE.md`, `README.md`, `docs/usage.md`, `CHANGELOG.md`, `VERSION`) and bundled font license `addons/neocade_theme/fonts/inter_ofl.txt` per FOUND-01.

### 12.2 Files Phase 4 MUST delete

- `addons/neocade_theme/neocade_theme.tres` — the existing empty Theme scaffold from project init. Under the locked architecture **no root `.tres` ships**. Deletion happens in the FIRST Phase 4 task.

### 12.3 Files Phase 4 MUST NOT create

- No per-direction `.gd` files. Each direction is purely data on the single class.
- No `themes/` subfolder. All 5 `.tres` files live at the addon root.
- No `_dev/` subfolder. (Spike artifacts at `.planning/spikes/dynamic-theme/` stay in `.planning/`, not under `addons/`.)
- No `neocade_mobile_theme.tres`. Mobile is a `platform=MOBILE` toggle.
- No `plugin.cfg` (per STACK Decision 5 — not an editor plugin).

### 12.4 Dependency order (Phase 4 task sequencing)

1. **Delete scaffold** `addons/neocade_theme/neocade_theme.tres`.
2. **Author `neocade_theme.gd`** — class shell + 9 `@export` properties + setters + `_regenerate_theme()` skeleton + `is_light` derivation.
3. **Implement formulas** — port §6 surface ramp, §6.3 per-color offsets, §6.5 state layers, §7 role tokens, §8 typography binding, §9 raised stylebox construction, §10 platform branch.
4. **Author Pulse `.tres`** (recommended starter — implement first).
5. **Verify Pulse** — load into a test scene, toggle `raised` / `platform`, confirm regeneration matches Phase 3.4 mockup output.
6. **Author Slate, Bubble, Daybreak, Burst `.tres`** — apply §5.2-§5.5 values + Theme Editor overrides.
7. **Root docs + clean addon packaging** — document consumer pattern (`preload("res://addons/neocade_theme/{name}_neocade_theme.tres")`), recommended starter (Pulse), custom theme authoring (`NeoCadeTheme.new()`), and keep non-runtime docs outside `addons/neocade_theme/` except the required bundled font OFL file.

### 12.5 Verification checkpoints

Phase 4 is feature-complete when:
- All 9 `@export` properties exist on `NeoCadeTheme` with the correct types, defaults, group labels, and setter wiring.
- `is_light` flag is computed correctly from `base_color.get_luminance()` and branches all conditional formulas.
- `_regenerate_theme()` populates entries for every Control in the §5 implementation order without errors.
- All 5 `.tres` files load successfully and produce visually distinct themes matching their Phase 3.4 finalist mockup commitment (Pulse 4-grid + 4 Stage 1 concept boards for Slate/Bubble/Daybreak/Burst).
- Toggling `raised` / `platform` / `base_color` / `accent_color` on any `.tres` produces correctly regenerated entries (Phase 3.2 spike pattern).
- No theme-default-overlay errors at editor or runtime load time.
- WCAG audit re-runs against the implemented theme produce the same ratios as `wcag-palette-audit.md`.

### 12.6 Cross-phase consumer references

| Phase | Uses DESIGN_TOKENS.md for |
|---|---|
| 4 | Class contract + `.tres` recipes + formula ports + delete-list + create-list |
| 5 | TYPEVAR-01..05 type variation authoring (Button + Label + RichTextLabel + Panel families) |
| 6 | Tree / ItemList / TabBar / Range Control entries (formulas in §6 + raised behavior in §9) |
| 7 | Popup-class theming + ColorPicker icons + Graph theming (§7 role tokens + §8 typography) |
| 8 | Mobile branch validation against §10 platform tokens; tap-target audit against §11.2 |
| 9 | Showcase scene preloads recommended starter (§3); theme picker cycles all 5 `.tres` files |

---

**End of DESIGN_TOKENS.md.** Phase 4 begins after `/gsd-verify-work` of Phase 3.4 closes the phase.
