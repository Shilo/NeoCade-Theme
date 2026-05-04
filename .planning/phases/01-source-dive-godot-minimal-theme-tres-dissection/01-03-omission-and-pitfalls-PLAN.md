---
phase: 01-source-dive-godot-minimal-theme-tres-dissection
plan: 03
type: execute
wave: 1
depends_on:
  - 01
files_modified:
  - .planning/research/MINIMAL-THEME-DISSECTION.md
autonomous: true
requirements:
  - RES-01
must_haves:
  truths:
    - "MINIMAL-THEME-DISSECTION.md `## Engine-Default Cross-Reference and Pitfall Confirmations` section is populated with: (a) cross-reference to scene/theme/default_theme.cpp recording the godot-master commit consulted, (b) per-Control omission flags listing slots upstream did NOT populate that the engine declares, (c) Pitfall 1.1 confirmation/refutation section, (d) Pitfall 1.7 confirmation/refutation section."
    - "Both pitfall sections cite source-line evidence — engine source lines for the behavior claim AND minimal_theme.tres lines for upstream's response to that behavior."
    - "Pitfall 1.1 conclusion correctly distinguishes engine behavior (focus is overlay drawing) from theme response (upstream populates `pressed_focus` / `checked_focus` because that's the only way to render focus when also pressed/checked)."
    - "Pitfall 1.7 conclusion correctly distinguishes resource-level theming (where upstream DOES set type-level entries for popup classes) from runtime override-bag inheritance (where popups DO NOT inherit because they're separate Windows)."
  artifacts:
    - .planning/research/MINIMAL-THEME-DISSECTION.md (Engine-Default + Pitfalls section appended)
  key_links:
    - "Engine cross-reference cites the actual godot-master commit SHA via `git -C <godot-master> log -1 --format=%H` (or notes that the user's clone is not a git repo and uses a directory listing as proxy)"
    - "Pitfall 1.1 references both `scene/gui/base_button.cpp` (behavior) and the populated `pressed_focus`/`checked_focus` rows from Plan 02's Button section (response)"
    - "Pitfall 1.7 references `scene/theme/theme_db.cpp` (lookup logic) and the populated PopupMenu/PopupPanel/AcceptDialog/TooltipPanel/Window rows from Plan 02 (resource-level coverage)"
---

<objective>
Append the engine-default cross-reference + Pitfall 1.1/1.7 confirmation/refutation block to `MINIMAL-THEME-DISSECTION.md` (under the `## Engine-Default Cross-Reference and Pitfall Confirmations` placeholder created by Plan 01). For each user-facing Control enumerated in Plan 02, identify the slots `default_theme.cpp` declares but upstream chose not to populate. Then write two pitfall confirmation sections that cite both engine-source evidence (the *behavior* claim) and `.tres`-enumeration evidence (upstream's *response* to the behavior).

Purpose: (1) Discharge CONTEXT.md D-12 — flag deliberate omissions, not just enumerated populations. (2) Discharge CONTEXT.md D-13 — confirm or refute Pitfall 1.1 (focus stylebox is overlay, loses to pressed/checked) and Pitfall 1.7 (popup separate-Window theming) directly from the data. The reasoning must distinguish *engine behavior* from *theme response* per RESEARCH.md Pitfalls 3 and 4.

Output: Two appended subsections under `## Engine-Default Cross-Reference and Pitfall Confirmations`:
  - `### Engine-Default Cross-Reference` — per-Control omission tables citing `default_theme.cpp` line numbers
  - `### Pitfall 1.1 — Focus Stylebox Overlay Behavior (Confirmation)`
  - `### Pitfall 1.7 — Popup Separate-Window Theming (Confirmation)`
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
@.planning/research/PITFALLS.md (Pitfall 1.1 + 1.7 framing)

<interfaces>
<!-- Engine source paths -->
- `/c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp` — canonical reference for which entries each Control declares
- `/c/Programming_Files/Godot/godot-master/scene/theme/theme_db.cpp` — theme registration / fallback resolution; relevant for Pitfall 1.7 confirmation
- `/c/Programming_Files/Godot/godot-master/scene/gui/base_button.cpp` — Button base behavior; relevant for Pitfall 1.1 (focus-as-overlay) confirmation

<!-- Per-Control engine-default extraction commands -->
For each user-facing Control enumerated in Plan 02, run:
```bash
grep -nE "theme->set_(stylebox|color|font|icon|constant|font_size)\([^,]+, [\"']<ClassName>[\"']" \
  /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp
```
This yields the canonical slot list the engine declares for that Control. Compare against Plan 02's enumeration; any slot in default_theme.cpp NOT in Plan 02's enumeration is a deliberate upstream omission per D-12.

<!-- Engine-source reference commit anchoring -->
Record the engine-source-commit anchor:
```bash
cd /c/Programming_Files/Godot/godot-master && \
  (git log -1 --format='%H %ad' --date=iso-strict 2>/dev/null || echo "NOT-A-GIT-REPO; using directory mtime: $(stat -c %y /c/Programming_Files/Godot/godot-master 2>/dev/null || ls -la /c/Programming_Files/Godot/godot-master | head -2)")
```
Embed the result in the cross-reference subsection so a future re-verification can pin against the same engine source.

<!-- Pitfall 1.1 framing (RESEARCH.md Pitfall 3) -->
Pitfall 1.1 reads: "focus stylebox is overlay, loses to pressed/checked". The naive interpretation says upstream "fixed" this by populating focus alongside pressed_focus. Correct interpretation: focus-as-overlay is *engine behavior* in `scene/gui/base_button.cpp` draw logic (focus is drawn ON TOP of the state stylebox, not as a state in its own right). Upstream populates `pressed_focus`/`checked_focus` *because the engine demands those composite-state slots when also pressed/checked*. Therefore Pitfall 1.1 is **CONFIRMED** (engine behavior is what the pitfall describes), and upstream's *response* is to populate composite-state slots — that's the design implication for NeoCade.

<!-- Pitfall 1.7 framing (RESEARCH.md Pitfall 4) -->
Pitfall 1.7 reads: "popups need first-class type theming because they are separate Windows that don't inherit theme overrides." Two layers:
  - Layer A: theme-resource type-level entries (e.g., `set_stylebox('panel', 'PopupMenu', sb)`). These DO apply because `theme_db.cpp` looks up the popup's type when no override is set.
  - Layer B: per-Control runtime override-bag overrides (e.g., `popup.add_theme_stylebox_override('panel', sb)`). These DO NOT inherit from the parent because popups are separate Windows.

  Upstream's evidence (Plan 02's PopupMenu/PopupPanel/AcceptDialog/TooltipPanel/Window sections show populated entries) addresses Layer A — confirming the pitfall's PRESCRIPTION is correct ("first-class type theming"). The pitfall's CLAIM about separate Windows not inheriting overrides at runtime is confirmed by `theme_db.cpp` lookup logic, not by enumeration data.

  Therefore Pitfall 1.7 is **CONFIRMED**, and upstream's *response* is the prescription to populate type-level entries for every popup class — exactly NeoCade's coverage strategy.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Anchor the engine-source reference commit and write the `### Engine-Default Cross-Reference` subsection header + provenance</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp (existence verification — first 5 lines for the engine-version comment)
    - /c/Programming_Files/Godot/godot-master/.git/HEAD (existence — to decide whether `git log` works)
    - .planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md (D-06: engine source cross-reference)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (under `## Engine-Default Cross-Reference and Pitfall Confirmations`)</files>
  <action>
    Run the engine-source-anchor command:
    ```bash
    cd /c/Programming_Files/Godot/godot-master && \
      (git log -1 --format='%H %ad' --date=iso-strict 2>/dev/null || echo "NOT-A-GIT-REPO; using directory mtime: $(stat -c %y /c/Programming_Files/Godot/godot-master 2>/dev/null)")
    ```

    If a SHA is returned: cite it. If "NOT-A-GIT-REPO": flag that the cross-reference is anchored to the local snapshot's directory mtime, not a git commit, and recommend a future re-verification against an actual `godotengine/godot` 4.6 release tag.

    Append (immediately under `## Engine-Default Cross-Reference and Pitfall Confirmations`):

    ```markdown
    ### Engine-Default Cross-Reference

    > **Purpose:** For every user-facing Control enumerated in `## Per-Control Enumeration`, this subsection identifies slots that `scene/theme/default_theme.cpp` declares but upstream chose NOT to populate. These are deliberate upstream omissions (per CONTEXT.md D-12). NeoCade may either follow upstream's omission or populate the slot — but the choice is documented here, not silently propagated.

    **Engine-source anchor:**
    - Path: `/c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp`
    - Anchor: [SHA + iso date if git, OR directory mtime + caveat]
    - Caveat: If the user's clone is older than Godot 4.6 release, some entries upstream sets may not yet exist in this `default_theme.cpp` snapshot. Re-verify against `godotengine/godot` tag `4.6-stable` before relying on this section for downstream Phase 4 generator decisions.

    **Methodology:** For each Control class, ran:
    ```bash
    grep -nE 'theme->set_(stylebox|color|font|icon|constant|font_size)\([^,]+, ["'\'']<Class>["'\'']' \
      /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp
    ```
    Compared the returned slot set to Plan 02's `### <Class>` enumeration. Slots in default_theme.cpp NOT in Plan 02's table = upstream omission (flagged below). Slots in upstream NOT in default_theme.cpp = upstream-orphaned (rare but flagged when found).
    ```
  </action>
  <verify>
    ```bash
    grep -q "^### Engine-Default Cross-Reference" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Engine-source anchor:" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -qE "(SHA|NOT-A-GIT-REPO|directory mtime)" .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    Subsection header present, engine-source anchor recorded (git SHA OR mtime+caveat), methodology paragraph greppable.
  </done>
  <acceptance_criteria>
    - File contains `### Engine-Default Cross-Reference` heading
    - File contains the literal string `Engine-source anchor:`
    - File contains either a 40-character hex SHA OR the literal string `NOT-A-GIT-REPO` OR the literal string `directory mtime` (one of the three forms produced by the anchor command)
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 2: Per-Control omission tables — for every class enumerated in Plan 02, append the `default_theme.cpp` slot diff</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp (run per-class greps; this file is large but well-keyed by class name)
    - .planning/research/MINIMAL-THEME-DISSECTION.md (Plan 02's `## Per-Control Enumeration` block — extract each `### ClassName`'s populated slot list)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append per-Control omission tables under `### Engine-Default Cross-Reference`)</files>
  <action>
    For each user-facing Control enumerated in Plan 02 (the same 27 + FlatButton list, minus container chrome which has minimal slots):

    1. Run the engine-default discovery grep:
       ```bash
       grep -nE "theme->set_(stylebox|color|font|icon|constant|font_size)\([^,]+, [\"']<ClassName>[\"']" \
         /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp
       ```

    2. Extract the slot names from `default_theme.cpp` output (the first quoted argument).

    3. Extract the slot+state names from Plan 02's `### <ClassName>` table (column "Slot Name" combined with "State").

    4. Compute the diff: which engine-default slots are NOT present in Plan 02's enumeration? Those are upstream omissions.

    5. Append a per-class omission table:

       ```markdown
       #### <ClassName> — omitted slots

       | Slot kind | Slot name | State | default_theme.cpp line | Upstream behavior | Implication for NeoCade |
       |-----------|-----------|-------|------------------------|-------------------|-------------------------|
       | stylebox  | normal_mirrored | normal | 1234 | Not set by upstream — engine fallback used | NeoCade can populate or follow upstream's omission. If RTL support matters → populate. |
       ```

       The "Upstream behavior" column always reads "Not set by upstream — engine fallback used" (this is the definition of the diff). The "Implication for NeoCade" column is the practical guidance: usually "follow upstream — engine default suffices for normal use" or "populate — affects accessibility / RTL / mobile".

    6. If a Control has zero omissions (upstream covers everything default_theme.cpp declares), write a single line: `> All engine-declared slots populated by upstream.`

    7. If a Control has upstream-orphaned slots (set by upstream but not declared in default_theme.cpp — possibly stale slots from older Godot versions), append a separate `#### <ClassName> — upstream-orphaned slots` table flagging them.
  </action>
  <verify>
    ```bash
    # At least 20 `#### ClassName — omitted slots` headings (some classes may have zero omissions, yielding the "All engine-declared slots populated" form instead — counted via either pattern)
    n=$(grep -cE "^#### [A-Z][a-zA-Z]+ — (omitted slots|upstream-orphaned slots)" .planning/research/MINIMAL-THEME-DISSECTION.md)
    full=$(grep -c "All engine-declared slots populated by upstream" .planning/research/MINIMAL-THEME-DISSECTION.md)
    test $((n + full)) -ge 20 || { echo "Only $((n+full)) omission/full entries; expected ≥20"; exit 1; }
    ```
  </verify>
  <done>
    At least 20 per-Control omission outcomes recorded (either omitted-slots tables or "all populated" notes).
  </done>
  <acceptance_criteria>
    - Either: ≥20 `#### ClassName — omitted slots` headings present
    - Or: combined count of `#### ClassName — omitted slots` headings + `All engine-declared slots populated by upstream` lines is ≥20
    - For at least one Control, an explicit example "Implication for NeoCade" cell is present (greppable as `Implication for NeoCade`)
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 3: Pitfall 1.1 (focus stylebox overlay) — confirmation/refutation section with engine + theme evidence</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-master/scene/gui/base_button.cpp (focus draw logic; grep for `focus_stylebox`, `_draw_focus`, `RID focus`)
    - .planning/research/PITFALLS.md (Pitfall 1.1 framing)
    - .planning/research/MINIMAL-THEME-DISSECTION.md `### Button` and `### CheckBox` (Plan 02 enumerations — `pressed_focus`, `checked_focus` rows are the *response* evidence)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### Pitfall 1.1 — Focus Stylebox Overlay Behavior (Confirmation)` under `## Engine-Default Cross-Reference and Pitfall Confirmations`, after the Engine-Default Cross-Reference subsection)</files>
  <action>
    1. Find focus draw logic in `base_button.cpp`:
       ```bash
       grep -nE "focus_stylebox|focus.*draw|draw.*focus" /c/Programming_Files/Godot/godot-master/scene/gui/base_button.cpp | head -20
       ```
       Capture the line number(s) showing focus is drawn AS AN OVERLAY (drawn after the state stylebox, not as a state itself).

    2. Find Button-related composite state styleboxes in `default_theme.cpp`:
       ```bash
       grep -nE "theme->set_stylebox.*['\"](pressed_focus|hover_pressed|checked_focus)['\"]" \
         /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp
       ```
       Capture line numbers.

    3. Find populated composite-state styleboxes in upstream:
       ```bash
       grep -nE "set_stylebox\('(pressed_focus|hover_pressed|checked_focus)'" \
         /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
       ```

    4. Append:

       ```markdown
       ### Pitfall 1.1 — Focus Stylebox Overlay Behavior (Confirmation)

       **Pitfall claim (PITFALLS.md §1.1):** "Focus stylebox is OVERLAY, not state — loses to pressed/checked. NeoCade must use composite-state slots (pressed_focus, checked_focus) to render focus when also pressed/checked."

       **Engine-source evidence (the *behavior*):**
       - `scene/gui/base_button.cpp` line(s) [N..M] — focus drawing is layered ON TOP of the state stylebox; not a state in its own right.
       - `scene/theme/default_theme.cpp` line(s) [N..M] — composite-state slots `pressed_focus`, `hover_pressed`, `checked_focus` exist precisely because focus-as-overlay would otherwise lose to pressed/checked styling.

       **Theme-resource evidence (upstream's *response*):**
       - `minimal_theme.tres` line(s) [N..M] — upstream sets `pressed_focus`, `checked_focus` for Button-family classes; rows in `### Button` and `### CheckBox` of `## Per-Control Enumeration` above show this populated.

       **Conclusion: Pitfall 1.1 is CONFIRMED.**
       - The *pitfall claim* (focus is overlay, loses to pressed/checked) is engine behavior verified by `base_button.cpp` draw logic.
       - Upstream's *response* (populating composite-state slots) is the design pattern NeoCade must follow per Phase 5's focus-ring design — NOT a refutation of the pitfall.
       - **Implication for NeoCade:** Phase 5 must populate pressed_focus / hover_pressed / checked_focus / radio_checked_focus slots for every focusable Button-family class; relying on `focus` alone leaves the focus invisible when the Control is also pressed or checked.
       ```
  </action>
  <verify>
    ```bash
    grep -q "^### Pitfall 1.1" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Pitfall 1.1 is CONFIRMED" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "base_button.cpp" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "pressed_focus" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Implication for NeoCade:" .planning/research/MINIMAL-THEME-DISSECTION.md
    ```
  </verify>
  <done>
    Pitfall 1.1 section present, conclusion explicit, engine-source + theme-resource evidence both cited with line references.
  </done>
  <acceptance_criteria>
    - File contains `### Pitfall 1.1 — Focus Stylebox Overlay Behavior (Confirmation)` heading
    - File contains literal string `Pitfall 1.1 is CONFIRMED`
    - File contains references to both `base_button.cpp` and `pressed_focus`
    - File contains literal string `Implication for NeoCade:` within the Pitfall 1.1 section
  </acceptance_criteria>
</task>

<task type="auto">
  <name>Task 4: Pitfall 1.7 (popup separate-Window theming) — confirmation/refutation section distinguishing layer A (resource) and layer B (override-bag)</name>
  <read_first>
    - /c/Programming_Files/Godot/godot-master/scene/theme/theme_db.cpp (theme lookup logic; grep for `get_theme_stylebox`, `_get_theme_item`, `Theme` lookup)
    - /c/Programming_Files/Godot/godot-master/scene/main/window.cpp (or `scene/main/viewport.cpp` — Window-as-separate-renderer claim)
    - .planning/research/PITFALLS.md (Pitfall 1.7 framing)
    - .planning/research/MINIMAL-THEME-DISSECTION.md `### PopupMenu`, `### PopupPanel`, `### AcceptDialog`, `### TooltipPanel`, `### Window` (Plan 02 enumerations — populated entries are the layer-A evidence)
  </read_first>
  <files>.planning/research/MINIMAL-THEME-DISSECTION.md (append `### Pitfall 1.7 — Popup Separate-Window Theming (Confirmation)` after the Pitfall 1.1 section)</files>
  <action>
    1. Find theme lookup logic in `theme_db.cpp`:
       ```bash
       grep -nE "get_theme_(stylebox|color|font)|_get_theme_item|class hierarchy lookup" /c/Programming_Files/Godot/godot-master/scene/theme/theme_db.cpp | head -30
       ```
       Capture line numbers showing how type-level theme entries resolve.

    2. Find Window/Popup separate-Window claim in engine source:
       ```bash
       grep -rnE "is_embedded|Popup.*Window|separate.*window" /c/Programming_Files/Godot/godot-master/scene/gui/popup.cpp /c/Programming_Files/Godot/godot-master/scene/main/window.cpp 2>/dev/null | head -10
       ```

    3. Append:

       ```markdown
       ### Pitfall 1.7 — Popup Separate-Window Theming (Confirmation)

       **Pitfall claim (PITFALLS.md §1.7):** "Popups are separate Windows that don't inherit theme overrides. NeoCade must populate type-level theme entries (PopupMenu, PopupPanel, AcceptDialog, FileDialog, ConfirmationDialog, TooltipPanel, Window) — relying on a parent's `add_theme_*_override` won't reach the popup."

       **Two layers of theming (the pitfall is about the second; the prescription is to use the first):**

       **Layer A — Resource-level type entries (DO apply to popups):**
       Theme resources have type-level entries (`set_stylebox('panel', 'PopupMenu', sb)`). When a popup with no override is opened, `theme_db.cpp` looks up the popup's type in the active Theme resource and finds the entry. This is how popups get themed.
       - Engine evidence: `theme_db.cpp` line(s) [N..M] — type-level lookup walks the Theme resource's type-keyed map.
       - Upstream evidence: Plan 02's `### PopupMenu`, `### PopupPanel`, `### AcceptDialog`, `### TooltipPanel`, `### Window` show populated type-level entries (cite specific lines from those sections).

       **Layer B — Per-Control override-bag overrides (DO NOT inherit through popups):**
       When a parent Control calls `parent.add_theme_stylebox_override('panel', sb)`, that override is stored on the parent's per-Control override map. A popup spawned by that parent is a separate Window — it has its own viewport, its own theme lookup chain, and does NOT inherit from the parent's override-bag. So an override applied to the parent does NOT reach the popup.
       - Engine evidence: `scene/gui/popup.cpp` line(s) [N..M] / `scene/main/window.cpp` line(s) [N..M] — popup is a Window subclass; Window has its own theme resolution root.

       **Conclusion: Pitfall 1.7 is CONFIRMED.**
       - The *pitfall claim* (popups don't inherit overrides at runtime) is engine behavior verified by `theme_db.cpp` + `popup.cpp` / `window.cpp`.
       - Upstream's *response* (populating type-level entries for every popup class — Layer A) is the prescription the pitfall recommends. Plan 02's enumeration confirms upstream follows this prescription.
       - **Critical distinction:** This is NOT a refutation. Resource-level type entries (Layer A — what upstream sets and what NeoCade also sets) are not the same as runtime override-bag overrides (Layer B — what fails to inherit). Anyone reading this must understand both layers; conflating them produces broken popup theming.
       - **Implication for NeoCade:** NeoCade's `neocade_theme.tres` MUST populate type-level entries for PopupMenu, PopupPanel, AcceptDialog, FileDialog (NeoCade-additive), ConfirmationDialog (NeoCade-additive), TooltipPanel, TooltipLabel (NeoCade-additive), Window. Phase 6/7 implementations cannot rely on `add_theme_*_override` calls on parent Controls — those don't reach popups.
       ```
  </action>
  <verify>
    ```bash
    grep -q "^### Pitfall 1.7" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Pitfall 1.7 is CONFIRMED" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "theme_db.cpp" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -qE "popup.cpp|window.cpp" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Layer A" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Layer B" .planning/research/MINIMAL-THEME-DISSECTION.md
    grep -q "Implication for NeoCade:" .planning/research/MINIMAL-THEME-DISSECTION.md   # already present from task 3, but task 4 also has its own
    awk '/^### Pitfall 1.7/,/^### |^## /' .planning/research/MINIMAL-THEME-DISSECTION.md | grep -q "Implication for NeoCade:"
    ```
  </verify>
  <done>
    Pitfall 1.7 section present, conclusion explicit, two-layer distinction explicit, both engine and theme evidence cited.
  </done>
  <acceptance_criteria>
    - File contains `### Pitfall 1.7 — Popup Separate-Window Theming (Confirmation)` heading
    - File contains literal string `Pitfall 1.7 is CONFIRMED`
    - File contains references to both `theme_db.cpp` and at least one of `popup.cpp` / `window.cpp`
    - File contains both `Layer A` and `Layer B` literal strings
    - The Pitfall 1.7 section contains its own `Implication for NeoCade:` line (verified by awk-bounded grep, not just a global one — the global grep matches Pitfall 1.1's instance from Task 3)
  </acceptance_criteria>
</task>

</tasks>

<threat_model>
## Trust Boundaries

| Boundary | Description |
|----------|-------------|
| Engine source `default_theme.cpp` snapshot version → omission cross-reference accuracy | If user's local clone is pre-Godot 4.6, some entries may be missing. Mitigation: engine-source anchor (Task 1) records the SHA / mtime so future re-verification can pin against a tagged release. |
| Pitfall framing accuracy → downstream phase decisions | If pitfall confirmation conflates engine behavior with theme response, Phase 5 (focus rings) and Phase 6 (popup theming) will design against an incorrect model. Mitigation: each conclusion explicitly distinguishes "behavior" (engine source cited) from "response" (theme resource cited). |

## STRIDE Threat Register

| Threat ID | Category | Component | Disposition | Mitigation Plan |
|-----------|----------|-----------|-------------|-----------------|
| T-1-07 | Repudiation | Pitfall 1.1 conclusion blurring engine-overlay-behavior with upstream-populates-composite-states | mitigate | RESEARCH.md Pitfall 3 framing is reflected verbatim in task 3's action body; conclusion section explicitly says "is CONFIRMED" with both layers of evidence cited. |
| T-1-08 | Repudiation | Pitfall 1.7 conclusion missing the Layer A / Layer B distinction (treating "upstream populates type entries" as refutation when it's actually the prescription) | mitigate | RESEARCH.md Pitfall 4 framing is reflected verbatim in task 4's action body; "Critical distinction:" callout is mandatory. |
| T-1-09 | Tampering | Engine source clone version drift causing false omission flags (slot exists in 4.6 but not in user's older clone) | mitigate | Engine-source anchor in Task 1 + caveat note instructing future re-verification against tagged release. |
</threat_model>

<verification>
- [ ] All 4 tasks complete; both pitfall sections present
- [ ] Each pitfall section CITES (not paraphrases) source lines from BOTH engine source AND minimal_theme.tres
- [ ] Each pitfall section concludes with explicit "is CONFIRMED" verdict and "Implication for NeoCade:" line
- [ ] Pitfall 1.7 section has explicit Layer A / Layer B distinction
- [ ] Engine-source anchor is recorded (SHA or mtime+caveat)
- [ ] At least 20 per-Control omission outcomes recorded
</verification>

<success_criteria>
- All grep checks across tasks 1-4 pass
- Both pitfalls confirmed (the locked design assumption per CONTEXT.md and PITFALLS.md)
- File reads top-to-bottom: ... Per-Control Enumeration → ## Engine-Default Cross-Reference and Pitfall Confirmations → ### Engine-Default Cross-Reference (per-Control omissions) → ### Pitfall 1.1 → ### Pitfall 1.7
</success_criteria>

<output>
After completion, create `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-03-SUMMARY.md` capturing: engine-source anchor recorded, Pitfall 1.1 conclusion + key evidence lines, Pitfall 1.7 conclusion + key evidence lines, total omission-table count, any unexpected findings (e.g., "Tree.parent_hl_line_color exists in default_theme.cpp 4.6 but not in user's clone — recommend pulling").
</output>
