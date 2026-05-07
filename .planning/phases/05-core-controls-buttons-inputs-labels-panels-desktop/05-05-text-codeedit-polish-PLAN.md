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
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
autonomous: true
requirements:
  - COV-03
  - TYPEVAR-02
  - TYPEVAR-03
  - TYPEVAR-05
  - COV-01
  - COV-09
  - TYPEVAR-06
requirements_addressed:
  - COV-03
  - TYPEVAR-02
  - TYPEVAR-03
  - TYPEVAR-05
  - COV-01
  - COV-09
  - TYPEVAR-06
must_haves:
  truths:
    - "Label, RichTextLabel, LineEdit, TextEdit, and CodeEdit have Phase 5 desktop text chrome."
    - "CodeEdit gutter colors are populated while syntax highlighting remains out of scope."
    - "CodeEdit folded icon wiring uses an official Godot 4.6 icon slot verified by the helper."
  artifacts:
    - path: "addons/neocade_theme/neocade_theme.gd"
      provides: "Text input/display polish and CodeEdit gutter recipes"
    - path: "addons/neocade_theme/icons/code_folded.svg"
      provides: "CodeEdit folded icon"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd"
      provides: "Text and CodeEdit final assertions"
  key_links:
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "CodeEdit gutter slots"
      via: "BINDING_TABLE color recipes"
      pattern: "breakpoint_color|code_folding_color|bookmark_color|executing_line_color|line_length_guideline_color"
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "addons/neocade_theme/icons/code_folded.svg"
      via: "official CodeEdit icon recipe"
      pattern: "code_folded|fold"
---

<objective>
Finish Phase 5 text input/display polish, including CodeEdit gutter chrome and the CodeEdit folded icon.

Purpose: This keeps the formerly oversized final plan focused on COV-03 text work only.
Output: Updated text/CodeEdit recipes, one new CodeEdit SVG plus import sidecar, and verifier coverage for the text-final stage.
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
@addons/neocade_theme/neocade_theme.gd
@addons/neocade_theme/icons/

<interfaces>
Phase 5 text scope:

```text
Label, RichTextLabel, LineEdit, TextEdit, CodeEdit
```

CodeEdit scope is gutter/chrome only. Syntax highlighting remains out of scope per FEATURES AF-7 and 05-RESEARCH.md.
</interfaces>
</context>

<tasks>

<task type="auto" tdd="true">
  <name>Task 1: Add text input/display final chrome recipes</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: Label, RichTextLabel, LineEdit, TextEdit, and CodeEdit have required font, caret, selection, placeholder/read-only, and focus slots.
    - Test 2: InfoText still uses `normal_font` and `normal_font_size` after the text-final changes.
    - Test 3: Syntax-highlighting theme entries are absent.
  </behavior>
  <action>Update Label, RichTextLabel, LineEdit, TextEdit, and CodeEdit BINDING_TABLE rows to finalize desktop text polish for COV-03. Preserve the Plan 05-04 InfoText `normal_font` / `normal_font_size` correction. Keep CodeEdit syntax highlighting out of scope; only text chrome, selection/caret/read-only state, focus, and gutter-adjacent Theme slots belong here.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $textFinalLog = Join-Path $logDir '05-05-text-final-task1.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage text-final *> $textFinalLog; if ($LASTEXITCODE -ne 0) { Get-Content $textFinalLog; throw 'text-final verifier failed' }; if (Select-String -Path $textFinalLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $textFinalLog; throw 'text-final verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>COV-03 text class structural checks pass, InfoText remains on RichTextLabel slots, and no syntax-highlighting scope creep is introduced.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 2: Add CodeEdit folded icon and gutter assertions</name>
  <files>addons/neocade_theme/neocade_theme.gd, addons/neocade_theme/icons/code_folded.svg, addons/neocade_theme/icons/code_folded.svg.import, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: CodeEdit has `breakpoint_color`, `code_folding_color`, `bookmark_color`, `executing_line_color`, and `line_length_guideline_color`.
    - Test 2: CodeEdit uses `code_folded.svg` only through an official Godot 4.6 icon slot verified by introspection or documentation.
    - Test 3: Godot import and verifier logs contain no `ERROR:` or `SCRIPT ERROR:` lines.
  </behavior>
  <action>Author `code_folded.svg` following the Phase 4 icon contract: 32x32 reference, monochrome `#FFFFFF`, imported with `svg/scale=2.0`, mipmaps enabled, `compress/mode=0`, and `process/fix_alpha_border=true`. Add CodeEdit gutter color slots named by Godot 4.6 docs/research: `breakpoint_color`, `code_folding_color`, `bookmark_color`, `executing_line_color`, and `line_length_guideline_color`. Wire the folded icon only to the official CodeEdit icon slot confirmed by the verifier; record the exact slot name in the verifier assertion.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $importLog = Join-Path $logDir '05-05-import.log'; & $godot --headless --path . --import --quit-after 2 *> $importLog; if ($LASTEXITCODE -ne 0) { Get-Content $importLog; throw 'Godot import failed' }; if (Select-String -Path $importLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $importLog; throw 'Godot import log contains ERROR or SCRIPT ERROR' }; $verifyLog = Join-Path $logDir '05-05-text-final.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage text-final *> $verifyLog; if ($LASTEXITCODE -ne 0) { Get-Content $verifyLog; throw 'text-final verifier failed' }; if (Select-String -Path $verifyLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $verifyLog; throw 'text-final verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>CodeEdit gutter colors and folded icon wiring pass the text-final verifier with clean Godot logs.</done>
</task>

</tasks>

<verification>
Run the text-final verifier and inspect the Godot import/verifier logs for `ERROR:` and `SCRIPT ERROR:`. Confirm no `.tres` files are modified by this plan.
</verification>

<success_criteria>
Phase 5 text/CodeEdit polish is complete when all five text Controls pass structural checks and CodeEdit has gutter chrome without syntax-highlighting scope creep.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-05-SUMMARY.md`
</output>
