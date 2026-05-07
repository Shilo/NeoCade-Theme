---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 01
type: execute
wave: 1
depends_on: []
files_modified:
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd
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
    - "A Godot 4.6.x executable path is recorded before any Phase 5 implementation plan uses import, ResourceSaver, screenshots, or headless verification."
    - "Phase 5 has runnable verifier helpers that make the later requirements testable instead of relying on manual inspection."
    - "The verifier contract names the Phase 5 invariants: 15 variations, InfoText normal_font_size, CodeEdit gutter slots, SpinBox icons, shape lookup integrity, focus visibility, and no Theme.clear."
  artifacts:
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt"
      provides: "Absolute Godot 4.6.x executable path"
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
Create the Phase 5 execution foundation: resolve or install a real Godot 4.6.x CLI, document its path, and author the verifier helpers that all later Phase 5 plans use.

Purpose: Phase 4 used a hand-authored fallback because Godot CLI was unavailable. Phase 5 decision D-11 retires that fallback. This plan must happen first.
Output: Godot path documentation plus Phase 5 verifier scripts under the Phase 5 helpers directory only.
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
  <name>Task 1: Resolve Godot 4.6.x CLI and record the path</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd</files>
  <action>Create the helpers directory. Add `Resolve-Godot46.ps1` that searches, in order, `$env:GODOT4`, `$env:GODOT`, `godot`, `godot4`, common Windows install locations, and `C:\Users\shilo\Godot\`. If no executable is found, download or install the current Godot 4.6.x stable Windows 64-bit CLI from official Godot distribution endpoints, without committing the binary. Write the resolved absolute executable path to `godot-cli-path.txt`. Create `_phase5_cli_smoke.gd` as a small `SceneTree` script that loads `res://addons/neocade_theme/pulse_neocade_theme.tres`, asserts the loaded resource is `NeoCadeTheme`, and asserts `has_stylebox("normal", "Button")` after load-time regeneration. This implements D-11 before later plans rely on Godot import, ResourceSaver, screenshots, or headless verification.</action>
  <verify>
    <automated>powershell -ExecutionPolicy Bypass -File .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1 -VerifyOnly; $godot = Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw; & $godot.Trim() --version; & $godot.Trim() --headless --path . --import --quit-after 2; & $godot.Trim() --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd</automated>
  </verify>
  <done>`godot-cli-path.txt` contains a working Godot 4.6.x executable path; headless import has no `ERROR:` or `SCRIPT ERROR:` lines; Pulse loads and has regenerated Button styleboxes.</done>
</task>

<task type="auto">
  <name>Task 2: Create Phase 5 verifier scaffold with explicit invariant groups</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd</files>
  <action>Create `_phase5_verify_headless.gd` as a `SceneTree` verifier and `_phase5_verify.gd` as the EditorScript wrapper that calls the same assertion groups. The initial runnable stage must validate Phase 4 baseline plus helper wiring, then expose named assertion groups for later plans: `assert_variation_count_15`, `assert_inf_text_normal_font_size`, `assert_codeedit_gutter_slots`, `assert_spinbox_icons`, `assert_shape_lookup_integrity`, `assert_focus_overlay_visibility`, and `assert_no_theme_clear`. Implement `assert_no_theme_clear` by scanning non-comment lines only, so the grep gate is not self-invalidating. Implement `_phase5_focus_probe.gd` to create Button, CheckBox, CheckButton, and OptionButton instances using an approved direction theme, force focus plus hover/pressed/checked states where Godot exposes them, and check that the official `focus` stylebox remains available/visible; do not check or create invented combo slot names per D-07.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage tooling; Select-String -Path .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -Pattern 'assert_variation_count_15|assert_inf_text_normal_font_size|assert_codeedit_gutter_slots|assert_spinbox_icons|assert_shape_lookup_integrity|assert_focus_overlay_visibility|assert_no_theme_clear' -AllMatches</automated>
  </verify>
  <done>Both verifier entrypoints run in tooling mode, and the source contains the exact invariant groups later plans must enable as features land.</done>
</task>

</tasks>

<verification>
Overall plan check:
- Godot CLI is usable through the recorded path.
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
