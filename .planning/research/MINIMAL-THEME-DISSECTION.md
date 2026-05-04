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

> **Stylebox-variable dictionary (used by per-class tables below).** Several `var X : StyleBoxFlat = ...` declarations sit between the Globals section (line ~95) and the per-class `set_*` calls (line 173+). Per-class tables cite these by name rather than expanding the construction recipe inline; this dictionary is the lookup. All `* scale` factors are EDSCALE-derived and FORBIDDEN in NeoCade per D-05 — Phase 4 token generator drops them.

| Variable | Definition (symbolic) | Lines |
|----------|-----------------------|-------|
| `color_button_normal` | `_get_base_color(0.35, 0.85)` | 96 |
| `color_button_hover` | `_get_base_color(0.55, 0.75)` | 97 |
| `color_button_pressed` | `_get_base_color(0.75, 0.75)` | 98 |
| `color_button_disabled` | `_get_base_color(0.2, 0.75)` | 99 |
| `color_button_border` | `_get_base_color(0.45, 0.75)` | 100 |
| `color_button_border_hover` | `_get_base_color(0.65, 0.75)` | 101 |
| `color_button_border_pressed` | `_get_base_color(0.85, 0.75)` | 102 |
| `color_extra_border` | `color_mono * Color(1, 1, 1, 0.4)` | 105 |
| `color_extra_border_dimmed` | `color_mono * Color(1, 1, 1, 0.2)` | 106 |
| `base_sb` | `StyleBoxFlat.new()` with `bg_color = base_color`, `content_margin_all = base_margin * scale`, `corner_radius_all = int(corner_radius * scale)` | 109-112 |
| `button_sb` | `base_sb.duplicate()` with `bg_color = color_button_normal`, `shadow_color = color_mono_inv * Color(1,1,1,0.005)`, `shadow_size = int(ceilf(8 * scale))`, `shadow_offset = Vector2(0,4) * scale`, `_set_border(.., color_extra_border or color_button_border, 1)` (per `draw_extra_borders`), `_set_margin(.., base_margin*2, base_margin*1.5, base_margin*2, base_margin*1.5)` | 117-126 |
| `button_hover_sb` | `button_sb.duplicate()` with `bg_color = color_button_hover`, `_set_border(.., color_extra_border or color_button_border_hover, 1)` (per `draw_extra_borders`) | 128-133 |
| `button_pressed_sb` | `button_sb.duplicate()` with `bg_color = color_button_pressed`, `_set_border(.., color_extra_border or color_button_border_pressed, 1)` (per `draw_extra_borders`) | 135-140 |
| `button_disabled_sb` | `button_sb.duplicate()` with `border_width_all = 0`, `bg_color = color_button_disabled`, conditional `_set_border(.., color_extra_border_dimmed * Color(1,1,1,0.5), 1)` if `draw_extra_borders` | 142-146 |
| `flat_button_hover_sb` | `base_sb.duplicate()` with `_set_margin(.., base_margin*1.5, base_margin*0.9, base_margin*1.5, base_margin*0.9)`, `bg_color = color_button_normal`, conditional `_set_border(.., color_extra_border, 1)` if `draw_extra_borders` | 148-153 |
| `flat_button_pressed_sb` | `flat_button_hover_sb.duplicate()` with `bg_color = color_button_hover` | 155-156 |
| `flat_button_normal_sb` | `flat_button_hover_sb.duplicate()` with `draw_center = false` | 158-159 |
| `base_empty_sb` | `base_sb.duplicate()` with `draw_center = false`, `set_content_margin_all(0)` | 161-163 |
| `base_empty_wide_sb` | `base_sb.duplicate()` with `draw_center = false`, `_set_margin(.., base_empty_wide_margin*1.5, base_empty_wide_margin, base_empty_wide_margin*1.5, base_empty_wide_margin)` where `base_empty_wide_margin = maxf(base_margin, 3.0)` (line 168) | 165-169 |

> **Snapshot at upstream defaults** (`base_color=#272727`, `accent_color=#569eff`, `contrast=0.325`, `corner_radius=4`, `dark_theme=true`, `dark_theme_icon_and_font=true`, `draw_extra_borders=false`, `scale=1.0`, `base_margin=4.0`):
> - `color_button_normal` ≈ `Color(0.34, 0.34, 0.34, 1)` (base_color brightened by `0.35*0.325 ≈ 0.114` in HSV V; saturation × 0.85 ≈ 0)
> - `color_button_hover` ≈ `Color(0.40, 0.40, 0.40, 1)` (V shift ≈ 0.179)
> - `color_button_pressed` ≈ `Color(0.46, 0.46, 0.46, 1)` (V shift ≈ 0.244)
> - `color_button_disabled` ≈ `Color(0.31, 0.31, 0.31, 1)` (V shift ≈ 0.065)
> - `color_button_border` ≈ `Color(0.37, 0.37, 0.37, 1)` (V shift ≈ 0.146)
> - `color_button_border_hover` ≈ `Color(0.43, 0.43, 0.43, 1)` (V shift ≈ 0.211)
> - `color_button_border_pressed` ≈ `Color(0.49, 0.49, 0.49, 1)` (V shift ≈ 0.276)
>
> Per cross-AI review HIGH #4 anchor: the snapshot column in per-class tables uses these computed values, never `(unevaluated)` placeholders.

### Button

**Gloss:** Godot's base `Button` Control — text + optional icon, no toggle behavior. Source of all push-button-style theme entries; CheckBox / CheckButton / OptionButton / MenuButton inherit / share much of this.

**Upstream entry count:** 24 total set_* calls (12 stylebox, 11 color, 1 constant, 0 font/icon).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_color | normal | `color_font_normal` = `color_mono_font * Color(1,1,1,0.7)` (mono_font = WHITE since dark_theme_icon_and_font) | `Color(1,1,1,0.7)` | 256 (set), 81 (def) |
| color | font_disabled_color | disabled | `color_font_dimmed` = `color_mono_font * Color(1,1,1, 0.35 if dark_theme_icon_and_font else 0.5)` | `Color(1,1,1,0.35)` | 257, 84 |
| color | font_focus_color | focus | `color_font_highlighted` = `color_mono_font` (full alpha) | `Color(1,1,1,1)` | 258, 83 |
| color | font_hover_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 259, 83 |
| color | font_hover_pressed_color | hover_pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 260, 83 |
| color | font_pressed_color | pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 261, 83 |
| color | icon_disabled_color | disabled | `color_icon_disabled` = `Color(1,1,1, 0.35 if dark_theme_icon_and_font else 0.5)` | `Color(1,1,1,0.35)` | 262, 93 |
| color | icon_focus_color | focus | `color_icon_focus` = `Color(1,1,1)` | `Color(1,1,1,1)` | 263, 89 |
| color | icon_hover_color | hover | `color_icon_hover` = `Color(1,1,1)` | `Color(1,1,1,1)` | 264, 90 |
| color | icon_hover_pressed_color | hover_pressed | `color_icon_hover` = `Color(1,1,1)` | `Color(1,1,1,1)` | 265, 90 |
| color | icon_normal_color | normal | `color_icon_normal` = `Color(1,1,1, 0.7 if dark_theme_icon_and_font else 0.95)` | `Color(1,1,1,0.7)` | 266, 87 |
| color | icon_pressed_color | pressed | `color_icon_pressed` = `accent_color * (1.15 if dark_theme_icon_and_font else 3.5)` then `.a = 1.0` | `Color(0.39, 0.71, 1.0, 1)` (≈ accent#569eff × 1.15) | 267, 91-92 |
| constant | outline_size | (n/a) | literal `0` | `0` | 268 |
| stylebox | disabled | disabled | `button_disabled_sb` | (per dict; `bg_color≈(0.31,0.31,0.31)`, `border_width_all=0`) | 269, 142-146 |
| stylebox | disabled_mirrored | disabled (RTL) | `button_disabled_sb` | (same as `disabled`) | 270, 142-146 |
| stylebox | focus | focus | `base_empty_sb` | (per dict; `draw_center=false`, `content_margin=0`) — pure focus is a no-op overlay; Pitfall 1.1 evidence | 271, 161-163 |
| stylebox | hover | hover | `button_hover_sb` | (per dict; `bg_color≈(0.40,0.40,0.40)`, border_color=`color_button_border_hover`) | 272, 128-133 |
| stylebox | hover_mirrored | hover (RTL) | `button_hover_sb` | (same as `hover`) | 273, 128-133 |
| stylebox | hover_pressed | hover_pressed | `button_pressed_sb` | (per dict; `bg_color≈(0.46,0.46,0.46)`) | 274, 135-140 |
| stylebox | hover_pressed_mirrored | hover_pressed (RTL) | `button_pressed_sb` | (same as `hover_pressed`) | 275, 135-140 |
| stylebox | normal | normal | `button_sb` | (per dict; `bg_color≈(0.34,0.34,0.34)`, shadow_size=8 EDSCALE, content_margin per `_set_margin(sb, 8, 6, 8, 6)`) | 276, 117-126 |
| stylebox | normal_mirrored | normal (RTL) | `button_sb` | (same as `normal`) | 277, 117-126 |
| stylebox | pressed | pressed | `button_pressed_sb` | (per dict; `bg_color≈(0.46,0.46,0.46)`) | 278, 135-140 |
| stylebox | pressed_mirrored | pressed (RTL) | `button_pressed_sb` | (same as `pressed`) | 279, 135-140 |

**Per-class notes:**
- Upstream sets BOTH `<state>` and `<state>_mirrored` styleboxes for every state (normal/hover/pressed/hover_pressed/disabled). RTL UI support is explicit, even though the values are identical. NeoCade should mirror this discipline — Godot's RTL renderer expects the `_mirrored` slots to be present.
- `outline_size = 0` (line 268) explicitly disables font outlines on Buttons. Upstream does not set `font_outline_color`; engine default is whatever Godot picks. If NeoCade ever wants outlines, both `outline_size` and `font_outline_color` must be set.
- `focus` slot is `base_empty_sb` (draw_center=false, no margins). This is **Pitfall 1.1 evidence in action** — focus-as-overlay loses to pressed/checked, so upstream makes the focus stylebox a transparent no-op and relies on `font_focus_color` / `icon_focus_color` for focus indication. Plan 03 confirms/refutes Pitfall 1.1 from this evidence.
- `font_size`, `icon_max_width`, `h_separation` are NOT explicitly set on Button — engine defaults apply. Plan 03 will flag these as deliberate omissions per D-12.

### CheckBox

**Gloss:** Godot's `CheckBox` Control — Button subclass with a square tickbox icon to the left of label text. Inherits Button's full state matrix; only overrides what differs.

**Upstream entry count:** 4 total set_* calls (2 stylebox, 2 color).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_hover_pressed_color | hover_pressed | `color_font_highlighted` = `color_mono_font` | `Color(1,1,1,1)` | 283, 83 |
| color | font_pressed_color | pressed | `color_font_normal` = `color_mono_font * Color(1,1,1,0.7)` | `Color(1,1,1,0.7)` | 284, 81 |
| stylebox | normal | normal | `sb` (locally constructed at 286-288: `base_sb.duplicate()`, `draw_center=false`, `_set_margin(sb, 6, 2, 6, 2)`) | (transparent panel, asymmetric margins favoring horizontal padding) | 289, 286-288 |
| stylebox | normal_mirrored | normal (RTL) | same `sb` as above | (same) | 290, 286-288 |

**Per-class notes:**
- Upstream sets ONLY `font_pressed_color` (overriding Button's `color_font_highlighted` to `color_font_normal` — pressed CheckBox text dims, unlike Button) and `font_hover_pressed_color`. Other font/icon colors (font_color, font_focus_color, font_hover_color, etc.) inherit from Button via type chain.
- The radio-related slots (`radio_checked`, `radio_unchecked`, `radio_checked_disabled`, `radio_unchecked_disabled`) are NOT set on CheckBox. These ARE Godot-API-level slots per `default_theme.cpp` — Plan 03 cross-reference will flag them as deliberate upstream omissions (engine-default ticked-box icon used).
- `checked`, `unchecked`, `checked_disabled`, `unchecked_disabled` icon slots also not set — engine-default icons used.

### CheckButton

**Gloss:** Godot's `CheckButton` Control — Button subclass with a horizontal switch (toggle slider) icon. Visually distinct from CheckBox; semantics identical (binary toggle).

**Upstream entry count:** 3 total set_* calls (3 color, 0 stylebox/font/icon/constant).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_focus_color | focus | `color_font_normal` = `color_mono_font * Color(1,1,1,0.7)` | `Color(1,1,1,0.7)` | 294, 81 |
| color | font_hover_pressed_color | hover_pressed | `color_font_highlighted` = `color_mono_font` | `Color(1,1,1,1)` | 295, 83 |
| color | font_pressed_color | pressed | `color_font_normal` | `Color(1,1,1,0.7)` | 296, 81 |

**Per-class notes:**
- Upstream sets ONLY 3 font colors. All styleboxes (normal/hover/pressed/disabled/focus) inherit from Button base class via the engine's type-resolution chain.
- Note `font_focus_color` is overridden to `color_font_normal` (Color(1,1,1,0.7)), distinct from Button's `color_font_highlighted` (Color(1,1,1,1)). CheckButton text appears dimmer in focus than a regular Button would.
- The toggle-icon slots (`on`, `off`, `on_disabled`, `off_disabled`, `on_mirrored`, `off_mirrored`, etc.) are NOT set — engine-default switch icons used.

### FlatButton

**Gloss:** Editor-only Button type variation in upstream — used for borderless toolbar buttons (Properties tab, Inspector tab). NeoCade reuses the name as a Button TYPEVAR-01 / DF-Button-1 per FEATURES.md (research-only enumeration here per CONTEXT.md D-10).

**Upstream entry count:** 22 total set_* calls (10 stylebox, 12 color, 0 constant/font/icon).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_color | normal | `color_font_normal` | `Color(1,1,1,0.7)` | 467, 81 |
| color | font_disabled_color | disabled | `color_font_dimmed` | `Color(1,1,1,0.35)` | 468, 84 |
| color | font_focus_color | focus | `color_font_highlighted` | `Color(1,1,1,1)` | 469, 83 |
| color | font_hover_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 470, 83 |
| color | font_hover_pressed_color | hover_pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 471, 83 |
| color | font_pressed_color | pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 472, 83 |
| color | icon_disabled_color | disabled | `color_icon_disabled` | `Color(1,1,1,0.35)` | 473, 93 |
| color | icon_focus_color | focus | `color_icon_focus` | `Color(1,1,1,1)` | 474, 89 |
| color | icon_hover_color | hover | `color_icon_hover` | `Color(1,1,1,1)` | 475, 90 |
| color | icon_hover_pressed_color | hover_pressed | `color_icon_hover` | `Color(1,1,1,1)` | 476, 90 |
| color | icon_normal_color | normal | `color_icon_normal` | `Color(1,1,1,0.7)` | 477, 87 |
| color | icon_pressed_color | pressed | `color_icon_pressed` | `Color(0.39,0.71,1.0,1)` (≈ accent × 1.15) | 478, 91-92 |
| stylebox | disabled | disabled | `base_empty_wide_sb` | (per dict; draw_center=false, wide horizontal margin) | 480, 165-169 |
| stylebox | disabled_mirrored | disabled (RTL) | `base_empty_wide_sb` | (same) | 481, 165-169 |
| stylebox | normal | normal | `base_empty_wide_sb` | (transparent — flat button has no normal-state background) | 482, 165-169 |
| stylebox | normal_mirrored | normal (RTL) | `base_empty_wide_sb` | (same) | 483, 165-169 |
| stylebox | hover | hover | `flat_button_hover_sb` | (per dict; bg=`color_button_normal`, narrow vertical margin) | 484, 148-153 |
| stylebox | hover_mirrored | hover (RTL) | `flat_button_hover_sb` | (same) | 485, 148-153 |
| stylebox | hover_pressed | hover_pressed | `flat_button_pressed_sb` | (per dict; bg=`color_button_hover`) | 486, 155-156 |
| stylebox | hover_pressed_mirrored | hover_pressed (RTL) | `flat_button_pressed_sb` | (same) | 487, 155-156 |
| stylebox | pressed | pressed | `flat_button_pressed_sb` | (same) | 488, 155-156 |
| stylebox | pressed_mirrored | pressed (RTL) | `flat_button_pressed_sb` | (same) | 489, 155-156 |

**Per-class notes:**
- **TYPEVAR-01 design context.** Editor-only in upstream; enumerated here per CONTEXT.md D-10 because NeoCade reuses the name as a Button type variation per FEATURES.md TYPEVAR-01 (DF-Button-1). NeoCade's FlatButton variation does NOT inherit upstream's editor-bound implementation; this enumeration is research material for the TYPEVAR-01 visual contract decision in Phase 5.
- Color matrix is **identical to Button's** — same 12 entries, same source globals. The only difference is the stylebox set: FlatButton uses the "flat" (border-less, transparent-normal) variants instead of the bordered/filled `button_*_sb` family.
- No `focus` stylebox is set on FlatButton (unlike Button which sets `focus → base_empty_sb` at line 271). FlatButton's focus state has no theme entry → engine default applies, which on a flat button is effectively invisible. Pitfall 1.1 worth noting: focus indication on flat buttons relies entirely on `font_focus_color` and `icon_focus_color`.
- TYPEVAR-01 NeoCade visual contract should NOT replicate the "no normal-state background" approach if NeoCade's design system requires visible idle affordance. Phase 5 decision.

### MenuButton

**Gloss:** Godot's `MenuButton` Control — Button subclass that opens a PopupMenu when pressed. Used for menu triggers in toolbars and dropdown menus.

**Upstream entry count:** 23 total set_* calls (11 stylebox, 12 color, 0 constant/font/icon).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_color | normal | `color_font_normal` | `Color(1,1,1,0.7)` | 645, 81 |
| color | font_disabled_color | disabled | `color_font_dimmed` | `Color(1,1,1,0.35)` | 646, 84 |
| color | font_focus_color | focus | `color_font_highlighted` | `Color(1,1,1,1)` | 647, 83 |
| color | font_hover_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 648, 83 |
| color | font_hover_pressed_color | hover_pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 649, 83 |
| color | font_pressed_color | pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 650, 83 |
| color | icon_disabled_color | disabled | `color_icon_disabled` | `Color(1,1,1,0.35)` | 652, 93 |
| color | icon_focus_color | focus | `color_icon_focus` | `Color(1,1,1,1)` | 653, 89 |
| color | icon_hover_color | hover | `color_icon_hover` | `Color(1,1,1,1)` | 654, 90 |
| color | icon_hover_pressed_color | hover_pressed | `color_icon_hover` | `Color(1,1,1,1)` | 655, 90 |
| color | icon_normal_color | normal | `color_icon_normal` | `Color(1,1,1,0.7)` | 656, 87 |
| color | icon_pressed_color | pressed | `color_icon_pressed` | `Color(0.39,0.71,1.0,1)` | 657, 91-92 |
| stylebox | disabled | disabled | `base_empty_wide_sb` | (per dict; transparent, wide margins) | 659, 165-169 |
| stylebox | disabled_mirrored | disabled (RTL) | `base_empty_wide_sb` | (same) | 660, 165-169 |
| stylebox | focus | focus | `base_empty_wide_sb` | (transparent — focus is a no-op; relies on `font_focus_color`) | 661, 165-169 |
| stylebox | normal | normal | `base_empty_wide_sb` | (transparent — flat button styling) | 662, 165-169 |
| stylebox | normal_mirrored | normal (RTL) | `base_empty_wide_sb` | (same) | 663, 165-169 |
| stylebox | pressed | pressed | `flat_button_pressed_sb` | (per dict; bg=`color_button_hover`) | 664, 155-156 |
| stylebox | pressed_mirrored | pressed (RTL) | `flat_button_pressed_sb` | (same) | 665, 155-156 |
| stylebox | hover | hover | `flat_button_hover_sb` | (per dict; bg=`color_button_normal`) | 666, 148-153 |
| stylebox | hover_mirrored | hover (RTL) | `flat_button_hover_sb` | (same) | 667, 148-153 |
| stylebox | hover_pressed | hover_pressed | `flat_button_hover_sb` | (intentional — see notes) | 668, 148-153 |
| stylebox | hover_pressed_mirrored | hover_pressed (RTL) | `flat_button_hover_sb` | (same) | 669, 148-153 |

**Per-class notes:**
- MenuButton uses **flat-style styleboxes throughout** (`base_empty_wide_sb` for normal/disabled/focus + `flat_button_*_sb` for hover/pressed). This is consistent with FlatButton — both treat MenuButton as a "button living in a toolbar" semantically.
- **Asymmetry vs Button:** `hover_pressed` uses `flat_button_hover_sb` (not `flat_button_pressed_sb`). When a menu is open AND mouse is hovering the trigger, the visual is "hover" not "pressed" — the open menu IS the pressed-state indicator, not the trigger background. Subtle but intentional.
- **Type variation: FlatMenuButton** — upstream defines an editor-only `FlatMenuButton` variation (lines 493-517, 23 set_*) that is structurally identical to MenuButton (same 23 slot/color entries) but exists as a distinct type for editor toolbar styling. NeoCade FEATURES.md does NOT currently define a FlatMenuButton TYPEVAR; this is documented for completeness only. If NeoCade adds menu-button-in-toolbar variations in v1.x, FlatMenuButton would be the precedent.
- Color matrix identical to Button + FlatButton (same 12 colors, same globals). The "button family" share a common color axis; styleboxes differentiate.

### OptionButton

**Gloss:** Godot's `OptionButton` Control — Button subclass that opens a PopupMenu and displays the selected option's text/icon. Used for dropdown selection.

**Upstream entry count:** 24 total set_* calls (12 stylebox, 12 color (include `arrow_margin` which is constant — actually 1 constant + 12 color = 13 non-stylebox; recheck below), and breakdown is: 1 constant + 12 color + 11 stylebox = 24).

> Recount (per acceptance-criterion exact equality): 1 constant (line 673) + 12 color (lines 675-686) + 11 stylebox (lines 688-698) = 24. ✓

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| constant | arrow_margin | (n/a) | `int(base_margin * 2 * scale)` | `8` (base_margin=4, scale=1) — EDSCALE-derived; NeoCade drops `* scale` | 673 |
| color | font_color | normal | `color_font_normal` | `Color(1,1,1,0.7)` | 675, 81 |
| color | font_disabled_color | disabled | `color_font_dimmed` | `Color(1,1,1,0.35)` | 676, 84 |
| color | font_focus_color | focus | `color_font_highlighted` | `Color(1,1,1,1)` | 677, 83 |
| color | font_hover_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 678, 83 |
| color | font_hover_pressed_color | hover_pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 679, 83 |
| color | font_pressed_color | pressed | `color_font_highlighted` | `Color(1,1,1,1)` | 680, 83 |
| color | icon_disabled_color | disabled | `color_icon_disabled` | `Color(1,1,1,0.35)` | 681, 93 |
| color | icon_focus_color | focus | `color_icon_focus` | `Color(1,1,1,1)` | 682, 89 |
| color | icon_hover_color | hover | `color_icon_hover` | `Color(1,1,1,1)` | 683, 90 |
| color | icon_hover_pressed_color | hover_pressed | `color_icon_hover` | `Color(1,1,1,1)` | 684, 90 |
| color | icon_normal_color | normal | `color_icon_normal` | `Color(1,1,1,0.7)` | 685, 87 |
| color | icon_pressed_color | pressed | `color_icon_pressed` | `Color(0.39,0.71,1.0,1)` | 686, 91-92 |
| stylebox | disabled | disabled | `button_disabled_sb` | (per dict) | 688, 142-146 |
| stylebox | disabled_mirrored | disabled (RTL) | `button_disabled_sb` | (same) | 689, 142-146 |
| stylebox | focus | focus | `base_empty_sb` | (transparent — Pitfall 1.1) | 690, 161-163 |
| stylebox | normal | normal | `button_sb` | (per dict; bordered + filled) | 691, 117-126 |
| stylebox | normal_mirrored | normal (RTL) | `button_sb` | (same) | 692, 117-126 |
| stylebox | pressed | pressed | `button_pressed_sb` | (per dict) | 693, 135-140 |
| stylebox | pressed_mirrored | pressed (RTL) | `button_pressed_sb` | (same) | 694, 135-140 |
| stylebox | hover | hover | `button_hover_sb` | (per dict) | 695, 128-133 |
| stylebox | hover_mirrored | hover (RTL) | `button_hover_sb` | (same) | 696, 128-133 |
| stylebox | hover_pressed | hover_pressed | `button_pressed_sb` | (per dict) | 697, 135-140 |
| stylebox | hover_pressed_mirrored | hover_pressed (RTL) | `button_pressed_sb` | (same) | 698, 135-140 |

**Per-class notes:**
- OptionButton uses the **same stylebox set as Button** (`button_sb` / `button_hover_sb` / `button_pressed_sb` / `button_disabled_sb` / `base_empty_sb`-for-focus) — it's a "real button" visually, in contrast to MenuButton which is a flat toolbar-button.
- The `arrow_margin` constant (line 673) controls horizontal spacing between the option's icon/text and the dropdown arrow icon. It's the only OptionButton-specific constant; engine defaults handle `h_separation`, `icon_max_width`, etc.
- `arrow` icon slot is NOT set — engine-default dropdown arrow used. Plan 03 will flag this as a deliberate omission per D-12.
- Color matrix identical to Button (same 12 colors, same globals).

### Label

**Gloss:** Godot's `Label` Control — static text display. No interactive states; the simplest theme-able Control.

**Upstream entry count:** 2 total set_* calls (1 color, 1 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_color | normal | `color_font_normal` | `Color(1,1,1,0.7)` | 595, 81 |
| stylebox | normal | normal | local `empty_sb` (line 597-599: `base_empty_sb.duplicate()`, then `_set_margin(empty_sb, 8, 4, 8, 4)` in EDSCALE units, base_margin=4) | (transparent panel, asymmetric margins favoring horizontal padding to prevent the editor's quick-open dialog from cramming text) | 600, 597-599 |

**Per-class notes:**
- Upstream sets ONLY `font_color` and `normal` stylebox. Outline (`font_outline_color`, `outline_size`), font itself (`font`), font_size, and shadow (`font_shadow_*`) are NOT set — engine defaults apply.
- Comment at line 598: "Keeping vertical margin low otherwise quick open looks bad" — explicit acknowledgment that Label margins were tuned for the editor's quick-open dialog. NeoCade should select Label margins from its own design system, not lift this `_set_margin(8, 4, 8, 4)` (a Pitfall 6.1 / EDSCALE forbidden lift anyway since `_set_margin` multiplies by `scale`).
- Label is a base class for ToolTip / FoldableContainer headers / many other Controls. Inheritance chain matters; per-class tests in downstream phases should verify that LabelSettings overrides don't conflict with the upstream `font_color` set on the type root.

### LineEdit

**Gloss:** Godot's `LineEdit` Control — single-line text input. Critical for editor inspector property fields.

**Upstream entry count:** 4 total set_* calls (1 color, 3 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_placeholder_color | (placeholder) | `color_font_dimmed` = `color_mono_font * Color(1,1,1, 0.35 if dark_theme_icon_and_font else 0.5)` | `Color(1,1,1,0.35)` | 604, 84 |
| stylebox | focus | focus | local `sb` (line 606-610: `base_sb.duplicate()`, `bg_color = color_surface_lowest`, conditional `_set_border(sb, color_extra_border, 1)` if `draw_extra_borders`, `_set_margin(sb, 8, 3, 8, 3)`) | bg ≈ `Color(0.10, 0.10, 0.10, 1)` (surface_lowest, V≈ -1.3 × 0.325 = -0.423 from base) | 611, 606-610 |
| stylebox | normal | normal | local `sb = sb.duplicate()` from focus, then `bg_color = color_surface_lower` (line 614-615) | bg ≈ `Color(0.13, 0.13, 0.13, 1)` (surface_lower, V≈ -0.95 × 0.325 = -0.309 from base) | 616, 614-615 |
| stylebox | read_only | read_only | local `sb = sb.duplicate()` from normal, then `bg_color = Color(0,0,0,0.2) if dark_theme else Color(1,1,1,0.5)` (line 620-621) | `Color(0,0,0,0.2)` (dark_theme branch) | 622, 620-621 |

**Per-class notes:**
- Upstream uses **shared stylebox construction** with TextEdit — lines 606-623 set both `LineEdit` and `TextEdit` from the same `sb` variable. The first stylebox built (focus, surface_lowest bg) is darker than the normal-state (surface_lower bg) — visually, focus is *darker* than normal, opposite of the typical "focus is highlighted" pattern. This communicates "this field accepts input."
- Read-only stylebox uses bg_color `Color(0,0,0,0.2)` (transparent dark overlay) for dark_theme; comment at line 619: "Using transparent background for readonly otherwise it looks bad in the master audio bus."
- **Selection / caret colors NOT set on LineEdit** (no `selection_color`, `caret_color`, `caret_background_color`, `font_selected_color`). Engine defaults handle these. This is a deliberate omission per D-12 — NeoCade's TEXT-* requirements (REQUIREMENTS.md) include caret/selection theming, so Plan 04 flags as additive coverage NeoCade owns.
- `font` (typeface), `font_size`, `font_color`, `font_uneditable_color`, `clear_button_color`, `clear_button_color_pressed` are NOT set — engine-default editor font / sizes used.

### RichTextLabel

**Gloss:** Godot's `RichTextLabel` Control — BBCode-rendered text with inline formatting (bold/italic/colors). Used for editor help, console logs, multi-line tooltips.

**Upstream entry count:** 1 total set_* call (1 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | normal | normal | local `sb` (line 779-781: `base_sb.duplicate()`, `bg_color = color_surface_low`, `set_content_margin_all(base_margin * 2 * scale)`) | bg ≈ `Color(0.16, 0.16, 0.16, 1)` (surface_low, V≈ -0.6 × 0.325 = -0.195 from base) | 782, 779-781 |

**Per-class notes:**
- Single set_* call. `default_color` (text base color), `font_selected_color`, `selection_color`, `outline_color`, `outline_size`, `bold_font` / `italic_font` / `bold_italic_font` / `mono_font` / `normal_font`, plus per-section font_size are ALL NOT set — engine defaults apply.
- `surface_low` bg is the **uniform RichTextLabel background** — slightly raised from `surface_base` (anchor) but well below `surface_high`. Reads as a "content well" against the editor's `surface_base` panels.
- NeoCade should treat this as a starting point only — REQUIREMENTS.md TYPO-* category likely requires explicit bold/italic font slots and selection color.

### TextEdit

**Gloss:** Godot's `TextEdit` Control — multi-line text input. Foundation for CodeEdit (NeoCade-additive per D-09). Used for inspector multi-line property fields.

**Upstream entry count:** 3 total set_* calls (3 stylebox, 0 color).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | focus | focus | shared `sb` from LineEdit construction (line 606-610: `base_sb.duplicate()`, `bg_color = color_surface_lowest`, `_set_margin(sb, 8, 3, 8, 3)`) | bg ≈ `Color(0.10, 0.10, 0.10, 1)` | 612, 606-610 |
| stylebox | normal | normal | shared `sb` from LineEdit (line 614-615: `bg_color = color_surface_lower`) | bg ≈ `Color(0.13, 0.13, 0.13, 1)` | 617, 614-615 |
| stylebox | read_only | read_only | shared `sb` from LineEdit (line 620-621: `bg_color = Color(0,0,0,0.2) if dark_theme else Color(1,1,1,0.5)`) | `Color(0,0,0,0.2)` (dark) | 623, 620-621 |

**Per-class notes:**
- TextEdit shares its 3 styleboxes (`focus`, `normal`, `read_only`) verbatim with LineEdit (same `sb` variable, same construction) — upstream constructs the stylebox once and assigns to both classes simultaneously (lines 611-612 / 616-617 / 622-623 paired).
- **Zero colors and zero constants** set on TextEdit. The full TextEdit theming surface (line/background colors, caret_color, selection_color, font_selected_color, font_readonly_color, font_placeholder_color, line_height, search_result_*, code_completion_*, indent_guide_color, etc.) — ALL NOT set. Engine defaults applied. This is a substantial deliberate omission per D-12; CodeEdit (NeoCade-additive) inherits from TextEdit and would inherit all of this gap.
- Upstream font (`font`), font_size are NOT set on TextEdit — engine-default font / size, which means TextEdit text rendering relies on the engine's built-in font scaled by EDSCALE. Pitfall: NeoCade must explicitly set `font` + `font_size` on TextEdit (and CodeEdit additive) for stable runtime rendering across export targets.
- **Editor-font usage:** Upstream's GDScript at lines 432-462 (extracted via grep) sets `Editor`-class `font` / `bold_font` / `italic_font` slots — these are editor-only `Editor` aggregator slots, NOT user-facing `TextEdit` slots. NeoCade's `TextEdit` font path goes through Phase 4's typography decision (Inter for monoscale text, Outfit for display).

### ItemList

**Gloss:** Godot's `ItemList` Control — selectable list of items with optional icons. Used for asset library, scene tree's recent-files panel, palette pickers.

**Upstream entry count:** 11 total set_* calls (1 color, 1 constant, 9 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | guide_color | (n/a) | `Color.TRANSPARENT` | `Color(0,0,0,0)` | 574 |
| constant | v_separation | (n/a) | `int(base_margin * 1.5 * scale)` | `6` (base_margin=4, scale=1) — EDSCALE-derived | 575 |
| stylebox | cursor | cursor | local `sb` (line 577-578: `base_sb.duplicate()`, `bg_color = color_mono * Color(1,1,1,0.04)`) | bg ≈ `Color(1,1,1,0.04)` (subtle white tint over base) | 579, 577-578 |
| stylebox | cursor_unfocused | cursor (unfocused) | same `sb` as cursor | (same) | 580, 577-578 |
| stylebox | focus | focus | `base_empty_sb` | (transparent — Pitfall 1.1 evidence; focus relies on font color) | 581, 161-163 |
| stylebox | hovered | hover | `flat_button_hover_sb` | (per dict; bg=`color_button_normal`, narrow vertical margin) | 583, 148-153 |
| stylebox | selected | selected | `flat_button_hover_sb` | (same — selected and hovered visually identical) | 584, 148-153 |
| stylebox | selected_focus | selected+focus | `flat_button_hover_sb` | (same) | 585, 148-153 |
| stylebox | hovered_selected | hovered+selected | `flat_button_hover_sb` | (same) | 586, 148-153 |
| stylebox | hovered_selected_focus | hovered+selected+focus | `flat_button_hover_sb` | (same) | 587, 148-153 |
| stylebox | panel | (panel) | local `sb` (line 589-590: `base_sb.duplicate()`, `set_content_margin_all(base_margin * 2 * scale)`) | bg = base_color, content_margin = 8 (EDSCALE) | 591, 589-590 |

**Per-class notes:**
- Upstream collapses 5 distinct combined-states (`hovered`, `selected`, `selected_focus`, `hovered_selected`, `hovered_selected_focus`) onto the **same `flat_button_hover_sb` stylebox**. Visually, hover and selected look identical; focus indication is overlay-only (Pitfall 1.1 evidence). NeoCade should consider whether selected should look distinct from hover (e.g., accent-tinted fill) — Phase 5 design decision.
- `cursor` and `cursor_unfocused` styleboxes are minimal (4% white tint) — almost invisible. Upstream's design choice favors selection indication over cursor indication.
- `font_color`, `font_selected_color`, `font_hovered_color`, `font_outline_color`, `outline_size` NOT set — engine defaults. Plan 03 D-12 omissions list will include these.
- **Type variation: ItemListSecondary** — line 1000 sets `panel` stylebox using the sidebar `sb` (color_surface_low bg). NeoCade FEATURES.md does not currently include an ItemListSecondary TYPEVAR; documented for completeness (potential v1.x).

### TabBar

**Gloss:** Godot's `TabBar` Control — horizontal row of tabs (used standalone or as part of TabContainer). Each tab is selectable; one is currently-selected.

**Upstream entry count:** 13 total set_* calls (8 color, 5 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_selected_color | selected | `color_font_normal` | `Color(1,1,1,0.7)` | 828, 81 |
| color | font_hovered_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 830, 83 |
| color | font_unselected_color | unselected | `color_font_secondary` = `color_mono_font * Color(1,1,1,0.45)` | `Color(1,1,1,0.45)` | 832, 82 |
| color | font_disabled_color | disabled | `color_font_dimmed * Color(1,1,1,0.55)` | `Color(1,1,1, ~0.193)` (0.35 × 0.55) | 834, 84 |
| color | icon_selected_color | selected | `color_font_normal` | `Color(1,1,1,0.7)` | 837, 81 |
| color | icon_hovered_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 839, 83 |
| color | icon_unselected_color | unselected | `color_font_secondary` | `Color(1,1,1,0.45)` | 841, 82 |
| color | icon_disabled_color | disabled | `color_font_dimmed * Color(1,1,1,0.55)` | `Color(1,1,1, ~0.193)` | 843, 84 |
| stylebox | tab_selected | selected | local `sb` (line 846-850: `base_sb.duplicate()`, `_set_margin(sb, 16, ~8.4, 16, ~8.4)`, `set_corner_radius_all(0)` then `corner_radius_top_left = corner_radius_top_right = int(corner_radius * scale)`) | bg = base_color, top corners only rounded (4 EDSCALE), bottom corners square — visually "pinned" to panel below | 851, 846-850 |
| stylebox | tab_focus | focus | `base_empty_sb` | (transparent — Pitfall 1.1 evidence) | 859, 161-163 |
| stylebox | tab_unselected | unselected | local `sb = sb.duplicate()` from tab_selected, then `bg_color = color_surface_lowest`, `set_border_width_all(0)` (line 863-865) | bg ≈ `Color(0.10,0.10,0.10,1)` (surface_lowest), no border, top corners rounded | 866, 863-865 |
| stylebox | tab_disabled | disabled | same `sb` as tab_unselected (line 870 reuses) | (same as tab_unselected — disabled visually = unselected) | 870, 863-865 |
| stylebox | tab_hovered | hover | local `sb = sb.duplicate()` from tab_unselected, then `bg_color = color_surface_base * Color(1,1,1,0.8)` (line 874-875) | bg ≈ `Color(0.21,0.21,0.21,0.8)` (surface_base × 0.8 alpha) | 876, 874-875 |

**Per-class notes:**
- 8 colors paired (4 font / 4 icon — same role per state). The font and icon color tracks move together.
- Tab styleboxes share the `_set_margin(sb, 16, 8.4, 16, 8.4)` pattern — wide horizontal padding, moderate vertical (`base_margin * 4` horizontal, `base_margin * 2.1` vertical). Tabs are visually substantial.
- **Top-only corner rounding** is the visual signature: tabs round at top (next to panel above) but square at bottom (flush to panel below). NeoCade Phase 5 should preserve this — squaring the bottom is what makes a tab "feel docked."
- `font` (typeface), `font_size`, `font_outline_color`, `outline_size`, `font_outline_size`, `h_separation`, `icon_separation` NOT set — engine defaults. Plan 03 D-12 omissions.
- **Tab buttons** (`increment`, `decrement`, `increment_highlight`, `decrement_highlight`, `drop_mark`, `close`, `close_pressed`) — these icons are NOT set. Engine defaults used. NeoCade's icon set design (Phase 4 ICON-*) needs to cover these.
- `button_pressed` / `button_highlight` slots NOT set.

### TabContainer

**Gloss:** Godot's `TabContainer` Control — TabBar + content panel + tab-switching. Top-level "tabbed pages" layout.

**Upstream entry count:** 15 total set_* calls (8 color, 7 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | font_selected_color | selected | `color_font_normal` | `Color(1,1,1,0.7)` | 829, 81 |
| color | font_hovered_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 831, 83 |
| color | font_unselected_color | unselected | `color_font_secondary` | `Color(1,1,1,0.45)` | 833, 82 |
| color | font_disabled_color | disabled | `color_font_dimmed * Color(1,1,1,0.55)` | `Color(1,1,1, ~0.193)` | 835, 84 |
| color | icon_selected_color | selected | `color_font_normal` | `Color(1,1,1,0.7)` | 838, 81 |
| color | icon_hovered_color | hover | `color_font_highlighted` | `Color(1,1,1,1)` | 840, 83 |
| color | icon_unselected_color | unselected | `color_font_secondary` | `Color(1,1,1,0.45)` | 842, 82 |
| color | icon_disabled_color | disabled | `color_font_dimmed * Color(1,1,1,0.55)` | `Color(1,1,1, ~0.193)` | 844, 84 |
| stylebox | tab_selected | selected | shared `sb` from TabBar (lines 846-850; same construction) | (same as TabBar.tab_selected) | 852, 846-850 |
| stylebox | tab_focus | focus | `base_empty_sb` | (transparent) | 860, 161-163 |
| stylebox | tab_unselected | unselected | shared `sb` from TabBar | (same as TabBar.tab_unselected) | 867, 863-865 |
| stylebox | tab_disabled | disabled | shared `sb` from TabBar | (same as TabBar.tab_unselected — visual collapse) | 871, 863-865 |
| stylebox | tab_hovered | hover | shared `sb` from TabBar | (same as TabBar.tab_hovered) | 877, 874-875 |
| stylebox | panel | (panel) | local `sb` (line 880-884: `base_sb.duplicate()`, `set_content_margin_all(increased_margin * 1.5 * scale)`, `set_corner_radius_all(0)` then `corner_radius_bottom_right = corner_radius_bottom_left = int(corner_radius * scale)`) | bg = base_color, BOTTOM corners only rounded — mirrors tab top-rounding to form a "tabbed card" visual | 885, 880-884 |
| stylebox | tabbar_background | (tabbar) | local `sb` (line 891-895: `base_sb.duplicate()`, `bg_color = color_surface_lowest`, `corner_radius_bottom_left = corner_radius_bottom_right = 0`, `_set_margin(sb, 0, 1, 4, 0)`) | bg ≈ `Color(0.10,0.10,0.10,1)` (surface_lowest), only top corners rounded | 896, 891-895 |

**Per-class notes:**
- TabContainer **shares all 5 tab_* styleboxes with TabBar** (same `sb` constructions at lines 846-850 / 863-865 / 874-875). Plus 2 TabContainer-only styleboxes: `panel` (the content area below tabs) and `tabbar_background` (the tab strip behind the tabs).
- `panel` rounds BOTTOM corners; `tab_selected` rounds TOP corners. Together they form a continuous "tabbed card" — the selected tab's bottom edge bleeds into the panel's top edge.
- 8 colors paired (4 font / 4 icon) — identical to TabBar's color matrix.
- `tabbar_background` uses `surface_lowest` bg — visually the tab strip is the *darkest* surface, with selected tab popping forward to `base_color`.
- `side_margin`, `icon_max_width`, `font_size`, `font_outline_size`, `outline_size`, `h_separation`, `icon_separation` NOT set — engine defaults. Plan 03 D-12 omissions.
- **Type variation: TabContainerOdd** — lines 857, 861, 868, 872, 878, 889, 897 (7 set_*). Specializes 5 tab_* styleboxes + panel + tabbar_background by re-coloring with `color_surface_base` (panel) or `color_surface_lower` (tab_unselected/disabled). Used by upstream editor for the secondary inspector tabs to differentiate odd-row TabContainers from even ones. NeoCade FEATURES.md does NOT include TabContainerOdd; documented for completeness.
- **Type variation: TreeSecondary, ItemListSecondary** — also reference via line 999/1000 for shared sidebar visual; documented under Tree / ItemList sections.

### Tree

**Gloss:** Godot's `Tree` Control — hierarchical row-based data view with collapsible parents. The most theme-complex Control in Godot's set; powers Inspector, Scene Tree, Filesystem dock.

**Upstream entry count:** 30 total set_* calls (4 color, 8 constant, 18 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| color | drop_position_color | (n/a) | `color_font_dimmed` | `Color(1,1,1,0.35)` | 901, 84 |
| color | font_color | normal | `color_font_normal` | `Color(1,1,1,0.7)` | 902, 81 |
| color | guide_color | (n/a) | `Color.TRANSPARENT` | `Color(0,0,0,0)` | 903 |
| color | parent_hl_line_color | (n/a) | `color_mono * Color(1,1,1, relationship_line_opacity)` | `Color(1,1,1, 0.5)` (relationship_line_opacity default 0.5) | 904, 34 |
| constant | children_hl_line_width | (n/a) | literal `0` | `0` | 905 |
| constant | draw_guides | (n/a) | literal `0` (false) | `0` | 906 |
| constant | draw_relationship_lines | (n/a) | literal `1` (true) | `1` | 907 |
| constant | inner_item_margin_left | (n/a) | `int(base_margin * scale)` | `4` (EDSCALE-derived) | 908 |
| constant | inner_item_margin_right | (n/a) | `int(base_margin * scale)` | `4` (EDSCALE-derived) | 909 |
| constant | parent_hl_line_width | (n/a) | `int(ceilf(scale))` | `1` (EDSCALE-derived) | 910 |
| constant | relationship_line_width | (n/a) | literal `0` | `0` | 911 |
| constant | v_separation | (n/a) | `tree_v_separation = int(pow(base_margin * 0.2 * scale, 3))` | `0` (4 × 0.2 = 0.8, 0.8^3 ≈ 0.512, int = 0) — effectively zero v_separation | 914, 913 |
| stylebox | panel | (panel) | local `empty_sb` (line 920-921: `base_empty_sb.duplicate()`, `_set_margin(empty_sb, 6, 10, 6, 10)`) | (transparent panel; asymmetric margins favoring vertical for tall lists) | 922, 920-921 |
| stylebox | focus | focus | `base_empty_sb` | (transparent — Pitfall 1.1) | 926, 161-163 |
| stylebox | title_button_hover | (header hover) | local `sb` (line 928-934: `base_sb.duplicate()`, `bg_color = color_surface_lowest`, `border_width_left = border_width_right = int(ceilf(scale))`, `border_color = sb.bg_color * Color(1,1,1,0)` — transparent border for column-title separation) | bg ≈ `Color(0.10,0.10,0.10,1)`; left/right borders 1 EDSCALE wide, fully transparent | 936, 928-934 |
| stylebox | title_button_normal | (header) | same `sb` as title_button_hover | (same) | 937, 928-934 |
| stylebox | title_button_pressed | (header pressed) | same `sb` | (same) | 938, 928-934 |
| stylebox | button_hover | hover | local `sb` (line 940-942: `flat_button_hover_sb.duplicate()`, `set_content_margin_all(0)`, `bg_color = color_button_disabled`) | bg ≈ `Color(0.31,0.31,0.31,1)` (button_disabled), zero margin | 943, 940-942 |
| stylebox | hover | hover | same `sb` | (same) | 944, 940-942 |
| stylebox | hovered_dimmed | (n/a) | same `sb` | (same) | 945, 940-942 |
| stylebox | custom_button_hover | hover | same `sb` | (same) | 946, 940-942 |
| stylebox | hovered | hover | same `sb` | (same) | 947, 940-942 |
| stylebox | selected | selected | same `sb` | (same — selected = hovered visually) | 948, 940-942 |
| stylebox | selected_focus | selected+focus | same `sb` | (same) | 949, 940-942 |
| stylebox | hovered_selected | hovered+selected | local `sb = sb.duplicate()` then `bg_color = color_button_normal` (line 951-952) | bg ≈ `Color(0.34,0.34,0.34,1)` (button_normal — slightly brighter than disabled) | 953, 951-952 |
| stylebox | hovered_selected_focus | hovered+selected+focus | same `sb` | (same) | 954, 951-952 |
| stylebox | button_pressed | pressed | local `sb` (line 956-957: `flat_button_pressed_sb.duplicate()`, `_set_margin(sb, 4, 0, 4, 0)`) | bg = `color_button_hover`, narrow zero-vertical margin | 958, 956-957 |
| stylebox | custom_button_pressed | pressed | same `sb` | (same) | 959, 956-957 |
| stylebox | cursor | cursor | local `sb` (line 962-963: `base_sb.duplicate()`, `bg_color = color_mono * Color(1,1,1,0.04)` — transparent cursor overlay drawn on top of item) | bg ≈ `Color(1,1,1,0.04)` | 964, 962-963 |
| stylebox | cursor_unfocused | cursor (unfocused) | same `sb` | (same) | 965, 962-963 |

**Per-class notes:**
- **Three stylebox tiers** — title_button (header), button/hover/selected/hovered (list rows; multiple slots collapse to ONE stylebox), hovered_selected (the brighter "still in selection" row state), button_pressed / custom_button_pressed (pressing an inline button on a tree item), cursor / cursor_unfocused (transparent overlay).
- **State-collapse pattern reaches its peak here** — `button_hover`, `hover`, `hovered_dimmed`, `custom_button_hover`, `hovered`, `selected`, `selected_focus` all map to the SAME stylebox. Upstream's design philosophy: minimize visual noise on tree rows. NeoCade Phase 5 should consider whether tree-row state should differentiate more — accessibility may require it.
- `tree_v_separation = int(pow(base_margin * 0.2 * scale, 3))` (line 913): with base_margin=4, scale=1, this evaluates to `pow(0.8, 3) = 0.512`, `int(0.512) = 0`. So `v_separation = 0`. **Trees have ZERO vertical separation between rows.** This is intentional for dense data display; NeoCade may want to revisit for accessibility (target row tappability on touch).
- Comment at lines 916-919: "Using empty stylebox for trees to avoid drawing unnecessary borders in docks. Note that using opaque color that is the same as dock background doesn't work because EditorPropertyResource is using Tree panel stylebox to draw its background as well." — explicit acknowledgment of editor-coupling that NeoCade does NOT inherit (D-05); NeoCade's Tree panel can be opaque if Phase 5 design wants.
- Comment at lines 924-925: "Leaving focus empty for trees and scroll containers because there's no way to make focus indication look not janky when only a part of a dock is highlighted" — Pitfall 1.1 evidence for Plan 03.
- Comment at line 961: "Cursor is drawn on top of the item so it needs to be transparent" — Tree cursor stylebox must be a transparent overlay because Godot draws it ABOVE the row's stylebox; opaque cursor would hide row contents.
- Slots NOT set: `arrow`, `arrow_collapsed`, `select_arrow`, `checked`, `unchecked`, `indeterminate`, `updown` icons; `font`, `font_size`, `title_button_font`, `font_outline_color`, `outline_size`, `font_outline_size`, `font_selected_color`, `relationship_line_color`, `children_hl_line_color`, `custom_button_font_*`, `item_margin`, `button_margin`, `scroll_border`, `scroll_speed` constants. Plan 03 D-12 omissions.
- **Type variation: TreeSecondary** — line 999 sets `panel` stylebox using sidebar `sb` (color_surface_low bg). Used by editor's docks. NeoCade FEATURES.md does not include TreeSecondary; documented for completeness.

### ProgressBar

**Gloss:** Godot's `ProgressBar` Control — horizontal indeterminate-or-determinate progress indicator. Used by editor for asset import, build progress, etc.

**Upstream entry count:** 2 total set_* calls (2 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | background | (background) | local `sb` (line 762-768: `base_sb.duplicate()`, `bg_color = color_surface_lowest`, `expand_margin_top = expand_margin_bottom = base_margin * 0.5 * scale`, `set_content_margin_all(base_margin * scale)`, conditional `_set_border(sb, color_extra_border_dimmed, 1)` if `draw_extra_borders`) | bg ≈ `Color(0.10,0.10,0.10,1)` (surface_lowest); top/bottom expand_margin = 2 (EDSCALE), content_margin = 4 | 769, 762-768 |
| stylebox | fill | (fill) | local `sb = sb.duplicate()` from background, `bg_color = color_button_normal`, conditional `_set_border(sb, color_extra_border, 1)` if `draw_extra_borders` | bg ≈ `Color(0.34,0.34,0.34,1)` (button_normal — same fill color as a normal Button) | 775, 771-774 |

**Per-class notes:**
- 2 styleboxes only — `background` (the track) and `fill` (the filled portion). Upstream uses **the same color as a normal Button** for the fill, treating progress as "an animated button growing across the track." Subtle but cohesive.
- `expand_margin_top` / `expand_margin_bottom` of `0.5 * base_margin = 2` EDSCALE units make the background slightly "fatter" than its content area — gives the rounded rectangle a slight vertical breathing room.
- `font`, `font_color`, `font_size`, `font_outline_color`, `outline_size`, `font_outline_size` NOT set — engine defaults. ProgressBar typically doesn't render text overlay in the editor; if a NeoCade game shows percentage labels, font theming becomes additive coverage.

### HSlider

**Gloss:** Godot's `HSlider` Control — horizontal slider with grabber. Used for editor sliders (camera FOV, audio levels) and game runtime controls.

**Upstream entry count:** 1 total set_* call (1 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | slider | (track) | local `sb` (line 985-987: `base_sb.duplicate()`, `bg_color = color_mono_inv * Color(1,1,1,0.35)`, `_set_margin(sb, 0, 2, 0, 2)`) | bg ≈ `Color(0,0,0,0.35)` (color_mono_inv = BLACK in dark_theme; 35% alpha) — semi-transparent dark track | 988, 985-987 |

**Per-class notes:**
- ONLY the `slider` (track) stylebox is set. `grabber_area`, `grabber_area_highlight`, `grabber_disabled` styleboxes NOT set — engine defaults.
- `grabber`, `grabber_highlight`, `grabber_disabled` ICONS NOT set — engine-default circular grabber.
- `tick` icon NOT set — engine default.
- `center_grabber`, `grabber_offset` constants NOT set — engine defaults.
- **Heavy reliance on engine defaults** — upstream invests almost nothing in slider theming. NeoCade's REQUIREMENTS.md may require more extensive slider theming (accessible touch targets, accent-colored grabber per ARCHITECTURE.md focus model).

### VSlider

**Gloss:** Godot's `VSlider` Control — vertical slider with grabber. Used in audio bus volume meters and similar vertical controls.

**Upstream entry count:** 1 total set_* call (1 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | slider | (track) | local `sb = sb.duplicate()` from HSlider, `_set_margin(sb, 2, 0, 2, 0)` (rotated margin from HSlider) | bg ≈ `Color(0,0,0,0.35)` (same as HSlider, rotated margins) | 991, 989-990 |

**Per-class notes:**
- Constructed by **rotating HSlider's margins**: HSlider has `_set_margin(sb, 0, 2, 0, 2)` (vertical breathing room around horizontal track); VSlider has `_set_margin(sb, 2, 0, 2, 0)` (horizontal breathing room around vertical track). Identical bg_color, identical bordering, just transposed margins.
- Same engine-default slots as HSlider — `grabber*` styleboxes/icons, `tick`, `center_grabber`, `grabber_offset` all NOT set.
- NeoCade should mirror this rotation pattern when designing slider styleboxes — share construction, transpose orientation.

### HScrollBar

**Gloss:** Godot's `HScrollBar` Control — horizontal scrollbar with grabber. Used by ScrollContainer for horizontal overflow.

**Upstream entry count:** 5 total set_* calls (5 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | grabber | normal | local `sb` (line 791-793: `base_sb.duplicate()`, `bg_color = _get_base_color(0.5, 0.6)`, `_set_border(sb, base_color * Color(1,1,1,0), 3)` — 3-EDSCALE transparent border) | bg ≈ `Color(0.43, 0.43, 0.43, 1)` (V≈ +0.163 from base, sat × 0.6); transparent 3px border (acts as inset margin) | 795, 791-793 |
| stylebox | grabber_highlight | hover | local `sb = base_sb.duplicate()` (line 798-800: `bg_color = _get_base_color(1.4, 0.5)`, `_set_border(sb, base_color * Color(1,1,1,0), 2.5)`) | bg ≈ `Color(0.61, 0.61, 0.61, 1)` (V≈ +0.455 from base, sat × 0.5 — much brighter on hover); transparent 2.5px border | 802, 798-800 |
| stylebox | grabber_pressed | pressed | same `sb` as grabber_highlight | (same — pressed = hover visually) | 804, 798-800 |
| stylebox | scroll | (track) | local `empty_sb` (line 807-810: `base_empty_sb.duplicate()`, `_set_margin(empty_sb, 0, margin, 0, margin)` where `margin = 12 if increase_scrollbar_touch_area else 6`) | (transparent track; vertical content_margin = 6 normally, 12 on touchscreens) — see `enable_touch_optimizations` notes | 812, 807-810 |
| stylebox | scroll_focus | focus | same `empty_sb` as scroll | (same — focus = scroll visually; Pitfall 1.1) | 813, 807-810 |

**Per-class notes:**
- **Touch-optimization conditional:** Lines 38-44 (Globals section) read `increase_scrollbar_touch_area` based on engine-version-conditional `enable_touch_optimizations`. With touch enabled, scrollbar `scroll` stylebox margins double from 6 to 12 EDSCALE units, making the touch target larger. NeoCade has a separate mobile theme variant (`neocade_mobile_theme.tres`, Phase 8-9), so this runtime conditional is dropped in favor of fixed mobile-vs-desktop margins.
- Track (`scroll` / `scroll_focus`) is transparent; visual exists only via the grabber. Compare to NeoCade's likely design: explicit visible track for accessibility.
- Grabber-pressed uses SAME stylebox as grabber-highlight (line 802 = line 804 source `sb`). Pressing doesn't visually distinguish from hovering — acceptable for scrollbar (most users grab + drag without noticing the press transition).
- `decrement`, `increment`, `decrement_highlight`, `increment_highlight`, `decrement_pressed`, `increment_pressed` ICONS NOT set — engine-default arrows. Plan 03 D-12 omissions.

### VScrollBar

**Gloss:** Godot's `VScrollBar` Control — vertical scrollbar with grabber. Used by ScrollContainer for vertical overflow (the typical use case).

**Upstream entry count:** 5 total set_* calls (5 stylebox).

| Slot Kind | Slot Name | State | Formula (symbolic) | Snapshot @ defaults | Source line(s) |
|-----------|-----------|-------|--------------------|---------------------|----------------|
| stylebox | grabber | normal | shared `sb` from HScrollBar (line 791-793: `_get_base_color(0.5, 0.6)`, transparent 3-EDSCALE border) | (same as HScrollBar.grabber) | 796, 791-793 |
| stylebox | grabber_highlight | hover | shared `sb` from HScrollBar (line 798-800: `_get_base_color(1.4, 0.5)`, transparent 2.5-EDSCALE border) | (same as HScrollBar.grabber_highlight) | 803, 798-800 |
| stylebox | grabber_pressed | pressed | same `sb` as grabber_highlight | (same) | 805, 798-800 |
| stylebox | scroll | (track) | local `empty_sb = empty_sb.duplicate()` from HScrollBar (line 815-816: rotates margin → `_set_margin(empty_sb, margin, 0, margin, 0)`) | (transparent track; horizontal content_margin = 6/12, see HScrollBar notes) | 818, 815-816 |
| stylebox | scroll_focus | focus | same `empty_sb` as scroll | (same) | 819, 815-816 |

**Per-class notes:**
- VScrollBar **shares all 3 grabber styleboxes verbatim with HScrollBar** (single `sb` construction at lines 791-793 / 798-800 used for both classes). Track is rotated like HSlider/VSlider (horizontal margin vs vertical margin).
- `enable_touch_optimizations` conditional (lines 38-44 Globals) — same touch-area dynamic as HScrollBar; NeoCade uses fixed mobile theme variant instead.
- Same engine-default omissions as HScrollBar (decrement/increment icons, etc.).








## Engine-Default Cross-Reference and Pitfall Confirmations

> This section is appended by **Plan 03 (default_theme.cpp omission cross-reference + Pitfall 1.1 / 1.7 confirmation/refutation)**. Heading reserved here for ordering only.
