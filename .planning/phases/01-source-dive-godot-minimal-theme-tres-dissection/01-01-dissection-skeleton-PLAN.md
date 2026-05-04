---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 01
type: execute
wave: 0
depends_on: []
files_modified:
  - .planning/research/MINIMAL-THEME-DISSECTION.md
autonomous: true
requirements:
  - RES-01
must_haves:
  truths:
    - "MINIMAL-THEME-DISSECTION.md exists at .planning/research/ with provenance, globals, helpers, color-system, and Editor-API touchpoints sections all present at top of file"
    - "Provenance block names the snapshot file path, file size in bytes, line count, ISO date downloaded, and SHA-256 hash 102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e"
    - "Editor-API Touchpoints callout is explicit and lists every EditorInterface/EditorSettings/EDSCALE reference with line citations into minimal_theme.tres so downstream phases never accidentally port editor-bound code (D-05)"
    - "Editor-API Touchpoints line numbers are runtime-validated against the live file (Task 3) — not just structurally grep-checked. Verification stamp appended to DISSECTION.md."
    - "Globals 'scale' row carries an explicit FORBIDDEN-in-NeoCade callout per D-05 so no downstream reader mistakes EDSCALE-derived values for NeoCade-usable constants (per cross-AI review 2026-05-04)"
    - "Globals/helpers/color-system documentation is comprehensive enough that per-class enumeration plans (02, 03) can reference by name (e.g. color_surface_base, color_font_normal, _set_margin) without re-defining"
  artifacts:
    - .planning/research/MINIMAL-THEME-DISSECTION.md (created — file exists with skeleton sections + line-citation verification stamp)
  key_links:
    - "Provenance hash matches `sha256sum /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres` output"
    - "Globals section line citations resolve to actual lines in minimal_theme.tres (verifiable via grep AND `sed -n 'Np'` runtime spot-check per Task 3)"
    - "Editor-API Touchpoints section is greppable as 'Editor-API Touchpoints' (used by VALIDATION.md task 01-01-03)"
    - "Line-citation runtime validation stamp is greppable as 'Line-citation runtime validation' (Task 3 deliverable)"
---

<objective>
Create `.planning/research/MINIMAL-THEME-DISSECTION.md` with the document skeleton: front-matter (date authored, source provenance), Globals (the 9 editor settings reads + derived globals), Helpers (the three helper functions: `_get_base_color`, `_set_margin`, `_set_border`), Color System (named font/icon/state colors, the 7-stop tonal surface ramp), and an explicit "Editor-API Touchpoints (Forbidden in NeoCade per D-05)" callout. This is the shared vocabulary every per-class enumeration in plans 02-03 will reference.

Purpose: The dissection target's `_init()` runs once and derives ~30 named values that all 377 `set_*` calls reference. Documenting them up front (Wave 0) keeps the per-class tables compact and lets downstream plans cite by name rather than expanding each formula inline. It also discharges D-05 (Editor-API touchpoint flagging) at the highest visible point of the doc.

Output: `MINIMAL-THEME-DISSECTION.md` with sections (in order):
  1. Header / provenance / glossary
  2. Editor-API Touchpoints (Forbidden in NeoCade) — D-05 callout
  3. Globals (editor-settings reads, derived margins, dark_theme flag, surface ramp formulas, named font/icon/state colors)
  4. Helper Functions (full bodies for `_get_base_color`, `_set_margin`, `_set_border` with line citations)
  5. (placeholder) "## Per-Control Enumeration" heading where Plan 02 will append
  6. (placeholder) "## Engine-Default Cross-Reference and Pitfall Confirmations" heading where Plan 03 will append
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-RESEARCH.md
@.planning/research/SOURCES.md

<interfaces>
<!-- Key reference points the executor needs. Extracted from minimal_theme.tres. -->
<!-- All line numbers are into /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres (1118 lines, MIT). -->

GDScript header (lines 1-12):
```
[gd_resource type="Theme" load_steps=2 format=3 uid="uid://bcibt73qths3g"]
[sub_resource type="GDScript" id="GDScript_hhmc0"]
script/source = "@tool
extends Theme

var base_color : Color
var contrast : float
var scale : float
var dark_theme : bool

func _init() -> void:
```

`_init()` editor-settings reads (lines 14-44) — D-05 forbidden in NeoCade:
- Line 15: `var settings : EditorSettings = EditorInterface.get_editor_settings()`
- Line 18: `base_color = settings.get_setting('interface/theme/base_color')`
- Line 20: `contrast = settings.get_setting('interface/theme/contrast')`
- Line 21: `scale = EditorInterface.get_editor_scale()`
- Line 24: `accent_color = settings.get_setting('interface/theme/accent_color')`
- Line 26: `base_spacing = settings.get_setting('interface/theme/base_spacing')`
- Line 28: `extra_spacing = settings.get_setting('interface/theme/additional_spacing')`
- Line 30: `corner_radius = settings.get_setting('interface/theme/corner_radius')`
- Line 32: `icon_and_font_color = settings.get_setting('interface/theme/icon_and_font_color')`
- Line 34: `relationship_line_opacity = settings.get_setting('interface/theme/relationship_line_opacity')`
- Line 36: `draw_extra_borders = settings.get_setting('interface/theme/draw_extra_borders')`
- Lines 38-44: touch-area setting (engine-version-conditional read of `enable_touch_optimizations` or `increase_scrollbar_touch_area`)

Derived globals (lines 46-93):
- Line 50: `var base_margin : float = base_spacing`
- Line 51: `var increased_margin : float = base_spacing + extra_spacing * 0.75`
- Line 52: `var popup_margin : float = maxf(base_margin * 2.4, 4.0 * scale)`
- Line 56: `dark_theme = base_color.get_luminance() < 0.5`
- Line 62: `var color_mono : Color = Color.WHITE if dark_theme else Color.BLACK`
- Line 63: `var color_mono_inv : Color = Color.BLACK if dark_theme else Color.WHITE`
- Line 64: `var color_mono_font : Color = Color.WHITE if dark_theme_icon_and_font else Color.BLACK`
- Lines 72-78: 7-stop surface ramp:
  - `color_surface_lowest = _get_base_color(-1.3 if dark_theme else -2.2, 0.9)`
  - `color_surface_lower = _get_base_color(-0.95 if dark_theme else -1.8, 0.9)`
  - `color_surface_low = _get_base_color(-0.6 if dark_theme else -0.9)`
  - `color_surface_base = _get_base_color(-0.2)`
  - `color_surface_high = _get_base_color(0.2, 0.8)`
  - `color_surface_higher = _get_base_color(0.35, 0.8)`
  - `color_surface_highest = _get_base_color(0.55, 0.6)`
- Lines 80-93: font/icon color definitions
  - `color_font_normal = color_mono_font * Color(1, 1, 1, 0.7)` (line 81)
  - `color_font_secondary = color_mono_font * Color(1, 1, 1, 0.45)` (line 82)
  - `color_font_highlighted = color_mono_font` (line 83)
  - `color_font_dimmed = color_mono_font * Color(1, 1, 1, 0.35 if dark_theme_icon_and_font else 0.5)` (line 84)
  - `color_icon_normal = Color(1, 1, 1, 0.7 if dark_theme_icon_and_font else 0.95)` (line 87)
  - `color_icon_secondary = Color(1, 1, 1, 0.45 if dark_theme_icon_and_font else 0.6)` (line 88)
  - `color_icon_focus = Color(1, 1, 1)` (line 89)
  - `color_icon_hover = Color(1, 1, 1)` (line 90)

Helper functions:
- `func _get_base_color(brightness_offset: float = 0, saturation_multiplier: float = 1) -> Color` (line 1096)
- `func _set_margin(sb: StyleBox, left: float, top: float, right: float = left, bottom: float = top) -> void` (line 1104)
- `func _set_border(sb: StyleBoxFlat, color: Color, width: float = 1, blend: bool = false) -> void` (line 1111)

Body extraction commands (executor uses these to read the actual implementations):
```bash
sed -n '1096,1103p' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
sed -n '1104,1110p' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
sed -n '1111,1118p' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
```

README.md recommended editor settings (used to instantiate "snapshot @ default settings" verification values throughout):
- `base_color = #272727`
- `accent_color = #569eff`
- `contrast = 0.3-0.35` (use 0.325 midpoint for snapshot)
- `icon_saturation = 2`
- `corner_radius = 4-5` (use 4 for snapshot)
- Main font: Inter

Provenance values (already computed; copy verbatim into doc):
- Snapshot path: `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres`
- File size: `48,442 bytes`
- Line count: `1118`
- ISO date downloaded: `2026-05-04` (per ZIP timestamp `May 4 09:19`)
- SHA-256: `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`
- Source repo: https://github.com/passivestar/godot-minimal-theme (MIT)
- Note: ZIP download (no commit SHA available); hash is the reproducibility anchor.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Verify provenance values match the live file (regenerate the SHA, size, line count from the snapshot in case the user re-downloaded)</name>
  <read_first>
    - C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres (existence + first 5 lines for resource header verification)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-RESEARCH.md (Sources section: HIGH-confidence claim that file is 1118 lines, 48442 bytes, SHA-256 102fd6b3...a73f2e)
  </read_first>
  <files>(no files written this task — verification step)</files>
  <action>
    Run all three commands; capture outputs. They MUST agree with the values embedded in the plan's `<interfaces>` block. If any disagrees (re-download, file changed), STOP and surface the discrepancy — the dissection's provenance must be regenerated against the live snapshot, not stale plan values.

    Commands (all paths use Git-Bash forward-slash style):
    ```bash
    sha256sum /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    wc -l    /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    wc -c    /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    head -1  /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    ```

    Expected outputs (must all match):
    - SHA-256: `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`
    - Line count: `1118`
    - Byte count: `48442`
    - First line: `[gd_resource type="Theme" load_steps=2 format=3 uid="uid://bcibt73qths3g"]`

    If discrepancy: regenerate the values, update the plan's `<interfaces>` block AND update task 2's action body before continuing.
  </action>
  <verify>
    Three command outputs match the four expected values exactly.
  </verify>
  <done>
    All four checks pass. Recorded outputs are byte-identical to the values cited in `<interfaces>` and used in task 2's provenance section. (No file writes in this task.)
  </done>
  <acceptance_criteria>
    - `sha256sum` output line matches `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e */c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres`
    - `wc -l` output begins with `1118 `
    - `wc -c` output begins with `48442 `
    - `head -1` output is exactly `[gd_resource type="Theme" load_steps=2 format=3 uid="uid://bcibt73qths3g"]`
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 2: Create MINIMAL-THEME-DISSECTION.md with header, provenance, glossary, and the section skeleton (placeholder headings for plans 02 and 03)</name>
  <read_first>
    - .planning/research/SOURCES.md (Section 1 — for tone, header conventions, and "What was read" provenance style; NeoCade research-doc convention)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-RESEARCH.md (Glossary table — copy verbatim)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md (D-03 provenance requirements; D-05 editor-API forbidden constraint)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md</files>
  <action>
    Use the Write tool to create `.planning/research/MINIMAL-THEME-DISSECTION.md` with EXACTLY this content (preserve every heading, table, and value verbatim — these are the grep targets for VALIDATION.md tasks 01-01-01..03):

    ```markdown
    # godot-minimal-theme — `.tres` Dissection

    **Authored:** 2026-05-04
    **Status:** Living research artifact — appended to by Phase 1 plans 01-03.
    **Author:** NeoCade Theme research / Phase 1 source-dive.

    ## Provenance

    | Field | Value |
    |-------|-------|
    | Snapshot path | `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres` |
    | File size | 48,442 bytes |
    | Line count | 1118 |
    | First line | `[gd_resource type="Theme" load_steps=2 format=3 uid="uid://bcibt73qths3g"]` |
    | ISO date downloaded | 2026-05-04 |
    | SHA-256 | `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e` |
    | Source repo | https://github.com/passivestar/godot-minimal-theme |
    | License | MIT |
    | Note | Acquired as a ZIP download (per `ls -la` `.gitattributes` only — no `.git` directory). No commit SHA available; the SHA-256 above is the reproducibility anchor for any future re-extraction. |

    ## Methodology

    Dissection methodology is **symbolic formula extraction** (per CONTEXT.md D-04, RESEARCH.md Pattern 1): every `set_*` call is captured as the *expression* the upstream GDScript writes — not as a single evaluated numeric snapshot — so the convention generalizes across editor settings combinations. Each per-Control entry is paired with **one concrete instantiation** at upstream's documented default editor settings (per `README.md`: `base_color #272727`, `accent_color #569eff`, `contrast 0.325`, `corner_radius 4`, `icon_saturation 2`, Inter main font) for verification. The formula is the convention; the snapshot is the verification anchor.

    All line citations resolve into the file at the snapshot path above (1118 lines). Lines numbers in citations refer to that file. Cross-references into `default_theme.cpp` and `theme_db.cpp` are appended in the per-Control omission cross-reference (Plan 03).

    Theme-slot vocabulary used throughout this document (per RESEARCH.md Glossary):

    | Slot kind | What it is | Example |
    |-----------|-----------|---------|
    | `stylebox` | A `StyleBox` resource (typically `StyleBoxFlat`) with `bg_color`, `corner_radius_*`, `border_*`, `content_margin_*`, `expand_margin_*`, etc. | `Button.normal` |
    | `color` | A `Color` (RGBA) | `Button.font_color` |
    | `font` | A `Font` resource | `Button.font` |
    | `font_size` | An `int` (typically pixels) | `Button.font_size` |
    | `icon` | A `Texture2D` (typically SVG via SVGTexture in Godot 4) | `Button.icon` |
    | `constant` | An `int` (margins, separations, line widths) | `Button.h_separation` |

    Per-state suffixes used by the dissected upstream theme (catalogued exhaustively per CONTEXT.md D-11): `normal`, `hover`, `pressed`, `focus`, `disabled`, `hover_pressed`, `pressed_focus`, `checked`, `unchecked`, `radio_checked`, `radio_unchecked`, `radio_checked_disabled`, `radio_unchecked_disabled`, `cursor`, `cursor_unfocused`, `selected`, `selected_focus`, `even`, `odd`, `tab_selected`, `tab_unselected`, `tab_disabled`, `tab_focus`, `popup_panel`, plus per-Control idiosyncrasies as found.

    ## Editor-API Touchpoints (Forbidden in NeoCade per D-05)

    > **Critical reuse constraint.** Upstream's GDScript reads runtime state from `EditorInterface` and `EditorSettings`. NeoCade is runtime-first (must work in shipped games on all 6 export targets), so these APIs are forbidden in any NeoCade source. Every touchpoint is enumerated below; downstream phases (Phase 4 generator, Phase 6 onward) MUST NOT replicate these patterns. The touchpoints are research material, not blueprint.

    | Line | Construct | Purpose in upstream | NeoCade substitute (Phase 4) |
    |------|-----------|---------------------|------------------------------|
    | 15 | `EditorInterface.get_editor_settings()` | Acquire EditorSettings handle | `@tool` token-generator script reads from a hand-authored TokenSet resource (no editor handle); design tokens come from Phase 3 mockup-approved values. |
    | 18 | `settings.get_setting('interface/theme/base_color')` | Editor base color | NeoCade has its own palette per ARCHITECTURE.md (3 candidate palettes — Phase 3 mockup-gate selects). |
    | 20 | `settings.get_setting('interface/theme/contrast')` | Editor contrast slider | NeoCade contrast is a fixed design choice from ARCHITECTURE.md state-layer model. |
    | 21 | `EditorInterface.get_editor_scale()` | EDSCALE multiplier (Pitfall 6.1 — DO NOT lift values that depend on this) | NeoCade is HD-only (PROJECT.md), no edscale; mobile variant has its own pixel constants from MOBILE-DESIGN-SPEC.md (Phase 8). |
    | 24 | `settings.get_setting('interface/theme/accent_color')` | Editor accent | NeoCade has 8 accent hues with semantic role aliases (FEATURES.md DF-4); palette is Phase 3 territory. |
    | 26 | `settings.get_setting('interface/theme/base_spacing')` | Editor spacing | NeoCade uses fixed `base_margin` token from Phase 3 design system. |
    | 28 | `settings.get_setting('interface/theme/additional_spacing')` | Editor extra spacing | Same as above; not user-configurable in NeoCade. |
    | 30 | `settings.get_setting('interface/theme/corner_radius')` | Corner radius slider | NeoCade has fixed corner radius per stylebox role (4 default, 8 popups, 12 dialogs per STACK.md). |
    | 32 | `settings.get_setting('interface/theme/icon_and_font_color')` | Light/dark icon mode | NeoCade is dark-only in v1 (light deferred to v2 per STATE.md). |
    | 34 | `settings.get_setting('interface/theme/relationship_line_opacity')` | Inspector relationship lines | Editor-only; NeoCade does not theme inspector. |
    | 36 | `settings.get_setting('interface/theme/draw_extra_borders')` | Border drawing toggle | NeoCade borders are deterministic per stylebox role (no toggle). |
    | 38-44 | Engine-version-conditional touch-optimization read | Adjusts `increase_scrollbar_touch_area` for touchscreens | NeoCade has separate `neocade_mobile_theme.tres` (Phase 8-9) with its own touch sizing; no runtime toggle. |
    | (in helper) | `EDSCALE`-derived values throughout via `scale` variable | Per-resolution scaling | NeoCade uses Godot's `content_scale_factor` + Theme defaults; no EDSCALE multiplier in NeoCade values (Pitfall 6.1 hard rule). |

    **Pitfall reinforcement (per RESEARCH.md Anti-Patterns):**
    - DO NOT lift any numeric value from upstream that is multiplied by `scale` or `edscale` — those values are *editor-relative*, not *user-relative*. NeoCade's Phase 4 token generator computes from NeoCade's own design system.
    - DO NOT replicate the `_init()`-from-EditorSettings pattern — NeoCade's generator is `@tool`-time only (Phase 4) and writes static `.tres` outputs that have no runtime editor dependency.

    ## Globals

    > Note: this section catalogues the variables the upstream `_init()` derives from the editor-settings reads (above). All 377 `set_*` calls in the file reference these by name. Per-class enumerations in subsequent sections cite by name; this section is the dictionary.

    ### Margins / spacing

    | Name | Definition | Lines | Snapshot @ defaults |
    |------|------------|-------|---------------------|
    | `base_spacing` | `maxi(settings.get_setting('interface/theme/base_spacing'), 2)` (clamped to ≥ 2 per upstream comment) | 26, 48 | 4 (Godot editor default) |
    | `base_margin` | `float(base_spacing)` | 50 | 4.0 |
    | `extra_spacing` | `settings.get_setting('interface/theme/additional_spacing')` | 28 | 0 (Godot default) |
    | `increased_margin` | `base_spacing + extra_spacing * 0.75` | 51 | 4.0 |
    | `popup_margin` | `maxf(base_margin * 2.4, 4.0 * scale)` | 52 | 9.6 (or 4.0×scale, whichever bigger) — **NeoCade note:** the `4.0 * scale` term is EDSCALE-derived and forbidden in NeoCade per D-05; NeoCade's `popup_margin` uses `base_margin * 2.4` only (Phase 4 token rule). |
    | `scale` | `EditorInterface.get_editor_scale()` ⚠ **EDSCALE-derived; FORBIDDEN in NeoCade per D-05.** Any formula in this Globals table or a per-class table that multiplies by `scale` MUST be flagged in Plan 02 / 03 / 04 outputs and stripped before NeoCade-token use (Phase 4). | 21 | 1.0 (default 100% editor scale) |

    ### Theme-mode flags

    | Name | Definition | Lines |
    |------|------------|-------|
    | `dark_theme` | `base_color.get_luminance() < 0.5` | 56 |
    | `dark_theme_icon_and_font` | `dark_theme` initially; overridden by `icon_and_font_color` setting if non-AUTO (line 60) | 57, 60 |

    ### Mono colors (light/dark theme switches)

    | Name | Definition | Lines |
    |------|------------|-------|
    | `color_mono` | `Color.WHITE if dark_theme else Color.BLACK` | 62 |
    | `color_mono_inv` | `Color.BLACK if dark_theme else Color.WHITE` | 63 |
    | `color_mono_font` | `Color.WHITE if dark_theme_icon_and_font else Color.BLACK` | 64 |

    ### 7-stop tonal surface ramp

    | Name | Formula | Lines |
    |------|---------|-------|
    | `color_surface_lowest` | `_get_base_color(-1.3 if dark_theme else -2.2, 0.9)` | 72 |
    | `color_surface_lower` | `_get_base_color(-0.95 if dark_theme else -1.8, 0.9)` | 73 |
    | `color_surface_low` | `_get_base_color(-0.6 if dark_theme else -0.9)` | 74 |
    | `color_surface_base` | `_get_base_color(-0.2)` | 75 |
    | `color_surface_high` | `_get_base_color(0.2, 0.8)` | 76 |
    | `color_surface_higher` | `_get_base_color(0.35, 0.8)` | 77 |
    | `color_surface_highest` | `_get_base_color(0.55, 0.6)` | 78 |

    > NeoCade contrast: ARCHITECTURE.md uses 5 stops (M3 ramp). Upstream uses 7. Coverage delta will note this divergence.

    ### Font / icon named colors

    | Name | Formula | Lines |
    |------|---------|-------|
    | `color_font_normal` | `color_mono_font * Color(1, 1, 1, 0.7)` | 81 |
    | `color_font_secondary` | `color_mono_font * Color(1, 1, 1, 0.45)` | 82 |
    | `color_font_highlighted` | `color_mono_font` (full alpha) | 83 |
    | `color_font_dimmed` | `color_mono_font * Color(1, 1, 1, 0.35 if dark_theme_icon_and_font else 0.5)` | 84 |
    | `color_icon_normal` | `Color(1, 1, 1, 0.7 if dark_theme_icon_and_font else 0.95)` | 87 |
    | `color_icon_secondary` | `Color(1, 1, 1, 0.45 if dark_theme_icon_and_font else 0.6)` | 88 |
    | `color_icon_focus` | `Color(1, 1, 1)` | 89 |
    | `color_icon_hover` | `Color(1, 1, 1)` | 90 |

    ## Helper Functions

    > Three helper functions appear at the BOTTOM of the script (lines 1096-1118) and are called dozens of times throughout the per-class section. Each is documented here with full body + line citations. Per-class enumerations call these by name.

    ### `_get_base_color(brightness_offset: float = 0, saturation_multiplier: float = 1) -> Color`

    **Lines:** 1096-1103.

    Returns a color derived from `base_color` (the editor's base color setting), shifted in HSV space by `brightness_offset` (scaled by `contrast`) and modulated in saturation by `saturation_multiplier`. **This is the function that powers the 7-stop tonal ramp.** The brightness offset is signed: negative offsets darken (used for surface-lowest/lower/low/base), positive offsets lighten (used for surface-high/higher/highest).

    **Body (executor extracts at runtime via `sed -n '1096,1103p' minimal_theme.tres` and pastes verbatim into this slot):**
    ```gdscript
    func _get_base_color(brightness_offset: float = 0, saturation_multiplier: float = 1) -> Color:
        # ... actual body, paste verbatim from sed output ...
    ```

    **Conceptual model:** result = `base_color` shifted in HSV by `brightness_offset * contrast` (with `dark_theme` flipping sign), then multiplied in saturation by `saturation_multiplier`. The `contrast` editor setting (line 20) is what makes the ramp tunable.

    ### `_set_margin(sb: StyleBox, left: float, top: float, right: float = left, bottom: float = top) -> void`

    **Lines:** 1104-1110.

    Convenience wrapper around `StyleBox.set_content_margin_*` calls. Lets per-class code write `_set_margin(sb, 4, 4)` instead of four individual margin assignments.

    **Body:** (executor extracts at runtime via `sed -n '1104,1110p'` and pastes verbatim into this slot.)

    ### `_set_border(sb: StyleBoxFlat, color: Color, width: float = 1, blend: bool = false) -> void`

    **Lines:** 1111-1118.

    Convenience wrapper for `StyleBoxFlat.border_color`, `border_width_*`, and the `draw_extra_borders` toggle. Used heavily for focus rings and split-container divider lines.

    **Body:** (executor extracts at runtime via `sed -n '1111,1118p'` and pastes verbatim into this slot.)

    ## Per-Control Enumeration

    > This section is appended by **Plan 02 (per-class enumeration)**. Heading reserved here for ordering only.

    ## Engine-Default Cross-Reference and Pitfall Confirmations

    > This section is appended by **Plan 03 (default_theme.cpp omission cross-reference + Pitfall 1.1 / 1.7 confirmation/refutation)**. Heading reserved here for ordering only.
    ```

    Then immediately extract the actual bodies of the three helper functions and paste them into the placeholders above:
    ```bash
    sed -n '1096,1103p' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    sed -n '1104,1110p' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    sed -n '1111,1118p' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    ```
    Use Edit to replace each "(executor extracts at runtime...)" placeholder with the verbatim sed output (wrapped in a ` ```gdscript ... ``` ` block).
  </action>
  <verify>
    File created. All grep checks pass:
    ```bash
    test -f .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "SHA-256: 102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e" .planning/research/MINIMAL-THEME-DISSECTION.md   # also accepts table-cell form
    grep -qE "Editor[- ]API Touchpoints" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "EditorInterface.get_editor_settings" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "EditorInterface.get_editor_scale" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -qE "## (Globals|Helper Functions)" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "_get_base_color" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "_set_margin" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "_set_border" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "color_surface_base" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "color_font_normal" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "## Per-Control Enumeration" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "## Engine-Default Cross-Reference and Pitfall Confirmations" .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    All 12 grep checks pass. Helper-function bodies (lines 1096-1118 from minimal_theme.tres) are pasted verbatim into the doc — not left as `(executor extracts at runtime...)` placeholders.
  </done>
  <acceptance_criteria>
    - File `.planning/research/MINIMAL-THEME-DISSECTION.md` exists
    - File contains the literal SHA-256 string `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`
    - File contains a heading or section name matching `Editor[- ]API Touchpoints`
    - File contains the strings `EditorInterface.get_editor_settings` and `EditorInterface.get_editor_scale`
    - File contains `## Globals` and `## Helper Functions` sections
    - File contains the names `_get_base_color`, `_set_margin`, `_set_border`, `color_surface_base`, `color_font_normal` (greppable as identifiers)
    - File contains the placeholder headings `## Per-Control Enumeration` and `## Engine-Default Cross-Reference and Pitfall Confirmations` so plans 02-03 can append
    - Helper-function code blocks contain actual GDScript bodies (no placeholder text like "executor extracts at runtime")
    - Globals "Margins / spacing" table contains the literal string `FORBIDDEN in NeoCade per D-05` on the `scale` row (D-05 callout, per cross-AI review)
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 3: Runtime line-citation grep validation — verify the Editor-API Touchpoints table's hardcoded line numbers match the live file (per cross-AI review HIGH #2)</name>
  <read_first>
    - .planning/research/MINIMAL-THEME-DISSECTION.md (just-written file from Task 2 — contains the table to be validated)
    - C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres (live file — lines being cited)
  </read_first>
  <files>(no files written — verification step; if mismatches found, may rewrite the table cells in MINIMAL-THEME-DISSECTION.md)</files>
  <action>
    The Editor-API Touchpoints table in Task 2's document body hardcodes absolute line numbers (e.g., line 15 = `EditorInterface.get_editor_settings()`, line 21 = `EditorInterface.get_editor_scale()`, line 18 = `base_color`, etc.). Task 1's SHA-256 verification proves file integrity but does NOT prove that these specific line numbers are correct — the string `EditorInterface.get_editor_scale` could appear anywhere in the file and still pass Task 2's structural greps.

    This task runtime-validates each cited line number against `sed -n 'Np'` output, catching any drift before downstream plans build on incorrect citations.

    For EACH of the following 12 cited lines (covering all rows of the Editor-API Touchpoints table where a specific line number is given), run `sed -n 'Np' /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres` and verify the expected substring appears on that line:

    | Cited line | Expected substring on that line |
    |------------|---------------------------------|
    | 15 | `EditorInterface.get_editor_settings()` |
    | 18 | `interface/theme/base_color` |
    | 20 | `interface/theme/contrast` |
    | 21 | `EditorInterface.get_editor_scale()` |
    | 24 | `interface/theme/accent_color` |
    | 26 | `interface/theme/base_spacing` |
    | 28 | `interface/theme/additional_spacing` |
    | 30 | `interface/theme/corner_radius` |
    | 32 | `interface/theme/icon_and_font_color` |
    | 34 | `interface/theme/relationship_line_opacity` |
    | 36 | `interface/theme/draw_extra_borders` |
    | 56 | `dark_theme` AND `get_luminance` (both must appear) |

    Run as a single shell block:
    ```bash
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    fail=0
    check() { local n=$1 needle=$2; sed -n "${n}p" "$src" | grep -qF -- "$needle" || { echo "MISMATCH line $n: expected '$needle'"; fail=$((fail+1)); }; }
    check 15 "EditorInterface.get_editor_settings()"
    check 18 "interface/theme/base_color"
    check 20 "interface/theme/contrast"
    check 21 "EditorInterface.get_editor_scale()"
    check 24 "interface/theme/accent_color"
    check 26 "interface/theme/base_spacing"
    check 28 "interface/theme/additional_spacing"
    check 30 "interface/theme/corner_radius"
    check 32 "interface/theme/icon_and_font_color"
    check 34 "interface/theme/relationship_line_opacity"
    check 36 "interface/theme/draw_extra_borders"
    sed -n "56p" "$src" | grep -q "dark_theme" && sed -n "56p" "$src" | grep -q "get_luminance" || { echo "MISMATCH line 56: expected 'dark_theme' AND 'get_luminance'"; fail=$((fail+1)); }
    test "$fail" -eq 0 || { echo "Line citation validation FAILED ($fail mismatches)"; exit 1; }
    echo "All 12 line citations verified."
    ```

    **If ALL 12 checks pass:** Append a verification stamp to MINIMAL-THEME-DISSECTION.md immediately under the Editor-API Touchpoints table (use Edit tool):
    ```markdown
    > **Line-citation runtime validation (per cross-AI review 2026-05-04):** All 12 cited lines (15, 18, 20, 21, 24, 26, 28, 30, 32, 34, 36, 56) verified by `sed -n 'Np'` against the live snapshot. Stamp date: 2026-05-04.
    ```

    **If ANY check fails:** Halt the plan and report. The executor MUST then either:
    - (A) Re-grep each forbidden-API string to find its actual current line number and rewrite the table cells in MINIMAL-THEME-DISSECTION.md before continuing, or
    - (B) If the file SHA also no longer matches Task 1's expected hash, regenerate provenance (re-run Task 1) and re-author the table from the live file's line numbers.

    Do NOT proceed to plans 02/03/04/05 with mismatched citations — downstream plans cite into this table and a wrong line number propagates.
  </action>
  <verify>
    ```bash
    # Line-citation validation block (re-run for verify)
    src=/c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
    sed -n "15p" "$src" | grep -qF "EditorInterface.get_editor_settings()"
    sed -n "21p" "$src" | grep -qF "EditorInterface.get_editor_scale()"
    sed -n "18p" "$src" | grep -qF "interface/theme/base_color"
    sed -n "30p" "$src" | grep -qF "interface/theme/corner_radius"
    sed -n "56p" "$src" | grep -qF "dark_theme"
    sed -n "56p" "$src" | grep -qF "get_luminance"
    # Verification stamp recorded in DISSECTION.md
    grep -q "Line-citation runtime validation" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "All 12 cited lines" .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    All 12 line-number citations verified against live snapshot. Verification stamp appended to MINIMAL-THEME-DISSECTION.md. (No table cells rewritten — they were already correct against this snapshot.) If any mismatches were found and corrected, the corrected table now matches the live file.
  </done>
  <acceptance_criteria>
    - All 6 spot-check `sed`+`grep` commands in the verify block exit 0
    - File contains the literal string `Line-citation runtime validation`
    - File contains the literal string `All 12 cited lines`
  </acceptance_criteria>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| upstream `minimal_theme.tres` (MIT) → NeoCade dissection doc | Untrusted in the licensing sense: copying values verbatim creates derived-work claim ambiguity. Boundary is honored by symbolic formula extraction (D-04 + Pitfall 6.1). |
| editor-API surface (`EditorSettings`, `EditorInterface`, `EDSCALE`) → NeoCade runtime | Forbidden boundary per D-05. Boundary is honored by explicit "Editor-API Touchpoints" callout flagging every touchpoint with line citations so downstream phases never accidentally port editor-bound code. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-1-01 | Tampering | Editor-API touchpoints accidentally inherited by NeoCade source | mitigate | The `## Editor-API Touchpoints (Forbidden in NeoCade per D-05)` section explicitly enumerates all 13 touchpoints with NeoCade substitutes; later phases reading this dissection must consult that section first. Acceptance criteria require the section to exist by greppable name. |
| T-1-02 | Repudiation | License attribution ambiguity from verbatim numeric copying | mitigate | Methodology is symbolic formula extraction (D-04). Provenance block names the upstream repo + license. Per-class tables cite formulas, not lifted values; "snapshot" cells exist only as verification anchors and are clearly labeled "@ defaults." |
| T-1-03 | Information disclosure | Stale snapshot reference if user re-downloads | accept | Task 1 verifies the live SHA-256 matches the planned value before any other writes; if mismatch, the plan halts and the operator updates provenance. |
</threat_model>

<verification>
- [ ] Plan 02 and Plan 03 can append into the doc using the placeholder headings created here without re-organizing the file
- [ ] No `set_*` per-class enumerations appear in this doc yet (those are Plan 02's deliverable)
- [ ] Editor-API Touchpoints section is the most prominent visible callout (above per-class enumeration heading) so downstream phase implementers see it first
- [ ] Helper-function bodies are pasted verbatim (not paraphrased)
- [ ] Provenance hash is byte-identical to live `sha256sum` output
- [ ] Editor-API Touchpoints line numbers runtime-validated against live file (Task 3); verification stamp present in DISSECTION.md
- [ ] Globals "scale" row contains FORBIDDEN-in-NeoCade callout per D-05
</verification>

<success_criteria>
- File `.planning/research/MINIMAL-THEME-DISSECTION.md` exists
- All 12 grep acceptance checks in task 2 pass
- Provenance values match the live snapshot (task 1 verification passed)
- All 12 Editor-API line citations runtime-verified by Task 3 (sed-based spot-check); verification stamp recorded
- File reads top-to-bottom in this order: header → provenance → methodology → glossary → Editor-API Touchpoints → Globals → Helper Functions → (placeholder) Per-Control Enumeration → (placeholder) Engine-Default Cross-Reference and Pitfall Confirmations
</success_criteria>

<output>
After completion, create `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-01-SUMMARY.md` capturing: provenance verification result, list of named globals/helpers documented, line citations used, and any deviations from the planned content.
</output>
