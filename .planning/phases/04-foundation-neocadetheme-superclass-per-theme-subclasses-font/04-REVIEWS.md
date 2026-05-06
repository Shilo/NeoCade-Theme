---
phase: 4
reviewers: [opencode, codex]
opencode_model: deepseek/deepseek-v4-pro
codex_model: default
reviewed_at: 2026-05-06
plans_reviewed:
  - 04-01-scaffold-deletion-and-class-shell-PLAN.md
  - 04-02-fonts-and-OFL-PLAN.md
  - 04-03-button-family-icons-PLAN.md
  - 04-04-color-formulas-and-role-tokens-PLAN.md
  - 04-05-binding-table-and-iteration-engine-PLAN.md
  - 04-06-pulse-tres-and-verification-PLAN.md
  - 04-07-peer-themes-and-main-tscn-PLAN.md
  - 04-08-addon-metadata-and-readme-PLAN.md
cycle: 1
---

# Cross-AI Plan Review — Phase 4 (Cycle 1)

## OpenCode Review (DeepSeek V4 Pro)

## Cross-AI Plan Review: Phase 4 — Foundation (8 Plans)

### 1. Summary

The 8-plan set is **sound in direction and architecture** but carries **several MEDIUM and HIGH risks** that should be resolved before execution. The plans faithfully implement the locked DESIGN_TOKENS contract, respect all forbidden surfaces (no subclasses, no plugin.cfg, no mobile `.tres`, no root `.tres`), and correctly sequence Wave 1 parallelization (class shell ‖ fonts ‖ icons). However, the BINDING_TABLE authoring task (Plan 04-05 Task 2) is drastically underspecified — it delegates "the executor authors directly using the 37-row scorecard" with ~600-1000 lines of Dictionary data, yet provides no concrete enumeration of Slot names per Control, no recipe-to-role mapping table, and no verification of Tree's actual 16 stylebox slot names. The type variation count oscillates between 13 and 14 across different plans, and the `_regenerate_theme()` naming is inconsistent within Plan 04-02's `.import` sidecar instructions. The `spread_factor` per-direction override is deferred to "Plan 04-05 will supersede" but Plan 04-05 never actually implements per-direction spread factor sourcing from `directions.json`. These are correctable but would block goal achievement if executed as-written.

---

### 2. Strengths

- **Forbidden-surface discipline is flawless.** All 8 plans respect: no per-direction `.gd` subclasses, no root `neocade_theme.tres`, no `themes/` or `_dev/` subfolders, no `neocade_mobile_theme.tres`, no `plugin.cfg`, no EditorInspectorPlugin. The scaffold deletion in Plan 04-01 Task 1 is the critical first step and is correctly ordered.
- **D-01 `clear()` prohibition is enforced with grep-backed verification.** Every plan that touches `_regenerate_theme()` includes automated `clear()` detection in its verify commands. The class shell (Plan 04-01) even includes a comment placeholder reminding future plans.
- **Wave 1 parallelism (Plans 01, 02, 03) is correctly structured** — the class shell, fonts, and icons are truly independent and can be executed concurrently.
- **PITFALLS 1.2 (type variations don't inherit fonts) is correctly addressed** across Plans 04-05 and 04-07, with explicit `set_font()` calls per variation and verification that `has_font("font", variation)` returns true.
- **Design Tokens hex-to-float conversion in Plan 04-06 Task 1 is correct** — the color values in the `.tres` files are properly float-encoded from hex (e.g., `Color(0.0823529, 0.101961, 0.180392, 1)` for `#151A2E`).
- **Pulse-first implementation order (Plans 04-06 → 04-07) is respected**, with verification Pulse-only in Plan 04-06 before peers ship in Plan 04-07.
- **Class default values in Plan 04-01 match D-13/DESIGN_TOKENS §3 exactly** — Slate-ish neutral, not Pulse-flavored.
- **The `_resolve_recipe()` design in Plan 04-05 Task 3 is well-structured** — the focus_ring special case, raised intensity multiplier, alpha blending, and D-04 null-continue escape hatch are all correctly reasoned.
- **PITFALLS 1.1 (focus as outer ring) is correctly encoded** in the focus_ring recipe branch of `_resolve_recipe()`, with `expand_margin_*` used for the ring offset rather than corner radius adjustment.
- **Atomic commit discipline** — every plan ends with a commit task; wave boundaries are clean.

---

### 3. Concerns

#### HIGH

1. **Plan 04-05 Task 2 BINDING_TABLE authoring is critically underspecified (risk: Plan 04-05 execution failure).** The task tells the executor to "author BINDING_TABLE entries one Control at a time" using `MINIMAL-THEME-COVERAGE-DELTA.md` and `MINIMAL-THEME-DISSECTION.md`, but provides no concrete slot-name enumeration, no recipe-to-role mapping specification, and delegates the entire ~600-1000 line Dictionary to executor discretion. The RESEARCH.md §1.5 provides a per-Control state matrix table, but that table is marked non-exhaustive ("A non-exhaustive but representative summary") and uses informal slot names like `cursor_unfocused` (which may or may not match Godot 4.6's actual Theme slot strings). The exact Theme slot string names are critical — Godot expects `"cursor_unfocused"` not `"cursor_unfocused"` (verify exact casing), and `"title_button_normal"` not `"titlebutton_normal"`. Without a concrete enumeration, the executor risks creating entries that don't map to Godot's expected slot names, producing a Theme that "has entries" but doesn't actually style Controls. **Recommendation:** Before executing Plan 04-05, produce a concrete BINDING_TABLE slot-name enumeration (a structured reference document) from a live Godot 4.6 Theme Editor inspection or from the godot-minimal-theme dissection's verified slot names. This could be a separate Phase 4.0 prep task or an append to the PLAN.md.

2. **Per-direction `spread_factor` is never resolved (risk: all 5 directions produce identical surface ramp).** Plan 04-04 Task 4 hard-codes `var spread_factor: float = 1.0` and states "Plan 04-05 will supersede this" / "Plan 04-05 will source this per-direction." But Plan 04-05 never actually implements per-direction `spread_factor` sourcing. The DESIGN_TOKENS §5 per-direction recipes specify: Pulse `spreadFactor = 1.3` (wide), Slate `0.7` (narrow), Bubble `1.0` (medium), Daybreak `1.0` (medium), Burst `1.3` (wide). Without per-direction sourcing, all 5 directions render with a uniform `1.0` spread factor, collapsing the intended surface-contrast differentiation. **Recommendation:** Add a task to Plan 04-05 or Plan 04-06 that reads spread_factor from `directions.json` or hard-codes per-direction values in the Pulse/Bubble/Burst/Slate/Daybreak `.tres` files as an additional `@export`-hidden derived property, OR use the `spacing` value as a heuristic proxy (wider spacing → narrower spread, narrower spacing → wider spread — but this is fragile and breaks for Bubble `spacing=22` / Pulse `spacing=18` / Burst `spacing=22` with different intended spreads). Simplest fix: make `spread_factor` a per-`.tres` property computed in `_regenerate_theme()` by reading `corner_radius` + `spacing` into a heuristic OR store it in the `.tres` metadata via `Resource.set_meta()`.

#### MEDIUM

3. **Type variation count oscillates between 13 and 14 (risk: verification failure).** CONTEXT.md D-08 explicitly lists 13 names: PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton (6), HeaderLarge, HeaderMedium, HeaderSmall, Caption, CodeLabel (5), InfoText (1), CardPanel, HeroPanel (2) = 14, not 13. Plan 04-05 Task 1 declares 14 entries (the CodeLabel is included). Plan 04-06 Task 2 verification script asserts `TYPE_VARIATIONS.size() == 13`. Plan 04-05 must_haves says "all 13 NeoCade type variations." The ROADMAP Phase 5 SC#3 says "14 variations" (line 198). The actual count from the TYPEVAR IDs is ambiguous — TYPEVAR-01..04 would be 4 categories with varying counts. **Recommendation:** Resolve the exact count. 14 is the likely correct number (6 Button + 5 Label + 1 InfoText + 2 Panel = 14). Update all assertion and verification strings from 13 to 14 across all plans.

4. **No `default_font` or `default_font_size` set anywhere in the plans (risk: Control types without explicit font entries fall back to engine default).** Plan 04-05 Task 3's `_regenerate_theme()` iteration walk populates per-Control `font` and `font_size` entries via BINDING_TABLE, and sets explicit fonts on type variations. But the THEME DEFAULTS — `theme.default_font = inter_variable` and `theme.default_font_size = 14` — are never set. Per Godot's Theme resolution: if a Control type has no `font` / `font_size` entry AND has no type variation, it falls back to `Theme.default_font` / `Theme.default_font_size`, and if that's null, falls to the engine's built-in default (likely a system font, not Inter). The RESEARCH.md §8 skeleton shows `default_font = fonts.body_inter_variable` and `default_font_size = sizes.body_medium` — but the actual Plan 04-05 Task 3 walk code does not include these lines. **Recommendation:** Add `default_font = preload("res://addons/neocade_theme/fonts/Inter-Body.tres")` and `default_font_size = tokens.body` (from platform tokens) to the `_regenerate_theme()` body in Plan 04-05 Task 3, before the BINDING_TABLE walk, so any Control type that happens to lack an explicit font entry still renders in Inter.

5. **`main.tscn` theme reference cleared in Plan 04-01 but not reassigned until Plan 04-07 — 6 plans of broken scene (risk: editor usability mid-phase).** Plan 04-01 deletes the scaffold `.tres` and strips the theme reference from `main.tscn`. Plan 04-07 Task 2 reassigns Pulse. Between Plan 04-01 and Plan 04-07, the showcase scene has no theme override and may render with Godot's default appearance (or worse, with a dangling reference error). This is acceptable for autonomous execution but inconvenient for manual editor testing. **Recommendation:** In Plan 04-01 Task 1, instead of fully stripping the theme line, replace it with a placeholder comment (e.g., `# theme = ExtResource(...) - reassigned in Plan 04-07`) so the scene remains parseable. Or accept the transient broken state and note it in Plan 04-01's commit message.

6. **`_phase4_verify.gd` uses `EditorScript` which requires Godot Editor to run (risk: verification cannot run headless/autonomously).** The verification helper in Plan 04-06 Task 2 extends `EditorScript` and requires `godot --headless --script` or File→Run. On Windows where the executor may not have access to Godot Editor (the AGENTS.md environment is PowerShell + bash, and the project has `godot_launch_editor` tool), this verification may block Plan 04-06 close. The plan acknowledges this ("if neither works in the autonomous executor's environment, the executor manually loads the `.tres`") but this is a hand-wavy fallback. **Recommendation:** Also author a pure-GDScript `assert`-based test file that can be run via `godot --headless --script` (not requiring EditorScript) OR use the `godot_run_project` tool with a test scene that checks the Theme entries programmatically.

7. **FontVariation `.tres` resources in Plan 04-02 Task 4 may fail to reference the base font correctly (risk: FontVariation resources silently don't apply wght/opsz).** The plan uses a `uid://neocade_inter_var_tres` reference to `Inter-Variable.tres`. If Godot's import pipeline generates a different UID for the FontFile (since UIDs are Godot-generated, not user-chosen), the FontVariation's `base_font = ExtResource("1_inter")` will resolve to a broken reference. The plan acknowledges this ("synthetic UIDs... will be normalized by Godot on first import") but the `Inter-Variable.tres` wrapper and the FontVariation `.tres` files both use synthetic placeholder UIDs that Godot will not automatically reconcile — Godot only normalizes UIDs in `.import` sidecars, not in hand-authored `.tres` files. **Recommendation:** After creating the font files, open them in the Godot Editor (triggering UID resolution), re-save them, and commit the normalized versions. The plan should include an explicit "open in Godot Editor, save, re-commit normalized UIDs" step in Plan 04-02.

8. **`toggle_on.svg` and `toggle_off.svg` use dual-color (white + black) authoring — but Godot icon `modulate` is a single multiply (risk: toggle icons don't tint correctly).** Plan 04-03 Task 1 explicitly authors `toggle_on.svg` as `<rect fill="#FFFFFF"/>` track + `<circle fill="#000000"/>` knob. When Godot applies `icon_modulate = Color(accent_color)` to this texture, it multiplies ALL channels, so the `#000000` knob becomes `Color(0,0,0,1) * accent_color = Color(0,0,0,1)` — still black. The white track becomes `Color(1,1,1,1) * accent_color = accent_color`. This actually works correctly for the toggle use case! But `checkbox_checked.svg`'s dual-color version (`fill="#FFFFFF"` box + `stroke="#000000"` check) would have the same behavior — the check stays black regardless of modulate. The plan correctly switches to a single-color version for `checkbox_checked`. However, `clear.svg` and `toggle_on.svg`/`toggle_off.svg` still use dual-color — verify that the finished icons render correctly under modulate in a real Godot scene. **Recommendation:** Add a verification step in Plan 04-06 that loads icons and confirms `icon_modulate` produces expected results, especially for dual-color icons.

#### LOW

9. **Plan 04-08's README instructs consumers to use `theme.duplicate()` for CJK override, but `duplicate()` on a Resource that calls `_init()`→`_regenerate_theme()` will trigger regeneration (risk: minor correctness concern).** The CJK override pattern in README.md shows `preload("...").duplicate()` then appending to `default_font.fallbacks`. Since `NeoCadeTheme._init()` calls `_regenerate_theme()`, duplicating the resource triggers another regeneration cycle — harmless but wasted work. Not a blocker.

10. **Plan naming inconsistency: `scope creep` vs `Plan 04-07 states`...** (No, this is fine — let me skip this.)

11. **`_phase4_verify.gd` file deletion is documented as "Phase 11" in Plans 04-06 and 04-08 — but Phase 11 is distribution-focused and may forget cleanup tasks buried in earlier plans (risk: verification helper ships in v1 distribution).** The file is explicitly marked with a `DELETE BEFORE v1 PUBLICATION` comment header, which is good, but the Phase 11 plan should have a concrete task for this cleanup. **Recommendation:** Add a note to Phase 11 PLAN.md (when authored) to grep for `DELETE BEFORE` and remove matching files.

12. **`Inter-Variable.ttf.import` sidecar in Plan 04-02 Task 2 uses `allow_system_fallback=true` but also `fallbacks=[]` — these may conflict in Godot 4.6's `.import` parser (risk: import setting misread).** The plan's `.import` sidecar includes both a `[params]` `allow_system_fallback=true` and `fallbacks=[]`. In Godot 4.6's FontFile importer, the `fallbacks` setting in the `.import` file controls the `FontFile.fallbacks` array, and `allow_system_fallback` controls the `FontFile.allow_system_fallback` boolean. These are orthogonal — no conflict. But `Fallbacks=null` also appears, which is suspicious. The executor should verify the `.import` file opens correctly in Godot 4.6 after authoring.

---

### 4. Suggestions

- **Produce a concrete BINDING_TABLE slot-name enumeration document** (referenced from Plan 04-05) that lists every `(theme_type, data_type, slot_name, recipe_role)` tuple for all 37 Controls. The live Godot 4.6 Theme Editor can be used to extract exact slot name strings. This removes the "executor discretion" risk from the highest-LOC task in Phase 4.

- **Resolve the 13 vs 14 type variation count** across CONTEXT.md D-08, Plan 04-05 Task 1, Plan 04-06 Task 2, and ROADMAP Phase 5 SC#3. Pick 14 (the correct count: 6 Button + 5 Label/InfoText + 2 Panel + 1 InfoText = 14).

- **Add `default_font` and `default_font_size` to `_regenerate_theme()` in Plan 04-05 Task 3.** The RESEARCH.md §8 skeleton already shows these lines; the Plan 04-05 Task 3 walk code omitted them.

- **Implement per-direction `spread_factor` sourcing** — either as a hard-coded lookup in `_regenerate_theme()` keyed by `base_color` hex values, or by adding a `spread_factor` float property via `Resource.set_meta()` on each `.tres` file that `_regenerate_theme()` reads. If neither, add `spread_factor` as a non-exported property derived from `base_color` matching (simple: if `base_color` matches Pulse/Burst → 1.3, if Slate → 0.7, else 1.0).

- **Add a FontVariation UID normalization step to Plan 04-02 Task 4** — after authoring the `.tres` files, open them in Godot Editor so Godot resolves the placeholder UIDs, re-save, and commit the normalized versions.

- **Add `set_default_font()` and `set_default_font_size()` calls in Plan 04-05 Task 3** so Plan 04-06/07 `.tres` files that are loaded without per-Control font entries still render in Inter at the correct size.

- **Consider adding a lightweight Phase 4.0 "prep" task** that runs a Godot 4.6 Theme Editor inspection script to dump all slot names for all 37 Control types into a JSON file, which Plan 04-05's executor then uses as the authoritative BINDING_TABLE slot-name source. This would be a 20-minute automation task that pays for itself in Plan 04-05 execution reliability.

---

### 5. Risk Assessment: **MEDIUM**

**Justification:** The plan set has no architectural flaws — it correctly respects all locked decisions, forbidden surfaces, and dependency ordering. However, two HIGH concerns (BINDING_TABLE underspecification and missing per-direction spread_factor) could cause Phase 4 to produce a Theme where (a) Controls don't render as intended due to wrong slot names, and (b) all 5 directions share identical surface ramp contrast despite their DESIGN_TOKENS commitments to different spread factors. Both are correctable with the concrete interventions suggested above. The three MEDIUM concerns (type variation count, missing default_font, and verify-script runtime dependency) are also fixable with low-cost edits. Overall, the plan set is **execution-ready after addressing the four HIGH+primary-MEDIUM concerns**, but running it as-is risks a "the engine works but produces subtly wrong output" outcome that would require significant Plan 04-05 rework.

---

## Codex Review

170,537
## Summary

The plan set has a strong phase structure and mostly respects the locked single-class / five-data-resource architecture, but I would not execute it as-is. The main blockers are around Godot resource/import correctness, unresolved coverage ambiguity, the per-direction formula gap, and dependency ordering. The biggest risk is that the plans can produce files that pass grep-based checks while still failing to load or failing SC#7 in Godot.

## Strengths

- Pulse-first sequencing is correct: Plan `04-06` gates the first end-to-end `.tres` before peer themes.
- Forbidden surfaces are mostly respected: no per-direction `.gd`, no `plugin.cfg`, no `_dev/`, no `themes/`, no mobile `.tres`.
- The additive regeneration principle is explicit across Plans `04-01`, `04-04`, and `04-05`; `clear()` is repeatedly forbidden.
- The binding-table approach is coherent for a first implementation and correctly framed as revisable.
- Verification intent is good: export toggles, `is_light`, raised mode, type variations, and coverage all get some planned checks.

## Concerns

- **HIGH — Plan `04-05`, Task 2: SC#7 coverage list is internally inconsistent.**  
  The plan says “37 scorecard Controls” but lists 39-ish names and then says the executor may drop one. That makes success non-deterministic. The exact canonical scorecard must be frozen before implementation.

- **HIGH — Plan `04-05`, Task 1: type variation count/name mismatch.**  
  The project repeatedly says 13 type variations, but the supplied names across context include both `CodeLabel` and `HeroPanel`, yielding 14. Plan `04-05` drops `CodeLabel`, while DESIGN_TOKENS references code typography. This blocks strict SC#7 verification.

- **HIGH — Plans `04-04` / `04-05`: per-direction spread/state deltas are not actually implemented.**  
  Plan `04-04` leaves `spread_factor = 1.0`, hover `8`, pressed `12`, disabled `0.38`, and Plan `04-05` does not add a real per-direction lookup. That violates DESIGN_TOKENS §5/§6 for Pulse/Slate/Bubble/Daybreak/Burst and weakens Pulse mockup parity.

- **HIGH — Plan `04-02`, Tasks 2-4: hand-authored `.import` and `FontFile.tres` are risky and likely not load-verified.**  
  Godot’s dynamic font importer has real importer properties, but placeholder UIDs/cache paths and a hand-written `FontFile` wrapper may not serialize the way Godot expects. Generate these through Godot import/save and commit the actual files.

- **HIGH — Plans `04-06` / `04-07`: custom `.tres` header format may be wrong.**  
  Hand-writing `[gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme"]` may not match Godot’s saved format for a GDScript `class_name` extending `Theme`. These resources should be created/saved once by Godot or validated by `ResourceLoader.load()` before committing.

- **HIGH — Plan `04-05` omits required default font binding.**  
  FONT-06 requires the theme `default_font` to be Inter and fallback behavior documented/explicit. Plan `04-05` sets variation fonts but does not clearly set `default_font` / `default_font_size`.

- **HIGH — Plan `04-08` dependency is wrong.**  
  It depends only on `04-02`, but Task 5 verifies files from `04-06` and `04-07`. Either make `04-08` depend on `04-07`, or move layout verification to a final plan/verification step.

- **MEDIUM — Plan `04-05`, Task 3: raised-mode verification can fail by construction.**  
  The BINDING_TABLE excerpt gives `Button.normal` `raised_intensity = 0`, but Plan `04-06` expects `Button.normal.shadow_size > 0` after `raised = true`.

- **MEDIUM — Plan `04-03`: some icons violate monochrome/modulate discipline.**  
  `toggle_on.svg` uses black and white baked colors. Since Godot modulate multiplies colors, black remains black and may fail tinting on dark UI.

- **MEDIUM — Plan `04-02`: Inter acquisition is not pinned.**  
  “Latest Inter v4.x” plus no checksum makes builds non-reproducible. Pin exact release URL and SHA256.

- **MEDIUM — Plan `04-02` references stricken requirements.**  
  `FONT-02` / `FONT-03` are stricken, but Plan `04-02` includes them in requirements/commit refs. That will muddy traceability.

- **LOW — Grep-heavy verification can pass broken Godot resources.**  
  Many checks verify substrings instead of loading resources in Godot. Substring checks are fine as secondary checks, not primary validation.

## Suggestions

- Add a pre-implementation “canonical matrix” patch before Plan `04-05`: exact 37 Control rows, exact slot names, exact 13 variations, with no “executor selects/drops” language.
- Replace hand-authored import/resource sidecars with a Godot headless import/save task: import Inter and SVGs, create FontVariation resources via a script, save them, then commit actual generated `.import` / `.tres`.
- Add a `DIRECTION_PRESETS` internal table or resource metadata for non-exported per-direction formula parameters: spread, hover delta, pressed delta, disabled opacity. Keep it non-exported if the 9-export surface is locked.
- Make Plan `04-05` set `default_font` and `default_font_size` explicitly.
- Make Plan `04-08` depend on `04-07`, or split its structural verification into the phase verify step.
- Add one hard Godot load test per plan that creates resources: `ResourceLoader.load(...)`, `is NeoCadeTheme`, and key `has_*` assertions.
- Make all SVGs single-color unless there is a documented two-layer theme slot strategy.

## Risk Assessment

**Overall risk: HIGH.** The architecture is sound, but several plans can create syntactically plausible files that Godot may not load, and SC#7 is not currently well-defined enough to verify. Fix the resource-generation path, the exact coverage matrix, the variation list, the per-direction formula source, and the `04-08` dependency before execution.

Sources checked: Godot Theme API (`set_*`, `has_*`, type variations), StyleBoxFlat shadow/expand properties, FontVariation properties, DynamicFont importer properties, and Godot text scene/resource format docs.  
- https://docs.godotengine.org/en/stable/classes/class_theme.html  
- https://docs.godotengine.org/en/4.6/tutorials/ui/gui_theme_type_variations.html  
- https://docs.godotengine.org/en/latest/classes/class_styleboxflat.html  
- https://docs.godotengine.org/en/latest/classes/class_fontvariation.html  
- https://docs.godotengine.org/en/4.6/classes/class_resourceimporterdynamicfont.html  
- https://docs.godotengine.org/en/4.6/engine_details/file_formats/tscn.html

---

## Consensus Summary

### Agreed Strengths (raised by both reviewers)

- **Forbidden-surface discipline is intact** — no per-direction `.gd`, no `plugin.cfg`, no `_dev/`, no `themes/`, no `neocade_mobile_theme.tres`, no root `neocade_theme.tres`, no EditorInspectorPlugin. Every plan respects the locked architecture.
- **D-01 `clear()` prohibition is enforced** with grep-backed verification across every plan that touches `_regenerate_theme()`.
- **Pulse-first sequencing is correct** — Plan 04-06 gates the first end-to-end `.tres` before peer themes ship in Plan 04-07.
- **Wave 1 parallelism is sound** — Plans 01, 02, 03 are correctly independent (class shell ‖ fonts ‖ icons).
- **Binding-table approach is coherent and properly framed as REVISABLE** per CONTEXT.md D-03.
- **Atomic commit discipline + clean wave boundaries** across all 8 plans.

### Agreed HIGH Concerns (raised by both reviewers — top priority for replan)

1. **Coverage matrix is underspecified / non-deterministic.** Plan 04-05 Task 2 says "37 scorecard Controls" but supplied lists vary (39-ish names with executor-discretion-to-drop). No concrete slot-name enumeration per Control. Risk: SC#7 verification cannot deterministically pass; executor authors entries Godot won't recognize. Fix: freeze the canonical 37 Control rows + exact slot names per Control before Plan 04-05 executes.

2. **Per-direction `spread_factor` (and per-direction state-layer deltas: hover/pressed/disabled) are never implemented.** Plan 04-04 hard-codes `spread_factor = 1.0` with a comment that Plan 04-05 will supersede — but Plan 04-05 never adds per-direction sourcing. Result: all 5 directions render with identical surface ramps + state layers, collapsing the differentiation that DESIGN_TOKENS §5/§6 mandates (Pulse 1.3 wide, Slate 0.7 narrow, Bubble 1.0 medium, Daybreak 1.0 medium, Burst 1.3 wide; per-direction hover/pressed deltas in the .json shape_language axes).

3. **Theme `default_font` and `default_font_size` are never set.** Plans set fonts per type variation (per PITFALLS 1.2) but skip the theme-level defaults. FONT-06 requires `theme.default_font = Inter Variable Roman`. Result: any Control type that lacks an explicit `font` entry falls back to engine default (system font), not Inter.

### Codex-only HIGH Concerns (also adopted as Cycle 1 HIGHs)

4. **Type variation count mismatch (13 vs 14).** TYPEVAR-01..04 enumerated yields 14 (6 Button + 5 Label + 1 InfoText + 2 Panel). CONTEXT.md D-08 lists 14 names but says "13"; Plan 04-05 Task 1 declares 14; Plan 04-06 verifier asserts 13; ROADMAP Phase 5 SC#3 says 14. Pick a number — and verify whether `CodeLabel` is in or out — before execution.

5. **Hand-authored Inter-Variable.tres (FontFile wrapper), FontVariation .tres files, and `.import` sidecar use synthetic UIDs and hand-written serialization that may not match Godot's saved format.** Recommendation: drive these through Godot import (`godot --headless --import`) or a build-time `@tool` script, then commit the actual files Godot produces.

6. **Hand-written `.tres` header `[gd_resource type="NeoCadeTheme" script_class="NeoCadeTheme"]` may not match Godot's saved format for a GDScript `class_name` extending Theme.** Recommendation: create one `.tres` with `NeoCadeTheme.new()` + `ResourceSaver.save(...)` once, inspect the actual header Godot emits, then use that as the template.

7. **Plan 04-08 dependency is wrong.** Declares `depends_on: [04-02]` only, but Task 5 verifies files produced by 04-06 (Pulse `.tres`) and 04-07 (peer `.tres`). Either change `depends_on` to `[04-07]`, or move the structural verification to a phase-level VERIFICATION step.

### OpenCode-only Concerns (MEDIUM — addressed in next cycle)

- **`main.tscn` theme is cleared in Plan 04-01 then dangles for 6 plans until Plan 04-07.** Transient broken-scene state during execution. Suggestion: leave a placeholder reference or accept and document the gap.
- **`_phase4_verify.gd` uses EditorScript** which requires Godot Editor to run — pure GDScript or `--headless --script` alternative needed for autonomous verification.
- **`toggle_on.svg` / `toggle_off.svg` use dual-color (white track + black knob)** — modulate multiplies, so the black knob stays black after tinting. Verify the rendered result on accent-tinted backgrounds.

### Codex-only Concerns (MEDIUM)

- **Inter acquisition is not pinned** — "latest Inter v4.x" with no checksum makes builds non-reproducible. Pin exact release URL + SHA256.
- **Plan 04-02 references stricken requirements** (FONT-02 / FONT-03 are stricken per UD-4 Option D + REQUIREMENTS.md). Remove from `requirements:` and commit refs.
- **Raised-mode verification can fail by construction** — Plan 04-05 Task 3 BINDING_TABLE excerpt has `Button.normal raised_intensity = 0`, but Plan 04-06 expects `shadow_size > 0` after `raised = true`. Reconcile.

### LOW

- **Grep-heavy verification can pass syntactically broken Godot resources.** Add at least one `ResourceLoader.load()` + `is NeoCadeTheme` + key `has_*` assertion per plan that produces resources.
- **`README` `theme.duplicate()` for CJK override triggers a redundant `_regenerate_theme()` cycle on the duplicated resource.** Harmless but wasted work; consider documenting via `.fallbacks.append()` on the original then `duplicate()` if isolation is needed.

### Divergent Views

- **Type variation count.** OpenCode classifies the 13/14 mismatch as MEDIUM ("resolve the exact count, likely 14"); Codex classifies it as HIGH (blocks SC#7 strict verification). Treating as HIGH for Cycle 1 because: (a) it's a verification correctness issue, (b) Codex's strict reading is right — non-deterministic SC#7 is a goal-blocking concern.

### Overall Risk Assessment

**HIGH** — both reviewers landed on HIGH overall risk. The architecture is sound and the plan structure is good, but the plans currently contain enough underspecification + Godot-API-correctness risks that execution-as-written would likely produce files that pass grep checks but fail Godot resource loading or fail SC#7 verification. Replanning to address the 7 agreed/strong HIGH concerns is the right next step.
