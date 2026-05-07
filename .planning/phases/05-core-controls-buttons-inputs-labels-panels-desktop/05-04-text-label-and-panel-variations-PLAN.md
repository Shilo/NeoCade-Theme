---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 04
type: execute
wave: 4
depends_on:
  - 05-03
files_modified:
  - addons/neocade_theme/neocade_theme.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
autonomous: true
requirements:
  - COV-03
  - TYPEVAR-02
  - TYPEVAR-03
  - TYPEVAR-04
  - TYPEVAR-05
  - COV-01
  - COV-07
  - COV-09
  - TYPEVAR-06
requirements_addressed:
  - COV-03
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
    - "Label and RichTextLabel variations are registered and use correct Godot font slots."
    - "Kicker is the 15th type variation mapped to Label without claiming unsupported Theme-level letter spacing."
    - "Panel, PanelContainer, CardPanel, and HeroPanel use direction-specific panel radius, alpha, and raised-lift recipes."
  artifacts:
    - path: "addons/neocade_theme/neocade_theme.gd"
      provides: "Kicker variation, InfoText slot correction, text and panel variation recipes"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd"
      provides: "15-variation and panel/text assertions"
  key_links:
    - from: "TYPE_VARIATIONS.Kicker"
      to: "Label"
      via: "set_type_variation"
      pattern: "\"Kicker\"\\s*:\\s*\"Label\""
    - from: "InfoText variation"
      to: "RichTextLabel theme slots"
      via: "normal_font and normal_font_size"
      pattern: "normal_font_size"
---

<objective>
Author the text, label, RichTextLabel, and panel variation layer, including the required Kicker variation and InfoText RichTextLabel slot fix.

Purpose: This closes TYPEVAR-02 through TYPEVAR-05 for Phase 5 and contributes Panel/PanelContainer coverage to COV-07.
Output: Updated type variation registry, font/size slots, BINDING_TABLE rows, and verifier coverage.
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

<interfaces>
Text and panel variation contracts:

```text
Label variations: HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, Kicker
RichTextLabel variation: InfoText
Panel variations: CardPanel, HeroPanel
```

Research constraint: official Godot 4.6 Label theme properties do not expose a Theme-level letter-spacing slot. Kicker may set font, font_size, and font_color. Tracking/uppercase is content/showcase behavior unless a verified Godot API is found during execution.
</interfaces>
</context>

<tasks>

<task type="auto" tdd="true">
  <name>Task 1: Add Kicker as the 15th type variation and fix RichTextLabel font-size slot</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: `TYPE_VARIATIONS.size() == 15`.
    - Test 2: `theme.get_type_variation_base("Kicker") == "Label"` or the equivalent Godot 4.6 introspection passes.
    - Test 3: Kicker has `font` and `font_size` set explicitly.
    - Test 4: InfoText has `normal_font` and `normal_font_size`, and the wrong `font_size` slot for `InfoText` is removed/absent.
    - Test 5: No production code claims or sets a fake `letter_spacing` Theme constant unless Godot introspection proves that constant exists.
  </behavior>
  <action>Add `"Kicker": "Label"` to `TYPE_VARIATIONS` per D-09. Add explicit `set_font("font", "Kicker", body_font)` and `set_font_size("font_size", "Kicker", tokens.kicker)`. Fix InfoText sizing to use RichTextLabel's `normal_font_size` slot to match the already-correct `normal_font` slot from Phase 4 BL-02, and delete the existing wrong `set_font_size("font_size", "InfoText", ...)` line rather than leaving both slots. Add a small comment near InfoText explaining RichTextLabel slot names. Implement Kicker's theme-owned styling as font, size, and color only; do not invent `letter_spacing` or text-transform Theme entries. If execution discovers an official Label theme constant for tracking via `Theme.get_constant_list("Label")`, it may wire it only with a documented Godot 4.6 docs/source citation and a verifier assertion proving the constant name; otherwise tracking remains content/showcase behavior. Addresses review MEDIUM: wrong InfoText `font_size` slot must be removed, not merely supplemented.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $textPanelsLog = Join-Path $logDir '05-04-text-panels-task1.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage text-panels *> $textPanelsLog; if ($LASTEXITCODE -ne 0) { Get-Content $textPanelsLog; throw 'text-panels verifier failed' }; if (Select-String -Path $textPanelsLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $textPanelsLog; throw 'text-panels verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>TYPE_VARIATIONS has 15 entries, Kicker is mapped to Label, InfoText uses RichTextLabel `normal_font` plus `normal_font_size` slots, and the wrong `font_size` slot is absent for InfoText.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 2: Add Label and RichTextLabel variation chrome</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, Kicker, and InfoText all have expected font colors and font sizes.
    - Test 2: Kicker font_color differs by `shape.kicker_style`: Pulse/Bubble accent, Slate muted, Daybreak accent, Burst accent plus larger/bolder treatment where Theme can own it.
    - Test 3: InfoText uses `normal_font_size` and `default_color`/`selection_color` RichTextLabel slots.
  </behavior>
  <action>Add or update BINDING_TABLE rows for HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel, Kicker, and InfoText. Use `_apply_kicker_style()` or equivalent closed enum dispatch against `shape.kicker_style`. For Burst's "uppercase-bold-larger-scale", implement the theme-owned part by increasing Kicker font_size to `tokens.kicker + 1` and reusing the existing `Inter-HeaderMedium.tres` / `header_medium_font` weight-700 FontVariation; do not bundle a new font and do not create a new font asset. For Slate's "small-caps-subtle", make explicit in code comments/verifier notes that small-caps is a content cue; the Theme owns only muted font_color and size. For code labels, keep Inter in v1 and preserve README's consumer-supplied mono override pattern. Keep syntax highlighting out of scope.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $textPanelsLog = Join-Path $logDir '05-04-text-panels-task2.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage text-panels *> $textPanelsLog; if ($LASTEXITCODE -ne 0) { Get-Content $textPanelsLog; throw 'text-panels verifier failed' }; if (Select-String -Path $textPanelsLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $textPanelsLog; throw 'text-panels verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>Label/RichTextLabel variations have explicit slots, direction-aware Kicker color behavior, and no unsupported Theme-level tracking claim.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 3: Add Panel, PanelContainer, CardPanel, and HeroPanel chrome</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: Panel and PanelContainer each have the single official `panel` stylebox using direction-aware panel alpha and radius where Godot supports that slot.
    - Test 2: CardPanel and HeroPanel variation rows exist and resolve `shape.card_radius`, `shape.hero_radius`, `shape.surface_alpha_panels`, and `shape.raised_lifts.panel`.
    - Test 3: All five directions produce non-null CardPanel and HeroPanel styleboxes without modifying `.tres` files.
  </behavior>
  <action>Update Panel and PanelContainer rows and add CardPanel/HeroPanel rows per TYPEVAR-04 and COV-07 contribution. Use surface_panel/surface_high roles, `shape.card_radius`, `shape.hero_radius`, `shape.surface_alpha_panels`, and `shape.raised_lifts.panel`. Preserve the Phase 4 direction resource contract: no new `.tres`, no per-direction `.gd`, no Theme.clear, no subresources baked into the five direction resources.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $textPanelsLog = Join-Path $logDir '05-04-text-panels-task3.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage text-panels *> $textPanelsLog; if ($LASTEXITCODE -ne 0) { Get-Content $textPanelsLog; throw 'text-panels verifier failed' }; if (Select-String -Path $textPanelsLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $textPanelsLog; throw 'text-panels verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>Panel and panel variations generate direction-specific chrome and pass all five-direction verifier assertions.</done>
</task>

</tasks>

<verification>
Run the text-panels stage. Confirm `TYPE_VARIATIONS.size() == 15`, `InfoText.normal_font_size` exists, and `letter_spacing` is not asserted unless a verified Godot API supports it.
</verification>

<success_criteria>
TYPEVAR-02, TYPEVAR-03, TYPEVAR-04, and TYPEVAR-05 are implemented for desktop, Kicker is added safely, and Panel/PanelContainer coverage contributes to COV-07.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-04-SUMMARY.md`
</output>
