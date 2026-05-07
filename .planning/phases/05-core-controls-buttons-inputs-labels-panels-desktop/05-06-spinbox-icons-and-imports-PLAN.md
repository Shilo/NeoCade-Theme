---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 06
type: execute
wave: 6
depends_on:
  - 05-05
files_modified:
  - addons/neocade_theme/neocade_theme.gd
  - addons/neocade_theme/icons/spinbox_up.svg
  - addons/neocade_theme/icons/spinbox_up.svg.import
  - addons/neocade_theme/icons/spinbox_down.svg
  - addons/neocade_theme/icons/spinbox_down.svg.import
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
autonomous: true
requirements:
  - COV-03
  - COV-01
requirements_addressed:
  - COV-03
  - COV-01
must_haves:
  truths:
    - "SpinBox has up/down icons wired through official Godot 4.6 icon slots."
    - "SpinBox keeps the LineEdit-style interior and adds only SpinBox-specific constants/icons in this plan."
    - "New SVG imports follow the Phase 4 icon sidecar contract."
  artifacts:
    - path: "addons/neocade_theme/icons/spinbox_up.svg"
      provides: "SpinBox up arrow icon"
    - path: "addons/neocade_theme/icons/spinbox_down.svg"
      provides: "SpinBox down arrow icon"
    - path: "addons/neocade_theme/neocade_theme.gd"
      provides: "SpinBox icon recipes"
  key_links:
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "addons/neocade_theme/icons/spinbox_up.svg"
      via: "BINDING_TABLE icon recipe"
      pattern: "spinbox_up|up_arrow"
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "addons/neocade_theme/icons/spinbox_down.svg"
      via: "BINDING_TABLE icon recipe"
      pattern: "spinbox_down|down_arrow"
---

<objective>
Add SpinBox-specific arrow icons and wire them through official Godot 4.6 theme slots.

Purpose: This extracts SpinBox icon/import work from the former oversized final plan, keeping the ResourceSaver round-trip separate.
Output: Two SpinBox SVGs with import sidecars, plus SpinBox icon recipes and verifier assertions.
</objective>

<execution_context>
@C:/Users/shilo/.codex/get-shit-done/workflows/execute-plan.md
@C:/Users/shilo/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/REQUIREMENTS.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-RESEARCH.md
@addons/neocade_theme/neocade_theme.gd
@addons/neocade_theme/icons/

<interfaces>
Existing icon contract:

```text
32x32 SVG reference, monochrome #FFFFFF, imported by Godot with svg/scale=2.0, mipmaps/generate=true, compress/mode=0, process/fix_alpha_border=true.
```

SpinBox is a Phase 5 special case. Do not claim COV-04 closure; the remaining range controls stay in Phase 6.
</interfaces>
</context>

<tasks>

<task type="auto" tdd="true">
  <name>Task 1: Author SpinBox up/down SVGs and import sidecars</name>
  <files>addons/neocade_theme/icons/spinbox_up.svg, addons/neocade_theme/icons/spinbox_up.svg.import, addons/neocade_theme/icons/spinbox_down.svg, addons/neocade_theme/icons/spinbox_down.svg.import, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: `spinbox_up.svg` and `spinbox_down.svg` are 32x32 monochrome `#FFFFFF` SVGs.
    - Test 2: Import sidecars exist and match the Phase 4 icon contract.
    - Test 3: Godot import log contains no `ERROR:` or `SCRIPT ERROR:` lines.
  </behavior>
  <action>Author `spinbox_up.svg` and `spinbox_down.svg` as small legible 32x32 monochrome arrow/chevron icons. Import them with Godot CLI so the committed `.import` sidecars use real Godot settings and resource UIDs. Match Phase 4's contract exactly: `svg/scale=2.0`, `mipmaps/generate=true`, `compress/mode=0`, and `process/fix_alpha_border=true`.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $importLog = Join-Path $logDir '05-06-import.log'; & $godot --headless --path . --import --quit-after 2 *> $importLog; if ($LASTEXITCODE -ne 0) { Get-Content $importLog; throw 'Godot import failed' }; if (Select-String -Path $importLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $importLog; throw 'Godot import log contains ERROR or SCRIPT ERROR' }; $svgFiles = @('addons/neocade_theme/icons/spinbox_up.svg','addons/neocade_theme/icons/spinbox_down.svg'); foreach ($svgFile in $svgFiles) { $svgText = Get-Content $svgFile -Raw; if ($svgText -notmatch '#FFFFFF') { throw ($svgFile + ' missing #FFFFFF') } }; $importFiles = @('addons/neocade_theme/icons/spinbox_up.svg.import','addons/neocade_theme/icons/spinbox_down.svg.import'); $requiredImportSettings = @('svg/scale=2.0','mipmaps/generate=true','compress/mode=0','process/fix_alpha_border=true'); foreach ($importFile in $importFiles) { $importText = Get-Content $importFile -Raw; $missingImportSettings = @($requiredImportSettings | Where-Object { $importText -notmatch [regex]::Escape($_) }); if ($missingImportSettings.Count -ne 0) { throw ($importFile + ' missing import setting(s): ' + ($missingImportSettings -join ', ')) } }</automated>
  </verify>
  <done>SpinBox SVGs and import sidecars exist, use the expected monochrome/import contract, and import cleanly.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 2: Wire SpinBox official icon slots</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: SpinBox up/down icon slots are populated with the new SVG textures.
    - Test 2: The verifier confirms official Godot 4.6 icon slot names, expected to be `up_arrow` and `down_arrow` unless introspection proves otherwise.
    - Test 3: SpinBox interior remains LineEdit-style and this task adds only SpinBox-specific constants/icons.
  </behavior>
  <action>Add SpinBox BINDING_TABLE icon recipes using official Godot 4.6 icon slot names. Start with `up_arrow` and `down_arrow`; if Godot CLI introspection returns different official names, correct the plan implementation to match the introspected list and update the verifier assertion. Do not create any new `.tres` files, and do not claim full COV-04 range-control closure.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $verifyLog = Join-Path $logDir '05-06-spinbox.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage spinbox *> $verifyLog; if ($LASTEXITCODE -ne 0) { Get-Content $verifyLog; throw 'spinbox verifier failed' }; if (Select-String -Path $verifyLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $verifyLog; throw 'spinbox verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>SpinBox up/down icons load through official Godot slots and pass the spinbox verifier.</done>
</task>

</tasks>

<verification>
Run Godot import and the spinbox verifier with log scans for `ERROR:` and `SCRIPT ERROR:`. Confirm no `.tres` files are modified by this plan.
</verification>

<success_criteria>
SpinBox-specific Phase 5 work is complete when up/down icons are imported, wired, and verifier-proven through official Godot slots.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-06-SUMMARY.md`
</output>
