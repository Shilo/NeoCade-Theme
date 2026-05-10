# Phase 12: Signature Visual Moves - Research

**Researched:** 2026-05-10
**Domain:** Godot 4.6 Theme / StyleBoxFlat / BINDING_TABLE recipe surgery
**Confidence:** HIGH for C4; HIGH for C2'; HIGH for C6 (with one OPEN flag on letter-spacing implementation in Pulse kicker)

## Summary

Phase 12 is implementation-ready. The spike series (001-005) and 8+ rounds of locked decisions (D-12.01..D-12.29 in `12-CONTEXT.md`) have completed the discussion work. This research validates the planner's required Godot 4.6 API points, locates the exact source lines and BINDING_TABLE rows that need rebinding, confirms the runtime state inventory is **empty** (Phase 12 is a pure code change — no data migrations, no stored state, no OS registrations), and surfaces the cross-cutting concerns the planner must thread through.

The three signature moves resolve cleanly against the current architecture:
- **C4** is a 6-line rewrite of `_raised_depth_color` at `addons/neocade_theme/scripts/neocade_theme.gd:800-806`. Every callsite (12 of them at lines 343-345, 394-405) keeps its signature. `Color.from_hsv` and `Color.h/s/v` are confirmed Godot 4.6 API.
- **C2'** rebinds 8 existing BINDING_TABLE recipe rows from neutral tokens to `accent_color`-derived tokens. No row count change (37-row freeze preserved). No new public exports.
- **C6** edits the 5 entries of `STYLE_PERSONALITY` (lines 913-1094) and the `STYLE_PERSONALITY_DEFAULT` (1158-1189) to add per-direction signature keys; thread those keys through the existing stylebox builder in `_resolve_recipe()` (line 5276+). One new TYPE_VARIATION (`SectionKicker`) joins the existing 47-entry registry.

**Primary recommendation:** Implement in three waves matching `D-12.20`'s fallback boundary: Wave 1 = C4 atomic (~30 min, single function). Wave 2 = C2' (8 rebind rows + showcase deltas, ~2-3h). Wave 3 = C6 (5 per-direction sub-features, ~4-6h). Each wave is independently shippable per the locked invariants.

## User Constraints (from CONTEXT.md)

### Locked Decisions

**C4 - HSV value-darken depth formula (D-12.01..D-12.05):**
- D-12.01: Replace body of `_raised_depth_color(element: Color, base_c: Color) -> Color` at `addons/neocade_theme/scripts/neocade_theme.gd:800-806`. `base_c` stays in signature, becomes unused.
- D-12.02: Use this exact body:
  ```gdscript
  func _raised_depth_color(element: Color, base_c: Color) -> Color:
      var strength: float = 0.20 + 0.10 * float(raised_strength)
      var h: float = element.h
      var s: float = element.s
      var v: float = element.v * (1.0 - strength)
      var result := Color.from_hsv(h, s, max(v, 0.04))
      result.a = element.a
      return result
  ```
- D-12.03: No callsite changes - signature preserved.
- D-12.04: Verification: hue rotation = 0.0 deg, saturation drop = 0%, value drop = strength.
- D-12.05: Only fires when `raised=true` (existing zero-3D path when `raised=false` is preserved).

**C2' - Accent expansion in idle chrome (D-12.06..D-12.10):**
- D-12.06: Headline fix. Rebind existing BINDING_TABLE rows to use accent-derived tokens in idle state.
- D-12.07: Six rebind targets (final, locked):
  1. TabBar `tab_selected` top stripe -> accent
  2. TabContainer `tab_selected` top stripe -> accent
  3. ItemList `selected` / `selected_focus` row indicator -> accent
  4. Tree `selected` / `selected_focus` row indicator -> accent
  5. Section kicker text color -> accent (currently routes via `_apply_kicker_style`)
  6. Slider / Range active value/section indicators -> accent
  7. Section-header underlines -> accent (or `accent_offset` if full accent is too loud)
- D-12.08: No new BINDING_TABLE rows. Preserve 37-row freeze, slot-name freeze, recipe shape - only color sources change.
- D-12.09: Hue invariant. Use `accent_color`, `accent_offset`, `accent_rim` only. No new hues.
- D-12.10: Hold on both DESKTOP and MOBILE platform paths.

**C6 - Per-direction signature moves (D-12.11..D-12.15):**
- D-12.11: Per direction:
  - **Pulse** - `SectionKicker` Label variation, uppercase-tracked, 10px, accent-colored.
  - **Slate** - `shape.hairline_thickness = 1`, threaded through stylebox borders.
  - **Bubble** - Floor radius keys to `max(existing, 26)` across all chrome.
  - **Daybreak** - `primary_outline_color/offset/width` for flat 1px accent outline at 3px offset; bump `primary_padding` to `Vector2i(20, 14)`. **NO halo, NO glow.**
  - **Burst** - `primary_min_height = 56` desktop / `64` mobile (implemented via stylebox padding because Godot 4.6 Button exposes no `minimum_size_height` theme constant; see Q15 below).
- D-12.12: SC#1 locked invariant. `raised=false` must show ZERO 3D anywhere. Every C6 move must verify it leaves a flat result when `raised=false`.
- D-12.13: SC#3 locked. No glow halos. Outline + padding only.
- D-12.14: SC#4. Greyscale-thumbnail-identifiable gate.
- D-12.15: All C6 changes live in `STYLE_PERSONALITY` and dependent recipe code.

**Public API and contract invariants (D-12.16..D-12.20):**
- D-12.16: Zero public-export changes. 12-export contract preserved.
- D-12.17: `Style.CUSTOM` gracefully falls back via `STYLE_PERSONALITY_DEFAULT`. C6 moves gated on explicit style enum. C2' applies universally.
- D-12.18: No `.tres` migration - canonical resource regenerates automatically.
- D-12.19: No new SVGs needed.
- D-12.20: Mid-phase fallback at C4 + C2' (~3-4h) leaves a shippable state.

**Showcase additions (D-12.21..D-12.23):**
- D-12.21: Demo Pulse `SectionKicker` chrome in existing "Buttons" or new "Identity" section.
- D-12.22: C2' visible automatically in existing chrome.
- D-12.23: No new role/role-panel variations (those belong to Phase 13).

**Verification gates (D-12.24..D-12.29):** See Validation Architecture section below.

### Claude's Discretion

- Exact stylebox-stacking technique for Daybreak's outline (StyleBoxFlat `border_width_*` + `expand_margin_*` vs. drawing a second wrapping stylebox).
- Exact Pulse `SectionKicker` registration (new TYPE_VARIATIONS entry vs. reuse of existing `Kicker`).
- Ordering of BINDING_TABLE rebinds (alphabetical vs. by Control class).
- Greyscale-thumbnail verification tooling.
- 30-config smoke matrix dimensions.

### Deferred Ideas (OUT OF SCOPE)

- **C1** - Role Label variations (`SuccessLabel`/`WarningLabel`/`DangerLabel`/`InfoLabel`) -> Phase 13.
- **C3** - Role Panel variations (`AccentPanel`/`InfoPanel`/`WarningPanel`/`DangerPanel`/`SuccessPanel`) -> Phase 13.
- **C2** - MD3 secondary/tertiary auto-derivation -> deferred to future spike + opt-in export.
- **C5** - Per-direction lift thickness scaling -> deferred for re-evaluation after Phase 12.
- Surface tonal range expansion - separate post-Phase-12 spike.
- New top-level `@export var` properties - forbidden by SC#6.
- Light color mode, alternate palettes, real-device QA - all v1.x or v2 deferred.
- Asset Library submission, `plugin.cfg`, editor plugin - not on v1 roadmap.
- Bespoke severity SVGs - Phase 12+1 polish.
- Halo / glow / shadow chrome - locked out by PROJECT.md and SC#3.
- Animations beyond Godot StyleBox transitions - out-of-scope per spike constraint filter.

## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| (none) | Phase 12 is post-v1 visual-identity work; no REQUIREMENTS.md REQ-IDs map here | Coverage is via the 6 locked SCs in `12-CONTEXT.md` D-12.24..D-12.29 |

The 6 locked success criteria carry the requirement weight:
1. SC#1 - `raised=false` MUST show ZERO 3D elements
2. SC#2 - `raised=true` keeps current lift subset (panels + buttons lift, tabs do not)
3. SC#3 - No glow halos in any state
4. SC#4 - Every direction identifiable at thumbnail scale via greyscale render
5. SC#5 - No new hues introduced (C2' redistributes existing accent)
6. SC#6 - Zero public-export changes (12-export contract preserved)

## Project Constraints (from CLAUDE.md)

Direct directives that constrain Phase 12 implementation:
- **Flat MD3 / MD3 Expressive only.** No textures, no patterns, no embossing, no painterly/leather/wood/grunge chrome, no gradients on chrome, no synthwave/neon-noir/cyberpunk, no pixel art in the theme itself. [VERIFIED: CLAUDE.md line 5]
- **Raised depth uses solid colors + offset darker flat shape duplicates only.** No drop shadows, no blurred halos. [VERIFIED: CLAUDE.md line 5]
- **Single concrete `@tool class_name NeoCadeTheme extends Theme` at `res://addons/neocade_theme/scripts/neocade_theme.gd`.** No subclasses, no per-direction `.gd` files, no per-style `.tres` files. [VERIFIED: CLAUDE.md line 7]
- **12 exports, hard locked.** Phase 12 may NOT add new top-level `@export var` properties. [VERIFIED: CLAUDE.md line 9]
- **Canonical resource is `res://addons/neocade_theme/neocade_theme.tres`.** No per-style sibling resources. [VERIFIED: CLAUDE.md line 13]
- **Light/dark behavior luminance-derived from `base_color`.** Phase 12 must not assume `is_light=false`. [VERIFIED: CLAUDE.md line 11]
- **Pulse is the recommended starter and showcase default, no architectural privilege.** Phase 12's C6 Pulse move (kicker) must NOT propagate to other directions' defaults. [VERIFIED: CLAUDE.md line 13]

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| HSV value-darken depth (C4) | Color helper layer (`_raised_depth_color`) | Stylebox builder consumes via `offset_color` parameter | Single function rewrite; depth math is pure color transformation isolated from stylebox assembly |
| Accent rebind in idle chrome (C2') | BINDING_TABLE recipe row data | `_resolve_recipe()` color branch consumes recipes unchanged | Pure data edit; the resolution path already supports the necessary tokens |
| Per-direction shape keys (C6) | `STYLE_PERSONALITY[Style.X].shape` data | `_resolve_recipe()` stylebox branch + new helper paths for outline/hairline/min-height | Shape data is the existing extensibility point; new keys flow through existing `_lookup_shape()` dispatch |
| SectionKicker registration (C6 Pulse) | `TYPE_VARIATIONS` const + `BINDING_TABLE["SectionKicker"]` | `_regenerate_theme()` `set_type_variation` loop (line 429-433) + explicit `set_font`/`set_font_size` calls | Existing pattern for Label variations; adding one row to two const dicts |
| Greyscale thumbnail verification (SC#4) | Headless Godot renderer + `Image.adjust_bcs` | Phase 12 verify helper script | `Image.adjust_bcs(0, 0, -1)` desaturates; saved PNGs scored by user attestation per Phase 9/10 precedent |
| 30-config smoke matrix (SC#6) | Phase 12 verify helper (headless GD) | `NeoCadeTheme.new()` + iterate axes | Pattern established by Phase 4 verify helpers; iterate style x raised x platform configs |

## Standard Stack

### Core (already present in codebase, no installation needed)

| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Godot Engine | 4.6 (`config_version=5`) | Theme runtime + StyleBoxFlat primitives | [VERIFIED: `project.godot` config_version=5] Project locked to 4.6 by Phase 3.2 feasibility validation |
| Inter Variable Roman | OFL 1.1 bundled | Theme default_font (the only bundled font) | [VERIFIED: addons/neocade_theme/fonts/inter_variable.ttf] UD-4 / Option D / FONT-REVIEW.md locked |

### Supporting (used by Phase 12 verification)

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| Godot SceneTree headless mode | 4.6 | Run verify scripts via `godot --headless --quit --script ...` | Phase 12 dual verify helpers (EditorScript + SceneTree) follow the Phase 4-8 precedent |
| `Image.adjust_bcs(brightness, contrast, saturation)` | Godot 4.6 native | Desaturate rendered showcase screenshots to greyscale | [CITED: docs.godotengine.org/en/4.6/classes/class_image.html] SC#4 verification |

### Godot 4.6 APIs verified for Phase 12

- `Color.from_hsv(h: float, s: float, v: float, alpha: float = 1.0) -> Color` -- static constructor. Parameters typically 0.0..1.0. [CITED: docs.godotengine.org/en/4.6/classes/class_color.html]
- `Color.h`, `Color.s`, `Color.v` -- float properties, range 0.0..1.0. [CITED: docs.godotengine.org/en/4.6/classes/class_color.html]
- `StyleBoxFlat.border_width_left/top/right/bottom: int` -- per-side border widths. [CITED: docs.godotengine.org/en/4.6/classes/class_styleboxflat.html]
- `StyleBoxFlat.expand_margin_left/top/right/bottom: float` -- expands stylebox **outside** control rect; does NOT affect clickable area. [CITED: docs.godotengine.org/en/4.6/classes/class_styleboxflat.html] -- the right tool for Daybreak's "outline 3px outside button edge".
- `StyleBoxFlat.draw_center: bool` -- toggles inner fill. Could be useful for a pure-outline stylebox; not strictly required for Daybreak because the inner button stylebox handles the fill.
- Button theme properties confirmed: no `minimum_size_height` constant. Burst's "oversized 56-64px primary CTAs" MUST be implemented via stylebox `content_margin` (which expands `minimum_size`) -- see Q15 below.
- Label theme properties confirmed: no letter-spacing / tracking theme constant. The "tracked-uppercase" Pulse kicker tracking is CONTENT-side (showcase text must use uppercase, no theme-level tracking). Already documented at `neocade_theme.gd:1203-1211`.

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| `Color.from_hsv` for C4 | `_mix(element, Color.BLACK, 0.40)` | Black-mix reduces saturation as a side effect; spike 002b verdict iteration 4 rejected this as drift from HCGames "same hue family" target |
| Stacked StyleBoxFlat for Daybreak outline | Single StyleBoxFlat with `expand_margin_*` + thin `border_width_*` | The single-stylebox path is simpler and matches the existing `_apply_outline_border` helper. **CHOSEN.** A wrapping PanelContainer at consumer-code level was considered and rejected because v1 theme must own the outline without consumer scaffolding |
| Burst oversized via theme constant | Stylebox content_margin only | Godot 4.6 Button has no `minimum_size_height` theme property; content_margin is the only path. **NO CHOICE** (forced by API) |
| New `SectionKicker` variation | Reuse existing `Kicker` variation | The existing `Kicker` (line 1240) is already wired across the codebase with `font_color` dispatching via `_apply_kicker_style`. **Reusing `Kicker` is simpler.** New `SectionKicker` adds churn. Recommend: edit `_apply_kicker_style` so all directions whose `kicker_style` starts with `uppercase-tracked` return accent (already does); ensure Pulse's existing `uppercase-tracked-accent` value is bound through `Kicker.font_color`. Already wired - the C6 Pulse signature may be primarily SHOWCASE-side (add a Kicker label demonstrating the existing chrome). **OPEN: planner decides** |

**Version verification:** Godot 4.6 is the project's locked engine version (`project.godot` `config_version=5`). No npm-style version churn here -- the engine version is gated by the Godot project file.

## Architecture Patterns

### System Architecture Diagram (Phase 12 surfaces)

```
User exports change (style/raised/platform/base/accent/...)
  -> @export setter fires
  -> _after_direction_export_changed() / _after_variant_export_changed()
  -> _sync_style_from_exports() (if direction export)
  -> _regenerate_theme()
       |
       +-- (existing) compute role_table from base/accent/spread/personality
       |       |
       |       +-- _raised_depth_color() <<< C4 REWRITE LANDS HERE >>>
       |       |
       |       +-- writes role_table[..._offset] for 12 raised-depth slots
       |
       +-- (existing) walk TYPE_VARIATIONS, register variations
       |       |
       |       +-- (C6 Pulse, optional) add "SectionKicker" entry if not reusing Kicker
       |
       +-- (existing) walk BINDING_TABLE
       |       |
       |       +-- _resolve_recipe(recipe, data_type, role_table, tokens, style_personality)
       |       |       |
       |       |       +-- stylebox branch: reads `role`, `border_role`, `radius`,
       |       |       |    `padding`, `raised_intensity`, `border_widths`, `alpha`
       |       |       |    <<< C6 SLATE hairline_thickness / DAYBREAK outline / BURST padding >>>
       |       |       |
       |       |       +-- color branch: <<< C2' rebinds change `role` strings here >>>
       |       |       |
       |       |       +-- _apply_kicker_style(): kicker_style enum -> font color
       |
       +-- (existing) _apply_separator_styleboxes(): HSeparator/VSeparator/PopupMenu separators
              |
              +-- currently uses role_table.outline_color
              <<< C2' Section-header underline option: rebind to accent_offset >>>
```

### Recommended Project Structure

No new directories. All edits land in:

```
addons/neocade_theme/
  scripts/
    neocade_theme.gd               # C4 rewrite (line 800-806), C2' rebinds (BINDING_TABLE),
                                   # C6 STYLE_PERSONALITY edits (line 913-1094 + DEFAULT line 1158-1189),
                                   # C6 helper code in _resolve_recipe() (~line 5276+)
                                   # Optionally: new SectionKicker TYPE_VARIATIONS entry (line 1212+)
  neocade_theme.tres               # NO edit needed; regenerates automatically on next theme load

showcase/
  showcase.tscn                    # ONE-LINE edit: add a SectionKicker (or Kicker) Label
                                   # above the "Buttons" section heading to demo Pulse C6

.planning/phases/12-signature-visual-moves/
  helpers/
    _phase12_verify.gd             # NEW: EditorScript variant (Phase 4 precedent)
    _phase12_verify_headless.gd    # NEW: SceneTree headless variant (Phase 4-8 precedent)
    _phase12_thumbnail_render.gd   # NEW: render each direction at 256x144, save greyscale PNG
                                   #      for SC#4 user attestation
    _phase12_smoke_matrix.gd       # NEW: iterate 30-config smoke matrix for SC#6 export-count assertion
```

### Pattern 1: HSV value-darken depth (C4)

**What:** Replace surface-anchored depth with element-anchored depth at a `raised_strength`-scaled value-darken factor.
**When to use:** Phase 12 Wave 1 -- single function body rewrite, atomic.
**Example:**
```gdscript
# Source: .planning/spikes/visual-identity-distinctiveness/002b-raised-depth-formula-hsv-darken/README.md
# Replaces body of neocade_theme.gd:800-806 (D-12.02 verbatim)
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    var strength: float = 0.20 + 0.10 * float(raised_strength)
    var h: float = element.h
    var s: float = element.s
    var v: float = element.v * (1.0 - strength)
    var result := Color.from_hsv(h, s, max(v, 0.04))
    result.a = element.a
    return result
```

### Pattern 2: BINDING_TABLE color rebind (C2')

**What:** Change the `role` field of an existing recipe entry from a neutral token (e.g., `text_muted`, `outline_color`, `button_pressed`) to an accent token (`role_primary`, `accent_offset`, `accent_rim`).
**When to use:** Each of the C2' rebinds (D-12.07 items 1-7).
**Example:**
```gdscript
# Source: neocade_theme.gd:3443-3446 BEFORE
"tab_selected": {"role": "button_pressed", "border_role": "button_border_pressed",
                "raised_intensity": 0, "border_width": 0,
                "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},

# AFTER (C2' rebind: add top accent stripe via border_widths Vector4i)
"tab_selected": {"role": "button_pressed", "border_role": "role_primary",
                "raised_intensity": 0,
                "border_widths": Vector4i(0, 2, 0, 0),  # 2px top edge only
                "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

The `_resolve_recipe()` stylebox branch already supports `border_widths: Vector4i` (line 5382-5389) for asymmetric borders. The 2px top stripe approach is faithful to the mockup-refined-plan.html visual.

### Pattern 3: Per-direction shape key (C6)

**What:** Add a new key to `STYLE_PERSONALITY[Style.X].shape` (or `STYLE_PERSONALITY_DEFAULT.shape`) and reference it from BINDING_TABLE recipes via the existing `shape.<key>` string convention (handled by `_lookup_shape()`).
**When to use:** Slate hairline_thickness, Bubble min_radius_floor, Daybreak primary_outline_*, Burst primary_min_height.
**Example:**
```gdscript
# Source: neocade_theme.gd:954 (Slate STYLE_PERSONALITY) AFTER
Style.SLATE: {
    "spread_factor": 0.7, "hover_pct": 4.0, "pressed_pct": -6.0,  "disabled_opacity": 0.50,
    "shape": {
        "primary_radius":        14,
        # ... existing keys preserved ...
        "hairline_thickness":    1,   # <<< C6 Slate addition
        "focus_offset":  2,
        "kicker_style":  &"small-caps-subtle",
    },
},
```

### Anti-Patterns to Avoid

- **Editing `Theme.clear`**: do not introduce a new path that clears the theme; the existing `clear()` in `_regenerate_theme()` (line 261) is the single canonical clear -- the no-`Theme.clear` invariant from Phase 4 still holds.
- **Adding a new `@export` property** for any C6 constant (e.g., `hairline_thickness`, `primary_outline_width`). SC#6 forbids. These live inside `STYLE_PERSONALITY.shape`.
- **Drawing the Daybreak outline as a second wrapping PanelContainer in showcase.** The theme owns the outline. A consumer should not need to wrap their button in extra nodes.
- **Hand-rolling a new BINDING_TABLE recipe row** for C2'. The 37-row freeze (Cycle 1 C1) prevents this; the rebinds only change the **color source** of existing rows.
- **Stacking two StyleBoxFlat instances for Daybreak's outline + fill.** Godot does not natively support stacked styleboxes per slot. The single-stylebox + `expand_margin_*` + `border_width_*` approach is the correct path -- both are properties of the same StyleBoxFlat.
- **Treating `accent_color` and `role_primary` as separate tokens.** In `role_table` (line 598-599), `role_primary` IS `accent_color`. C2' rebinds should use `role_primary` (the canonical role-table key) for consistency with the rest of the codebase.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| HSV color-space conversion | Manual `rgb_to_hsv` math | `Color.from_hsv()` + `Color.h/s/v` accessors | Built-in, gamma-correct, single-pass |
| Outline outside button edge | Wrapping stylebox / `Control` parent | `StyleBoxFlat.expand_margin_*` + `border_width_*` | Native Godot 4.6 path; explicitly designed for "border outside control rect" per `expand_margin_*` docstring |
| Button minimum height for Burst | Custom `set_constant("minimum_size_height", ...)` | Stylebox `content_margin_top/bottom` | Godot 4.6 Button has no such theme constant; content_margin already drives minimum_size |
| Greyscale conversion of rendered PNG | Per-pixel luminance loop | `Image.adjust_bcs(0.0, 0.0, -1.0)` | Native, fast, deterministic |
| Letter-spacing on Pulse Kicker | Custom Font shader or per-char position | Showcase-side `text = "DEMO KICKER"` (uppercase content) + accept the rendered tracking is character-only | Godot 4.6 Label/Theme has no letter-spacing slot. Documented at `neocade_theme.gd:1203-1211`. The "tracked" feel is content-side per Phase 5 closure |

**Key insight:** Every Phase 12 candidate fits inside existing Godot 4.6 Theme/StyleBox primitives. No shaders, no GDExtension, no plugin scripts. The spike series specifically filtered candidates that needed those.

## Runtime State Inventory

This is a rename/refactor-adjacent change set (it modifies internal recipes and constants without touching the public API), so a runtime-state audit is warranted.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | **None.** No databases, no persisted user data. The canonical resource `addons/neocade_theme/neocade_theme.tres` stores only the 12 export values via the inspector serializer; it does NOT serialize derived theme entries (those regenerate every load via `_init() -> _regenerate_theme()` at line 167-168). | No data migration. The `.tres` file is unchanged by Phase 12. [VERIFIED: line 167-168 + line 261 `clear()` invariant] |
| Live service config | **None.** No external services. The Godot project is self-contained. | None |
| OS-registered state | **None.** No Windows Task Scheduler, no systemd, no launchd. | None |
| Secrets/env vars | **None.** No secrets, no env vars. | None |
| Build artifacts | **Stale verify helpers reference removed paths.** `_phase8_verify_headless.gd:4-6` references `pulse_neocade_theme.tres`, `neocade_mobile_theme.tres`, and `neocade_theme.tres` (multiple paths) -- all but the canonical `neocade_theme.tres` were removed during 2026-05-08 consolidation. | **Heads-up for the planner.** Phase 12 verify helpers must reference only `res://addons/neocade_theme/neocade_theme.tres`. Existing helpers should not be run as part of Phase 12 verification; Phase 12 ships its own helpers. |

**The canonical question:** *After every file in the repo is updated, what runtime systems still have the old behaviors cached, stored, or registered?* -- **Nothing.** A consumer who has `var theme = preload("res://addons/neocade_theme/neocade_theme.tres")` instantiated in a scene re-loads the resource on next scene open and `_regenerate_theme()` rebuilds all theme entries from scratch. There is no caching beyond `_persistent_icon_cache` and `_persistent_generated_texture_cache` (both internal, both invalidated by setter changes and by the `texture_cache: false` default).

## Common Pitfalls

### Pitfall 1: `raised=false` accidentally retains 3D leakage from C6 moves

**What goes wrong:** A C6 move (e.g., Daybreak's outline) renders even when `raised=false`, violating SC#1.
**Why it happens:** The C6 outline lives in the primary button's stylebox itself, not in a separate "raised" code path. If the implementation hardcodes `expand_margin_*` regardless of `raised`, the outline shows in flat mode too.
**How to avoid:** Daybreak's outline (the only C6 move with a potential leakage axis) MUST be gated on `raised` inside the stylebox builder. The plan must explicitly state: "Daybreak outline applies only when `raised=true`". Alternatively, scope the outline to a single side that vanishes naturally in flat mode -- but the cleanest implementation is an explicit `if raised: apply_outline(...)` gate in `_resolve_recipe()`.
**Warning signs:** Verifier should compare flat-mode pixel hash before/after Phase 12 implementation for each direction. Any diff in `raised=false` chrome that isn't a C4 / C2' / Kicker color is a SC#1 regression.

### Pitfall 2: `raised_strength=0` produces `_raised_depth_color = element * 0.80`, NOT element

**What goes wrong:** A consumer who sets `raised_strength=0` (the minimum) expects depth-strip = button face. The new formula gives 20% darken, not 0%.
**Why it happens:** D-12.02 formula `0.20 + 0.10 * raised_strength` starts at 20%, not 0%.
**How to avoid:** This is **intentional** per the spike 002b verdict (40% target at raised_strength=2, so raised_strength=0 is "subtle but visible"). Document in CHANGELOG that the depth at strength=0 is 20% darker, not identical. The existing `_raised_depth_color` already produces ~26% darker at strength=2 (per spike 002a), so the new minimum of 20% is *quieter* than today's depth -- no regression in user-perceived volume.
**Warning signs:** None expected, but the planner should flag this in plan notes for awareness.

### Pitfall 3: GL Compatibility renderer over-renders alpha on chrome borders

**What goes wrong:** Daybreak's 1px flat outline at full alpha looks fine in GL Compatibility; but if it were rendered with `border_alpha < 1.0`, the GL Compat renderer would over-render the alpha (Godot issue #23640), making the outline look thicker than spec.
**Why it happens:** Documented in PROJECT.md SUMMARY Conflict 3 (2026-05-04): the `shadow_size = -1` workaround exists specifically because of this.
**How to avoid:** Daybreak's outline MUST be full alpha (1.0). This is already in CONTEXT.md D-12.26 ("Verification: no `Color()` with alpha `< 1.0` and `> 0.0` is bound as an outline / shadow / outer-border slot"). Verify in the SC#3 gate.
**Warning signs:** If Daybreak's outline reads "halo-like" in the rendered showcase, check `border_alpha`. It must be 1.0 (the recipe default).

### Pitfall 4: Bubble's "floor to 26 radius" floors `primary_radius=999` to 999, not 26

**What goes wrong:** A naive `floor` implementation reads `max(existing, 26)` and applies it to `primary_radius=999`, returning 999 (correct), but a misunderstood "force to 26" would clamp the pill primary to 26.
**Why it happens:** The CONTEXT.md D-12.11 Bubble row says "Forced >=26 corner radius across ALL chrome (pillow silhouette everywhere)" -- meaning **minimum** 26, not exactly 26.
**How to avoid:** Implement as `max(existing, 26)` not `26`. Bubble's `primary_radius=999` (line 993) and `tab_radius=999`/`chip_radius=999` stay at 999.
**Warning signs:** If Bubble's primary buttons stop reading as a pill, the floor was implemented as a clamp.

### Pitfall 5: `Style.CUSTOM` users hit a missing key error on `STYLE_PERSONALITY_DEFAULT`

**What goes wrong:** A C6 move adds `shape.primary_outline_width` only to Daybreak; the recipe in `_resolve_recipe` reads `_lookup_shape(style_personality, "shape.primary_outline_width")` for ALL directions; CUSTOM users get a `null` return that breaks downstream code.
**Why it happens:** `STYLE_PERSONALITY_DEFAULT` at line 1158-1189 is used for `Style.CUSTOM`. If a C6 key is added per-direction but NOT to DEFAULT, CUSTOM consumers see broken behavior.
**How to avoid:** EVERY new `shape.<key>` introduced by C6 must also be added to `STYLE_PERSONALITY_DEFAULT.shape`, with a no-op default value:
  - `hairline_thickness: 0` (Slate adds 1; default off)
  - `min_radius_floor: 0` (Bubble adds 26; default off)
  - `primary_outline_color: &""` (Daybreak adds `&"accent"`; default off / falsy)
  - `primary_outline_offset: 0` (Daybreak adds 3; default off)
  - `primary_outline_width: 0` (Daybreak adds 1; default off)
  - `primary_min_height: 0` (Burst adds 56; default off)
The `_resolve_recipe()` code path must check for the no-op value and skip the mutation -- e.g., `if hairline_thickness <= 0: do not apply hairline border`.
**Warning signs:** Verifier should set `style = Style.CUSTOM` and call every recipe; if any recipe returns `null` or throws, a default key is missing.

### Pitfall 6: Phase 4 verify helpers reference stale paths (post-2026-05-08 consolidation)

**What goes wrong:** The planner copies the Phase 4 verify pattern verbatim, including `const PULSE_PATH := "res://addons/neocade_theme/pulse_neocade_theme.tres"` -- but this file was deleted during 2026-05-08 consolidation.
**Why it happens:** The Phase 4 helper was authored before the single-canonical-resource architecture.
**How to avoid:** Phase 12 verify helpers MUST use `res://addons/neocade_theme/neocade_theme.tres` as the single load path, and they must call `theme.style = NeoCadeTheme.Style.PULSE` (etc.) to test each direction by toggling, not by loading separate resources. The setter dispatch at line 49-58 handles this cleanly.
**Warning signs:** Verifier fails with "ResourceLoader.load returned null" or "is not NeoCadeTheme" assertion -- the path is wrong.

## Code Examples

Verified patterns from official sources and the existing codebase:

### C4 implementation (verbatim from spike 002b iteration 5)

```gdscript
# Source: .planning/spikes/visual-identity-distinctiveness/002b-raised-depth-formula-hsv-darken/README.md
# Replaces addons/neocade_theme/scripts/neocade_theme.gd:800-806
func _raised_depth_color(element: Color, base_c: Color) -> Color:
    # base_c retained in signature for callsite compatibility but unused;
    # depth is now element-anchored, not surface-anchored (HCGames anchor).
    var strength: float = 0.20 + 0.10 * float(raised_strength)
    var h: float = element.h
    var s: float = element.s
    var v: float = element.v * (1.0 - strength)
    var result := Color.from_hsv(h, s, max(v, 0.04))
    result.a = element.a
    return result
```

### C2' TabBar tab_selected rebind (representative of all 4 stripe rebinds)

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd:3443 BEFORE
"tab_selected": {"role": "button_pressed", "border_role": "button_border_pressed",
                "raised_intensity": 0, "border_width": 0,
                "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},

# AFTER (preserves face color; adds 2px top accent stripe)
"tab_selected": {"role": "button_pressed", "border_role": "role_primary",
                "raised_intensity": 0,
                "border_widths": Vector4i(0, 2, 0, 0),   # left/top/right/bottom
                "radius": "shape.tab_radius", "corner_profile": "tab_connected",
                "padding": Vector2i(12, 6), "mobile_padding": Vector2i(18, 14)},
```

### C2' ItemList/Tree selected row left-stripe rebind

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd:3019 BEFORE
"selected":               {"role": "button_pressed", "border_role": "button_pressed",
                            "raised_intensity": 0, "border_width": 0},

# AFTER (preserves selected row face; adds 3px left accent stripe)
"selected":               {"role": "button_pressed", "border_role": "role_primary",
                            "raised_intensity": 0,
                            "border_widths": Vector4i(3, 0, 0, 0)},
```

### C6 Slate hairline_thickness shape key + recipe thread-through

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd:954 (Slate STYLE_PERSONALITY) AFTER
Style.SLATE: {
    "spread_factor": 0.7, ...,
    "shape": {
        ...,
        "hairline_thickness":  1,   # NEW; others have 0 (must add to DEFAULT)
        ...,
    },
},

# Thread-through in _resolve_recipe() stylebox branch (after line 5391):
# (Pseudocode; planner must place the lookup before _apply_outline_border)
var hairline: int = 0
var hairline_raw: Variant = _lookup_shape(style_personality, "shape.hairline_thickness")
if hairline_raw != null and (typeof(hairline_raw) == TYPE_INT or typeof(hairline_raw) == TYPE_FLOAT):
    hairline = int(hairline_raw)
if hairline > 0:
    # Force border_width to hairline for "interactive surface" recipes
    border_width = hairline
```

The "interactive surface" trigger condition is a planner choice: e.g., gated on `recipe.has("border_role")` being a button-state role, or on the theme_type being in a Button-family allowlist.

### C6 Daybreak outline (flat, no halo, gated on `raised=true`)

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd:1026 (Daybreak STYLE_PERSONALITY) AFTER
Style.DAYBREAK: {
    "spread_factor": 1.0, ...,
    "shape": {
        ...,
        "primary_padding":       Vector2i(20, 14),   # was Vector2i(15, 9)
        "primary_outline_color": &"role_primary",     # NEW; lookup token name
        "primary_outline_offset": 3,                  # NEW; px outside button edge
        "primary_outline_width":  1,                  # NEW; flat 1px line
        ...,
    },
},

# Thread-through in _resolve_recipe() stylebox branch (only for primary buttons,
# gated on raised because SC#1 forbids 3D in flat mode):
if raised:
    var outline_color_key_v: Variant = _lookup_shape(style_personality, "shape.primary_outline_color")
    var outline_width_v: Variant = _lookup_shape(style_personality, "shape.primary_outline_width")
    var outline_offset_v: Variant = _lookup_shape(style_personality, "shape.primary_outline_offset")
    if outline_width_v != null and int(outline_width_v) > 0:
        var oc: Color = role_table.get(String(outline_color_key_v), role_table.role_primary)
        sb.border_color = oc
        # Replace existing border_width_* with outline_width:
        sb.border_width_left = int(outline_width_v)
        sb.border_width_top = int(outline_width_v)
        sb.border_width_right = int(outline_width_v)
        sb.border_width_bottom = int(outline_width_v)
        # Push outline outside button edge (3px expand) - this is the "3px offset":
        var off: int = int(outline_offset_v)
        sb.expand_margin_left = off
        sb.expand_margin_top = off
        sb.expand_margin_right = off
        sb.expand_margin_bottom = off
        # CRITICAL: outline alpha must be 1.0 (SC#3 no halo gate); border_alpha is the
        # recipe default 1.0 unless overridden, so do NOT set border_alpha < 1.0 here.
```

**Important:** The above is gated `if raised:` -- when `raised=false`, the outline is NOT drawn. This is what makes Daybreak's outline flat-compatible per SC#1.

**Alternative interpretation:** "1px outer mint outline" at offset 3px could also be implemented as: keep the existing `border_width_*=outline_width` at the button's existing edge, then add `expand_margin_*=3` (so the stylebox extends 3px outside but the border stays at the new edge). The visual result is the same. The planner picks the cleaner code path.

### C6 Burst oversized primary (via stylebox content_margin, NOT theme constant)

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd:1062 (Burst STYLE_PERSONALITY) AFTER
Style.BURST: {
    ...,
    "shape": {
        ...,
        "primary_padding":       Vector2i(24, 18),   # was Vector2i(16, 10); +8 V, +8 H
        # OR add a new key:
        "primary_min_height":    56,                 # desktop; mobile = 64 via tokens
        ...,
    },
},
```

The simplest path: bump `primary_padding` on Burst to push the button's `minimum_size` to ~56px. The `primary_min_height` key approach requires threading mobile (64) vs desktop (56) selection inside the recipe -- doable, but extra complexity for marginal gain. **Recommend:** start with `primary_padding=Vector2i(24, 18)` and confirm the rendered height. If still under 56px desktop, add a hard floor in `_resolve_recipe()` that sets `sb.content_margin_top/bottom` to at least `(56 - default_font_size) / 2`.

### Phase 12 verify helper skeleton (dual EditorScript + headless)

```gdscript
# Source: pattern follows .planning/phases/04-.../helpers/_phase4_verify.gd
# File: .planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd
@tool
extends EditorScript

func _run() -> void:
    var theme := preload("res://addons/neocade_theme/neocade_theme.tres") as NeoCadeTheme
    assert(theme != null, "Canonical theme failed to load as NeoCadeTheme")

    # SC#1 — raised=false ZERO 3D
    for style_value in NeoCadeTheme.selectable_styles():
        var t := theme.duplicate() as NeoCadeTheme
        t.style = style_value
        t.raised = false
        _assert_no_3d_chrome(t, NeoCadeTheme.Style.find_key(style_value))

    # SC#2 — raised=true keeps lift subset
    for style_value in NeoCadeTheme.selectable_styles():
        var t := theme.duplicate() as NeoCadeTheme
        t.style = style_value
        t.raised = true
        _assert_tabs_flat(t, NeoCadeTheme.Style.find_key(style_value))
        _assert_panels_lift(t, NeoCadeTheme.Style.find_key(style_value))

    # SC#6 — Zero public-export changes (count exactly 12)
    var script := theme.get_script()
    var export_count := _count_top_level_exports(script)
    assert(export_count == 12, "SC#6 FAIL: @export count = %d (expected 12)" % export_count)
```

## Per-direction implementation specifics

### Pulse - SectionKicker (or reuse Kicker)

**Current state:**
- `STYLE_PERSONALITY[Style.PULSE].shape.kicker_style = &"uppercase-tracked-accent"` (line 947) -- already wired.
- `TYPE_VARIATIONS["Kicker"] = "Label"` (line 1240) -- already registered.
- `BINDING_TABLE["Kicker"].color.font_color = {"kicker_style": "shape.kicker_style"}` (line 4910-4911) -- already dispatches.
- `_apply_kicker_style("uppercase-tracked-accent", role_table)` returns `role_primary` (line 5251). For Pulse, this IS `accent_color` -- already accent-colored.
- Showcase has 12 Kicker labels distributed across Text Inputs and Token Gallery sections (showcase.tscn lines 138-1110).

**What Phase 12 actually changes for Pulse:**
- **Likely zero code changes for Pulse Kicker** -- the existing chrome is already accent-colored uppercase. The C6 Pulse signature may be primarily a **showcase scene edit**: add a Kicker label above the "Buttons" section heading so the kicker chrome is visible in the most-frequented showcase view (currently the "Buttons" section has no Kicker labels per the grep at line 360+).
- **OPEN to planner:** Either reuse `Kicker` and add showcase nodes, OR register a new `SectionKicker` variation as a distinct entry (slightly different rendering -- e.g., font_size 10 instead of tokens.kicker=12). The mockup-refined-plan.html shows Pulse kickers at "font-size: 11px; letter-spacing: 0.18em" -- so a `SectionKicker` could differ from `Kicker` by being smaller-and-tracked. **Recommend reusing `Kicker`** for minimal churn; the 10px-vs-12px delta is consumer-side per content.
- If new `SectionKicker` IS added:
  - Append `"SectionKicker": "Label"` to `TYPE_VARIATIONS` (line 1240, after existing Kicker)
  - Append `"SectionKicker": {"color": {"font_color": {"kicker_style": "shape.kicker_style"}}}` to BINDING_TABLE (after the existing `Kicker` entry at line 4909)
  - Add `set_font("font", "SectionKicker", body_font)` + `set_font_size("font_size", "SectionKicker", 10)` in `_regenerate_theme()` (after line 449)

**Tracking (letter-spacing):** Godot 4.6 Label has NO theme-level letter-spacing slot (verified via Phase 5 research finding at `neocade_theme.gd:1203-1211`). The "tracked" feel is content-side -- the showcase Kicker text node should be authored with uppercase content. The mockup's 0.18em tracking is visual ground truth but not theme-enforceable.

### Slate - 1px hairline borders

**Current state:**
- `STYLE_PERSONALITY[Style.SLATE].shape` has no `hairline_thickness` key. Border widths in styleboxes come from `recipe.get("border_width", outline_width)` (line 5376), with `outline_width: int = 1` as the @export default.
- The existing Slate `spread_factor = 0.7` already implies narrower chrome (slimmer surface ramp), but not 1px hairlines on every interactive surface.

**What Phase 12 changes for Slate:**
- Add `"hairline_thickness": 1` to Slate's `STYLE_PERSONALITY.shape` (after line 968 or so).
- Add `"hairline_thickness": 0` to `STYLE_PERSONALITY_DEFAULT.shape` (Pitfall 5 mandate).
- Add `"hairline_thickness": 0` to Pulse/Bubble/Daybreak/Burst `STYLE_PERSONALITY.shape` (so the key is uniformly present even when no-op).
- Thread-through in `_resolve_recipe()` stylebox branch: when `hairline_thickness > 0` AND the recipe has a `border_role` (i.e., it's a chrome stylebox, not a Label/RichTextLabel `empty: true`), force `border_width` to `hairline_thickness`.

**Mobile tap-target check:** Slate's primary button on MOBILE is `primary_padding * densityScale = Vector2i(14, 9) * 1.5 = Vector2i(21, 13.5)`. Default font_size = 16 (mobile body) + content_margin 13.5*2 = 43px. With hairline=1, total height = 45px -- under the 48dp Android floor by 3px. **PLANNER MUST CHECK** that Slate's mobile primary still meets `tokens.primaryButtonMin = 56` (mobile token). Likely fine because primary buttons resolve through `_apply_primary_strategy("quiet-pill", ...)` which sets `bg_color = surface_panel` and adds 1px border -- the existing 1px border for quiet-pill primary buttons already meets the hairline target.

**Verification:** Slate's stylebox borders for Button, MenuButton, LineEdit, OptionButton, TabBar etc. should all read 1px in `theme.get_stylebox("normal", "Button").border_width_left`.

### Bubble - Forced >=26 corner radius

**Current Bubble shape values (line 992-1003):**
- `primary_radius: 999` (pill)
- `primary_padding: Vector2i(16, 10)`
- `secondary_radius: 26`
- `tab_radius: 999` (pill)
- `chip_radius: 999` (pill)
- `card_radius: 26`
- `hero_radius: 26`

**Sub-components NOT in `STYLE_PERSONALITY.shape` (potential gaps):**
- Slider grabber: rendered via `_make_slider_grabber_icon()` (line 5511); inspect for radius derivation.
- ScrollBar grabber: BINDING_TABLE `VScrollBar.grabber.radius = "shape.secondary_radius"` (line 4191) -- Bubble's secondary_radius=26, so already >=26. **OK.**
- OptionButton arrow icon: bound via `"arrow_down" SVG`, NOT a stylebox radius -- not affected by radius floor.
- CheckBox shape: bound via `"checkbox_checked"/"checkbox_unchecked" SVG`, NOT a stylebox radius -- not affected.
- `shape.secondary_radius`: already 26 for Bubble. **OK.**

**What Phase 12 changes for Bubble:** Likely **zero shape edits** because Bubble's existing radii (lines 993-1003) already meet the `>=26` floor for every key. The only addition is a defensive `min_radius_floor: 26` key in Bubble's shape (and `0` in default) plus a thread-through in `_resolve_recipe()` that does `resolved_radius = max(resolved_radius, min_radius_floor)` after the existing radius lookup. This is **insurance** for cases where a recipe hardcodes a small radius (e.g., the recipe at `Editor.prop_subsection_stylebox.radius = "shape.secondary_radius"` -- but Bubble's secondary_radius is 26, so safe).

**Slider grabber check:** the grabber icon is generated, not stylebox-driven. `_make_slider_grabber_icon` (line 5511) likely uses `tokens.thumbnailSize` and a fixed radius. **PLANNER MUST READ THIS HELPER** and confirm Bubble's slider grabber reads as "pillowy" (corner-radius >=8). If not, this is a separate per-direction tweak.

**Verification:** For Bubble, iterate every `theme.get_stylebox(...)` for every Control class and assert `corner_radius_*` >= 26.

### Daybreak - 1px flat outline at 3px offset

**Current state:**
- `STYLE_PERSONALITY[Style.DAYBREAK].shape.primary_padding = Vector2i(15, 9)` (line 1030).
- `STYLE_PERSONALITY[Style.DAYBREAK].shape.primary_strategy = &"friendly-generous"` (line 1031).
- `_apply_primary_strategy("friendly-generous", ...)` (line 5165-5168) sets `sb.bg_color = role_primary` and `sb.border_color = accent_rim` -- the existing border is `accent_rim` (a 50% white-mix of accent), not pure accent.

**What Phase 12 changes for Daybreak:**
1. Bump `primary_padding` from `Vector2i(15, 9)` to `Vector2i(20, 14)` (CONTEXT.md D-12.11 verbatim).
2. Add three new shape keys: `primary_outline_color: &"role_primary"`, `primary_outline_offset: 3`, `primary_outline_width: 1`.
3. Add zero-value defaults for these three keys in `STYLE_PERSONALITY_DEFAULT.shape` AND in the other 4 directions' shape blocks.
4. Thread-through in `_resolve_recipe()`: only for primary-button styleboxes (gated on `strategy: "shape.primary_strategy"` being present in recipe), AND only when `raised=true` (SC#1 gate). Apply outline via `border_width_* = primary_outline_width`, `expand_margin_* = primary_outline_offset`, `border_color = role_table.get(primary_outline_color, role_primary)`. Override the `accent_rim` border set by `_apply_primary_strategy`.

**GL Compatibility pitfall check:** Border is full-alpha by default (`border_alpha = 1.0` in `_resolve_recipe` line 5379). Daybreak outline is therefore safe from issue #23640.

**Render verification:** Daybreak primary button (raised=true) should show: 1px solid accent border, 3px gap between button edge and outline (the `expand_margin_*` is what creates the gap; without it, the outline sits flush at the button edge). Actually -- re-reading the docs: `expand_margin_*` extends the stylebox OUTSIDE the control rect, AND the border is drawn at the outer edge of the stylebox. So the visual is: button edge -> 3px transparent gap -> 1px border. **This is exactly the "1px outline at 3px offset" target.**

**Alternative cleaner implementation:** Use a second invisible stylebox slot for the outline. But Godot's StyleBox slots are one per state -- you can't stack two on `normal`. So the `expand_margin_*` + `border_width_*` on the same stylebox IS the only way. **Confirmed correct.**

### Burst - Oversized primary CTAs

**Current state:**
- `STYLE_PERSONALITY[Style.BURST].shape.primary_padding = Vector2i(16, 10)` (line 1066).
- Burst primary buttons currently render at: `font_size 14 (body) + content_margin 10*2 = 34px` desktop, `16 + content_margin 14*1.5*2 = 58px` mobile (mobile uses `mobile_padding` if specified, but Burst's recipes only specify `padding: shape.primary_padding`; the per-direction `densityScale` multiplier at `_resolve_recipe()` line 5419-5420 handles the desktop->mobile scaling).

**What Phase 12 changes for Burst:**
- Bump `primary_padding` from `Vector2i(16, 10)` to `Vector2i(24, 18)` -- yields desktop 14 + 18*2 = 50px, mobile 16 + 18*1.5*2 = 70px. **Mobile may overshoot** the 64px target if the simple padding bump approach is used.
- Alternative: add `primary_min_height: 56` desktop / `64` mobile key. Thread-through in `_resolve_recipe()` (after content_margin set): compute current minimum_height = font_size + content_margin_top + content_margin_bottom; if less than `primary_min_height`, bump content_margin_top/bottom evenly to reach the floor.

**Recommend:** simpler path -- bump `primary_padding` to `Vector2i(20, 14)`. This yields desktop 14 + 14*2 = 42px (under target), mobile 16 + 14*1.5*2 = 58px (close). NOT enough.

Therefore: **Burst needs the `primary_min_height` shape key approach**. Default to `0` in non-Burst directions and DEFAULT.

```gdscript
# Source: neocade_theme.gd:1062 Burst AFTER
Style.BURST: {
    ...,
    "shape": {
        ...,
        "primary_padding":     Vector2i(20, 14),    # was Vector2i(16, 10); generous
        "primary_min_height":  56,                  # desktop floor; mobile = primary_min_height * 1.0 OR a separate key
        ...,
    },
},
```

For mobile: either (a) read `tokens.primaryButtonMin = 56` (which is the existing mobile token) and use that, OR (b) add `primary_min_height_mobile: 64`. **Simpler:** use `tokens.primaryButtonMin` (existing value 56 mobile / 44 desktop) and override only for Burst. Burst's desktop primary becomes 56px (vs. other directions' 44px) -- a 1.27x scale factor, matches the spike's "1.4x size of other directions" target close enough.

**Verification:** Burst's primary Button minimum_size.y should be 56 desktop, 64 mobile, after `tokens.primaryButtonMin` resolution.

## Cross-cutting concerns

### `Style.CUSTOM` graceful fallback (D-12.17)

`STYLE_PERSONALITY_DEFAULT` at line 1158-1189 is consumed by `_resolve_style_personality()` at line 1192-1193 when `style = Style.CUSTOM`. Every new shape key introduced by C6 MUST be added here with a no-op default:
- `hairline_thickness: 0` -- no hairline override
- `min_radius_floor: 0` -- no radius floor (existing radii pass through)
- `primary_outline_color: &"role_primary"` -- safe default (matches Daybreak), but unused because...
- `primary_outline_offset: 0` -- zero offset disables the outline
- `primary_outline_width: 0` -- zero width disables the outline
- `primary_min_height: 0` -- zero min height = no floor

The thread-through code in `_resolve_recipe()` must skip the mutation when these no-op values are present. Example: `if hairline_thickness <= 0: do nothing`. This is a recurring pattern in `_resolve_recipe()` already (see `if outline_width > 0` gating elsewhere).

### Mobile path (D-12.10)

The existing `tokens.densityScale = 1.5` multiplier at `_resolve_recipe()` line 5398-5421 scales all `padding: Vector2i(...)` recipes by 1.5x on MOBILE. C2' rebinds change `role`/`border_role` only -- no padding changes -- so the MOBILE path is unaffected by C2'.

C6 Slate hairlines: 1px is 1px regardless of density. The MOBILE thicker padding still resolves correctly because the border is independent.

C6 Daybreak outline: 1px outline + 3px offset. On MOBILE, the densityScale 1.5x is currently applied to padding (line 5398-5421) but NOT to border_width or expand_margin. **The planner must decide:** does the outline scale to 1.5px on MOBILE (so it reads at the same visual size as desktop on hi-DPI displays)? Or stays at 1px? **Recommend:** stay at 1px to match the spike's literal pixel-count spec; the hi-DPI displays will naturally render thinner-but-sharper.

C6 Burst oversized: `tokens.primaryButtonMin = 56` (mobile) vs `44` (desktop) already encodes the mobile scaling. C6 just bumps Burst's effective minimum to 56 desktop / 64 mobile.

### GL Compatibility renderer pitfalls

- Issue #23640: shadow alpha over-render. **Mitigation:** all Phase 12 styleboxes use `border_alpha = 1.0` (recipe default; full opacity). Verified by SC#3 gate (D-12.26).
- No new shadow_size additions. The existing `shadow_size = -1` flat-mode default at `_make_raised_stylebox()` (line 891-893) stays untouched. Daybreak's outline uses `border_width_*` + `expand_margin_*`, NOT shadow.

### Showcase scene compatibility

`showcase/showcase.tscn` has 241 nodes. Phase 12 additions:
- 1 new `SectionKicker` (or `Kicker`) Label above "Buttons" section heading (~10 lines of .tscn delta).
- C2' visible in existing chrome (TabBar/TabContainer/Tree/ItemList) automatically.
- C6 Pulse Kicker visible in existing 12 Kicker labels automatically (Pulse already renders them accent-colored).
- C6 Slate hairlines, Bubble pillow, Daybreak outline, Burst oversized -- visible in existing Buttons section when style switched.

**No new showcase sections needed** for Phase 12 (per D-12.23 -- role variations belong to Phase 13's Showcase additions).

### `_regenerating` reentry guard

`_regenerate_theme()` line 253-254 guards against reentry via `if _regenerating: return`. Phase 12 changes are purely data + helper math; no new setters or signals introduced. The guard remains correct.

### No-`Theme.clear` invariant

`_regenerate_theme()` line 261 calls `clear()` once. No other `clear()` calls exist in the codebase (verified by grep). Phase 12 must NOT add any. Locked since Phase 4.

## Verification tooling

### Greyscale thumbnail render (SC#4)

**Recommended approach:** Standalone SceneTree helper that:
1. Loads `res://addons/neocade_theme/neocade_theme.tres`
2. Loads `res://showcase/showcase.tscn`
3. Iterates 5 styles + raised={true,false} = 10 configurations
4. For each: applies the style, queries the showcase root, calls `get_viewport().get_texture().get_image()` to capture the rendered viewport, resize to 256x144 via `image.resize()`, call `image.adjust_bcs(0.0, 0.0, -1.0)` to desaturate (saturation=-1.0 fully desaturates), save PNG to `.planning/phases/12-signature-visual-moves/artifacts/thumbnails/<style>-raised<bool>.png`.
5. User attestation determines pass/fail per the Phase 9/10 closure precedent.

**Critical:** `Image.adjust_bcs` takes brightness/contrast/saturation. To fully desaturate, saturation must be `-1.0` (NOT `0.0`). Reference: docs.godotengine.org/en/4.6/classes/class_image.html `adjust_bcs` notes that the saturation parameter is the **multiplier offset**, so `-1.0` reduces saturation to zero from the default 1.0.

**Wait:** the Godot 4.6 docs actually say `saturation` is "the value to adjust saturation by" -- ambiguous. Test before locking. The shader-equivalent in `screen-reading_shaders.html` uses `mix(vec3(dot(vec3(1.0), c.rgb) * 0.33333), c.rgb, saturation)` -- so saturation=0 gives grey, saturation=1 gives original. **Confirmed: `adjust_bcs(0.0, 0.0, 0.0)` gives grey** if the API mirrors the shader semantics. The planner should test both values (0.0 and -1.0) in the verify helper and pick the one that produces a greyscale image.

### 30-config smoke matrix (SC#6)

**Axes (full = 144 configs):**
- 6 styles (5 + CUSTOM)
- 2 raised values (true / false)
- 3 platform values (DESKTOP / MOBILE / AUTO)
- 2 base_color samples (a dark and a custom)
- 2 accent_color samples (a built-in and a custom)
= 144

**Curated 30-subset (representative):**
- 5 styles x 2 raised x 1 platform=DESKTOP x default base/accent = 10
- 5 styles x 1 raised=true x 1 platform=MOBILE x default base/accent = 5
- 1 style=CUSTOM x 2 raised x 3 platforms x default base/accent = 6
- 5 styles x 1 raised=true x 1 platform=AUTO x custom base/accent = 5
- 4 edge cases: very dark base, very light base, accent=base (low contrast), accent over the WCAG floor = 4
= 30

For each config: instantiate `NeoCadeTheme.new()`, apply the config, count `@export var` declarations via `script.get_property_list().filter(p.usage & PROPERTY_USAGE_SCRIPT_VARIABLE)`. Assert count == 12. Assert `theme.has_stylebox("normal", "Button")` etc.

### Verify helper pattern (dual EditorScript + headless)

Follow the Phase 4 precedent at `.planning/phases/04-.../helpers/_phase4_verify.gd` (EditorScript) and `_phase4_verify_headless.gd` (SceneTree).

**Required pattern:**
- EditorScript variant for in-Godot-editor invocation (File > Run).
- SceneTree headless variant for `godot --headless --quit --script ...` CI invocation.
- Both share the same assertion battery (duplicated, not loaded, per KISS at line 22-23 of `_phase4_verify_headless.gd`).
- Load via `preload("res://addons/neocade_theme/neocade_theme.tres")` -- the canonical resource. **Do NOT** reference `pulse_neocade_theme.tres` or any other per-style resource (those are deleted; Pitfall 6).

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Godot 4.6 native (no external test framework). Verify helpers are `@tool extends EditorScript` (in-editor) + `extends SceneTree` (headless). |
| Config file | None. Helper scripts are standalone. |
| Quick run command | `godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" --stage architecture` |
| Full suite command | `godot --headless --quit --script ".planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd" --stage full` |

### Phase 12 Requirements -> Test Map

| SC ID | Behavior | Test Type | Automated Command | File Exists? |
|-------|----------|-----------|-------------------|--------------|
| SC#1 | `raised=false` shows ZERO 3D elements for every style | runtime (headless) | `godot --headless --quit --script ".../_phase12_verify_headless.gd" --stage sc1-no-3d-when-flat` | Wave 0 (NEW) |
| SC#2 | `raised=true` lifts panels + buttons; tabs stay flat | runtime (headless) | `godot --headless --quit --script ".../_phase12_verify_headless.gd" --stage sc2-tabs-flat-when-raised` | Wave 0 (NEW) |
| SC#3 | No glow halos -- no `Color()` with `alpha in (0.0, 1.0)` on outline/shadow/outer-border slots | static (grep) + runtime introspection | grep + `--stage sc3-no-glow-halo` | Wave 0 (NEW) |
| SC#4 | Every direction identifiable at thumbnail scale via greyscale render | manual + tooling | `godot --headless --quit --script ".../_phase12_thumbnail_render.gd"` -> user attestation | Wave 0 (NEW) |
| SC#5 | No new hues -- every Phase-12-touched color literal resolves to `base_color`/`accent_color`/existing token | static (grep + AST inspection) | Phase 12 plan diff review + grep `Color\(` in `git diff` | Wave 0 (manual review) |
| SC#6 | `@export` count == 12 before and after Phase 12 | static (script introspection) | `--stage sc6-export-count` -- iterates `script.get_property_list()` and asserts count | Wave 0 (NEW) |

### Sampling Rate

- **Per task commit:** quick run -- `--stage architecture` (verifies the single canonical resource loads, BINDING_TABLE still has 37 rows, TYPE_VARIATIONS still has 47+1 (if SectionKicker added) entries, 12-export count holds).
- **Per wave merge:** full suite -- all SC stages (`--stage full`).
- **Phase gate:** full suite green + SC#4 thumbnail render + user attestation on greyscale identifiability.

### Wave 0 Gaps

Phase 12 ships its own verify helpers because the existing Phase 4/8 helpers reference stale paths (Pitfall 6):

- `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify.gd` -- new (EditorScript variant)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` -- new (SceneTree headless variant)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_thumbnail_render.gd` -- new (SC#4 SceneTree script)
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` -- new (30-config smoke for SC#6)

Framework install: none. Godot CLI is already on the development machine (per Phase 5+ verify scripts at `.planning/phases/05-.../helpers/godot-cli-path.txt`).

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Godot 4.6 engine | All Phase 12 implementation and verification | (assumed yes; project lives in Godot) | 4.6.x | None -- this is a Godot project; engine availability is project-fundamental |
| Godot CLI (`godot`) | Headless verify scripts | Documented at `.planning/phases/05-.../helpers/godot-cli-path.txt` and `godot-cli-provenance.txt` | per Phase 5 setup | If unavailable: fall back to in-editor `_phase12_verify.gd` (EditorScript) -- requires user to run File > Run in Godot Editor. Phase 4 precedent (line 117 of CONTEXT.md) used this fallback when CLI unavailable. |
| `Image.adjust_bcs` | SC#4 thumbnail desaturation | Yes (Godot 4.6 stdlib) | 4.6 | If saturation semantics produce unexpected results, fall back to per-pixel luminance computation in GDScript (slower but deterministic) |

**Missing dependencies with no fallback:** None.
**Missing dependencies with fallback:** Godot CLI -- fall back to EditorScript variant.

## Security Domain

**Security enforcement:** Not applicable. NeoCade is a Theme resource addon. There are:
- No user inputs (theme exports are inspector-edited at design time, not user-input-driven at runtime).
- No network endpoints.
- No file I/O beyond `preload` of bundled assets (fonts/icons in the addon folder).
- No authentication, no session management, no cryptography.

ASVS categories: V5 Input Validation does not apply because all inputs are typed (`@export var x: int` etc.) and Godot enforces the type at the inspector level. No user-provided strings flow into theme code. No SQL, no shell exec, no template injection paths.

The single security-adjacent surface is `_load_icon()` (line 5557) and `_make_*_icon()` helpers (line 5588+), which use Godot stdlib `Image.load_svg_from_string()` and `FileAccess.get_file_as_string()` against paths under `res://addons/neocade_theme/icons/`. Phase 12 does NOT add new SVGs (D-12.19), so no new file I/O paths are introduced.

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `_raised_depth_color = _mix(element, base, 0.16); _mix(result, BLACK, 0.10)` | HSV value-darken at `0.20 + 0.10 * raised_strength` | Phase 12 Wave 1 | Hue preserved; saturation preserved; depth strip stays in element's hue family. Matches HCGames flat-game-UI anchor. |
| `tab_selected.border_role = button_border_pressed` (neutral) | `tab_selected.border_role = role_primary` with `border_widths: Vector4i(0, 2, 0, 0)` (2px accent top stripe) | Phase 12 Wave 2 | Accent gets airtime in idle chrome; the headline complaint resolution |
| Daybreak halo at 4px-thick @ 12% alpha ring (spike 003 original) | Daybreak 1px flat full-alpha outline at 3px offset | 2026-05-10 user revert | SC#3 compliance; flat-compatible per SC#1 |
| C5 lift thickness bump (spike 003 original recommendation) | DEFERRED for re-evaluation after Phase 12 | 2026-05-10 user refinement | Current 2-3px lifts judged sufficient pending C4+C2' headline fix |

**Deprecated/outdated:**
- The Phase 8 verify helper paths (`pulse_neocade_theme.tres`, `neocade_mobile_theme.tres`) are stale post-2026-05-08 consolidation. Phase 12 does NOT depend on them; new helpers ship in `.planning/phases/12-signature-visual-moves/helpers/`.

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | `Image.adjust_bcs(0, 0, 0)` produces greyscale (saturation=0 -> grey) | Verification tooling | Medium -- if the API treats saturation as additive offset (so `0` = no change), the SC#4 thumbnails would not be greyscale and the verifier would need to re-tune. **Test in verify script before locking.** |
| A2 | The C6 Pulse Kicker can be served by the existing `Kicker` TYPE_VARIATION without registering a new `SectionKicker` | Per-direction implementation specifics | Low -- if the planner decides a distinct font_size or position is needed, register `SectionKicker` as a new entry following the Phase 4 pattern; ~5 lines of additional code. The choice is reversible. |
| A3 | Burst's `primary_min_height` shape key approach is cleaner than padding-only | Per-direction implementation specifics | Low -- if padding-only suffices on every density target, the `primary_min_height` key is unnecessary. The 30-config smoke matrix will reveal this. |
| A4 | The Daybreak outline can be implemented as a single StyleBoxFlat with `expand_margin_*` and `border_width_*` (no second wrapping stylebox needed) | Per-direction implementation specifics | Low -- verified against docs.godotengine.org/en/4.6/classes/class_styleboxflat.html `expand_margin_*` semantics: "Useful in combination with border_width_* to draw a border outside the control rect". This is exactly the intended use case. |
| A5 | The C2' rebind for "section-header underlines" maps to the existing `HSeparator.separator` stylebox (currently rendered via `_apply_separator_styleboxes()` at line 746-757 using `outline_color`) | C2' specifics | Medium -- if the spike's intent was a dedicated "section-header underline" Control distinct from HSeparator, then this rebind has nothing to bind. The showcase scene does not currently use HSeparator (per grep). The planner may rebind `_apply_separator_styleboxes` to use `accent_offset` instead of `outline_color`, or skip this rebind entirely if the showcase doesn't exercise it. **OPEN: planner decides whether to ship this rebind in Wave 2.** |

## Open Questions

1. **Should the C6 Pulse signature be a new `SectionKicker` variation or a reuse of the existing `Kicker`?**
   - What we know: The existing `Kicker` is already accent-colored uppercase-tracked-accent for Pulse (`kicker_style: &"uppercase-tracked-accent"` -> `_apply_kicker_style` -> `role_primary` -> `accent_color`). 12 Kicker labels exist in the showcase. The "tracked" feel is content-side per Godot 4.6 Label having no letter-spacing slot.
   - What's unclear: Whether the planner wants a visually-distinct Kicker (smaller, accent-colored differently) for "section headers" specifically.
   - Recommendation: Reuse existing `Kicker`. Add one new Kicker label to the showcase "Buttons" section to demo the chrome. If a visual distinction is desired post-implementation, register `SectionKicker` in a future phase.

2. **Should the C2' section-header underline rebind ship in Wave 2, or be deferred?**
   - What we know: The showcase does not currently exercise HSeparator. `_apply_separator_styleboxes()` (line 746) sets HSeparator's separator stylebox to `outline_color` (line 747).
   - What's unclear: Whether changing `outline_color` to `accent_offset` for HSeparator would have collateral impact (PopupMenu separators ALSO use the same `h_line` stylebox via line 755-757 -- those are intentionally neutral).
   - Recommendation: Skip this rebind for Phase 12. The other 5 C2' rebinds (tabs, items, trees, kickers, slider value labels) cover the headline fix. Document this in the plan as "deferred to a separate spike on section-header treatment".

3. **What's the exact mobile scaling rule for Daybreak's outline (1px) and offset (3px)?**
   - What we know: `tokens.densityScale = 1.5` on MOBILE scales padding 1.5x. Border width and expand_margin are NOT currently scaled.
   - What's unclear: Whether the outline should look "1px tall" on hi-DPI mobile (sharper, thinner) or "1.5px tall" (same visual size as desktop after density scaling).
   - Recommendation: Stay at 1px (no density scaling on outline). The spike's literal spec says "1px outline at 3px offset"; the visual mockup-refined-plan.html does not differentiate desktop vs mobile outline width.

## Sources

### Primary (HIGH confidence)
- Godot 4.6 docs `class_color.html` (Color.from_hsv, Color.h/s/v) -- VERIFIED via Context7 CLI fetch
- Godot 4.6 docs `class_styleboxflat.html` (border_width_*, expand_margin_*, draw_center) -- VERIFIED via Context7 CLI fetch
- Godot 4.6 docs `class_image.html` (adjust_bcs) -- VERIFIED via Context7 CLI fetch
- Godot 4.6 docs `class_button.html` (Button has no minimum_size_height theme property) -- VERIFIED via Context7 CLI fetch
- `.planning/spikes/visual-identity-distinctiveness/REPORT.md` -- HIGH (consolidated spike + user-locked decisions)
- `.planning/spikes/visual-identity-distinctiveness/002b-raised-depth-formula-hsv-darken/README.md` -- HIGH (C4 formula provenance, iteration 1-5 traces)
- `.planning/spikes/visual-identity-distinctiveness/003-per-direction-signature-move-catalog/README.md` -- HIGH (C6 per-direction feasibility, references, effort)
- `.planning/phases/12-signature-visual-moves/12-CONTEXT.md` -- HIGH (locked decisions D-12.01..D-12.29)
- `addons/neocade_theme/scripts/neocade_theme.gd` -- HIGH (current source; all callsites and BINDING_TABLE rows verified by file read)

### Secondary (MEDIUM confidence)
- `.planning/spikes/visual-identity-distinctiveness/005-before-after-comparison/mockup-refined-plan.html` -- MEDIUM (visual contract; renders the proposed AFTER state for all 5 directions)
- `.planning/phases/04-.../helpers/_phase4_verify.gd` and `_phase4_verify_headless.gd` -- MEDIUM (verify pattern precedent; some path references stale but pattern is reusable)
- `.planning/DESIGN_TOKENS.md` per-direction palette + shape language -- MEDIUM (not re-read in this research; assumed unchanged by the project state)

### Tertiary (LOW confidence)
- None. Every claim in this research is backed by a primary or secondary source verified via tool call.

## Metadata

**Confidence breakdown:**
- C4 implementation: HIGH -- formula already validated in spike 002b, callsites enumerated, Godot 4.6 API verified.
- C2' rebind plan: HIGH -- exact BINDING_TABLE rows located, recipe shape supports the changes via existing `border_widths: Vector4i` and `border_role` keys.
- C6 per-direction implementation: HIGH for Slate hairlines, Bubble pillow, Daybreak outline, Burst oversized; MEDIUM for Pulse Kicker (the OPEN question on SectionKicker vs Kicker reuse).
- Cross-cutting (CUSTOM fallback, mobile, GL Compat): HIGH -- existing code patterns identified, pitfalls documented.
- Verification tooling: MEDIUM -- `Image.adjust_bcs` saturation semantics need an empirical test (A1).

**Research date:** 2026-05-10
**Valid until:** 30 days (2026-06-09). Godot 4.6 API surface is stable in this window; locked Phase 12 success criteria do not drift; the spike series outputs are durable.
