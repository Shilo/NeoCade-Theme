---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 05
type: execute
wave: 2
depends_on:
  - 01
  - 02
  - 03
  - 04
files_modified:
  - .planning/research/SOURCES.md
autonomous: true
requirements:
  - DOCS-05
  - RES-01
must_haves:
  truths:
    - ".planning/research/SOURCES.md Section 1 (godot-minimal-theme) is updated in place — preserving existing What was read / adopted / rejected / still open / Confidence in coverage structure"
    - "What was read pass-2 entry added — names this dissection's outputs (MINIMAL-THEME-DISSECTION.md, MINIMAL-THEME-COVERAGE-DELTA.md), dated 2026-05-04 (Phase 1 source-dive)"
    - "What we adopted gains a Phase 1 sub-bullet recording adopted patterns (e.g. composite-state slot strategy from Pitfall 1.1 confirmation, popup type-level theming strategy from Pitfall 1.7 confirmation)"
    - "What's still open's previous LOW-confidence entries (Full .tres enumeration; Accent application strategy; Editor-theme-only types' theme entries) are revised — Full .tres enumeration line is removed (resolved by Phase 1); other entries refined or moved to Open Questions if still applicable"
    - "Confidence in coverage line raised from MEDIUM to HIGH for v1, with the explicit basis: Phase 1 dissection completed, 27 user-facing Controls × per-state enumerated, omission cross-reference vs default_theme.cpp captured, Pitfalls 1.1/1.7 confirmed from data"
  artifacts:
    - .planning/research/SOURCES.md (Section 1 updated in place)
  key_links:
    - "Section 1 contains links/references to both new files (MINIMAL-THEME-DISSECTION.md, MINIMAL-THEME-COVERAGE-DELTA.md)"
    - "Other Sections 2-9 of SOURCES.md remain unchanged (only Section 1 modified)"
---

<objective>
Update `.planning/research/SOURCES.md` Section 1 in place with the Phase 1 source-dive synthesis: refresh `What was read` to record pass-2 deep-dive completion, append `What we adopted` Phase 1 entries, refresh `What we rejected` if any new rejections surface from the dissection, REMOVE the resolved "Full `.tres` enumeration" line from `What's still open`, and raise the `Confidence in coverage` from `MEDIUM` to `HIGH`. This is the description-vs-analysis "synthesis" deliverable per CONTEXT.md D-15.

Purpose: Discharge DOCS-05 (continuous SOURCES.md update through source-dive spike outputs) and the RES-01 sub-clause "Findings appended to SOURCES.md." This is the only plan in Phase 1 that touches SOURCES.md; all other plans append to DISSECTION.md or create COVERAGE-DELTA.md.

Output: SOURCES.md Section 1 updated in place. Sections 2-9 untouched.
</objective>

<execution_context>
@$HOME/.claude/get-shit-done/workflows/execute-plan.md
@$HOME/.claude/get-shit-done/templates/summary.md
</execution_context>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/STATE.md
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md
@.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-RESEARCH.md
@.planning/research/SOURCES.md (the file being edited — read existing Section 1 in full before editing so the structure is preserved)
@.planning/research/MINIMAL-THEME-DISSECTION.md (Plan 02 + Plan 03 outputs — for the "What was read pass-2" line and the "What we adopted Phase 1" bullets)
@.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (Plan 04 output — for cross-link)

<interfaces>
<!-- SOURCES.md Section 1 existing structure (verbatim from current file as of 2026-05-04) -->
The current Section 1 has these sub-headings (preserve as-is, only edit content within them):

```
## 1. godot-minimal-theme by passivestar

**Source name + location:**
- Repository: https://github.com/passivestar/godot-minimal-theme
- License: MIT
- Now productized as Godot 4.6's default "Modern" editor theme

**What was read (initial pass, 2026-05-04):**
- README in full ...
- Issue tracker: #19, #8 ...
- License terms (MIT) ...
- **NOT read in initial pass:** the `.tres` file itself line-by-line ...

**What we adopted:**
- Function-as-completeness-benchmark posture ...
- Inter as primary UI font ...
- Corner radius default 4px ...
- High icon saturation discipline ...
- Single-accent dominance pattern ...

**What we rejected:**
- Verbatim numeric values ...
- Single-accent palette ...
- StyleBoxEmpty for transparent slots ...
- #272727 base color ...
- #569eff accent ...
- Editor-only theme types ...

**What's still open:**
- **Full `.tres` enumeration** — what entries are defined per Control × per state ...
- **Accent application strategy** — how does minimal-theme apply its single accent ...
- **Editor-theme-only types' theme entries** — even though we don't theme them in v1 ...
- **Comparison against Godot 4.6's "Modern" editor theme** — minimal-theme was ported ...

**Confidence in coverage:** **MEDIUM** for v1 ...
```

<!-- Edit operations to apply (using Edit tool) -->

EDIT 1: After the "**NOT read in initial pass:**" bullet, INSERT a new sub-block:
```
**What was read (Phase 1 source-dive, 2026-05-04):**
- `minimal_theme.tres` enumerated line-by-line — provenance recorded (SHA-256 `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`, 1118 lines, 48,442 bytes). 27 user-facing Controls × per-state × per-entry tabulated; 80-class active-verification audit; FlatButton dissected as Button TYPEVAR-01 research per CONTEXT.md D-10. See `.planning/research/MINIMAL-THEME-DISSECTION.md`.
- `default_theme.cpp` cross-referenced for engine-declared slots; per-Control omission tables for slots upstream chose NOT to populate.
- `theme_db.cpp` + `base_button.cpp` consulted for Pitfall 1.1 (focus stylebox overlay) and Pitfall 1.7 (popup separate-Window theming) confirmation/refutation; both pitfalls **CONFIRMED** with engine-source + theme-resource evidence cited.
- Coverage delta vs FEATURES.md 35-class matrix computed: 27 themed-in-upstream + 8 NeoCade-additives + FlatButton (research-only) + container-chrome reconciliation. See `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md`.
```

EDIT 2: At the end of the "**What we adopted:**" list, APPEND new bullets:
```
- **Composite-state slot strategy (from Pitfall 1.1 confirmation, Phase 1)** — populating `pressed_focus`, `hover_pressed`, `checked_focus`, `radio_checked_focus` slots is mandatory for visible focus on focusable Controls; relying on bare `focus` slot leaves focus invisible when also pressed/checked (engine behavior, not theme behavior). Phase 5 focus-ring design depends on this.
- **Popup type-level theming as required pattern (from Pitfall 1.7 confirmation, Phase 1)** — every popup class (PopupMenu, PopupPanel, AcceptDialog, FileDialog, ConfirmationDialog, TooltipPanel, TooltipLabel, Window) must have type-level theme-resource entries; runtime `add_theme_*_override` on parents does NOT inherit through popups (separate Windows). NeoCade's coverage strategy aligns with this prescription.
- **7-stop tonal surface ramp pattern documented as reference (Phase 1)** — upstream's 7-stop ramp (`color_surface_lowest..._highest` via `_get_base_color(brightness, sat_mult)`) is the design pattern; NeoCade's M3 5-stop ramp (per ARCHITECTURE.md) is the chosen architecture. Divergence is intentional (M3 is the canonical model adopted in Conflict 2 resolution); the upstream pattern is now research material, not direction.
```

EDIT 3: At the end of the "**What we rejected:**" list, APPEND a new bullet (only if Phase 1 surfaced new rejections — this is the rejection of editor-API patterns):
```
- **`@tool extends Theme` + `EditorInterface.get_editor_settings()` + `EDSCALE` runtime pattern** — D-05 rejection re-confirmed by Phase 1 enumeration. Upstream's GDScript reads 9 `interface/theme/*` editor settings + uses `EditorInterface.get_editor_scale()`. NeoCade's `@tool` token-generator (Phase 4) reads from a hand-authored TokenSet resource, not from EditorSettings — runtime-first; works in shipped games on all 6 export targets. The 13 specific Editor-API touchpoints with line citations are documented in `MINIMAL-THEME-DISSECTION.md` `## Editor-API Touchpoints (Forbidden in NeoCade per D-05)`.
```

EDIT 4: REMOVE the bullet that begins with `**Full `.tres` enumeration**` from "**What's still open:**". (The line is now resolved.)

EDIT 5: REVISE the bullet that begins with `**Accent application strategy**` to: `**Accent application strategy** — partially resolved by Phase 1 enumeration (per-Control accent-using rows are now visible in DISSECTION.md). Synthesizing the cross-class accent pattern into a NeoCade design rule remains Phase 3 mockup-design work. Reduced from "open in initial pass" to "design synthesis pending Phase 3."`

EDIT 6: KEEP the "Editor-theme-only types' theme entries" bullet as-is (still open; deferred to v1.x per `### Active Verification Audit` editor-only bucket in DISSECTION.md).

EDIT 7: KEEP the "Comparison against Godot 4.6's Modern editor theme" bullet as-is (deferred per CONTEXT.md "Deferred Ideas").

EDIT 8: REPLACE the entire "**Confidence in coverage:**" line:
- Old: `**Confidence in coverage:** **MEDIUM** for v1 (README-level claims verified; coverage delta vs FEATURES.md not yet computed). **What would raise it:** Phase 1 source-dive spike that opens the `.tres` and enumerates entries.`
- New: `**Confidence in coverage:** **HIGH** for v1. Phase 1 source-dive (2026-05-04) opened the `.tres` and enumerated every entry per-Control × per-state with line citations; coverage delta vs FEATURES.md 35-class matrix computed; Pitfall 1.1 and Pitfall 1.7 confirmed from data with engine-source + theme-resource evidence. **Remaining uncertainty (LOW-impact):** edge-case Godot version drift between user's local engine clone and Godot 4.6 release tag; recommend re-pinning the omission cross-reference once Godot 4.6 is finalized in user's clone (caveat noted in DISSECTION.md \`### Engine-Default Cross-Reference\`).`
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Apply EDITS 1-8 to SOURCES.md Section 1 in sequence using the Edit tool</name>
  <read_first>
    - .planning/research/SOURCES.md (full Section 1 — verify current state matches `<interfaces>` snapshot before editing; if Section 1 has been updated since this plan was authored, halt and reconcile)
    - .planning/research/MINIMAL-THEME-DISSECTION.md (verify it exists; the SOURCES.md update links to it)
    - .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md (verify it exists; the SOURCES.md update links to it)
  </read_first>
  <files>.planning/research/SOURCES.md</files>
  <action>
    For each EDIT in `<interfaces>`, use the Edit tool with the exact `old_string` from the current Section 1 and the exact `new_string` from the EDIT spec.

    EDIT 1 — INSERT after "NOT read in initial pass" bullet:
    ```
    Edit(file_path=".planning/research/SOURCES.md",
         old_string="- **NOT read in initial pass:** the `.tres` file itself line-by-line; per-Control × per-state entry enumeration; interaction state transforms; accent strategy; how it handles popups; whether it themes `TooltipPanel`/`TooltipLabel`/`Window` etc.",
         new_string="- **NOT read in initial pass:** the `.tres` file itself line-by-line; per-Control × per-state entry enumeration; interaction state transforms; accent strategy; how it handles popups; whether it themes `TooltipPanel`/`TooltipLabel`/`Window` etc.\n\n**What was read (Phase 1 source-dive, 2026-05-04):**\n- `minimal_theme.tres` enumerated line-by-line — provenance recorded (SHA-256 `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`, 1118 lines, 48,442 bytes). 27 user-facing Controls × per-state × per-entry tabulated; 80-class active-verification audit; FlatButton dissected as Button TYPEVAR-01 research per CONTEXT.md D-10. See `.planning/research/MINIMAL-THEME-DISSECTION.md`.\n- `default_theme.cpp` cross-referenced for engine-declared slots; per-Control omission tables for slots upstream chose NOT to populate.\n- `theme_db.cpp` + `base_button.cpp` consulted for Pitfall 1.1 (focus stylebox overlay) and Pitfall 1.7 (popup separate-Window theming) confirmation/refutation; both pitfalls **CONFIRMED** with engine-source + theme-resource evidence cited.\n- Coverage delta vs FEATURES.md 35-class matrix computed: 27 themed-in-upstream + 8 NeoCade-additives + FlatButton (research-only) + container-chrome reconciliation. See `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md`.")
    ```
    (If the executor's environment requires the `old_string` to be a literal substring without surrounding context, use a smaller unique fragment from the line. The above is the form for the Edit tool's exact-match semantic.)

    EDIT 2-8: Apply the remaining edits per `<interfaces>` specs using `old_string` taken verbatim from the current SOURCES.md and `new_string` per the spec.

    NOTE on EDIT 4 (REMOVE the Full `.tres` enumeration bullet):
    ```
    Edit(file_path=".planning/research/SOURCES.md",
         old_string="- **Full `.tres` enumeration** — what entries are defined per Control × per state; what are the actual numeric values of styleboxes; how does interaction state transform per class. **Recommended phase:** Phase 1 source-dive spike (per SUMMARY.md roadmap).\n",
         new_string="")
    ```
    (Empty new_string deletes the line; preserve the surrounding `- **Accent application strategy**` bullet's leading newline.)

    NOTE on EDIT 8 (REPLACE the Confidence in coverage line): the line spans multiple sentences in the current file — use the full sentence as `old_string`:
    ```
    Edit(file_path=".planning/research/SOURCES.md",
         old_string="**Confidence in coverage:** **MEDIUM** for v1 (README-level claims verified; coverage delta vs FEATURES.md not yet computed). **What would raise it:** Phase 1 source-dive spike that opens the `.tres` and enumerates entries.",
         new_string="**Confidence in coverage:** **HIGH** for v1. Phase 1 source-dive (2026-05-04) opened the `.tres` and enumerated every entry per-Control × per-state with line citations; coverage delta vs FEATURES.md 35-class matrix computed; Pitfall 1.1 and Pitfall 1.7 confirmed from data with engine-source + theme-resource evidence. **Remaining uncertainty (LOW-impact):** edge-case Godot version drift between user's local engine clone and Godot 4.6 release tag; recommend re-pinning the omission cross-reference once Godot 4.6 is finalized in user's clone (caveat noted in DISSECTION.md `### Engine-Default Cross-Reference`).")
    ```

    Apply all 8 edits in sequence. After each, re-read the affected portion of SOURCES.md to confirm the edit applied and Section 1's overall structure (5 sub-headings) is preserved.
  </action>
  <verify>
    ```bash
    # Section 1 still has its 5 sub-headings (preserved structure)
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -cE "^\*\*(Source name|What was read|What we adopted|What we rejected|What's still open|Confidence in coverage):" | (read n; test "$n" -ge 5 || { echo "Section 1 has only $n sub-headings; expected ≥5"; exit 1; })

    # Cross-references to new docs present
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -q "MINIMAL-THEME-DISSECTION"
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -q "MINIMAL-THEME-COVERAGE-DELTA"

    # Confidence raised to HIGH
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -q "Confidence in coverage:.*HIGH"

    # Phase 1 source-dive sub-block present
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -q "Phase 1 source-dive"

    # Old "Full .tres enumeration" still-open bullet removed
    ! awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -q "Full \`.tres\` enumeration"

    # Pitfall confirmation references
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -qE "Pitfall 1.1.*[Cc]onfirm"
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -qE "Pitfall 1.7.*[Cc]onfirm"

    # Editor-API rejection bullet
    awk '/^## 1\. godot-minimal-theme/,/^## 2\./' .planning/research/SOURCES.md | grep -q "Editor-API Touchpoints\|EditorInterface.get_editor_settings"

    # Section 2 onward unchanged — sanity check the heading is still there
    grep -q "^## 2\\. LDtk UI docs" .planning/research/SOURCES.md
    ```
  </verify>
  <done>
    All 8 edits applied; Section 1 verifies; Section 2+ unchanged.
  </done>
  <acceptance_criteria>
    - SOURCES.md Section 1 still has its 5 standard sub-headings (Source name, What was read, What we adopted, What we rejected, What's still open, Confidence in coverage)
    - Section 1 contains literal strings `MINIMAL-THEME-DISSECTION` and `MINIMAL-THEME-COVERAGE-DELTA`
    - Section 1's Confidence line contains `HIGH` (not `MEDIUM` for the headline confidence)
    - Section 1 contains the literal string `Phase 1 source-dive`
    - Section 1 does NOT contain the literal string `Full \`.tres\` enumeration` (the resolved still-open bullet is gone)
    - Section 1 contains both `Pitfall 1.1` and `Pitfall 1.7` references with confirmation language
    - Section 2 (`## 2. LDtk UI docs`) heading is still present (the edit didn't accidentally cascade)
  </acceptance_criteria>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| In-place edit of shared research dossier (SOURCES.md) | Risk of cascading edits: an Edit tool call with a non-unique `old_string` could match in Section 2 or beyond and corrupt other sections. Mitigation: every Edit's `old_string` is taken from Section 1 only and is unique within the file (verifiable by `grep -c` before applying); verify checks Section 2's heading is still present. |
| SOURCES.md schema drift | If SOURCES.md schema changes between this plan's authoring and execution (e.g., another phase already touched Section 1), Edit will mismatch. Mitigation: Task 1's `read_first` includes reading Section 1 in full to verify current state matches `<interfaces>` snapshot. |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-1-12 | Tampering | Edit tool's old_string matching outside Section 1 | mitigate | Pre-edit `grep -c "<old_string>" .planning/research/SOURCES.md` check (count must be 1); if >1, halt and re-author the EDIT with disambiguating context. |
| T-1-13 | Denial of service | Section 1 schema corrupted (missing sub-heading) | mitigate | Verify-block awk-bounded grep checks all 5 sub-headings post-edit. |
</threat_model>

<verification>
- [ ] Each EDIT's old_string was unique in SOURCES.md before that edit was applied
- [ ] Section 1 still has its 5 standard sub-headings post-edit
- [ ] Cross-references to MINIMAL-THEME-DISSECTION.md and MINIMAL-THEME-COVERAGE-DELTA.md are present
- [ ] Confidence raised to HIGH
- [ ] Other Sections (2-9) of SOURCES.md untouched (heading sanity check)
</verification>

<success_criteria>
- All grep checks pass
- DOCS-05 satisfied (SOURCES.md updated)
- RES-01 satisfied (findings appended to SOURCES.md, completing the requirement's "Findings appended to SOURCES.md" sub-clause)
</success_criteria>

<output>
After completion, create `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-05-SUMMARY.md` capturing: which 8 edits applied cleanly, any disambiguation required, the final Confidence in coverage value, and the count of cross-references in Section 1 to the new docs.
</output>
