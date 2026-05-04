---
phase: 1
reviewers: [opencode]
reviewer_models:
  opencode: deepseek/deepseek-v4-pro
reviewed_at: 2026-05-04T17:33:12Z
plans_reviewed:
  - 01-01-dissection-skeleton-PLAN.md
  - 01-02-per-control-enumeration-PLAN.md
  - 01-03-omission-and-pitfalls-PLAN.md
  - 01-04-coverage-delta-PLAN.md
  - 01-05-sources-md-update-PLAN.md
high_concerns: 2
medium_concerns: 4
low_concerns: 4
overall_risk: MEDIUM
---

# Cross-AI Plan Review — Phase 1

## OpenCode Review (DeepSeek V4 Pro)

# Cross-AI Plan Review — NeoCade Theme Phase 1

## Summary

The 5-plan set is **thorough and largely well-designed**, with exhaustive coverage of RES-01 and DOCS-05 requirements, strong alignment with all 15 locked D-decisions, and clear acceptance criteria. However, the **Wave 1 scheduling claim is factually incorrect** — Plans 03 and 04 have hard read-dependencies on Plan 02's output despite being declared "parallel-eligible." This will cause execution failures if the three run in parallel. Two plans also embed massive verbatim document templates that assume precise line numbers in the upstream source; provenance verification (Plan 01-01 Task 1) mitigates this but doesn't fully close the gap. Overall risk: **MEDIUM** — the plans would work if executed sequentially (02 → 03 → 04) but will fail under the stated Wave-1 parallelism.

---

## Strengths

- **Complete D-decision alignment**: Every locked decision D-01 through D-15 is explicitly addressed by at least one plan. D-05 (Editor-API touchpoints) gets a dedicated, highly-visible section with 13 touchpoint line citations. D-12 (omission flags) and D-13 (pitfall confirmation) are fully discharged.
- **Three-file split (D-14/D-15) is cleanly executed**: DISSECTION.md (descriptive), COVERAGE-DELTA.md (analysis), SOURCES.md (synthesis) — each plan targets exactly one deliverable.
- **Acceptance criteria are grep-verifiable**: Every plan specifies bash greps that can objectively verify completion. Plan 01-01's 12 structural checks, Plan 01-02's per-class row counts, Plan 01-03's pitfall-confirmation string checks — all mechanically testable without human judgment.
- **Pitfall handling is nuanced**: Pitfall 1.1 and 1.7 sections correctly distinguish engine *behavior* from theme *response*, avoiding the RESEARCH.md Pitfalls 3/4 conflation errors. Layer A/B distinction for popup theming is precise.
- **Active-verification audit (Plan 01-02 Task 1) re-surveys the entire 80-class surface**: This discharges the "keyword grep might miss classes" risk. The audit produces a classification table that feeds both the coverage delta and the omission cross-reference.
- **Provenance double-check (Plan 01-01 Task 1)**: Re-hashes the live snapshot before any writes, catching stale references immediately.
- **Threat models included per plan**: Even for research-only artifacts, STRIDE registers are present with specific threat → disposition → mitigation triples.

---

## Concerns

### HIGH

1. **Wave-1 parallelism is broken — Plan 03 and Plan 04 cannot run in parallel with Plan 02** (`01-03-omission-and-pitfalls-PLAN.md`, `01-04-coverage-delta-PLAN.md`, RESEARCH.md).

   RESEARCH.md §"Architectural Responsibility Map" and the opening block claim:
   > "Wave 1: Plans 2 + 3 + 4 in parallel (per-class enumeration is independent of omission analysis is independent of coverage delta)"

   This is false. Plan 03 Task 2 explicitly states: *"Extract the slot+state names from Plan 02's `### <ClassName>` table (column 'Slot Name' combined with 'State')"* — a hard read-dependency on Plan 02's enumeration data in DISSECTION.md. Plan 04 Task 2 says: *"Read DISSECTION.md's Active Verification Audit"* — same problem. If the executor launches Plans 02, 03, 04 in parallel as directed, Plans 03 and 04 will either fail (DISSECTION.md's per-class sections / audit table don't exist yet) or produce empty/incorrect output.

   **Fix**: Re-wave. Options: (A) Plan 02 → Wave 1, Plans 03+04 → Wave 2, Plan 05 → Wave 3. Or (B) Keep Wave 1 but make Plans 03/04 explicitly aware: run their write-phase tasks in Wave 1, then reconciliation-phase tasks (03-Task 2, 04-Task 2) in a deferred Wave 1.1 after Plan 02 completes.

2. **Plan 01-01 embeds absolute line-number assumptions into a verbatim document template** (`01-01-dissection-skeleton-PLAN.md` Task 2 action body).

   The Editor-API Touchpoints table hardcodes line numbers (e.g., *"Line 15: EditorInterface.get_editor_settings()"*, *"Line 21: EditorInterface.get_editor_scale()"*). If the user's snapshot differs from the expected 1118-line file (re-download, different ZIP extraction), these line citations will be wrong. Task 1 verifies the SHA match, but the verify checks for this document are structural (`grep -q "EditorInterface.get_editor_scale"`), not line-number-correctness checks. The string "EditorInterface.get_editor_scale" could appear anywhere in the doc and pass verification even if the cited line number is wrong.

   **Fix**: Either (A) don't pre-populate line numbers — have the executor grep for them at runtime and substitute, or (B) add a verification step after Task 2 that grep-checks at least 3 random line citations against the live file (e.g., `sed -n '21p' minimal_theme.tres | grep -q "EditorInterface.get_editor_scale"`).

### MEDIUM

3. **Plan 01-02 verify commands use per-class minimum row counts that could false-fail on minimally-themed classes** (`01-02-per-control-enumeration-PLAN.md`, Tasks 2-7).

   Each task's verify block uses a different `≥N` minimum (5 for buttons, 3 for labels, 4 for ranges). If upstream genuinely themes a class with fewer entries than the minimum (e.g., a container class with only 2 constant entries), the verify fails even though the enumeration is correct. The plan acknowledges *"very loose lower bound"* but doesn't handle the case where a class legitimately has 1-2 entries.

   **Fix**: Base minimums on actual `grep -c` output from the discovery command (run the grep first, assert the row count matches that number ±0), or accept 1 as the absolute floor and only warn for count mismatches with discovery grep.

4. **Plan 01-04 Scorecard has 38 rows for a supposed 35-class matrix — double-count risk** (`01-04-coverage-delta-PLAN.md` Task 1 action body).

   The Coverage Scorecard preface says: *"Row count is 38 — 35 FEATURES.md classes + FlatButton (research-only D-10) + HSplitContainer + VSplitContainer (container chrome called out in D-09). FEATURES.md may already include HSplit/VSplit in its 35; verify in Task 2 and reconcile if double-counted."* This means the scorecard may overcount by 2 if HSplit/VSplit are already in FEATURES.md's 35. Task 2 addresses this, but Task 2 is gated on Plan 02's audit, which is the Wave-1 parallelism problem from Concern 1.

   **Fix**: Read FEATURES.md at plan-prep time (not just at runtime) and pre-classify HSplit/VSplit into one bucket. The ambiguity is resolvable by reading the existing file — no need to defer it to Task 2.

5. **Plan 01-03 engine-source anchor may be uncertain** (`01-03-omission-and-pitfalls-PLAN.md` Task 1).

   The `git log -1` command may fail if the godot-master directory isn't a git repo. The plan handles this with a fallback to `stat -c %y` or `ls -la`, but a non-git directory mtime doesn't pin the engine version at all — it could be an arbitrary date. If the clone is pre-4.6, omission flags from `default_theme.cpp` will be wrong for NeoCade's actual target (Godot 4.6). The caveat note is present, but the downstream impact is that Phase 4 might build its generator from incomplete slot lists.

   **Fix**: Make the engine-source anchor check mandatory — if not a git repo, require the user to run `git clone --depth 1 --branch 4.6-stable` before proceeding. OR accept the mtime but add a task to the caveat: "Before Phase 4, re-verify omission flags against tagged 4.6-stable release."

6. **Globals section in DISSECTION.md references `scale` but NeoCade forgoes EDSCALE** (Plan 01-01 Task 2 document body, Globals table).

   The Margins/Spacing table lists `scale` as `EditorInterface.get_editor_scale()` (line 21, D-05 forbidden). The Editor-API Touchpoints callout warns against this, but the Globals table itself doesn't mark `scale` as forbidden/upstream-only. A reader scrolling from Globals → per-class tables might see `popup_margin = maxf(base_margin * 2.4, 4.0 * scale)` and think "scale" is a NeoCade-usable convention.

   **Fix**: Add a `> NeoCade note` callout on the `scale` row in the Globals table: "EDSCALE-derived; forbidden in NeoCade per D-05."

### LOW

7. **Plan 01-02 Task 7 references `scene/gui/popup.cpp` and `scene/main/window.cpp` for Pitfall 1.7 engine evidence** — these filenames may differ in Godot 4.x (e.g., Popup logic merged into `popup_menu.cpp`, Window at `scene/main/window.cpp`). The grep has `2>/dev/null` so it won't crash, but if files aren't found the pitfall evidence will be weaker (relying on `theme_db.cpp` only).

8. **The `<interfaces>` blocks in multiple plans embed `head -20` or `head -30` in grep commands** — if relevant lines fall outside the first 20/30 matches, evidence is missed. Acceptable for initial discovery, but the pitfall sections should eventually read the full function bodies, not just early lines.

9. **Plan 01-05 EDIT 1 inserts a large block between two existing bullets in SOURCES.md** — the `old_string` matched is the entire "- **NOT read in initial pass:**" bullet text. If SOURCES.md has been edited since the plan was authored (e.g., format change, additional bullets), the exact match will fail and the edit will cascade-fail. The plan's Task 1 `read_first` includes reading Section 1 to verify current state, which mitigates this.

10. **Plan 01-02 Task 8's empty-section check awk script has a subtle bug**: the pattern `/^### [A-Z]/` won't match `### User-facing container chrome` (which has the word "User-facing" starting with uppercase). The `[A-Z]` character class only matches the first character, so `### User-facing...` would match `U` and trigger a false "empty section" check on the previous section. However, since container chrome is a single section and its heading starts with `### U`, it should still match the pattern correctly.

---

## Dependency Graph (corrected)

The stated graph (from RESEARCH.md):

```
01 (Wave 0) → [02, 03, 04] (Wave 1, parallel) → 05 (Wave 2)
```

Actual dependencies (what the task bodies reveal):

```
01 (Wave 0)
  ↓
02 (Wave 1 — enumeration data created in DISSECTION.md)
  ↓
03 (Wave 2 — reads 02's per-class tables for slot diff; also reads 02's audit for classification)
04 (Wave 2 — reads 02's audit table for HSplit/VSplit reconciliation)
  ↓
05 (Wave 3 — reads all DISSECTION.md + COVERAGE-DELTA.md)
```

The minimum fix: keep the file-level deliverables as described but reorder execution to **02 → 03 → 04 → 05** sequentially (or 02 → [03, 04] in parallel within Wave 2, then 05 in Wave 3). Plan 02's tasks internally can be parallelized (tasks 2-7 enumerate different Control groups), but Plan 03 and 04 must not start before Plan 02 finishes.

---

## Recommendations

1. **Re-wave immediately**: Change the wave ordering to `01 (Wave 0) → 02 (Wave 1) → 03, 04 (Wave 2) → 05 (Wave 3)`. Update RESEARCH.md and each plan's `depends_on` field. Plan 03 should add `depends_on: [01, 02]`. Plan 04 should add `depends_on: [01, 02]`.

2. **Make line-number citations runtime-verified**: Add a step to Plan 01-01 Task 2's verify block that grep-confirms at least 5 random Editor-API line claims against the live snapshot. Example:
   ```bash
   sed -n '21p' minimal_theme.tres | grep -q "EditorInterface.get_editor_scale"
   ```

3. **Read FEATURES.md at plan-authoring time for Plan 01-04**: Pre-resolve the HSplitContainer/VSplitContainer membership question by checking whether they're in the 35-class matrix now, rather than deferring to Task 2.

4. **Drop minimum-row-count verify checks in Plan 01-02**: Replace `test "$n" -ge N` with a dynamic check: run the per-class discovery grep FIRST, count the lines, then assert the enumeration row count equals that number. This eliminates the false-fail risk.

5. **Add runbook for missing engine source**: If `C:\Programming_Files\Godot\godot-master\scene\theme\default_theme.cpp` doesn't exist when Plan 03 executes, the plan should specify a fallback (flag the omission cross-reference as "pending engine source availability" rather than aborting the entire phase).

---

## Risk Assessment: MEDIUM

**Justification**: The plans are individually well-specified and would produce correct outputs if executed in the correct order. The Wave-1 parallelism bug (Concern #1) is the primary risk — it would cause execution crashes if the executor naively follows the RESEARCH.md wave schedule. The line-number-hardcoding risk (Concern #2) is real but partially mitigated by provenance verification. The re-waving fix is trivial (update `depends_on` arrays and reconsider the wave table). No plan contradicts any D-decision. All five ROADMAP success criteria are covered by at least one plan. Once re-waved, the plans are ready for execution.

---

## Consensus Summary

Single reviewer (OpenCode + DeepSeek V4 Pro). No cross-reviewer consensus to synthesize.

### Top Concerns (priority order)

1. **HIGH — Wave-1 parallelism bug**: RESEARCH.md declares Plans 02/03/04 parallel-eligible, but Plans 03 and 04 have hard read-dependencies on Plan 02's DISSECTION.md output. Re-wave to `01 → 02 → [03, 04] → 05`.
2. **HIGH — Hardcoded line citations in Plan 01-01**: Editor-API Touchpoints table has baked-in line numbers (e.g., line 21 = `get_editor_scale()`); SHA check verifies file integrity but not line-number correctness. Add runtime line-citation grep validation.
3. **MEDIUM — Plan 01-02 minimum row counts can false-fail** legitimately-low-entry classes; replace static minimums with dynamic discovery-grep equality assertions.
4. **MEDIUM — Plan 01-04 Scorecard 38-row vs 35-class double-count risk** for HSplit/VSplit; resolve at plan-prep time by reading FEATURES.md, not at Task 2 runtime.
5. **MEDIUM — Plan 01-03 engine-source provenance** when godot-master directory isn't a git repo; mtime doesn't pin engine version. Mandate `git clone --branch 4.6-stable` or flag downstream Phase 4 dependency.
6. **MEDIUM — DISSECTION.md Globals table** lists `scale` (EDSCALE-derived) without forbidden-in-NeoCade callout; risks confusing readers per D-05.

### Agreed Strengths (single reviewer)

- Complete D-01..D-15 decision coverage
- Clean three-file split per D-14/D-15
- Grep-verifiable acceptance criteria across all five plans
- Active-verification audit re-surveys 80-class surface (Plan 01-02 Task 1)
- Per-plan STRIDE threat models even for research-only artifacts

### Divergent Views

N/A — single reviewer.

---

## How to Incorporate

To feed this review back into planning:

```
/gsd-plan-phase 1 --reviews
```

This re-runs plan generation with the REVIEWS.md feedback loaded as context. The convergence wrapper `/gsd-plan-review-convergence 1 --opencode` will auto-iterate until HIGH concerns are resolved or `max-cycles=3` is hit.
