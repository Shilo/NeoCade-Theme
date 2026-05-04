# Phase 1: Source-Dive — godot-minimal-theme `.tres` Dissection - Discussion Log

> **Audit trail only.** Do not use as input to planning, research, or execution agents.
> Decisions are captured in CONTEXT.md — this log preserves the alternatives considered.

**Date:** 2026-05-04
**Phase:** 1-Source-Dive — godot-minimal-theme `.tres` Dissection
**Areas discussed:** Canonical source artifact, Enumeration scope, State combination depth, Output structure

---

## Canonical source artifact

### Q1: Which `.tres` is THE benchmark for Phase 1's enumeration?

| Option | Description | Selected |
|--------|-------------|----------|
| Upstream repo only (Recommended) | passivestar/godot-minimal-theme `default_theme.tres` from main branch. Pinned to a specific commit SHA in SOURCES.md for reproducibility. Cleanest, smallest scope. | ✓ |
| Godot 4.6 bundled "Modern" theme only | What ships in Godot 4.6 stable as the default editor theme — the productized port. Closer to "what consumers see today", but comes pre-tuned with EDSCALE adjustments and may have engine-internal types we don't care about. | |
| Both — dissect upstream + diff vs 4.6 bundled | Full dissection of the upstream `.tres` AND a diff section noting what the 4.6 port changed. Most exhaustive. Adds ~30-50% effort. | |

**User's choice:** Upstream repo only (Recommended)
**Notes:** Diff against the 4.6 productized port deferred to a future spike if it turns out to matter.

### Q2: How should we acquire the upstream `.tres` for dissection?

| Option | Description | Selected |
|--------|-------------|----------|
| Local clone under `C:\Programming_Files\` (Recommended) | `git clone` to `C:\Programming_Files\godot-minimal-theme\`. Pin commit SHA in SOURCES.md. | |
| WebFetch raw `.tres` only | Pull the single file via WebFetch from a pinned-SHA raw.githubusercontent.com URL. | |
| Vendor a snapshot into `.planning/research/upstream/` | Copy the `.tres` into our repo for fully-self-contained dissection. | |
| **Other (user-supplied)** | User had already downloaded the ZIP to `C:\Programming_Files\Godot\godot-minimal-theme-main\`. Use that. Dissection target: `minimal_theme.tres` (1118 lines). | ✓ |

**User's choice:** Use the existing local snapshot at `C:\Programming_Files\Godot\godot-minimal-theme-main\`
**Notes:** Since this is a ZIP download (no git clone), provenance pinning is by SHA-256 hash + file size + line count + download date — not commit SHA.

### Q3: Upstream's `.tres` is a `@tool extends Theme` script that derives values from EditorSettings at runtime. How should we extract concrete numeric values for state transforms?

| Option | Description | Selected |
|--------|-------------|----------|
| Reverse-engineer the GDScript formulas (Recommended) | Read `_init()` line-by-line and document the formulas symbolically. Pair with one concrete instantiation at default editor settings for verification. | ✓ |
| Run the script in Godot, capture output values | Open the theme in a real Godot 4.6 editor, dump resolved theme entries to JSON. Captures only one snapshot. | |
| Both: formulas + verified snapshot | Document formulas symbolically AND run the script for one concrete realization. ~25% extra effort. | |

**User's choice:** Reverse-engineer the GDScript formulas (Recommended)
**Notes:** Critical reuse constraint surfaced — NeoCade itself MUST NOT touch `EditorSettings` / `EditorInterface` (runtime-first, must work on all 6 export targets in shipped games). Upstream's editor-bound script is **inspiration only**, never ported. User also pointed to `C:\Programming_Files\Godot\godot-master\` (Godot source) as additional cross-reference, and explicitly required NeoCade use its own custom palette and styles, not Godot's.

---

## Enumeration scope

### Q1: Which Controls should the dissection enumerate?

| Option | Description | Selected |
|--------|-------------|----------|
| 27 themed-by-upstream + delta list of 8 NeoCade-additives (Recommended) | Enumerate all 27 classes upstream actually themes. Document the 8 NeoCade-additives separately as a coverage delta with the note "no upstream benchmark exists — NeoCade owns the design." | ✓ (extended) |
| 27 only — don't even mention the 8 additives | Strictly dissect what's in the file. NeoCade-additive scope is FEATURES.md's job. | |
| 27 + editor-only types catalog | Catalog upstream's editor-only theme types too as a v1.x reference inventory. | |

**User's choice:** Option (a) **plus active grep-verification step** — "27 themed-by-upstream + delta list of 8 NeoCade-additives + research to make sure you didn't miss anything else. it should disect everything."
**Notes:** "Exhaustive" verbatim — every entry, every formula, every icon, every constant; no abbreviation. Active verification step required to confirm no class was missed beyond initial keyword survey.

### Q2: Should the dissection also catalog upstream's editor-only theme types (FlatButton, MainScreenButton, BottomPanelButton, EditorInspectorCategory, etc.)?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — catalog as v1.x reference inventory (Recommended) | All editor-only types catalogued as v1.x reference, marked clearly out of v1 scope. | |
| No — user-facing only | Strict separation: v1 doesn't theme editor-only types, Phase 1 doesn't catalog them either. | ✓ (with FlatButton exception) |
| Catalog names only, not entries | List which editor-only types upstream styles (and theme slots) but no formulas/values. | |

**User's choice:** "no, user facing only, but you can dissect FlatButton as this may be relevant to having a variation button in our theme, im unsure. do it for research purposes."
**Notes:** FlatButton is the explicit exception — editor-only in upstream, but NeoCade reuses the name as a Button type variation per FEATURES.md TYPEVAR-01. Skip MainScreenButton, BottomPanelButton, EditorInspectorCategory, and all other editor-only types.

---

## State combination depth

### Q1: Godot supports state combinations (e.g., `hover_pressed`, `pressed_focus`, `checked`, `checked_disabled`, `cursor_unfocused`) on top of primary states. How deep should the dissection capture upstream's state coverage?

| Option | Description | Selected |
|--------|-------------|----------|
| All states upstream actually populates, including combinations (Recommended) | Document every state slot upstream sets, however unusual. Aligns with "dissect everything." | ✓ |
| Primary 5 only (normal/hover/pressed/focused/disabled) | Stop at the primary state set. Faster, but loses per-class state-combination intel. | |
| Primary 5 + flag combinations as "NOT POPULATED" or "POPULATED — see X" | Document primary 5 fully; flag presence/absence per class for combinations. | |

**User's choice:** All states upstream actually populates, including combinations (Recommended)

### Q2: Should the dissection also flag state slots Godot's API supports but upstream chose NOT to populate (e.g., 'CheckBox.checked_focus exists in default_theme.cpp but upstream leaves it unset')?

| Option | Description | Selected |
|--------|-------------|----------|
| Yes — flag both populated AND deliberate-omission (Recommended) | Documents upstream's design choices, not just its data. Cross-referenced against `scene/theme/default_theme.cpp`. | ✓ |
| No — just document what's populated | Strict "enumerate the file" approach. | |
| Flag omissions only for focus-related slots (focus_*, *_focus) | Targeted: capture the omission signal where it matters most. | |

**User's choice:** Yes — flag both populated AND deliberate-omission (Recommended)
**Notes:** Pitfall 1.1 (focus is OVERLAY, loses to pressed/checked) and Pitfall 1.7 (popup separate-Window) each get an explicit confirmation/refutation section in the dissection doc.

---

## Output structure

### Q1: Where does Phase 1's dissection output live?

| Option | Description | Selected |
|--------|-------------|----------|
| Three-file split: dissection doc + coverage delta doc + SOURCES.md update (Recommended) | Pure-enumeration `MINIMAL-THEME-DISSECTION.md` + `MINIMAL-THEME-COVERAGE-DELTA.md` + SOURCES.md Section 1 summary block + adopt/reject synthesis. | ✓ |
| Single dissection doc + SOURCES.md inline summary | One `MINIMAL-THEME-DISSECTION.md` with both enumeration AND coverage-delta sections in it. | |
| Everything inline in SOURCES.md | Append the entire dissection as a giant new section inside SOURCES.md. | |

**User's choice:** Three-file split: dissection doc + coverage delta doc + SOURCES.md update (Recommended)

### Q2: How should the dissection doc separate description from analysis?

| Option | Description | Selected |
|--------|-------------|----------|
| Dissection = pure enumeration; SOURCES.md update = analytical synthesis (Recommended) | `MINIMAL-THEME-DISSECTION.md` stays descriptive; SOURCES.md Section 1 carries the "what we adopt / reject / keep open" synthesis. | ✓ |
| Dissection doc has both per-Control: 'data' + 'NeoCade should adopt/reject' callouts | Each Control section ends with a "NeoCade implications" subsection. | |
| Dissection has flag-only callouts ('see SOURCES.md Section 1 for adoption status') | Inline pointers without duplication. | |

**User's choice:** Dissection = pure enumeration; SOURCES.md update = analytical synthesis (Recommended)
**Notes:** Coverage delta doc carries the 27-vs-35 + additives analysis. Clean separation — enumeration is reusable forever; synthesis decisions evolve as design evolves.

---

## Claude's Discretion

- Exact table layout / column ordering for per-Control entry enumerations.
- Choice of grep + manual reading vs. a one-shot parse helper script for enumeration (both acceptable; output is human-readable Markdown either way).
- Order in which Controls are dissected (alphabetical / importance / category-grouped).
- Whether to include a glossary / legend section explaining Godot Theme entry-slot terminology at the top of the dissection doc.
- Specific provenance fields beyond path + size + SHA-256 hash + line count + date (e.g., whether to include line-count-by-section breakdown).

## Deferred Ideas

- **Diff against Godot 4.6 bundled "Modern" editor theme** — open per SOURCES.md but not in Phase 1 scope.
- **Editor-only theme types catalog** (MainScreenButton, BottomPanelButton, EditorInspectorCategory, EditorProperty, etc.) — out of scope per user's "user-facing only" decision.
- **Run upstream's script in a real Godot 4.6 editor and dump resolved theme entries to JSON** — methodology option B; not chosen (formulas more useful), but a quick add if Phase 4 token-design or Phase 10 COV-10 wants a concrete value comparison.
- **Mine upstream's icon set as a NeoCade icon-design starting point** — out of scope for Phase 1 (we enumerate icon REFERENCES, not visual design); NeoCade's bespoke icons are designed independently in Phase 4.
