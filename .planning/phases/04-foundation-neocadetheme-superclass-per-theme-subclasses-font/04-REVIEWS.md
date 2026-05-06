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

---

# Cross-AI Plan Review — Phase 4 (Cycle 3 — FINAL at max-cycles gate)

**Reviewed:** 2026-05-06 (re-review after replan commit `31903c8`)
**Reviewers:** OpenCode (DeepSeek V4 Pro), Codex
**Scope:** Verify cycle-2 HIGH concerns (C1/C2/N1) are FULLY RESOLVED; identify new concerns introduced by cycle-2-to-3 replan.

## OpenCode Cycle 3 Review (DeepSeek V4 Pro)

## 1. Summary

All three cycle-2 unresolved HIGH concerns (C1, C2, N1) are **FULLY RESOLVED** with concrete, verifiable acceptance tests embedded in the plans. All six MEDIUM/LOW concerns are also fully addressed. One new MEDIUM concern identified (N2 — `.tres` serialization bloat), one new LOW concern (N3 — `get_script_constant_map()` runtime fragility). No HIGH concerns remain that would trigger the escalation gate. Phase 4 is ready to execute.

---

## 2. Per-Concern Resolution Status

### C1 — Coverage matrix slot-name enumeration (Cycle 2: PARTIALLY RESOLVED)
**FULLY RESOLVED**

Evidence:
- **Plan 04-05 Task 2.5** creates `CANONICAL_SLOT_NAMES: Dictionary` with verbatim slot-name arrays for 22 complex Controls (Tree's 16 styleboxes, Button's 6+12 slots, LineEdit's 3, PopupMenu's 5, Window's 2, both ScrollBars' 5, ItemList's 9, etc.). Remaining 15 simpler Controls verify via BINDING_TABLE key existence.
- **Plan 04-06 Task 2** (both verifier variants) iterate `CANONICAL_SLOT_NAMES.keys()`, match on `"stylebox"/"color"/"constant"/"font_size"/"icon"`, and assert `theme.has_*(slot_name, theme_type)` for each frozen slot. Failures produce `"CANONICAL_SLOT_NAMES freeze fail: %s.%s.%s missing"` — wrong slot names cannot pass.
- **Plan 04-06 acceptance criteria**: verifier contains CANONICAL_SLOT_NAMES reference, `for theme_type in canonical_slots.keys():`, `match dt:` branches, and the freeze-fail assertion message.
- **Plan 04-06 verify command**: PowerShell checks both verifier files contain `'CANONICAL_SLOT_NAMES'`, `'for theme_type in canonical_slots.keys():'`, `'match dt:'`, all 5 has_* branch patterns, and `'CANONICAL_SLOT_NAMES freeze fail'`.

### C2 — `disabled_opacity` hard-coded 0.38 despite DIRECTION_PRESETS (Cycle 2: PARTIALLY RESOLVED)
**FULLY RESOLVED**

Evidence:
- **Plan 04-04 Task 4**: `_regenerate_theme()` sources `presets.disabled_opacity` per direction. `DIRECTION_PRESET_DEFAULT` holds `0.38` as custom-theme fallback ONLY.
- **Plan 04-05 Task 3**: `_resolve_recipe` stylebox branch: `var is_disabled: bool = recipe.get("disabled", false)` → `alpha = presets.disabled_opacity`. Color branch: identical pattern. NO hard-coded `0.38` in either branch.
- **Plan 04-05 BINDING_TABLE recipes**: use `"disabled": true` flag, no `"alpha": 0.38` literals.
- **Plan 04-06 Task 2 verifiers**: assert `Button.font_disabled_color.a == 0.42` (Pulse's DIRECTION_PRESETS value). Headless variant: same check.
- **Plan 04-05 Task 3 verify command**: extracts `_resolve_recipe` body via regex, asserts `0.38` does NOT appear inside it. Also extracts Button recipe section from BINDING_TABLE, asserts `"alpha": 0.38` does NOT appear.

### N1 — `font` data type in BINDING_TABLE schema without handler (Cycle 2: HIGH, new)
**FULLY RESOLVED**

Evidence:
- **Plan 04-05 schema**: "Cross-AI Cycle 2 N1 fix: the `font` data type is REMOVED from the schema — per-Control fonts go through `theme.default_font`... Explicit `set_font()` calls on the 14 type variations."
- **Plan 04-05 Task 3 `_resolve_recipe`**: 5 branches only (stylebox/color/constant/font_size/icon). NO font branch. Unknown data_type returns null.
- **Plan 04-05 Task 3 iteration walk**: 5 setter calls only (set_stylebox/set_color/set_constant/set_font_size/set_icon). NO set_font on per-slot walk.
- **Plan 04-05 Task 1**: 14 explicit `set_font("font", variation, ...)` calls outside the BINDING_TABLE walk + `theme.default_font = body_font`.
- **Plan 04-05 Task 3 verify command**: regex asserts `elif data_type == "font"` NOT in `_resolve_recipe` body. Regex asserts `set_font(slot_name, theme_type,` NOT in the BINDING_TABLE walk section.
- **Plan 04-01 class docstring**: documents the binding mechanism as REVISABLE per D-03.

### M1 — `_save_peer_tres()` defined but unverified as called inside `_run()`
**FULLY RESOLVED**

Evidence:
- **Plan 04-07 Task 1 verify command**: Extracts `_run()` body via `(?s)func _run\\(\\)[^\\n]*\\n(.*?)(?=^func |\\Z)` regex, asserts `_save_peer_tres()` appears WITHIN the extracted body. Also checks `_save_pulse_tres()` similarly. Distinguished from mere file-level presence.

### M2 — Platform tokens (densityScale + tapPadding) unwired to stylebox margins
**FULLY RESOLVED**

Evidence:
- **Plan 04-05 Task 3 `_resolve_recipe`**: Stylebox branch computes `h_margin` and `v_margin` using `tokens.get("densityScale", 1.0)` and `tokens.get("tapPadding", 0)`. Formula: `int(spacing * density) + tap_pad` for horizontal, `int(spacing * 0.6 * density) + tap_pad` for vertical.
- **Plan 04-05 Task 3 acceptance criteria** tag these as M2 fix wires.
- **Plan 04-06 Task 2** (both verifiers): Toggles `NeoCadeTheme.Platform.DESKTOP` / `NeoCadeTheme.Platform.MOBILE`, captures `Button.normal.content_margin_left`, asserts `mobile_margin > desktop_margin`.
- **Plan 04-06 acceptance criteria**: "File contains `tokens.get(\"densityScale\"` and `tokens.get(\"tapPadding\"` and `mobile_margin > desktop_margin` assertion."

### M3 — Peer .tres file runtime validation only-claimed (not implemented)
**FULLY RESOLVED**

Evidence:
- **Plan 04-07 Task 1.5 (NEW)**: Explicitly added task. Extends `_phase4_verify.gd` with `_verify_peers()` function called from `_run()`. Extends `_phase4_verify_headless.gd` with peer iteration in `_init()`.
- Both iterate all 4 peer filenames, assert `ResourceLoader.load(path)`, `loaded is NeoCadeTheme`, `has_stylebox("normal", "Button")`, `_resolve_direction_presets().spread_factor` matches expected (0.7/1.0/1.0/1.3).
- **Plan 04-07 Task 1.5 acceptance criteria**: Both files contain 4 filenames, `_verify_peers()`, `is NeoCadeTheme`, `spread_factor` checks. Headless variant accumulates failures.
- **Plan 04-07 Task 1.5 verify command**: PowerShell confirms both files reference all 4 filenames + spread_factor assertions.

### L1 — Stale "13 variations" + "Plan 04-05 supersedes" remnants
**FULLY RESOLVED**

Evidence:
- Plan 04-05 TYPE_VARIATIONS: "14 entries exact" (6+5+1+2), "Cross-AI Cycle 1 C4 fix".
- Plan 04-06 verifier: `type_variations.size() == 14`.
- Plan 04-08 CHANGELOG: "14 type variations".
- No "13 variations" nor "supersedes" text found in any plan.

### L2 — No cross-direction differentiation smoke test in verify
**FULLY RESOLVED**

Evidence:
- **Plan 04-06 Task 2** (both verifiers): Constructs in-memory Slate with `base_color = Color("#111820")`, calls `_resolve_direction_presets()`, asserts `abs(slate spread_factor - 0.7) < 0.001`, and asserts `|Pulse spread - Slate spread| > 0.5`.
- **Plan 04-06 acceptance criteria**: "File contains the cross-direction smoke test" with `Color("#111820")` and spread_factor difference assertion.
- **Plan 04-06 verify command**: PowerShell checks for `'slate_test: NeoCadeTheme'`, `'Color(\"#111820\")'`, `'spread_factor'`.

### L3 — CHANGELOG lists non-canonical Controls (GraphFrame/GraphNode/etc.)
**FULLY RESOLVED**

Evidence:
- **Plan 04-08 Task 2 CHANGELOG**: Explicitly lists all 37 canonical names. Has explicit L3 fix note: "list trimmed to the canonical 37."
- **Plan 04-08 Task 2 acceptance criteria**: "File does NOT contain non-canonical names GraphFrame, GraphNode, HFlowContainer, HSeparator, VSeparator in the Phase 4 coverage prose."
- **Plan 04-08 Task 2 verify command**: PowerShell asserts each of the 5 non-canonical names does NOT appear and each of the 37 canonical names DOES appear.

---

## 3. NEW Concerns from Cycle-2-to-3 Replan

### N2 — `.tres` files are non-data-oriented due to `ResourceSaver.save()` serialization (MEDIUM)

**What**: Plan 04-06 Task 1 and Plan 04-07 Task 1 generate `.tres` files via `NeoCadeTheme.new()` → set exports → `ResourceSaver.save()`. But `NeoCadeTheme.new()` triggers `_init()` → `_regenerate_theme()`, which populates thousands of theme entries. `ResourceSaver.save()` serializes ALL of them into the `.tres` — styleboxes, colors, constants, icons for all 37 Controls × multiple states. The resulting `.tres` files are NOT "data-oriented" (only `@export` values) as SC#6 requires. They carry a full copy of all regenerated entries alongside the 9 `@export` values.

**Impact**: Files are bloated (potentially hundreds of KB instead of <1KB). Functionally correct — `_init()` regenerates on load and overwrites the stale entries. But contradicts SC#6 intent and creates brittle files where stale entries could mask regeneration bugs.

**Mitigation**: Low — the plan is self-correcting (regeneration overwrites on load). A Phase 4 post-execute cleanup could regenerate files with `_init()` disabled. Or accept the bloat as v1 expedience and fix in a later phase. Does NOT block correctness.

**Suggested fix**: After `NeoCadeTheme.new()` and `ResourceSaver.save()`, re-open the `.tres` file and strip out all theme-entry sections (keeping only `@export` properties). Or use a post-generation script. Not required to close this review — flag for executor awareness.

### N3 — `get_script_constant_map()` reliance for runtime verification (LOW)

**What**: Plan 04-06 and 04-07 verifiers access `BINDING_TABLE`, `TYPE_VARIATIONS`, and `CANONICAL_SLOT_NAMES` via `theme.get_script().get_script_constant_map().get("BINDING_TABLE", {})`. This depends on Godot 4.6 GDScript exposing class-level `const` values through `Object.get_script_constant_map()`.

**Impact**: If this API doesn't include consts (only `const` enums or script constants), the fallback `{}` returns empty dicts causing false-negative assertions (e.g., `binding_table.size() != 37`). The verifier would FAIL-loud, not silently pass. The issue is self-detecting but may block automated CI.

**Mitigation**: Fails-loud with clear messages. The executor can work around by directly referencing `NeoCadeTheme.BINDING_TABLE` (static access via class_name) if `get_script_constant_map()` doesn't work. LOW severity — does not affect theme correctness, only verification tooling.

---

## 4. Risk Assessment: LOW

All three cycle-2 HIGHs are fully resolved with verifiable acceptance tests. No new HIGH concerns. Two new concerns (N2 MEDIUM — cosmetic bloating, N3 LOW — verification tooling) do not block execution or correctness. The Phase 4 plan set is converged and ready for `/gsd-execute-phase 4`.

---

## Codex Cycle 3 Review

**Summary**

C1, C2, N1 and the listed M/L concerns are resolved in the plan text with verifiable acceptance tests. However, I found one new HIGH outside those fixes: the `.tres` generation flow saves a `NeoCadeTheme` after `_regenerate_theme()` has populated Theme entries, which conflicts with the locked “data-only `.tres`” architecture and the Plan 04-06 file-size assertions.

**Per-Concern Resolution Status**

- **C1: FULLY RESOLVED**
  Evidence: Plan 04-05 Task 2.5 adds `const CANONICAL_SLOT_NAMES: Dictionary = {` and states `BINDING_TABLE recipe slot-keys MUST match these arrays exactly.` Plan 04-06 Task 2 verifies this by iterating `CANONICAL_SLOT_NAMES` and calling `theme.has_stylebox/color/constant/font_size/icon(...)`.

- **C2: FULLY RESOLVED**
  Evidence: Plan 04-05 Task 2 changes disabled recipes to `"disabled": true`. Plan 04-05 Task 3 `_resolve_recipe()` passes `presets` and sets `alpha = presets.disabled_opacity` in both stylebox and color branches. Plan 04-06 Task 2 asserts `Button.font_disabled_color.a` equals Pulse `0.42`.

- **N1: FULLY RESOLVED**
  Evidence: Plan 04-05 must-haves say the `font` data type is removed from `BINDING_TABLE`. Plan 04-05 Task 3 says `_resolve_recipe` supports only `stylebox`, `color`, `constant`, `font_size`, `icon`, and the walk has no `set_font(slot_name, theme_type, ...)` branch. Fonts are handled by `default_font` plus 14 explicit `set_font("font", variation, ...)` calls.

- **M1: FULLY RESOLVED**
  Evidence: Plan 04-07 Task 1 acceptance explicitly requires `_run()` body extraction by regex and checks `_save_peer_tres()` is called inside that body.

- **M2: FULLY RESOLVED**
  Evidence: Plan 04-05 Task 3 wires `tokens.get("densityScale", 1.0)` and `tokens.get("tapPadding", 0)` into stylebox margins. Plan 04-06 Task 2 verifies `mobile_margin > desktop_margin`.

- **M3: FULLY RESOLVED**
  Evidence: Plan 04-07 Task 1.5 adds `_verify_peers()` and extends the headless verifier. Both load all 4 peers, assert `is NeoCadeTheme`, assert `has_stylebox("normal", "Button")`, and verify spread factors.

- **L1: FULLY RESOLVED**
  Evidence: Plan 04-05 Task 1 locks `TYPE_VARIATIONS` to 14 with `CodeLabel` included. Plan 04-06 Task 2 asserts `type_variations.size() == 14`. I found no stale “13 variations” or “Plan 04-05 supersedes” remnants in the provided 04-04 through 04-07 text.

- **L2: FULLY RESOLVED**
  Evidence: Plan 04-06 Task 2 constructs `slate_test: NeoCadeTheme`, sets `base_color = Color("#111820")`, and asserts Slate spread factor `0.7` differs from Pulse `1.3` by `> 0.5`.

- **L3: FULLY RESOLVED**
  Evidence: Plan 04-08 Task 2 lists the canonical 37 Controls and its verifier throws if `GraphFrame`, `GraphNode`, `HFlowContainer`, `HSeparator`, or `VSeparator` appear.

**New Concerns**

- **HIGH - `.tres` generation likely violates data-only architecture**
  Evidence: Plan 04-01 Task 2 defines `_init() -> _regenerate_theme()`. Plan 04-05 Task 3 makes `_regenerate_theme()` populate Theme entries via `set_stylebox`, `set_color`, `set_constant`, `set_font_size`, and `set_icon`. Plan 04-06 Task 1 then does `var pulse: NeoCadeTheme = NeoCadeTheme.new()` and `ResourceSaver.save(pulse, ...)`.
  
  A Godot `Theme` resource with populated entries will normally serialize those entries into the `.tres`. That conflicts with Plan 04-06’s claim that `pulse_neocade_theme.tres` is 200-1500 bytes and saves only 9 export values. It also conflicts with the project’s “saved `.tres` files stay data-oriented” rule. This needs manual design review before execution.

- **MEDIUM - Plan 04-06 Task 1 has a verify/template mismatch**
  Evidence: the template uses `var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"` then `ResourceSaver.save(pulse, path)`, but the automated verifier searches for literal `ResourceSaver.save(pulse, "res://addons/neocade_theme/pulse_neocade_theme.tres")`. A correct implementation following the template can fail the plan verifier.

**Risk Assessment**

Overall risk: **HIGH**, due to the new `.tres` serialization architecture conflict. The original Cycle 2 HIGHs are resolved, but this new issue can block Plan 04-06/04-07 execution or silently violate the locked resource format goal.

---

## Cycle 3 Consensus Summary

### Per-Concern Resolution

| Concern | OpenCode | Codex | Aggregate |
|---|---|---|---|
| **C1** Slot-name freeze | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **C2** `disabled_opacity` consumption | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **N1** `font` schema vs walk alignment | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **M1** `_save_peer_tres()` called inside `_run()` | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **M2** Platform tokens wired to margins | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **M3** Peer `.tres` runtime verification | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **L1** Stale "13 variations" prose | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **L2** Cross-direction differentiation smoke test | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| **L3** CHANGELOG canonical 37 trim | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |

### NEW Concerns from Cycle-2-to-3 Replan

#### N4 — `.tres` serialization architecture conflict

- **OpenCode:** flagged as **MEDIUM** ("N2 — `.tres` files are non-data-oriented due to `ResourceSaver.save()` serialization"). Self-correcting at runtime (regeneration overwrites stale entries on load).
- **Codex:** flagged as **HIGH** (".tres generation likely violates data-only architecture"). Conflicts with locked SC#6 ("saved `.tres` files stay data-oriented") AND with Plan 04-06's own file-size assertions (200-1500 bytes claim).
- **Aggregate (stricter reading wins): HIGH.**

**Root cause:** Plan 04-06 Task 1 + Plan 04-07 Task 1 generate `.tres` via `NeoCadeTheme.new()` → `_init()` triggers `_regenerate_theme()` → populates thousands of Theme entries → `ResourceSaver.save()` serializes EVERYTHING into the `.tres`. Result: `.tres` files contain the 9 `@export` values PLUS a frozen snapshot of the regenerated stylebox/color/constant/font_size/icon entries.

**Why this matters:**
1. **Violates SC#6** (locked architecture decision): "saved `.tres` files stay data-oriented" — contradicted by serialized entry bloat.
2. **Plan 04-06 file-size assertion contradicted:** the plan claims `pulse_neocade_theme.tres` will be ~200-1500 bytes; actual size with serialized entries will be much larger (10s-100s of KB).
3. **Brittle:** stale serialized entries could mask `_regenerate_theme()` regression bugs (the file appears to "work" because it has entries baked in, even if regeneration is broken).
4. **Self-correcting at runtime:** on load, `_init()` runs first and regenerates — so functionally the theme renders correctly. But the bloat + SC#6 violation remain.

**Suggested fixes (Phase 4 must pick one):**
- **A.** After `ResourceSaver.save()`, post-process the `.tres` file textually to strip everything except the `@export` block (preserving only 9 properties + the resource header). Verify file size < 2KB.
- **B.** Save BEFORE `_regenerate_theme()` runs — gate the populate phase with `if not Engine.is_editor_hint(): return` or similar, so `NeoCadeTheme.new()` produces an empty Theme that `ResourceSaver` can save cleanly. But this contradicts D-01 (regenerate must run on @export setter, including `.new()` defaults).
- **C.** Use a different save mechanism that captures only `@export` values. Hand-author the `.tres` text from a known Godot-emitted template (one-time captured at execute time) — re-introduces the cycle-1 C6 risk but with empirical Godot output as the template, not speculation.
- **D.** Accept the bloat as v1 expedience, drop SC#6 wording from "data-oriented" to "regenerated-on-load", and update Plan 04-06 file-size assertion. Documents the architectural reality.

#### N5 (Codex) — Plan 04-06 Task 1 verify/template path mismatch (MEDIUM)

The template uses `var path := "res://addons/neocade_theme/pulse_neocade_theme.tres"` then `ResourceSaver.save(pulse, path)`, but the automated verifier searches for the literal `ResourceSaver.save(pulse, "res://addons/neocade_theme/pulse_neocade_theme.tres")` (variable inlined). A correct implementation following the template can fail the verifier.

#### N3 / OpenCode — `get_script_constant_map()` runtime fragility (LOW)

Verifier accesses `theme.get_script().get_script_constant_map()` to read `BINDING_TABLE` / `TYPE_VARIATIONS` / `CANONICAL_SLOT_NAMES`. If Godot 4.6 doesn't expose const dictionaries through this API, the fallback `{}` returns empty dicts and assertions fail-loud. Self-detecting; can be worked around by direct class-name access (`NeoCadeTheme.BINDING_TABLE`).

### Risk Assessment

- **OpenCode:** LOW (plan set is execution-ready; N2/N3 don't block)
- **Codex:** HIGH (.tres serialization architecture conflict is a real blocker)
- **Aggregate: HIGH** — N4 is real and contradicts a locked SC. Cannot ship as-is without explicit user decision.

### Convergence Status

- Cycle 1 HIGH: 7
- Cycle 2 HIGH: 3 (decreasing)
- Cycle 3 HIGH: 1 (decreasing — the original 7 + 3 are all resolved; one new HIGH introduced by the replan path itself)
- **Stall: NO** (each cycle decreased; the path was C1-C7 → C1+C2+N1 → N4 — a new concern, not a recurring one)
- **Max cycles reached:** YES (3/3)
- **Escalation gate triggered.**

The original 7 HIGHs and the cycle-2 emergent HIGH are all closed. The remaining HIGH (N4) is an architectural side-effect of resolving cycle-1's C5/C6 (Godot-serialized fonts + .tres files via ResourceSaver) — adopting that path conflicted with the locked SC#6 "data-oriented" constraint. The user must decide whether to:
1. Run a 4th cycle (override max_cycles=3) to resolve N4,
2. Proceed anyway with N4 acknowledged as a known issue (Phase 4 executor will discover it on first .tres save),
3. Stop and review manually.

---

# Cross-AI Plan Review — Phase 4 (Cycle 4 — N4 fix verification, max-cycles override)

**Reviewed:** 2026-05-06 (re-review after replan commit `e2c175b`)
**Reviewers:** OpenCode (DeepSeek V4 Pro), Codex
**Scope:** Verify cycle-3 N4 (.tres bloat) is FULLY RESOLVED via Fix A textual strip.

## OpenCode Cycle 4 Review (DeepSeek V4 Pro)

## Cross-AI Plan Review — Cycle 4 (N4 Fix)

### 1. N4 Resolution Status: PARTIALLY RESOLVED

**The textual strip approach is correct in principle and addresses the bloat concern.** The fix adds `_strip_theme_entries(path)` after each `ResourceSaver.save()` call, preserving only the `[gd_resource ...]` header + 9 `@export` property lines on `[resource]`. The `< 2048` byte size assertion catches failures at both save-time (Plan 04-06 Task 1, Plan 04-07 Task 1) and layout-time (Plan 04-08 Task 5).

**Evidence:**
- Plan 04-06 Task 1: `_strip_theme_entries(path)` defined with line-based section parsing, `EXPORT_KEYS` whitelist, `[sub_resource]` block skip, and `< 2048` assertion
- Plan 04-06 Task 1: `_save_pulse_tres()` invokes `_strip_theme_entries(path)` AFTER `ResourceSaver.save(...)` and AFTER the C6 header-first-line capture
- Plan 04-07 Task 1: `_save_peer_tres()` invokes `_strip_theme_entries(path)` for each of the 4 peers
- Plan 04-07 Task 1 verify: checks each peer `.tres` for `< 2048` bytes AND absence of `[sub_resource` / `theme_data/`
- Plan 04-08 Task 5: layout-time re-check on all 5 `.tres` files for `< 2048`

**Remaining gap (MEDIUM):** The `EXPORT_KEYS` whitelist does not include `"script"`. If Godot 4.6 serializes NeoCadeTheme with `script = ExtResource(...)` inside the `[resource]` block (instead of `script_class="NeoCadeTheme"` in the header), the strip drops the script reference, making the resource load as a plain `Theme` instead of `NeoCadeTheme`. The Plan 04-06 verifier (`loaded is NeoCadeTheme`) would catch this at runtime, but requiring a re-plan cycle after execution.

**Recommended pre-emptive fix:** Add `"script"` to `EXPORT_KEYS` in Plan 04-06 Task 1. Cost: one extra line preserved per .tres (~50 bytes).

---

### 2. Regression Check — All Prior Fixes Intact

| Concern | Status | Evidence |
|---------|--------|----------|
| **C1** (37 canonical rows, no executor discretion) | INTACT | Plan 04-05 Task 2 BINDING_TABLE has exact 37-key list; Plan 04-06 verifier asserts `binding_table.size() == 37`; list unchanged in Cycle 4 |
| **C2** (per-direction presets, not hard-coded) | INTACT | Plan 04-04 Task 3.5 DIRECTION_PRESETS unchanged; Plan 04-05 `_resolve_recipe` reads `presets.disabled_opacity`; Plan 04-06 verifier asserts `0.42 != 0.38` |
| **C3** (default_font set before BINDING_TABLE walk) | INTACT | Plan 04-05 Task 1 sets `default_font = body_font`; Plan 04-06 verifier asserts `default_font != null` |
| **C4** (TYPE_VARIATIONS = 14 with CodeLabel) | INTACT | Plan 04-05 Task 1 has all 14 entries incl. CodeLabel; Plan 04-06 verifier asserts `size() == 14` and `has("CodeLabel")` |
| **C5** (Godot-serialized fonts, not hand-authored) | INTACT | Plan 04-02 unchanged; fonts still generated via `ResourceSaver.save()` |
| **C6** (Pulse .tres via ResourceSaver, not hand-authored) | INTACT | Plan 04-06 Task 1 still calls `ResourceSaver.save(pulse, ...)`; strip is post-save; header form preservation verified |
| **C7** (Plan 04-08 depends on 04-07) | INTACT | Plan 04-08 frontmatter still shows `depends_on: ["04-07"]` |
| **N1** (no `font` data type in BINDING_TABLE walk) | INTACT | Plan 04-05 Task 3 has 5 setter branches, no `set_font`; verifier grep confirms |
| **M1** (_save_peer_tres() called inside _run() body) | INTACT | Plan 04-07 Task 1 verifier extracts `_run()` body and asserts `_save_peer_tres()` appears WITHIN it |
| **M2** (platform-aware margins via densityScale + tapPadding) | INTACT | Plan 04-05 `_resolve_recipe` reads `tokens.densityScale` / `tokens.tapPadding`; Plan 04-06 verifier asserts `mobile_margin > desktop_margin` |
| **M3** (peer-load verification in both verifiers) | INTACT | Plan 04-07 Task 1.5 adds `_verify_peers()` to EditorScript variant + peer checks to headless variant; verifiers confirm |
| **L1** (removed pre-replan hard-coded note) | INTACT | Plan 04-04 Task 4 body explicitly says "previous 'intentionally hard-coded' NOTE is REMOVED" |
| **L2** (cross-direction spread differentiation smoke test) | INTACT | Plan 04-06 verifier constructs in-memory Slate and asserts `abs(1.3 - 0.7) > 0.5` |
| **L3** (CHANGELOG lists 37 canonical, no non-canonical Controls) | INTACT | Plan 04-08 Task 2 CHANGELOG enumerates all 37; verifier greps for absence of GraphFrame/GraphNode/HFlowContainer/HSeparator/VSeparator |

All 15 prior fixes survive the Cycle 4 replan changes. The Cycle 4 changes are scoped to Plans 04-06/04-07/04-08 only, and are additive — no prior fix code was modified.

---

### 3. New Concerns from Cycle 3→4 Replan

#### MEDIUM: `_strip_theme_entries` may drop `script` property from `[resource]`

- **Location:** Plan 04-06 Task 1, `_strip_theme_entries()` body
- **What happens:** The `EXPORT_KEYS` array hard-codes the 9 export property names. If Godot 4.6 serializes NeoCadeTheme with `script = ExtResource("uid_for_neocade_theme_gd")` **inside** `[resource]` (rather than `script_class="NeoCadeTheme"` in the header), the strip drops it. The resource loads as plain `Theme`, `_init()` never fires, no entries populate.
- **Mitigation:** Plan 04-06's verifier asserts `loaded is NeoCadeTheme` at runtime — this catches the failure post-strip and forces a correction cycle. But the plan should pre-empt this.
- **Fix cost:** Add `"script"` to `EXPORT_KEYS` (one line). If Godot never emits `script=` inside `[resource]`, it's a no-op. If it does, it prevents a breakage.
- **Verdict:** MEDIUM. Runtime verifier catches it; plan should pre-empt it.

#### LOW: Multi-regeneration waste during .tres generation

- **Location:** Plan 04-06 Task 1 `_save_pulse_tres()`
- **What happens:** `NeoCadeTheme.new()` triggers `_init()` → `_regenerate_theme()`. Then each of the 9 `@export` assignments triggers regeneration again (short-circuit prevents no-ops, but 5 of Pulse's 9 values differ from defaults). Total: 6 regenerations to produce one .tres. The post-strip discards the bloat; no correctness impact, just wasted CPU.
- **Verdict:** LOW. Efficiency concern only; doesn't affect correctness.

#### LOW: Additional strip edge-cases

- **`_last_regeneration_usec`:** Non-exported `var` — Godot doesn't serialize it. No risk.
- **Multi-line `[gd_resource]` header:** Godot 4.6 uses single-line headers. If future Godot wraps them, lines between headers would be dropped (section != "" and section != "[resource]"). Unlikely in v1 scope.

---

### 4. Final Risk Assessment

| Risk | Level | Blocking? |
|------|-------|-----------|
| Strip drops `script = ExtResource(...)` in `[resource]` | MEDIUM | No (runtime verifier catches post-strip) |
| Multi-regeneration waste | LOW | No |
| Future Godot header format changes | LOW | No |
| **No HIGH concerns remain.** | | |

**The N4 fix is structurally sound.** The textual-strip approach is line-based (no regex fragility), handles `[sub_resource]` blocks and `theme_data/` entries correctly, and has dual-layer size assertions (save-time + layout-time). The one MEDIUM concern (possible `script` property drop) has a runtime safety net and a trivial pre-emptive fix.

**Convergence verdict: Converge.** Zero HIGH concerns. The plan achieves the goal — `.tres` files stay data-oriented (< 2048 bytes) with all baseline entries recomputed at load time. Prior fixes are intact.

---

## Codex Cycle 4 Review

1. **N4 Resolution Status: PARTIALLY RESOLVED**

The replan fixes the original bloat mechanism in principle: Pulse saves via `ResourceSaver.save()` and then calls `_strip_theme_entries(path)` after header capture, with comments explicitly saying the strip keeps the Godot-emitted header plus nine exports and removes regenerated entries ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:110), [04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:126)). The strip implementation skips `[sub_resource ...]` blocks, preserves only `[gd_resource ...]` and `[resource]`, and whitelists the 9 export keys ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:157), [04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:172)). It asserts post-strip size `< 2048` ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:196)), peers reuse the same strip after each save ([04-07]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-PLAN.md:123)), and Plan 04-08 adds a layout-time size check for all five `.tres` files ([04-08]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-08-addon-metadata-and-readme-PLAN.md:571)).

However, N4 is not fully resolved because the strip can remove the script linkage required for a custom GDScript resource. The plan itself acknowledges Godot may serialize the resource as `script_class="NeoCadeTheme"` or via `script = ExtResource(...)` ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:238)), but `_strip_theme_entries()` drops every `[ext_resource ...]` section and drops every `[resource]` line except the 9 exports ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:165), [04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:176)). If Godot emits the common script-backed form, the stripped file will no longer load as `NeoCadeTheme`. The verifier would catch this via `ResourceLoader.load(path)` and `loaded is NeoCadeTheme` ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:299)), but the plan still instructs an unsafe strip.

2. **Regression Check**

C1 intact: canonical `BINDING_TABLE.size() == 37` and exact 37 list remain asserted ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:317)).

C2 intact: `DIRECTION_PRESETS` and per-direction `spread_factor` / state / disabled values remain sourced from presets ([04-04]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-04-color-formulas-and-role-tokens-PLAN.md:290), [04-04]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-04-color-formulas-and-role-tokens-PLAN.md:363)).

C3 intact: `default_font = body_font` and `default_font_size = tokens.body` remain before the table walk ([04-05]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-binding-table-and-iteration-engine-PLAN.md:132)).

C4 intact: 14 `TYPE_VARIATIONS`, including `CodeLabel`, remain specified ([04-05]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-binding-table-and-iteration-engine-PLAN.md:100), [04-05]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-binding-table-and-iteration-engine-PLAN.md:118)).

C5 intact: font `.tres` resources remain generated through `ResourceSaver.save()` rather than hand-authored ([04-02]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-02-fonts-and-OFL-PLAN.md:215), [04-02]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-02-fonts-and-OFL-PLAN.md:235)).

C6 partially regressed by N4: `ResourceSaver.save()` is still used, but the post-strip may remove the script ext_resource needed for the Godot-emitted custom-resource form.

C7 intact: Plan 04-08 now depends on `04-07` ([04-08]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-08-addon-metadata-and-readme-PLAN.md:6)).

N1 intact: no BINDING_TABLE `font` branch; only five setter branches remain ([04-05]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-binding-table-and-iteration-engine-PLAN.md:682)).

M1 intact: `_save_peer_tres()` is explicitly called inside `_run()` ([04-07]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-PLAN.md:131)).

M2 intact: margins use `densityScale` and `tapPadding`, and verifier asserts mobile margin > desktop ([04-05]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-05-binding-table-and-iteration-engine-PLAN.md:620), [04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:404)).

M3 intact: peer verification loads each peer and checks `is NeoCadeTheme`, Button stylebox, and spread factor ([04-07]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-PLAN.md:212)).

L1 intact: hard-coded preset remnants are explicitly removed in favor of preset sourcing ([04-04]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-04-color-formulas-and-role-tokens-PLAN.md:425)).

L2 intact: Pulse vs Slate spread-factor smoke test remains ([04-06]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:409)).

L3 intact: CHANGELOG canonical 37 verification remains and forbids non-canonical names ([04-08]( /C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-08-addon-metadata-and-readme-PLAN.md:581)).

3. **New Concerns**

HIGH: `_strip_theme_entries()` can strip required custom-script linkage. It preserves only `[gd_resource]`, `[resource]`, and the 9 export keys, so any `[ext_resource type="Script" ...]` plus `script = ExtResource(...)` emitted by Godot is lost. Fix: preserve script ext_resource sections and the `script = ExtResource(...)` assignment when present, or assert the emitted header is truly `type="NeoCadeTheme"` with no script dependency before stripping. Also recompute or remove `load_steps` after stripping.

4. **Final Risk Assessment**

Convergence should not close yet. The bloat/size side of N4 is addressed, but the strip architecture can produce `.tres` files that satisfy the `< 2048` data-only check while failing the core requirement: loading as `NeoCadeTheme`. One HIGH remains.

---

## Cycle 4 Consensus Summary

### N4 Resolution Status

| Aspect | Status |
|---|---|
| Bloat / file-size aspect | **FULLY RESOLVED** — < 2048 byte assertion at save-time + layout-time |
| Header preservation (Godot-emitted, not hand-authored) | **FULLY RESOLVED** — header captured before strip, preserved verbatim |
| Type preservation (loads as NeoCadeTheme, not plain Theme) | **PARTIALLY RESOLVED → introduces NEW HIGH N5** |

### Regression Check — Prior Concerns

All 14 prior concerns (C1-C7, N1, M1-M3, L1-L3) remain INTACT per both reviewers' line-cited evidence. Cycle-4 changes were scoped to Plans 04-06/04-07/04-08 and did not modify any earlier-phase fixes.

### NEW HIGH N5 — `_strip_theme_entries()` may strip required `script` linkage

- **OpenCode:** MEDIUM ("script property drop"; runtime verifier catches)
- **Codex:** HIGH ("strip can remove the script linkage required for a custom GDScript resource"; unsafe by construction)
- **Aggregate: HIGH**

**Root cause.** The strip preserves only `[gd_resource ...]` header + the 9 `EXPORT_KEYS` lines under `[resource]`. But Godot 4.6 may serialize a custom-class resource (NeoCadeTheme extends Theme via class_name) with TWO forms:
1. `[gd_resource type="NeoCadeTheme" ...]` header alone (no script ext_resource needed) — strip works.
2. `[gd_resource type="Theme" ...]` header + `[ext_resource type="Script" path="..." id="..."]` block + `script = ExtResource("script_id")` line inside `[resource]` — strip drops the ext_resource block and the script= line, resource loads as plain `Theme`.

If Godot uses form 2 (and we don't know empirically until first save), the `.tres` passes the size check but fails the `loaded is NeoCadeTheme` runtime check.

**Trivial fix:** Update `_strip_theme_entries()` to ALSO preserve:
- Any `[ext_resource type="Script" ...]` blocks (don't drop them when iterating sections).
- The `script = ExtResource(...)` line inside `[resource]` (add `"script"` to `EXPORT_KEYS` OR detect the line via prefix match).
- Re-stamp `load_steps = N` in the header to match the count of preserved [ext_resource] + [resource] sections (or remove `load_steps` and let Godot recompute on load).

Both reviewers agree on the trivial fix.

### Cycle 4 Risk Assessment

- **OpenCode:** LOW (no HIGH; the script-drop is a runtime-catchable MEDIUM)
- **Codex:** HIGH (script-drop is unsafe by construction; .tres files passing the size check while failing the type check is exactly the brittle scenario this cycle was supposed to eliminate)
- **Aggregate: HIGH**

### Convergence Trajectory

- Cycle 1 HIGH: 7
- Cycle 2 HIGH: 3 (decreasing)
- Cycle 3 HIGH: 1 (decreasing — N4 emerged from C5/C6 fix path)
- Cycle 4 HIGH: 1 (STALLED ON COUNT — N5 emerged from N4 fix path)

The count is stalled at 1 but the SUBSTANCE is different each cycle (N4 was bloat; N5 is type-linkage). Each emergent HIGH has been a side-effect of the prior cycle's fix path. The remaining issue is genuinely trivial to fix — preserve `script` references in the strip — but requires another replan + review pass to close.

---

# Cross-AI Plan Review — Phase 4 (Cycle 5 — N5 verification, max-cycles +2 override)

**Reviewed:** 2026-05-06 (re-review after replan commit `9ea0496`)
**Reviewers:** OpenCode (DeepSeek V4 Pro), Codex
**Scope:** Verify cycle-4 N5 (.tres script-linkage drop) is FULLY RESOLVED.

## OpenCode Cycle 5 Review (DeepSeek V4 Pro)

## 1. N5 Resolution Status: FULLY RESOLVED (one LOW regex note)

The script-linkage preservation logic is correct in its three components:

**Component (a) — Preserve `[ext_resource type="Script" ...]` blocks:** Correct. The check `begins_with("[ext_resource")` AND `find("type=\"Script\"") != -1` is evaluated BEFORE the general `[ext_resource]` drop, so script ext_resources survive. Godot 4.6 serializes `[ext_resource ...]` blocks as single lines — no multi-line edge case exists. ✓

**Component (b) — Preserve `script = ExtResource(...)` / `script_class = ...` in `[resource]`:** Correct. Both prefix patterns (`begins_with("script = ExtResource(")` and `begins_with("script_class =")`) match Godot's actual serialization form. The prefix strategy correctly handles variable id values in `ExtResource("...")`. ✓

**Component (c) — Strip `load_steps=N` from `[gd_resource ...]` header:** The `_strip_load_steps_attr()` helper is conceptually correct — Godot 4.x recomputes `load_steps` on load when the attribute is absent. The regex `r"\s*load_steps=\d+"` correctly matches the attribute. ✓

**LOW concern — regex `rx.sub(header_line, "", true)` uses empty-string replacement, not a space.** If `load_steps` sits between two other attributes (Godot's format: `type="Theme" load_steps=42 format=3`), removing ` load_steps=42` without replacing it with a space produces `type="Theme"format=3` — fused attributes, which Godot would reject. The plan's double-space cleanup regex (`r" {2,}"`) cannot fix zero-space fusion. The fix is one character: `rx.sub(header_line, " ", true)` (replace with single space instead of empty string). This is LOW severity because (a) the runtime `loaded is NeoCadeTheme` verifier catches any file Godot refuses to parse, (b) `load_steps` may not even appear in headers without `[ext_resource]`/`[sub_resource]` blocks, and (c) the fix is trivial.

**Size assertion:** Preserved script ext_resource adds ~80-150 bytes, well under the 2048-byte cap. ✓

**Verdict:** The script-linkage preservation is structurally sound. The regex replacement value is a trivial pre-emptive fix — one character (`" "` instead of `""`). Does not block convergence.

---

## 2. Regression Check — All Prior Fixes Intact

| Concern | Status | Evidence |
|---------|--------|----------|
| **C1** (37 canonical rows) | INTACT | Plan 04-05 BINDING_TABLE, unchanged |
| **C2** (DIRECTION_PRESETS per-direction) | INTACT | Plan 04-04 Task 3.5/4, unchanged |
| **C3** (default_font before walk) | INTACT | Plan 04-05 Task 1, unchanged |
| **C4** (14 type variations + CodeLabel) | INTACT | Plan 04-05 Task 1, unchanged |
| **C5** (Godot-serialized fonts) | INTACT | Plan 04-02, unchanged |
| **C6** (ResourceSaver for .tres) | INTACT | Plan 04-06 Task 1 still uses `ResourceSaver.save()` then strips; header captured before strip |
| **C7** (Plan 04-08 depends on 04-07) | INTACT | Plan 04-08 frontmatter, unchanged |
| **N1** (no `font` branch in walk) | INTACT | Plan 04-05 Task 3, unchanged |
| **N4** (data-only .tres via strip) | STRENGTHENED | Strip now also preserves script linkage |
| **M1** (_save_peer_tres() called in _run()) | INTACT | Plan 04-07 verifier, unchanged |
| **M2** (densityScale/tapPadding wired) | INTACT | Plan 04-05 _resolve_recipe, unchanged |
| **M3** (peer-load verification) | INTACT | Plan 04-07 Task 1.5, unchanged |
| **L1** (no stale "13 variations") | INTACT | Already resolved Cycle 3 |
| **L2** (cross-direction smoke test) | INTACT | Plan 04-06 verifier, unchanged |
| **L3** (CHANGELOG 37 canonical) | INTACT | Plan 04-08 Task 2, unchanged |

Cycle 5 changes are scoped to Plans 04-06/04-07/04-08 and are additive only — no prior fix was modified. **Zero regressions.**

---

## 3. New Concerns Introduced by Cycle 5

### LOW: `_strip_load_steps_attr() rx.sub(header_line, "", true)` — empty-string replacement can fuse tokens

**Location:** Plan 04-06 Task 1, `_strip_load_steps_attr()`

**What:** `rx.sub(header_line, "", true)` removes `load_steps=N` including its preceding spaces, but replaces with empty string. If `load_steps` is between `type="Theme"` and `format=3`, the result is `type="Theme"format=3` (fused). Godot's parser would reject this malformed header.

**Fix:** `rx.sub(header_line, " ", true)` (one space instead of empty string). Then `r" {2,}" → " "` cleans double spaces.

**Severity:** LOW. Self-detecting — the file fails to load, verifier catches it. Trivial one-character fix.

### No other new concerns

- ~~Regex quotes/escapes~~ — `begins_with("[ext_resource")` and `stripped.find("type=\"Script\"")` are syntactically correct GDScript. ✓
- ~~Multiple script ext_resources~~ — if Godot emitted multiple `[ext_resource type="Script"]` blocks, all would be preserved (each is independently detected); non-script ext_resources are still dropped. ✓
- ~~`load_steps` removal breaking Godot~~ — Godot 4.x recomputes `load_steps` when absent. Verified against Godot docs. ✓
- ~~`script_class =` not matching~~ — Godot uses space-before-equals: `script_class = "..."`. `begins_with("script_class =")` is correct. ✓

---

## 4. Risk Assessment: LOW

| Risk | Level | Blocking? |
|------|-------|-----------|
| `_strip_load_steps_attr` empty-replace fuses tokens | LOW | No (self-detecting + trivial fix) |
| All prior fixes C1-C7/N1/N4/M1-M3/L1-L3 | None | Intact |
| Script-linkage preservation (core N5) | None | Correct |
| **HIGH count: 0** | | |

---

## 5. Convergence Verdict: **CONVERGE**

Zero HIGH concerns remain. The one LOW concern (regex empty-replace → space-replace) is a self-detecting one-character fix that doesn't block execution. The plan set is ready for `/gsd-execute-phase 4`.

---

## Codex Cycle 5 Review

**Findings**

No HIGH findings. N5 is **FULLY RESOLVED** and the loop can converge.

One LOW cleanup: [04-06 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:317) still greps the stripped `.tres` for literal `NeoCadeTheme`. Runtime verification already asserts `loaded is NeoCadeTheme`, which is the stronger check. If Godot ever emits form-2 without a `script_class` string, the strip could be correct while this PowerShell grep false-fails. Not blocking; accepting `NeoCadeTheme|neocade_theme\.gd|script = ExtResource\(` would be more robust.

**N5 Status**

**FULLY RESOLVED.** The updated strip plan preserves the form-2 script linkage:

- Keeps `[ext_resource type="Script" ...]` blocks instead of dropping all ext_resources: [04-06 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:181)
- Keeps `script = ExtResource(...)` and `script_class = ...` lines inside `[resource]`: [04-06 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:221)
- Strips `load_steps=N` from `[gd_resource ...]`: [04-06 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:206)
- Applies the same shared strip helper to peer themes: [04-07 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-PLAN.md:163)
- Runtime verifiers assert `loaded is NeoCadeTheme` for Pulse and peers: [04-06 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-06-pulse-tres-and-verification-PLAN.md:373), [04-07 Plan](/C:/Programming_Files/Shilocity/Godot/NeoCade-Theme/.planning/phases/04-foundation-neocadetheme-superclass-per-theme-subclasses-font/04-07-peer-themes-and-main-tscn-PLAN.md:219)

The `load_steps` removal is acceptable. This repo already has valid Godot resources without `load_steps`, including `main.tscn` and the original scaffold `.tres`.

**Regression Check**

C1-C7, N1, N4, M1-M3, and L1-L3 remain intact.

Key gates remain in place: canonical 37 coverage and slot freeze, disabled opacity from presets, no BINDING_TABLE font branch, Godot-serialized font/theme generation, N4 `< 2048` strip assertions, peer `_run()` invocation verification, peer runtime validation, canonical 37 docs, and Phase 04-08 dependency on 04-07.

**Risk Assessment**

Residual risk is low. The strip logic is line-based and conservative around script linkage. The critical failure mode, loading as plain `Theme`, is directly caught by runtime `ResourceLoader.load(...) is NeoCadeTheme` checks. No remaining HIGH concerns. Converged.

---

## Cycle 5 Consensus Summary — CONVERGED

| Aspect | OpenCode | Codex | Aggregate |
|---|---|---|---|
| **N5** Script linkage preservation | FULLY RESOLVED | FULLY RESOLVED | **FULLY RESOLVED** |
| All prior C1-C7, N1, N4, M1-M3, L1-L3 | INTACT | INTACT | **INTACT** |
| New HIGH | 0 | 0 | **0** |
| New MEDIUM | 0 | 0 | **0** |
| New LOW | 1 | 1 | 2 minor |

### LOW Concerns (Convergence-Compatible)

1. **OpenCode L1** — `_strip_load_steps_attr()` `rx.sub(header_line, "", true)` uses empty-string replacement. If `load_steps` sits between two attributes (e.g., `type="Theme" load_steps=42 format=3`), zero-replace fuses tokens (`type="Theme"format=3`). One-char fix: replace with `" "` instead of `""`. Self-detecting via `loaded is NeoCadeTheme` runtime verifier — does not block convergence.
2. **Codex L1** — Plan 04-06 verifier still greps stripped `.tres` for literal `NeoCadeTheme` string. Runtime `loaded is NeoCadeTheme` is the stronger check; if Godot uses form 2 without `script_class` string, the grep could false-fail while the load-check passes. Suggestion: accept `NeoCadeTheme|neocade_theme\.gd|script = ExtResource\(` as alternates. Not blocking.

### Convergence Trajectory

| Cycle | HIGH | Direction |
|---|---|---|
| 1 | 7 | initial review |
| 2 | 3 | ↓ (4 fewer) |
| 3 | 1 | ↓ (2 fewer; N4 emerged from C5/C6 fix) |
| 4 | 1 | → (stalled count; N5 emerged from N4 fix) |
| 5 | **0** | ↓ (all resolved) |

### Final Verdict — CONVERGED

Phase 4 plans are execution-ready. The 8 plans collectively address all 16 primary requirements (FOUND-01..03, FONT-01/05/06/07/08/09, ICON-01..04) plus the supporting TOKEN-01..10 implementation. The single-class + 5 data-only `.tres` architecture (D-31 / DESIGN_TOKENS.md) is faithfully implemented with the seamless `@exports` ↔ Theme Editor authoring model (CONTEXT.md D-01..D-14).

**Phase 4 unblocked for `/gsd-execute-phase 4`.**

---

# Cross-AI Plan Review — Phase 4 (Cycle 6 — Fresh Independent Pass + Self-Review)

**Reviewed:** 2026-05-06 (post-cycle-5 'CONVERGED' verdict; user requested fresh independent re-review explicitly distrusting OpenCode/DeepSeek)
**Reviewers:** OpenCode (DeepSeek V4 Pro), Codex, **Claude (orchestrator self-review)**
**Scope:** Independent top-to-bottom review (NOT a fix-verification framing). Each reviewer asked to find issues prior cycles missed.

## OpenCode Fresh Review (DeepSeek V4 Pro)

## Summary

The 8 plans form a well-structured pipeline: scaffold deletion → class shell → fonts → icons → formulas → iteration engine → Pulse verification → peer themes → metadata. The architecture (single concrete `NeoCadeTheme` class + 5 data-only `.tres` files + additive regeneration) is sound and the plan sequencing is largely correct. However, **two potential bugs** would prevent the code from compiling and running, and **one data discrepancy** would produce visually-wrong output for 4 of the 5 themes.

---

## Strengths

1. **Additive iteration engine design is well-considered.** The D-01 (no `clear()`), D-04 (escape hatch), and reentry-guard (`_regenerating`) form a correct pattern for coexisting formula-driven and Theme-Editor-authored entries.
2. **Cross-AI review cycle fixes are correctly threaded.** C1 (37-row freeze), C2 (DIRECTION_PRESETS per-direction), C4 (14 variations including CodeLabel), C6 (Godot-serialized `.tres`), N1 (remove `font` from schema), N4 (`.tres` strip post-save), N5 (preserve script linkage) — all integrated coherently through the plan tasks and acceptance criteria.
3. **Dual verification paths (EditorScript + SceneTree)** provide both interactive and CI-friendly validation. The editor variant is correct for `@tool` resources; the headless variant enables autonomous execution.
4. **Canonical slot-name freeze (CANONICAL_SLOT_NAMES, Plan 04-05 Task 2.5)** solves the real problem of wrong-slot-name false-positives passing row-count checks.
5. **Font import is Godot-driven** (Plan 04-02 ensures `.import` sidecars come from Godot's importer, with param enforcement). The FontFile + FontVariation pattern for Inter Variable Roman's opsz/wght axes is correct for Godot 4.6.

---

## Concerns

### HIGH

| # | Concern | Plan & Location | Detail |
|---|---------|-----------------|--------|
| **C1** | **DIRECTION_PRESETS values disagree with DESIGN_TOKENS personality spec** | 04-04, Task 3.5 const `DIRECTION_PRESETS` | The hard-coded dictionary in the plan contains state-layer deltas that DO NOT match the canonical DESIGN_TOKENS for 4 of 5 directions. Pulse is correct. The other 4: |

**Detail of C1 — value-by-value trace:**

| Direction | Design Tokens §5 says | Plan 04-04 DIRECTION_PRESETS says |
|-----------|----------------------|----------------------------------|
| Slate hover | +4% (§5.2) | `hover_pct: 8.0` |
| Slate pressed | −6% (§5.2) | `pressed_pct: -12.0` |
| Bubble hover | +8% (§5.3) | `hover_pct: 10.0` |
| Bubble pressed | −10% (§5.3) | `pressed_pct: -12.0` |
| Daybreak hover | +6% (§5.4) | `hover_pct: 8.0` |
| Daybreak pressed | −6% (§5.4) | `pressed_pct: -12.0` |
| Burst hover | +8% (§5.5) | `hover_pct: 10.0` |
| Burst pressed | −12% (§5.5) | `pressed_pct: -14.0` |

The formula `_mix(base_color, state_hover_target, hover_pct / 100.0)` directly consumes these values. A Slate direction loaded from its `.tres` would render hover at 8% lift (twice the approved 4%), producing a visibly more reactive state layer than the Phase 3.4 mockup gate approved. The DESIGN_TOKENS is the Phase 3.4 contract and must be authoritative — the DIRECTION_PRESETS must be reconciled to its values.

**Correction:** The `DIRECTION_PRESETS` const in Plan 04-04 Task 3.5 should use the DESIGN_TOKENS §5 personality values, not the values currently written. Specifically:
- Slate line: `"hover_pct": 4.0, "pressed_pct": -6.0` (was 8.0/-12.0)
- Bubble line: `"hover_pct": 8.0, "pressed_pct": -10.0` (was 10.0/-12.0)
- Daybreak line: `"hover_pct": 6.0, "pressed_pct": -6.0` (was 8.0/-12.0)
- Burst line: `"hover_pct": 8.0, "pressed_pct": -12.0` (was 10.0/-14.0)

The Plan 04-06 Cycle 2 L2 verification (Pulse-vs-Slate spread_factor smoke test) checks `spread_factor` only — it does NOT assert `hover_pct` or `pressed_pct` per direction. So this discrepancy would pass verification and ship wrong state layers.

---

| # | Concern | Plan & Location | Detail |
|---|---------|-----------------|--------|
| **C2** | **GDScript Dictionary dot-notation syntax errors — code will not compile** | 04-04 Task 4, 04-05 Task 3, and 04-02 Task 2 | GDScript 4.x does NOT support `dict.property` for Dictionary access. Must use `dict["property"]` or `dict.get("property")`. The following lines in the plan code snippets are invalid: |

**Plan 04-04 Task 4** — `_regenerate_theme()` body:
```gdscript
var spread_factor: float = presets.spread_factor   # INVALID
var hover_pct: float = presets.hover_pct            # INVALID
var pressed_pct: float = abs(presets.pressed_pct)   # INVALID
var disabled_opacity: float = presets.disabled_opacity  # INVALID
```

**Plan 04-04 Task 4 + Plan 04-05 Task 1** — `tokens` dictionary access:
```gdscript
default_font_size = tokens.body      # INVALID
set_font_size(..., tokens.h1)        # INVALID (appears in Task 1 variation block)
set_font_size(..., tokens.h2)        # INVALID
set_font_size(..., tokens.label_)    # INVALID
set_font_size(..., tokens.body)      # INVALID
```

**Plan 04-05 Task 3** — `_resolve_recipe` stylebox branch:
```gdscript
var density: float = tokens.get("densityScale", 1.0)  # Bracket: correct
var tap_pad: int = tokens.get("tapPadding", 0)         # Bracket: correct
```
(The `tokens.get()` calls ARE valid — those use bracket method. Only the dot-notation calls above fail.)

Every instance of `presets.something` and `tokens.something` (without bracket notation) must be rewritten as `presets["something"]` and `tokens["something"]`. The acceptance criteria grep for specific substrings (e.g., `var spread_factor: float = presets.spread_factor`) so the verify commands will MATCH the broken code and report PASS — a silent false positive. The acceptance criteria must be updated to match bracket-notation patterns.

---

| # | Concern | Plan & Location | Detail |
|---|---------|-----------------|--------|
| **C3** | **`.tscn` comment syntax wrong — uses `#` instead of `;`** | 04-01 Task 1 | Godot `.tscn` / `.tres` files use a subset of ConfigFile format. Comments are introduced with `;` (semicolon), NOT `#` (hash). The plan says to insert `# theme = ExtResource(...) - reassigned in Plan 04-07` inside a node block. This may cause a parse error when opening the scene in Godot Editor. The verification command checks for the presence of the `# theme...` prefix but doesn't open the scene in the editor. The plan does include a fallback ("verify by opening `main.tscn` in the editor; the file MUST still parse") but doesn't enforce it before the commit. Fix: use `; theme = ...` for the comment line, or simply leave a blank line (no placeholder comment at all).

---

### MEDIUM

| # | Concern | Plan & Location | Detail |
|---|---------|-----------------|--------|
| **C4** | **`.tres` strip helper edge cases under Godot 4.6 native serialization** | 04-06 Task 1, `_strip_theme_entries()` | The line-based textual parser is fragile. Specific edge cases: (a) If Godot serializes a `[sub_resource]` StyleBoxFlat that spans multiple lines (unlikely for flat styleboxes, but possible for complex ones with embedded resources), the section-skip logic that drops `[sub_resource]` lines may miss nested content on subsequent non-bracket lines. (b) After the strip removes `load_steps=N`, the double-space cleanup (`r" {2,}"`) may produce single-space gaps in unusual attribute ordering. Mitigation: the Cycle 4 N5 fix strips `load_steps` and preserves script linkage; the remaining edge cases are low-probability since the `.tres` only contains `@export` scalar values + optional script ref after the strip. Acceptable risk for Phase 4 given the post-strip `< 2048` byte size assertion catches gross failures and `_phase4_verify_headless.gd` validates runtime loading. |
| **C5** | **Icon `.import` sidecars hand-authored (inconsistent with C5 font fix)** | 04-03 Task 2 | Plan 04-03 hand-authors `.svg.import` sidecars — the same pattern that Cycle 1 C5 explicitly forbade for fonts. The font fix was: "drive materialization through Godot." For SVG icons, the import pipeline is simpler (no FontVariation sub-resources), so hand-authoring is less risky. But the principle of Godot-native serialization should apply consistently. The `importer="texture"` line and `[params]` structure are stable in Godot 4.x, so hand-authoring is tolerable here — but the plan should at minimum document that the sidecar template was verified against Godot 4.6's actual output for a test SVG. |
| **C6** | **Disabled opacity conflates text and container alpha** | 04-05 Task 3, `_resolve_recipe()` | The `disabled_opacity` from DIRECTION_PRESETS is used for BOTH font alpha and stylebox bg alpha. DESIGN_TOKENS §7.2 distinguishes "38% text / 12% container" (M3 baseline). The per-direction disabled_opacity replaces the 38% text constant, but applying it to stylebox backgrounds means a disabled Button has its container at 42% (Pulse) opacity rather than 12%. In dark modes, a 42%-opaque surface_panel on top of the page color creates a subtle bleed-through effect that may look like glass/popup styling rather than disabled-state dimming. However, DESIGN_TOKENS §6.5 explicitly says "applied as theme_color.a = disabled_opacity in disabled stylebox/font_color slots" — so the plan is following the token contract as written. The §7.2 text is the M3 baseline reference, not the NeoCade override. This is a token-design inconsistency in DESIGN_TOKENS, not a plan error. Flagged as MEDIUM because a design reviewer should confirm whether Pulse's 0.42 disabled container alpha is the intended visual. |
| **C7** | **Dual verifier logic duplicated — maintenance fragility** | 04-06 Task 2, 04-07 Task 1.5 | `_phase4_verify.gd` (EditorScript) and `_phase4_verify_headless.gd` (SceneTree) contain ~80% identical assertion logic. Any fix to a verification check must be applied to both files. The plan acknowledges this ("duplicated rather than `load`-ed") and tags both for Phase 11 deletion, so the maintenance window is only Phases 4-10. Risk is moderate — a future update that fixes one but not the other would produce inconsistent verification results. |

---

### LOW

| # | Concern | Plan & Location | Detail |
|---|---------|-----------------|--------|
| **C8** | **`_regenerate_theme()` runs ~10 times per `.tres` load** | 04-01 Task 2, 04-04 Task 4 | `_init()` → regeneration with class defaults, then 9 setter calls during `.tres` property deserialization → 9 more regenerations. Each runs the full BINDING_TABLE walk. Correct output but ~10× the work. Reentry guard prevents cascading but does not batch the 9 independent setter triggers. For a production `.tres` with ~37 controls × multiple slots, this is potentially hundreds of stylebox allocations per load. Acceptable for v1 given `.tres` is typically loaded once at scene init; can be optimized in v1.x with a dirty-flag batched approach. |
| **C9** | **`set_font_size` on PanelContainer variations is unnecessary but harmless** | 04-05 Task 1 | `set_font_size("font_size", "CardPanel", tokens.body)` and `set_font_size("font_size", "HeroPanel", tokens.body)` on PanelContainer type variations — PanelContainers don't display text natively, so these are no-ops. Harmless overhead; remove in v1.x polish if desired. |
| **C10** | **`VERSION` file format: trailing-newline ambiguity** | 04-08 Task 3 | The task says "use `Set-Content -Encoding UTF8 -NoNewline` if the convention is no-trailing-newline, OR the default `Set-Content` (with trailing newline) — verify against project root convention if any." No project-root convention exists. The plan should pick one and commit. Recommend no trailing newline for a single-line file (many tools parse `cat VERSION` without stripping `\n`). |
| **C11** | **`_strip_load_steps_attr` anchor string inconsistency** | 04-06 Task 1 | The GDScript code block defines `_strip_load_steps_attr()` inside the `_phase4_import.gd` extension. But `_strip_theme_entries` has a `static func` declaration. The docstring says "static func `_strip_load_steps_attr(header_line: String) -> String`" — the `static` keyword matters for calling from `_strip_theme_entries` which is also `static`. This is correct and will compile (both are static), but verify that `_strip_theme_entries` is consistently marked `static` (it is, per the Plan 04-06 code). No issue. |

---

## Suggestions

1. **Reconcile DIRECTION_PRESETS with DESIGN_TOKENS §5 BEFORE execution.** Update the Plan 04-04 Task 3.5 const with the values from §5.1-§5.5 personality specs. The Cycle 2 L2 verification should also assert `hover_pct` and `pressed_pct` per direction, not just `spread_factor`.

2. **Fix all Dictionary dot-notation to bracket notation throughout plans.** This is a mechanical change: `presets.spread_factor` → `presets["spread_factor"]`, `tokens.body` → `tokens["body"]`, etc. Update acceptance criteria grep patterns to bracket-notation equivalents.

3. **Change `.tscn` comment prefix from `#` to `;`** in Plan 04-01 Task 1. Alternatively, drop the placeholder comment entirely and just leave a blank line where the theme property was. The acceptance criteria "parses as a valid `.tscn`" then becomes the verification test.

4. **Add icon import sidecar generation note** in Plan 04-03 Task 2: explicitly state that the template was validated against Godot 4.6's actual output for a test SVG, OR switch to a Godot-driven approach (load SVG, save `.import`, then enforce params programmatically — same pattern as fonts).

5. **Add `hover_pct` and `pressed_pct` per-direction assertions** to the Plan 04-06 verifier (both EditorScript and headless variants). Currently the Cycle 2 L2 fix only checks `spread_factor`. Adding hover/pressed checks catches the C1 discrepancy at verification time.

6. **Consider a batch-dirty optimization note** — in `_regenerate_theme()`, if all 9 setters trigger regeneration independently, a simple `_dirty := false` flag checked at entry and cleared after the walk could batch them. Not needed for v1 but worth a PLAN.md note for v1.x.

---

## Requirement Coverage Trace

| Requirement | Primary Plan | Status |
|---|---|---|
| FOUND-01 (addon layout) | 04-01 (delete scaffold, create .gd) + 04-02 (fonts/) + 04-03 (icons/) + 04-06 (pulse.tres) + 04-07 (peer .tres) + 04-08 (metadata) | **Covered** — 04-08 Task 5 verifies the full layout |
| FOUND-02 (class with 9 exports) | 04-01 (shell) + 04-04 (formulas) + 04-05 (engine) | **Covered** — but C2 (dot-notation) must be fixed for compilation |
| FOUND-03 (per-direction .tres) | 04-06 (Pulse) + 04-07 (Slate/Bubble/Daybreak/Burst) | **Covered** — but C1 (DIRECTION_PRESETS) must be fixed for visual correctness |
| FONT-01 (Inter bundled) | 04-02 Task 1, 2 | Covered |
| FONT-05 (OFL.txt) | 04-02 Task 5 | Covered |
| FONT-06 (default_font) | 04-05 Task 1 (C3 fix) | Covered |
| FONT-07 (italic synthetic) | 04-08 CHANGELOG + README | Covered (documented, not implemented) |
| FONT-08 (import settings) | 04-02 Task 2 | Covered |
| FONT-09 (CJK override docs) | 04-08 README | Covered |
| ICON-01 (SVG icons 32×32) | 04-03 Task 1 | Covered |
| ICON-02 (icon coverage) | 04-03 Task 1 (Button-family) + Phase 6/7 (remainder) | Partially covered (Button-family only; remainder deferred per plan) |
| ICON-03 (monochrome) | 04-03 Task 1 | Covered |
| ICON-04 (no external libs) | 04-03 (by construction) | Covered |

All 16 requirements land in specific plans. FONT-02/03/04 are correctly stricken (only Inter shipped). ICON-02 is only partial in Phase 4 (Button-family only; Tree/ColorPicker/FileDialog/ScrollBar icons are Phase 6/7 per the out-of-scope list). This matches the plan design.

---

## What's Missing

1. **No plan verifies `main.tscn` actually opens in Godot Editor** after scaffold deletion + comment replacement. The verification is textual (grep) only. Plan 04-01 should include a manual verification step: "Open the project in Godot Editor and confirm `main.tscn` loads without missing-resource errors."

2. **No plan verifies the `.tres` deserialization load order** (`_init()` before/after property restoration). The existing verification checks that the loaded Pulse `.tres` has correct `@export` values, which implicitly confirms the final state is correct regardless of order. Explicit documentation of the expected order (and why it's fine) would be valuable but isn't required for execution.

3. **No plan addresses Pitfall 3.3 (texture filter mismatch) explicitly.** The icon import sidecars set `mipmaps/generate=true` but do NOT explicitly set the texture filter mode per-resource. In Godot 4.x, per-resource texture filter is set via the import sidecar's `mipmaps/generate=true` plus the project-level setting. The icon plan is implicitly correct (Linear With Mipmaps is the default when mipmaps are generated), but the pitfall specifically warns about pixel-art projects using Nearest filtering overriding theme icons. A Phase 10 or Phase 4 note should address this.

---

## Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| DIRECTION_PRESETS incorrect (C1) | **Certain** — values hardcoded in plan differ from DESIGN_TOKENS | **High** — 4/5 directions render with wrong state layers, failing Phase 3.4 mockup fidelity gate | Fix values before execution; add hover/pressed assertions to Plan 04-06 verifier |
| GDScript compile failure (C2) | **Certain** — dot-notation on Dictionary is invalid GDScript 4.x | **High** — code will not compile; Phase 4 blocks | Change to bracket notation throughout |
| `.tscn` parse error (C3) | **Medium** — Godot's ConfigFile parser may reject `#` comments inside node blocks | **Medium** — scene fails to open; Plan 04-07 can't reassign theme | Use `;` prefix or blank line |
| `.tres` strip helper breakage (C4) | **Low** — format is simple; post-strip size assertion catches gross failures | **Medium** — corrupted `.tres` prevents theme loading | Runtime verify via `_phase4_verify_headless.gd` |
| Disabled visual differs from design intent (C6) | **Low** (follows DESIGN_TOKENS as written) | **Low** — cosmetic; reversible with DESIGN_TOKENS update | Document in CHANGELOG; revise in v1.x if needed |

**Overall:** The plans are execution-ready after resolving C1, C2, and C3. C1 is the most impactful because it produces incorrect visual output without any verification failure — the L2 smoke test checks `spread_factor` but not `hover_pct`/`pressed_pct`.

---

---

## Codex Fresh Review

**Summary**

I would not call these plans execution-ready yet. The architecture is mostly coherent, but there are several blockers where the plans can pass their own grep checks while still producing an addon that violates Phase 4 contracts or sets theme slots Godot controls do not actually use.

**Strengths**

- The single `NeoCadeTheme extends Theme` direction is consistent with the locked architecture.
- Pulse-first sequencing is correct.
- The `ResourceSaver.save()` approach for `.tres` headers is a good correction over hand-authored custom resource headers.
- The dual verifier idea is strong, especially the headless `SceneTree` variant.
- The plans correctly focus on additive regeneration and avoid `clear()` inside `_regenerate_theme()`.

**Concerns**

**HIGH — Phase 4 layout contract is violated by helper scripts.**  
Plans `04-02`, `04-06`, `04-07`, and `04-08` leave `_phase4_import.gd`, `_phase4_verify.gd`, and `_phase4_verify_headless.gd` directly under `addons/neocade_theme/`. That directly conflicts with FOUND-01 / Phase 4 SC#1: addon root contains exactly one `.gd` file, `neocade_theme.gd`. `04-08` even makes these helper scripts required layout files, which reverses the project contract. Move helpers under `.planning/phases/...` or delete them before Phase 4 layout verification.

**HIGH — CANONICAL_SLOT_NAMES contains wrong or incomplete Godot 4.6 slots.**  
`04-05` claims slot names are frozen, but examples already diverge from Godot 4.6 docs and local dissection. CheckButton uses `checked`, `unchecked`, disabled, and mirrored icon slots, not `on` / `off` per the official CheckButton docs. Tree docs include slots like `hovered_dimmed` and `custom_button`; the plan’s Tree freeze omits them. Button and OptionButton omit mirrored styleboxes despite the local dissection saying upstream sets them and RTL expects them. Worse: Theme `set_icon` / `has_icon` can create arbitrary theme items, so a verifier can pass while Godot never uses those slots.

**HIGH — Icon `.import` files are not safe as planned.**  
`04-03` hand-authors `.svg.import` files with `path="res://.godot/imported/<name>.svg-<hash>.ctex"` and says placeholders will be normalized. On Windows, `<hash>` is not a valid filename if left literal, and the plan never defines how to compute or replace it. This should follow the font plan: author SVGs, run Godot import, then assert actual generated import params.

**HIGH — `default_font = Inter-Body.tres` conflicts with FONT-06 and breaks README CJK instructions.**  
`04-05` sets `default_font` to a `FontVariation`. FONT-06 says theme `default_font` is Inter Variable Roman with `fallbacks=[]` and system fallback enabled. `04-08` README then casts `theme.default_font as FontFile`, which fails if `default_font` is `FontVariation`. Use `Inter-Variable.tres` as `default_font`; use FontVariation only for explicit type variations.

**HIGH — `04-05` delegates the hardest implementation instead of specifying it.**  
Task 2 says the full `BINDING_TABLE` is too long to inline and tells the executor to author it from research. That is not an executable plan at the same rigor as the others. Since SC#7 depends on exact slots, the plan needs either a generated table artifact or an explicit script that introspects/validates the exact table against Godot 4.6 class theme properties.

**MEDIUM — The `.tres` strip helper is plausible but brittle.**  
The N5 additions help, but the line parser still assumes simple one-line section headers and a narrow resource body whitelist. It also strips generated defaults by text rather than saving a data-only resource intentionally. Safer: generate `.tres`, load it, verify it, then create a second data-only save path that temporarily suppresses regeneration or saves a cleared duplicate outside `_regenerate_theme()`.

**MEDIUM — Font acquisition is not true verification.**  
`04-02` says capture SHA256 after download. That records what was downloaded; it does not verify against a known-good hash. Pin the release asset URL and expected SHA256 in the plan before execution, or vendor the binary from a known checked-in source.

**LOW — DIRECTION_PRESETS lookup is acceptable but should be hardened.**  
The peer-load checks catch the main float round-trip risk. I would still add a helper that normalizes direction identity explicitly when creating shipped `.tres` files, or at least assert `base_color.to_html(false)` for every saved file.

**Suggestions**

- Fix the helper-script layout before execution.
- Replace the slot freeze with a generated/verified table from Godot 4.6 API data, not examples.
- Change CheckButton icons to `checked` / `unchecked` families; add disabled and mirrored icon slots.
- Make SVG imports Godot-generated, not hand-authored with fake `.ctex` paths.
- Set `default_font` to the base `FontFile`, then set variations explicitly.
- Add one real `godot --headless --script` verification step after `04-05` before any `.tres` generation.

**Risk Assessment**

Current risk is **high**. The plans have strong structure, but two blockers are contract-level: addon layout violates FOUND-01, and the slot verifier can pass wrong slots. Fix those before execution; otherwise Phase 4 may appear green while shipping a theme that is incomplete or structurally noncompliant.

Sources checked: Godot 4.6 `Theme` API, `FontVariation`, `StyleBoxFlat`, `CheckButton`, `CheckBox`, `Tree`, `TabBar`, and `Script.get_script_constant_map()` docs.

---


---

## Claude Self-Review (Orchestrator, Shallow)

User explicitly requested: *"i also dont trust OpenCode/Deepseek, so use your best judgement and also do a shallow self review"*. So beyond aggregating the two external reviewers, I validated each HIGH claim against authoritative sources (Godot 4.6 docs via Context7, the actual plan files, DESIGN_TOKENS.md). Reporting which findings are real vs which are false positives.

### Validation of OpenCode HIGH claims

**OpenCode C1 — DIRECTION_PRESETS values disagree with DESIGN_TOKENS §5 for 4 of 5 directions: VALIDATED ✓**

Diffed `DIRECTION_PRESETS` const in Plan 04-04 against DESIGN_TOKENS §5 personality state-layer-deltas lines:

| Direction | DESIGN_TOKENS §5 (authoritative) | Plan 04-04 DIRECTION_PRESETS |
|---|---|---|
| Pulse    | hover +6%,  pressed -10%, disabled 0.42 | hover 6.0,  pressed -10.0, disabled 0.42 ✓ |
| **Slate**    | **hover +4%,  pressed -6%**,  disabled 0.50 | **hover 8.0,  pressed -12.0**, disabled 0.50 ✗ |
| **Bubble**   | **hover +8%,  pressed -10%**, disabled 0.45 | **hover 10.0, pressed -12.0**, disabled 0.45 ✗ |
| **Daybreak** | hover +6%, **pressed -6%**,  disabled 0.50 | **hover 8.0,  pressed -12.0**, disabled 0.50 ✗ |
| **Burst**    | hover +8%,  pressed -12%, disabled 0.45 | **hover 10.0, pressed -14.0**, disabled 0.45 ✗ |

Pulse only correct direction. The other 4 ship with state layers that don't match the Phase 3.4 mockup-approved gate. **Real HIGH.**

**OpenCode C2 — GDScript Dictionary dot-notation invalid: INVALID ✗ (false positive)**

I verified via Context7 / Godot 4.6 docs: dict.key syntax is explicitly supported per `classes/class_dictionary.md` for string keys that are valid identifiers. `presets.spread_factor`, `tokens.body` etc. are valid GDScript 4.x. OpenCode misreads the language spec. **NOT a real concern.**

**OpenCode C3 — `.tscn` comment prefix `#` should be `;`: VALIDATED ✓**

Verified via Context7 / Godot 4.6 docs (`engine_details/file_formats/tscn.md`): TSCN single-line comments use `;` (semicolon), not `#`. Plan 04-01 inserts `# theme = ExtResource(...) - reassigned in Plan 04-07` — wrong prefix. Additionally, Godot will discard ANY comments on save, so the placeholder strategy is fragile. **Real HIGH.**

### Validation of Codex HIGH claims

**Codex HIGH 1 — Helper scripts violate FOUND-01: VALIDATED ✓**

FOUND-01 (verbatim): *"addon root contains exactly **1 `.gd` file** (`neocade_theme.gd`)"*. Plan 04-08 layout verifier explicitly REQUIRES 4 `.gd` files at addon root: `neocade_theme.gd`, `_phase4_import.gd`, `_phase4_verify.gd`, `_phase4_verify_headless.gd`. Strictly violates SC#1. The plan defends this by saying helpers are deleted in Phase 11 — but Phase 4 close state is what SC#1 evaluates against. **Real HIGH.**

**Codex HIGH 2 — CANONICAL_SLOT_NAMES + Plan 04-05 has wrong CheckButton slots: VALIDATED ✓**

Verified via Context7 / Godot 4.6 `class_checkbutton.md`: Theme Icons are `checked`, `checked_disabled`, `checked_disabled_mirrored`, `checked_mirrored`, `unchecked`, `unchecked_disabled`, `unchecked_disabled_mirrored`, `unchecked_mirrored`. Plan 04-05 says *"CheckButton on/off"*. Plan 04-03 names files `toggle_on.svg` / `toggle_off.svg`. Both wrong. Plus the plan misses 6 disabled/mirrored variants. **Real HIGH.**

**Codex HIGH 3 — SVG `.import` files have placeholder `<hash>` paths: VALIDATED ✓**

Plan 04-03 lines 239/247 use literal `<name>` and `<hash>` placeholders in `.import` `path=` and `dest_files=` strings. Line 279 says: *"placeholders will be normalized by Godot on first import"* — works ONLY if workflow is "commit placeholder → run Godot import → re-commit normalized". Plan doesn't enforce the re-commit step; if executor commits the placeholder once and never re-commits, the addon ships broken. **Real HIGH.**

**Codex HIGH 4 — `default_font = FontVariation` conflicts with FONT-06 + breaks README cast: VALIDATED ✓**

- FONT-06: *"Theme `default_font` is Inter Variable Roman; `default_font.fallbacks = []`"* — implies FontFile.
- Plan 04-05 line 135-136: assigns `FontVariation` (Inter-Body.tres) to `default_font`.
- Plan 04-08 line 412: README casts `default_font as FontFile`.

`FontVariation` and `FontFile` are sibling types both extending `Font`, NOT cast-compatible. README cast fails at runtime. Fix: `default_font` should be `Inter-Variable.tres` (the FontFile); per-variation FontVariations are set explicitly via `set_font(...)`. **Real HIGH.**

**Codex HIGH 5 — BINDING_TABLE delegated to executor: VALIDATED ✓**

Plan 04-05 Task 2 line 274 says *"too long to inline verbatim here, but the executor authors it directly using the 37-row scorecard..."* and line 345 *"BINDING_TABLE should be ~600-1000 lines"*. This is a delegation, not a plan. The exact slot-name underspecification produces issues like Codex HIGH 2's CheckButton bug. **Real HIGH.**

### Self-Review Independent Findings

**SR1 — OpenCode's cycle-5 LOW about regex token-fusion was INVALID.** I traced `\s*load_steps=\d+` empirically: regex matches ` load_steps=42` (16 chars including leading space). Empty-string replacement leaves the trailing space between `42` and `format` untouched (the regex doesn't extend past digits). No fusion. OpenCode misanalyzed. **Validates the user's distrust of OpenCode/DeepSeek as a reviewer — their flags should not be treated as authoritative without verification.**

**SR2 — `script_class="..."` no-spaces edge case (LOW).** The cycle-4 N5 strip preserves `begins_with("script_class =")` (with spaces). Both prior reviewers and the plan assumed Godot 4.6 always serializes with spaces. Likely fine; runtime `loaded is NeoCadeTheme` would catch regression. **Real LOW.**

**SR3-SR7 — Cross-plan integration spot-checks all clean** (font path consistency, reentry guard correctness, build-helper deletion lineage, main.tscn handling sequence, plan total volume = 4299 lines). No new findings. ✓

### Cycle 6 Aggregate

**Validated HIGH concerns introduced by this fresh pass: 7**

| # | Concern | Source | Plan |
|---|---|---|---|
| F1 | DIRECTION_PRESETS values wrong for 4/5 directions | OpenCode C1 (validated) | 04-04 Task 3.5 |
| F2 | `.tscn` comment prefix `#` should be `;` | OpenCode C3 (validated) | 04-01 Task 1 |
| F3 | Helper scripts at addon root violate FOUND-01 | Codex HIGH 1 (validated) | 04-02/06/07/08 |
| F4 | CheckButton slot names `on`/`off` should be `checked`/`unchecked` | Codex HIGH 2 (validated) | 04-03, 04-05 |
| F5 | SVG `.import` literal `<hash>` placeholders | Codex HIGH 3 (validated) | 04-03 Task 2 |
| F6 | `default_font` type mismatch (FontVariation vs FontFile) | Codex HIGH 4 (validated) | 04-05 Task 1 vs 04-08 README |
| F7 | BINDING_TABLE delegated to executor (~600-1000 lines unspecified) | Codex HIGH 5 (validated) | 04-05 Task 2 |

**Invalidated by self-review: 1**

| # | Concern | Source | Verdict |
|---|---|---|---|
| - | GDScript dict dot-notation invalid | OpenCode C2 | **FALSE POSITIVE** — `dict.key` is valid in GDScript 4.x for string keys that are valid identifiers (Godot docs explicit) |

**MEDIUMs added in this pass: 4** — strip helper edge cases, icon `.import` Godot-driven generation, hover/pressed verifier coverage, font SHA256 verification.

**LOWs: ~5** — disabled opacity baseline conflict, `_regenerate_theme()` runs ~10× per .tres load, dual verifier duplication, VERSION trailing-newline, `script_class` no-spaces edge case.

### Convergence Status — REOPENED

The cycle-5 "CONVERGED" verdict was premature. The fresh pass identified 7 real HIGH concerns the prior 5 cycles missed. Five cycles of review-replan converged on a plan-set that still contains:
- Wrong state-layer values for 4 of 5 directions (visible mockup-fidelity regression)
- Wrong CheckButton icon binding (icons silently don't apply)
- A forbidden helper-script layout (FOUND-01 violation)
- A FontVariation/FontFile type conflict (README cast would crash)
- A BINDING_TABLE delegation that masks ~600-1000 lines of unspecified work
- A `.tscn` comment prefix typo (parse error)
- An unreliable `.import` placeholder workflow

Risk assessment: **HIGH** (Codex), **HIGH** (validated against Claude's spot-checks), **MEDIUM-LOW** (OpenCode — but OpenCode's earlier verdicts proven unreliable, so down-weight).

**Recommendation: run cycle 7 replan to address all 7 validated HIGHs.** Each is mechanically fixable with specific edits to specific plans; none requires architectural rework.
