---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 07
type: execute
wave: 7
depends_on:
  - 05-06
files_modified:
  - addons/neocade_theme/pulse_neocade_theme.tres
  - addons/neocade_theme/slate_neocade_theme.tres
  - addons/neocade_theme/bubble_neocade_theme.tres
  - addons/neocade_theme/daybreak_neocade_theme.tres
  - addons/neocade_theme/burst_neocade_theme.tres
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd
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
    - "The existing five direction resources round-trip through Godot ResourceSaver."
    - "The addon root contains exactly the five approved direction `.tres` files and no root or mobile stray `.tres`."
    - "The final Phase 5 verifier passes across all five directions with clean Godot logs."
  artifacts:
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd"
      provides: "ResourceSaver round-trip helper for the five direction resources"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd"
      provides: "Final Phase 5 structural verifier"
    - path: "addons/neocade_theme/pulse_neocade_theme.tres"
      provides: "Approved Pulse direction resource"
  key_links:
    - from: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd"
      to: "addons/neocade_theme/*_neocade_theme.tres"
      via: "ResourceSaver.save"
      pattern: "ResourceSaver\\.save"
    - from: "PowerShell final invariant"
      to: "addons/neocade_theme/*.tres"
      via: "exact allowed filename set"
      pattern: "pulse_neocade_theme|slate_neocade_theme|bubble_neocade_theme|daybreak_neocade_theme|burst_neocade_theme"
---

<objective>
Round-trip the five existing direction resources through Godot ResourceSaver and run the final Phase 5 verifier/data-only gates.

Purpose: This isolates final resource serialization and invariant checking from CodeEdit and SpinBox implementation work.
Output: ResourceSaver helper, round-tripped five direction `.tres` files, final verifier stage, and exact addon-root `.tres` set gate.
</objective>

<execution_context>
@C:/Users/shilo/.codex/get-shit-done/workflows/execute-plan.md
@C:/Users/shilo/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-RESEARCH.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-SUMMARY.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-SUMMARY.md
@addons/neocade_theme/neocade_theme.gd

<interfaces>
Allowed addon-root direction resources:

```text
pulse_neocade_theme.tres
slate_neocade_theme.tres
bubble_neocade_theme.tres
daybreak_neocade_theme.tres
burst_neocade_theme.tres
```

No root `neocade_theme.tres`, no `neocade_mobile_theme.tres`, and no extra addon-root `.tres` files are allowed per PROJECT.md and D-06.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: ResourceSaver round-trip the five direction resources only</name>
  <files>addons/neocade_theme/pulse_neocade_theme.tres, addons/neocade_theme/slate_neocade_theme.tres, addons/neocade_theme/bubble_neocade_theme.tres, addons/neocade_theme/daybreak_neocade_theme.tres, addons/neocade_theme/burst_neocade_theme.tres, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_resource_saver.gd</files>
  <action>Create `_phase5_resource_saver.gd` as a headless `SceneTree` script that loads exactly the five approved direction resources, asserts each loaded resource is `NeoCadeTheme`, calls `ResourceSaver.save()` for each original path, and exits nonzero on any load/save failure. Do not create any new `.tres` files. Preserve the data-only contract by stripping generated theme entry sections after save if Godot serializes them, leaving only script linkage plus exported values.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $importLog = Join-Path $logDir '05-07-import.log'; & $godot --headless --path . --import --quit-after 2 *> $importLog; if ($LASTEXITCODE -ne 0) { Get-Content $importLog; throw 'Godot import failed' }; if (Select-String -Path $importLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $importLog; throw 'Godot import log contains ERROR or SCRIPT ERROR' }; $saveLog = Join-Path $logDir '05-07-resource-saver.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_resource_saver.gd') *> $saveLog; if ($LASTEXITCODE -ne 0) { Get-Content $saveLog; throw 'ResourceSaver round-trip failed' }; if (Select-String -Path $saveLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $saveLog; throw 'ResourceSaver log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>The five existing direction resources save successfully through Godot ResourceSaver with clean logs and no new `.tres` files.</done>
</task>

<task type="auto">
  <name>Task 2: Run final verifier and exact data-only resource gates</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd</files>
  <action>Enable the final verifier stage so it checks: `TYPE_VARIATIONS.size() == 15`; all 15 variation rows exist; InfoText has `normal_font` and `normal_font_size`; CodeEdit gutter slots exist; SpinBox icons load; every required `shape.*` path resolves across all five directions; official focus overlay is visible/valid; no non-comment `Theme.clear` or `.clear()` call appears in `neocade_theme.gd`; and all five `.tres` files remain under 2 KiB with no `[sub_resource]` or `theme_data/` sections. Add a PowerShell final invariant that the addon-root `.tres` filenames are exactly the five approved direction files and the count is exactly 5.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $focusLog = Join-Path $logDir '05-07-focus.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_focus_probe.gd') *> $focusLog; if ($LASTEXITCODE -ne 0) { Get-Content $focusLog; throw 'focus probe failed' }; if (Select-String -Path $focusLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $focusLog; throw 'focus probe log contains ERROR or SCRIPT ERROR' }; $finalLog = Join-Path $logDir '05-07-final.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage final *> $finalLog; if ($LASTEXITCODE -ne 0) { Get-Content $finalLog; throw 'final verifier failed' }; if (Select-String -Path $finalLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $finalLog; throw 'final verifier log contains ERROR or SCRIPT ERROR' }; $sourceLines = Get-Content addons/neocade_theme/neocade_theme.gd | Where-Object { $_ -notmatch '^\\s*#' }; if (($sourceLines | Select-String -Pattern '\\.clear\\(').Count -ne 0) { throw 'Theme.clear invariant violated' }; $expected = @('bubble_neocade_theme.tres','burst_neocade_theme.tres','daybreak_neocade_theme.tres','pulse_neocade_theme.tres','slate_neocade_theme.tres') | Sort-Object; $actual = Get-ChildItem addons/neocade_theme -File -Filter '*.tres' | Select-Object -ExpandProperty Name | Sort-Object; $diff = Compare-Object $expected $actual; if (@($actual).Count -ne 5 -or $diff) { throw ('Addon-root .tres set mismatch: ' + ($actual -join ', ')) }; $bad = Get-ChildItem addons/neocade_theme -File -Filter '*_neocade_theme.tres' | Where-Object { $_.Length -ge 2048 -or (Select-String -Path $_.FullName -Pattern '\\[sub_resource\\]|theme_data/' -Quiet) }; if ($bad) { throw ('Direction .tres data-only invariant failed: ' + ($bad.Name -join ', ')) }</automated>
  </verify>
  <done>Final Phase 5 verifier passes across all five directions; addon-root `.tres` names exactly match the approved set; each direction resource remains data-only and under 2 KiB.</done>
</task>

</tasks>

<verification>
Run full Phase 5 verification:
- Godot headless import with log scan.
- `_phase5_resource_saver.gd` with log scan.
- `_phase5_focus_probe.gd` with log scan.
- `_phase5_verify_headless.gd -- --stage final` with log scan.
- Exact addon-root `.tres` set check: pulse/slate/bubble/daybreak/burst only, count 5.
- Data-only resource invariant and non-comment `.clear(` source scan.
</verification>

<success_criteria>
Phase 5 is complete when COV-02, COV-03, TYPEVAR-01 through TYPEVAR-05 are satisfied; COV-01/COV-07/COV-09/TYPEVAR-06 have their Phase 5 contributors; SpinBox icons are wired without claiming full COV-04 closure; all five direction resources pass final data-only verification.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-07-SUMMARY.md`
</output>
