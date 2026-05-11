---
phase: 13-role-variations
verified: 2026-05-11T00:00:00Z
status: human_needed
score: 9/9 must-haves verified (visual halo / chrome inspection requires manual UAT)
overrides_applied: 0
human_verification:
  - test: "Open showcase.tscn in Godot 4.6.2 editor, switch to Role Variations tab. Visually confirm each of 5 Role Panels shows a subtle 6% tinted background (NOT a solid block; NOT a halo under GL Compatibility). Default chrome in other tabs (Buttons, Token Gallery, Coverage) looks identical to pre-Phase-13 state."
    expected: "4 Role Labels are legibly colored (success=green, warning=yellow, danger=red, info=cyan) on surface background; 5 Role Panels show a subtle role-tinted wash; no haloing on panel borders; other tabs visually unchanged."
    why_human: "Visual halo presence under GL Compatibility (Pitfall 1; Godot #23640 analog) and pixel-level legibility judgement is not automatable. CLAUDE.md QA flow explicitly defers visual UAT to manual user verification. 13-VALIDATION.md Manual-Only Verifications section also lists this as a manual gate."
deferred_items:
  - id: DI-13-01
    location: ".planning/phases/13-role-variations/deferred-items.md"
    summary: "Verifier `--stage default-chrome-unchanged` over-strict alpha-band check false-REDs on Daybreak's pre-existing `shape.surface_alpha_panels=0.96` (Phase 12 baseline, NOT a Phase 13 regression). Helper-side spec gap; SC#3 genuinely intact by static diff inspection."
    impact: "Cosmetic verifier defect; does not invalidate SC#3 closure."
  - id: WR-01 (from 13-REVIEW.md)
    location: ".planning/phases/13-role-variations/13-REVIEW.md"
    summary: "README copy 'tint by 6% over the per-direction panel chrome' mischaracterizes the implementation (alpha=0.06 is a replacement of bg_color role, not a compositing overlay)."
    impact: "Documentation drift, not a code defect; cosmetic and tracked."
---

# Phase 13: Role Variations Verification Report

**Phase Goal (from ROADMAP.md):**
> Add opt-in role-coded type variations (4 Role Labels + 5 Role Panels) consumers can apply via `theme_type_variation` when a widget semantically represents success/warning/danger/info/accent state. Zero auto-bindings; baseline chrome unchanged from Phase 12.

**Verified:** 2026-05-11
**Status:** human_needed (all 9 automated must-haves VERIFIED; one visual UAT item awaiting manual inspection)
**Re-verification:** No — initial verification

## Goal Achievement

### Locked Success Criteria (from ROADMAP and 13-VALIDATION.md)

Phase 13 has no REQ-IDs in REQUIREMENTS.md; coverage is via 3 locked success criteria (SC-13-1, SC-13-2, SC-13-3) plus must-have invariants pinned by the four plan frontmatters.

| #   | Truth                                                                                                                                                          | Status     | Evidence                                                                                                                                                                                                            |
| --- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 1 (SC-13-1) | Default chrome unchanged from Phase 12 baseline; smoke-test 30 configs regenerate cleanly with all invariants holding.                          | VERIFIED  | `_phase13_smoke_matrix.gd` PASS — 30 configs regenerated cleanly, all invariants held (BT=149, TV=61, exports=12, `has_color("font_color", *Label)` ×4, `has_stylebox("panel", *Panel)` ×5). Default Label.font_color at line 3169 still `{"role": "text_strong"}`; default PanelContainer.panel at lines 5011-5022 byte-identical (`"role": "surface_panel"`, `"alpha": "shape.surface_alpha_panels"`, `"padding": Vector2i(10, 8)`). |
| 2 (SC-13-2) | All 4 Role Labels + 5 Role Panels visible in new Showcase section; headless verifier confirms registry + showcase scene contain all 9 keys.    | VERIFIED  | `--stage role-variations-registered` PASS — 9 new variations live. `--stage role-variations-in-showcase` PASS — all 9 variation nodes confirmed in `showcase/showcase.tscn` (lines 1441, 1446, 1451, 1456, 1469, 1478, 1487, 1496, 1505 carry `theme_type_variation = &"..."`). |
| 3 (SC-13-3) | Type variations only activate when consumer applies `theme_type_variation`; never auto-bound to widget defaults.                                  | VERIFIED  | The 9 new keys are registered in `TYPE_VARIATIONS` (additive, lines 1329-1338) with BINDING_TABLE recipes that ONLY fire when the resolver walks those entries (key-driven, opt-in). Static diff: zero modifications to default `Label.font_color` recipe at line 3169 or default `PanelContainer.panel` recipe at lines 5011-5022. None of the 9 keys appear in `EDITOR_ONLY_THEME_TYPES` (Pitfall 4 invariant). |
| 4 | All 9 TYPE_VARIATIONS keys registered with correct base types (4 Labels → `Label`; 5 Panels → `PanelContainer`).                                          | VERIFIED  | `addons/neocade_theme/scripts/neocade_theme.gd` lines 1328-1338: 4 entries map to `"Label"` and 5 entries map to `"PanelContainer"`. Runtime verifier `--stage role-variations-registered` PASS confirms registry membership. |
| 5 | 4 explicit `set_font("font", "<X>Label", body_font)` calls AND 4 explicit `set_font_size("font_size", "<X>Label", tokens.body)` calls in `_regenerate_theme()` (PITFALLS 1.2 / Pitfall 6 mandate). | VERIFIED  | `neocade_theme.gd` lines 447-450 (set_font for Success/Warning/Danger/Info Label) and lines 512-515 (set_font_size for same). `--stage role-label-fonts` PASS — all 4 Role Labels have explicit font + font_size > 0. Role Panels deliberately have ZERO font calls (PanelContainer renders no text). |
| 6 | 9 BINDING_TABLE recipe entries; BINDING_TABLE.size() == 149 (Phase 12 baseline 140 + 9 Phase 13).                                                          | VERIFIED  | 149 top-level keys counted in `BINDING_TABLE` dict body (powershell-confirmed). 4 Role Label entries (lines 5081-5103) each contain only `color.font_color` recipe pointing to `role_<x>`. 5 Role Panel entries (lines 5107-5174) each contain a full `stylebox.panel` recipe with `alpha: 0.06` literal (exactly 5 occurrences in file). `--stage architecture` PASS confirms runtime count. |
| 7 | No new `@export` declarations (12-export contract preserved).                                                                                              | VERIFIED  | `^@export var` count = 12 (lines 49, 61, 68, 79, 86, 93, 101, 109, 117, 125, 138, 147). Runtime introspection via `_count_top_level_exports()` confirms 12 via `--stage architecture`. |
| 8 | `Theme.clear()` does not appear anywhere in `neocade_theme.gd` (D-01 invariant).                                                                          | VERIFIED  | Full-file grep returns 0 matches for `Theme.clear()` across both comment and non-comment lines. |
| 9 | None of the 9 new keys appear in `EDITOR_ONLY_THEME_TYPES` (Pitfall 4 invariant — these are general-purpose opt-ins, not editor-only).                  | VERIFIED  | EDITOR_ONLY_THEME_TYPES dict (lines 1342-1410) inspected; none of `SuccessLabel`, `WarningLabel`, `DangerLabel`, `InfoLabel`, `AccentPanel`, `InfoPanel`, `WarningPanel`, `DangerPanel`, `SuccessPanel` are present. |

**Score:** 9/9 truths verified

### Required Artifacts

| Artifact                                                                                                            | Expected                                                                                                                                  | Status     | Details                                                                                                                                                                                                                                              |
| ------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `addons/neocade_theme/scripts/neocade_theme.gd`                                                                     | 9 new TYPE_VARIATIONS keys; 4 set_font + 4 set_font_size for Role Labels; 9 new BINDING_TABLE entries; D-01 + 12-export + Pitfall 4 intact | VERIFIED   | All grep checks pass. Loadable as `NeoCadeTheme` resource (verified by `_phase13_verify_headless.gd` which calls `ResourceLoader.load(CANONICAL_TRES)` successfully).                                                                              |
| `showcase/showcase.tscn`                                                                                            | 9 nodes wired with new `theme_type_variation = &"<Name>"` values; structural Role Variations ScrollContainer at tab_index=9 with visible=false | VERIFIED   | ScrollContainer "Role Variations" at line 1408; tab_index=9 at line 1412; 9 demo cells use the 9 expected variations; 1 Kicker label adds a section header. 20 unique_ids in reserved Phase 13 range 2700000010-2700000029; 262 total unique_ids in scene with 0 duplicates. |
| `README.md`                                                                                                         | `## Role Variations (opt-in)` section between `## Showcase` and `## Design Rules`; Showcase tab count updated to "10 sections"             | VERIFIED   | Section present at line 81 (between Showcase line 65 and Design Rules line 118). Two mapping tables document the 4 Role Labels + 5 Role Panels. `&"<Name>"` StringName literal syntax used in code samples. Showcase line 69 updated: "10 sections covering controls, dialogs, graph, tokens, coverage, and role variations." |
| `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd`                                          | Pin `EXPECTED_BINDING_TABLE_ROWS := 149` and `EXPECTED_TYPE_VARIATIONS_COUNT := 61`                                                       | VERIFIED   | Lines 19-20: both constants pinned at the expected values. Helper successfully invoked against canonical Godot 4.6.2 CLI; runtime evidence reproduced below. (Note: line 7 docstring still references "TYPE_VARIATIONS == 56" — this is a stale docstring; the actual `const` on line 20 is correct at 61. Cosmetic, not blocking.) |
| `.planning/phases/13-role-variations/helpers/_phase13_smoke_matrix.gd`                                             | Same pins (BT=149, TV=61)                                                                                                                 | VERIFIED   | Lines 16-17: both constants pinned at 149/61. Runtime evidence: `PHASE13_SMOKE: PASS — 30 configs regenerated cleanly, invariants held`.                                                                                                                  |

### Key Link Verification

| From                                            | To                                                                            | Via                                                                                  | Status   | Details                                                                                                                                                                                       |
| ----------------------------------------------- | ----------------------------------------------------------------------------- | ------------------------------------------------------------------------------------ | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TYPE_VARIATIONS dict (9 new keys)               | `_regenerate_theme()` `set_type_variation()` loop                             | Existing loop iterates over TYPE_VARIATIONS; new keys auto-registered on regenerate  | WIRED    | Runtime: `--stage role-variations-registered` returns OK; live theme reports all 9 variations registered. |
| Role Label TYPE_VARIATIONS entries (4)          | `set_font()` + `set_font_size()` blocks at lines 447-450 & 512-515            | Explicit calls — Pitfall 1.2 mandate (no Theme inheritance for fonts on variations)  | WIRED    | Runtime: `--stage role-label-fonts` returns OK; all 4 Role Labels have `has_font("font", v)` true AND `font_size > 0`. |
| Role Label BINDING_TABLE entries (4)            | `_resolve_recipe()` color branch                                              | Recipe `{"role": "role_<x>"}` resolved via `role_table` lookup                       | WIRED    | Runtime: `has_color("font_color", *Label)` true for all 4 via `--stage role-variations-registered`. Role tokens `role_success`, `role_warning`, `role_danger`, `role_info` exist in `role_table`. |
| Role Panel BINDING_TABLE entries (5)            | `_resolve_recipe()` stylebox branch with alpha pathway                        | Recipe `{"role": "role_<x>", "alpha": 0.06, ...}` resolved via alpha-literal path     | WIRED    | Runtime: `has_stylebox("panel", *Panel)` true for all 5 via `--stage role-variations-registered`. Existing resolver at neocade_theme.gd lines ~5353-5360 accepts literal floats for `alpha`. |
| showcase.tscn `theme_type_variation` cells      | Live theme registry (NeoCadeTheme TYPE_VARIATIONS)                            | Ext_resource theme load at scene root + Godot's `set_type_variation()` propagation   | WIRED    | Runtime: `--stage role-variations-in-showcase` returns OK; scene-walk found all 9 expected variation names in the showcase tree. |
| README code samples (`&"SuccessLabel"`, `&"AccentPanel"`) | Consumer apply pattern                                                  | Documentation; StringName literal syntax matches showcase.tscn convention            | WIRED    | Code samples are syntactically valid GDScript and reference real registered variation names. |

### Data-Flow Trace (Level 4)

| Artifact | Data Variable | Source | Produces Real Data | Status |
| -------- | ------------- | ------ | ------------------ | ------ |
| Showcase "Role Variations" tab → Role Labels (4 cells) | `theme_type_variation` StringName literal | NeoCadeTheme registry (set_color via BINDING_TABLE resolver) | Yes — `has_color("font_color", *Label)` returns true for all 4 in live theme; role_table tokens (`role_success`/`role_warning`/`role_danger`/`role_info`) are populated per-direction at theme regenerate | FLOWING |
| Showcase "Role Variations" tab → Role Panels (5 cells, each wrapping a content Label) | `theme_type_variation` StringName literal | NeoCadeTheme registry (set_stylebox via BINDING_TABLE resolver) | Yes — `has_stylebox("panel", *Panel)` returns true for all 5 in live theme; `bg_color = role_table[role] * alpha=0.06` | FLOWING |
| `_phase13_smoke_matrix.gd` per-config invariant block | Live theme regenerated from 30 different (style, raised, platform) configs | Theme `_regenerate_theme()` for each config | Yes — all 30 configs regenerate cleanly, all invariants hold including 9 new variation bindings | FLOWING |

### Behavioral Spot-Checks (live runtime)

| Behavior                                                                | Command                                                                                  | Result                                                                                                                | Status   |
| ----------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- | -------- |
| Architecture invariants (BT=149, TV=61, exports=12)                     | `--stage architecture`                                                                   | `PHASE13_VERIFY: architecture OK (BINDING_TABLE=149, TYPE_VARIATIONS=61, exports=12); PASS — stage 'architecture' all assertions green` | PASS     |
| 9 new role variations registered in live theme + have color/stylebox bindings | `--stage role-variations-registered`                                                     | `role-variations-registered OK (9 new variations live); PASS — stage 'role-variations-registered' all assertions green` | PASS     |
| All 9 variations present in showcase scene                              | `--stage role-variations-in-showcase`                                                    | `role-variations-in-showcase OK (all 9 variation nodes present in showcase.tscn); PASS — stage 'role-variations-in-showcase' all assertions green` | PASS     |
| 4 Role Labels have explicit font + font_size (Pitfall 1.2)              | `--stage role-label-fonts`                                                               | `role-label-fonts OK (4 Role Labels have explicit font + font_size); PASS — stage 'role-label-fonts' all assertions green` | PASS     |
| Default chrome unchanged                                                | `--stage default-chrome-unchanged`                                                       | RED on Daybreak alpha 0.960 (DI-13-01 — over-strict verifier heuristic; pre-existing Phase 12 token, NOT a Phase 13 regression) | DEFERRED (DI-13-01; not a failure per verification request) |
| 30-config invariant smoke                                               | `_phase13_smoke_matrix.gd`                                                               | `PHASE13_SMOKE: PASS — 30 configs regenerated cleanly, invariants held`                                              | PASS     |

### Requirements Coverage

Phase 13 has no REQUIREMENTS.md REQ-IDs (per ROADMAP.md line 606 and 13-VALIDATION.md line 40). Plan frontmatters declare requirements as `[SC-13-1, SC-13-2, SC-13-3]`, the 3 locked success criteria.

| Requirement | Source Plan(s)                                | Description                                                                                                                       | Status     | Evidence                                                                                                                                                                                                                                                                                                                                                                       |
| ----------- | --------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SC-13-1     | 13-01, 13-02, 13-03, 13-04                    | Default chrome unchanged from Phase 12 baseline; 30 configs regenerate pre/post pixel-equal where no Role Variation widget is placed. | SATISFIED  | 30-config smoke matrix PASS; static diff inspection confirms zero modifications to default Label.font_color (line 3169) or default PanelContainer.panel (lines 5011-5022) recipes across all four Phase 13 plans. The DI-13-01 RED in `--stage default-chrome-unchanged` is a verifier-side over-strict heuristic, not a baseline regression (deferred-items.md-tracked).         |
| SC-13-2     | 13-01, 13-02, 13-03, 13-04                    | All 4 Role Labels + 5 Role Panels visible in the new Showcase section; headless verifier confirms registry + scene presence.       | SATISFIED  | `--stage role-variations-registered` PASS (9 has_color/has_stylebox bindings live). `--stage role-variations-in-showcase` PASS (scene-walk confirms all 9 `theme_type_variation` cells present in showcase.tscn). Showcase has "Role Variations" tab at index 9 with 1 Kicker + 4 Role Label demos + 5 Role Panel demos (each wrapping content Labels).                          |
| SC-13-3     | 13-01, 13-02, 13-03, 13-04                    | Type variations only activate when consumer applies `theme_type_variation`; never auto-bound to widget defaults.                  | SATISFIED  | Static diff: default `Label.font_color` recipe at line 3169 still `{"role": "text_strong"}` (unchanged); default `PanelContainer.panel` recipe at lines 5011-5022 still uses `surface_panel` + `Vector2i(10, 8)` (unchanged). The 9 new BINDING_TABLE entries are KEY-driven, only resolving when their TYPE_VARIATIONS key is matched on a widget. Pitfall 4 verified — none of the 9 keys leak into EDITOR_ONLY_THEME_TYPES. |

No ORPHANED requirements: all plan-frontmatter `requirements:` IDs map to the 3 SCs above; the SCs are all SATISFIED.

### Anti-Patterns Found

| File                                                                                  | Line(s)   | Pattern                                                            | Severity | Impact                                                                                                                                                                                                                                                                                                       |
| ------------------------------------------------------------------------------------- | --------- | ------------------------------------------------------------------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `.planning/phases/13-role-variations/helpers/_phase13_verify_headless.gd`             | 7         | Stale docstring (`TYPE_VARIATIONS == 56`)                          | Info     | The header docstring still says `BINDING_TABLE.size() == 149, TYPE_VARIATIONS == 56` while the live `const EXPECTED_TYPE_VARIATIONS_COUNT := 61` on line 20 is the actually-asserted value. Cosmetic comment drift documenting Wave-1's stale-baseline reconciliation that wasn't propagated to this docstring. |
| `addons/neocade_theme/scripts/neocade_theme.gd`                                       | 5079-5080 | Stale source-line reference in comment (IN-01 from 13-REVIEW.md)   | Info     | Comment claims `Label.font_color` is at line 3147; actual line is 3169. SC#3 invariant itself holds — comment points at wrong line, would mislead future reviewers. Documentation drift, not a defect.                                                                                                       |
| `showcase/showcase.tscn`                                                              | 193, 1493 | Duplicate node name `DangerPanel` under different parents (IN-02)  | Info     | Pre-existing `DangerPanel` (Buttons section, no theme_type_variation) and new Phase 13 `DangerPanel` (Role Variations section, with `&"DangerPanel"`) under different parents. Godot allows same-name siblings; unique_ids do not collide. Not a functional bug.                                                |
| `addons/neocade_theme/scripts/neocade_theme.gd`                                       | 5104-5172 | `raised=true` behavior on Role Panels undocumented (IN-03)         | Info     | `raised_face_edge: true` causes `_apply_raised_depth_border()` to overwrite `surface_panel_edge` border with `role_<x>_offset` darker tint when `raised=true`. Consistent with all other raised-aware recipes; intentional but unmentioned in comments / README.                                                |
| `addons/neocade_theme/scripts/neocade_theme.gd`                                       | 5111, 5125, 5139, 5153, 5167 | Magic-number `0.06` duplication across 5 Role Panel recipes (IN-04) | Info     | Future tuning requires editing 5 sites. Stylistically consistent with other alpha literals in the file (0.10, 0.18, 0.20, 0.32, 0.55, 0.72), so a one-off literal here matches the file's prevailing pattern. Not blocking.                                                                                  |
| `README.md`                                                                           | 97-98     | "6% tint over the per-direction panel chrome" mischaracterization (WR-01 from 13-REVIEW.md) | Info (warning-class but surfaced as deferred per verification request) | The README implies a compositing model (role color layered on top of `surface_panel`), but the actual implementation REPLACES the panel face role (alpha=0.06 over whatever is behind the PanelContainer, not over `surface_panel`). Documentation drift; tracked as deferred. |

No Blocker / Warning-class production-code defects found. The WR-01 README copy mischaracterization is documentation drift only; surfaced as deferred per the verification request's explicit instructions.

### Human Verification Required

#### 1. Visual halo / chrome inspection of showcase Role Variations tab

**Test:** Open `showcase/showcase.tscn` in Godot 4.6.2 editor (or run the project), switch to the "Role Variations" tab; visually inspect each of the 5 Role Panels for haloing under GL Compatibility (Pitfall 1 / Godot #23640 analog). Also visually confirm:
- All 4 Role Labels are legibly colored on the surface background (success=green, warning=yellow, danger=red, info=cyan).
- All 5 Role Panels show a subtle tinted background — NOT a solid block, NOT a halo around the panel border.
- Default Label and default PanelContainer chrome in OTHER tabs (Buttons, Token Gallery, Coverage) looks IDENTICAL to its pre-Phase-13 appearance.

**Expected:** Subtle, legible role-tinted panels with no haloing; default chrome visually unchanged in other tabs.

**Why human:** Visual halo presence under GL Compatibility and pixel-level legibility judgement is not automatable. CLAUDE.md QA flow explicitly defers visual UAT to manual user verification; 13-VALIDATION.md "Manual-Only Verifications" section lists this as a manual gate. The Wave-0 `_phase13_role_render.gd` helper exists for evidence capture if a halo is observed (precompute-mix fallback path documented in 13-RESEARCH.md lines 300-314).

### Deferred Items (informational; explicitly NOT failures per verification request)

These are tracked items the verification request explicitly surfaced as deferred:

1. **DI-13-01** — `_phase13_verify_headless.gd --stage default-chrome-unchanged` over-strict alpha-band check false-REDs on Daybreak's `shape.surface_alpha_panels=0.96` (Phase 12 baseline token, NOT a Phase 13 regression). Helper-side spec gap; SC#3 genuinely intact by static diff inspection. Recommended fix in a follow-up: replace alpha-band heuristic with "no bound `bg_color` in default `PanelContainer.panel` references a `role_<x>` token" check. Tracked in `.planning/phases/13-role-variations/deferred-items.md`.

2. **WR-01** (from 13-REVIEW.md) — README claim that Role Panels "tint by 6% over the per-direction panel chrome" mischaracterizes the implementation. The 0.06 alpha is a replacement of the panel face `bg_color` (resolved via `role_<x>` against the parent surface), not a compositing layer ON TOP of `surface_panel`. Documentation drift, not a code defect. Tracked in `13-REVIEW.md` line 61-93 with suggested replacement copy.

### Closeout Summary

All 9 must-have observable truths are VERIFIED through a combination of:

- Source-code grep + structural diff inspection (TYPE_VARIATIONS, BINDING_TABLE, set_font/set_font_size, @export count, Theme.clear() absence, EDITOR_ONLY_THEME_TYPES Pitfall 4 absence, default Label/PanelContainer recipes unchanged).
- Live runtime verification via canonical Godot 4.6.2 CLI: `--stage architecture` PASS, `--stage role-variations-registered` PASS, `--stage role-variations-in-showcase` PASS, `--stage role-label-fonts` PASS.
- 30-config smoke matrix PASS — every Phase 13 invariant holds across the curated (style × raised × platform × custom-color) sweep.
- Static counts: BINDING_TABLE = 149 (140 pre-Phase-13 + 9 new), TYPE_VARIATIONS = 61 (52 actual pre-Phase-13 baseline + 9 new — Wave-1-reconciled from the stale "47 + 9 = 56" plan text), `@export var` = 12, `Theme.clear()` non-comment count = 0, alpha 0.06 literal count = 5 (one per Role Panel).
- Showcase scene: 9 `theme_type_variation = &"<Name>"` cells wired across 4 Role Label + 5 Role Panel demo nodes; 20 new unique_ids in reserved Phase 13 range 2700000010-2700000029; 262 total unique_ids in scene, 0 duplicates.
- README: `## Role Variations (opt-in)` section between Showcase and Design Rules with mapping tables and `&"<Name>"` code samples; Showcase tab count updated from 9 to 10.

One stage (`--stage default-chrome-unchanged`) returns RED, but the failure is the documented DI-13-01 verifier-side heuristic bug, not a real SC#3 regression. SC#3 is genuinely intact by static diff inspection. This is explicitly surfaced as a deferred item per the verification request, not a gap.

One human verification item remains (visual halo / chrome inspection per Pitfall 1; 13-VALIDATION.md Manual-Only Verifications section). Per the decision tree in Step 9: ANY human verification item flips status from `passed` to `human_needed`, regardless of the otherwise-clean 9/9 automated score.

**Phase 13 goal is achieved at the code level (9/9 truths VERIFIED).** The remaining work is a single manual UAT pass for visual halo + chrome confirmation, which is the documented `13-VALIDATION.md` Manual-Only gate.

---

_Verified: 2026-05-11_
_Verifier: Claude (gsd-verifier)_
_Runtime evidence: Godot 4.6.2 stable mono official 71f334935_
