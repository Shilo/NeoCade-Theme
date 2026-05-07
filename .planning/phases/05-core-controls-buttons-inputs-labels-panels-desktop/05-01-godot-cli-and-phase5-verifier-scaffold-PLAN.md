---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/GODOT-CLI-MISSING.md
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd
autonomous: false
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
    - "A Godot 4.6.x executable path is recorded before any Phase 5 implementation plan uses import, ResourceSaver, screenshots, or headless verification."
    - "No Godot executable is downloaded or installed unless the user explicitly approves the exact official URL and SHA256."
    - "Phase 5 has runnable verifier helpers that make the later requirements testable instead of relying on manual inspection."
    - "The verifier contract names the Phase 5 invariants: 15 variations, InfoText normal_font_size, CodeEdit gutter slots, SpinBox icons, shape lookup integrity, focus visibility, and no Theme.clear."
  artifacts:
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt"
      provides: "Absolute Godot 4.6.x executable path"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt"
      provides: "Godot executable source URL/path and SHA256 when install/download is approved"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd"
      provides: "Headless structural verifier"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd"
      provides: "Focus overlay visibility probe"
  key_links:
    - from: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt"
      to: "Godot 4.6.x CLI"
      via: "PowerShell invocation"
      pattern: "Godot_v4\\.6|--version"
    - from: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd"
      to: "addons/neocade_theme/neocade_theme.gd"
      via: "ResourceLoader plus Theme introspection"
      pattern: "has_stylebox|has_color|has_font_size"
---

<objective>
Create the Phase 5 execution foundation: resolve a real Godot 4.6.x CLI, document its path, and author the verifier helpers that all later Phase 5 plans use.

Purpose: Phase 4 used a hand-authored fallback because Godot CLI was unavailable. Phase 5 decision D-11 retires that fallback. This plan must happen first.
Output: Godot path/provenance documentation plus Phase 5 verifier scripts under the Phase 5 helpers directory only. Download/install is gated by explicit user approval and SHA256 verification.
</objective>

<execution_context>
@C:/Users/shilo/.codex/get-shit-done/workflows/execute-plan.md
@C:/Users/shilo/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/DESIGN_TOKENS.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-RESEARCH.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-VERIFICATION.md
@addons/neocade_theme/neocade_theme.gd

<interfaces>
Existing Phase 4 contracts the verifier must inspect:

```gdscript
@tool
class_name NeoCadeTheme
extends Theme

const TYPE_VARIATIONS: Dictionary = {
    "PrimaryButton": "Button",
    "SecondaryButton": "Button",
    "GhostButton": "Button",
    "DangerButton": "Button",
    "IconButton": "Button",
    "FlatButton": "Button",
    "HeaderLarge": "Label",
    "HeaderMedium": "Label",
    "HeaderSmall": "Label",
    "Caption": "Label",
    "CodeLabel": "Label",
    "InfoText": "RichTextLabel",
    "CardPanel": "PanelContainer",
    "HeroPanel": "PanelContainer",
}

func _resolve_recipe(recipe: Dictionary, data_type: String, role_table: Dictionary,
        tokens: Dictionary, presets: Dictionary) -> Variant:
```

Research conclusion D-07: Godot 4.6 uses official `focus` overlay behavior for Button-family controls. Do not add or verify invented `pressed_focus`, `checked_focus`, or `hover_pressed_focus` slots.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create search-only Godot 4.6.x resolver and CLI smoke script</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/GODOT-CLI-MISSING.md, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd</files>
  <action>Create the helpers directory. Add `Resolve-Godot46.ps1` that defaults to search-only mode and searches, in order, `$env:GODOT4`, `$env:GODOT`, `godot`, `godot4`, common Windows install locations, and `C:\Users\shilo\Godot\`. The default `-VerifyOnly` / search path MUST NOT download, install, extract, or execute a network-fetched binary. If no executable is found, write `GODOT-CLI-MISSING.md` with exact next steps and exit with a clear "approval required" status; do not create a fake path. The script may support `-AllowInstall -DownloadUrl <official Godot URL> -ExpectedSha256 <sha256>` only for use after the checkpoint below. In `-AllowInstall` mode, download only from official Godot distribution endpoints, compute `Get-FileHash -Algorithm SHA256`, compare exactly to `-ExpectedSha256`, document URL/hash/install path in `godot-cli-provenance.txt`, extract outside the repo, and never commit the binary. Write the resolved absolute executable path to `godot-cli-path.txt` only after the version check passes. Create `_phase5_cli_smoke.gd` as a small `SceneTree` script that loads `res://addons/neocade_theme/pulse_neocade_theme.tres`, asserts the loaded resource is `NeoCadeTheme`, and asserts `has_stylebox("normal", "Button")` after load-time regeneration. This addresses review HIGH: autonomous Godot binary download/install is forbidden without explicit approval and SHA256 documentation.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $resolveLog = Join-Path $logDir '05-01-resolve.log'; powershell -ExecutionPolicy Bypass -File (Join-Path $phaseDir 'helpers/Resolve-Godot46.ps1') -VerifyOnly *> $resolveLog; $resolveExit = $LASTEXITCODE; $pathFile = Join-Path $phaseDir 'helpers/godot-cli-path.txt'; $missingFile = Join-Path $phaseDir 'helpers/GODOT-CLI-MISSING.md'; if ($resolveExit -ne 0 -and -not (Test-Path $missingFile)) { Get-Content $resolveLog; throw 'Godot resolver failed without writing GODOT-CLI-MISSING.md' }; if (-not (Test-Path $pathFile)) { if (-not (Test-Path $missingFile)) { throw 'Resolver wrote neither godot-cli-path.txt nor GODOT-CLI-MISSING.md' }; Write-Host 'Godot CLI missing; checkpoint approval/manual install required before Task 2'; return }; $godot = (Get-Content $pathFile -Raw).Trim(); & $godot --version; $importLog = Join-Path $logDir '05-01-import.log'; & $godot --headless --path . --import --quit-after 2 *> $importLog; if ($LASTEXITCODE -ne 0) { Get-Content $importLog; throw 'Godot import failed' }; if (Select-String -Path $importLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $importLog; throw 'Godot import log contains ERROR or SCRIPT ERROR' }; $smokeLog = Join-Path $logDir '05-01-cli-smoke.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_cli_smoke.gd') *> $smokeLog; if ($LASTEXITCODE -ne 0) { Get-Content $smokeLog; throw 'Phase 5 CLI smoke failed' }; if (Select-String -Path $smokeLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $smokeLog; throw 'Phase 5 CLI smoke log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>The search-only resolver either writes `godot-cli-path.txt` and passes version/import/smoke checks, or writes `GODOT-CLI-MISSING.md` and pauses at the approval checkpoint without downloading or installing anything.</done>
</task>

<task type="checkpoint:human-action" gate="blocking">
  <name>Checkpoint: Approve Godot install only if search-only resolution fails</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/GODOT-CLI-MISSING.md</files>
  <action>If `godot-cli-path.txt` already exists from Task 1, skip this checkpoint. If Task 1 wrote `GODOT-CLI-MISSING.md`, pause execution: the user must either provide an already-installed Godot 4.6.x executable path or explicitly approve `Resolve-Godot46.ps1 -AllowInstall` with an official Godot URL and the expected SHA256. After the user responds, rerun the resolver with the supplied path or approved install arguments. Do not choose a download URL or hash autonomously.</action>
  <what-built>`Resolve-Godot46.ps1` searches for an existing Godot 4.6.x executable without downloading or installing anything by default.</what-built>
  <how-to-verify>
    1. If Task 1 found Godot and wrote `godot-cli-path.txt`, skip this checkpoint and continue.
    2. If Task 1 wrote `GODOT-CLI-MISSING.md`, the user must either install Godot 4.6.x manually and provide the executable path, or explicitly approve `Resolve-Godot46.ps1 -AllowInstall` with an official Godot download URL and the expected SHA256.
    3. After approval/manual install, rerun the Task 1 automated verification. `godot-cli-provenance.txt` must record the source path or URL and SHA256 for any approved download.
  </how-to-verify>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $pathFile = Join-Path $phaseDir 'helpers/godot-cli-path.txt'; if (-not (Test-Path $pathFile)) { throw 'Checkpoint not satisfied: godot-cli-path.txt is missing' }; $godot = (Get-Content $pathFile -Raw).Trim(); & $godot --version; if ($LASTEXITCODE -ne 0) { throw 'Approved/supplied Godot path does not execute' }; $prov = Join-Path $phaseDir 'helpers/godot-cli-provenance.txt'; if (Test-Path $prov) { $provText = Get-Content $prov -Raw; if ($provText -match 'DownloadUrl' -and $provText -notmatch 'SHA256') { throw 'Approved download provenance missing SHA256' } }</automated>
  </verify>
  <done>`godot-cli-path.txt` exists after user action/approval, the executable prints a 4.6.x version, and any approved download has SHA256 provenance recorded.</done>
  <resume-signal>Type `approved` with the Godot path, or approve the exact official URL + SHA256 for `-AllowInstall`.</resume-signal>
</task>

<task type="auto">
  <name>Task 2: Create Phase 5 verifier scaffold with explicit invariant groups</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd</files>
  <action>Create `_phase5_verify_headless.gd` as a `SceneTree` verifier and `_phase5_verify.gd` as the EditorScript wrapper that calls the same assertion groups. The initial runnable stage must validate Phase 4 baseline plus helper wiring, then expose named assertion groups for later plans: `assert_variation_count_15`, `assert_inf_text_normal_font_size`, `assert_codeedit_gutter_slots`, `assert_spinbox_icons`, `assert_shape_lookup_integrity`, `assert_focus_overlay_visibility`, and `assert_no_theme_clear`. Each group must emit a marker line such as `PHASE5_GROUP_OK:<group_name>` when executed so the gate proves stage routing, not only source-text presence. `assert_spinbox_icons` must assert `Theme.get_icon_list("SpinBox")` contains exactly the official Phase 5 slot set used later: `up`, `up_disabled`, `down`, and `down_disabled`. `assert_codeedit_gutter_slots` must include `line_number_color` and must assert `Theme.get_icon_list("CodeEdit").has("folded")` before Plan 05-05 wires the folded icon. `assert_inf_text_normal_font_size` must assert `normal_font_size` exists on `InfoText` and the wrong `font_size` slot is absent. Implement `assert_no_theme_clear` by scanning non-comment lines only, so the grep gate is not self-invalidating. Implement `_phase5_focus_probe.gd` to create Button, CheckBox, CheckButton, and OptionButton instances using an approved direction theme, force focus plus hover/pressed/checked states where Godot exposes them, and always assert the official `focus` stylebox structure. Pixel rendering is optional: if headless rendering is unavailable, emit `PHASE5_FOCUS_RENDER_SKIPPED` and pass only after structural focus assertions succeed; do not check or create invented combo slot names per D-07.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $toolingLog = Join-Path $logDir '05-01-tooling.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage tooling *> $toolingLog; if ($LASTEXITCODE -ne 0) { Get-Content $toolingLog; throw 'tooling verifier failed' }; if (Select-String -Path $toolingLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $toolingLog; throw 'tooling verifier log contains ERROR or SCRIPT ERROR' }; $verifySource = Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd'; $sourceText = Get-Content $verifySource -Raw; $requiredGroups = @('assert_variation_count_15','assert_inf_text_normal_font_size','assert_codeedit_gutter_slots','assert_spinbox_icons','assert_shape_lookup_integrity','assert_focus_overlay_visibility','assert_no_theme_clear'); $missingGroups = @($requiredGroups | Where-Object { $sourceText -notmatch ('\b' + [regex]::Escape($_) + '\b') }); if ($missingGroups.Count -ne 0) { throw ('Missing verifier assertion group(s): ' + ($missingGroups -join ', ')) }; $missingMarkers = @($requiredGroups | Where-Object { -not (Select-String -Path $toolingLog -Pattern ('PHASE5_GROUP_OK:' + [regex]::Escape($_)) -Quiet) }); if ($missingMarkers.Count -ne 0) { throw ('Missing verifier marker(s): ' + ($missingMarkers -join ', ')) }</automated>
  </verify>
  <done>Both verifier entrypoints run in tooling mode; every invariant group executes and emits an OK marker; later plans have structural assertions for SpinBox official slots, CodeEdit folded slot, InfoText slot correctness, focus overlay, shape lookups, and no `clear()` calls.</done>
</task>

</tasks>

<verification>
Overall plan check:
- Godot CLI is usable through the recorded path, or execution is paused at the checkpoint until the user supplies/approves one.
- No download/install occurs unless the user explicitly approves the exact official URL and SHA256; approved downloads write `godot-cli-provenance.txt`.
- Headless import succeeds before any Phase 5 implementation runs.
- Verifier scripts live under `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/`, not under `addons/neocade_theme/`.
- The helper contract explicitly rejects `pressed_focus` / `checked_focus` slots and verifies official `focus` overlay visibility.
</verification>

<success_criteria>
Phase 5 Wave 1 is complete when future plans can call the recorded Godot path and the headless verifier without discovering tooling or helper paths themselves.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-01-SUMMARY.md`
</output>
