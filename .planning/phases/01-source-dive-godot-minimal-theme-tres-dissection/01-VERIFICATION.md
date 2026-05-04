---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
verified: 2026-05-04T12:30:00Z
status: passed
score: 5/5 must-haves verified
overrides_applied: 0
---

# Phase 1: Source-Dive: godot-minimal-theme `.tres` Dissection — Verification Report

**Phase Goal:** Produce evidence-grade enumeration of every theme entry in `passivestar/godot-minimal-theme` `.tres` (per-Control × per-state) so NeoCade's "feature-complete to godot-minimal-theme's bar" claim is verifiable, not aspirational.

**Verified:** 2026-05-04T12:30:00Z
**Status:** passed
**Re-verification:** No — initial verification

## Goal Achievement

### Observable Truths (ROADMAP Phase 1 Success Criteria)

| # | Truth | Status | Evidence |
|---|-------|--------|----------|
| 1 | SOURCES.md has a new section enumerating every theme entry — for each themed Control class, lists every stylebox / color / font / icon / constant entry with its base value and per-state value | VERIFIED | DISSECTION.md `## Per-Control Enumeration` (line 189) contains 28 `### ClassName` sections covering all 27 user-facing Controls + FlatButton; each row carries slot kind / state / formula / snapshot / line citation. SOURCES.md Section 1 cross-links DISSECTION.md as the enumeration artifact. |
| 2 | Coverage delta document compares godot-minimal-theme's entries to FEATURES.md 35-class matrix; flags additive Controls and missing classes | VERIFIED | `MINIMAL-THEME-COVERAGE-DELTA.md` (119 lines) contains the 37-row scorecard table summing to the 35-class FEATURES.md universe; 8 NeoCade-additives explicitly enumerated (CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel); sum invariant `23 + 8 + 2 + 2 = 35` documented. |
| 3 | Interaction-state transform conventions extracted as concrete numeric values, not prose impressions — feeds the M3 state-layer model decision in Phase 4 | VERIFIED | DISSECTION.md `## Globals` (lines 66-122) carries concrete numerics: 7-stop tonal surface ramp formulas (`color_surface_lowest..._highest`), font/icon named-color alpha values (0.7, 0.45, 0.35, 0.95, 0.6), `_get_base_color(brightness, sat_mult)` body extracted verbatim. Per-Control sections cite by name. |
| 4 | Popup/Window theming patterns cataloged — confirms or refutes Pitfall 1.7 | VERIFIED | DISSECTION.md `### Pitfall 1.7 — Popup Separate-Window Theming (Confirmation)` (line 1565) cites `theme_db.cpp` lines 365-374, 380-383 (engine-source layer-A behavior), `window.cpp` lines 67-95 (layer-B separate-Window behavior), and 5 upstream type-level entries (PopupMenu/PopupPanel/AcceptDialog/TooltipPanel/PopupDialog). Pitfall 1.7 **CONFIRMED** with engine + theme evidence. |
| 5 | Findings committed to `.planning/research/` as a dated artifact; SOURCES.md updated; no `.tres` styling commits made in this phase | VERIFIED | All 3 research artifacts created and committed (`MINIMAL-THEME-DISSECTION.md` 1683 lines, `MINIMAL-THEME-COVERAGE-DELTA.md` 119 lines, `SOURCES.md` Section 1 updated — Confidence MEDIUM → HIGH). `addons/neocade_theme/neocade_theme.tres` remains the 74-byte empty scaffold from pre-Phase-1 commit `d5063e1`; no styling commits in Phase 1's commit chain. |

**Score:** 5/5 truths verified

### Required Artifacts

| Artifact | Expected | Status | Details |
|----------|----------|--------|---------|
| `.planning/research/MINIMAL-THEME-DISSECTION.md` | 1683 lines, provenance + globals + helpers + 28 per-Control sections + engine cross-reference + Pitfall 1.1 + Pitfall 1.7 | VERIFIED | 1683 lines exact match. Provenance block contains snapshot path, file size 48442 bytes, line count 1118, ISO date 2026-05-04, SHA-256 `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`. Top-level sections: Provenance, Methodology, Editor-API Touchpoints (D-05), Globals, Helper Functions, Per-Control Enumeration, Engine-Default Cross-Reference and Pitfall Confirmations. |
| `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` | 119 lines, 35-class scorecard + 8 NeoCade-additives + FlatButton note + sum invariant | VERIFIED | 119 lines exact match. Coverage Scorecard table (37 rows reconciling to 35-class FEATURES.md universe), NeoCade-Additives (8) detail table, FlatButton type-variation note OUTSIDE the 35, Numeric Summary with sum invariant `23 + 8 + 2 + 2 = 35` verified. |
| `.planning/research/SOURCES.md` Section 1 | Confidence raised MEDIUM → HIGH; "Full .tres enumeration" line removed; Phase 1 sub-blocks added | VERIFIED | Line 56: `**Confidence in coverage:** **HIGH** for v1. Phase 1 source-dive (2026-05-04) opened the .tres and enumerated every entry per-Control × per-state...`. New `**What was read (Phase 1 source-dive, 2026-05-04):**` sub-block added. "Full .tres enumeration" removed from "What's still open". Two new "What we adopted" Phase 1 bullets (composite-state slot strategy, popup type-level theming). |

### Key Link Verification

| From | To | Via | Status | Details |
|------|-----|-----|--------|---------|
| DISSECTION.md provenance | minimal_theme.tres SHA-256 | SHA-256 `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e` | WIRED | Documented as reproducibility anchor in Provenance block; Note explicitly mentions ZIP download with no `.git`. |
| DISSECTION.md Editor-API Touchpoints | minimal_theme.tres line citations | Line 60 stamp: "All 12 cited lines verified by `sed -n 'Np'` against the live snapshot. Stamp date: 2026-05-04" | WIRED | Runtime-validation stamp present and dated, satisfying must-have truth #4 of Plan 01. |
| DISSECTION.md `## Globals` `scale` row | D-05 FORBIDDEN callout | Line 79: "⚠ **EDSCALE-derived; FORBIDDEN in NeoCade per D-05.**" | WIRED | Explicit FORBIDDEN-in-NeoCade callout in the Globals scale row, matching cross-AI review 2026-05-04 directive. |
| Coverage delta scorecard | DISSECTION.md `### ClassName` | Cross-reference column links `DISSECTION.md \`### ClassName\`` for every themed-in-upstream row | WIRED | All 27 themed-in-upstream rows link to a corresponding `### ClassName` section in DISSECTION.md (verified by grep). |
| SOURCES.md Section 1 | DISSECTION.md + COVERAGE-DELTA.md | "See `.planning/research/MINIMAL-THEME-DISSECTION.md`" / "See `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md`" | WIRED | Both new artifacts cited in SOURCES.md Section 1 "What was read (Phase 1 source-dive)" sub-block. |
| Pitfall 1.1 | base_button.cpp / button.cpp / default_theme.cpp | Engine-source line citations 222-226, 228-230, 290-303, 285, 324 | WIRED | Engine evidence chain documented; `_get_current_stylebox()` is shown to NOT include focus, focus drawn AFTER as overlay (lines 228-230), font_focus_color suppressed in non-DRAW_NORMAL states (lines 290-303). Composite-state slots cited from default_theme.cpp. |
| Pitfall 1.7 | theme_db.cpp / window.cpp / control.cpp | Lines 365-374, 380-383 (theme_db); 67-95 (window); 3585-3604 (control) | WIRED | Two-layer evidence chain: layer A (resource-level type entries DO apply via class-hierarchy walk) + layer B (per-Control runtime override-bag does NOT inherit through popups). Plus 5 upstream type-level entries cited. |

### Data-Flow Trace (Level 4)

N/A — research-only phase produces Markdown documentation, no runtime data flow to verify.

### Behavioral Spot-Checks

| Behavior | Command | Result | Status |
|----------|---------|--------|--------|
| DISSECTION.md line count matches spec | `wc -l .planning/research/MINIMAL-THEME-DISSECTION.md` | 1683 lines | PASS |
| COVERAGE-DELTA.md line count matches spec | `wc -l .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` | 119 lines | PASS |
| All 27 user-facing classes + FlatButton enumerated | `grep -nE "^### (AcceptDialog\|...\|FlatButton)$" DISSECTION.md` | 28 matches found (all 27 D-08 classes + FlatButton) | PASS |
| Top-level sections present | `grep -n "^## " DISSECTION.md` | 7 sections: Provenance, Methodology, Editor-API Touchpoints, Globals, Helper Functions, Per-Control Enumeration, Engine-Default Cross-Reference and Pitfall Confirmations | PASS |
| Pitfall sections present | `grep -n "Pitfall 1\.[17]" DISSECTION.md` | Both confirmation subsections at lines 1448 and 1565 | PASS |
| SOURCES.md Confidence raised to HIGH | `grep -n "Confidence in coverage" SOURCES.md` | Line 56: HIGH for godot-minimal-theme; line 87: MEDIUM for LDtk (correct — only Section 1 modified) | PASS |
| No .tres styling commits in addons/neocade_theme/ | `git log --oneline -- "addons/neocade_theme/*.tres"` | Only `d5063e1 feat(neocade_theme): add new theme resource file` (pre-Phase-1 scaffold, 74 bytes, empty `[resource]`) | PASS |

### Requirements Coverage

| Requirement | Source Plan | Description | Status | Evidence |
|-------------|-------------|-------------|--------|----------|
| RES-01 | Plans 01-04 | Phase 1 source-dive spike produces line-by-line dissection of passivestar/godot-minimal-theme .tres (per-Control × per-state entry enumeration; interaction state transforms; popup/window theming patterns). Findings appended to SOURCES.md. | SATISFIED | DISSECTION.md per-Control enumeration (28 sections), COVERAGE-DELTA.md 35-class scorecard, SOURCES.md Section 1 updated with Phase 1 findings; Pitfalls 1.1 + 1.7 confirmed. REQUIREMENTS.md line 14: `[x]` marked complete. |
| DOCS-05 | Plan 05 | SOURCES.md is updated by Phase 1, 2, 3 source-dive spike outputs (RES-01..03) with new findings. | SATISFIED | SOURCES.md Section 1 modified in place: Confidence MEDIUM → HIGH, Phase 1 sub-blocks added, "Full .tres enumeration" line removed from "What's still open". Sections 2-9 untouched (verified — line 87 LDtk MEDIUM unchanged). REQUIREMENTS.md line 200 + line 385 confirm Phase 1 contribution. |

No orphaned requirements detected — REQUIREMENTS.md Phase 1 distribution explicitly lists exactly RES-01 + DOCS-05 (line 394: "Phase 1: 2 (RES-01, plus Phase 1 contribution to DOCS-05)"); both are accounted for in the plan frontmatter and verified above.

### Anti-Patterns Found

| File | Line | Pattern | Severity | Impact |
|------|------|---------|----------|--------|
| (none) | — | — | — | Research artifacts only — no executable code in scope. Provenance block, runtime-validation stamps, and FORBIDDEN-in-NeoCade callouts deliberately included to flag upstream's editor-API patterns; these are anti-pattern *documentation*, not anti-patterns in NeoCade code. |

### Hard Constraint Verification

| Constraint | Source | Status | Evidence |
|-----------|--------|--------|----------|
| No `.tres` styling commits in `addons/neocade_theme/` (mockup gate, D-05) | CLAUDE.md, PROJECT.md hard constraint | UPHELD | Only commit touching `addons/neocade_theme/*.tres` is the pre-Phase-1 scaffold `d5063e1` (74 bytes — minimal `[gd_resource type="Theme" format=3]` + empty `[resource]` block). Phase 1 commit chain (97e4ac4 → 2593237) modified `.planning/research/*.md` and `.planning/phases/01-*/SUMMARY.md` only. Verified by `git log --oneline -- "addons/neocade_theme/*.tres"`. |
| Snapshot path documented | Plan 01 | UPHELD | `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres` documented in Provenance. |
| SHA-256 reproducibility anchor | Plan 01 | UPHELD | `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e` documented + Note explains ZIP-download → no commit SHA available, SHA-256 is the anchor. |
| 80-class active-verification audit | Plan 02 D-08 | UPHELD | DISSECTION.md `### Active Verification Audit` (line 193) classifies all 80 unique uppercase tokens into 5 buckets (user-facing enumerated, editor-only skipped, slot-name not-a-class, type-variation, NeoCade-additive). |
| Engine-source commit anchor | Plan 03 | UPHELD | DISSECTION.md `### Engine-Default Cross-Reference` documents godot-master snapshot mtime (2026-05-01 18:12:23 -0700), version (4.7-beta), and caveat about 4.6 → 4.7 drift with re-verification recommendation for Phase 4. |

### Human Verification Required

None. Phase 1 is research-only; all deliverables are textual artifacts whose structural correctness was programmatically verified above. No visual / runtime / external-service behaviors to test.

### Gaps Summary

No gaps found. All 5 ROADMAP success criteria are satisfied with citation-grade evidence in the codebase. Both requirement IDs (RES-01, DOCS-05) are SATISFIED. Both pitfall confirmations cite engine-source AND theme-resource evidence per Plan 03 must-haves. Sum invariant on the 35-class coverage delta verified. Hard constraint (no `.tres` styling commits) upheld. The phase goal — evidence-grade enumeration making "feature-complete to godot-minimal-theme's bar" verifiable — is achieved: Phase 4's `@tool` token-generator now has a per-Control × per-state × per-slot input contract, and Phase 10's COV-10 has a concrete enumeration to diff against.

---

_Verified: 2026-05-04T12:30:00Z_
_Verifier: Claude (gsd-verifier)_
