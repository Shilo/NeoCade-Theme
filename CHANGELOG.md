# Changelog

All notable changes to NeoCade Theme are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed (style architecture)

- Replaced the five separate direction resources with one canonical
  `res://addons/neocade_theme/neocade_theme.tres` resource.
- Added `NeoCadeTheme.Style` with `BUBBLE`, `BURST`, `DAYBREAK`, `PULSE`,
  `SLATE`, and `CUSTOM`. Selecting a built-in style applies the matching
  exported direction values and regenerates the theme once.
- Direction personality now resolves from the explicit `style` export instead
  of an implicit `base_color` hex lookup.
- `NeoCadeThemeOptionButton` now lists built-in styles from `NeoCadeTheme`
  rather than scanning for multiple theme files. The optional `None` entry
  still applies a null theme and `theme_selected(theme, index)` is preserved.
- The showcase now applies `res://addons/neocade_theme/neocade_theme.tres`
  and uses Pulse as its starter style.

### Changed (cleanup)

- Runtime addon folder now contains only Godot-consumed addon assets plus the
  required bundled-font OFL file. Package docs now live outside the addon:
  `README.md`, `docs/usage.md`, `CHANGELOG.md`, `LICENSE.md`, and `VERSION`.
- Mobile implementation notes moved out of the root into
  `.planning/MOBILE-DESIGN-SPEC.md`.
- Removed `CONTRIBUTING.md`; this repo is not expecting external contribution
  workflow yet.
- Inter OFL text moved beside the redistributed font as
  `addons/neocade_theme/fonts/inter_ofl.txt`.
- Duplicate Body and Caption FontVariation resources were removed; both now
  reuse the imported Inter FontFile directly and differ by Theme font-size
  entries.
- Removed unused `check.svg` and its import sidecar from the icon set.
- Moved the live showcase into `res://showcase/showcase.tscn`.

### Added (Phase 9 — Showcase)

- Editor-authored `res://showcase/showcase.tscn` showcase implemented with nine sections: Buttons,
  Text Inputs, Numbers & Range, Selection & Lists, Containers & Layout,
  Dialogs & Popups, Advanced & Graph, Token Gallery, and Coverage 37/37.
- Reusable `NeoCadeThemeOptionButton` dropdown-only script at
  `res://addons/neocade_theme/scripts/neocade_theme_option_button.gd`; it lists
  built-in NeoCade styles alphabetically, appends optional `None`, applies
  selection to an exported target or scene root, and emits
  `theme_selected(theme, index)` after applying a theme.
- `res://showcase/showcase.gd` handles the scoreboard Window button and
  `close_requested` signal without constructing the showcase UI at runtime.
- BBCode demo with bold/color/italic/code markup, multi-script label sample,
  token swatches, type samples, radius scale, and coverage verification strip.
- `accessibility_name` metadata wiring on serialized interactive showcase
  Controls.
- `export_presets.cfg` with Web, Windows, Linux, macOS, Android, and iOS named
  presets for QA and release automation.

### Added (Phase 10 — QA package)

- Static QA reports for contrast, focus, coverage, export readiness,
  fresh-install dry-run checklist, and deferred manual/device UAT matrix.
### Added (Phase 11 — Distribution)

- GitHub Actions release workflow for one-click manual releases: CI import,
  showcase open, version bump, changelog slice extraction, addon archive,
  Web showcase export, GitHub Pages deployment, and GitHub Release publication.

### Added (Phase 4 — Foundation)

- Single concrete `@tool class_name NeoCadeTheme extends Theme` class
  (`addons/neocade_theme/scripts/neocade_theme.gd`) with 10 `@export` properties:
  - Top level: `style`, `raised`, `platform`
  - Style Overrides group: `base_color`, `accent_color`, `corner_radius`,
    `spacing`, `raised_strength`, `focus_thickness`, `outline_width`
- One canonical direction/style `.tres` file at addon root:
  `neocade_theme.tres`.
- Inter Variable Roman font (PINNED to Inter v4.0;
  SHA256: `746431E950FD28D29B0189D708D4A5852A8458EDB3184387EADCEE9E5E34676C`)
  bundled at `fonts/inter_variable.ttf` with Grayscale AA + Light hinting +
  Auto subpixel + Mipmaps import settings (per GL Compatibility renderer
  constraints).
- 3 FontVariation `.tres` resources covering the weighted header scale:
  HeaderLarge (wght=800, opsz=32), HeaderMedium (wght=700, opsz=32), and
  HeaderSmall (wght=600, opsz=24). Body-weight and Caption entries reuse the
  imported `inter_variable.ttf` FontFile directly; Caption differs by font size.
- 9 bespoke monochrome SVG Button-family icons at `icons/`:
  checkbox_checked, checkbox_unchecked, radio_checked, radio_unchecked,
  checkbutton_checked, checkbutton_unchecked, arrow_down, clear, close —
  all 32×32 reference, Scale=2.0 + Linear With Mipmaps import.
  (Cycle 6 F4 fix 2026-05-06: was `toggle_on`/`toggle_off`; renamed to
  `checkbutton_checked`/`checkbutton_unchecked` to match Godot 4.6
  CheckButton's `checked`/`unchecked` icon slot names per
  class_checkbutton.md. 6 disabled/mirrored CheckButton variants deferred
  to v1.x.)
- SIL OFL 1.1 license text + Inter Reserved Font Name notice in
  `fonts/inter_ofl.txt`.
- Dynamic `_regenerate_theme()` engine that walks BINDING_TABLE covering
  all 37 canonical scorecard Godot 4.6 Control types (Cross-AI Cycle 2 L3
  fix: list trimmed to the canonical 37 from
  MINIMAL-THEME-COVERAGE-DELTA.md; previously included non-canonical
  entries that are container-chrome or Phase 6/7 polish, not Phase 4
  baseline): AcceptDialog, Button, CheckBox, CheckButton, CodeEdit,
  ColorPicker, ColorPickerButton, ConfirmationDialog, FileDialog,
  FoldableContainer, GraphEdit, HScrollBar, HSlider, HSplitContainer,
  ItemList, Label, LineEdit, LinkButton, MenuBar, MenuButton, OptionButton,
  Panel, PopupMenu, PopupPanel, ProgressBar, RichTextLabel, SpinBox, TabBar,
  TabContainer, TextEdit, TooltipLabel, TooltipPanel, Tree, VScrollBar,
  VSlider, VSplitContainer, Window.
- 14 type variations registered with explicit fonts (PITFALLS 1.2;
  Cross-AI Cycle 1 C4 fix: CodeLabel included): PrimaryButton /
  SecondaryButton / GhostButton / DangerButton / IconButton / FlatButton /
  HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel /
  InfoText / CardPanel / HeroPanel.
- `is_light` flag derived from `base_color.get_luminance() >= 0.5`;
  surface ramp + state layers + text colors flip on `is_light` per
  DESIGN_TOKENS §6.4.
- Hard-offset shadow raised mode (`raised = true` produces
  `shadow_size = raised_strength`, `shadow_offset = (0, raised_strength)`,
  no blur); flat mode sets `shadow_size = -1` (no shadow).
- `Platform.AUTO` resolves at runtime via `OS.has_feature("mobile")`.

### Fixed (Phase 4 post-review, 2026-05-06)

- **BL-01 (font bundle bloat)**: removed `fonts/inter_variable.tres` and
  repointed the FontVariation `.tres` files + the class's `default_font`
  preload to `fonts/inter_variable.ttf` directly (Godot 4 imports `.ttf` as
  a `FontFile` resource via the `.import` sidecar). Bundle size dropped
  from ~2.0 MB back to ~857 KB, matching the FONT-REVIEW.md ~810 KB pledge.
  The previous `.tres` round-trip was inlining the Inter binary as a
  `PackedByteArray`, shipping the font twice.
- **Font resource cleanup**: removed duplicate Body and Caption FontVariation
  resources (`wght=400` on both). Body-weight and Caption entries now reuse
  the imported Inter FontFile directly, with size differences handled by
  Theme font-size entries.
- **BL-02 (RichTextLabel slot-name typo)**: changed
  `set_font("font", "InfoText", body_font)` to
  `set_font("normal_font", "InfoText", body_font)` at
  `neocade_theme.gd:189`. RichTextLabel reads `normal_font` (not `font`),
  so the explicit per-variation font set was previously silently dropped
  and InfoText fell back to `theme.default_font`.
- Verifier helper: switched `Color != Color` strict equality to hex-string
  comparison (`to_html(false).to_upper()`) since `.tres` serializer
  truncates floats to 7 digits and loaded values don't byte-equal
  in-code-constructed `Color("#hex")` literals.

### Notes (v1.0.0 limitations preserved)

- **No italic glyphs ship in v1.** Inter Italic Variable is deferred to v1.x.
  Consumers requiring italics use Godot's synthetic italic transform via
  `FontVariation.transform = Transform2D(...)` or `font_italic` Theme slot
  where applicable. (FONT-07 deferred per UD-4 Option D.)
- **No CJK font bundled in v1.** Consumers needing CJK script support
  append a CJK font (e.g., system Noto Sans CJK) to a duplicated theme's
  `default_font.fallbacks`. See README "CJK / non-Latin scripts" section.
  (FONT-09(a) override pattern; UD-2 default behavior.)
- **No `plugin.cfg`.** This is NOT an editor plugin — consumers preload the
  canonical theme directly via
  `preload("res://addons/neocade_theme/neocade_theme.tres")`.
  (STACK Decision 5; CONTEXT.md D-05.)
- **No light mode in v1.** Light surface palettes are forward-compat-flagged
  via the `is_light` field but the v1 directions all ship with dark base
  colors. (Deferred to v2.)
- **No EditorInspectorPlugin in v1.** Theme authoring is via Theme Editor
  and `@export` properties; no per-slot inspector helper. (Deferred
  indefinitely; revisit if/when human artists join authoring.)
- **Binding mechanism (slot-name + property-name table compiled into
  `neocade_theme.gd`) is REVISABLE.** See class-header docstring +
  CONTEXT.md D-03; future v1.x may switch to a property-name convention
  or metadata-tagged Resource model without breaking the public `@export`
  surface or `.tres` file format.

### Out of scope (v1)

- Light mode + alternate palettes (deferred to v2).
- Asset Library submission — REJECTED for v1 (DIST-05 stricken); v1 ships
  GitHub-Releases-only.
