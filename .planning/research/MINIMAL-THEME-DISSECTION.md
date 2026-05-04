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

> **Line-citation runtime validation (per cross-AI review 2026-05-04):** All 12 cited lines (15, 18, 20, 21, 24, 26, 28, 30, 32, 34, 36, 56) verified by `sed -n 'Np'` against the live snapshot. Stamp date: 2026-05-04.

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

**Body** (extracted verbatim from `sed -n '1096,1103p' minimal_theme.tres`):

```gdscript
func _get_base_color(brightness_offset: float = 0, saturation_multiplier: float = 1) -> Color:
	var dark : bool = dark_theme if brightness_offset >= 0 else !dark_theme
	var color : Color = Color(base_color)
	color.v = clampf(lerpf(color.v, 1 if dark else 0, absf(contrast * brightness_offset)), 0, 1)
	color.s *= saturation_multiplier
	return color

# Shorthand content margin setter
```

**Conceptual model:** result = `base_color` shifted in HSV by `brightness_offset * contrast` (with `dark_theme` flipping sign), then multiplied in saturation by `saturation_multiplier`. The `contrast` editor setting (line 20) is what makes the ramp tunable.

### `_set_margin(sb: StyleBox, left: float, top: float, right: float = left, bottom: float = top) -> void`

**Lines:** 1104-1110.

Convenience wrapper around `StyleBox.set_content_margin_*` calls. Lets per-class code write `_set_margin(sb, 4, 4)` instead of four individual margin assignments.

**Body** (extracted verbatim from `sed -n '1104,1110p' minimal_theme.tres`):

```gdscript
func _set_margin(sb: StyleBox, left: float, top: float, right: float = left, bottom: float = top) -> void:
	sb.content_margin_left = left * scale
	sb.content_margin_top = top * scale
	sb.content_margin_right = right * scale
	sb.content_margin_bottom = bottom * scale

# Shorthand border setter
```

> **NeoCade note (D-05 reinforcement):** Every `_set_margin` invocation multiplies its arguments by the editor `scale` global (line 21 — EDSCALE). NeoCade's Phase 4 reimplementation MUST drop the `* scale` factor and instead multiply by NeoCade's own design-token unit (or by Godot's runtime `content_scale_factor` if user-configurable). Treat upstream `_set_margin(sb, X, Y)` calls as `content_margin = X` (NeoCade unit), not `X * scale`.

### `_set_border(sb: StyleBoxFlat, color: Color, width: float = 1, blend: bool = false) -> void`

**Lines:** 1111-1118.

Convenience wrapper for `StyleBoxFlat.border_color`, `border_width_*`, and the `draw_extra_borders` toggle. Used heavily for focus rings and split-container divider lines.

**Body** (extracted verbatim from `sed -n '1111,1118p' minimal_theme.tres`):

```gdscript
func _set_border(sb: StyleBoxFlat, color: Color, width: float = 1, blend: bool = false) -> void:
	sb.border_color = color
	sb.border_blend = blend
	sb.set_border_width_all(int(ceilf(width * scale)))
"


[resource]
```

> **NeoCade note (D-05 reinforcement):** `_set_border` also multiplies by `scale` (EDSCALE — line 21). NeoCade reimplementation must replace `width * scale` with the raw NeoCade-token width. The trailing `"`, blank line, and `[resource]` shown above are the closing of the GDScript sub-resource string literal and the start of the Theme `[resource]` block at line 1118 — NOT part of `_set_border`. Included here for transparent provenance of the verbatim sed output.

## Per-Control Enumeration

> **Active Verification Audit (per CONTEXT.md D-08).** This subsection records every unique uppercase-token target the upstream `set_*` calls reference (80 tokens total — the keyword grep `set_(stylebox|color|font|icon|constant|font_size)\(...,\s*'[A-Z][a-zA-Z]+'` plus `[^,]+` first-arg surface them all). Each is classified into one of five buckets. The "user-facing — enumerated below" bucket is the dissection scope; the others are documented for completeness so coverage delta (Plan 04) starts from a verified baseline, not a keyword guess.

### Active Verification Audit

> **Methodology.** The audit grep `grep -oE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '[A-Z][a-zA-Z]+'" minimal_theme.tres | grep -oE "'[A-Z][a-zA-Z]+'" | sort -u` extracts the SECOND positional argument of every `set_*` call. A separate broader sweep also surfaces FIRST-positional-argument uppercase tokens that are slot-names rather than classes (Background, ContextualToolbar, FocusViewport, LaunchPadMovieMode, LaunchPadNormal, MovieWriterButtonPressed, ThemeEditorPreviewBG, ThemeEditorPreviewFG — these are slot-names of `EditorStyles` class and surface in the audit-grep output as a side effect). The combined set is 80 tokens; the table below classifies all 80.

| Class | Bucket | Why |
|-------|--------|-----|
| AcceptDialog | user-facing — enumerated below | D-08 user-facing dialog Control. Upstream set_* count: 1 (line 749). |
| AnimationBezierTrackEdit | editor-only — skipped per D-10 | Editor animation pane internal class. 4 set_* (173-176). |
| AnimationTimelineEdit | editor-only — skipped per D-10 | Editor animation pane internal class. 13 set_* (178-199). |
| AnimationTrackEdit | editor-only — skipped per D-10 | Editor animation pane internal class. 5 set_* (201-216). |
| AnimationTrackEditGroup | editor-only — skipped per D-10 | Editor animation pane internal class. 5 set_* (218-226). |
| AssetLib | editor-only — skipped per D-10 | Editor Asset Library dialog. 1 set_* (line discoverable via `grep -n "'AssetLib'"`). |
| Background | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name of `set_stylebox('Background', 'EditorStyles', sb)` at line 397. Surfaces in keyword audit; not a Godot Control class. |
| BottomPanelButton | editor-only — skipped per D-10 | Editor bottom-panel toggle button type. 4 set_* (233, 237, 238, 242). |
| Button | user-facing — enumerated below | D-08 user-facing base Button. 24 set_* (lines 256-279). |
| CheckBox | user-facing — enumerated below | D-08 user-facing toggle Control. 4 set_* (lines 283, 284, 289, 290). |
| CheckButton | user-facing — enumerated below | D-08 user-facing switch Control. 3 set_* (lines 294, 295, 296). |
| ColorPicker | user-facing — enumerated below | D-08 user-facing color picker. 3 set_* (lines 525, 526, 532). |
| ContextualToolbar | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('ContextualToolbar', 'EditorStyles', sb)` line 417. |
| Editor | editor-only — skipped per D-10 | Editor-singleton aggregate-color/icon class. 16 set_* (lines 300-322 region). |
| EditorAbout | editor-only — skipped per D-10 | About dialog. 1 set_* (line 757). |
| EditorAudioBus | editor-only — skipped per D-10 | Audio bus editor. 3 set_* (lines 248, 249, 252). |
| EditorDebuggerInspector | editor-only — skipped per D-10 | Debugger inspector pane. 1 set_* (line 1004). |
| EditorHelpBitContent | editor-only — skipped per D-10 | Editor help-bit content area. 1 set_*. |
| EditorHelpBitTitle | editor-only — skipped per D-10 | Editor help-bit title bar. 1 set_*. |
| EditorInspector | editor-only — skipped per D-10 | Editor inspector pane. 2 set_*. |
| EditorInspectorCategory | editor-only — skipped per D-10 | Inspector category header. 1 set_*. |
| EditorInspectorSection | editor-only — skipped per D-10 | Inspector section folder. 1 set_*. |
| EditorLogFilterButton | editor-only — skipped per D-10 | Log filter toggle. 3 set_*. |
| EditorProperty | editor-only — skipped per D-10 | Inspector property row. 5 set_*. |
| EditorSettingsDialog | editor-only — skipped per D-10 | Editor settings dialog. 1 set_* (line 753). |
| EditorSpinSlider | editor-only — skipped per D-10 | Inspector spin-slider widget. 1 set_*. |
| EditorStyles | editor-only — skipped per D-10 | Aggregate editor-styles namespace (carries Background/FocusViewport/LaunchPadNormal/etc. slot styleboxes). 13 set_* (lines 397, 405, 410-412, 417, 424, 429, 434, 853, 869, 985 region). |
| EditorValidationPanel | editor-only — skipped per D-10 | Validation panel. 1 set_*. |
| FlatButton | research-only (D-10 exception) | Editor-only in upstream (line 467-489) but enumerated below per CONTEXT.md D-10 because NeoCade reuses the name as Button TYPEVAR-01 (FEATURES.md DF-Button-1). 22 set_*. |
| FlatMenuButton | type variation noted on its base — enumerated below alongside MenuButton | Editor-only specialization of MenuButton with a flat (border-less) base stylebox. 23 set_* (lines 493-517). Documented under MenuButton notes for reference; NeoCade does not currently define a FlatMenuButton type variation (FEATURES.md TYPEVAR-* table has none). |
| FocusViewport | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('FocusViewport', 'EditorStyles', sb)` line 405. |
| GraphEdit | user-facing — enumerated below | D-08 user-facing node graph editor. 1 set_* (line 539). |
| GraphStateMachine | editor-only — skipped per D-10 | AnimationStateMachine editor. 1 set_* (line 543). |
| HBoxContainer | container chrome — enumerated below in "User-facing container chrome" section | Layout container; only constants. 1 set_* (line 547). |
| HScrollBar | user-facing — enumerated below | D-08 user-facing horizontal scrollbar. 5 set_* (lines 795, 802, 804, 812, 813). |
| HSeparator | container chrome — enumerated below in "User-facing container chrome" section | Layout separator; constant + stylebox. 2 set_* (lines 975, 978). |
| HSlider | user-facing — enumerated below | D-08 user-facing horizontal slider. 1 set_* (line 988). |
| HSplitContainer | container chrome — enumerated below in "User-facing container chrome" section | Layout container; constants only. 3 set_* (lines 552-554). |
| InspectorActionButton | editor-only — skipped per D-10 | Inspector action button row. 9 set_* (lines 559-570). |
| ItemList | user-facing — enumerated below | D-08 user-facing item list. 11 set_* (lines 574-591). |
| ItemListSecondary | type variation noted on its base — enumerated below alongside ItemList | Editor secondary-pane ItemList specialization. 1 set_* (line 1000). |
| Label | user-facing — enumerated below | D-08 user-facing label. 2 set_* (lines 595, 600). |
| LaunchPadMovieMode | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('LaunchPadMovieMode', 'EditorStyles', sb)` line 424. |
| LaunchPadNormal | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('LaunchPadNormal', 'EditorStyles', sb)` line 429. |
| LineEdit | user-facing — enumerated below | D-08 user-facing single-line text input. 4 set_* (lines 604, 611, 616, 622). |
| MainMenuBar | editor-only — skipped per D-10 | Editor's main-menu-bar type variation. 4 set_* (line 627 region). NOT the bare `MenuBar` class (see MenuBar reconciliation below). |
| MainScreenButton | editor-only — skipped per D-10 | Editor main-screen button. 8 set_*. |
| MenuButton | user-facing — enumerated below | D-08 user-facing menu trigger button. 23 set_* (lines 645-669). |
| MovieWriterButtonPressed | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('MovieWriterButtonPressed', 'EditorStyles', sb)` line 434. |
| OptionButton | user-facing — enumerated below | D-08 user-facing dropdown trigger. 24 set_* (lines 673-698). |
| PanelContainer | container chrome — enumerated below in "User-facing container chrome" section | Layout container with single panel stylebox. 1 set_* (line 725). |
| PopupDialog | editor-only — skipped per D-10 | Legacy popup dialog (Godot 3.x leftover); upstream still themes it. 1 set_* (line 748). |
| PopupMenu | user-facing — enumerated below | D-08 user-facing popup menu. 8 set_* (lines 702-723). |
| PopupPanel | user-facing — enumerated below | D-08 user-facing popup panel. 1 set_* (line 735). |
| ProgressBar | user-facing — enumerated below | D-08 user-facing progress indicator. 2 set_* (lines 769, 775). |
| ProjectExportDialog | editor-only — skipped per D-10 | Editor project-export dialog. 1 set_* (line 755). |
| ProjectManager | editor-only — skipped per D-10 | Project Manager window. 1 set_*. |
| ProjectSettingsEditor | editor-only — skipped per D-10 | Editor project-settings dialog. 1 set_* (line 754). |
| RichTextLabel | user-facing — enumerated below | D-08 user-facing rich-text label. 1 set_* (line 782). |
| RunBarButton | editor-only — skipped per D-10 | Editor toolbar run-button. 1 set_*. |
| RunBarButtonMovieMakerDisabled | editor-only — skipped per D-10 | Editor toolbar run-button (movie-maker disabled). 4 set_*. |
| RunBarButtonMovieMakerEnabled | editor-only — skipped per D-10 | Editor toolbar run-button (movie-maker enabled). 4 set_*. |
| SceneImportSettingsDialog | editor-only — skipped per D-10 | Editor import-settings dialog. 1 set_* (line 756). |
| ScrollContainer | container chrome — enumerated below in "User-facing container chrome" section | Layout container; styleboxes. 2 set_* (lines 786, 787). |
| SplitContainer | container chrome — enumerated below in "User-facing container chrome" section | Base SplitContainer constants. 2 set_* (lines 823, 824). |
| TabBar | user-facing — enumerated below | D-08 user-facing tab bar. 13 set_* (lines 828-876, every other). |
| TabContainer | user-facing — enumerated below | D-08 user-facing tab container. 15 set_* (lines 829-896, every other). |
| TabContainerOdd | type variation noted on its base — enumerated below alongside TabContainer | Editor TabContainer odd-row specialization. 7 set_* (lines 857-897, scattered). |
| TextEdit | user-facing — enumerated below | D-08 user-facing multi-line text input. 3 set_* (lines 612, 617, 623). |
| ThemeEditorPreviewBG | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('ThemeEditorPreviewBG', 'EditorStyles', sb)` line 869. |
| ThemeEditorPreviewFG | slot-name (not a class) — themed under EditorStyles class | First-arg slot-name `set_stylebox('ThemeEditorPreviewFG', 'EditorStyles', sb)` line 853. |
| ThemeItemEditorDialog | editor-only — skipped per D-10 | Editor theme-item-editor dialog. 1 set_* (line 758). |
| TooltipPanel | user-facing — enumerated below | D-08 user-facing tooltip panel. 1 set_* (line 743). |
| Tree | user-facing — enumerated below | D-08 user-facing tree control. 30 set_* (lines 901-965). |
| TreeSecondary | type variation noted on its base — enumerated below alongside Tree | Editor secondary-pane Tree specialization. 1 set_* (line 999). |
| VBoxContainer | container chrome — enumerated below in "User-facing container chrome" section | Layout container; only constants. 1 set_* (line 548). |
| VScrollBar | user-facing — enumerated below | D-08 user-facing vertical scrollbar. 5 set_* (lines 796, 803, 805, 818, 819). |
| VSeparator | container chrome — enumerated below in "User-facing container chrome" section | Layout separator. 2 set_* (lines 976, 981). |
| VSlider | user-facing — enumerated below | D-08 user-facing vertical slider. 1 set_* (line 991). |
| VSplitContainer | container chrome — enumerated below in "User-facing container chrome" section | Layout container; constants only. 3 set_* (lines 556-558). |

**Bucket counts:**
- user-facing — enumerated below: 24 (AcceptDialog, Button, CheckBox, CheckButton, ColorPicker, GraphEdit, HScrollBar, HSlider, ItemList, Label, LineEdit, MenuButton, OptionButton, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, TabBar, TabContainer, TextEdit, TooltipPanel, Tree, VScrollBar, VSlider)
- research-only (FlatButton, D-10 exception): 1 (FlatButton)
- type variation noted on its base: 4 (FlatMenuButton → MenuButton notes; ItemListSecondary → ItemList notes; TabContainerOdd → TabContainer notes; TreeSecondary → Tree notes)
- container chrome — enumerated below as a single section "User-facing container chrome": 9 (HBoxContainer, VBoxContainer, PanelContainer, ScrollContainer, SplitContainer, HSplitContainer, VSplitContainer, HSeparator, VSeparator)
- editor-only — skipped per D-10: 34 (AnimationBezierTrackEdit, AnimationTimelineEdit, AnimationTrackEdit, AnimationTrackEditGroup, AssetLib, BottomPanelButton, Editor, EditorAbout, EditorAudioBus, EditorDebuggerInspector, EditorHelpBitContent, EditorHelpBitTitle, EditorInspector, EditorInspectorCategory, EditorInspectorSection, EditorLogFilterButton, EditorProperty, EditorSettingsDialog, EditorSpinSlider, EditorStyles, EditorValidationPanel, GraphStateMachine, InspectorActionButton, MainMenuBar, MainScreenButton, PopupDialog, ProjectExportDialog, ProjectManager, ProjectSettingsEditor, RunBarButton, RunBarButtonMovieMakerDisabled, RunBarButtonMovieMakerEnabled, SceneImportSettingsDialog, ThemeItemEditorDialog)
- slot-name (not a class) — themed under EditorStyles class: 8 (Background, ContextualToolbar, FocusViewport, LaunchPadMovieMode, LaunchPadNormal, MovieWriterButtonPressed, ThemeEditorPreviewBG, ThemeEditorPreviewFG)

**Total:** 24 + 1 + 4 + 9 + 34 + 8 = 80 tokens. Matches the audit-grep output exactly.

**D-08 reconciliation:** D-08 lists 27 user-facing Controls; the audit surfaces only 24 with direct `set_*` entries. The three D-08 classes WITHOUT upstream entries are:
1. **`MenuBar`** — D-08 lists it but upstream targets only `MainMenuBar` (editor type variation). The bare `MenuBar` class has zero `set_*` calls in `minimal_theme.tres`. **Classification:** unthemed by upstream — NeoCade owns first-class theming; coverage delta (Plan 04) flags this as NeoCade-additive.
2. **`Panel`** — D-08 lists it but upstream targets `PanelContainer` (container Control) and `PopupPanel` (popup) and never the bare `Panel` Control. The bare `Panel` class has zero `set_*` calls. **Classification:** unthemed by upstream — NeoCade-additive.
3. **`Window`** — D-08 lists it but upstream theme has zero `set_*` calls targeting bare `Window`. Window styling in upstream is implicit via the popup classes (`PopupDialog`, `AcceptDialog`, etc.) which are subclasses. **Classification:** unthemed by upstream — NeoCade-additive.

These three are enumerated below as `### MenuBar`, `### Panel`, `### Window` sections each carrying an explicit "no upstream entries" / "NeoCade-additive" note (no enumeration table since there's nothing to enumerate). Coverage delta (Plan 04) consumes these as additives requiring NeoCade-original theming.



## Engine-Default Cross-Reference and Pitfall Confirmations

> This section is appended by **Plan 03 (default_theme.cpp omission cross-reference + Pitfall 1.1 / 1.7 confirmation/refutation)**. Heading reserved here for ordering only.
