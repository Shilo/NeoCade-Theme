# Phase 13: Role Variations — Research

**Researched:** 2026-05-11
**Domain:** Godot 4.6 Theme — `theme_type_variation` opt-ins, additive `TYPE_VARIATIONS` + `BINDING_TABLE` extensions
**Confidence:** HIGH (every fact in this document is grounded in code line numbers from `addons/neocade_theme/scripts/neocade_theme.gd`, ROADMAP.md, Phase 12 helper code, or the showcase scene; no Context7/web lookup was required because the entire surface is in-repo)

---

## Summary

Phase 13 adds **9 opt-in role-coded type variations** to the existing single-class architecture: 4 Labels (`SuccessLabel`, `WarningLabel`, `DangerLabel`, `InfoLabel`) and 5 PanelContainer subtypes (`AccentPanel`, `InfoPanel`, `WarningPanel`, `DangerPanel`, `SuccessPanel`). The work is **purely additive** to two existing data structures inside `addons/neocade_theme/scripts/neocade_theme.gd`: the `TYPE_VARIATIONS` dict at lines 1257-1317 (currently 47 entries), and the `BINDING_TABLE` dict at lines 1805-5057 (currently 140 top-level theme types). Every required input — the role color tokens, the `panel_bg`-equivalent stylebox recipe, the `_mix` helper for 6% tinting, the recipe resolver — already exists. There is **no formula work, no new export, no architecture change.**

The phase also adds a **10th showcase section** to `showcase/showcase.tscn` (current count: 9 ScrollContainer tabs at lines 108-1124) and reuses the existing Phase 12 verifier infrastructure under `.planning/phases/12-signature-visual-moves/helpers/` to assert success criteria. Because Phase 12's `_phase12_smoke_matrix.gd` already asserts `BINDING_TABLE == 140`, Phase 13 either updates that constant to `149` (140 + 9) in a Phase-13-owned copy of the helpers, or — preferred — ships fresh `.planning/phases/13-role-variations/helpers/` analogues that assert the post-Phase-13 invariants while leaving Phase 12's helpers untouched as historical evidence.

**Primary recommendation:** Treat Phase 13 as **two BINDING_TABLE additive edits + one TYPE_VARIATIONS additive edit + one showcase-scene additive edit + one new helpers directory**, with **zero changes to default Label/PanelContainer BINDING_TABLE rows** (lines 3141-3149 and 4989-5000) and **zero changes to existing exports, formulas, role-token derivation, or recipe resolver semantics**. The 6% role-color tint over `surface_panel` is implemented via the existing `{"alpha": 0.06, ...}` recipe field already supported at `_resolve_recipe` lines 5352-5360. SC#3 is preserved by making every role-panel recipe a **full-tint role color stylebox** rather than an overlay (i.e., reuse the existing `role: "role_success"` style with `alpha: 0.06` semantics that the resolver already handles, but verify the resulting `bg_color.a == 0.06` is acceptable to GL Compatibility — this needs a smoke-test asssertion).

---

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|--------------|----------------|-----------|
| 9 new opt-in type variations | NeoCadeTheme class data (`TYPE_VARIATIONS` const) | — | TYPE_VARIATIONS at lines 1257-1317 is the single registry Godot reads via `set_type_variation()`. All variations live here. |
| Role-color font binding for 4 Labels | NeoCadeTheme class data (`BINDING_TABLE` const) | NeoCadeTheme class behavior (`_resolve_recipe` color branch at lines 5585-5615) | The color resolver already supports `{"role": "role_success"}`-style recipes (already used 30+ times in BINDING_TABLE — see EditorHelp line 1943, EditorInspector line 1982, CodeEdit line 2324). Zero new code path needed. |
| Role-tinted stylebox for 5 Panels | NeoCadeTheme class data (`BINDING_TABLE` const) | NeoCadeTheme class behavior (`_resolve_recipe` stylebox branch at lines 5336-5584) | The stylebox resolver already supports `{"role": "<role>", "alpha": 0.06, ...}` recipes (alpha handled at line 5353-5360). 6% role tint is naturally expressed as `{"role": "role_<x>", "alpha": 0.06}` over surface_panel border. |
| 10th showcase section | `showcase/showcase.tscn` scene data | — | Existing 9 ScrollContainer tabs at `RootMargin/RootStack/ShowcaseTabs/<Name>` (lines 108-1124); the new section follows the identical structure (ScrollContainer → MarginContainer → GridContainer → Kicker + 9 demo cells). |
| Success criteria verification | `.planning/phases/13-role-variations/helpers/*.gd` | Phase 12 helper precedent at `.planning/phases/12-signature-visual-moves/helpers/` | Phase 12 ships 8 helpers including `_phase12_smoke_matrix.gd` (30 configs) and `_phase12_verify_headless.gd` (architecture/SC stages). Phase 13 reuses that pattern with `--stage role-variations` + a duplicate 30-config smoke that asserts post-Phase-13 invariants. |
| README opt-in pattern docs | `README.md` (repo root) | — | Repo-root README per FOUND-01 (docs live outside `addons/neocade_theme/`). |

---

## Standard Stack

### Core (everything below already exists in the repo)

| Library/Const | Version | Purpose | Why Standard |
|---------------|---------|---------|--------------|
| Godot Engine | 4.6 | Theme primitive + `theme_type_variation` | [VERIFIED: project.godot pins 4.6; Phase 12 verifier runs against 4.6 headless] |
| `NeoCadeTheme` (`addons/neocade_theme/scripts/neocade_theme.gd`) | post-Phase-12 | Single concrete `@tool class_name NeoCadeTheme extends Theme` | The only entry point; everything routes through `_regenerate_theme()` |
| `TYPE_VARIATIONS` const (lines 1257-1317) | 47 entries pre-Phase-13 | Dict mapping `"VariationName": "BaseType"` for `set_type_variation()` registration | The canonical registry; Phase 13 grows this to 56 entries |
| `BINDING_TABLE` const (lines 1805-5057) | 140 top-level keys pre-Phase-13 | Dict mapping `"ThemeType": {"data_type": {"slot": recipe_dict}}` | Drives every `set_stylebox/set_color/set_constant/set_font_size/set_icon` call in `_regenerate_theme()` |
| `_resolve_recipe()` (lines 5334-5679) | Phase 12 baseline | Recipe → concrete StyleBox/Color/int/Texture2D dispatcher | Handles all 5 data types; color branch reads `role` + optional `alpha` + optional `disabled` |
| Role tokens in `role_table` (lines 339-342 derivation, 603-610 table insertion) | Phase 4 baseline | `role_success`/`role_warning`/`role_danger`/`role_info` Color values | **The exact role-token names match ROADMAP.md Phase 13 scope verbatim — no key-name remediation needed** |
| `_mix(a, b, amount)` helper (lines 772-778) | Phase 4 baseline | Linear RGB lerp matching the renderer's formula | Not invoked directly by Phase 13 — the resolver applies role-color alpha; for stylebox tinting we use the resolver's existing alpha pathway |
| `_phase12_smoke_matrix.gd` | Phase 12 | 30-config (5 styles × 2 raised × 3 platforms + custom + edges) headless regen + invariant asserts | Phase 13 reuses the curated 30-config matrix shape; copies the script with `EXPECTED_BINDING_TABLE_ROWS = 149` and `EXPECTED_TYPE_VARIATIONS_COUNT = 56` |
| `_phase12_verify_headless.gd` | Phase 12 | Stage-based verifier (`architecture`/`sc1`/`sc2`/`sc3`/`sc6`/`smoke-30`/`full`) | Phase 13 ships a parallel `_phase13_verify_headless.gd` with 3 new stages (`role-variations-registered`, `role-variations-bindings`, `default-chrome-unchanged`) |

### Supporting

| Const / Slot | Purpose | Used By |
|--------------|---------|---------|
| Existing `PanelContainer.panel` recipe at lines 4989-5000 | Reference for the `panel_bg` recipe shape — uses `role: "surface_panel"`, `border_role: "surface_panel_edge"`, `alpha: "shape.surface_alpha_panels"`, `raised_intensity: "shape.raised_lifts.panel"`, `raised_face_edge: true`, `padding: Vector2i(10, 8)` | Each new Role Panel variation's `panel` stylebox recipe mirrors this shape but swaps `role` to the appropriate `role_*` token and adds `alpha: 0.06` (the 6%-mix-tint contract from ROADMAP Phase 13 § C3) |
| Existing `CardPanel`/`HeroPanel` recipes at lines 5019-5056 | Reference for how PanelContainer variations layer additional fields (radius, padding) on top of the base panel recipe | Each new Role Panel variation copies this layered-recipe shape |
| Existing `Label.font_color` recipe at line 3147 | Reference for label `font_color` recipe shape — `{"role": "text_strong"}` | Each new Role Label variation's `font_color` recipe is `{"role": "role_<x>"}` (single-key recipe; no alpha needed for `text_<x>` styling) |
| Existing kicker example pattern (e.g., `Caption` at lines 4940-4944) | Reference for a minimal Label variation BINDING_TABLE block | The 4 new Role Label entries follow this exact shape — only `"color": {"font_color": {"role": "role_<x>"}}` |
| `set_type_variation(name, base_type)` Godot API | Registers a variation so consumer-set `theme_type_variation = "Name"` falls through to the base type then up to the registered slots | Called inside `_regenerate_theme()` at line 433 in a `for variation_name in TYPE_VARIATIONS.keys()` loop — Phase 13's 9 new keys flow through this loop automatically |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| 6% role tint via `{"role": "role_success", "alpha": 0.06}` on the stylebox | Manual `_mix(panel_bg, role_color, 0.06)` precomputed value injected into role_table as a new key `surface_panel_success_tint` | Adds 5 new keys to role_table (one per role); adds 5 derivation lines in `_regenerate_theme()`; rejected because the resolver's existing alpha branch already produces the same visual result with **zero new derivation code**. ALSO: a stylebox `bg_color.a = 0.06` is a near-transparent role color, which is visually identical to a 6% mix of role color over the underlying surface when stacked on PanelContainer's existing chrome — verify in 30-config smoke. |
| Subclass-style variations (`SuccessLabel extends DangerLabel`) | Direct base-type extension via `"SuccessLabel": "Label"` | The roadmap explicitly says all 4 Labels extend `Label`; all 5 Panels extend `PanelContainer`. No chain-up needed. Confirmed by re-reading ROADMAP Phase 13 § C1 + § C3. |
| Adding `accent_panel_tint`, `success_panel_tint`, etc. as new role-table keys precomputed via `_mix` | Reuse existing `role_<x>` keys + recipe alpha | Rejected — pollutes role_table with single-use keys and adds derivation lines. The recipe `alpha` field at lines 5353-5360 already handles this. |
| Per-direction role overrides (Pulse's `role_danger` differs from Slate's `role_danger`) | Use the existing direction-independent defaults at lines 339-342 | The roadmap is silent on per-direction role-color personality. Defaults are universal (`role_success = #5CC971` etc.). Document this as an assumption — if user wants per-direction roles, it's a follow-up. |

**Installation:**
No new packages. All required code paths exist.

**Version verification:**
N/A — Phase 13 ships only GDScript edits + showcase scene edits + new `.gd` verify helpers. No external dependencies.

---

## Architecture Patterns

### System Architecture Diagram

```
                          ┌──────────────────────────────────────┐
                          │  Consumer code/scene                 │
                          │  my_label.theme_type_variation =     │
                          │      "SuccessLabel"                  │
                          └────────────────┬─────────────────────┘
                                           │ Godot looks up
                                           ▼
              ┌──────────────────────────────────────────────────┐
              │  Theme (NeoCadeTheme instance) — set_type_variation │
              │  registry maps "SuccessLabel" → "Label"          │
              │  (registered in TYPE_VARIATIONS loop at line 429-433) │
              └────────────────┬─────────────────────────────────┘
                               │ Godot resolves font_color slot
                               │ via theme.get_color("font_color",
                               │   "SuccessLabel") which falls back
                               │ through SuccessLabel → Label → defaults
                               ▼
              ┌──────────────────────────────────────────────────┐
              │  BINDING_TABLE walk (lines 639-662 of            │
              │  _regenerate_theme)                              │
              │  • Reads BINDING_TABLE["SuccessLabel"] → ...     │
              │    .font_color → {"role": "role_success"}        │
              │  • Calls _resolve_recipe(recipe, "color",        │
              │    role_table, tokens, style_personality)        │
              │  • Color resolver branch (lines 5585-5615) reads │
              │    role_table["role_success"] = Color("#5CC971") │
              │  • set_color("font_color", "SuccessLabel", c)    │
              └──────────────────────────────────────────────────┘

  For Role Panels: identical path, but the stylebox branch (lines 5336-5584)
  reads BINDING_TABLE["SuccessPanel"].stylebox.panel → recipe with
  role: "role_success", alpha: 0.06, border_role: "surface_panel_edge",
  raised_intensity: "shape.raised_lifts.panel", radius/padding inherited.
```

The diagram shows: Phase 13 introduces NO new code paths. It only adds keys to TYPE_VARIATIONS and BINDING_TABLE — the same dispatch loop at lines 639-662 of `_regenerate_theme` handles the new entries automatically.

### Recommended Project Structure

```
addons/neocade_theme/scripts/
└── neocade_theme.gd                                        # ONLY modified production file
    ├── TYPE_VARIATIONS (lines 1257-1317)                   # +9 keys (4 Labels + 5 Panels)
    └── BINDING_TABLE (lines 1805-5057)                     # +9 top-level entries (140 → 149)

showcase/
└── showcase.tscn                                           # +1 ScrollContainer section (9 → 10)

.planning/phases/13-role-variations/
├── 13-RESEARCH.md                                          # This file
├── 13-CONTEXT.md                                           # (post-discuss)
├── 13-PATTERNS.md                                          # (post-discuss, optional)
├── 13-VALIDATION.md                                        # (post-plan)
├── helpers/
│   ├── _phase13_verify_headless.gd                         # SceneTree headless verifier
│   ├── _phase13_smoke_matrix.gd                            # 30-config smoke + post-Phase-13 invariants
│   └── _phase13_role_render.gd                             # SC#2 evidence: renders Showcase Role Variations section, asserts all 9 widgets present
└── 13-XX-...-PLAN.md / -SUMMARY.md                         # 1 plan file (single executable session)

README.md                                                   # +1 section: "Role Variations (opt-in)"
```

### Pattern 1: Additive TYPE_VARIATIONS Extension

**What:** Add 9 new key/value pairs to the const Dictionary literal at lines 1257-1317.
**When to use:** Whenever a new `theme_type_variation` opt-in is shipped.
**Example:**
```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd lines 1257-1317
# Insert 9 new entries; existing entries (47) UNCHANGED.
const TYPE_VARIATIONS: Dictionary = {
    # ... existing 47 entries ...
    # Role Label variations (Phase 13 § C1) — extend Label, role_<x> font_color
    "SuccessLabel": "Label",
    "WarningLabel": "Label",
    "DangerLabel":  "Label",
    "InfoLabel":    "Label",
    # Role Panel variations (Phase 13 § C3) — extend PanelContainer, 6% role-color tint
    "AccentPanel":  "PanelContainer",
    "InfoPanel":    "PanelContainer",
    "WarningPanel": "PanelContainer",
    "DangerPanel":  "PanelContainer",
    "SuccessPanel": "PanelContainer",
}
```

### Pattern 2: Additive BINDING_TABLE Extension — Role Labels

**What:** Add 4 new top-level entries to `BINDING_TABLE`, mirroring the existing `Caption` shape (lines 4940-4944).
**When to use:** Adding a Label variation that needs a single role-color font_color.
**Example:**
```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd line 5057 (insertion point — just before the closing brace)
# Mirror Caption recipe at lines 4940-4944.
"SuccessLabel": {
    "color": {
        "font_color": {"role": "role_success"},
    },
},
"WarningLabel": {
    "color": {
        "font_color": {"role": "role_warning"},
    },
},
"DangerLabel": {
    "color": {
        "font_color": {"role": "role_danger"},
    },
},
"InfoLabel": {
    "color": {
        "font_color": {"role": "role_info"},
    },
},
```

### Pattern 3: Additive BINDING_TABLE Extension — Role Panels (6% tint)

**What:** Add 5 new top-level entries to `BINDING_TABLE`, mirroring `CardPanel` shape (lines 5019-5034) but with role-color tint + alpha 0.06.
**When to use:** Adding a PanelContainer variation that should produce a subtle tinted background.
**Example:**
```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd line 5057 (insertion point)
# Tint recipe: role-colored bg at alpha 0.06; preserves the panel border + radius + raised lift from
# the per-direction shape language, so each Role Panel still shares chrome with default PanelContainer.
"AccentPanel": {
    "stylebox": {
        "panel": {
            "role":             "role_primary",
            "alpha":            0.06,
            "border_role":      "surface_panel_edge",
            "radius":           "shape.card_radius",
            "raised_intensity": "shape.raised_lifts.panel",
            "raised_face_edge": true,
            "padding":          Vector2i(12, 10),
        },
    },
},
"InfoPanel":    { "stylebox": { "panel": { "role": "role_info",    "alpha": 0.06, "border_role": "surface_panel_edge", "radius": "shape.card_radius", "raised_intensity": "shape.raised_lifts.panel", "raised_face_edge": true, "padding": Vector2i(12, 10) } } },
"WarningPanel": { "stylebox": { "panel": { "role": "role_warning", "alpha": 0.06, "border_role": "surface_panel_edge", "radius": "shape.card_radius", "raised_intensity": "shape.raised_lifts.panel", "raised_face_edge": true, "padding": Vector2i(12, 10) } } },
"DangerPanel":  { "stylebox": { "panel": { "role": "role_danger",  "alpha": 0.06, "border_role": "surface_panel_edge", "radius": "shape.card_radius", "raised_intensity": "shape.raised_lifts.panel", "raised_face_edge": true, "padding": Vector2i(12, 10) } } },
"SuccessPanel": { "stylebox": { "panel": { "role": "role_success", "alpha": 0.06, "border_role": "surface_panel_edge", "radius": "shape.card_radius", "raised_intensity": "shape.raised_lifts.panel", "raised_face_edge": true, "padding": Vector2i(12, 10) } } },
```

**Why `alpha: 0.06` instead of precomputed `_mix(panel_bg, role_color, 0.06)`:** The resolver at lines 5353-5407 applies `Color(c.r, c.g, c.b, alpha)` to the role-color lookup. The resulting StyleBoxFlat has `bg_color = role_color_with_a=0.06`, which when drawn over the underlying scene composites the same 6% tint. **VERIFY in Wave 0 smoke that this composites correctly under GL Compatibility** — Pitfall 3 in Phase 12 (border_alpha intermediate values cause halos) is a related concern but applies to BORDER alpha specifically; bg_color alpha is the documented way to produce a translucent fill.

**Open question (escalation candidate):** If 6% bg_color alpha produces a visually different result than a precomputed mix (e.g., GL Compatibility over-renders translucent fills the same way it over-renders translucent borders), fall back to precomputing the mix in `_regenerate_theme()` and exposing it as `role_table["role_<x>_panel_tint"]`. See § Pitfalls below for the contingency.

### Pattern 4: Additive Showcase Section

**What:** Add a 10th `ScrollContainer` child to `RootMargin/RootStack/ShowcaseTabs` in `showcase/showcase.tscn`.
**When to use:** Demonstrating new theme variations to consumers.
**Example:**
```gdscript
# Source: showcase/showcase.tscn — current 9 sections at lines 108-1124. Insert section 10 AFTER line 1124's
# "Coverage 37 of 37" tab (or between any pair of existing tabs; the metadata/_tab_index controls order).
# Schema (mirror Buttons section at lines 108-336):
[node name="Role Variations" type="ScrollContainer" parent="RootMargin/RootStack/ShowcaseTabs" unique_id=<fresh>]
layout_mode = 2
horizontal_scroll_mode = 1
metadata/_tab_index = 9  # 10th position (0-indexed)

[node name="Margin" type="MarginContainer" parent=".../Role Variations" unique_id=<fresh>]
theme_override_constants/margin_left = 12
theme_override_constants/margin_top = 12
theme_override_constants/margin_right = 12
theme_override_constants/margin_bottom = 24

[node name="Grid" type="GridContainer" parent=".../Role Variations/Margin" unique_id=<fresh>]
theme_override_constants/h_separation = 14
theme_override_constants/v_separation = 14
columns = 3  # or 5 depending on demo layout — 5 panels in one row + 4 labels in another reads cleanly with columns=5

[node name="RoleSectionKicker" type="Label" parent=".../Grid" unique_id=<fresh>]
theme_type_variation = &"Kicker"
text = "ROLE VARIATIONS · OPT-IN"

# Then 9 demo cells:
#   SuccessLabel demo (e.g., text = "Run uploaded successfully", theme_type_variation = &"SuccessLabel")
#   WarningLabel demo (text = "Network is slow", theme_type_variation = &"WarningLabel")
#   DangerLabel demo  (text = "Save failed", theme_type_variation = &"DangerLabel")
#   InfoLabel demo    (text = "New season starts Friday", theme_type_variation = &"InfoLabel")
#   AccentPanel demo  (PanelContainer wrapping a content Label, theme_type_variation = &"AccentPanel")
#   InfoPanel demo    ("...")
#   WarningPanel demo ("...")
#   DangerPanel demo  ("...")
#   SuccessPanel demo ("...")
```

**Unique IDs:** Godot 4.6 `.tscn` `unique_id=` attribute uses integers. Use a large constant offset (e.g., `2700000010` onward) to avoid clashes with existing IDs (the showcase already uses values like `2700000001` for Kickers per line 128).

### Anti-Patterns to Avoid

- **DO NOT rewrite the default `Label.font_color` recipe (line 3147).** That would violate SC#3 ("Type variations only activate when consumer applies `theme_type_variation`"). The roadmap is explicit: default Label chrome must remain byte-identical to Phase 12 baseline.
- **DO NOT rewrite the default `PanelContainer.panel` recipe (lines 4989-5000).** Same reason as above — SC#3 mandates default PanelContainer chrome must remain byte-identical.
- **DO NOT add new `@export` properties.** SC preserves the 12-export contract from Phase 12 (FOUND-02). The 9 new variations are pure-data registrations.
- **DO NOT introduce new role-table keys for the panel tint** unless the 0.06 alpha pathway is rejected by SC#1 smoke test. Adds derivation lines for zero functional gain.
- **DO NOT modify Phase 12's helper scripts.** They assert `BINDING_TABLE == 140`. Create Phase 13's own helpers under `.planning/phases/13-role-variations/helpers/`.
- **DO NOT add a `font_color` recipe to default `Label`'s BINDING_TABLE entry that references a role token.** The default Label.font_color is `{"role": "text_strong"}` (line 3147) — must stay as-is.
- **DO NOT skip the `font` set on the new Label variations.** Per PITFALLS 1.2 (referenced in `_regenerate_theme()` lines 435-462), type variations DO NOT inherit fonts from their base type. The new Role Label variations need explicit `set_font("font", "SuccessLabel", body_font)` etc., added to the explicit `set_font` block at lines 441-477. **This is the easiest thing to forget and the highest-impact bug** — without explicit fonts, the labels fall back to default_font, which is usually fine because default_font matches body_font for Labels, BUT future-proof against any default_font swap by setting them explicitly.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| 6% panel tint | A new `_mix_panel_tint(role_color)` helper | The existing recipe `{"role": "role_<x>", "alpha": 0.06}` pathway | Resolver already supports alpha; adding a helper duplicates logic |
| Role-color precomputed table | `surface_<role>_panel` derivation block in `_regenerate_theme()` | Read role_color from role_table at recipe-resolve time | Adds 5 new derivation lines for no functional gain |
| Verifier framework | A test-runner abstraction | Phase 12's headless `extends SceneTree` script with `--stage` arg pattern | Already battle-tested through Phase 12 SC#1-SC#6 + 30-config smoke |
| 30-config smoke matrix | A new randomized matrix | Copy `_phase12_smoke_matrix.gd` verbatim and update `EXPECTED_BINDING_TABLE_ROWS` to 149 | Identical curated configs; identical invariant checks; only the post-Phase-13 row count differs |
| Per-section showcase scene loader | A new scene script | The existing showcase pattern (ScrollContainer → MarginContainer → GridContainer with section Kicker) | Confirmed by reading lines 108-336 (Buttons section template) — exactly mirror this. |
| Greyscale identifiability for the new section | A new render helper | None needed — SC#4 from Phase 12 doesn't extend to Phase 13 | Phase 13 SC are SC#1 (default chrome unchanged via 30-config), SC#2 (variations visible in showcase), SC#3 (no auto-bindings). Greyscale identifiability is not a Phase 13 criterion. |

**Key insight:** Phase 13 is **the textbook additive opt-in pattern** for the existing architecture. The entire scope — 9 variations + 1 showcase section + verifier — is implementable by editing 1 production file + 1 scene file + creating 1 new helpers folder, with zero new code paths in the resolver or any formula.

---

## Common Pitfalls

### Pitfall 1: GL Compatibility may over-render `bg_color.a < 1.0` (potential halo on tinted panels)

**What goes wrong:** GL Compatibility renderer (the ship target per CROSS-PLATFORM.md + EXPORT-04) over-renders intermediate alpha on StyleBox borders (Phase 12 SC#3 deals with this via `border_color.a in {0, 1}` invariant — see `_phase12_verify_headless.gd::_stage_sc3` lines 176-217). The question is whether the same over-rendering happens for `bg_color.a` (the panel fill).
**Why it happens:** Phase 12 RESEARCH cites Godot issue #23640 (GL Compat shadow alpha over-rendering). The fix was `shadow_size = -1` everywhere. Whether bg_color alpha is similarly affected is **not documented in this repo**. Phase 12 SC#3 verifier explicitly handles border alpha — silent on bg alpha.
**How to avoid:** Wave 0 of Phase 13 must run a smoke test that creates a `SuccessPanel` widget in headless mode, regenerates the theme, retrieves the stylebox via `theme.get_stylebox("panel", "SuccessPanel")`, and asserts `sb.bg_color.a == 0.06` (sanity check on the resolver), THEN renders the showcase scene at any one style and inspects via `_phase12_thumbnail_render` pattern whether the tinted panel reads as a halo or as a clean tint. If it halos: switch to **Pitfall 1 Fallback** below.
**Pitfall 1 Fallback:** Precompute the mix in `_regenerate_theme()`. Add 5 derivation lines after the role-token block (line 342):
```gdscript
var role_success_panel_tint: Color = _mix(surface_panel, role_success, 0.06)
var role_warning_panel_tint: Color = _mix(surface_panel, role_warning, 0.06)
var role_danger_panel_tint:  Color = _mix(surface_panel, role_danger,  0.06)
var role_info_panel_tint:    Color = _mix(surface_panel, role_info,    0.06)
var role_primary_panel_tint: Color = _mix(surface_panel, role_primary, 0.06)
```
Add 5 keys to role_table (around line 610). Recipes then use `{"role": "role_<x>_panel_tint"}` with no alpha.
**Warning signs:** Visible "glow" or "halo" around Role Panel borders in the showcase rendered at any style. Compare against Phase 12 mockup-refined-plan.html expectation.

### Pitfall 2: `theme_type_variation` lookup quirk — variations DO NOT inherit fonts (PITFALLS 1.2)

**What goes wrong:** Consumer sets `my_label.theme_type_variation = "SuccessLabel"`. Godot looks up `font_color` and successfully gets `role_success` via the BINDING_TABLE walk. Then Godot looks up `font` — and DOESN'T find one on `SuccessLabel` because we forgot to register it. The label falls back to the theme's `default_font`, which is usually fine, but if a consumer has overridden the `default_font` on a duplicated theme, the variation will render in the wrong font.
**Why it happens:** PITFALLS 1.2 (cited at lines 435-440 of `_regenerate_theme()`): "type variations DO NOT inherit fonts from base type, even when stylebox inheritance works." This is a Godot 4.6 quirk that already trips existing variations — see existing pattern at lines 441-462 where every type variation gets an explicit `set_font("font", "...")` call.
**How to avoid:** Add 4 explicit `set_font("font", "SuccessLabel", body_font)` etc. calls in the existing block at lines 441-462. For the 5 Role Panels: no explicit font needed (PanelContainer itself doesn't render text — but `CardPanel`/`HeroPanel` do have explicit set_font calls at lines 461-462 for content layout; mimic those to stay consistent).
**Warning signs:** In headless render, a Role Label appears in a different font weight or family than a default Label at the same font size. Verifier should assert `theme.get_font("font", "SuccessLabel") != null` for all 4 Role Labels.

### Pitfall 3: PanelContainer stylebox "merging" — Godot does NOT merge, it REPLACES

**What goes wrong:** Plan authors might assume that `BINDING_TABLE["SuccessPanel"].stylebox.panel` merges with `BINDING_TABLE["PanelContainer"].stylebox.panel` (the default at lines 4989-5000). It does not — Godot's `set_stylebox(slot, type, stylebox)` REPLACES whatever stylebox was registered for that (slot, type) pair. The base type entry is consulted at LOOKUP time via the variation chain, not assembled at registration time.
**Why it happens:** `theme_type_variation` is a runtime lookup mechanism. When the consumer Control's effective type is `"SuccessPanel"`, Godot's `Theme::get_stylebox("panel", "SuccessPanel")` first checks the SuccessPanel entry; if missing, falls back to PanelContainer; if missing, returns the default StyleBoxEmpty. So our SuccessPanel BINDING_TABLE entry MUST provide a complete stylebox recipe — it cannot "extend" the PanelContainer recipe with just an alpha override.
**How to avoid:** Each of the 5 Role Panel recipes must specify the full set of `role` + `border_role` + `alpha` + `radius` + `raised_intensity` + `raised_face_edge` + `padding` fields, mirroring the existing CardPanel structure at lines 5019-5034. The recipe shown in Pattern 3 above is complete.
**Warning signs:** A Role Panel renders without a border or with wrong radius — symptom of an incomplete recipe.

### Pitfall 4: `editor_only` filter at line 640 silently skips entries

**What goes wrong:** The BINDING_TABLE walk at line 640 says `if not editor_hint and EDITOR_ONLY_THEME_TYPES.has(theme_type): continue`. If a Phase 13 author accidentally adds the 9 new variation names to `EDITOR_ONLY_THEME_TYPES` (lines 1320-1388), they'll silently disappear from runtime themes.
**Why it happens:** The pattern exists for editor-specific variations. The 9 new variations are explicitly NOT editor-only — they're general-purpose opt-ins.
**How to avoid:** Do NOT add the 9 new keys to `EDITOR_ONLY_THEME_TYPES`. The verifier should assert: `for variation in ["SuccessLabel", ..., "SuccessPanel"]: assert not EDITOR_ONLY_THEME_TYPES.has(variation)`.
**Warning signs:** Variation appears in headless TYPE_VARIATIONS introspection but does NOT appear in `theme.get_color_type_list()` / `theme.get_stylebox_type_list()` at runtime — symptom of the editor_only filter eating it.

### Pitfall 5: Showcase `unique_id` collisions break the scene load

**What goes wrong:** Godot 4.6 `.tscn` `unique_id=<int>` must be unique within the scene. Using values that already exist for other nodes will silently corrupt the scene on load.
**Why it happens:** The showcase already uses `unique_id=2700000001` for Kicker labels (line 128 et al). Random numbers risk collision.
**How to avoid:** Use a Phase-13-reserved offset (e.g., `2700000010` through `2700000050`) and verify uniqueness by running a grep over the existing IDs first.
**Warning signs:** Scene fails to load or renders without the new section. Symptom: opening `showcase/showcase.tscn` in Godot editor produces a parse error.

### Pitfall 6: Adding new fonts to Role Label variations needs explicit `set_font_size` too

**What goes wrong:** Adding `set_font("font", "SuccessLabel", body_font)` but forgetting `set_font_size("font_size", "SuccessLabel", tokens.body)`. Without the size set explicitly, the variation falls back to default_font_size — usually correct, but inconsistent with the existing Caption variation pattern at lines 444 + 504.
**Why it happens:** The font and font_size slots are separately bindable in Godot 4.6.
**How to avoid:** For each new Role Label, add BOTH a `set_font("font", "<x>Label", body_font)` call (in the block at lines 441-462) AND a `set_font_size("font_size", "<x>Label", tokens.body)` call (in the block at lines 498-527). Mirror the Caption pattern (line 444 + line 504).
**Warning signs:** Role Label renders at a different size than Caption on mobile (which scales tokens.body from 14 to 16).

---

## Runtime State Inventory

Phase 13 is **NOT** a rename/refactor/migration phase — it's an additive feature phase. The Runtime State Inventory check is included for completeness:

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | None — Phase 13 adds new theme entries; consumers opt in via scene authoring or runtime `theme_type_variation` assignment. No data store carries the old/new variation names. | None |
| Live service config | None — no external services configure NeoCade variations. | None |
| OS-registered state | None — Godot does not register theme variations with the OS. | None |
| Secrets / env vars | None — Phase 13 has no secret keys. | None |
| Build artifacts / installed packages | The compiled `addons/neocade_theme/neocade_theme.tres` is a Godot Resource. After the source `.gd` is edited and the project is reopened in Godot, the canonical `.tres` is automatically regenerated by `_regenerate_theme()` on next instantiation. No manual artifact rebuild needed. The `.tres` file ON DISK may contain serialized theme entries from Phase 12 — Godot will regenerate over them per FOUND-03 SC#5/SC#6 ("Saved `.tres` behavior is honest Godot behavior; Godot may serialize generated Theme entries"). | None — verifier asserts post-Phase-13 entries are present in headless reload of the canonical .tres |

---

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| Godot 4.6 CLI (headless) | Phase 13 verifier helpers + 30-config smoke + showcase render check | ⚠️ Last documented status: present on author's machine (Phase 12 helpers ran successfully); CLI path at `.planning/phases/05-.../helpers/godot-cli-path.txt` per 12-VALIDATION.md line 65 | 4.6 | If unavailable, defer SC#1/SC#2 verification to manual UAT per Phase 4 precedent (BINDING_TABLE_SEED.txt placeholder pattern) |
| Git | Commit / atomic plan landing | ✓ | per system | — |
| PowerShell (Windows) | Helper invocations on the dev machine | ✓ | Windows 11 native | bash via Bash tool |

**Missing dependencies with no fallback:** None at planning time.

**Missing dependencies with fallback:** Godot CLI — if unavailable, plans use the Phase 4 precedent of headless-deferred verification with a documented fallback.

---

## Validation Architecture

**Nyquist validation required** per `.planning/config.json`: `"nyquist_validation": true`.

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Godot 4.6 native (no external test framework). Verify helpers are `extends SceneTree` (headless CLI variant), per Phase 12 precedent. |
| Config file | None — helper scripts are standalone. |
| Quick run command | `godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd" -- --stage architecture` |
| Full suite command | `godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd" -- --stage full` then `godot --headless --quit --script ".planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd"` |
| Estimated runtime | ~5–10 seconds per stage; ~15–25 seconds for the 30-config smoke; total full suite ~30 seconds |

### Phase Requirements → Test Map

Phase 13 has **no REQUIREMENTS.md REQ-IDs** (per ROADMAP.md line 607). Validation maps to the **3 locked success criteria** from ROADMAP.md lines 609-612.

| SC ID | Behavior | Test Type | Automated Command | File Exists? |
|-------|----------|-----------|-------------------|--------------|
| **SC#1** | Default chrome unchanged from Phase 12 baseline. Smoke-test 30 configs (5 styles × 2 raised × 3 platforms) pre/post pixel-equal where no Role Variation widget is placed. | runtime (headless) + diff-against-Phase-12-baseline | `godot --headless --quit --script ".../_phase13_smoke_matrix.gd"` (asserts BINDING_TABLE == 149, TYPE_VARIATIONS == 56, Button.normal/PanelContainer.panel/Label.font_color recipes BYTE-IDENTICAL to Phase 12 by comparing the resolved StyleBox fields) | ❌ Wave 0 |
| **SC#2** | All 4 Labels + 5 Panels visible in the new Showcase section. Headless render verifies each `TYPE_VARIATIONS` entry appears in the live registry AND in the showcase scene. | runtime (headless registry introspection) + scene-load assertion | `godot --headless --quit --script ".../_phase13_verify_headless.gd" -- --stage role-variations-registered` (asserts the 9 keys exist in TYPE_VARIATIONS; `theme.get_color_type_list()` contains all 4 Labels; `theme.get_stylebox_type_list()` contains all 5 Panels) + `--stage role-variations-in-showcase` (loads showcase.tscn, walks the tree, asserts 9 nodes with the expected `theme_type_variation` properties) | ❌ Wave 0 |
| **SC#3** | Type variations only activate when consumer applies `theme_type_variation` — never auto-bound to widget defaults. Default Label and default PanelContainer chrome produce byte-identical output to Phase 12 baseline. | static (BINDING_TABLE diff vs frozen Phase 12 baseline at line 3141-3149 and 4989-5000) + runtime introspection | `--stage default-chrome-unchanged` (loads canonical .tres, retrieves `theme.get_color("font_color", "Label")` and `theme.get_stylebox("panel", "PanelContainer")`, compares against a captured Phase 12 baseline; FAILS if anything in those slots references role_success/role_warning/role_danger/role_info/role_primary) | ❌ Wave 0 |
| **architecture** | Canonical .tres loads, BINDING_TABLE.size() == 149, TYPE_VARIATIONS.size() == 56, @export count == 12 | runtime (headless) | `--stage architecture` | ❌ Wave 0 |
| **smoke-30** | All 30 representative configs regenerate without error post-Phase-13 (invariants: BT==149, TV==56, @export==12, Button.normal exists, PanelContainer.panel exists, all 9 new variations resolve to a StyleBox or Color value, not null) | runtime (headless) | `_phase13_smoke_matrix.gd` | ❌ Wave 0 |
| **fonts-explicit** | Each of the 4 new Role Labels has an explicit `font` slot bound (per PITFALLS 1.2 mandate). | runtime (headless) | `--stage role-label-fonts` (asserts `theme.get_font("font", "SuccessLabel") != null` × 4) | ❌ Wave 0 |
| **panel-alpha-renders-cleanly** (Pitfall 1 contingency) | A Role Panel with `bg_color.a == 0.06` renders cleanly under GL Compatibility (no halo). | tooled (headless render) + manual visual confirmation | Render via `_phase13_role_render.gd`; visual diff against the precomputed-mix fallback's render | ❌ Wave 0 (only run if Pitfall 1 contingency triggers) |

### Sampling Rate

- **Per task commit:** `--stage architecture` (~5 seconds; asserts the 149/56 counts hold)
- **Per wave merge:** `--stage full` + `_phase13_smoke_matrix.gd` (~30 seconds)
- **Phase gate (before `/gsd-verify-work`):** Full suite green + visual inspection of showcase Role Variations section against the locked design intent (subtle 6% tint per panel; legible color font on each label)

### Wave 0 Gaps

Before Phase 13 implementation can begin, Wave 0 must create the following helpers:

- [ ] `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd` — SceneTree headless verifier with stages: `architecture`, `role-variations-registered`, `role-variations-in-showcase`, `default-chrome-unchanged`, `role-label-fonts`, `full`. Mirror Phase 12 `_phase12_verify_headless.gd` structure (file already documented in this RESEARCH at the source quote above).
- [ ] `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd` — Direct port of `_phase12_smoke_matrix.gd` with `EXPECTED_BINDING_TABLE_ROWS = 149` and a new invariant block asserting all 9 Phase 13 variations exist in TYPE_VARIATIONS and produce non-null stylebox/color values for the 30 configs.
- [ ] `.planning/phases/13-role-variations/helpers/_phase13_role_render.gd` (optional, Pitfall 1 contingency only) — Renders showcase.tscn at Pulse style with the Role Variations tab active, saves PNG to `.planning/phases/13-role-variations/artifacts/`, for visual halo inspection.
- [ ] Framework install: NONE — Godot CLI path already documented at `.planning/phases/05-.../helpers/godot-cli-path.txt` per Phase 12 precedent.

If Godot CLI is unavailable on the executor machine: defer SC#1/SC#2 smoke tests to manual UAT per Phase 4 BINDING_TABLE_SEED.txt fallback precedent. The static SC#3 check (default chrome unchanged) can still run via grep / introspection-by-reading-source.

---

## Code Examples

### Example 1: Adding the 9 TYPE_VARIATIONS entries

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd, insert AFTER line 1316 (just before the closing brace at line 1317)
# Existing line 1316: 	"NoBorderHorizontalBottom": "NoBorderHorizontal",
# Then add the 9 new entries below, then close brace:

	# Phase 13 § C1: Role Label opt-in type variations (4)
	"SuccessLabel": "Label",
	"WarningLabel": "Label",
	"DangerLabel":  "Label",
	"InfoLabel":    "Label",
	# Phase 13 § C3: Role Panel opt-in type variations (5)
	"AccentPanel":  "PanelContainer",
	"InfoPanel":    "PanelContainer",
	"WarningPanel": "PanelContainer",
	"DangerPanel":  "PanelContainer",
	"SuccessPanel": "PanelContainer",
}
```

### Example 2: Adding the 9 BINDING_TABLE entries

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd, insert AFTER line 5056 (closing of HeroPanel block)
# and BEFORE line 5057 (closing of BINDING_TABLE):

	# 55. SuccessLabel — Label variation (Phase 13 § C1). Opt-in only; default Label.font_color
	#     remains text_strong at line 3147 — SC#3 invariant.
	"SuccessLabel": {
		"color": {
			"font_color": {"role": "role_success"},
		},
	},
	# 56. WarningLabel — Label variation (Phase 13 § C1).
	"WarningLabel": {
		"color": {
			"font_color": {"role": "role_warning"},
		},
	},
	# 57. DangerLabel — Label variation (Phase 13 § C1).
	"DangerLabel": {
		"color": {
			"font_color": {"role": "role_danger"},
		},
	},
	# 58. InfoLabel — Label variation (Phase 13 § C1).
	"InfoLabel": {
		"color": {
			"font_color": {"role": "role_info"},
		},
	},
	# 59-63. Role Panels — PanelContainer variations (Phase 13 § C3).
	#        6%-mix tint of the corresponding role color over the per-direction panel chrome.
	#        Mirror CardPanel recipe (lines 5019-5034) but override `role` and add `alpha: 0.06`.
	#        Opt-in only; default PanelContainer.panel at lines 4989-5000 stays unchanged — SC#3 invariant.
	"AccentPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_primary",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	"InfoPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_info",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	"WarningPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_warning",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	"DangerPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_danger",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
	"SuccessPanel": {
		"stylebox": {
			"panel": {
				"role":             "role_success",
				"alpha":            0.06,
				"border_role":      "surface_panel_edge",
				"radius":           "shape.card_radius",
				"raised_intensity": "shape.raised_lifts.panel",
				"raised_face_edge": true,
				"padding":          Vector2i(12, 10),
			},
		},
	},
}
```

### Example 3: Adding explicit font + font_size for the 4 new Role Labels

```gdscript
# Source: addons/neocade_theme/scripts/neocade_theme.gd, in the `_regenerate_theme()` font-set
# block at lines 441-462. INSERT new lines AFTER existing Caption line at line 444:

# (Existing lines 441-444:)
# 	set_font("font", "HeaderLarge",  header_large_font)
# 	set_font("font", "HeaderMedium", header_medium_font)
# 	set_font("font", "HeaderSmall",  header_small_font)
# 	set_font("font", "Caption",      body_font)
#
# ADD:
	# Phase 13 § C1: explicit font binding for Role Label variations (PITFALLS 1.2 — type
	# variations do NOT inherit fonts from their base type).
	set_font("font", "SuccessLabel", body_font)
	set_font("font", "WarningLabel", body_font)
	set_font("font", "DangerLabel",  body_font)
	set_font("font", "InfoLabel",    body_font)

# In the font_size block at lines 498-527, INSERT after existing Caption font_size at line 504:
# (Existing line 504:)
# 	set_font_size("font_size", "Caption",      tokens.label_)
#
# ADD:
	# Phase 13 § C1: explicit font_size binding for Role Label variations.
	set_font_size("font_size", "SuccessLabel", tokens.body)
	set_font_size("font_size", "WarningLabel", tokens.body)
	set_font_size("font_size", "DangerLabel",  tokens.body)
	set_font_size("font_size", "InfoLabel",    tokens.body)
```

**Note:** Role Labels use `tokens.body` (not `tokens.label_`) because they're general-purpose body labels, not small captions. The exact size choice is a discuss-phase decision; `tokens.body` is the default-Label-equivalent size and the safest pick. The 5 Role Panels do NOT need explicit font/font_size because PanelContainer doesn't render text.

### Example 4: Verifier helper skeleton (mirror Phase 12 `_phase12_verify_headless.gd`)

```gdscript
# Source: .planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd
# Mirror .planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd

extends SceneTree

const CANONICAL_TRES := "res://addons/neocade_theme/neocade_theme.tres"
const EXPECTED_EXPORT_COUNT := 12
const EXPECTED_BINDING_TABLE_ROWS := 149  # 140 Phase 12 baseline + 9 Phase 13 additions
const EXPECTED_TYPE_VARIATIONS_COUNT := 56  # 47 Phase 12 baseline + 9 Phase 13 additions
const PHASE_13_NEW_LABEL_VARIATIONS := ["SuccessLabel", "WarningLabel", "DangerLabel", "InfoLabel"]
const PHASE_13_NEW_PANEL_VARIATIONS := ["AccentPanel", "InfoPanel", "WarningPanel", "DangerPanel", "SuccessPanel"]
const PHASE_13_ROLE_KEYS_FOR_LABELS := {
	"SuccessLabel": "role_success",
	"WarningLabel": "role_warning",
	"DangerLabel":  "role_danger",
	"InfoLabel":    "role_info",
}
const PHASE_13_ROLE_KEYS_FOR_PANELS := {
	"AccentPanel":  "role_primary",
	"InfoPanel":    "role_info",
	"WarningPanel": "role_warning",
	"DangerPanel":  "role_danger",
	"SuccessPanel": "role_success",
}

const VALID_STAGES := [
	"architecture",
	"role-variations-registered",
	"role-variations-in-showcase",
	"default-chrome-unchanged",
	"role-label-fonts",
	"full",
]

# ... _init / _parse_args / _run_stage match Phase 12 pattern ...

func _stage_role_variations_registered() -> void:
	# SC#2 part 1: TYPE_VARIATIONS registry includes 9 new keys.
	var theme: NeoCadeTheme = _fresh_theme()
	if theme == null: return
	var script: Script = theme.get_script() as Script
	var tv: Dictionary = script.get_script_constant_map().get("TYPE_VARIATIONS", {})
	for v in PHASE_13_NEW_LABEL_VARIATIONS + PHASE_13_NEW_PANEL_VARIATIONS:
		if not tv.has(v):
			_fail("role-variations-registered: TYPE_VARIATIONS missing %s" % v)
	# Also assert the BASE type chain
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if tv.get(v) != "Label":
			_fail("role-variations-registered: %s base type = %s (expected Label)" % [v, tv.get(v)])
	for v in PHASE_13_NEW_PANEL_VARIATIONS:
		if tv.get(v) != "PanelContainer":
			_fail("role-variations-registered: %s base type = %s (expected PanelContainer)" % [v, tv.get(v)])
	# Live registry: theme.get_color_type_list() / get_stylebox_type_list()
	var color_types: PackedStringArray = theme.get_color_type_list()
	for v in PHASE_13_NEW_LABEL_VARIATIONS:
		if not v in color_types:
			_fail("role-variations-registered: %s missing from theme.get_color_type_list()" % v)
	var sb_types: PackedStringArray = theme.get_stylebox_type_list()
	for v in PHASE_13_NEW_PANEL_VARIATIONS:
		if not v in sb_types:
			_fail("role-variations-registered: %s missing from theme.get_stylebox_type_list()" % v)
	if _failures.is_empty():
		print("PHASE13_VERIFY: role-variations-registered OK (9 new variations live)")


func _stage_default_chrome_unchanged() -> void:
	# SC#3: Default Label.font_color must NOT resolve to any role_* color.
	# Default PanelContainer.panel.bg_color must NOT resolve to any role_* color.
	var theme: NeoCadeTheme = _fresh_theme()
	if theme == null: return
	# Iterate every selectable style; for each, assert the resolved values.
	for style_value in NeoCadeTheme.selectable_styles():
		theme.style = style_value
		var default_label_color: Color = theme.get_color("font_color", "Label")
		# Capture the Phase 12 expected: text_strong from role_table — derived from
		# base_color + is_light. This is the "anything but the role tokens" assertion.
		# We approximate by checking that the resolved color is NOT one of the 5 role colors.
		var role_success := Color("#5CC971")
		var role_warning := Color("#FFD166")
		var role_danger  := Color("#FF6E6E")
		var role_info    := Color("#5FE3FF")
		# role_primary == accent_color (per-style). Don't compare against it directly; instead
		# assert the Label.font_color does NOT match accent_color either.
		if default_label_color.is_equal_approx(role_success) or default_label_color.is_equal_approx(role_warning) or default_label_color.is_equal_approx(role_danger) or default_label_color.is_equal_approx(role_info) or default_label_color.is_equal_approx(theme.accent_color):
			_fail("default-chrome-unchanged: style=%s Label.font_color resolves to a role color (%s) — SC#3 violation" % [NeoCadeTheme.style_label(style_value), default_label_color])
		# Same check on PanelContainer.panel.bg_color
		var panel_sb: StyleBoxFlat = theme.get_stylebox("panel", "PanelContainer") as StyleBoxFlat
		if panel_sb != null:
			var panel_bg: Color = panel_sb.bg_color
			# The Phase 12 default uses surface_panel; assert it is NOT a role color.
			if panel_bg.a > 0.05 and panel_bg.a < 0.99:
				_fail("default-chrome-unchanged: style=%s PanelContainer.panel bg_color has translucent alpha %.3f — Phase 12 baseline was opaque" % [NeoCadeTheme.style_label(style_value), panel_bg.a])
	if _failures.is_empty():
		print("PHASE13_VERIFY: default-chrome-unchanged OK across all selectable styles")
```

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| (Phase 12) BINDING_TABLE rows for tab_selected on TabBar/TabContainer used `border_role: "button_border_pressed"` (no accent stripe) | Phase 12 C2' rebound to `border_role: "role_primary"` + `border_widths: Vector4i(0, 2, 0, 0)` for a 2px top accent stripe | 2026-05-11 (Phase 12 Wave 2) | Pattern: BINDING_TABLE-only edits with no resolver changes are the standard way to inject accent presence. Phase 13 follows the same idiom: BINDING_TABLE-only additions, no resolver work. |
| (Pre-Phase-12) `EXPECTED_BINDING_TABLE_ROWS = 37` referenced the Phase 4 scorecard count | Phase 12 baseline: `EXPECTED_BINDING_TABLE_ROWS = 140` (per smoke matrix line 17) | 2026-05-10 (Phase 12 baseline lock) | Phase 13 lifts this to 149 in its own helper copies. |
| Phase 12 thumbnail render at 256×144 for SC#4 greyscale identifiability | Phase 13 has NO equivalent SC — Role Variations are not direction-personality changes, so no greyscale identifiability check applies | 2026-05-11 (Phase 13 scope lock) | Reduces verifier complexity; no thumbnail render helper needed |
| Phase 4 pattern: 14 type variations in `TYPE_VARIATIONS` | Post-Phase-12: 47 type variations (5+13+1+1+1+1+13+12 incl. editor-only) | Phase 5/6/7/12 cumulative | Phase 13 adds 9 → 56 total |

**Deprecated/outdated:**
- The 37-row freeze constant from Phase 4 is no longer the right number; verifier helpers must use 140 (Phase 12) or 149 (Phase 13 post). The Phase 12 helpers explicitly call this out in their comment block at lines 16-22.

---

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The recipe `{"role": "role_<x>", "alpha": 0.06}` on a stylebox produces a visually clean 6% role-color tint on PanelContainer under GL Compatibility (no halo/over-render artifact) | Pattern 3 (Role Panels), Pitfall 1 | If wrong: switch to precomputed mix in role_table (5 new derivation lines + 5 new role-table keys); see Pitfall 1 Fallback. Mitigation: Wave 0 smoke explicitly checks the rendered panel against the design intent. |
| A2 | Role color defaults (role_success=#5CC971, role_warning=#FFD166, role_danger=#FF6E6E, role_info=#5FE3FF) are direction-independent | Standard Stack > Role tokens | If wrong: the 9 BINDING_TABLE recipes still work; only the visual outcome would differ per-direction. Verified by reading lines 339-342 — these are literal Color() values, not derived from style_personality. |
| A3 | The `EDITOR_ONLY_THEME_TYPES` filter at line 1320-1388 does NOT need to include the 9 new variations (they are general-purpose, not editor-only) | Pitfall 4 | If wrong: variations would disappear from runtime themes. Mitigation: verifier asserts none of the 9 keys appear in EDITOR_ONLY_THEME_TYPES. |
| A4 | The existing showcase pattern (ScrollContainer → MarginContainer → GridContainer with 3 columns + Kicker label + N panel-wrapped widgets) is the right shape for the 10th section | Pattern 4 (Showcase Section) | If wrong: visual presentation may not match other sections. Mitigation: directly mirror the Buttons section structure at lines 108-336. |
| A5 | `tokens.body` is the correct font_size for the 4 new Role Labels (matching default Label sizing) | Code Example 3 | If wrong: labels could render at wrong size. Mitigation: discuss-phase confirms with user (default Label uses `default_font_size`, which on a Caption is `tokens.label_`; Role Labels are general-purpose so `tokens.body` is the safer pick). Alternative: leave font_size unset and inherit default_font_size. |
| A6 | The post-Phase-13 BINDING_TABLE row count is EXACTLY 149 (140 + 9) and TYPE_VARIATIONS count is EXACTLY 56 (47 + 9) | Validation Architecture | If the existing helpers ever stabilize at a different baseline, this assumption needs adjusting. Mitigation: Wave 0 step 1 is to run `_phase12_verify_headless.gd --stage architecture` and capture the pre-Phase-13 counts. |
| A7 | A single executable session can land all the Phase 13 work (TYPE_VARIATIONS + BINDING_TABLE + showcase scene + helpers + README) — i.e., 1 plan file is sufficient | Recommended Project Structure | If the work exceeds context budget, split into Wave 1 (TYPE_VARIATIONS + BINDING_TABLE) and Wave 2 (showcase + helpers + README). Plan stage decides. |
| A8 | The 6% role-color tint preserves SC#3 visually (default PanelContainer chrome looks identical to Phase 12 baseline when no Role Variation is applied) | SC#3 in Validation Architecture | The static introspection check covers this — the default PanelContainer.panel recipe at lines 4989-5000 is NOT touched, so the resolver produces the same value. Visual confirmation needed via 30-config smoke + spot check. |

**If this table is non-empty:** Multiple assumptions need user / executor confirmation. A1, A5, A7 are the highest-risk and most discuss-phase-relevant.

---

## Open Questions

1. **Should the 5 Role Panels use `tokens.body` `font_color` text bindings (so any Label inside reads cleanly)?**
   - What we know: CardPanel and HeroPanel both have `font_color: {"role": "text_strong"}` color bindings at lines 5031-5033 and 5053-5055. PanelContainer DOES expose a `font_color` slot via base Control inheritance even though PanelContainer doesn't directly render text — Labels inside the PanelContainer don't use this binding.
   - What's unclear: Whether to add an analog `font_color` color binding to each Role Panel for visual consistency with CardPanel/HeroPanel, or leave it off (PanelContainer.font_color is invisible without descendant Labels using `theme_type_variation = "ParentName"`, which is a Godot fall-through quirk).
   - Recommendation: **Leave it off** for the Role Panels (no `color` block, only `stylebox`). The role-color is already conveyed by the tinted background. Adding text styling within the panel is the consumer's responsibility (they can layer a Role Label inside the panel). This is the minimal-change approach.

2. **Should `AccentPanel` be the first or last in the 5 Role Panels (ordering in TYPE_VARIATIONS and BINDING_TABLE)?**
   - What we know: ROADMAP lists them as "`AccentPanel`, `InfoPanel`, `WarningPanel`, `DangerPanel`, `SuccessPanel`" (accent first). Ordering in the registry is alphabetical-by-existing-pattern in some places, scope-grouped in others.
   - What's unclear: No strict convention.
   - Recommendation: Follow ROADMAP order exactly (accent first, then info/warning/danger/success). Document this choice in the plan.

3. **Should the showcase Role Variations section be inserted as tab 10 (after Coverage 37 of 37) or in a more discoverable position?**
   - What we know: Existing tabs are functional groups (Buttons / Text / Range / Lists / Containers / Dialogs / Advanced / Tokens / Coverage). The new section is opt-in pattern demonstration — closest analog is "Token Gallery."
   - What's unclear: Whether the user wants Role Variations to be tab 9 (between Token Gallery and Coverage) or tab 10 (at the end).
   - Recommendation: **Tab 10, after Coverage 37 of 37**, because (a) Coverage is intentionally the "final" tab demonstrating completeness, and (b) Role Variations are opt-in extensions, which conceptually live after the core coverage statement. Discuss-phase confirms.

4. **For the 30-config smoke comparison "pre/post pixel-equal except where a Role Variation widget is intentionally placed" (SC#1) — what's the source-of-truth pre-baseline?**
   - What we know: Phase 12 helpers already establish a `Button.normal` stylebox capture and several runtime invariants. Phase 13 should compare against Phase 12 baseline.
   - What's unclear: Whether to capture Phase 12 baseline as JSON-serialized stylebox/color fields and check against them, or whether to compare against a live regenerated Phase 12 state (impossible to do post-edit without git checkout dance).
   - Recommendation: **Static byte-level introspection** rather than pixel-equal screenshot comparison. The 30-config smoke matrix asserts: for every config, every BINDING_TABLE row that EXISTS in Phase 12 still resolves to the same StyleBox/Color/int/Texture2D fields post-Phase-13. The 9 new keys are excluded. Specifically: assert `theme.get_color("font_color", "Label") == <captured Phase 12 value>` across 30 configs, where the captured value is recomputed once at smoke-test-time from a known Phase-12-equivalent role_table (since the formulas don't change, the resolved values are deterministic). Discuss-phase: confirm static introspection is acceptable vs. literal pixel diffs (which would require rendering 30+ scenes pre/post).

5. **The Phase 12 helpers folder has 8 files. Does Phase 13 need all of them or only a minimal subset?**
   - What we know: Phase 12 ships verify (both EditorScript + headless), smoke matrix, thumbnail render (.gd + .tscn × 2 for thumbnail + fullsize), and a runtime renderer.
   - What's unclear: Phase 13 has no thumbnail SC#4 equivalent, so thumbnail render scripts aren't needed. But the runtime renderer pattern may help with SC#2 (assert variations visible in scene).
   - Recommendation: **3 helpers** for Phase 13: `_phase13_verify_headless.gd` (multi-stage), `_phase13_smoke_matrix.gd` (post-Phase-13 invariants), `_phase13_role_render.gd` (optional, contingency for Pitfall 1). Skip the EditorScript variant; headless is sufficient.

---

## Project Constraints (from CLAUDE.md)

Phase 13 MUST respect these CLAUDE.md directives (extracted from the project root CLAUDE.md):

1. **Visual identity: flat MD3 / MD3 Expressive only.** No textures, patterns, embossing, painterly/leather/wood/grunge chrome, gradients on chrome, synthwave/neon-noir/cyberpunk, pixel art in the theme itself. — *Phase 13 introduces no new visual primitives; the 6% role-color tint is a flat solid color at low alpha, not a gradient or texture. Compliant.*

2. **Architecture: one concrete `@tool class_name NeoCadeTheme extends Theme` script** at `res://addons/neocade_theme/scripts/neocade_theme.gd` plus one canonical resource at `res://addons/neocade_theme/neocade_theme.tres`. **NO production subclasses, NO per-direction `.gd` files, NO per-style `.tres` files, NO `themes/` folder, NO `_dev/` folder, NO separate mobile theme resource.** — *Phase 13 only edits the existing concrete class + canonical resource. Compliant.*

3. **Public contract: NeoCadeTheme has exactly 12 exports.** `style`, `raised`, `platform`, `base_color`, `accent_color`, `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`, `outline_width`, `use_runtime_popup_selection_icons`, `texture_cache`. — *Phase 13 adds ZERO new exports. Compliant.*

4. **Setters regenerate theme entries dynamically.** No `Theme.clear()` shortcut (D-01 invariant from Phase 4). — *Phase 13 doesn't touch the `_regenerate_theme()` lifecycle. Compliant.*

5. **No editor plugin (`plugin.cfg`).** — *Phase 13 doesn't introduce a plugin. Compliant.*

6. **The state through Phase 12 is autonomous-execution-complete; Phase 13 is post-v1 visual-identity follow-up.** Manual release/UAT is out of Phase 13 scope. — *Phase 13 ships code/scene/docs additions only; no release workflow changes.*

7. **NeoCade is canonical name; VirtuCade is consuming game.** — *Phase 13 docs reference NeoCade everywhere.*

---

## Sources

### Primary (HIGH confidence — direct in-repo evidence)

- `addons/neocade_theme/scripts/neocade_theme.gd` lines 339-342, 603-610 — role_success/warning/danger/info color literals + role_table insertion [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 1257-1317 — TYPE_VARIATIONS dict shape, 47 entries pre-Phase-13 [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 1805-5057 — BINDING_TABLE dict shape, 140 top-level keys pre-Phase-13 [VERIFIED: smoke matrix line 17 + 12-VALIDATION line 30]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 3141-3149 — default Label BINDING_TABLE entry (font_color = text_strong) [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 4989-5000 — default PanelContainer BINDING_TABLE entry [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 5019-5034 — CardPanel BINDING_TABLE entry (reference shape for Role Panels) [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 5334-5615 — `_resolve_recipe()` color + stylebox branches with role + alpha handling [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 639-662 — BINDING_TABLE walk in `_regenerate_theme()`, 5 setter branches [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 429-462 — TYPE_VARIATIONS registration loop + explicit set_font block (PITFALLS 1.2 mandate) [VERIFIED: file read]
- `addons/neocade_theme/scripts/neocade_theme.gd` lines 772-778 — `_mix(a, b, amount)` helper [VERIFIED: file read]
- `showcase/showcase.tscn` lines 102-1124 — 9 ScrollContainer tabs at `RootMargin/RootStack/ShowcaseTabs/<Name>` [VERIFIED: file read]
- `showcase/showcase.tscn` lines 108-336 — Buttons section structure (reference for 10th section) [VERIFIED: file read]
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_smoke_matrix.gd` — 30-config curated matrix + invariant asserts [VERIFIED: file read]
- `.planning/phases/12-signature-visual-moves/helpers/_phase12_verify_headless.gd` — stage-based verifier pattern [VERIFIED: file read]
- `.planning/phases/12-signature-visual-moves/12-VALIDATION.md` — sampling rate + per-task verify map convention [VERIFIED: file read]
- `.planning/ROADMAP.md` lines 145-194 — Phase 13 top-of-roadmap richer scope/rationale [VERIFIED: file read]
- `.planning/ROADMAP.md` lines 603-619 — Phase 13 Phase Details synced goal + 3 locked success criteria [VERIFIED: file read]
- `.planning/STATE.md` lines 102-161 — Phase 12 closure state, key decisions, 96% milestone progress [VERIFIED: file read]
- `.planning/REQUIREMENTS.md` lines 116-122 — TYPEVAR-01..06 current state (live registry is authoritative) [VERIFIED: file read]
- `.planning/DESIGN_TOKENS.md` §7.1 Semantic role tokens — role.success/warning/danger/info default hex values match the lines 339-342 literals [VERIFIED: file read]
- `.planning/config.json` line 19 — `"nyquist_validation": true` mandates Validation Architecture section [VERIFIED: file read]
- `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-SUMMARY.md` — TYPE_VARIATIONS + BINDING_TABLE + _resolve_recipe canonical pattern and Cycle 2 N1 fix (no font branch) [VERIFIED: file read]

### Secondary (MEDIUM confidence — derived from primary sources via grep / structural analysis)

- The recipe `{"role": "role_<x>", "alpha": 0.06}` pathway is supported by the resolver at lines 5353-5407 — verified by reading the stylebox branch carefully; the `alpha < 1.0` check at line 5406 explicitly applies it to the bg_color. **Not visually verified** end-to-end (no headless render done in this research session).
- The post-Phase-13 BINDING_TABLE count of 149 (140 + 9) is derived from arithmetic on Phase 12 baseline 140 + 9 new top-level keys. **Verifier helpers must confirm.**
- The TYPE_VARIATIONS count of 56 (47 + 9) is derived from counting current entries at lines 1257-1317 (47 lines of key/value pairs by grep) + 9 new. **Verifier helpers must confirm.**

### Tertiary (LOW confidence — assumptions, training data, or context-implicit)

- Whether GL Compatibility renderer over-renders `bg_color.a` the same way it over-renders `border_color.a` — Pitfall 1, Assumption A1. **Needs Wave 0 smoke test.**
- The exact best font_size for Role Labels (`tokens.body` vs `tokens.label_` vs inherited default_font_size) — Assumption A5. **Needs discuss-phase decision.**

---

## Metadata

**Confidence breakdown:**
- Standard Stack: HIGH — all elements verified in-repo at exact line numbers
- Architecture Patterns: HIGH — all patterns are minimal extensions of documented Phase 4/12 patterns
- Pitfalls: HIGH (1-5) — derived from existing in-repo discipline (PITFALLS 1.2 / 1.7, SC#3 from Phase 12, EDITOR_ONLY_THEME_TYPES filter, unique_id collisions in tscn); MEDIUM on Pitfall 1 (GL Compat bg_color alpha behavior is an assumption needing smoke validation)
- Validation Architecture: HIGH — directly modeled on Phase 12 verifier infrastructure, which has shipped and passed
- Code Examples: HIGH for the 4 examples; the verifier skeleton is structurally complete but each stage will need actual implementation per the plan

**Research date:** 2026-05-11
**Valid until:** 2026-06-10 (~30 days; Godot 4.6 / NeoCade architecture is stable; only NEW phases that grow BINDING_TABLE/TYPE_VARIATIONS would change the row counts)
