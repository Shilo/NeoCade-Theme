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

---

# Cross-AI Plan Review — Phase 4 (Cycle 2)

**Reviewed:** 2026-05-06 (re-review after replan commit `7d8226d`)
**Reviewers:** OpenCode (DeepSeek V4 Pro), Codex
**Scope:** Verify cycle-1 HIGH concerns C1-C7 are resolved; identify new concerns introduced by replan.

## OpenCode Cycle 2 Review (DeepSeek V4 Pro)

## 1. Summary

All 7 Cycle 1 HIGH concerns are **FULLY RESOLVED** with concrete, verifiable acceptance criteria wired into each affected plan. The canon-37 freeze (C1), per-direction DIRECTION_PRESETS lookup (C2), theme-level `default_font`/`default_font_size` (C3), 14-variation count with CodeLabel restored (C4), Godot-serialized font/tres resource pipeline via ResourceSaver (C5/C6), and corrected Plan 04-08 dependency on 04-07 (C7) are each implemented and traceable to specific tasks, acceptance criteria, and verification commands. No new HIGH concerns were introduced. Two LOW concerns (stale comment remnant, fragile hex-key lookup) and one MEDIUM concern (the _phase4_import.gd manual executor edit on Plan 04-07's _run() re-extension) are noted below.

---

## 2. Per-Concern Resolution Status

### C1 — Coverage matrix non-deterministic

**Status: FULLY RESOLVED**

- **Plan 04-05, Task 2** explicitly enumerates the canonical 37 Control names verbatim from `MINIMAL-THEME-COVERAGE-DELTA.md` with the binding instruction: "NO executor discretion to add or drop. NO 'select 37 from 39'."
- **Plan 04-05 acceptance criteria** asserts `BINDING_TABLE` contains all 37 exact names as keys; verify command iterates the exact array and throws on any missing.
- **Plan 04-06 Task 2** verifier (`_phase4_verify.gd` + headless variant) asserts `binding_table.size() == 37` (exact equality, not `>=`) and checks every canonical name is present via `assert(binding_table.has(t))`.

### C2 — Per-direction spread_factor + state-layer deltas unimplemented

**Status: FULLY RESOLVED**

- **Plan 04-04, Task 3.5** introduces `const DIRECTION_PRESETS: Dictionary` keyed by `base_color` hex (5 entries: #151A2E, #111820, #241326, #0B2420, #20112E) with per-direction `spread_factor` (Pulse=1.3, Slate=0.7, Bubble=1.0, Daybreak=1.0, Burst=1.3), `hover_pct` (6/8/10/8/10), `pressed_pct` (-10/-12/-12/-12/-14), `disabled_opacity` (0.42/0.50/0.45/0.50/0.45). Includes `_resolve_direction_presets()` helper + `DIRECTION_PRESET_DEFAULT` fallback.
- **Plan 04-04, Task 4** `_regenerate_theme()` body sources all four values from `presets`: `var spread_factor: float = presets.spread_factor`, `var hover_pct: float = presets.hover_pct`, `var pressed_pct: float = abs(presets.pressed_pct)`, `var disabled_opacity: float = presets.disabled_opacity`. Acceptance criteria assert NO hard-coded literals (specifically verifies `= 1.0`, `8.0`, `12.0`, `0.38` are NOT present on those lines).
- 9-export surface preserved — `DIRECTION_PRESETS` is a `const`, not an `@export`.

### C3 — theme.default_font / default_font_size never set

**Status: FULLY RESOLVED**

- **Plan 04-05, Task 1** adds to `_regenerate_theme()` body BEFORE the BINDING_TABLE walk:
  ```gdscript
  var body_font := preload("res://addons/neocade_theme/fonts/Inter-Body.tres") as FontVariation
  default_font = body_font
  default_font_size = tokens.body
  ```
- Acceptance criteria assert the presence of both lines.
- **Plan 04-06 Task 2** verifier asserts `theme.default_font != null` and `theme.default_font_size > 0` (runtime check). FONT-06 closure documented in Plan 04-06 commit message.

### C4 — Type variation count mismatch (13 vs 14)

**Status: FULLY RESOLVED**

- **Plan 04-05, Task 1** TYPE_VARIATIONS declares exactly **14** entries: 6 Button (Primary/Secondary/Ghost/Danger/Icon/Flat) + 5 Label (HeaderLarge/Medium/Small/Caption/**CodeLabel**) + 1 InfoText + 2 Panel (CardPanel/HeroPanel). CodeLabel is INCLUDED (Cross-AI Cycle 1 C4 fix).
- Acceptance criteria verifies all 14 named entries + counts `set_font` calls ≥ 14 + `set_font_size` ≥ 12.
- **Plan 04-06** verifier asserts `type_variations.size() == 14` exactly + `type_variations.has("CodeLabel")`.
- **Plan 04-08 CHANGELOG.md** states "14 type variations" with CodeLabel listed.

### C5 — Hand-authored Inter-Variable.tres + FontVariation .tres + .import with synthetic UIDs

**Status: FULLY RESOLVED**

- **Plan 04-02, Task 2** creates `_phase4_import.gd` — a `@tool extends EditorScript` build helper. It:
  - Triggers Godot's TTF import by loading the .ttf (generating a real `.import` sidecar with Godot-assigned UIDs), then mutates only the `[params]` block values.
  - Saves `Inter-Variable.tres` via `ResourceSaver.save(inter_ttf, ...)` — Godot-assigned UID, Godot-serialized header.
  - Creates 5 `FontVariation` instances via `FontVariation.new()`, sets `base_font` to the loaded `Inter-Variable.tres`, and saves via `ResourceSaver.save()` — all UIDs are Godot-generated.
- **Tasks 3 and 4** are explicitly marked "SUPERSEDED" with no-action bodies; Task 2 is authoritative.
- Cross-AI Cycle 1 C5 explicitly named as this task's justification.

### C6 — Hand-written .tres header may not match Godot format

**Status: FULLY RESOLVED**

- **Plan 04-06, Task 1** creates `_save_pulse_tres()` in `_phase4_import.gd` using `NeoCadeTheme.new()` + `ResourceSaver.save()`. Captures + logs the Godot-emitted first line as the canonical template.
- **Plan 04-07, Task 1** creates `_save_peer_tres()` using the same pattern for all 4 peers: `NeoCadeTheme.new()` + `ResourceSaver.save()`. Headers match whatever Godot emitted for Pulse.
- Plan 04-06 verifier asserts `ResourceLoader.load() is NeoCadeTheme` (runtime type check, not string matching).

### C7 — Plan 04-08 wrong dependency declaration

**Status: FULLY RESOLVED**

- Plan 04-08 frontmatter: `depends_on: - "04-07"` with inline comment: `# Cross-AI Cycle 1 C7 fix: was [04-02]; Task 5 verifies files from 04-06 (Pulse) + 04-07 (peers + main.tscn). Depending only on 04-02 was wrong.`
- Plan 04-08 interfaces section explicitly explains the dependency change.
- Plan 04-08 Task 5 layout verification now correctly runs after all prior plans have landed their files.

---

## 3. New Concerns Introduced by Replan

### MEDIUM

**M1 — Plan 04-07 re-extension of `_phase4_import.gd` `_run()` is an inexact executor edit.**

Plan 04-06 adds `_save_pulse_tres()` and its call in `_run()`. Plan 04-07 instructs the executor to "append a new function and call it from `_run()` AFTER `_save_pulse_tres()`" — `_save_peer_tres()`. This requires the executor to locate the `_save_pulse_tres()` call inside `_run()`, which may have changed layout (whitespace, comments, additional font setup lines) from the abstract form in Plan 04-06's action text. If the executor inserts at the wrong position or fails to add the call entirely, `_save_peer_tres()` is defined but never executed, and Plan 04-07's peer .tres files are never generated. The acceptance criteria don't verify `_save_peer_tres()` is **called** inside `_run()` — only that the function declaration exists and `_run()` calls `_save_peer_tres()`. The verify command checks for the substring `_save_peer_tres()` in the file (which passes if it's only in the function definition), but does not explicitly verify it's inside `_run()`.

**Mitigation suggestion:** Plan 04-07 acceptance criteria or verify command should also check that `_run()` specifically contains the substring `_save_peer_tres()` (grep that `_save_peer_tres()` appears after `func _run()` and before the next `func` or EOF).

### LOW

**L1 — Stale NOTE in Plan 04-04 Task 4 contradicts the action code (C2 implementation).**

Plan 04-04 Task 4's action block correctly implements C2 (uses `presets.spread_factor` etc.), but the NOTE at the bottom of the action still claims: *"NOTE on `spread_factor`, `hover_pct`, `pressed_pct`, `disabled_opacity`: these are intentionally hard-coded to sensible defaults in this plan. Plan 04-05 supersedes them with per-direction values via the BINDING_TABLE or by reading direction metadata. The current values let the engine be functional..."* This is a pre-replan remnant. The actual code code block reads `presets.spread_factor` (NOT hard-coded). The acceptance criteria verify `presets.spread_factor` (NOT `1.0` literal). An executor reading the NOTE might be confused about whether the code or the note is canonical. The acceptance criteria are specific enough to catch errors, but the note adds noise.

**Mitigation suggestion:** Delete or update the NOTE to reflect that per-direction sourcing is now implemented via DIRECTION_PRESETS.

**L2 — `_resolve_direction_presets()` hex-key lookup is fragile under float round-trip.**

The lookup key is `base_color.to_html(false).to_upper()`. When a `.tres` is saved via `ResourceSaver`, `base_color` is serialized as `Color(0.0823529, 0.101961, 0.180392, 1)`. Upon reload, the Color is reconstructed from 32-bit floats. For the five approved direction hex values (#151A2E, #111820, #241326, #0B2420, #20112E), each channel value (0-255)÷255 can be represented exactly or near-exactly in 32-bit float, so the round-trip should produce the same `to_html()` output. However, there is no explicit verification in any plan that the round-trip is tested — the Plan 04-06 verifier checks `base_color == Color("#151A2E")` (equality test on Color, which uses float epsilon), but never verifies that `base_color.to_html(false)` resolves the correct DIRECTION_PRESETS entry. If a floating-point epsilon causes `to_html()` to output `151a2f` instead of `151a2e`, the lookup silently falls back to `DIRECTION_PRESET_DEFAULT` (spread=1.0, M3 baseline) — all 5 directions render identically, and no test catches it.

**Mitigation suggestion:** Add an assertion to Plan 04-06 verifier that `spread_factor` differs between Pulse (1.3) and Slate (0.7) when their respective `.tres` files are loaded — a simple cross-direction differentiation smoke test.

**L3 — Plan 04-06 verifier's `get_script().get_script_constant_map()` depends on script reflection in headless mode.**

The `_phase4_verify_headless.gd` accesses `theme.get_script().get_script_constant_map()` in `--headless` mode. While `GDScript.get_script_constant_map()` is available in all contexts (not editor-only), this is verification code only (deleted in Phase 11) and does not affect production behavior. Acceptable risk.

---

## 4. Risk Assessment: **LOW**

All 7 Cycle 1 HIGH concerns are fully resolved with verifiable, traceable implementations. The replan correctly freezes the canonical 37 coverage list, implements per-direction differentiation via DIRECTION_PRESETS, sets theme-level defaults, locks type variation count at 14 with CodeLabel, converts all font/tres file generation to Godot-serialized pipelines, and fixes the Plan 04-08 dependency. No new HIGH concerns were introduced. The one MEDIUM (Plan 04-07 `_run()` re-extension edit ambiguity) and three LOW concerns are correctable with minor acceptance-criteria additions or note cleanup — none block execution. The plan set is execution-ready.

---

## Codex Cycle 2 Review

**Summary**  
Cycle 2 resolves most of the resource-generation and dependency-ordering blockers, but I would not execute yet. The 37-row freeze, default font, 14 type variations, ResourceSaver `.tres` path, and Plan 04-08 dependency are materially fixed. Two execution blockers remain: C2 only partially fixes disabled opacity, and Plan 04-05’s BINDING_TABLE contract includes `font` entries but the iteration engine has no `font` branch.

**Per-Concern Status**

- **C1 — PARTIALLY RESOLVED.**  
  The 37-row non-determinism is fixed: Plan 04-05 freezes the canonical list and says “Count = 37 exact” with no add/drop discretion (`04-05...PLAN.md:23`, `:215`, `:344`). Plan 04-06 verifies `binding_table.size() == 37` and iterates `canonical_37` (`04-06...PLAN.md:222-224`).  
  Remaining gap: exact slot-name enumeration is still delegated to executor/dissection lookup, not frozen in the plan (`04-05...PLAN.md:235`, `:269`, `:288`, `:338`). The verifier only samples key types (`04-06...PLAN.md:227-229`), so wrong slot names can still pass broad row-count checks.

- **C2 — PARTIALLY RESOLVED.**  
  `DIRECTION_PRESETS` exists with per-direction `spread_factor`, `hover_pct`, `pressed_pct`, and `disabled_opacity` (`04-04...PLAN.md:290-305`), and `_regenerate_theme()` consumes spread/hover/pressed (`:363-409`).  
  Missing: `disabled_opacity` is assigned but not actually used. Plan 04-05 still hard-codes disabled alpha as `0.38` in Button recipes and recipe docs (`04-05...PLAN.md:249`, `:257`, `:283`). This leaves the disabled-opacity part of C2 unresolved.

- **C3 — FULLY RESOLVED.**  
  Plan 04-05 sets `default_font = body_font` and `default_font_size = tokens.body` before the BINDING_TABLE walk (`04-05...PLAN.md:129-134`). Plan 04-06 verifies both (`04-06...PLAN.md:240-242`, `:309-310`).

- **C4 — FULLY RESOLVED, with stale wording.**  
  Plan 04-05 defines 14 variations with `CodeLabel` included (`04-05...PLAN.md:97-124`) and acceptance requires all 14 plus explicit `CodeLabel` font (`:180-187`). Plan 04-06 verifies `type_variations.size() == 14` and `CodeLabel` (`04-06...PLAN.md:231-234`, `:315-319`).  
  Stale references to “13 variations” remain in prose (`04-05...PLAN.md:47`, `:49`, `:75`; `04-06...PLAN.md:21`, `:58`; `04-07...PLAN.md:25`). Treat as MEDIUM cleanup, not a blocker.

- **C5 — FULLY RESOLVED.**  
  Font `.tres` and FontVariation resources are now generated through `_phase4_import.gd` and `ResourceSaver.save()` (`04-02...PLAN.md:30-32`, `:215`, `:235`, `:288`, `:310`). Synthetic UID hand-authoring is removed from the font path.

- **C6 — FULLY RESOLVED for header generation.**  
  Pulse is generated via `NeoCadeTheme.new()` + `ResourceSaver.save()` (`04-06...PLAN.md:80-111`, `:131-147`) and verified with `ResourceLoader.load(path)` + `loaded is NeoCadeTheme` (`:202-204`). Peers use the same ResourceSaver path (`04-07...PLAN.md:87-123`, `:141-148`).  
  Minor gap: Plan 04-07 claims peer runtime load checks by extending verify scripts, but does not list or task edits to those verify files (`04-07...PLAN.md:8-14`, `:152`). MEDIUM.

- **C7 — FULLY RESOLVED.**  
  Plan 04-08 now depends on `04-07` and explicitly explains the prior dependency error (`04-08...PLAN.md:6-7`, `:60`). Its layout verification covers Pulse and peer theme files (`:540-573`).

**Cycle-1 Mediums**

- Main scene placeholder: resolved (`04-01...PLAN.md:25`, `:94-98`; restored in `04-07...PLAN.md:179-204`).
- Inter pin/SHA: resolved (`04-02...PLAN.md:103-115`, `:496`, `:521`).
- SVG strict monochrome: resolved (`04-03...PLAN.md:37`, `:110`, `:190`, `:205`).
- `Button.normal raised_intensity = 1`: resolved (`04-05...PLAN.md:245-267`, `:346`; verified in `04-06...PLAN.md:179`, `:326-330`).
- Headless verifier: resolved (`04-06...PLAN.md:181-183`, `:277-346`, `:367-371`).

**New Concerns**

- **HIGH — BINDING_TABLE contract includes `font`, but iteration never handles `font`.**  
  Plan 04-05 declares BINDING_TABLE data types include `font` (`04-05...PLAN.md:22`), but `_resolve_recipe` only supports stylebox/color/constant/font_size/icon and the walk only calls five setters, excluding `set_font(slot_name, theme_type, value)` (`:382`, `:493-495`, `:510`). If any base Control font entries are expected, they will not be applied or verified.

- **MEDIUM — Platform MOBILE content-margin claim is unsupported.**  
  Plan 04-06 says toggling MOBILE changes `Button.normal.content_margin_*` (`04-06...PLAN.md:24`), but Plan 04-05 sets margins from raw `spacing`, not platform tokens (`04-05...PLAN.md:425-428`). Either wire `tokens.densityScale`/`tapPadding` into stylebox resolution or remove that specific claim.

- **MEDIUM — Peer `.tres` runtime verification is claimed but not implemented.**  
  Plan 04-07 acceptance says peer files pass `ResourceLoader.load(path) is NeoCadeTheme`, “verified by extending” verify helpers (`04-07...PLAN.md:152`), but those helpers are not in `files_modified` or tasks.

- **LOW — Stale contradictory prose remains.**  
  `04-04` still says spread/state values are “intentionally hard-coded” and “Plan 04-05 supersedes” them (`04-04...PLAN.md:425`) even though the actual acceptance requires preset consumption. Also, `04-08` CHANGELOG lists non-canonical controls like `GraphFrame`, `GraphNode`, `HFlowContainer`, `HSeparator`, `VSeparator` (`04-08...PLAN.md:190-198`), reintroducing coverage-list noise in docs.

**Risk Assessment — HIGH**  
The replan is much stronger, but execution is not ready. C2 remains partially unresolved for disabled opacity, C1 still leaves exact slot names under-specified, and the missing `font` branch in the BINDING_TABLE walk is a new execution blocker for strict SC#7.

---

## Cycle 2 Consensus Summary

### Per-Concern Resolution (orchestrator aggregation — stricter reading wins)

| Concern | OpenCode | Codex | Aggregate |
|---|---|---|---|
| **C1** Coverage matrix freeze | FULLY RESOLVED | PARTIALLY RESOLVED (slot names still delegated to executor; verifier samples key types only) | **PARTIALLY RESOLVED** |
| **C2** Per-direction presets | FULLY RESOLVED | PARTIALLY RESOLVED (`disabled_opacity` assigned but Plan 04-05 still hard-codes 0.38 in Button recipes) | **PARTIALLY RESOLVED** |
| **C3** `default_font` + `default_font_size` | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **C4** 14 type variations + CodeLabel | FULLY RESOLVED | FULLY RESOLVED (stale "13 variations" prose remnants — MEDIUM cleanup, not a blocker) | **FULLY RESOLVED** |
| **C5** Godot-serialized fonts via ResourceSaver | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **C6** Programmatic `.tres` via `NeoCadeTheme.new()` + `ResourceSaver.save()` | FULLY RESOLVED | FULLY RESOLVED (minor MEDIUM: peer verifier extension claimed but not in `files_modified`) | **FULLY RESOLVED** |
| **C7** Plan 04-08 `depends_on: [04-07]` | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |

### NEW HIGH Concern Introduced by Cycle 1 Replan

- **N1 — BINDING_TABLE schema includes `font` data type but iteration engine has no `font` branch** (Codex HIGH).
  Plan 04-05 line 22 declares BINDING_TABLE data types include `font`, but `_resolve_recipe()` only supports stylebox / color / constant / font_size / icon (Plan 04-05 line 382), and the iteration walk only calls five setters at lines 493-495, 510 (excluding `set_font(slot_name, theme_type, value)`).
  **Impact:** if any base Control entries in BINDING_TABLE specify a `font` binding, those entries will be silently skipped — they will not be applied to the Theme and will not be verifiable by SC#7's "every type lists every expected slot" check. This blocks goal achievement for any Control where a per-Control font is required (likely few — most Controls inherit from `default_font` which IS set per C3 — but the schema gap is real).

### NEW MEDIUM/LOW Concerns

- **MEDIUM — Plan 04-07 `_phase4_import.gd._run()` re-extension is an inexact executor edit** (OpenCode M1). Verify command checks the substring `_save_peer_tres()` exists in the file, but doesn't verify it's CALLED inside `_run()`. If executor only adds the function definition, peer `.tres` files are never generated.
- **MEDIUM — Platform=MOBILE content-margin claim unsupported** (Codex). Plan 04-06 line 24 says toggling MOBILE changes `Button.normal.content_margin_*`, but Plan 04-05 lines 425-428 set margins from raw `spacing`, not platform tokens. Either wire `tokens.densityScale`/`tapPadding` into stylebox resolution or remove the claim.
- **MEDIUM — Peer `.tres` runtime verification claimed but not implemented in tasks** (Codex). Plan 04-07 line 152 acceptance says peers pass `ResourceLoader.load(path) is NeoCadeTheme` "verified by extending" verify helpers, but those helpers aren't listed in `files_modified` or tasks.
- **LOW — `_resolve_direction_presets()` hex-key lookup is fragile under float round-trip** (OpenCode L2). Cross-direction differentiation smoke test recommended.
- **LOW — Stale "13 variations" / "Plan 04-05 supersedes" / non-canonical CHANGELOG control names** in plan prose remnants (Codex + OpenCode). Doc cleanup, not execution-blocking.

### Risk Assessment Summary

- **OpenCode:** LOW (plan set is execution-ready)
- **Codex:** HIGH (3 execution blockers remain: C1 slot names + C2 disabled_opacity + N1 font branch)
- **Aggregate:** HIGH — strictest reviewer wins for execution gate.

**Unresolved HIGH count for cycle 2: 3** (C1 partial + C2 partial + N1 new). Down from cycle 1's 7. No stall. Replan cycle 3 should freeze slot names per Control, wire `disabled_opacity` everywhere, and add the `font` branch to the iteration engine.
