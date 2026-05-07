---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 02
type: execute
wave: 2
depends_on:
  - 05-01
files_modified:
  - addons/neocade_theme/neocade_theme.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
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
    - "All five approved directions resolve a complete `DIRECTION_PRESETS.shape` block."
    - "BINDING_TABLE recipes can read `shape.*` values for radius, padding, alpha, raised intensity, focus offset, and strategies."
    - "Custom `NeoCadeTheme.new()` instances with non-approved colors use `DIRECTION_PRESET_DEFAULT.shape` rather than failing."
  artifacts:
    - path: "addons/neocade_theme/neocade_theme.gd"
      provides: "DIRECTION_PRESETS.shape, _lookup_shape, and recipe schema extensions"
    - path: ".planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd"
      provides: "Shape lookup integrity assertions"
  key_links:
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: ".planning/DESIGN_TOKENS.md"
      via: "verbatim per-direction shape values"
      pattern: "shape.*primary_radius|shape.*raised_lifts"
    - from: "addons/neocade_theme/neocade_theme.gd"
      to: "BINDING_TABLE recipes"
      via: "_resolve_recipe shape lookup"
      pattern: "_lookup_shape\\("
---

<objective>
Extend the dynamic generator schema so Phase 5 variation and Control recipes can use per-direction shape language without creating new public exports or new `.tres` files.

Purpose: D-01 through D-04 require formula-driven variation chrome through `DIRECTION_PRESETS.shape`, `BINDING_TABLE`, `_resolve_recipe()`, and helpers.
Output: Shape data and resolver helpers in `neocade_theme.gd`, plus verifier coverage for all five directions.
</objective>

<execution_context>
@C:/Users/shilo/.codex/get-shit-done/workflows/execute-plan.md
@C:/Users/shilo/.codex/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/DESIGN_TOKENS.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-CONTEXT.md
@.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-RESEARCH.md
@.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-SUMMARY.md
@addons/neocade_theme/neocade_theme.gd

<interfaces>
Existing resolver surface:

```gdscript
const DIRECTION_PRESETS: Dictionary = {
    "151A2E": {"spread_factor": 1.3, "hover_pct": 6.0, "pressed_pct": -10.0, "disabled_opacity": 0.42},
    "111820": {"spread_factor": 0.7, "hover_pct": 4.0, "pressed_pct": -6.0, "disabled_opacity": 0.50},
    "241326": {"spread_factor": 1.0, "hover_pct": 8.0, "pressed_pct": -10.0, "disabled_opacity": 0.45},
    "0B2420": {"spread_factor": 1.0, "hover_pct": 6.0, "pressed_pct": -6.0, "disabled_opacity": 0.50},
    "20112E": {"spread_factor": 1.3, "hover_pct": 8.0, "pressed_pct": -12.0, "disabled_opacity": 0.45},
}

func _resolve_direction_presets() -> Dictionary:
    var key := base_color.to_html(false).to_upper()
    return DIRECTION_PRESETS.get(key, DIRECTION_PRESET_DEFAULT)
```
</interfaces>
</context>

<tasks>

<task type="auto" tdd="true">
  <name>Task 1: Add per-direction `shape` blocks</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: Each approved direction key (`151A2E`, `111820`, `241326`, `0B2420`, `20112E`) has a `shape` Dictionary with no missing Phase 5 keys.
    - Test 2: `DIRECTION_PRESET_DEFAULT.shape` exists and resolves for a custom non-approved `base_color`.
    - Test 3: Pulse, Slate, Bubble, Daybreak, and Burst preserve their existing `spread_factor`, `hover_pct`, `pressed_pct`, and `disabled_opacity` values while adding shape data.
  </behavior>
  <action>Extend `DIRECTION_PRESETS` and `DIRECTION_PRESET_DEFAULT` with a nested `shape` Dictionary per D-02. Source values from `.planning/DESIGN_TOKENS.md` sections 5.1-5.5: Pulse rectangular radius 0 / focus_offset 0 / primary lift 3; Slate radius 14 / focus_offset 2 / primary lift 2; Bubble radius 26 with primary pill radius 999 / focus_offset 2 / primary lift 6; Daybreak radius 8 / focus_offset 2 / primary lift 3; Burst radius 18 with primary radius 28 / focus_offset 1 / primary lift 5. Include `primary_padding` as `Vector2i` per project convention, surface alpha keys, closed `primary_strategy`, `ghost_strategy`, `kicker_style`, and `raised_lifts` with all subkeys from D-02. Do not add new `@export` properties. Do not create, edit, or rename any `.tres` file in this plan.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $shapeLog = Join-Path $logDir '05-02-shape-task1.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage shape *> $shapeLog; if ($LASTEXITCODE -ne 0) { Get-Content $shapeLog; throw 'shape verifier failed' }; if (Select-String -Path $shapeLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $shapeLog; throw 'shape verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>Verifier confirms all five directions plus default have the full shape key set and the existing Phase 4 direction scalar values are unchanged.</done>
</task>

<task type="auto" tdd="true">
  <name>Task 2: Extend `_resolve_recipe()` for shape lookups and strategies</name>
  <files>addons/neocade_theme/neocade_theme.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <behavior>
    - Test 1: `{"radius": "shape.primary_radius"}` applies all four corner radius fields.
    - Test 2: `{"padding": "shape.primary_padding"}` applies left/right from `Vector2i.x` and top/bottom from `Vector2i.y`.
    - Test 3: `{"alpha": "shape.surface_alpha_panels"}` changes only `bg_color.a` and preserves color channels.
    - Test 4: `{"raised_intensity": "shape.raised_lifts.primary"}` resolves to the active direction lift value.
    - Test 5: `{"strategy": "shape.primary_strategy"}` dispatches only known strategy enum values and fails loudly in the verifier for typos.
  </behavior>
  <action>Add `_lookup_shape(presets: Dictionary, dotted_path: String) -> Variant` that walks `presets.shape` for paths like `shape.raised_lifts.primary`. For approved direction presets, missing shape keys must be verifier failures; fallback is only acceptable for custom colors through `DIRECTION_PRESET_DEFAULT.shape`. Extend `_resolve_recipe()` stylebox and color branches to support `radius`, `padding`, `alpha` from `shape.*`, and `raised_intensity` from either integer literals or `shape.*`. Add small helper functions such as `_set_radius_all()`, `_set_content_margin_from_padding()`, `_apply_primary_strategy()`, `_apply_ghost_strategy()`, and `_apply_kicker_style()` as needed. Keep the existing additive iteration and D-04 escape hatch, and preserve the no-`Theme.clear()` invariant.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $shapeLog = Join-Path $logDir '05-02-shape-task2.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage shape *> $shapeLog; if ($LASTEXITCODE -ne 0) { Get-Content $shapeLog; throw 'shape verifier failed' }; if (Select-String -Path $shapeLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $shapeLog; throw 'shape verifier log contains ERROR or SCRIPT ERROR' }; $sourceLines = Get-Content addons/neocade_theme/neocade_theme.gd | Where-Object { $_ -notmatch '^\\s*#' }; if (($sourceLines | Select-String -Pattern '\\.clear\\(').Count -ne 0) { throw 'Theme.clear invariant violated' }</automated>
  </verify>
  <done>Shape recipe keys work through `_resolve_recipe()`, strategy values are closed and verifier-covered, and no non-comment `clear()` call exists.</done>
</task>

<task type="auto">
  <name>Task 3: Update verifier for shape lookup integrity across all five directions</name>
  <files>.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd, .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd</files>
  <action>Enable the `assert_shape_lookup_integrity` group created in Plan 01 for the `shape` stage. It must instantiate or load each of the five approved direction resources, confirm `_resolve_direction_presets().shape` maps to that direction rather than `DIRECTION_PRESET_DEFAULT`, and assert all recipe paths used by Phase 5 plans resolve non-null. Include `focus_offset` in this check because Plan 5 must verify focus ring gap per direction. The verifier must also scan non-comment `BINDING_TABLE` rows for unsupported focus combo slot names (`pressed_focus`, `checked_focus`, `hover_pressed_focus`) and fail if they appear there; do not make the forbidden-name list self-invalidating.</action>
  <verify>
    <automated>$phaseDir = '.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop'; $logDir = Join-Path $phaseDir 'logs'; New-Item -ItemType Directory -Force $logDir | Out-Null; $godot = (Get-Content (Join-Path $phaseDir 'helpers/godot-cli-path.txt') -Raw).Trim(); $shapeLog = Join-Path $logDir '05-02-shape-task3.log'; & $godot --headless --path . --script (Join-Path $phaseDir 'helpers/_phase5_verify_headless.gd') -- --stage shape *> $shapeLog; if ($LASTEXITCODE -ne 0) { Get-Content $shapeLog; throw 'shape verifier failed' }; if (Select-String -Path $shapeLog -Pattern '^(ERROR|SCRIPT ERROR):' -Quiet) { Get-Content $shapeLog; throw 'shape verifier log contains ERROR or SCRIPT ERROR' }</automated>
  </verify>
  <done>The shape stage proves all five directions are considered, shape lookup typos are caught, and D-07 unsupported combo slots remain absent.</done>
</task>

</tasks>

<verification>
Run the shape-stage headless verifier with the Godot path from Plan 01. Confirm no `.tres` file changed in this plan.
</verification>

<success_criteria>
The generator can now express direction-specific chrome from data recipes while preserving the 9-export public surface and the five existing data-only direction resources.
</success_criteria>

<output>
After completion, create `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/05-02-SUMMARY.md`
</output>
