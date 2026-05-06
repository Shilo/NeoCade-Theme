---
phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
plan: 08
type: execute
wave: 4
depends_on:
  - "04-02"
files_modified:
  - addons/neocade_theme/LICENSE.md
  - addons/neocade_theme/CHANGELOG.md
  - addons/neocade_theme/VERSION
  - addons/neocade_theme/README.md
autonomous: true
requirements:
  - FOUND-01
  - FONT-04
  - FONT-07
  - FONT-09
must_haves:
  truths:
    - "`addons/neocade_theme/LICENSE.md` exists and contains the project's license body (MIT recommended; verify against project root LICENSE convention if any). Contains a copyright line for the NeoCade Theme project."
    - "`addons/neocade_theme/CHANGELOG.md` exists with `[Unreleased]` heading at the top + Phase 4 deliverables enumerated underneath. Phase 11 expands for v1.0.0."
    - "`addons/neocade_theme/CHANGELOG.md` documents the synthetic italic-transform note for FONT-07 (no italic glyphs ship in v1; consumers obtain italic via Godot's `font_italic` synthetic transform)."
    - "`addons/neocade_theme/VERSION` exists, is a single-line file containing a version string (e.g., `0.4.0` or `0.4.0-phase-4`); follows project's pre-release versioning convention."
    - "`addons/neocade_theme/README.md` exists and documents: (a) consumer pattern (`preload(\"res://addons/neocade_theme/{name}_neocade_theme.tres\")`), (b) recommended starter (Pulse), (c) custom theme authoring (`NeoCadeTheme.new()`), (d) CJK override pattern (UD-2 / FONT-09(a)), (e) **code-font override pattern** for CodeEdit / `[code]` BBCode (FONT-04 — `code_edit.add_theme_font_override(\"font\", preload(\"res://your_mono.ttf\"))`; consumers ship their preferred mono since v1 is Inter-only), (f) **synthetic italic fallback note** (FONT-07 — Inter Italic Variable not bundled in v1; consumers can use Godot's `font_italic` Theme slot or `FontVariation.transform` skew for italic emphasis), (g) binding-mechanism revisability note (per CONTEXT.md D-03 + `<specifics>`)."
    - "`addons/neocade_theme/OFL.txt` is verified present (Plan 04-02); `addons/neocade_theme/` root metadata set is complete: `OFL.txt`, `LICENSE.md`, `README.md`, `CHANGELOG.md`, `VERSION`. **No `plugin.cfg`** (per STACK Decision 5 + D-05)."
  artifacts:
    - addons/neocade_theme/LICENSE.md
    - addons/neocade_theme/CHANGELOG.md
    - addons/neocade_theme/VERSION
    - addons/neocade_theme/README.md
  key_links:
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md D-14 step 11"
    - ".planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md §11 gates 14, 15"
    - ".planning/research/STACK.md Decision 5"
    - ".planning/REQUIREMENTS.md (FOUND-01 metadata, FONT-09 CJK override)"
---

<objective>
Ship the addon's distribution metadata files and the Phase 4 minimal README that documents the consumer pattern, recommended starter, custom theme authoring, and CJK override pattern. Phase 11 expands the README to its v1 distribution form; this plan ships the minimum required for FOUND-01 + FONT-09 closure.

Purpose: complete the addon's directory structure for distribution-readiness; lock in the no-`plugin.cfg` decision (STACK Decision 5 + D-05); provide consumer onboarding documentation for Phase 9 showcase + Phase 11 distribution.
Output: 4 new metadata files at `addons/neocade_theme/` root.
</objective>

<execution_context>
@$HOME/.codex/get-shit-done/workflows/execute-plan.md
@$HOME/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-RESEARCH.md
@.planning/research/STACK.md
@addons/neocade_theme/OFL.txt

<interfaces>
This plan is parallel-eligible with Plan 04-07 (peer themes + main.tscn). Both depend on Plan 04-02 (OFL.txt) only; neither depends on Plans 04-04/05/06.

Per FOUND-01, the addon's distribution layout is:
- `addons/neocade_theme/`
  - `neocade_theme.gd` (Plan 04-01/04/05)
  - `pulse_neocade_theme.tres` (Plan 04-06)
  - `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres` (Plan 04-07)
  - `OFL.txt` (Plan 04-02)
  - `LICENSE.md` (this plan)
  - `CHANGELOG.md` (this plan)
  - `VERSION` (this plan)
  - `README.md` (this plan)
  - `fonts/` (Plan 04-02)
  - `icons/` (Plan 04-03)
  - `_phase4_verify.gd` (Plan 04-06; deleted in Phase 11)

NO `plugin.cfg`. Per STACK Decision 5 + CONTEXT.md D-05, the consumer addon is not an editor plugin; consumers preload `.tres` files directly.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Author addons/neocade_theme/LICENSE.md</name>
  <read_first>
    - .planning/PROJECT.md (project license convention if documented)
    - .planning/research/STACK.md (Decision 5 — no plugin.cfg)
  </read_first>
  <files>
    - addons/neocade_theme/LICENSE.md (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/LICENSE.md` with the MIT License body (the standard open-source convention for Godot addons distributed via GitHub Releases). If the project root has a LICENSE file with a different license, the executor MUST instead match the root convention (look for `LICENSE`, `LICENSE.md`, `LICENSE.txt` at the project root). If no root license is present, default to MIT.

    MIT License body:

    ```
    # MIT License

    Copyright (c) 2026 Shilo (NeoCade Theme contributors)

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
    THE SOFTWARE.

    ---

    **Note on Inter Variable Roman bundled at `fonts/Inter-Variable.ttf`:**
    The Inter font is licensed under the SIL Open Font License 1.1 (see `OFL.txt`),
    NOT MIT. The MIT license above covers only the NeoCade Theme code, resources,
    and bespoke icons — not the bundled font binary.
    ```

    Use PowerShell `Set-Content -Encoding UTF8`. Replace the year/holder name placeholders if the project root LICENSE specifies different conventions.
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/LICENSE.md` exists.
    - File contains `# MIT License` (or another license heading if the project root LICENSE differs).
    - File contains `Copyright (c) 2026` (or the appropriate year per project convention).
    - File contains `Permission is hereby granted` (MIT body anchor).
    - File contains `THE SOFTWARE IS PROVIDED "AS IS"` (MIT disclaimer anchor).
    - File contains a note distinguishing the MIT-licensed addon code from the OFL-licensed Inter font (SIL OFL 1.1 reference).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/LICENSE.md'; if (-not (Test-Path $p)) { throw 'LICENSE.md missing' }; $g=Get-Content -Raw $p; foreach($n in 'MIT License','Copyright (c)','Permission is hereby granted','THE SOFTWARE IS PROVIDED \"AS IS\"','Inter Variable Roman','OFL') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }"
    </automated>
  </verify>
  <done>LICENSE.md ships with MIT body + a clear note on the Inter font's separate OFL licensing.</done>
</task>

<task type="auto">
  <name>Task 2: Author addons/neocade_theme/CHANGELOG.md</name>
  <read_first>
    - .planning/REQUIREMENTS.md (Phase 4 + Phase 5+ scope for the [Unreleased] section)
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md
  </read_first>
  <files>
    - addons/neocade_theme/CHANGELOG.md (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/CHANGELOG.md` following the [Keep a Changelog](https://keepachangelog.com/) convention with `[Unreleased]` at the top:

    ```markdown
    # Changelog

    All notable changes to NeoCade Theme are documented in this file.

    The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
    and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

    ## [Unreleased]

    ### Added (Phase 4 — Foundation)
    - Single concrete `@tool class_name NeoCadeTheme extends Theme` class
      (`addons/neocade_theme/neocade_theme.gd`) with 9 `@export` properties:
      - Core: `base_color`, `accent_color`, `raised`, `platform`
      - Shape: `corner_radius`, `spacing`, `raised_strength`, `focus_thickness`,
        `outline_width`
    - 5 data-only direction `.tres` files at addon root: `pulse_neocade_theme.tres`
      (recommended starter), `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`,
      `daybreak_neocade_theme.tres`, `burst_neocade_theme.tres`.
    - Inter Variable Roman font bundled at `fonts/Inter-Variable.ttf` with
      Grayscale AA + Light hinting + Auto subpixel + Mipmaps import settings
      (per GL Compatibility renderer constraints).
    - 5 FontVariation `.tres` resources covering the M3 type scale: HeaderLarge
      (wght=800, opsz=32), HeaderMedium (wght=700, opsz=32), HeaderSmall
      (wght=600, opsz=24), Body (wght=400), Caption (wght=400).
    - 10 bespoke monochrome SVG Button-family icons at `icons/`: check,
      checkbox_checked, checkbox_unchecked, radio_checked, radio_unchecked,
      toggle_on, toggle_off, arrow_down, clear, close — all 32×32 reference,
      Scale=2.0 + Linear With Mipmaps import.
    - SIL OFL 1.1 license text + Inter Reserved Font Name notice in `OFL.txt`.
    - Dynamic `_regenerate_theme()` engine that walks BINDING_TABLE covering
      all 37 scorecard Godot 4.6 Control types (Button, CheckBox, CheckButton,
      LineEdit, TextEdit, Tree, ItemList, TabBar, TabContainer, ProgressBar,
      HSlider, VSlider, HScrollBar, VScrollBar, PanelContainer, PopupPanel,
      PopupMenu, TooltipPanel, Window, AcceptDialog, ConfirmationDialog,
      FileDialog, ColorPicker, ColorPickerButton, GraphEdit, GraphFrame,
      GraphNode, HFlowContainer, SplitContainer, MenuBar, MenuButton,
      OptionButton, LinkButton, RichTextLabel, Label, SpinBox, CodeEdit,
      HSeparator, VSeparator).
    - 13 type variations registered with explicit fonts (PITFALLS 1.2):
      PrimaryButton / SecondaryButton / GhostButton / DangerButton / IconButton /
      FlatButton / HeaderLarge / HeaderMedium / HeaderSmall / Caption /
      InfoText / CardPanel / HeroPanel.
    - `is_light` flag derived from `base_color.get_luminance() >= 0.5`;
      surface ramp + state layers + text colors flip on `is_light` per
      DESIGN_TOKENS §6.4.
    - Hard-offset shadow raised mode (`raised = true` produces `shadow_size =
      raised_strength`, `shadow_offset = (0, raised_strength)`, no blur);
      flat mode sets `shadow_size = -1` (no shadow).
    - `Platform.AUTO` resolves at runtime via `OS.has_feature("mobile")`.

    ### Notes (v1.0.0 limitations preserved)
    - **No italic glyphs ship in v1.** Inter Italic Variable is deferred to v1.x.
      Consumers requiring italics use Godot's synthetic italic transform via
      `FontVariation.transform = Transform2D(...)` or `font_italic` Theme slot
      where applicable. (FONT-07 deferred per UD-4 Option D.)
    - **No CJK font bundled in v1.** Consumers needing CJK script support
      append a CJK font (e.g., system Noto Sans CJK) to a duplicated theme's
      `default_font.fallbacks`. See README "CJK / Non-Latin Scripts" section.
      (FONT-09(a) override pattern; UD-2 default behavior.)
    - **No `plugin.cfg`.** This is NOT an editor plugin — consumers preload
      `.tres` files directly via `preload("res://addons/neocade_theme/...")`.
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
    - Per-direction Theme Editor variation styleboxes (PrimaryButton /
      GhostButton personality per direction) — Phases 5/6/7 polish, not v1.0.0.
    - Bespoke SVG icons for Tree expand/collapse, ColorPicker, FileDialog,
      ScrollBar, TabBar — Phases 6/7.
    - Mobile-branch tap-target audit + `MOBILE-DESIGN-SPEC.md` deliverable —
      Phase 8.
    - Showcase scene with theme picker + raised toggle + platform selector —
      Phase 9.
    - Asset Library submission — REJECTED for v1 (DIST-05 stricken); v1 ships
      GitHub-Releases-only.
    ```

    Use PowerShell `Set-Content -Encoding UTF8`.
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/CHANGELOG.md` exists.
    - File contains `# Changelog` heading.
    - File contains `## [Unreleased]` section heading.
    - File contains `### Added (Phase 4 — Foundation)` subheading.
    - File contains `### Notes (v1.0.0 limitations preserved)` subheading.
    - File contains `Inter Italic Variable is deferred` (FONT-07 documentation).
    - File contains `No CJK font bundled` (UD-2 / FONT-09).
    - File contains `No plugin.cfg` (STACK Decision 5 / D-05).
    - File contains `is REVISABLE` (binding-mechanism revisability note per D-03).
    - File contains the names of all 5 directions: `pulse_neocade_theme`, `slate_neocade_theme`, `bubble_neocade_theme`, `daybreak_neocade_theme`, `burst_neocade_theme`.
    - File contains `Inter Variable Roman` and `OFL.txt` references.
    - File contains `BINDING_TABLE` reference.
    - File contains the literal text `13 type variations`.
    - File is between 2 KB and 8 KB.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/CHANGELOG.md'; if (-not (Test-Path $p)) { throw 'CHANGELOG.md missing' }; $g=Get-Content -Raw $p; foreach($n in '# Changelog','## [Unreleased]','### Added (Phase 4 — Foundation)','### Notes (v1.0.0 limitations preserved)','Inter Italic Variable is deferred','No CJK font bundled','No `plugin.cfg`','is REVISABLE','pulse_neocade_theme','slate_neocade_theme','bubble_neocade_theme','daybreak_neocade_theme','burst_neocade_theme','Inter Variable Roman','OFL.txt','BINDING_TABLE','13 type variations') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; $size=(Get-Item $p).Length; if ($size -lt 2000 -or $size -gt 8000) { throw \"CHANGELOG.md size $size bytes outside 2-8 KB range\" }"
    </automated>
  </verify>
  <done>CHANGELOG.md ships with [Unreleased] body documenting Phase 4 deliverables + v1 limitations.</done>
</task>

<task type="auto">
  <name>Task 3: Author addons/neocade_theme/VERSION single-line file</name>
  <read_first>
    - .planning/PROJECT.md (versioning convention)
  </read_first>
  <files>
    - addons/neocade_theme/VERSION (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/VERSION` as a single-line file containing the version string. Per Phase 4's pre-release status, use `0.4.0-phase-4` (semver pre-release tag). Phase 11 will overwrite to `1.0.0` for distribution.

    Content:

    ```
    0.4.0-phase-4
    ```

    The file MUST contain a single line (a trailing newline is allowed but no other content). Use PowerShell `Set-Content -Encoding UTF8 -NoNewline` if the convention is no-trailing-newline, OR the default `Set-Content` (with trailing newline) — verify against project root convention if any.
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/VERSION` exists.
    - File contains the literal substring `0.4.0` (or another semver pre-release tag matching project convention).
    - File is at most 30 bytes (single short version string).
    - File contains exactly 1 line of content (1 line + optional trailing newline).
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/VERSION'; if (-not (Test-Path $p)) { throw 'VERSION missing' }; $g=Get-Content -Raw $p; if ($g -notmatch '0\\.4\\.0') { throw \"VERSION missing 0.4.0; got: $g\" }; $size=(Get-Item $p).Length; if ($size -gt 30) { throw \"VERSION too large: $size bytes\" }; $lines = (Get-Content $p | Where-Object { $_ -ne '' }).Count; if ($lines -ne 1) { throw \"VERSION should have 1 non-empty line; got $lines\" }"
    </automated>
  </verify>
  <done>VERSION ships as a single-line file with the Phase 4 pre-release version string.</done>
</task>

<task type="auto">
  <name>Task 4: Author addons/neocade_theme/README.md (Phase 4 minimal)</name>
  <read_first>
    - .planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-CONTEXT.md (specifics, decisions D-13, D-14)
    - .planning/REQUIREMENTS.md (FONT-09 CJK override pattern)
    - .planning/research/STACK.md
  </read_first>
  <files>
    - addons/neocade_theme/README.md (NEW)
  </files>
  <action>
    Author `addons/neocade_theme/README.md` with the Phase 4 minimal content. Phase 11 expands for v1 distribution; this version covers only what FOUND-01 + FONT-09 require.

    Content:

    ```markdown
    # NeoCade Theme

    A drop-in [Godot 4.6](https://godotengine.org/) UI Theme system styling every
    built-in `Control` with a flat [Material Design 3 / MD3 Expressive](https://m3.material.io/)
    aesthetic. Native, accessibility-first, universal across the Godot Editor
    and game runtime. Optional "extruded flat 3D" raised variation per the
    [Flat-3D Game UI](https://hcgamestudios.itch.io/flat-game-ui-for-mobile-games)
    pattern.

    **No textures. No patterns. No embossing. No painterly chrome. No gradients
    on chrome.** Solid colors + offset darker shape duplicates for depth on the
    raised variation only.

    ## Recommended starter

    **Pulse** — `pulse_neocade_theme.tres` is the recommended starter direction
    for new consumers. Try this first.

    ```gdscript
    @export var theme: NeoCadeTheme = preload("res://addons/neocade_theme/pulse_neocade_theme.tres")
    ```

    Or assign via the Editor's Inspector → `theme` slot on any `Control`.

    ## Available directions

    v1 ships 5 approved directions, each as a data-only `.tres` file at the addon
    root. All 5 directions share the same `NeoCadeTheme` engine — they differ
    only in their 9 `@export` values and in optional Theme Editor authored entry
    overrides for personality.

    | Direction | File | Personality |
    |---|---|---|
    | **Pulse** ⭐ | `pulse_neocade_theme.tres` | Arcade-dense; cabinet-bezel rectangles; bold accent fill on primary |
    | **Slate** | `slate_neocade_theme.tres` | Spacious-premium-quiet; rounded-pill primary; iOS-style focus offset |
    | **Bubble** | `bubble_neocade_theme.tres` | Friendly-airy-generous; pillowy fully-rounded primary; pastel pink accent |
    | **Daybreak** | `daybreak_neocade_theme.tres` | Airy-breathing; gentle rounded; mint-halo focus ring |
    | **Burst** | `burst_neocade_theme.tres` | Event-spread-hierarchy-amplified; oversized statement primary; gold accent |

    All 5 directions support both desktop and mobile via the `platform` `@export`
    property (default: `Platform.AUTO` — auto-detects via
    `OS.has_feature("mobile")`).

    ## Custom themes

    `NeoCadeTheme` is **not abstract** — instantiate it directly to author your
    own theme:

    ```gdscript
    var custom_theme := NeoCadeTheme.new()
    custom_theme.base_color = Color("#080A1E")
    custom_theme.accent_color = Color("#FF66AA")
    custom_theme.corner_radius = 10
    # ... etc — see DESIGN_TOKENS.md for the 9 @export properties
    apply_theme(custom_theme)
    ```

    Or in the Godot FileSystem dock: right-click → New Resource → `NeoCadeTheme`,
    fill in the 9 `@export` values, save as `my_neocade_theme.tres` somewhere in
    your project, and use `preload("res://path/to/my_neocade_theme.tres")`.

    ## Theme Editor authoring

    The 9 `@export` properties drive ALL theme entries via the BINDING_TABLE
    iteration engine in `_regenerate_theme()`. **You can also author Theme Editor
    entries by hand** — Godot's standard Theme Editor workflow works directly on
    `NeoCadeTheme` resources. Slots not in BINDING_TABLE are LEFT UNTOUCHED by
    `_regenerate_theme()` (the escape hatch); slots IN BINDING_TABLE are
    formula-owned and will regenerate on `@export` mutations. This means custom
    per-theme personality (e.g., a one-off splash-screen panel style) survives
    `@export` changes.

    ## CJK / non-Latin script support

    NeoCade ships **only** Inter Variable Roman as its bundled font (UD-4 Option
    D); no CJK font is bundled. Consumers needing CJK script support append a
    CJK fallback to the theme's `default_font.fallbacks`:

    ```gdscript
    func _ready() -> void:
        var theme: NeoCadeTheme = preload("res://addons/neocade_theme/pulse_neocade_theme.tres").duplicate()
        var inter: FontFile = theme.default_font as FontFile
        var cjk_fallback: FontFile = preload("res://path/to/NotoSansCJK-Regular.ttf")
        inter.fallbacks = [cjk_fallback]
        # Apply the modified theme to your Control / scene root
    ```

    Godot's `default_font.allow_system_fallback = true` is already set in the
    bundled `Inter-Variable.ttf.import` sidecar, so the OS-side font fallback
    kicks in for unsupported scripts when no explicit fallback is set.

    ## Code font (CodeEdit / `[code]` BBCode)

    NeoCade does **not** bundle a monospaced font (FONT-04 stricken — JetBrains
    Mono Variable not bundled in v1). CodeEdit and `[code]` BBCode are rare in
    shipped games; consumers who use code surfaces ship their preferred mono.

    Override pattern:

    ```gdscript
    # On a specific CodeEdit instance:
    code_edit.add_theme_font_override("font", preload("res://your_mono.ttf"))
    ```

    Or as a Theme entry override on a duplicated NeoCadeTheme:

    ```gdscript
    var theme: NeoCadeTheme = preload("res://addons/neocade_theme/pulse_neocade_theme.tres").duplicate()
    theme.set_font("font", "CodeEdit", preload("res://your_mono.ttf"))
    ```

    Recommended monos: JetBrains Mono, Fira Code, IBM Plex Mono, Source Code Pro.

    ## Italic emphasis (synthetic fallback)

    Inter Italic Variable is **not bundled** in v1 (FONT-07 deferred per UD-4
    Option D). For italic emphasis on bundled Inter, use Godot's synthetic
    italic transform:

    ```gdscript
    # Option A — set the font_italic theme slot on a Label / RichTextLabel:
    label.add_theme_font_override("font_italic", preload("res://addons/neocade_theme/fonts/Inter-Body.tres"))
    # Then enable italic via BBCode [i]...[/i] in RichTextLabel; Godot applies
    # the synthetic skew transform to render the upright glyphs as italic.

    # Option B — author a FontVariation with a skew transform:
    var italic := FontVariation.new()
    italic.base_font = preload("res://addons/neocade_theme/fonts/Inter-Variable.tres")
    italic.transform = Transform2D(1.0, tan(deg_to_rad(12)), 0.0, 1.0, 0.0, 0.0)
    ```

    Body text rendering with synthetic italics is acceptable; true Inter Italic
    is deferred to v1.x.

    ## Architecture (v1)

    - **Single concrete class:** `addons/neocade_theme/neocade_theme.gd` declares
      `@tool class_name NeoCadeTheme extends Theme` with 9 `@export` properties.
    - **N data-only `.tres`:** v1 ships 5 (one per approved direction). No
      per-direction `.gd` files; no class hierarchy.
    - **Dynamic regeneration:** Setters on every `@export` trigger
      `_regenerate_theme()` which walks an internal BINDING_TABLE, computes
      derived values (surface ramp, state layers, raised offsets, role tokens),
      and populates Theme entries via `set_stylebox` / `set_color` / etc.
    - **Iteration is additive** — `_regenerate_theme()` does NOT call `clear()`.
      Slots not in BINDING_TABLE are untouched (escape hatch for custom Theme
      Editor authoring).

    > **Note on the binding mechanism:** the current implementation uses a
    > slot-name + property-name table compiled into `neocade_theme.gd`. This
    > internal mechanism is **REVISABLE** in future v1.x — alternative approaches
    > (property-name convention, metadata-tagged Resource model) may replace it
    > without breaking the public `@export` surface or the `.tres` file format.

    ## Bundled font (Inter Variable Roman)

    The `fonts/Inter-Variable.ttf` binary is licensed under the SIL Open Font
    License 1.1 (see `OFL.txt`), separately from the addon code's MIT license
    (see `LICENSE.md`). The Reserved Font Name "Inter" is preserved per the
    OFL terms — do not rename the binary.

    ## Cross-references

    - **Design tokens (the canonical Phase 4 contract):** `.planning/DESIGN_TOKENS.md`
    - **CHANGELOG:** `CHANGELOG.md`
    - **Font license:** `OFL.txt`
    - **Code license:** `LICENSE.md`
    - **Version:** `VERSION`

    ---

    _Phase 4 minimal README. Phase 11 expands this for v1 distribution._
    ```

    Use PowerShell `Set-Content -Encoding UTF8`.
  </action>
  <acceptance_criteria>
    - File `addons/neocade_theme/README.md` exists.
    - File contains `# NeoCade Theme` heading.
    - File contains `## Recommended starter` and explicitly names `Pulse` / `pulse_neocade_theme.tres`.
    - File contains the consumer pattern `preload("res://addons/neocade_theme/pulse_neocade_theme.tres")` (or any of the 5 directions).
    - File contains `## Available directions` section listing all 5 directions.
    - File contains `## Custom themes` section with `NeoCadeTheme.new()` example.
    - File contains `## CJK / non-Latin script support` section.
    - File contains the CJK override pattern: a code example using `default_font.fallbacks` + a CJK font preload.
    - File contains `## Code font` section (FONT-04 override pattern).
    - File contains the literal substring `add_theme_font_override("font"` (the FONT-04 code-font override recipe).
    - File contains `## Italic emphasis` section (FONT-07 synthetic italic fallback).
    - File contains `font_italic` AND/OR `FontVariation` with `transform` reference (the FONT-07 synthetic italic recipe).
    - File contains the literal text `is REVISABLE` (or equivalent — the binding-mechanism revisability disclosure per D-03).
    - File contains `OFL.txt` and `LICENSE.md` cross-references.
    - File is between 3 KB and 12 KB.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$p='addons/neocade_theme/README.md'; if (-not (Test-Path $p)) { throw 'README.md missing' }; $g=Get-Content -Raw $p; foreach($n in '# NeoCade Theme','## Recommended starter','Pulse','pulse_neocade_theme.tres','preload(\"res://addons/neocade_theme/pulse_neocade_theme.tres\")','## Available directions','slate_neocade_theme.tres','bubble_neocade_theme.tres','daybreak_neocade_theme.tres','burst_neocade_theme.tres','## Custom themes','NeoCadeTheme.new()','## CJK','default_font.fallbacks','## Code font','add_theme_font_override(\"font\"','## Italic emphasis','is REVISABLE','OFL.txt','LICENSE.md') { if ($g -notmatch [regex]::Escape($n)) { throw \"missing: $n\" } }; if (-not (($g -match 'font_italic') -or ($g -match 'FontVariation.*transform'))) { throw 'README missing FONT-07 synthetic italic recipe' }; $size=(Get-Item $p).Length; if ($size -lt 3000 -or $size -gt 14000) { throw \"README.md size $size bytes outside 3-14 KB range\" }"
    </automated>
  </verify>
  <done>README.md ships the Phase 4 minimal content covering consumer pattern + Pulse + custom theme authoring + CJK override + revisability disclosure.</done>
</task>

<task type="auto">
  <name>Task 5: Verify the addon root layout matches FOUND-01 and STACK Decision 5 (no plugin.cfg)</name>
  <read_first>
    - addons/neocade_theme/ (root directory)
    - .planning/research/STACK.md
  </read_first>
  <files>(verification only — no file edits)</files>
  <action>
    Verify the `addons/neocade_theme/` root layout matches the FOUND-01 + STACK Decision 5 contract:

    Required files at `addons/neocade_theme/`:
    - `neocade_theme.gd` ✓ (Plan 04-01/04/05)
    - `pulse_neocade_theme.tres` ✓ (Plan 04-06)
    - `slate_neocade_theme.tres` ✓ (Plan 04-07)
    - `bubble_neocade_theme.tres` ✓ (Plan 04-07)
    - `daybreak_neocade_theme.tres` ✓ (Plan 04-07)
    - `burst_neocade_theme.tres` ✓ (Plan 04-07)
    - `OFL.txt` ✓ (Plan 04-02)
    - `LICENSE.md` ✓ (this plan)
    - `CHANGELOG.md` ✓ (this plan)
    - `VERSION` ✓ (this plan)
    - `README.md` ✓ (this plan)
    - `_phase4_verify.gd` ✓ (Plan 04-06; deleted in Phase 11)

    Required subdirectories:
    - `fonts/` ✓ (Plan 04-02)
    - `icons/` ✓ (Plan 04-03)

    Forbidden (must NOT exist):
    - `addons/neocade_theme/plugin.cfg` (STACK Decision 5 / D-05)
    - `addons/neocade_theme/neocade_theme.tres` (deleted in Plan 04-01)
    - `addons/neocade_theme/_dev/` (per CONTEXT.md "Track 4")
    - `addons/neocade_theme/themes/` (per CONTEXT.md "Track 4")
    - `addons/neocade_theme/neocade_mobile_theme.tres` (per architecture revision; mobile is `@export`)

    The verify command checks the presence of required files + absence of forbidden files. This task does NOT modify any files; it is a structural assertion that all prior plans landed correctly.
  </action>
  <acceptance_criteria>
    - All 12 required files exist at the listed paths.
    - Both required subdirectories exist (`fonts/`, `icons/`).
    - The 5 forbidden paths do NOT exist.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$base='addons/neocade_theme'; $required=@('neocade_theme.gd','pulse_neocade_theme.tres','slate_neocade_theme.tres','bubble_neocade_theme.tres','daybreak_neocade_theme.tres','burst_neocade_theme.tres','OFL.txt','LICENSE.md','CHANGELOG.md','VERSION','README.md','_phase4_verify.gd'); foreach($f in $required) { if (-not (Test-Path \"$base/$f\")) { throw \"required file missing: $f\" } }; foreach($d in 'fonts','icons') { if (-not (Test-Path -PathType Container \"$base/$d\")) { throw \"required dir missing: $d\" } }; foreach($forbidden in 'plugin.cfg','neocade_theme.tres','_dev','themes','neocade_mobile_theme.tres') { if (Test-Path \"$base/$forbidden\") { throw \"forbidden path exists: $forbidden\" } }"
    </automated>
  </verify>
  <done>Addon layout matches the FOUND-01 + STACK Decision 5 contract; no `plugin.cfg`; no scaffold residue; flat layout per CONTEXT.md "Track 4".</done>
</task>

<task type="auto">
  <name>Task 6: Atomic commit — addon metadata + README</name>
  <read_first>
    - addons/neocade_theme/LICENSE.md
    - addons/neocade_theme/CHANGELOG.md
    - addons/neocade_theme/VERSION
    - addons/neocade_theme/README.md
  </read_first>
  <files>(commit only)</files>
  <action>
    Stage the 4 new metadata files and commit:

    ```
    feat(04-08): ship addon metadata + Phase 4 minimal README

    Plan 04-08 wave-4 (depends on Plan 04-02 OFL.txt):
    - addons/neocade_theme/LICENSE.md — MIT license body for the addon code +
      explicit note that the bundled Inter font is OFL 1.1 (separate license)
    - addons/neocade_theme/CHANGELOG.md — [Unreleased] section enumerating
      Phase 4 deliverables + v1.0.0 limitations (FONT-07 italic deferred,
      UD-2 CJK not bundled, D-05 no plugin.cfg, D-03 binding revisable, no
      light mode in v1, no EditorInspectorPlugin)
    - addons/neocade_theme/VERSION — single-line "0.4.0-phase-4" pre-release tag
    - addons/neocade_theme/README.md — Phase 4 minimal: consumer preload pattern,
      Pulse recommended starter, NeoCadeTheme.new() custom theme authoring,
      CJK override via default_font.fallbacks (UD-2 / FONT-09(a)), binding
      mechanism revisability disclosure (D-03)

    Layout verified: addons/neocade_theme/ has 12 required files + fonts/ +
    icons/; no plugin.cfg, no scaffold .tres, no _dev/ or themes/ subfolders.

    Refs: FOUND-01 (metadata), FONT-09 (CJK override pattern)
    Plan: 04-08
    ```

    `git add` the 4 paths; commit. Do NOT push.
  </action>
  <acceptance_criteria>
    - `git log -1 --pretty=%s` returns a subject line starting with `feat(04-08):`.
    - `git log -1 --name-status` shows 4 `A` entries: `addons/neocade_theme/LICENSE.md`, `addons/neocade_theme/CHANGELOG.md`, `addons/neocade_theme/VERSION`, `addons/neocade_theme/README.md`.
    - `git status --porcelain` is empty for all 4 paths.
  </acceptance_criteria>
  <verify>
    <automated>
      powershell -NoProfile -Command "$msg = git log -1 --pretty=%s; if ($msg -notmatch '^feat\\(04-08\\):') { throw \"commit subject wrong: $msg\" }; $ns = git log -1 --name-status; foreach($f in 'addons/neocade_theme/LICENSE\\.md','addons/neocade_theme/CHANGELOG\\.md','addons/neocade_theme/VERSION','addons/neocade_theme/README\\.md') { if ($ns -notmatch \"A\\s+$f\") { throw \"commit missing $f\" } }"
    </automated>
  </verify>
  <done>Addon metadata + README land as a single atomic Wave 4 commit. Phase 4 deliverables are complete; SC#1 (addon layout), FOUND-01 (metadata), FONT-09 (CJK override docs) close.</done>
</task>

</tasks>
