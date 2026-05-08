---
phase: 1
slug: source-dive-godot-minimal-theme-tres-dissection
status: draft
nyquist_compliant: true
wave_0_complete: true
created: 2026-05-04
---

# Phase 1 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.
>
> **NOTE:** Phase 1 is a research/documentation phase. It produces three Markdown research artifacts (`MINIMAL-THEME-DISSECTION.md`, `MINIMAL-THEME-COVERAGE-DELTA.md`, and a `SOURCES.md` Section 1 update) — no executable code, no tests. The "framework" below is **grep-based content verification** of the produced docs against required elements (provenance hash, class headings, omission flags, Pitfall 1.1/1.7 confirmation sections, SOURCES.md update markers). This satisfies Nyquist Dimension 8 by giving every task an automated post-execution check that runs in <1s.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | grep + test (POSIX) — no test runner; per-task acceptance criteria are grep assertions |
| **Config file** | none — Wave 0 not needed (Bash + grep available in Git Bash on Windows) |
| **Quick run command** | per-task: each task's `<acceptance_criteria>` block contains 1-N grep/test commands; run them after the task |
| **Full suite command** | concatenate all tasks' acceptance-criteria greps into a single shell pipeline (constructed at verification time) |
| **Estimated runtime** | <2s for any single task; <10s for full phase |

---

## Sampling Rate

- **After every task commit:** Run that task's `<acceptance_criteria>` greps locally — feedback is binary (criterion present/absent in the produced doc) and immediate.
- **After every plan wave:** Re-run all completed plans' criteria as a regression sweep.
- **Before `/gsd-verify-work`:** All criteria across all 5 plans must pass green.
- **Max feedback latency:** <2 seconds per task.

---

## Per-Task Verification Map

> Task IDs follow the planner's naming convention (`<phase>-<plan>-<task>`). Plans/tasks were authored in this same workflow run; the table below is **forward-mapped** from the plan structure decided in RESEARCH.md (5 plans / Wave 0 / Wave 1 / Wave 2). Statuses were backfilled on 2026-05-08 from the completed Phase 1 research artifacts: `MINIMAL-THEME-DISSECTION.md`, `MINIMAL-THEME-COVERAGE-DELTA.md`, and `SOURCES.md`.

| Task ID | Plan | Wave | Requirement | Threat Ref | Secure Behavior | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|------------|-----------------|-----------|-------------------|-------------|--------|
| 01-01-01 | 01 | 0 | RES-01 | — | Provenance present in DISSECTION.md | grep | `grep -q "SHA-256: 102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-01-02 | 01 | 0 | RES-01 | — | Globals/helpers/color-system documented | grep | `grep -qE "^## Globals|^## Helper Functions|^## Surface Ramp" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "_get_base_color" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "_set_margin" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "_set_border" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-01-03 | 01 | 0 | RES-01 (D-05) | T-1-01 | Editor-API touchpoints flagged | grep | `grep -qE "Editor[- ]API Touchpoints" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "EditorInterface.get_editor_settings" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "EditorInterface.get_editor_scale" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-02-01 | 02 | 1 | RES-01 (D-08) | — | Active-verification step records 80-token audit | grep | `grep -q "80 tokens total" .planning/research/MINIMAL-THEME-DISSECTION.md \|\| grep -q "Active Verification" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-02-02 | 02 | 1 | RES-01 (D-07) | — | All 27 user-facing Controls + FlatButton enumerated as `### ClassName` headings | grep | `for c in Button CheckBox CheckButton OptionButton MenuButton MenuBar LineEdit TextEdit Label RichTextLabel Tree ItemList TabBar TabContainer ProgressBar HSlider VSlider HScrollBar VScrollBar Panel PopupMenu PopupPanel AcceptDialog TooltipPanel Window ColorPicker GraphEdit FlatButton; do grep -q "^### $c\$" .planning/research/MINIMAL-THEME-DISSECTION.md \|\| { echo "MISSING: $c"; exit 1; }; done` | ✅ exists | ✅ pass |
| 01-02-03 | 02 | 1 | RES-01 (D-11) | — | Per-state coverage in enumeration tables (state column present) | grep | `grep -q "\| State \|" .planning/research/MINIMAL-THEME-DISSECTION.md \|\| grep -qE "^\| (normal\|hover\|pressed\|focus\|disabled)" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-02-04 | 02 | 1 | RES-01 (Pattern 1) | — | Line-citation column present in tables | grep | `grep -qE "Source line\|src line\|line\\(s\\)\|^\| Line " .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-03-01 | 03 | 1 | RES-01 (D-12) | — | Engine-default cross-reference: per-Control omission flags | grep | `grep -qE "(omitted by upstream\|leaves unset\|unset by upstream\|exists in default_theme.cpp)" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-03-02 | 03 | 1 | RES-01 (D-13) | — | Pitfall 1.1 confirmation/refutation section present | grep | `grep -qE "Pitfall 1\\.1.*(Confirm\|Refut)" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-03-03 | 03 | 1 | RES-01 (D-13) | — | Pitfall 1.7 confirmation/refutation section present | grep | `grep -qE "Pitfall 1\\.7.*(Confirm\|Refut)" .planning/research/MINIMAL-THEME-DISSECTION.md` | ✅ exists | ✅ pass |
| 01-04-01 | 04 | 1 | RES-01 (D-09) | — | Coverage delta file exists with 27-vs-35 comparison | grep | `test -f .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md && grep -q "27" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md && grep -q "35" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` | ✅ exists | ✅ pass |
| 01-04-02 | 04 | 1 | RES-01 (D-09) | — | NeoCade-additives section lists all 8 + container chrome | grep | `for c in CodeEdit FoldableContainer SpinBox ColorPickerButton LinkButton FileDialog ConfirmationDialog TooltipLabel; do grep -q "$c" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md \|\| { echo "MISSING ADDITIVE: $c"; exit 1; }; done` | ✅ exists | ✅ pass |
| 01-04-03 | 04 | 1 | RES-01 (D-10) | — | FlatButton type-variation note present | grep | `grep -q "FlatButton" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md && grep -qE "(type variation\|TYPEVAR-01\|Button variation)" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` | ✅ exists | ✅ pass |
| 01-05-01 | 05 | 2 | DOCS-05 | — | SOURCES.md Section 1 links into both new docs | grep | `grep -q "MINIMAL-THEME-DISSECTION" .planning/research/SOURCES.md && grep -q "MINIMAL-THEME-COVERAGE-DELTA" .planning/research/SOURCES.md` | ✅ exists | ✅ pass |
| 01-05-02 | 05 | 2 | DOCS-05 | — | SOURCES.md Section 1 confidence raised to HIGH | grep | `awk '/^## 1\\. godot-minimal-theme/,/^## 2\\./' .planning/research/SOURCES.md \| grep -q "Confidence in coverage:.*HIGH"` | ✅ exists | ✅ pass |
| 01-05-03 | 05 | 2 | DOCS-05 (D-15) | — | "What's still open" updated — `Full .tres enumeration` line resolved | grep | `awk '/^## 1\\. godot-minimal-theme/,/^## 2\\./' .planning/research/SOURCES.md \| grep -q "What's still open" && ! awk '/^## 1\\. godot-minimal-theme/,/^## 2\\./' .planning/research/SOURCES.md \| grep -q "Full .tres enumeration"` | ✅ exists | ✅ pass |

*Status: ✅ pass · ❌ fail · ⚠️ flaky*

---

## Wave 0 Requirements

- [x] No tests/test_file.py needed — Markdown deliverables only
- [x] No framework install needed — Bash + grep + sha256sum + Read are project standard, all verified available in Git Bash on Windows
- [x] Canonical heading style decided in RESEARCH.md Open Question 1 (`### ClassName` for per-Control sections) — applied uniformly in plans 02 and 04 so requirement-grep patterns are deterministic

*Existing infrastructure covers all phase requirements.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Per-Control formula extractions are *correct* (not just present) | RES-01 (D-04) | grep can verify presence of headings/columns/citations but not numerical correctness of symbolic formulas | Spot-check 5 random `### ClassName` sections in DISSECTION.md against the corresponding `set_*` lines in `minimal_theme.tres` (cited line numbers); each row's "formula" cell must match the actual GDScript expression at that line. Reviewer signs off as part of `/gsd-verify-work`. |
| Pitfall 1.1 / 1.7 confirmation reasoning is sound | RES-01 (D-13) | grep verifies the section exists; the *argument* needs human review against PITFALLS.md and `scene/gui/base_button.cpp` / `scene/theme/theme_db.cpp` | Read both confirmation/refutation sections end-to-end during `/gsd-verify-work`; each must cite source-line evidence (engine source AND populated-state slots in the .tres) and distinguish "engine behavior" from "theme response," per RESEARCH.md Pitfall 3+4 guidance. |
| 27-vs-35 coverage-delta math is correct | RES-01 (D-09) | grep checks the numbers appear; arithmetic and class membership require human review | During `/gsd-verify-work`: cross-check coverage-delta table against FEATURES.md 35-class matrix (item by item) and the active-verification 80-class audit list. |

---

## Validation Sign-Off

- [x] All tasks have `<automated>` verify (grep-based) or Wave 0 dependencies (none — all infra present)
- [x] Sampling continuity: every task has its own grep — no 3 consecutive tasks without automated verify
- [x] Wave 0 covers all MISSING references (no MISSING — all tools available, headings and citation formats decided)
- [x] No watch-mode flags (no test framework)
- [x] Feedback latency <2s per task
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** pending — set to `approved YYYY-MM-DD` when `/gsd-verify-work` completes for Phase 1.
