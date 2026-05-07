# Phase 05: Core Controls - Buttons, Inputs, Labels, Panels (Desktop) - Research

**Researched:** 2026-05-07 UTC / 2026-05-06 America/Los_Angeles  
**Domain:** Godot 4.6 dynamic `Theme` generation for desktop Control chrome  
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-01:** Formula-driven via `BINDING_TABLE` extension. All 14 existing type variations, plus `Kicker`, get first-class `BINDING_TABLE` entries keyed by variation name. Per-state recipes resolve through `_resolve_recipe()` with new `shape.*` recipe keys. The `.tres` files stay data-only; no `[sub_resource]` blocks for variation styleboxes. [VERIFIED: `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md`]
- **D-02:** `DIRECTION_PRESETS.shape` carries per-direction shape language: primary radius/padding/strategy, ghost strategy, secondary/tab/chip/card/hero radii, surface alpha values, raised lift map, focus offset, and kicker style. Values come from `DESIGN_TOKENS.md` sections 5.1-5.5. `DIRECTION_PRESET_DEFAULT.shape` serves custom-theme fallback. [VERIFIED: `05-CONTEXT.md`; `.planning/DESIGN_TOKENS.md`]
- **D-03:** Recipe schema extensions are `radius`, `padding`, `alpha`, and `raised_intensity` lookups against `shape.*`, implemented through a `_lookup_shape(presets, dotted_path)` helper. [VERIFIED: `05-CONTEXT.md`]
- **D-04:** Variation strategy enums drive multi-property recipes. Primary, ghost, and kicker strategies are closed enums dispatched by helper logic such as `_apply_strategy(...)`, not open-ended ad hoc properties. [VERIFIED: `05-CONTEXT.md`]
- **D-05:** All 5 directions ship in Phase 5 together: Pulse, Slate, Bubble, Daybreak, and Burst. [VERIFIED: `05-CONTEXT.md`]
- **D-06:** No new `.tres` files in Phase 5. The existing 5 direction resources remain the only direction resources. [VERIFIED: `05-CONTEXT.md`]
- **D-07:** Research must resolve Godot 4.6 focus draw-order behavior before the plan decides whether to keep focus-as-overlay only or add explicit combo entries. [VERIFIED: `05-CONTEXT.md`]
- **D-08:** Phase 5 establishes the COV-09 focus-indicator baseline for Phase 5 Controls; final Tab-walk QA remains Phase 10. [VERIFIED: `05-CONTEXT.md`; `.planning/ROADMAP.md`]
- **D-09:** `Kicker` is added as the 15th type variation in Phase 5, mapped to `Label`, with explicit font and font size and direction-aware kicker styling. [VERIFIED: `05-CONTEXT.md`; `.planning/DESIGN_TOKENS.md`]
- **D-10:** `Kicker` counts toward TYPEVAR-06 documentation, finalized in Phase 8. [VERIFIED: `05-CONTEXT.md`; `.planning/ROADMAP.md`]
- **D-11:** Godot 4.6 CLI is a Phase 5 prerequisite. Plan 01 must install or locate Godot 4.6.x, verify headless import, and document the executable path under the Phase 5 helpers directory. [VERIFIED: `05-CONTEXT.md`]
- **D-12:** Phase 5 extends the dual EditorScript + headless verifier pattern with assertions for 15 variations, shape lookups, variation entries, focus strategy, CodeEdit gutter colors, and SpinBox icons. [VERIFIED: `05-CONTEXT.md`; `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/_phase4_verify_headless.gd`]
- **D-13:** Phase 4's additive iteration invariant remains: never call `Theme.clear()` during regeneration. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/neocade_theme.gd`]
- **D-14:** The Phase 4 escape hatch remains: variations not in `BINDING_TABLE` are not overwritten by regeneration. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/neocade_theme.gd`]
- **D-15:** Phase 5 does not change `@export` defaults; class-default custom themes use `DIRECTION_PRESET_DEFAULT.shape`. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/neocade_theme.gd`]
- **D-16:** RichTextLabel variations use the `normal_font` slot; Phase 5 carries forward the Phase 4 BL-02 fix. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/neocade_theme.gd`]
- **D-17:** Inter Variable Roman remains the only bundled font family in Phase 5. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/fonts/`]

### the agent's Discretion

- Pick exact shape recipe key names, as long as they fit the existing recipe style. [VERIFIED: `05-CONTEXT.md`]
- Pick the simplest strategy dispatch implementation that scales to the Phase 5 strategy set. [VERIFIED: `05-CONTEXT.md`]
- Use `Vector2i` or arrays for padding; `Vector2i` is preferred by prior project convention. [VERIFIED: `05-CONTEXT.md`]
- Decide CodeEdit gutter color granularity based on visual completeness of the demo. [VERIFIED: `05-CONTEXT.md`]
- Choose SpinBox arrow icon shape, following the Phase 4 SVG import contract. [VERIFIED: `05-CONTEXT.md`]
- Decide whether combo focus entries are needed only after D-07 research. [VERIFIED: `05-CONTEXT.md`]
- Put Phase 5 helper scripts under `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/`. [VERIFIED: `05-CONTEXT.md`]

### Deferred Ideas (OUT OF SCOPE)

- Tree, ItemList, TabBar, TabContainer, FoldableContainer, range Controls beyond SpinBox, ScrollContainer/SplitContainer/MarginContainer chrome, popup-class theming, MenuBar, ColorPicker, GraphEdit family, mobile tuning, showcase UI, WCAG audit, cross-platform export QA, fresh-install QA, TYPEVAR-06 documentation finalization, light mode, alternate palettes, Inter Italic Variable, CJK font bundling, editor-only theme types, deeper screen-reader QA, sixth-direction strategy expansion, EditorInspectorPlugin variation UX, and binding mechanism redesign are deferred outside Phase 5. [VERIFIED: `05-CONTEXT.md`; `.planning/ROADMAP.md`]
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| COV-02 | Theme the 7 BaseButton-family Controls. | `Button` exposes normal, hover, pressed, disabled, focus, mirrored, and hover_pressed styleboxes; focus is drawn as an overlay by current Godot source, so the plan should populate canonical state slots and verify focus overlay instead of inventing combo slots. [CITED: https://docs.godotengine.org/en/4.6/classes/class_button.html; CITED: https://raw.githubusercontent.com/godotengine/godot/4.6/scene/gui/button.cpp] |
| COV-03 | Theme Label, RichTextLabel, LineEdit, TextEdit, and CodeEdit. | `FEATURES.md` lists the required text slots; CodeEdit syntax highlighting is explicitly out of scope while gutter/chrome slots remain in scope. [VERIFIED: `.planning/research/FEATURES.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_codeedit.html] |
| TYPEVAR-01 | Author 6 button type variations. | `TYPE_VARIATIONS` already registers 6 button variations; Phase 5 should add matching `BINDING_TABLE` rows and direction-aware stylebox recipes. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; `05-CONTEXT.md`] |
| TYPEVAR-02 | Author Label-family variations. | Phase 5 adds `Kicker` to the existing Label variation set. Official `Label` theme properties do not expose letter spacing, so Kicker tracking cannot be a real `Theme` slot unless Godot adds one later. [VERIFIED: `05-CONTEXT.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_label.html] |
| TYPEVAR-03 | Author InfoText RichTextLabel variation. | Current code uses `normal_font` for `InfoText`, matching RichTextLabel's slot model; the planner should also verify `normal_font_size` because the current code still sets `font_size` for `InfoText`. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; CITED: https://docs.godotengine.org/en/4.6/classes/class_richtextlabel.html] |
| TYPEVAR-04 | Author CardPanel and HeroPanel variations. | Context requires panel variations to use direction-specific card/hero radius, panel surface alpha, and panel raised lift values from `DIRECTION_PRESETS.shape`. [VERIFIED: `05-CONTEXT.md`; `.planning/DESIGN_TOKENS.md`] |
| TYPEVAR-05 | Ensure all variations set explicit fonts and font sizes. | Prior project research identifies variation font inheritance as unsafe; Phase 4 already added explicit font wiring, and Phase 5 must add the Kicker pair and test all variation font slots. [VERIFIED: `.planning/research/PITFALLS.md`; `addons/neocade_theme/neocade_theme.gd`] |
| COV-01 | Cumulative all-Control coverage begins here. | Phase 5 covers the keystone desktop Controls but does not close the 35-Control matrix; Phases 6 and 7 complete the remaining desktop Controls. [VERIFIED: `.planning/ROADMAP.md`; `.planning/REQUIREMENTS.md`] |
| COV-07 | Cumulative container coverage begins here. | Phase 5 covers Panel and PanelContainer plus panel variations; layout-only containers remain anti-features or later-phase constants. [VERIFIED: `.planning/ROADMAP.md`; `.planning/research/FEATURES.md`] |
| COV-09 | Focus pattern established here. | Phase 5 must populate focus slots for Phase 5 focusable Controls and prove visibility over hover/pressed/checked states; full Tab-walk QA remains Phase 10. [VERIFIED: `05-CONTEXT.md`; `.planning/ROADMAP.md`] |
| TYPEVAR-06 | Documentation contributor. | Phase 5's 15-variation implementation becomes input for Phase 8 documentation. [VERIFIED: `05-CONTEXT.md`; `.planning/ROADMAP.md`] |
</phase_requirements>

## Project Constraints (from AGENTS.md)

- The project is a Godot 4.6 native UI Theme addon named NeoCade, not VirtuCade; v1 is dark-only and HD-only, not pixel art, cyberpunk, synthwave, neon-noir, or dystopian. [VERIFIED: `AGENTS.md`; `.planning/PROJECT.md`]
- The GSD phase order is mandatory: `/gsd-discuss-phase N` -> `/gsd-plan-review-convergence N --opencode` -> `/gsd-execute-phase N` -> `/gsd-verify-work` -> `/clear`. [VERIFIED: `AGENTS.md`]
- Do not run plain `/gsd-plan-phase` or plain `/gsd-review`; cross-AI plan review through convergence is mandatory. [VERIFIED: `AGENTS.md`; `.planning/config.json`]
- Do not use `/clear` within a phase; clear only after verification before the next phase discussion. [VERIFIED: `AGENTS.md`]
- Read `.planning/STATE.md` before any GSD command and refuse skipped workflow steps. [VERIFIED: `AGENTS.md`; `.planning/STATE.md`]
- Do not use `/gsd-autonomous` on this project; Phases 5-7 need explicit user confirmation at user-decision gates. [VERIFIED: `AGENTS.md`]
- Do not hand-edit `.planning/*` mid-execution; this research artifact is a research-phase output requested by the user, not an execution edit. [VERIFIED: `AGENTS.md`]

## Summary

Phase 5 should be planned as a schema-extension and verification phase, not as manual resource authoring. The production change surface is narrow: extend `DIRECTION_PRESETS`, `TYPE_VARIATIONS`, `BINDING_TABLE`, and `_resolve_recipe()` inside `addons/neocade_theme/neocade_theme.gd`; keep the existing five `.tres` resources data-only and save them only through Godot `ResourceSaver` once the CLI prerequisite is met. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/neocade_theme.gd`; CITED: https://docs.godotengine.org/en/4.6/classes/class_resourcesaver.html]

The D-07 focus question resolves to overlay-only for Godot 4.6 Button-family Controls. Official Button theme slots list a separate `focus` stylebox and do not list `pressed_focus` or `checked_focus`; current 4.6 source draws the current state stylebox first, then draws the focus stylebox over it when the Control has focus. The planner should not add invented combo slots; it should instead verify the focus overlay remains visible over pressed, hover_pressed, checked, and disabled-disabled-focus edge states where applicable. [CITED: https://docs.godotengine.org/en/4.6/classes/class_button.html; CITED: https://raw.githubusercontent.com/godotengine/godot/4.6/scene/gui/button.cpp; CITED: https://raw.githubusercontent.com/godotengine/godot/4.6/scene/gui/base_button.cpp]

The blocking operational fact is that `godot` and `godot4` are not currently available on `PATH`, and no `Godot_v4.6*.exe` was found under `C:\Users\shilo` during the environment audit. Plan 01 must install or locate Godot 4.6.x before implementation plans rely on import, ResourceSaver, screenshots, or headless verification. [VERIFIED: local environment audit]

**Primary recommendation:** Plan Phase 5 in four waves: CLI/install + verifier scaffold, shape/strategy schema, variation/control slot population, then ResourceSaver round-trip plus focus/icon/text verification. [VERIFIED: `05-CONTEXT.md`; `.planning/config.json`]

## Architectural Responsibility Map

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|--------------|----------------|-----------|
| Direction shape language | Addon Theme Resource | Planning tokens | `DIRECTION_PRESETS.shape` owns runtime resolution; token docs are the locked data source. [VERIFIED: `05-CONTEXT.md`; `.planning/DESIGN_TOKENS.md`] |
| BaseButton-family chrome | Addon Theme Resource | Godot Control renderer | `BINDING_TABLE` writes theme slots; Godot's renderer decides state draw order. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; CITED: Godot 4.6 `button.cpp`] |
| Text class chrome | Addon Theme Resource | Godot text Controls | The theme owns fonts/colors/styleboxes; Control classes own editing behavior and syntax parsing. [VERIFIED: `.planning/research/FEATURES.md`; CITED: Godot 4.6 class docs] |
| CodeEdit gutter styling | Addon Theme Resource | CodeEdit widget | Phase 5 owns gutter colors/icons only; syntax highlighting remains outside the theme. [VERIFIED: `.planning/research/FEATURES.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_codeedit.html] |
| Kicker variation | Addon Theme Resource | Showcase/content text | The theme can set Label color/font/size, but official Label theme properties do not expose letter spacing or text transform. [CITED: https://docs.godotengine.org/en/4.6/classes/class_label.html] |
| Resource serialization | Godot CLI tooling | Addon Theme Resource | `ResourceSaver.save()` must write `.tres` files; manual author fallback is retired for Phase 5. [VERIFIED: `05-CONTEXT.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_resourcesaver.html] |
| Structural verification | Godot CLI tooling | Planning helpers | Phase 5 verifiers live under the phase helper directory and inspect the live generated Theme. [VERIFIED: `05-CONTEXT.md`; `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/`] |

## Standard Stack

### Core

| Tool / API | Version | Purpose | Why Standard |
|------------|---------|---------|--------------|
| Godot Engine | 4.6.x; 4.6.2 is the current 4.6 maintenance release checked in this session | Editor import, headless verification, Theme resource serialization | Project targets Godot 4.6 and Phase 5 requires real Godot `ResourceSaver` round-trips. [VERIFIED: `project.godot`; CITED: https://godotengine.org/article/maintenance-release-godot-4-6-2/] |
| GDScript `@tool` + `Theme` | Godot 4.6 API | Dynamic theme generation through `set_stylebox`, `set_color`, `set_constant`, `set_font`, `set_font_size`, `set_icon`, and `set_type_variation` | Existing architecture is one concrete tool script extending `Theme`. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; CITED: https://docs.godotengine.org/en/4.6/classes/class_theme.html] |
| `StyleBoxFlat` | Godot 4.6 API | Buttons, inputs, panels, focus rings, raised/flat chrome | Project rules prohibit textures, gradients, glow, and shader tricks; StyleBoxFlat gives native corners, borders, margins, alpha, and shadow controls. [VERIFIED: `.planning/PROJECT.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_styleboxflat.html] |
| `ResourceSaver` | Godot 4.6 API | Save generated `.tres` resources | Phase 5 explicitly replaces hand-authored fallback with Godot serialization. [VERIFIED: `05-CONTEXT.md`; CITED: https://docs.godotengine.org/en/4.6/classes/class_resourcesaver.html] |
| SVG icon resources | Godot import pipeline | CodeEdit folded icon and SpinBox arrows; disabled/toggled Button-family icon slots may reuse existing SVGs where Godot permits | Existing icon contract is 32x32 monochrome SVG with import sidecar. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/icons/`] |
| Inter Variable Roman | Bundled TTF + FontVariation resources | All Phase 5 typography | Project decision D-17 keeps only Inter Variable Roman bundled. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/fonts/`] |

### Supporting

| Tool | Version | Purpose | When to Use |
|------|---------|---------|-------------|
| Node.js | v25.0.0 | Context7 CLI fallback and local helper execution if needed | Documentation lookup only; not a production dependency. [VERIFIED: local environment audit] |
| npm | 11.11.1 | `ctx7` documentation lookup fallback | Research/docs only; no Phase 5 package install is required. [VERIFIED: local environment audit] |
| Git | 2.45.1.windows.1 | Commit research and later implementation artifacts | Required by GSD workflow. [VERIFIED: local environment audit] |
| Phase 4 verifier helpers | Project-local scripts | Template for Phase 5 EditorScript/headless verifiers | Reuse pattern, not code location. [VERIFIED: `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/`] |

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Formula-driven `BINDING_TABLE` rows | Hand-authored `.tres` sub_resources | Rejected by D-01/D-06; breaks data-only resource contract and Theme Editor regeneration model. [VERIFIED: `05-CONTEXT.md`] |
| One concrete `NeoCadeTheme` script | Per-direction script subclasses | Rejected by the locked Phase 4/PROJECT architecture. [VERIFIED: `.planning/PROJECT.md`; `05-CONTEXT.md`] |
| Focus overlay slot | Invented `pressed_focus` / `checked_focus` slots | Rejected for Button-family planning because official slots/source show `focus` overlay behavior, not combo slots. [CITED: Godot 4.6 Button docs/source] |
| Theme-level Kicker letter spacing | Fake `Label.letter_spacing` constant | Rejected because official Label theme properties do not expose that constant in 4.6. [CITED: https://docs.godotengine.org/en/4.6/classes/class_label.html] |
| Script/shader glow or texture chrome | Native `StyleBoxFlat` | Rejected by project hard constraints and export portability goals. [VERIFIED: `.planning/PROJECT.md`] |

**Installation:**

```powershell
# Required before Phase 5 implementation tasks that import, save, or verify resources.
# Install or locate Godot 4.6.x stable for Windows, then make one of these work:
godot --version
godot --headless --path . --import
```

**Version verification:** `godot` and `godot4` are currently missing from `PATH`; `node` is v25.0.0, `npm` is 11.11.1, and `git` is 2.45.1.windows.1. [VERIFIED: local environment audit]

## Architecture Patterns

### System Architecture Diagram

```text
Approved direction .tres exports
        |
        v
NeoCadeTheme._regenerate_theme()
        |
        +--> resolve platform tokens (desktop branch for Phase 5)
        |
        +--> resolve DIRECTION_PRESETS[base_color].shape
        |       |
        |       +--> approved direction values from DESIGN_TOKENS
        |       +--> DIRECTION_PRESET_DEFAULT.shape for custom colors
        |
        +--> build role table and state colors
        |
        +--> iterate BINDING_TABLE rows
                |
                +--> base Control rows: Button, LineEdit, TextEdit, CodeEdit, Panel, SpinBox
                |
                +--> variation rows: PrimaryButton ... HeroPanel, Kicker
                |
                +--> _resolve_recipe()
                        |
                        +--> shape.* lookup
                        +--> strategy dispatch
                        +--> StyleBoxFlat / Color / Constant / FontSize / Icon output
                                |
                                v
                         Theme slots consumed by Godot Controls
```

This diagram reflects the current single-script dynamic architecture and Phase 5's required schema extensions. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; `05-CONTEXT.md`]

### Recommended Project Structure

```text
addons/neocade_theme/
├── neocade_theme.gd            # only production GDScript edit target
├── *_neocade_theme.tres        # existing five direction resources, ResourceSaver-managed
├── fonts/                      # Inter font resources only
└── icons/                      # existing icons + Phase 5 SVG additions

.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/
├── 05-CONTEXT.md
├── 05-RESEARCH.md
└── helpers/
    ├── godot-cli-path.txt
    ├── _phase5_verify.gd
    ├── _phase5_verify_headless.gd
    └── _phase5_focus_probe.gd
```

The helper path follows Phase 4 path discipline; addon root should still contain exactly one production `.gd` file. [VERIFIED: `05-CONTEXT.md`; `.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/helpers/`]

### Pattern 1: Shape-Aware Recipe Resolution

**What:** Add a single helper that walks `DIRECTION_PRESETS.shape` for any `shape.*` recipe key. [VERIFIED: `05-CONTEXT.md`]  
**When to use:** Use for radius, padding, alpha, raised intensity, focus offset, and strategy lookup. [VERIFIED: `05-CONTEXT.md`]

```gdscript
# Source: Phase 5 D-03 plus Godot Dictionary/GDScript APIs.
func _lookup_shape(presets: Dictionary, dotted_path: String) -> Variant:
	var shape := presets.get("shape", DIRECTION_PRESET_DEFAULT.get("shape", {}))
	var current: Variant = shape
	for key in dotted_path.trim_prefix("shape.").split("."):
		if typeof(current) != TYPE_DICTIONARY or not current.has(key):
			return null
		current = current[key]
	return current
```

The verifier should fail on any null lookup for approved directions; fallback is for custom themes only. [VERIFIED: `05-CONTEXT.md`]

### Pattern 2: Focus Overlay, Not Combo Styleboxes

**What:** Populate `focus` styleboxes and draw them as transparent outer rings over the active state stylebox. [CITED: Godot 4.6 Button docs/source]  
**When to use:** All focusable Phase 5 Controls with a focus slot. [VERIFIED: `05-CONTEXT.md`; `.planning/ROADMAP.md`]

```gdscript
# Source: DESIGN_TOKENS §8.2 and Godot StyleBoxFlat docs.
var focus := StyleBoxFlat.new()
focus.bg_color = Color.TRANSPARENT
focus.border_color = roles.accent
focus.border_width_left = tokens.focus_thickness
focus.border_width_top = tokens.focus_thickness
focus.border_width_right = tokens.focus_thickness
focus.border_width_bottom = tokens.focus_thickness
focus.expand_margin_left = focus_offset
focus.expand_margin_top = focus_offset
focus.expand_margin_right = focus_offset
focus.expand_margin_bottom = focus_offset
focus.shadow_size = -1
```

The plan should include screenshot or pixel-level verification for focus over `pressed` and `hover_pressed` because source semantics do not guarantee the final visual contrast of each direction. [CITED: Godot source; VERIFIED: `.planning/DESIGN_TOKENS.md`]

### Pattern 3: Explicit Font Slots for Variations

**What:** Every variation gets explicit font and font size slots, using the correct base type slot names. [VERIFIED: `.planning/research/PITFALLS.md`]  
**When to use:** All 15 Phase 5 variations, especially `InfoText` and `Kicker`. [VERIFIED: `05-CONTEXT.md`]

```gdscript
# Source: Godot Theme API and current Phase 4 pattern.
set_type_variation("Kicker", "Label")
set_font("font", "Kicker", body_font)
set_font_size("font_size", "Kicker", tokens.kicker)

set_type_variation("InfoText", "RichTextLabel")
set_font("normal_font", "InfoText", body_font)
set_font_size("normal_font_size", "InfoText", tokens.body)
```

Planning note: current `neocade_theme.gd` uses `normal_font` for `InfoText` but still appears to set `font_size`; Phase 5 should fix or explicitly verify `normal_font_size`. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; CITED: https://docs.godotengine.org/en/4.6/classes/class_richtextlabel.html]

### Pattern 4: Icon Slot Completion by Reuse First

**What:** Add only the Phase 5 new SVG assets, and wire icon slots through recipes; reuse existing SVGs for disabled/toggled variants if separate artwork is unnecessary. [VERIFIED: `05-CONTEXT.md`; `.planning/research/FEATURES.md`]  
**When to use:** SpinBox arrows, CodeEdit folded icon, and BaseButton-family icon states such as CheckBox/CheckButton disabled variants. [VERIFIED: `.planning/research/FEATURES.md`]

```gdscript
# Source: existing Phase 4 icon recipe pattern.
"SpinBox": {
	"icons": {
		"up": {"icon": "spinbox_up"},
		"up_disabled": {"icon": "spinbox_up"},
		"down": {"icon": "spinbox_down"},
		"down_disabled": {"icon": "spinbox_down"}
	}
}
```

Official Godot 4.6 SpinBox docs use compact icon slot names such as `up`, `up_disabled`, `down`, and `down_disabled`; the plan should use those names rather than `up_arrow`/`down_arrow`. [CITED: https://docs.godotengine.org/en/4.6/classes/class_spinbox.html]

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Theme type variation registry | Custom variation inheritance system | `Theme.set_type_variation()` | Godot already supports variation-to-base-type mapping. [CITED: https://docs.godotengine.org/en/4.6/classes/class_theme.html] |
| Theme resource serialization | Manual `.tres` string authoring | `ResourceSaver.save()` | Phase 5 explicitly requires Godot round-trip and rejects Phase 4's temporary fallback. [VERIFIED: `05-CONTEXT.md`; CITED: ResourceSaver docs] |
| Button focus combinations | Fake `pressed_focus` / `checked_focus` slots | Official `focus` stylebox overlay | Official docs/source show focus as a separate overlay. [CITED: Button docs/source] |
| Kicker tracking | Undocumented Label constants | Document limitation; use color/font/size in Theme and uppercase content where needed | Official Label theme properties do not expose letter spacing. [CITED: Label docs] |
| CodeEdit syntax theme | Theme-driven syntax highlighter | Gutter/chrome theme slots only | Syntax colors are outside Phase 5 and outside the theme-surface target. [VERIFIED: `.planning/research/FEATURES.md`] |
| Raised/flat rendering | Shader glow, textures, or gradients | `StyleBoxFlat` borders, alpha, margins, and controlled shadow offsets | Project hard constraints prohibit glow/gradients/textures and require portable native UI. [VERIFIED: `.planning/PROJECT.md`] |

**Key insight:** The risky work is not drawing a single nice button; it is preserving the dynamic regeneration contract across five directions, fifteen variations, state overlays, ResourceSaver output, and future mobile branching. [VERIFIED: `05-CONTEXT.md`; `.planning/CROSS-PLATFORM.md`]

## Common Pitfalls

### Pitfall 1: Misplanning Focus as Combo Slots

**What goes wrong:** The plan adds unsupported `pressed_focus` or `checked_focus` theme slots and tests slot presence rather than actual focus visibility. [CITED: Button docs/source]  
**Why it happens:** Some UI toolkits model state combinations as named slots, but Godot Button draws `focus` over the current state stylebox. [CITED: Godot 4.6 `button.cpp`]  
**How to avoid:** Use `focus` overlay only, then verify it visually over pressed, hover_pressed, checked, and disabled variants. [CITED: Button docs/source; VERIFIED: `05-CONTEXT.md`]  
**Warning signs:** BINDING_TABLE rows include `pressed_focus`, `checked_focus`, or `hover_pressed_focus` without official slot verification. [CITED: Button docs]

### Pitfall 2: RichTextLabel Slot Names

**What goes wrong:** `InfoText` gets `font_size` instead of `normal_font_size`, so the explicit size may not apply. [VERIFIED: `addons/neocade_theme/neocade_theme.gd`; CITED: RichTextLabel docs]  
**Why it happens:** Label uses `font`/`font_size`, while RichTextLabel uses `normal_font`/`normal_font_size`. [CITED: https://docs.godotengine.org/en/4.6/classes/class_richtextlabel.html]  
**How to avoid:** Add a Wave 0 assertion for `Theme.has_font_size("normal_font_size", "InfoText")`. [VERIFIED: `05-CONTEXT.md`]  
**Warning signs:** Verifier only checks type variation registration, not actual font slot names. [VERIFIED: `.planning/research/PITFALLS.md`]

### Pitfall 3: Shape Fallback Hiding Typos

**What goes wrong:** A typo such as `shape.raised_lift.primary` silently falls back and makes one direction visually wrong. [VERIFIED: `05-CONTEXT.md`]  
**Why it happens:** Fallbacks are useful for custom colors but dangerous for approved direction data. [VERIFIED: `05-CONTEXT.md`]  
**How to avoid:** For approved directions, the verifier should assert every required shape key resolves non-null before any recipe output is accepted. [VERIFIED: `05-CONTEXT.md`]  
**Warning signs:** `_lookup_shape()` returns defaults for Pulse/Slate/Bubble/Daybreak/Burst without failing. [VERIFIED: `05-CONTEXT.md`]

### Pitfall 4: Planning Before Godot CLI Exists

**What goes wrong:** Implementation tasks assume import, ResourceSaver, and screenshot verification can run, then stall. [VERIFIED: local environment audit]  
**Why it happens:** Phase 4 used a temporary hand-author fallback; Phase 5 explicitly retires it. [VERIFIED: `05-CONTEXT.md`]  
**How to avoid:** Make Plan 01 install/locate Godot 4.6.x, run headless import, and write `helpers/godot-cli-path.txt`. [VERIFIED: `05-CONTEXT.md`]  
**Warning signs:** A plan starts editing `BINDING_TABLE` before Godot availability is resolved. [VERIFIED: local environment audit]

### Pitfall 5: Kicker Overpromising

**What goes wrong:** The plan claims Kicker implements letter spacing through Theme when Godot Label has no such theme property. [CITED: Label docs]  
**Why it happens:** The design token says "tracked", but the Godot theme API does not expose a Label tracking slot. [VERIFIED: `.planning/DESIGN_TOKENS.md`; CITED: Label docs]  
**How to avoid:** Implement what the Theme can own: font, size, color, and optional Burst weight if a FontVariation resource is added; document uppercase/tracking as content/showcase behavior or v1.x limitation. [CITED: Label docs; VERIFIED: `05-CONTEXT.md`]  
**Warning signs:** `set_constant("letter_spacing", "Kicker", 2)` appears without `Theme.get_constant_list("Label")` evidence. [CITED: Label docs]

### Pitfall 6: CodeEdit Scope Creep

**What goes wrong:** Phase 5 tries to style syntax tokens and editor-like semantics. [VERIFIED: `.planning/research/FEATURES.md`]  
**Why it happens:** CodeEdit has many editor features beyond the Phase 5 chrome target. [CITED: CodeEdit docs]  
**How to avoid:** Limit Phase 5 to gutter colors, text/editing chrome, and the folded icon. [VERIFIED: `05-CONTEXT.md`; `.planning/research/FEATURES.md`]  
**Warning signs:** Requirements mention language syntax themes or TextEdit parser behavior. [VERIFIED: `.planning/ROADMAP.md`]

## Code Examples

### Shape Recipe Application

```gdscript
# Source: Phase 5 D-03 recipe schema, adapted to current _resolve_recipe() shape.
if recipe.has("radius"):
	var radius := int(_lookup_shape(presets, recipe["radius"]))
	sb.corner_radius_top_left = radius
	sb.corner_radius_top_right = radius
	sb.corner_radius_bottom_left = radius
	sb.corner_radius_bottom_right = radius

if recipe.has("padding"):
	var pad: Vector2i = _lookup_shape(presets, recipe["padding"])
	sb.content_margin_left = pad.x
	sb.content_margin_right = pad.x
	sb.content_margin_top = pad.y
	sb.content_margin_bottom = pad.y
```

This matches D-03's required radius and padding semantics. [VERIFIED: `05-CONTEXT.md`]

### Direction Strategy Dispatch

```gdscript
# Source: Phase 5 D-04 strategy requirement.
func _apply_primary_strategy(sb: StyleBoxFlat, strategy: StringName, roles: Dictionary, presets: Dictionary) -> void:
	match strategy:
		&"bold-accent-fill":
			sb.bg_color = roles.accent
			sb.border_width_left = 0
		&"quiet-pill":
			sb.bg_color = roles.surface_panel
			_set_border_width_all(sb, 1)
			sb.border_color = roles.accent
		&"pillowy-fully-rounded":
			sb.bg_color = roles.accent
			_set_radius_all(sb, 999)
		&"friendly-generous":
			sb.bg_color = roles.accent
		&"oversized-statement":
			sb.bg_color = roles.accent
```

The exact helper names are discretionary; the planner should require the enum set to be explicit and verifier-covered. [VERIFIED: `05-CONTEXT.md`]

### Verifier Assertions

```gdscript
# Source: Phase 5 D-12 verifier requirements.
assert(theme.get_type_variation_base("Kicker") == "Label")
assert(theme.get_type_variation_list("Label").find("Kicker") != -1)
assert(theme.has_font("font", "Kicker"))
assert(theme.has_font_size("font_size", "Kicker"))
assert(theme.has_font("normal_font", "InfoText"))
assert(theme.has_font_size("normal_font_size", "InfoText"))
assert(theme.has_stylebox("normal", "PrimaryButton"))
assert(theme.has_stylebox("focus", "PrimaryButton"))
assert(theme.has_color("code_folding_color", "CodeEdit"))
```

If the exact Godot assertion method names differ, the plan should use the equivalent `Theme` introspection methods available in 4.6. [CITED: Theme docs]

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Separate desktop/mobile output resources | One dynamic Theme script with platform branch and data-only peer `.tres` files | Phase 4 architecture lock | Phase 5 must not add new direction or mobile resources. [VERIFIED: `.planning/PROJECT.md`; `05-CONTEXT.md`] |
| Hand-authored `.tres` fallback | Godot CLI + `ResourceSaver.save()` | Phase 5 D-11 | Plan 01 is blocking until Godot 4.6.x exists locally. [VERIFIED: `05-CONTEXT.md`; local environment audit] |
| 14 type variations | 15 type variations including `Kicker` | Phase 5 D-09 | Verifier and docs must count 15, not 14. [VERIFIED: `05-CONTEXT.md`] |
| Speculative focus combo entries | Official focus overlay | Phase 5 research | Planner should not author unsupported combo slots. [CITED: Button docs/source] |
| InfoText `font` ambiguity | RichTextLabel `normal_font` slot | Phase 4 BL-02 close | Phase 5 should also verify `normal_font_size`. [VERIFIED: `04-VERIFICATION.md`; `addons/neocade_theme/neocade_theme.gd`] |

**Deprecated/outdated:**

- Any planning text that says "14 variations" for Phase 5 is outdated; Phase 5 adds `Kicker` and must verify 15. [VERIFIED: `05-CONTEXT.md`]
- Any Phase 5 task that uses the Phase 4 hand-author fallback is outdated; Phase 5 requires Godot CLI ResourceSaver round-trip. [VERIFIED: `05-CONTEXT.md`]
- Any requirement to implement CodeEdit syntax highlighting in Phase 5 is out of scope. [VERIFIED: `.planning/research/FEATURES.md`; `05-CONTEXT.md`]

## Assumptions Log

All claims in this research were verified against local project files, official Godot docs/source, Context7 resolution output, or local environment probes. No `[ASSUMED]` claims are used.

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| - | None | - | - |

## Open Questions (RESOLVED)

1. **Godot 4.6.x install path handling.**  
   Resolution: Plan 05-01 does not assume a fixed install path. `Resolve-Godot46.ps1` searches environment variables, PATH commands, and common Windows locations; if needed it installs/locates Godot 4.6.x and writes the verified absolute executable path to `helpers/godot-cli-path.txt` per D-11. All later plans read that file.

2. **Kicker tracking.**  
   Resolution: Phase 5 implements only Theme-owned Kicker behavior: `font`, `font_size`, and direction-aware `font_color`. It does not invent a `Label.letter_spacing` Theme constant. Uppercase/tracking remains content/showcase behavior or a v1.x follow-up unless a source-verified Godot API is found during execution.

3. **InfoText `normal_font_size`.**  
   Resolution: Plan 05-04 fixes InfoText sizing to use RichTextLabel's `normal_font_size` slot alongside the already-correct `normal_font` slot, and the Wave 0 verifier asserts this invariant before later variation chrome is accepted.

4. **Disabled/toggled icon reuse.**  
   Resolution: Phase 5 reuses existing CheckBox/CheckButton SVGs for disabled/toggled variants where Godot exposes tintable icon slots, and verifies official slot coverage. New Phase 5 icon authoring is limited to CodeEdit folded and SpinBox up/down icons.

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|-------------|-----------|---------|----------|
| Godot CLI (`godot`) | Import, ResourceSaver, headless verifier, screenshots | No | - | Install/locate Godot 4.6.x in Plan 01. [VERIFIED: local environment audit] |
| Godot CLI (`godot4`) | Alternate command name | No | - | Same as above. [VERIFIED: local environment audit] |
| Godot 4.6 executable under `C:\Users\shilo` | Manual path fallback | No | - | User-selected install path documented in helper file. [VERIFIED: local environment audit] |
| Node.js | Context7 CLI fallback | Yes | v25.0.0 | Not needed for implementation. [VERIFIED: local environment audit] |
| npm | Context7 CLI fallback | Yes | 11.11.1 | Not needed for implementation. [VERIFIED: local environment audit] |
| Git | GSD commits | Yes | 2.45.1.windows.1 | None needed. [VERIFIED: local environment audit] |

**Missing dependencies with no fallback:**

- Godot 4.6.x CLI is blocking for Phase 5 implementation because D-11 retires hand-authored `.tres` fallback. [VERIFIED: `05-CONTEXT.md`; local environment audit]

**Missing dependencies with fallback:**

- None for implementation. Node/npm are present for research but not needed at execution time. [VERIFIED: local environment audit]

## Validation Architecture

### Test Framework

| Property | Value |
|----------|-------|
| Framework | Godot 4.6 GDScript EditorScript + headless script helpers. [VERIFIED: Phase 4 helper pattern] |
| Config file | No formal test config; project root is `project.godot`. [VERIFIED: repository scan] |
| Quick run command | `godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd` after Plan 01 installs Godot. [VERIFIED: `05-CONTEXT.md`] |
| Full suite command | `godot --headless --path . --import` then the Phase 5 headless verifier and an editor/manual visual pass for focus screenshots. [VERIFIED: `05-CONTEXT.md`] |

### Phase Requirements -> Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|--------------|
| COV-02 | 7 BaseButton-family Controls have state styleboxes/colors/icons and focus overlay. | structural + visual smoke | Phase 5 headless verifier + focus probe | No; Wave 0. [VERIFIED: repository scan] |
| COV-03 | 5 text Controls have required slots; CodeEdit gutter chrome present. | structural | Phase 5 headless verifier | No; Wave 0. [VERIFIED: repository scan] |
| TYPEVAR-01 | 6 button variations have styleboxes and font/color entries. | structural | Phase 5 headless verifier | No; Wave 0. [VERIFIED: repository scan] |
| TYPEVAR-02 | Label variations plus Kicker are registered and styled. | structural | Phase 5 headless verifier | No; Wave 0. [VERIFIED: repository scan] |
| TYPEVAR-03 | InfoText uses RichTextLabel slots and styles. | structural | Phase 5 headless verifier | No; Wave 0. [VERIFIED: repository scan] |
| TYPEVAR-04 | CardPanel and HeroPanel styleboxes resolve by direction. | structural | Phase 5 headless verifier | No; Wave 0. [VERIFIED: repository scan] |
| TYPEVAR-05 | Every variation has explicit font and font_size/normal_font_size where applicable. | structural | Phase 5 headless verifier | No; Wave 0. [VERIFIED: repository scan] |
| COV-09 | Focus ring remains visible over active states. | visual smoke | `_phase5_focus_probe.gd` screenshot/pixel check | No; Wave 0. [VERIFIED: `05-CONTEXT.md`] |

### Sampling Rate

- **Per task commit:** Run the Phase 5 headless verifier once Godot CLI exists. [VERIFIED: `05-CONTEXT.md`]
- **Per wave merge:** Run `godot --headless --path . --import` and the Phase 5 headless verifier. [VERIFIED: `05-CONTEXT.md`]
- **Phase gate:** Full import, headless verifier, and focused visual pass across all 5 directions before `/gsd-verify-work`. [VERIFIED: `05-CONTEXT.md`; `.planning/config.json`]

### Wave 0 Gaps

- [ ] `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt` - records the verified Godot executable path. [VERIFIED: `05-CONTEXT.md`]
- [ ] `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd` - structural assertions for requirements. [VERIFIED: `05-CONTEXT.md`]
- [ ] `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd` - editor-side verifier mirroring Phase 4. [VERIFIED: `05-CONTEXT.md`]
- [ ] `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd` - state-combo focus visibility probe. [VERIFIED: `05-CONTEXT.md`; CITED: Godot source]
- [ ] Godot CLI installation or PATH setup - blocking external dependency. [VERIFIED: local environment audit]

## Sources

### Primary (HIGH confidence)

- Context7 CLI resolve: `/websites/godotengine_en_4_6` for Godot 4.6 docs. Context7 resolved the correct documentation set; exact slot names were cross-checked with official docs/source because one fetched snippet set was not specific enough for Phase 5 slot planning. [VERIFIED: Context7 CLI]
- Godot 4.6 Theme docs: https://docs.godotengine.org/en/4.6/classes/class_theme.html - theme item setters and type variations. [CITED: official docs]
- Godot 4.6 Button docs: https://docs.godotengine.org/en/4.6/classes/class_button.html - Button theme stylebox/state slots. [CITED: official docs]
- Godot 4.6 Button source: https://raw.githubusercontent.com/godotengine/godot/4.6/scene/gui/button.cpp - focus draw order over current state stylebox. [CITED: official source]
- Godot 4.6 BaseButton source: https://raw.githubusercontent.com/godotengine/godot/4.6/scene/gui/base_button.cpp - draw mode semantics used by Button. [CITED: official source]
- Godot 4.6 Label docs: https://docs.godotengine.org/en/4.6/classes/class_label.html - Label theme properties; no letter-spacing theme property found. [CITED: official docs]
- Godot 4.6 RichTextLabel docs: https://docs.godotengine.org/en/4.6/classes/class_richtextlabel.html - RichTextLabel font/font_size slot names. [CITED: official docs]
- Godot 4.6 CodeEdit docs: https://docs.godotengine.org/en/4.6/classes/class_codeedit.html - CodeEdit theme surface. [CITED: official docs]
- Godot 4.6 SpinBox docs: https://docs.godotengine.org/en/4.6/classes/class_spinbox.html - SpinBox theme icons. [CITED: official docs]
- Godot 4.6 ResourceSaver docs: https://docs.godotengine.org/en/4.6/classes/class_resourcesaver.html - resource save API. [CITED: official docs]
- Godot 4.6.2 maintenance release: https://godotengine.org/article/maintenance-release-godot-4-6-2/ - current 4.6 maintenance release checked during research. [CITED: official release]
- Local project files: `AGENTS.md`, `.planning/PROJECT.md`, `.planning/REQUIREMENTS.md`, `.planning/ROADMAP.md`, `.planning/STATE.md`, `.planning/config.json`, `.planning/DESIGN_TOKENS.md`, `05-CONTEXT.md`, `04-VERIFICATION.md`, `addons/neocade_theme/neocade_theme.gd`. [VERIFIED: local files]

### Secondary (MEDIUM confidence)

- `.planning/research/FEATURES.md` - project coverage matrix and anti-features derived from earlier research. [VERIFIED: local research dossier]
- `.planning/research/PITFALLS.md` - prior project pitfall synthesis, cross-checked against current code/docs where Phase 5 depends on it. [VERIFIED: local research dossier]
- `.planning/research/ARCHITECTURE.md` and `.planning/research/CROSS-PLATFORM.md` - token/state/platform rationale, superseded where they conflict with `PROJECT.md`, `DESIGN_TOKENS.md`, or `05-CONTEXT.md`. [VERIFIED: local research dossier]

### Tertiary (LOW confidence)

- None. [VERIFIED: source review]

## Metadata

**Confidence breakdown:**

- Standard stack: HIGH - Godot 4.6 project version, official docs/source, and local environment were checked. [VERIFIED: `project.godot`; official docs/source; local audit]
- Architecture: HIGH - Phase 5 context, Phase 4 implementation, and locked project architecture agree on the formula-driven single-script model. [VERIFIED: `05-CONTEXT.md`; `addons/neocade_theme/neocade_theme.gd`; `.planning/PROJECT.md`]
- Pitfalls: HIGH for focus, CLI, ResourceSaver, and RichTextLabel slots because they were checked against source/docs/current code; MEDIUM for final icon-slot completeness until Godot CLI introspection is available locally. [CITED: official docs/source; VERIFIED: local code]

**Research date:** 2026-05-07 UTC / 2026-05-06 America/Los_Angeles  
**Valid until:** 2026-06-06 for local architecture; re-check Godot docs/releases before implementation if the project upgrades beyond 4.6.x. [VERIFIED: official release; `.planning/PROJECT.md`]  
**Validation:** `workflow.nyquist_validation=true`, so Validation Architecture is included. [VERIFIED: `.planning/config.json`]  
**Security:** `workflow.security_enforcement=false`, so Security Domain is omitted. [VERIFIED: `.planning/config.json`]
