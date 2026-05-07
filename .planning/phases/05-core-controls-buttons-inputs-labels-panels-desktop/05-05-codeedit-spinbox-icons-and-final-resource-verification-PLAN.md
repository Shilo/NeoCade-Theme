---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 05
type: execute
wave: 5
depends_on:
  - 05-04
files_modified:
  - addons/neocade_theme/neocade_theme.gd
  - addons/neocade_theme/icons/code_folded.svg
  - addons/neocade_theme/icons/code_folded.svg.import
  - addons/neocade_theme/icons/spinbox_up.svg
  - addons/neocade_theme/icons/spinbox_up.svg.import
  - addons/neocade_theme/icons/spinbox_down.svg
  - addons/neocade_theme/icons/spinbox_down.svg.import
  - addons/neocade_theme/pulse_neocade_theme.tres
  - addons/neocade_theme/slate_neocade_theme.tres
  - addons/neocade_theme/bubble_neocade_theme.tres
  - addons/neocade_theme/daybreak_neocade_theme.tres
  - addons/neocade_theme/burst_neocade_theme.tres
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd
autonomous: true
requirements:
  - COV-02
  - COV-03
  - TYPEVAR-01
  - TYPEVAR-02
  - TYPEVAR-03
  - TYPEVAR-04
  - TYPEVAR-05
  - COV-01
  - COV-07
  - COV-09
  - TYPEVAR-06
requirements_addressed:
  - COV-02
  - COV-03
  - TYPEVAR-01
  - TYPEVAR-02
  - TYPEVAR-03
  - TYPEVAR-04
  - TYPEVAR-05
  - COV-01
  - COV-07
  - COV-09
  - TYPEVAR-06
must_haves:
  truths:
    - "Text input/display Controls have Phase 5 desktop chrome, including CodeEdit gutter colors."
    - "SpinBox has up/down icons wired through official Godot 4.6 icon slots."
    - "All five direction resources remain data-only and pass the final Phase 5 verifier after ResourceSaver round-trip."
  artifacts:
    - path: "addons/neocade_theme/icons/code_folded.svg"
      provides: "CodeEdit folded icon"
    - path: "addons/neocade_theme/icons/spinbox_up.svg"
      provides: "SpinBox up arrow icon"
    - path: "addons/neocade_theme/icons/spinbox_down.svg"
      provides: "SpinBox down arrow icon"
    - path: "addons/neocade_theme/neocade_theme.gd"
      provides: "CodeEdit gutter, text input polish, SpinBox icon recipes"
  key_links:
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "addons/neocade_theme/icons/spinbox_up.svg"
      via: "BINDING_TABLE icon recipe"
      pattern: "spinbox_up|up_arrow"
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "CodeEdit gutter slots"
      via: "BINDING_TABLE color recipes"
      pattern: "breakpoint_color|code_folding_color|bookmark_color|executing_line_color|line_length_guideline_color"
---

<objective>
Finish Phase 5 coverage with text input/display polish, CodeEdit gutter chrome, SpinBox icons, and final all-direction ResourceSaver verification.

Purpose: This closes COV-03 for Phase 5 and proves the Phase 5 dynamic-generation changes work across Pulse, Slate, Bubble, Daybreak, and Burst without creating new `.tres` resources.
Output: Three new SVG icons and import sidecars, final `neocade_theme.gd` text/SpinBox updates, and verified data-only direction resources.
</objective>

<execution_context>
@C:/Users/shilo/.codex/get-shit-done/workflows/execute-plan.md
@C:/Users/shilo/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/REQUIREMENTS.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-RESEARCH.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-SUMMARY.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-SUMMARY.md
@addons/neocade_theme/neocade_theme.gd
@addons/neocade_theme/icons/

<interfaces>
Existing icon contract:

```text
32x32 SVG reference, monochrome #FFFFFF, imported by Godot with svg/scale=2.0, mipmaps/generate=true, compress/mode=0, process/fix_alpha_border=true.
```

Phase 5 text scope:

```text
Label, RichTextLabel, LineEdit, TextEdit, CodeEdit
```

CodeEdit scope is gutter/chrome only. Syntax highlighting is out of scope.
</interfaces>
</context>

<tasks>

<task type="auto" tdd="true">
  <name>Task 1: Add CodeEdit gutter and text input/display polish</name>
  <files>addons/neocade_theme/neocade_theme.gd, addons/neocade_theme/icons/code_folded.svg, addons/neocade_theme/icons/code_folded.svg.import, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: Label, RichTextLabel, LineEdit, TextEdit, and CodeEdit have Phase 5-required font, caret, selection, placeholder/read-only, and focus slots.
    - Test 2: CodeEdit has `breakpoint_color`, `code_folding_color`, `bookmark_color`, `executing_line_color`, and `line_length_guideline_color`.
    - Test 3: CodeEdit has a folded/fold icon only if official Godot 4.6 introspection reports the slot; the verifier records the exact slot name used.
    - Test 4: Syntax highlighting theme entries are not added.
  </behavior>
  <action>Update Label/RichTextLabel/LineEdit/TextEdit/CodeEdit BINDING_TABLE rows to finalize desktop text polish for COV-03. Add CodeEdit gutter color slots named by Godot 4.6 docs/research: `breakpoint_color`, `code_folding_color`, `bookmark_color`, `executing_line_color`, and `line_length_guideline_color`. Author `code_folded.svg` following the Phase 4 icon contract, import it with Godot CLI, and wire it only to an official CodeEdit icon slot verified by `Theme.get_icon_list("CodeEdit")` or documentation. Do not add CodeEdit syntax highlighting. Keep InfoText `normal_font_size` assertion enabled from Plan 04.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --import --quit-after 2; & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage text-final</automated>
  </verify>
  <done>COV-03 text classes pass structural verifier checks, including CodeEdit gutter colors and no syntax-highlighting scope creep.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 2: Add SpinBox icons and verify official slot names</name>
  <files>addons/neocade_theme/neocade_theme.gd, addons/neocade_theme/icons/spinbox_up.svg, addons/neocade_theme/icons/spinbox_up.svg.import, addons/neocade_theme/icons/spinbox_down.svg, addons/neocade_theme/icons/spinbox_down.svg.import, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: SpinBox has up/down icon slots populated with new SVG textures.
    - Test 2: The verifier confirms official Godot 4.6 icon slot names, expected to be `up_arrow` and `down_arrow` unless introspection proves otherwise.
    - Test 3: SpinBox keeps the LineEdit-style interior from Phase 4/5 and adds only SpinBox-specific constants/icons in this task.
  </behavior>
  <action>Author `spinbox_up.svg` and `spinbox_down.svg` as small legible 32x32 monochrome `#FFFFFF` arrow/chevron icons, with matching `.import` sidecars created by Godot import. Add SpinBox BINDING_TABLE icon recipes using official Godot 4.6 icon slot names; start with `up_arrow` and `down_arrow`, but let the Godot CLI verifier fail if introspection returns different slot names and then correct the names to the official list. This SpinBox work is Phase 5 special scope; do not claim COV-04 closure because COV-04's remaining range controls stay in Phase 6.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --import --quit-after 2; & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage spinbox</automated>
  </verify>
  <done>SpinBox up/down icons load through official Godot slots, and the new SVG import sidecars match the Phase 4 icon contract.</done>
</task>

<task type="auto">
  <name>Task 3: ResourceSaver round-trip and final all-direction verifier</name>
  <files>addons/neocade_theme/pulse_neocade_theme.tres, addons/neocade_theme/slate_neocade_theme.tres, addons/neocade_theme/bubble_neocade_theme.tres, addons/neocade_theme/daybreak_neocade_theme.tres, addons/neocade_theme/burst_neocade_theme.tres, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd</files>
  <action>Run a Godot `ResourceSaver.save()` pass over the existing five direction resources only: `pulse_neocade_theme.tres`, `slate_neocade_theme.tres`, `bubble_neocade_theme.tres`, `daybreak_neocade_theme.tres`, and `burst_neocade_theme.tres`. Do not create any new `.tres` files. Preserve the Phase 4 data-only contract by stripping generated theme entry sections after save if needed, leaving only script linkage plus exported values. Enable the final verifier stage so it checks: `TYPE_VARIATIONS.size() == 15`; all 15 variation rows exist; InfoText has `normal_font` and `normal_font_size`; CodeEdit gutter slots exist; SpinBox icons load; every required `shape.*` path resolves across all five directions; official focus overlay is visible/valid; no non-comment `Theme.clear` or `.clear()` call appears in `neocade_theme.gd`; and all five `.tres` files remain under 2 KiB with no `[sub_resource]` or `theme_data/` sections.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --import --quit-after 2; & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd; & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage final; powershell -NoProfile -Command "$bad = Get-ChildItem addons/neocade_theme -Filter '*_neocade_theme.tres' | Where-Object { $_.Length -ge 2048 -or (Select-String -Path $_.FullName -Pattern '\\[sub_resource\\]|theme_data/' -Quiet) }; if ($bad) { throw ('Direction .tres data-only invariant failed: ' + ($bad.Name -join ', ')) }"</automated>
  </verify>
  <done>Final Phase 5 verifier passes across all five directions, no new `.tres` exists, and existing direction resources remain data-only.</done>
</task>

</tasks>

<verification>
Run full Phase 5 verification:
- Godot headless import.
- `_phase5_focus_probe.gd`.
- `_phase5_verify_headless.gd -- --stage final`.
- Data-only `.tres` invariant on all five direction resources.
- Non-comment source scan for `.clear(` / `Theme.clear`.
</verification>

<success_criteria>
Phase 5 is complete when COV-02, COV-03, TYPEVAR-01 through TYPEVAR-05 are satisfied; COV-01/COV-07/COV-09/TYPEVAR-06 have their Phase 5 contributors; SpinBox icons are wired without claiming full COV-04 closure; all five directions pass final verification.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-05-SUMMARY.md`
</output>
