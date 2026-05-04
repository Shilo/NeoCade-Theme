# Phase 1: Source-Dive — godot-minimal-theme `.tres` Dissection - Context

**Gathered:** 2026-05-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Produce evidence-grade enumeration of every theme entry in passivestar's `godot-minimal-theme` (the upstream MIT-licensed reference theme that Godot 4.6 productized as its default "Modern" editor theme), so NeoCade's "feature-complete to godot-minimal-theme's bar" claim becomes verifiable, not aspirational.

**In scope:**
- Reverse-engineer the upstream `@tool extends Theme` GDScript symbolically — capture the formulas, not just one numeric snapshot
- Enumerate every theme entry upstream populates per Control class × per state × per slot type (stylebox / color / font / icon / constant), including state combinations Godot supports (`hover_pressed`, `pressed_focus`, `checked_focus`, `cursor_unfocused`, etc.)
- Flag deliberate omissions — slots that exist in `default_theme.cpp` but upstream leaves unset
- Confirm or refute Pitfall 1.1 (focus stylebox is overlay, loses to pressed/checked) and Pitfall 1.7 (popup separate-Window theming) directly from the data
- Coverage delta: 27 upstream-themed user-facing Controls vs NeoCade's 35-class target
- Active grep-verification step to confirm no class was missed beyond initial keyword survey
- Three output artifacts (see Output Structure below)

**Out of scope (explicit):**
- Any `.tres` styling commits in `addons/neocade_theme/` — Phase 1 is research-only; first styling commits are gated on Phase 3 mockup approval
- Lifting upstream's numeric values into NeoCade — Pitfall 6.1 forbids verbatim adoption (upstream uses EDSCALE; NeoCade derives numerics from its own design system)
- Diffing upstream against Godot 4.6's bundled "Modern" editor theme port — open per SOURCES.md but deferred
- Editor-only types (MainScreenButton, BottomPanelButton, EditorInspectorCategory, etc.) — only exception: FlatButton, since NeoCade reuses the name as a Button type variation
- Visual identity, palette, typography, mockup work — Phase 3 territory
- Mining LDtk source — Phase 2 territory (parallel-eligible)

</domain>

<decisions>
## Implementation Decisions

### Canonical Source Artifact
- **D-01:** **Upstream repo only** is the benchmark — passivestar/godot-minimal-theme. Do NOT diff against Godot 4.6's bundled "Modern" port (deferred).
- **D-02:** **Source file:** `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres` (1118 lines, user's downloaded ZIP snapshot). Repo root: `C:\Programming_Files\Godot\godot-minimal-theme-main\` (contains `LICENSE`, `README.md`, `minimal_theme.tres`).
- **D-03:** Provenance recorded at the top of the dissection doc: snapshot path + file size + SHA-256 hash of `minimal_theme.tres` + line count + ISO date snapshot was downloaded. Since this is a ZIP download (not a git clone), no commit SHA is available — hash is the reproducibility anchor.
- **D-04:** **Extraction methodology = reverse-engineer the GDScript formulas symbolically.** Document derivations as expressions: `Button.normal.bg_color = base_color.lerp(white, 0.05 * contrast)`, `Button.hover = normal.lighten(0.05)`, etc. Pair each formula with a single concrete instantiation at upstream's documented default editor settings (per `README.md`) for verification — but the **formula is the convention**, not any single output.
- **D-05:** **Critical reuse constraint (project-wide, surfaced here):** NeoCade itself MUST NOT use `EditorSettings`, `EditorInterface`, or any editor-bound API — NeoCade is runtime-first (must work in shipped games on all 6 export targets). Upstream's editor-bound script is **inspiration only**, never ported. The dissection captures upstream's formulas as research material; the Phase 4 `@tool` token-generator (TokenSet → both `.tres` files) is NeoCade's own runtime-safe substrate, with NeoCade's own custom palette, not Godot's.
- **D-06:** Cross-reference Godot source at `C:\Programming_Files\Godot\godot-master\` — particularly `scene/theme/default_theme.cpp` (canonical reference for which theme slots each Control class declares) and `scene/gui/*.cpp` (Control class implementations / state behavior reference). Use this to verify upstream's slot coverage against the engine's actual API.

### Enumeration Scope
- **D-07:** **Exhaustive enumeration** of every theme entry upstream populates — every stylebox, color, font, icon reference, constant. No abbreviation, no "and similar" shortcuts. "Dissect everything."
- **D-08:** **27 upstream-themed user-facing Controls** to enumerate (verified by initial grep): Button, CheckBox, CheckButton, OptionButton, MenuButton, MenuBar, LineEdit, TextEdit, Label, RichTextLabel, Tree, ItemList, TabBar, TabContainer, ProgressBar, HSlider, VSlider, HScrollBar, VScrollBar, Panel, PopupMenu, PopupPanel, AcceptDialog, TooltipPanel, Window, ColorPicker, GraphEdit. **Active verification step required:** re-survey the .tres beyond initial grep to confirm no class was missed (e.g., separator stylebox, RangeContainer, anything our keyword grep wouldn't catch).
- **D-09:** **8 NeoCade-additives** documented as coverage delta with explicit "no upstream benchmark exists; NeoCade owns the design" note: CodeEdit, FoldableContainer, SpinBox, ColorPickerButton, LinkButton, FileDialog, ConfirmationDialog, TooltipLabel. Plus container chrome (HSplitContainer, VSplitContainer) and any other classes the active-verification step surfaces.
- **D-10:** **Editor-only types: skip them**, with one exception. **FlatButton** — dissect for research purposes (editor-only in upstream, but NeoCade uses the name as a Button type variation per FEATURES.md TYPEVAR-01). Skip MainScreenButton, BottomPanelButton, EditorInspectorCategory, EditorProperty, and all other editor-only types.

### State Combination Depth
- **D-11:** **All states upstream populates, including combinations.** Document `hover_pressed`, `pressed_focus`, `checked_focus`, `checked_disabled`, `cursor_unfocused`, etc. — every state slot upstream sets, however unusual. Pitfall 1.1 (focus is OVERLAY, loses to pressed/checked) is one of the most-cited pitfalls in our research; capturing how upstream handles state combinations directly informs Phase 5's focus-ring design.
- **D-12:** **Flag deliberate omissions.** For every Control, cross-reference upstream's populated slots against `scene/theme/default_theme.cpp` to identify slots Godot's API supports but upstream chose NOT to populate. Format: "CheckBox.checked_focus — exists in default_theme.cpp, upstream leaves unset." Documents upstream's design choices, not just its data.
- **D-13:** Pitfall 1.1 and Pitfall 1.7 each get an explicit "Confirmation/Refutation" section at the end of the dissection doc, citing the populated+omission data that supports or refutes the claim.

### Output Structure
- **D-14:** **Three-file split:**
  1. `.planning/research/MINIMAL-THEME-DISSECTION.md` — pure-enumeration descriptive doc (likely 1500-3000 lines: per-Control × per-state × per-entry tables, formula extractions, icon inventory, omission flags). Provenance header at the top (snapshot path, size, hash, line count, date).
  2. `.planning/research/MINIMAL-THEME-COVERAGE-DELTA.md` — the 27-themed vs 35-target comparison + 8 NeoCade-additives + FlatButton variation note.
  3. `.planning/research/SOURCES.md` Section 1 — updated in place, with a summary block + adopt/reject/open synthesis (mirroring SOURCES.md's existing pattern for Sections 1-9). Links into the two new docs.
- **D-15:** **Description vs analysis split:** `MINIMAL-THEME-DISSECTION.md` stays purely descriptive — "here's exactly what upstream does, line-by-line, with citations." SOURCES.md update carries the "what we adopt / what we reject / what we keep open" synthesis. Coverage delta doc carries the 27-vs-35 + additives analysis. Clean separation: enumeration is reusable forever; synthesis decisions evolve as design evolves.

### Claude's Discretion
- Exact table layout / column ordering for per-Control entry enumerations — pick what reads best for the data; keep it consistent across Controls.
- Whether to use grep + manual reading vs. a one-shot parse helper script for the enumeration — both are acceptable; parser is fine if it speeds the work, but the dissection output is human-readable Markdown either way.
- Order in which Controls are dissected (alphabetical vs. importance-ordered vs. category-grouped) — pick what aids readability of the final doc.
- Whether to include a glossary / legend section explaining Godot Theme entry-slot terminology (`stylebox` / `font` / `font_color` / `icon` / `constant`) at the top of the dissection doc — recommended for readers unfamiliar with the API; Claude's call.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Dissection target (the artifact being dissected)
- `C:\Programming_Files\Godot\godot-minimal-theme-main\minimal_theme.tres` — DISSECTION TARGET. 1118 lines. `@tool extends Theme` GDScript-driven theme. License: MIT.
- `C:\Programming_Files\Godot\godot-minimal-theme-main\README.md` — Recommended editor settings (`base_color #272727`, `accent_color #569eff`, Inter font, corner radius 4-5px). Use to instantiate concrete formula outputs for verification.
- `C:\Programming_Files\Godot\godot-minimal-theme-main\LICENSE` — MIT (compatible with NeoCade redistribution if any patterns were lifted; per Pitfall 6.1, no values are lifted).

### Godot engine source (cross-reference for canonical Control entry slots)
- `C:\Programming_Files\Godot\godot-master\scene\theme\default_theme.cpp` — Canonical reference for which theme entries each Control class declares. Use to identify slots upstream omits.
- `C:\Programming_Files\Godot\godot-master\scene\gui\` — Control class implementations (state behavior reference: how `pressed`/`hover`/`focus` resolve at runtime).
- `C:\Programming_Files\Godot\godot-master\scene\theme\theme_db.cpp` — Theme registration / fallback resolution (relevant for confirming Pitfall 1.7 popup-separate-Window claim).

### NeoCade project canon (already authoritative for this phase)
- `.planning/PROJECT.md` — "godot-minimal-theme is the feature-completeness benchmark, NOT visual reference" (hard constraint); Research Charter mandates evidence-grade citations + file paths + specific values.
- `.planning/REQUIREMENTS.md` — RES-01 (Phase 1 source-dive must produce per-Control × per-state enumeration; findings appended to SOURCES.md); DOCS-05 (continuous SOURCES.md updates).
- `.planning/ROADMAP.md` Phase 1 Success Criteria — five concrete deliverables drive Phase 1 plan.
- `.planning/research/SUMMARY.md` Phase 1 Rationale — README values were extracted in initial pass; line-by-line `.tres` enumeration was NOT (LOW-confidence gap; this phase closes it).
- `.planning/research/SOURCES.md` Section 1 (godot-minimal-theme) — to be updated in place with Phase 1 findings; existing "What we adopted / What we rejected / What's still open" structure is the synthesis pattern to extend.
- `.planning/research/FEATURES.md` — 35-class coverage matrix (the comparison axis for the coverage delta doc); FlatButton listed as Button type variation (TYPEVAR-01 / DF-Button-1); editor-only types listed as AF-6 (anti-feature for v1 implementation).
- `.planning/research/PITFALLS.md` — Pitfall 1.1 (focus is OVERLAY, not state — loses to pressed/checked) and Pitfall 1.7 (popups are separate Windows — don't inherit theme overrides) are to be confirmed/refuted by Phase 1 enumeration data; Pitfall 6.1 (don't lift upstream numerics — they use EDSCALE) is the hard constraint Phase 1 must respect.
- `.planning/research/STACK.md` — `StyleBoxFlat` everywhere; AA requires `corner_radius >= 2`; relevant when comparing upstream's stylebox choices.
- `.planning/research/ARCHITECTURE.md` — M3 deterministic state-layer model (hover 8% / focus 12% / pressed 12%); useful when comparing upstream's formula transforms (e.g., does upstream's `hover` add 8% lightness? more? less?).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **None directly applicable to Phase 1.** Phase 1 produces research artifacts (`.md` docs in `.planning/research/`); it does NOT touch `addons/neocade_theme/` or any source code.
- The empty Theme scaffold at `addons/neocade_theme/neocade_theme.tres` (3 lines: header + `[resource]`) is intentionally untouched by Phase 1 — first styling commits are gated on Phase 3 mockup approval.

### Established Patterns
- **SOURCES.md Section structure** (`What was read` / `What we adopted` / `What we rejected` / `What's still open` / `Confidence in coverage`) — this is the existing synthesis pattern. Phase 1's SOURCES.md Section 1 update follows this exact structure, replacing the "What's still open: full `.tres` enumeration" line with the new findings + links into the two new docs.
- **Research artifact location** — `.planning/research/*.md` for synthesized research; `.planning/research/SOURCES.md` for the per-source dossier. Phase 1 follows both conventions: SOURCES.md update + two new artifact docs in `.planning/research/`.
- **Date stamping convention** — every research doc lists "Authored: YYYY-MM-DD" / "Researched: YYYY-MM-DD" in the frontmatter. Phase 1 docs follow.
- **Provenance pattern** — existing research docs cite specific file paths and line numbers (e.g., `app/assets/css/app.scss` lines 1-24). Phase 1 dissection doc applies the same discipline to upstream's `.tres` (cite line numbers from `minimal_theme.tres`).

### Integration Points
- **SOURCES.md Section 1** — existing "What's still open" entries (`Full .tres enumeration`, `Accent application strategy`, `Editor-theme-only types' theme entries`) get resolved or updated by Phase 1 findings.
- **Confidence in coverage line** in SOURCES.md Section 1 — currently "MEDIUM"; Phase 1 raises this to HIGH (the explicit recommendation in SOURCES.md: "Phase 1 source-dive spike that opens the .tres and enumerates entries").
- **Phase 4 generator (downstream consumer)** — `addons/neocade_theme/_dev/generate_themes.gd` will reference Phase 1's coverage delta when declaring TokenSet structure; the dissection doc's per-Control entry tables are the input format for "what entries does each Control need?"
- **Phase 10 COV-10 (downstream consumer)** — diff-checks NeoCade's final theme entries against Phase 1's enumeration to verify zero engine-default fallback for any Control upstream themes.

</code_context>

<specifics>
## Specific Ideas

- **The user explicitly downloaded the ZIP** to `C:\Programming_Files\Godot\godot-minimal-theme-main\` (not cloned). Provenance must record path + file size + SHA-256 hash since no git commit SHA is available.
- **The user wants exhaustive depth** — verbatim quote: "it should disect everything." No abbreviation, no shortcuts. Apply this discipline to: per-state transforms (formulas + verification snapshot), constants (every `icon_separation`/`item_margin`/etc.), icons (full inventory with file references), and edge-case state combinations (hover_pressed/checked_focus/etc.).
- **FlatButton is a special case** — the user explicitly called it out: "you can dissect FlatButton as this may be relevant to having a variation button in our theme, im unsure. do it for research purposes." Even though it's editor-only in upstream, NeoCade uses the name as a Button type variation, so it's worth the research investment for design context.
- **Runtime-first is non-negotiable** — verbatim quote: "This needs to support runtime first and foremost, editor is secondary. So absolutely dont use Editor related api such as EditorSettings." This applies to all of NeoCade, but is foreshadowed by Phase 1 because the dissection target IS editor-bound — the dissection doc must explicitly flag every editor-API touchpoint upstream uses, so downstream phases never accidentally port editor-bound code.
- **Use NeoCade's own custom palette and styles, not Godot's** — explicit user reinforcement of PROJECT.md hard constraint ("godot-minimal-theme is benchmark, NOT visual reference"). Phase 1 enumerates upstream's color values and formulas as **reference**; NeoCade's color values are independently designed in Phase 3.

</specifics>

<deferred>
## Deferred Ideas

- **Diff against Godot 4.6 bundled "Modern" editor theme** — open per SOURCES.md but not in Phase 1 scope. Deferred to a follow-up spike (or v1.x) if the diff turns out to matter for editor-coverage parity work.
- **Editor-only theme types catalog** (MainScreenButton, BottomPanelButton, EditorInspectorCategory, EditorProperty, etc.) — explicitly out of scope per user's "user-facing only" decision. Deferred to a future v1.x editor-coverage spike if/when v1.x picks up editor parity.
- **Run upstream's script in a real Godot 4.6 editor and dump resolved theme entries to JSON** — option B in the methodology question. Not chosen (formula extraction is more useful than one runtime snapshot), but the captured-snapshot output would be a quick add if Phase 4 token-design or Phase 10 COV-10 wants a concrete value comparison reference. Hold for that signal.
- **Mine upstream's icon set inventory as a NeoCade icon-design starting point** — out of scope for Phase 1 (we enumerate icon REFERENCES, not visual design). NeoCade's bespoke icons are designed independently in Phase 4 (ICON-01..04). Phase 1 documents what icon slots upstream uses; Phase 4 designs the actual SVGs.

</deferred>

---

*Phase: 1-Source-Dive — godot-minimal-theme `.tres` Dissection*
*Context gathered: 2026-05-04*
