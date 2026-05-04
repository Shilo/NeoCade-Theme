# Phase 1: Source-Dive — godot-minimal-theme `.tres` Dissection — Research

**Researched:** 2026-05-04
**Domain:** Godot 4.x Theme resource format + GDScript-driven theme generation reverse engineering
**Confidence:** HIGH

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

- **D-01:** Upstream repo only (`passivestar/godot-minimal-theme`) is the benchmark. Do NOT diff against Godot 4.6's bundled "Modern" port (deferred).
- **D-02:** Source file: `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres` (1118 lines). Repo root: `C:\Programming_Files\Godot\godot-minimal-theme-main\`.
- **D-03:** Provenance recorded at top of dissection doc: snapshot path + file size + SHA-256 hash + line count + ISO date downloaded. No commit SHA (ZIP download). Hash is the reproducibility anchor.
- **D-04:** Extraction methodology = reverse-engineer GDScript formulas symbolically. Document derivations as expressions (e.g. `Button.normal.bg_color = base_color.lerp(white, 0.05 * contrast)`). Pair each formula with one concrete instantiation at upstream's documented default editor settings (per `README.md`) for verification. Formula is the convention, not any single output.
- **D-05:** Critical reuse constraint: NeoCade itself MUST NOT use `EditorSettings`, `EditorInterface`, or any editor-bound API. Upstream's editor-bound script is **inspiration only**, never ported. The dissection must explicitly flag every editor-API touchpoint upstream uses.
- **D-06:** Cross-reference Godot source at `C:\Programming_Files\Godot\godot-master\`: `scene/theme/default_theme.cpp` (canonical slot reference per Control class), `scene/gui/*.cpp` (Control state behavior), `scene/theme/theme_db.cpp` (theme registration / fallback resolution).
- **D-07:** Exhaustive enumeration — every theme entry upstream populates: every stylebox, color, font, icon, constant. No abbreviation, no "and similar" shortcuts.
- **D-08:** **27 upstream-themed user-facing Controls** to enumerate (verified via initial grep): Button, CheckBox, CheckButton, OptionButton, MenuButton, MenuBar, LineEdit, TextEdit, Label, RichTextLabel, Tree, ItemList, TabBar, TabContainer, ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar, Panel, PopupMenu, PopupPanel, AcceptDialog, TooltipPanel, Window, ColorPicker, GraphEdit. **Active verification step required:** re-survey the .tres beyond initial grep to confirm no class was missed (separator stylebox, RangeContainer, anything keyword grep wouldn't catch).
- **D-09:** **8 NeoCade-additives** documented as coverage delta: CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel — each marked "no upstream benchmark exists; NeoCade owns the design." Plus container chrome (HSplitContainer, VSplitContainer) and any other classes the active-verification step surfaces.
- **D-10:** Editor-only types: skip them, with one exception. **FlatButton** — dissect for research purposes (NeoCade uses the name as a Button type variation per FEATURES.md TYPEVAR-01). Skip MainScreenButton, BottomPanelButton, EditorInspectorCategory, EditorProperty, all other editor-only types.
- **D-11:** All states upstream populates, including combinations: `hover_pressed`, `pressed_focus`, `checked_focus`, `checked_disabled`, `cursor_unfocused`, etc. — every state slot upstream sets, however unusual.
- **D-12:** Flag deliberate omissions. For every Control, cross-reference upstream's populated slots against `default_theme.cpp` to identify slots Godot's API supports but upstream chose NOT to populate. Format: "CheckBox.checked_focus — exists in default_theme.cpp, upstream leaves unset."
- **D-13:** Pitfall 1.1 (focus is OVERLAY, loses to pressed/checked) and Pitfall 1.7 (popup separate-Window theming) each get an explicit "Confirmation/Refutation" section at the end of the dissection doc, citing populated+omission data.
- **D-14:** Three-file split:
  1. `.planning/research/MINIMAL-THEME-DISSECTION.md` — pure-enumeration descriptive doc (1500-3000 lines: per-Control × per-state × per-entry tables, formula extractions, icon inventory, omission flags). Provenance header at top.
  2. `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — 27-themed vs 35-target comparison + 8 NeoCade-additives + FlatButton variation note.
  3. `.planning/research/SOURCES.md` Section 1 — updated in place with summary block + adopt/reject/open synthesis.
- **D-15:** Description vs analysis split: dissection stays purely descriptive. SOURCES.md update carries adopt/reject synthesis. Coverage delta doc carries the 27-vs-35 + additives analysis.

### Claude's Discretion

- Exact table layout / column ordering for per-Control entry enumerations — pick what reads best, keep consistent across Controls.
- Whether to use grep + manual reading vs. a one-shot parse helper script — both acceptable; output is human-readable Markdown either way.
- Order in which Controls are dissected (alphabetical vs. importance vs. category-grouped) — pick what aids readability.
- Whether to include a glossary / legend section explaining Godot Theme entry-slot terminology — recommended; Claude's call.

### Deferred Ideas (OUT OF SCOPE)

- Diff against Godot 4.6 bundled "Modern" editor theme — deferred follow-up spike or v1.x.
- Editor-only theme types catalog (MainScreenButton, BottomPanelButton, EditorInspectorCategory, EditorProperty, etc.) — deferred to future v1.x editor-coverage spike.
- Run upstream's script in real Godot 4.6 editor and dump resolved theme entries to JSON — option B; not chosen (formula extraction is more useful than one runtime snapshot).
- Mine upstream's icon set inventory as NeoCade icon-design starting point — out of scope (we enumerate icon REFERENCES, not visual design). NeoCade's bespoke icons are designed in Phase 4.
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|------------------|
| RES-01 | Phase 1 source-dive spike produces line-by-line dissection of `passivestar/godot-minimal-theme` `.tres` (per-Control × per-state entry enumeration; interaction state transforms; popup/window theming patterns). Findings appended to SOURCES.md. | This research catalogues the exact `.tres` structure (1118 lines, 1 GDScript sub_resource, 1 [resource] block, 377 `set_*` calls), the `_init()` flow, the helper functions (`_get_base_color`, `_set_margin`, `_set_border`), the surface ramp model (7 stops), the state-color model, and the 80 unique class targets in the file. The dissection plans build on this skeleton. |
| DOCS-05 | SOURCES.md is updated by Phase 1, 2, 3 source-dive spike outputs (RES-01..03) with new findings. | Section 1 of SOURCES.md (godot-minimal-theme) is the explicit update target — current "MEDIUM" confidence is to be raised to "HIGH" by adding links into the new dissection doc + coverage-delta doc, plus revised "What's still open" entries. Existing structure (`What was read` / `adopted` / `rejected` / `still open` / `Confidence`) is preserved. |
</phase_requirements>

## Summary

The dissection target is fully accessible and well-bounded: `minimal_theme.tres` is a 48,442-byte / 1118-line Godot Theme resource consisting of (a) a `[gd_resource type="Theme"]` shell, (b) one `[sub_resource type="GDScript"]` containing a 1095-line `@tool extends Theme` script, and (c) one `[resource]` block that attaches the script. The script is what does the work. It runs at editor-load via `_init()`, reads 9 editor settings (`base_color`, `accent_color`, `contrast`, `base_spacing`, `additional_spacing`, `corner_radius`, `icon_and_font_color`, `relationship_line_opacity`, `draw_extra_borders`, plus a touch flag), derives a 7-stop tonal surface ramp via `_get_base_color(brightness_offset, saturation_multiplier)`, defines named font/icon/state colors, and then makes **377 `set_stylebox/set_color/set_font/set_icon/set_constant` calls** across **80 unique class targets** to populate the Theme. Per-class formulas, state-layer transforms, and popup theming patterns are all derivable by reading the script symbolically.

Of the 80 unique class targets, ~27 are user-facing Controls per CONTEXT.md D-08, ~50+ are editor-only types (skipped per D-10), and FlatButton is a research-only research target per D-10 because NeoCade reuses the name as a Button variation. The plan must (1) capture provenance up front (already computed: SHA-256 `102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e`, 48,442 bytes, 1118 lines), (2) extract globals/helpers/color-system once (shared across all per-class enumerations), (3) enumerate each user-facing Control × each populated state × each entry slot exhaustively with line-number citations into `minimal_theme.tres`, (4) cross-reference each Control's populated slots against `scene/theme/default_theme.cpp` to flag deliberate omissions, (5) confirm/refute Pitfall 1.1 and Pitfall 1.7 from the populated data, and (6) compute the 27-vs-35 coverage delta + NeoCade-additives.

**Primary recommendation:** Structure the work as **5 plans** — one per file deliverable (DISSECTION provenance+globals+helpers, DISSECTION per-class enumerations, DISSECTION omission cross-reference + pitfall confirmations, COVERAGE-DELTA, SOURCES.md update). Plans 1-3 produce one composite file (`MINIMAL-THEME-DISSECTION.md`) in three appended sections — split is purely for verification granularity (Plan 02 also produces the active-verification audit table that Plans 03 and 04 consume).

**Wave schedule (corrected per cross-AI review 2026-05-04):**
- **Wave 0:** Plan 01 (provenance + globals — short, blocks downstream).
- **Wave 1:** Plan 02 (per-class enumeration AND active-verification audit). This plan ALONE — Plans 03 and 04 hard-read its DISSECTION.md output (per-Control tables for slot-diff in Plan 03; active-verification audit table for HSplit/VSplit/MenuBar/Panel reconciliation in Plan 04). Running 03/04 in parallel with 02 produces empty output or read-after-write race failures.
- **Wave 2:** Plans 03 + 04 in parallel. They write to different files (Plan 03 → `MINIMAL-THEME-DISSECTION.md` Engine-Default + Pitfall sections; Plan 04 → new `MINIMAL-THEME-COVERAGE-DELTA.md`) and have no read-dependency on each other; both depend only on Plan 02's outputs.
- **Wave 3:** Plan 05 (SOURCES.md update — depends on all three doc deliverables existing so it can link them).

The earlier wave schedule (Plans 02+03+04 parallel in Wave 1) was a planning bug — see "Dependency Graph" below for evidence. The corrected dependency graph is `01 → 02 → [03, 04] → 05`.

## Architectural Responsibility Map

Phase 1 produces research artifacts only; no code or runtime tier is involved. The "tier" mapping is documentation responsibility:

| Capability | Primary Tier | Secondary Tier | Rationale |
|------------|-------------|----------------|-----------|
| Per-Control × per-state entry enumeration | `.planning/research/MINIMAL-THEME-DISSECTION.md` | — | Pure-descriptive doc per D-15. |
| Coverage delta (27 vs 35 + additives) | `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` | — | Comparison axis is FEATURES.md's 35-class matrix; lives separately for clean re-reading per D-14/D-15. |
| Adopt/reject/still-open synthesis | `.planning/research/SOURCES.md` Section 1 | — | Existing dossier pattern; in-place update per D-14. |
| Pitfall 1.1 / 1.7 confirmation | DISSECTION.md (final section) | — | Confirmed/refuted from populated+omission data per D-13. |
| Engine-default cross-reference | DISSECTION.md (per-Control omission flags) | `scene/theme/default_theme.cpp` (canonical slot list) | Flags slots upstream chose NOT to populate per D-12. |

## Standard Stack

Phase 1 is a research-and-documentation phase. There is no library/framework stack to install. The "stack" is the toolchain used to read the source artifacts and produce the docs:

### Core

| Tool | Version | Purpose | Why Standard |
|------|---------|---------|--------------|
| Markdown (CommonMark) | — | Output format for all 3 deliverables | Project convention; SOURCES.md and other research docs use it |
| Bash (Git Bash on Windows) | 5.x | grep / sed / sha256sum / wc for source mining | Available; project's Bash tool runs Git Bash on Windows |
| Grep tool | ripgrep-backed | Pattern enumeration of `set_*` calls | Project standard for content search |
| Read tool | — | Read 1118-line source file in chunks | Project standard for file reads |
| sha256sum (coreutils) | — | Provenance hash for D-03 | Required by D-03; verified available in Git Bash |

### Supporting

None. Phase 1 produces no code, no resource files, no test fixtures. Discussion of font/icon/palette/styling is **explicitly Phase 3+ territory** per CONTEXT.md.

### Alternatives Considered

| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Hand-grep + manual reading | Write a one-shot Python parser script | D-04 grants discretion; hand-grep is fast for ~80 classes and produces verifiable line citations; a parser is fine but the output format remains Markdown either way. **Recommendation:** hand-grep + structured tables; only switch to a parser if a class proves too large to enumerate by hand. |
| Run upstream script in Godot editor and dump JSON | Read script symbolically | Per CONTEXT.md "Deferred Ideas" — runtime dump captures one snapshot at one editor settings combination; symbolic reading captures formulas, which generalize across all settings. Symbolic is the locked decision (D-04). |

## Architecture Patterns

### System Architecture (research artifact dependencies)

```
                    minimal_theme.tres (1118 lines, MIT)
                              |
                              v
            ┌─────────────────────────────────────┐
            |  Wave 0 — Plan 01: Skeleton         |
            |  (provenance, globals, helpers,     |
            |   color system, Editor-API flags)   |
            └─────────────────────────────────────┘
                              |
                              v
            ┌─────────────────────────────────────┐
            |  Wave 1 — Plan 02: Per-Control      |
            |  enumeration + active-verification  |
            |  audit (80-class classification)    |
            |  Output: DISSECTION.md per-class    |
            |  tables + Active Verification Audit |
            └─────────────────────────────────────┘
                              |
                ┌─────────────┴─────────────┐
                v                           v
    ┌──────────────────────┐   ┌──────────────────────┐
    |  Wave 2 — Plan 03:   |   |  Wave 2 — Plan 04:   |
    |  default_theme.cpp   |   |  Coverage delta vs   |
    |  omission cross-ref  |   |  FEATURES.md         |
    |  + Pitfall 1.1/1.7   |   |  35-class matrix     |
    |  confirm. READS:     |   |  + 8 additives.      |
    |  Plan 02's per-class |   |  READS: Plan 02's    |
    |  tables (slot diff). |   |  audit (HSplit/VSplit|
    |                      |   |  + MenuBar/Panel     |
    |                      |   |  reconciliation).    |
    └──────────────────────┘   └──────────────────────┘
                |                           |
                └─────────────┬─────────────┘
                              v
            ┌─────────────────────────────────────┐
            |  Wave 3 — Plan 05: SOURCES.md       |
            |  Section 1 update — links DISSECTION|
            |  + COVERAGE-DELTA; adopt/reject/    |
            |  open synthesis.                    |
            └─────────────────────────────────────┘
```

**Why Plans 03 + 04 are NOT parallel-eligible with Plan 02 (per cross-AI review 2026-05-04):** Plan 03 Task 2 reads the per-Control slot tables Plan 02 writes into DISSECTION.md (slot diff vs default_theme.cpp); Plan 04 Task 2 reads Plan 02's `### Active Verification Audit` table to reconcile HSplitContainer / VSplitContainer / MenuBar / Panel placeholders. Both are hard read-after-write dependencies. Plans 03 and 04 ARE parallel with each other (different output files; no shared writes; both depend only on Plan 02's outputs).

### Recommended Project Structure

```
.planning/
├── research/
│   ├── MINIMAL-THEME-DISSECTION.md      # NEW (created by plans 2-4)
│   ├── MINIMAL-THEME-COVERAGE-DELTA.md  # NEW (created by plan 5)
│   └── SOURCES.md                       # UPDATED in place (plan 6 — Section 1)
└── phases/
    └── 01-source-dive-godot-minimal-theme-tres-dissection/
        ├── 01-CONTEXT.md          # Already exists
        ├── 01-RESEARCH.md         # This file
        └── 01-XX-...-PLAN.md      # Created by planner (this run)
```

### Pattern 1: Symbolic Formula Extraction

**What:** Read each `set_color`/`set_stylebox`/etc. call and capture the *expression*, not the *evaluated value*.
**When to use:** Every per-class entry enumeration in the dissection doc.
**Example (drawn from line 256 of `minimal_theme.tres`):**
```gdscript
# Line 256 of minimal_theme.tres
set_color('font_color', 'Button', color_font_normal)

# Earlier (line 81):
# var color_font_normal : Color = color_mono_font * Color(1, 1, 1, 0.7)
# var color_mono_font : Color = Color.WHITE if dark_theme_icon_and_font else Color.BLACK
# Definition: dark_theme = base_color.get_luminance() < 0.5
```
**Dissection table row format (recommended):**
| Slot | Formula (symbolic) | Snapshot @ default settings | Source line(s) |
|------|--------------------|-----------------------------|----------------|
| `Button.font_color` | `color_mono_font * Color(1,1,1,0.7)` where `color_mono_font = WHITE` if `dark_theme` else `BLACK`; `dark_theme = base_color.luminance() < 0.5` | `Color(1,1,1,0.7)` (since default `base_color=#272727` is dark) | 256 (set), 81 (def), 56 (dark_theme) |

### Pattern 2: 7-Stop Tonal Surface Ramp

**What:** Upstream uses 7 surface levels from `_get_base_color(brightness_offset, saturation_multiplier)` (lines 72-78):
- `color_surface_lowest = _get_base_color(-1.3, 0.9)` — darkest
- `color_surface_lower = _get_base_color(-0.95, 0.9)`
- `color_surface_low = _get_base_color(-0.6)`
- `color_surface_base = _get_base_color(-0.2)` — anchor
- `color_surface_high = _get_base_color(0.2, 0.8)`
- `color_surface_higher = _get_base_color(0.35, 0.8)`
- `color_surface_highest = _get_base_color(0.55, 0.6)` — brightest
**When to use:** When dissecting any Control whose stylebox `bg_color` references one of these. The surface ramp is a *shared* convention; document it once in the globals section, then reference by name in per-class tables.
**NeoCade contrast:** ARCHITECTURE.md uses 5 stops (M3 ramp). Note divergence in coverage delta.

### Pattern 3: Helper-function abstraction (`_set_margin`, `_set_border`)

**What:** Lines 1104-1118 define `_set_margin(sb, l, t, r, b)` and `_set_border(sb, color, width, blend)`. These wrap the Godot StyleBox margin/border setters and are called dozens of times.
**When to use:** Where a stylebox call uses these helpers, dissection should expand the helper inline (or document once, then cite).

### Pattern 4: Editor-API touchpoints (D-05 critical)

**What:** Upstream calls `EditorInterface.get_editor_settings()` (line 15), `EditorInterface.get_editor_scale()` (line 21), and reads ~10 `interface/theme/*` settings keys. These are **forbidden in NeoCade itself** per D-05.
**When to use:** Document each touchpoint at the top of the dissection (in the globals/`_init()` section). The dissection doc must have an "Editor-API Touchpoints (Forbidden in NeoCade)" callout with line numbers, so downstream phases never accidentally port editor-bound code.

### Anti-Patterns to Avoid

- **Lifting numeric values verbatim:** Pitfall 6.1 — upstream uses `EDSCALE` (the editor-scale factor); copying numbers without the formula loses meaning.
- **Treating one settings combination as canonical:** D-04 explicitly forbids — formulas first, snapshot is verification.
- **Editor-API bleed-through:** D-05 — dissection cannot recommend any pattern that requires `EditorSettings`/`EditorInterface` in the consumed downstream phases.
- **Skipping omission cross-reference:** D-12 — without `default_theme.cpp` cross-reference, omission flags are guesses.
- **Abbreviating with "and similar":** D-07 — every entry must be enumerated.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Counting set_* calls per class | Custom AST parser | `grep -oE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '[A-Z][a-zA-Z]+'"` + `sort -u` | Already verified: produces 80-class list in <1s; AST parse adds setup cost without precision gain. |
| Hash provenance | Manual file inspection | `sha256sum` from coreutils | Single deterministic command; output is the citation. |
| Cross-reference engine slots | Manual `default_theme.cpp` reading per class | Targeted grep on `default_theme.cpp` for the class name | `default_theme.cpp` is large but well-structured — class-keyed grep is sufficient. |

**Key insight:** This phase is text-mining a 1118-line text file plus targeted lookups in two reference files. No bespoke tooling needed; existing Bash/Grep/Read are sufficient.

## Common Pitfalls

### Pitfall 1: Over-trusting initial 27-class count

**What goes wrong:** D-08 lists 27 user-facing Controls "verified by initial grep." But initial grep is keyword-based; it can miss classes whose set_* call uses a single quote inside a double-quoted string, or classes themed only via `set_stylebox` for a separator slot, or via type-variations.
**Why it happens:** Different quoting styles in GDScript (single vs double); type-variations that look like editor-only names but are user-facing aliases.
**How to avoid:** Run a second-pass grep that captures ALL unique 2nd arguments to `set_*` calls (already verified: 80 unique targets), then audit the 80 against `default_theme.cpp` to confirm which are user-facing Controls vs editor-only. D-08's "Active verification step required" is this audit — make it an explicit task in the plan.
**Warning signs:** Coverage delta count differs from 27.

### Pitfall 2: Conflating "defined" with "set"

**What goes wrong:** A theme entry can be defined in `default_theme.cpp` (engine API) but not set by upstream — and vice versa, upstream can set entries that no Control reads (orphaned slots from old Godot versions).
**Why it happens:** Upstream targets Godot 4.3-4.5; entry slots evolve over versions.
**How to avoid:** D-12 omission flags must specify "exists in `default_theme.cpp`" with a line citation; if cross-reference can't find the slot, flag it as "set by upstream but no engine-default — possibly orphaned."
**Warning signs:** A populated entry has no engine-default counterpart.

### Pitfall 3: Pitfall 1.1 misreading

**What goes wrong:** Pitfall 1.1 claims focus stylebox is overlay (loses to pressed/checked). Naive reading of the dissection might think upstream "fixed" this by always populating focus alongside pressed_focus. Actually, focus-as-overlay is *engine behavior*, not theme behavior — upstream populates `pressed_focus` and `checked_focus` because those are the only way to *render* focus when also pressed/checked.
**Why it happens:** Overlay vs state distinction is in `scene/gui/base_button.cpp` draw logic, not in `default_theme.cpp` slot list.
**How to avoid:** Confirmation/refutation section (D-13) must reference `scene/gui/base_button.cpp` for the *behavior* claim, plus the populated `pressed_focus`/`checked_focus` slots in the .tres for the *theme response* to that behavior.
**Warning signs:** Dissection conclusion says "Pitfall 1.1 refuted" because focus is populated; correct conclusion is "Pitfall 1.1 confirmed; upstream's response is to populate composite-state slots."

### Pitfall 4: Pitfall 1.7 popup theming

**What goes wrong:** Pitfall 1.7 says popups are separate Windows that don't inherit theme overrides. Dissection might claim "refuted" because PopupMenu/PopupPanel/AcceptDialog/TooltipPanel are all explicitly themed at the Theme-resource level. But the pitfall is about *inherited overrides at runtime*, not about the Theme resource — the resource-level theming is precisely the *fix* for the pitfall.
**Why it happens:** Two layers (theme resource has type-level entries) vs (runtime Control has theme overrides) — pitfall is about the second.
**How to avoid:** Confirmation/refutation must distinguish "upstream theme resource sets type-level entries for popup classes" (TRUE, by enumeration) from "popups inherit override-bag overrides" (FALSE, per `scene/theme/theme_db.cpp` resolution logic).
**Warning signs:** Confirm/refute uses one-word verdict without distinguishing levels.

### Pitfall 5: Skipping the Globals section

**What goes wrong:** Going straight into per-class tables without first documenting the 9 editor-settings reads + 7-stop surface ramp + named font/icon/state colors. Per-class tables then have to expand every formula inline, ballooning the doc and making cross-class patterns invisible.
**Why it happens:** Eagerness to start enumerating; per-class is the visible deliverable.
**How to avoid:** Plan 01 (globals/helpers) is Wave 0 explicitly to force the shared vocabulary first. Plan 02 per-class enumeration (Wave 1) cites into the Globals section by name.
**Warning signs:** First per-class entry table has 200-character formula cells; cross-class duplication is high.

### Pitfall 6: Missed line-number citations

**What goes wrong:** Tables list the formula but not the line in `minimal_theme.tres` — when downstream phases want to verify a claim, they have to grep all over again.
**Why it happens:** Table writing focuses on values, not provenance.
**How to avoid:** Every table row must include source line number(s). The grep tool already returns line numbers — preserve them in plans' acceptance criteria. Format: `set call line, def line, dependency line`. Examples in Pattern 1 above.
**Warning signs:** Coverage delta or SOURCES.md update can't cite specific lines.

## Common Theme-Slot Vocabulary (Glossary)

For dissection-doc readers unfamiliar with Godot Theme API:

| Slot kind | What it is | Example |
|-----------|-----------|---------|
| `stylebox` | A `StyleBox` resource (typically `StyleBoxFlat`) with bg_color, corner_radius, border_*, content_margin_*, expand_margin_*, etc. | `Button.normal` = the visual background drawn for the button's normal state |
| `color` | A `Color` (RGBA) | `Button.font_color` = text color in normal state |
| `font` | A `Font` resource | `Button.font` = font face/variation used for label text |
| `font_size` | An `int` (typically pixels) | `Button.font_size` = label point size |
| `icon` | A `Texture2D` (typically SVG via SVGTexture in Godot 4) | `Button.icon` = optional icon shown next to label |
| `constant` | An `int` (mostly margins, separations, line widths) | `Button.h_separation` = horizontal space between icon and label |

**Per-state suffixes:** `normal`, `hover`, `pressed`, `focus`, `disabled`, `hover_pressed`, `pressed_focus`, `checked`, `unchecked`, `radio_checked`, `radio_unchecked`, `cursor`, `cursor_unfocused`, etc. The actual set depends on the Control class.

## Code Examples

### Example 1: Computing provenance (already done; reuse for Plan 2)

```bash
# Verified in this research session
sha256sum /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
# 102fd6b3cab3b30b3c05878badff83e321df06a98adf4bb17e6a94d1b0a73f2e

wc -l /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
# 1118

ls -la /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres | awk '{print $5}'
# 48442
```

### Example 2: Enumerating per-class set_* calls

```bash
# Get every set_* call targeting class 'Button' (line numbers preserved)
grep -nE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, 'Button'" \
  /c/Programming_Files/Godot/godot-minimal-theme-main/minimal_theme.tres
```

### Example 3: Cross-referencing engine-default slot list

```bash
# Find Button slot definitions in default_theme.cpp
grep -nE "theme->set_(stylebox|color|font|icon|constant|font_size)\([^,]+, [\"']Button" \
  /c/Programming_Files/Godot/godot-master/scene/theme/default_theme.cpp
```

### Example 4: Listing all unique class targets (D-08 verification)

```bash
# Already executed in this research; output preserved here for plan reference:
cd /c/Programming_Files/Godot/godot-minimal-theme-main && \
  grep -oE "set_(stylebox|color|font|icon|constant|font_size)\([^,]+, '[A-Z][a-zA-Z]+'" \
  minimal_theme.tres | grep -oE "'[A-Z][a-zA-Z]+'" | sort -u | tr -d "'"
```

**Result (80 unique class targets, alphabetical):**
```
AcceptDialog, AnimationBezierTrackEdit, AnimationTimelineEdit, AnimationTrackEdit,
AnimationTrackEditGroup, AssetLib, Background, BottomPanelButton, Button, CheckBox,
CheckButton, ColorPicker, ContextualToolbar, Editor, EditorAbout, EditorAudioBus,
EditorDebuggerInspector, EditorHelpBitContent, EditorHelpBitTitle, EditorInspector,
EditorInspectorCategory, EditorInspectorSection, EditorLogFilterButton, EditorProperty,
EditorSettingsDialog, EditorSpinSlider, EditorStyles, EditorValidationPanel, FlatButton,
FlatMenuButton, FocusViewport, GraphEdit, GraphStateMachine, HBoxContainer, HScrollBar,
HSeparator, HSlider, HSplitContainer, InspectorActionButton, ItemList, ItemListSecondary,
Label, LaunchPadMovieMode, LaunchPadNormal, LineEdit, MainMenuBar, MainScreenButton,
MenuButton, MovieWriterButtonPressed, OptionButton, PanelContainer, PopupDialog,
PopupMenu, PopupPanel, ProgressBar, ProjectExportDialog, ProjectManager,
ProjectSettingsEditor, RichTextLabel, RunBarButton, RunBarButtonMovieMakerDisabled,
RunBarButtonMovieMakerEnabled, SceneImportSettingsDialog, ScrollContainer, SplitContainer,
TabBar, TabContainer, TabContainerOdd, TextEdit, ThemeEditorPreviewBG,
ThemeEditorPreviewFG, ThemeItemEditorDialog, TooltipPanel, Tree, TreeSecondary,
VBoxContainer, VScrollBar, VSeparator, VSlider, VSplitContainer
```

**Audit note:** Of the 80, ~25-27 are user-facing (the D-08 list). The rest split into editor-only (skip per D-10), type-variations on user-facing classes (TabContainerOdd, ItemListSecondary, TreeSecondary, FlatMenuButton — research target if relevant to NeoCade type variations), and the FlatButton special case (D-10). The Plan 3 active-verification task must reconcile this 80 against D-08's 27 + FlatButton + NeoCade-additives, and explicitly classify HBoxContainer/VBoxContainer/HSeparator/VSeparator/PanelContainer/ScrollContainer/SplitContainer as user-facing-but-themed-with-minimal-data (likely just constants / separator stylebox).

## Runtime State Inventory

> Phase 1 produces no code, no resources, no migrations. Skipped — none applicable.

| Category | Items Found | Action Required |
|----------|-------------|------------------|
| Stored data | None — research-only phase | None |
| Live service config | None | None |
| OS-registered state | None | None |
| Secrets/env vars | None | None |
| Build artifacts | None | None |

## Environment Availability

| Dependency | Required By | Available | Version | Fallback |
|------------|------------|-----------|---------|----------|
| `minimal_theme.tres` source file | All plans | ✓ | 1118 lines, 48442 bytes, SHA-256 `102fd6b3...a73f2e` | — (locked dissection target per D-02) |
| `godot-master` engine source clone | Plan 4 (omission cross-reference) | ✓ | — | — (verified `scene/theme/default_theme.cpp` and `scene/gui/*.cpp` present) |
| Bash + Grep + Read tools | All plans | ✓ | Git Bash 5.x | — |
| sha256sum (coreutils) | Plan 2 (provenance) | ✓ | Git Bash builtin | — |
| Hand-grep methodology | All plans | ✓ | — | Switch to Python parse script if a class's `set_*` calls exceed manual enumeration capacity |

**Missing dependencies with no fallback:** None.
**Missing dependencies with fallback:** None.

## Validation Architecture

> Note on Nyquist for documentation phases: this phase produces Markdown research artifacts only — no code, no automated tests, no test framework applicable. The "validation" model below substitutes goal-backward grep checks for executable tests. VALIDATION.md should reflect that — Dimension 8 satisfied by acceptance-criteria greps, not pytest/jest.

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None (Markdown research artifacts; no executable validation) |
| Config file | None |
| Quick run command | Per-plan: `grep -c "<expected pattern>" <output_file>` |
| Full suite command | Composite of all plan acceptance-criteria greps |

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| RES-01 | Per-Control × per-state enumeration written | grep | `test $(grep -cE "^### [A-Z][a-zA-Z]+" .planning/research/MINIMAL-THEME-DISSECTION.md) -ge 28` (27 user-facing + FlatButton) | ❌ Wave 0 (created by plans) |
| RES-01 | Provenance present | grep | `grep -q "SHA-256: 102fd6b3" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "1118 lines" .planning/research/MINIMAL-THEME-DISSECTION.md` | ❌ Wave 0 |
| RES-01 | Coverage delta written | grep | `test -f .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md && grep -q "27" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md && grep -q "FlatButton" .planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` | ❌ Wave 0 |
| RES-01 | Pitfall 1.1 + 1.7 confirmation sections present | grep | `grep -q "Pitfall 1.1" .planning/research/MINIMAL-THEME-DISSECTION.md && grep -q "Pitfall 1.7" .planning/research/MINIMAL-THEME-DISSECTION.md` | ❌ Wave 0 |
| RES-01 | Editor-API touchpoints flagged (D-05) | grep | `grep -qE "Editor[ -]API" .planning/research/MINIMAL-THEME-DISSECTION.md` | ❌ Wave 0 |
| DOCS-05 | SOURCES.md Section 1 updated; confidence raised; links to new docs | grep | `grep -q "MINIMAL-THEME-DISSECTION" .planning/research/SOURCES.md && grep -q "MINIMAL-THEME-COVERAGE-DELTA" .planning/research/SOURCES.md` and `grep -A30 "^## 1\\. godot-minimal-theme" .planning/research/SOURCES.md \| grep -q "Confidence in coverage:.*HIGH"` | ❌ Wave 3 |

### Sampling Rate
- **Per task commit:** Run that task's acceptance-criteria greps locally
- **Per wave merge:** Re-run all completed plans' criteria
- **Phase gate:** All criteria above pass green before `/gsd-verify-work`

### Wave 0 Gaps
- [ ] No tests/test_file.py — Markdown deliverables, not code; greps are the validation primitive
- [ ] No test framework install needed
- [ ] **One actual gap:** Decide on canonical Markdown heading style (`### ClassName` chosen above for grep simplicity) — must be applied uniformly so the requirement-grep pattern is deterministic

## Security Domain

> Phase 1 produces no executable code, no network calls, no auth flows, no data persistence. ASVS does not apply meaningfully. Documenting only the upstream-attribution risk (license-related), which is resolved by D-04 (formula extraction, not value lifting) + Pitfall 6.1 honoring.

### Applicable ASVS Categories

| ASVS Category | Applies | Standard Control |
|---------------|---------|-----------------|
| V2 Authentication | no | — |
| V3 Session Management | no | — |
| V4 Access Control | no | — |
| V5 Input Validation | no | — |
| V6 Cryptography | no | — |

### Known Threat Patterns for {stack}

| Pattern | STRIDE | Standard Mitigation |
|---------|--------|---------------------|
| Verbatim numeric copying from MIT-licensed upstream creating "derived work" claim ambiguity | Repudiation (license attribution) | D-04 + Pitfall 6.1: extract formulas symbolically, derive NeoCade values independently in Phase 3; record the dissection as "research-only enumeration of upstream's structure" |
| Editor-API contamination of runtime-first NeoCade | Tampering (architectural) | D-05: dissection explicitly flags every `EditorSettings`/`EditorInterface` touchpoint with line citations so downstream phases never accidentally port them |

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| `EditorScript`-driven theme generation (Yuri Sizov original article) | `@tool extends Theme` + `_init()` reads `EditorSettings` | Sizov→passivestar productization | Upstream is the productized form; dissect this form, not the originating article |
| Verbatim `.tres` editing | GDScript-driven generation | passivestar's choice | Both forms are valid Godot Theme resource shapes; NeoCade Phase 4 will use `@tool` script for the generator (a `.tres`+`@tool` hybrid like upstream, but runtime-safe) |
| Single-snapshot theme dump | Symbolic formula extraction (D-04) | This phase's locked methodology | Captures generality; reusable across editor settings |

**Deprecated/outdated:**
- N/A — `minimal_theme.tres` is the current canonical artifact (and now ported into Godot 4.6 itself).

## Assumptions Log

| # | Claim | Section | Risk if Wrong |
|---|-------|---------|---------------|
| A1 | The 80 unique class targets surfaced by the verification grep is exhaustive of all `set_*` calls in `minimal_theme.tres` | Code Examples §4 | If a class is themed via a non-standard pattern (e.g., subclass-of-set, indirect helper), it'd be missed. **Mitigation:** Plan 3's "active verification step" (D-08) — re-grep with broader patterns and audit; the 80 above is the keyword-based starting point, not the final answer. **[VERIFIED: grep run in this research session — 80 results.]** Risk is low; broader-pattern verification is part of the plan. |
| A2 | `default_theme.cpp` in the user's local `godot-master` clone is sufficiently close to Godot 4.6 release for omission cross-reference | Pattern 4 / Pitfall 2 | If user's clone is stale (pre-4.6), some entries upstream sets may not yet have engine-default counterparts. **Mitigation:** Plan 4 should `git log -1` the user's `godot-master` to record the commit it cross-referenced; if commit is pre-4.6, flag and recommend pulling. **[ASSUMED — not yet verified in this session.]** |
| A3 | "User-facing" vs "editor-only" classification of the 80 targets resolves cleanly to D-08's 27 + FlatButton (research) + ~10 type-variations + ~40 editor-only | Common Pitfalls §1 | If the split is more ambiguous (e.g., some classes ARE user-facing but only relevant in editor mode), coverage delta numbers shift. **Mitigation:** Plan 5's coverage-delta task includes a per-class classification rationale, not just a count. **[ASSUMED — to be verified in plans.]** |
| A4 | Pitfall 1.7 confirmation hinges on `theme_db.cpp` runtime resolution behavior + populated PopupMenu/PopupPanel/AcceptDialog/TooltipPanel/Window slots in upstream | Pitfall 4 | If `theme_db.cpp` resolution doesn't behave as PITFALLS.md describes, the confirmation logic shifts. **Mitigation:** Plan 4 should read `theme_db.cpp` lookup function explicitly and quote it; do not rely on PITFALLS.md restatement alone. **[ASSUMED — to be verified.]** |

**If this table is empty:** All claims in this research were verified or cited — no user confirmation needed.

(A1 verified; A2/A3/A4 to be verified during plan execution.)

## Open Questions

1. **How granular should the per-class enumeration tables be?**
   - What we know: D-07 mandates exhaustive ("dissect everything") with no abbreviations; CONTEXT.md "Claude's Discretion" grants formatting freedom.
   - What's unclear: Whether to combine all states into one wide table per class, or one row per (slot, state) pair.
   - Recommendation: Plan 3 uses ONE row per (entry-name, state) pair, with columns: state | slot kind | formula | snapshot | source line(s). This denormalizes the data for greppability — every entry is grepable by class+state+slot — which serves Phase 4 generator and Phase 10 COV-10 verification downstream.

2. **Should helper functions (`_set_margin`, `_set_border`, `_get_base_color`) be expanded inline or referenced?**
   - What we know: They're called dozens of times; expanding inline would 5x the doc length.
   - What's unclear: Reader convenience vs auditability.
   - Recommendation: Document each helper ONCE in the Globals section with full body + line citations. Per-class tables reference by name (`_set_margin(sb, 4, 4)`). Greppable, compact, auditable.

3. **What's the canonical line-citation format?**
   - What we know: Grep returns `path:line:content`; tables already need line columns per Pattern 1.
   - What's unclear: Format choice (`L256` vs `line 256` vs `:256`).
   - Recommendation: Plain integers in table cells: `256, 81, 56`. Project convention is concise; readers can `grep -n` to find context.

## Sources

### Primary (HIGH confidence)
- `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres` (read in this session) — the dissection target. SHA-256 `102fd6b3...a73f2e`, 1118 lines, 48442 bytes (verified).
- `C:\Programming_Files\Godot\godot-minimal-theme-main\README.md` (read in this session) — recommended editor settings (`base_color #272727`, `accent_color #569eff`, contrast 0.3-0.35, icon saturation 2, corner radius 4-5, Inter main font).
- `C:\Programming_Files\Godot\godot-master\scene\theme\` directory listing (verified in this session) — confirms `default_theme.cpp` and `theme_db.cpp` exist.
- `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md` — locked decisions D-01..D-15.
- `.planning/REQUIREMENTS.md` lines 14, 200, 273, 385 — RES-01 + DOCS-05 specifications.
- `.planning/ROADMAP.md` Phase 1 section — five concrete success criteria.
- `.planning/research/SOURCES.md` Section 1 — existing structure and "What's still open" entries to be resolved.
- `.planning/research/SUMMARY.md` Phase 1 Rationale — README values were extracted in initial pass; line-by-line `.tres` enumeration was NOT (LOW-confidence gap; this phase closes it).

### Secondary (MEDIUM confidence)
- `.planning/research/PITFALLS.md` Pitfalls 1.1, 1.7, 6.1 — interpretations to confirm/refute against the dissected data (re-verified during plan execution).
- `.planning/research/FEATURES.md` 35-class matrix — comparison axis for coverage delta.

### Tertiary (LOW confidence)
- None.

## Metadata

**Confidence breakdown:**
- Standard Stack: HIGH — Bash/Grep/Read are project standard; sha256sum verified available.
- Architecture: HIGH — research artifact dependency graph follows existing `.planning/research/` conventions.
- Pitfalls: HIGH — six pitfalls drawn directly from CONTEXT.md decisions, PITFALLS.md citations, and existing SOURCES.md structure.
- Symbolic methodology (Pattern 1): HIGH — exemplified live against line 256 of `minimal_theme.tres`.
- 80-target enumeration (Code Examples §4): HIGH — verified via grep in this session.
- Plan structure (5-plan, Waves 0 → 1 → [2,2] → 3): HIGH — driven by file-deliverable boundaries from D-14 and read-after-write dependencies (Plans 03/04 read Plan 02's DISSECTION.md outputs; corrected per cross-AI review 2026-05-04).

**Research date:** 2026-05-04
**Valid until:** No expiry — `minimal_theme.tres` snapshot is frozen by D-02; engine source cross-reference is checked once and pinned in the dissection doc.
