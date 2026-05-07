---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 03
type: execute
wave: 3
depends_on:
  - 05-02
files_modified:
  - addons/neocade_theme/neocade_theme.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd
autonomous: true
requirements:
  - COV-02
  - TYPEVAR-01
  - TYPEVAR-05
  - COV-01
  - COV-09
  - TYPEVAR-06
requirements_addressed:
  - COV-02
  - TYPEVAR-01
  - TYPEVAR-05
  - COV-01
  - COV-09
  - TYPEVAR-06
must_haves:
  truths:
    - "The seven BaseButton-family Controls have desktop state coverage using official Godot slots."
    - "The six Button variations have direction-aware styleboxes and explicit font/font-size wiring."
    - "Focus is visible through the official `focus` overlay over hover/pressed/checked states without invented combo slots."
  artifacts:
    - path: "addons/neocade_theme/neocade_theme.gd"
      provides: "Button-family BINDING_TABLE rows and six Button variation rows"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd"
      provides: "Focus overlay visual/structural probe"
  key_links:
    - from: "TYPE_VARIATIONS"
      to: "BINDING_TABLE"
      via: "variation names used as theme types"
      pattern: "PrimaryButton|SecondaryButton|GhostButton|DangerButton|IconButton|FlatButton"
    - from: "BINDING_TABLE Button-family rows"
      to: "Godot Button renderer"
      via: "official focus stylebox"
      pattern: "\"focus\""
---

<objective>
Author the BaseButton-family desktop chrome and the six button type variations through the dynamic generation system.

Purpose: This closes COV-02 and TYPEVAR-01 for Phase 5 while establishing the COV-09 focus overlay pattern that later desktop phases inherit.
Output: Updated `BINDING_TABLE` and verifier coverage for Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton, and the six Button variations.
</objective>

<execution_context>
@C:/Users/shilo/.codex/get-shit-done/workflows/execute-plan.md
@C:/Users/shilo/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/REQUIREMENTS.md
@.planning/DESIGN_TOKENS.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-RESEARCH.md
@addons/neocade_theme/neocade_theme.gd

<interfaces>
Button-family controls in Phase 5 scope:

```text
Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, LinkButton
```

Type variations in TYPEVAR-01:

```text
PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton
```

D-07 resolution: use official `focus` overlay and verification. Do not add `pressed_focus`, `checked_focus`, or `hover_pressed_focus`.
</interfaces>
</context>

<tasks>

<task type="auto" tdd="true">
  <name>Task 1: Add direction-aware Button variation rows</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: `BINDING_TABLE` has rows for PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, and FlatButton.
    - Test 2: Each variation has normal, hover, pressed, focus, disabled, and hover_pressed styleboxes where the Button base supports them.
    - Test 3: Each variation has explicit font and font_size entries or explicit `set_font` / `set_font_size` calls.
    - Test 4: Primary and ghost strategy values differ across Pulse, Slate, Bubble, Daybreak, and Burst according to `DIRECTION_PRESETS.shape`.
  </behavior>
  <action>Add BINDING_TABLE rows for the six Button variations per D-01 and TYPEVAR-01. Recipes must use `shape.primary_radius`, `shape.primary_padding`, `shape.primary_strategy`, `shape.ghost_strategy`, `shape.raised_lifts.primary`, `shape.raised_lifts.secondary`, and `shape.raised_lifts.ghost` as appropriate. DangerButton must use the semantic danger role already established in role tokens or add a local role color without adding a new export. IconButton must remain compact but still use the official focus overlay. FlatButton is the runtime variation named by TYPEVAR-01, not the deferred editor-only FlatButton class. Use strategy helpers from Plan 02 rather than ad hoc per-direction branching in each row.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage buttons</automated>
  </verify>
  <done>All six Button variations generate state styleboxes through BINDING_TABLE and pass explicit font/font-size checks.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 2: Polish BaseButton-family rows without unsupported combo slots</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: Button, CheckBox, CheckButton, OptionButton, MenuButton, ColorPickerButton, and LinkButton have all official Phase 5 slots populated.
    - Test 2: CheckBox and CheckButton reuse existing checked/unchecked SVGs for normal and disabled/toggled slots where Godot exposes tintable icon slots, unless Godot introspection proves a distinct slot name.
    - Test 3: No `pressed_focus`, `checked_focus`, or `hover_pressed_focus` strings are present in production BINDING_TABLE rows.
    - Test 4: LinkButton keeps text-button behavior and does not receive a filled StyleBox chrome that Godot would not use.
  </behavior>
  <action>Update existing BaseButton-family BINDING_TABLE rows to use direction-aware radius, padding, alpha, focus offset, and raised-lift recipes from Plan 02 while preserving official Godot slot names. Respect the D-07 research conclusion: use `focus` overlay only, and prove visibility instead of adding invented combo slots. Keep `.tres` files data-only; all behavior must come from `neocade_theme.gd` regeneration.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage buttons</automated>
  </verify>
  <done>Every BaseButton-family type in COV-02 has official slot coverage, and the verifier confirms unsupported combo slot names are absent.</done>
</task>

<task type="auto">
  <name>Task 3: Enable focus overlay verification for Phase 5 button controls</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <action>Enable the focus assertion group for the button stage. `_phase5_focus_probe.gd` must test Pulse, Slate, Bubble, Daybreak, and Burst, force focus on representative Button, CheckBox, CheckButton, and OptionButton controls, then assert the generated `focus` stylebox is transparent-bg, accent-bordered, uses direction-specific `focus_thickness`, and uses direction-specific `shape.focus_offset`. Render a small Viewport for each representative focused control and pixel-check that the accent ring is visible outside the control bounds. If headless rendering cannot produce an image, the probe must fail with a clear error so the executor fixes the render path before this plan is complete.</action>
  <verify>
    <automated>$godot = (Get-Content .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt -Raw).Trim(); & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd; & $godot --headless --path . --script .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd -- --stage buttons</automated>
  </verify>
  <done>COV-09 baseline is established for Phase 5 Button-family controls, using official `focus` overlay only.</done>
</task>

</tasks>

<verification>
Run the button-stage verifier and focus probe. Confirm all five directions pass and no `.tres` file gains `[sub_resource]` or `theme_data/` entries.
</verification>

<success_criteria>
COV-02 and TYPEVAR-01 are implemented for desktop through the dynamic generator, and the focus overlay pattern is proven for this phase's focusable Button-family controls.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-03-SUMMARY.md`
</output>
