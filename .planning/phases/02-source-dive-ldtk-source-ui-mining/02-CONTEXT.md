# Phase 2: Source-Dive — LDtk Source UI Mining - Context

**Gathered:** 2026-05-04
**Status:** Ready for planning

<domain>
## Phase Boundary

Mine LDtk's Haxe + SCSS + asset source under `C:\Programming_Files\ldtk-master\` for concrete UI implementation patterns and post-release lessons-learned, so NeoCade's "polished UI" claim is anchored to a real polished UI rather than imagined ones. Output: research artifact(s) under `.planning/research/` + SOURCES.md updates. **No `.tres` styling commits.**

**In scope:**
- Comprehensive file-by-file pass through `src/electron.renderer/` UI directories — primarily `ui/` (40+ Haxe files), `ui/modal/`, `ui/palette/`, `ui/vp/`, plus `page/Editor.hx` (the main editor page that wires the chrome together).
- Each file gets at minimum a one-line UI-pattern summary; promising files get full pattern extraction with file:line citations.
- SCSS palette + chrome conventions in `app/assets/css/app.scss` (10,819 lines) — extract beyond the lines 1-24 already known to ARCHITECTURE.md (panel collapse, modal flow, status indicators, tinted-sidebar implementation, button groups, focus chrome, hover/active conventions).
- Asset inventory + visual preview of `app/assets/icons/` SVG icons (silhouette + stroke conventions inform NeoCade's bespoke set as inspiration only). Aseprite + atlas files catalogued as "sprite-sheet, not adoptable." `res/fonts/` rejection re-confirmed.
- `docs/CHANGELOG.md` audit for UI lessons learned — what shipped, what was reverted, what design decisions surfaced post-release.
- Confirm or refute LDtk-related claims in user's prior research report (Source 8 in SOURCES.md): Material Design SVG icons, Endesga32 for level tiles, etc.
- Anti-cyberpunk filter audit — for each adopted pattern, confirm it doesn't drag synthwave/neon-noir aesthetic with it.
- Output: ONE research artifact + SOURCES.md Sections 2 (LDtk web docs) + 3 (LDtk source) updated.

**Out of scope (explicit):**
- Any `.tres` styling commits in `addons/neocade_theme/` — Phase 2 is research-only; first styling commits gated on Phase 3 mockup approval.
- Lifting LDtk's numeric SCSS values verbatim into NeoCade — values are tuned for Heaps/Electron, not Godot/StyleBoxFlat (Pitfall 6.1 cousin).
- **Verbatim lifting** of LDtk's specific values — copying `$bgDark: #1e2229` into NeoCade's surface palette, redrawing LDtk's specific icons 1:1, copying `$orange: #ffcc00` as NeoCade's primary accent, etc. **Pattern-level inspiration mining IS in scope** (per D-01, D-05, D-12) — extract conventions like "single warm accent against neutral ramp", "icons use silhouette discipline + N px stroke weight", "tinted panel headers", "modal flow with darkened backdrop overlay" with file:line citations. Phase 3 mockup designer decides which patterns to translate into NeoCade's independent design language. The line is: **patterns ✓, specific values ✗.**
- Heaps engine architecture + LDtk's Haxe-specific abstractions — read for behavior intent, not for porting.
- Bitmap atlas font architecture (BMFont, `noto_sans_display_*.png/.xml`) — Pitfall 5.4 already rejects in v1.
- `pixel_berry.png` and any pixel-font usage — HD-only constraint already rejects.
- Heaps-specific UI primitives that don't map to Godot Theme/StyleBoxFlat — research-only mention if at all.
- `.tres` translation as a binding spec — translation sketches included where obvious are **inspiration only**, never spec.
- Phase 1 territory (godot-minimal-theme dissection) — already complete.
- Phase 3 territory (mood-board photo curation, palette mockups, typography mockups).

</domain>

<decisions>
## Implementation Decisions

### Mining Depth & Breadth
- **D-01:** **Comprehensive file-by-file pass.** Closes the SOURCES.md Source 3 "must read all of it" mandate the user explicitly stated in PROJECT.md. Every `.hx` file under `src/electron.renderer/ui/`, `ui/modal/`, `ui/palette/`, `ui/vp/` gets at least a one-line UI-pattern summary. Files that surface adopt-worthy patterns get full extraction (file:line citations + UI behavior + adopt/reject reasoning).
- **D-02:** **`page/Editor.hx`** is mined as the chrome-wiring file (it composes the visible panels/sidebars/toolbars). `App.hx` + `Boot.hx` skipped beyond a frontmatter scan (bootstrapping, not UI patterns). `Tool.hx` + `tool/` mined for tool-button conventions.
- **D-03:** **Active verification step** — after the file-by-file pass, do a grep audit for visual-chrome features that may have been missed: gradients, drop-shadow declarations, transition/animation rules, focus-ring conventions, hover state declarations in SCSS. Mirrors Phase 1's 80-class active-verification audit discipline.
- **D-04:** **Minimum thresholds:** ROADMAP says ≥8-12 patterns adopted, ≥3-5 patterns rejected. Phase 2 is expected to far exceed both — comprehensive mining likely surfaces 20+ adoptable patterns + 10+ explicit rejections. Underage on either threshold blocks phase verification.

### LDtk's Status (re-affirmed, mining stays loose-inspiration scoped)
- **D-05:** **LDtk is loose inspiration, not a spec source of truth.** User's explicit guidance, reinforced 2026-05-04. This shapes every other decision below — the artifact's tone, translation depth, and adoption framing all stay "here's what LDtk does, here's a non-binding sketch of how it could land in NeoCade — Phase 3 designer's call."
- **D-06:** Comprehensive depth (D-01) does NOT promote LDtk to spec depth. The mining is exhaustive but the adoption posture stays curated. "Read everything → adopt selectively → write it down with file:line so we can re-check later."

### Asset Mining Handling
- **D-07:** **Inventory + visual preview of SVG icons.**
  - `app/assets/icons/*.svg` (~80 files like `arrow_down.svg`, `autoLayer.svg`, `bug.svg`, `add.svg`, `close.svg`, etc.) — every file catalogued (path + dimensions + role). Each visually opened so silhouette + stroke conventions inform NeoCade's bespoke SVG set design language **as inspiration only**. Specific design moves to extract: stroke weight discipline, corner/end-cap conventions, fill-vs-stroke rules, accent-color usage if any.
  - `res/atlas/*.aseprite` (`appElements.aseprite`, `icons.aseprite`) — catalogued as "sprite-sheet source, not directly adoptable." Inventory + role-description; no decompose to PNG.
  - `res/fonts/*.png/.xml` — bitmap atlas font; Pitfall 5.4 rejection re-confirmed inline. No further action.
  - `app/assets/fonts/` — if exists, scanned for what runtime fonts ship to verify the SCSS font-family declarations.
- **D-08:** Adopt-or-reject on icons stays at "silhouette/stroke discipline" level. **No copying** — NeoCade icons are independently designed in Phase 4 (ICON-01..04). Phase 2 documents what aesthetic LDtk's icons exemplify; Phase 4 designs against that brief.

### Output Artifact Structure
- **D-09:** **Single new artifact:** `.planning/research/LDTK-UI-MINING.md`. Not multi-doc like Phase 1 — Phase 1 split because the dissection target was a 1118-line `.tres` requiring exhaustive enumeration (description vs analysis). Phase 2 is curated mining for inspiration; one synthesis doc reads better than fragments.
- **D-10:** **Sections inside `LDTK-UI-MINING.md`:**
  1. Provenance (path + size + line counts of source files mined + ISO date).
  2. Scope & method (what was read; how patterns were judged adopt/reject; anti-cyberpunk filter discipline).
  3. UI Pattern Catalogue (the adopted patterns — file:line cited + behavior + non-binding NeoCade translation sketch where obvious).
  4. Rejected Patterns (what we explicitly do NOT carry forward + reasoning).
  5. CHANGELOG Lessons-Learned (versioned UI iteration history; what was added then removed; design decisions that surfaced post-release).
  6. Asset Inventory (SVG icons + aseprite atlases + fonts; with visual-preview commentary on the icons).
  7. Anti-cyberpunk filter audit (per-adopted-pattern check that no synthwave drift sneaks in).
  8. Verification of user's prior research report's LDtk claims (Source 8 cross-reference: Material Design SVG icons, Endesga32, etc. — confirmed/refuted).
  9. Open questions (carried forward to Phase 3+ if any LDtk pattern needs design-side resolution).
- **D-11:** **SOURCES.md updates:**
  - Section 2 (LDtk web docs) — confidence raises from MEDIUM to HIGH or MEDIUM-HIGH; "What's still open" entries closed or updated.
  - Section 3 (LDtk source) — confidence raises from LOW to HIGH; all four current "still open" items closed (UI patterns end-to-end, atlas conventions, CHANGELOG end-to-end, prior-report claim verification); new findings link into `LDTK-UI-MINING.md`.

### Translation Depth
- **D-12:** **Translation column where obvious, descriptive otherwise — every translation tagged "inspiration sketch, not spec."**
  - Where the StyleBoxFlat / Godot Theme mapping is free and uncontroversial (e.g., "tinted panel header → `PanelContainer` type variation with `bg_color = role.primary.lerp(surface, 0.85)`"), include a brief translation sketch.
  - Where translation requires Phase 3 mockup decisions (palette, typography, spacing scale not yet locked) or Phase 5+ implementation choices, leave it as an open Phase 3+ design question rather than guessing.
  - **Mandatory wording prefix on every translation note:** "*Inspiration sketch — Phase 3 mockup or Phase 5+ designer's call.*" Prevents downstream phases from treating LDtk-derived sketches as authoritative.
- **D-13:** Translation sketches are NOT a substitute for `DESIGN_TOKENS.md` (Phase 3) or per-phase implementation plans (Phase 5+). They're inspiration-grade only.

### Provenance & Methodology
- **D-14:** **Provenance recorded** at the top of `LDTK-UI-MINING.md`: source root path (`C:\Programming_Files\ldtk-master\`), key file paths + line counts (verified at mining time), ISO date the mining was performed, LDtk version (from `version.txt` or `package.json` — record explicitly), git commit SHA if a `.git` directory exists in the LDtk source clone (otherwise note "no commit SHA available — version-only").
- **D-15:** **File:line citation discipline** — every adopted pattern entry MUST cite at least one specific file path + line range (e.g., "tinted sidebar implementation: `src/electron.renderer/page/Editor.hx:120-145`; SCSS rule: `app/assets/css/app.scss:3245-3260`"). Phase 1 standard re-applied.
- **D-16:** **Anti-cyberpunk filter** — for each candidate-adopted pattern, document one line confirming it doesn't drag synthwave/neon-noir aesthetic with it. Patterns that fail the filter go into Rejected with reasoning. Forces the mining to stay aligned with NeoCade's "vibrant arcade hall by day" anchor.

### CHANGELOG Audit Approach
- **D-17:** **Targeted-but-thorough CHANGELOG audit.** Read `docs/CHANGELOG.md` end-to-end, but extract ONLY UI-relevant entries (skip parser/exporter/format-version/data-spec entries — those are LDtk's content domain, not UI). Tag each extracted entry with version + date + UI category (chrome / modal / icon / interaction / focus / accessibility / typography). Promise: every reverted UI change gets called out — those are the highest-value lessons.

### Verification of Prior Report's LDtk Claims
- **D-18:** **Cross-check user's research report's LDtk claims** (per SOURCES.md Source 3 open item #4 + Source 8 reference). Specifically verify: (a) "uses Material Design SVG icons" — true/false based on actual icon files; (b) "uses Endesga32 for level tiles" — relevant only if LDtk mixes UI palette with content palette; (c) any other LDtk-specific claim in the prior report that the comprehensive mining touches. Each verification anchored to file:line evidence.

### Claude's Discretion
- Exact file-walking order (alphabetical / category-grouped / importance-ordered) — pick what aids readability of the catalogue.
- Whether to use grep + manual reading vs. a one-shot Haxe parser — both acceptable; manual reading is fine if a parser would burn more time than it saves.
- Whether to include a glossary section explaining LDtk-specific terminology (Heaps, Electron, hxml build, atlas baking) — recommended for downstream readers unfamiliar with the stack; Claude's call.
- How to subdivide Section 3 (UI Pattern Catalogue) — by UI region (sidebar / modal / toolbar / status / context-menu) vs by NeoCade Control affinity (Tree / TabBar / Popup / Button / Panel) vs alphabetical. Pick what makes Phase 5+ implementation-time lookups easiest.
- Whether to include screenshots from a running LDtk instance to anchor the patterns visually — out of strict scope but allowed if cheap; do NOT spin up Electron / Heaps for this.

</decisions>

<canonical_refs>
## Canonical References

**Downstream agents MUST read these before planning or implementing.**

### Mining target (the source being mined)
- `C:\Programming_Files\ldtk-master\` — repo root. License: MIT. Heaps/Electron (Haxe). Includes README + LICENSE + tests + docs.
- `C:\Programming_Files\ldtk-master\src\electron.renderer\` — UI implementation root. Subdirs: `ui/` (Modal.hx, ContextMenu.hx, Notification.hx, ToolPalette.hx, CommandPalette.hx, EntityInstanceEditor.hx, FieldDefsForm.hx, FieldInstancesForm.hx, RulePatternEditor.hx, Tip.hx, Tileset.hx, Cursor.hx, etc.), `ui/modal/` (Dialog.hx, Panel.hx, ContextMenu.hx, DebugMenu.hx, Progress.hx, MetaProgress.hx, ToolPalettePopOut.hx, dialog/, panel/), `ui/palette/`, `ui/vp/`, `tool/`, `page/` (Editor.hx, Home.hx, CrashReport.hx, Updating.hx).
- `C:\Programming_Files\ldtk-master\app\assets\css\app.scss` — main SCSS (10,819 lines). Already partially mined for palette (lines 1-24); rest of file is the comprehensive mining target.
- `C:\Programming_Files\ldtk-master\app\assets\icons\` — runtime-shipped SVG icons (~80 files including arrow_down.svg, autoLayer.svg, bug.svg, alpha.svg, appUpdate.svg, etc.). Inventory + visual preview target.
- `C:\Programming_Files\ldtk-master\res\atlas\` — `appElements.aseprite` + `icons.aseprite`. Inventory only; not decomposed.
- `C:\Programming_Files\ldtk-master\res\fonts\` — bitmap atlas Noto Sans + pixel_berry. Rejection re-confirmation only.
- `C:\Programming_Files\ldtk-master\docs\CHANGELOG.md` — UI lessons-learned audit target.
- `C:\Programming_Files\ldtk-master\version.txt` — LDtk version pin for provenance.
- `C:\Programming_Files\ldtk-master\app\package.json` — Electron + dependency versions; useful for understanding the runtime stack only (NOT for adoption).

### NeoCade project canon (already authoritative for this phase)
- `.planning/PROJECT.md` — "LDtk is the quality/polish benchmark, NOT visual copy" (hard constraint); "must read all of it for UI" mandate (Source Coverage table); Research Charter mandates evidence-grade citations with file paths + specific values.
- `.planning/REQUIREMENTS.md` — RES-02 (Phase 2 mines `src/electron.renderer/` for UI implementation patterns; appended to SOURCES.md); DOCS-05 (continuous SOURCES.md updates).
- `.planning/ROADMAP.md` Phase 2 Success Criteria — five concrete deliverables drive the Phase 2 plan: ≥8-12 patterns adopted with file:line refs, ≥3-5 rejections with reasoning, CHANGELOG-derived lessons learned, asset inventory + adoptability decision, findings committed + SOURCES.md updated + no `.tres` commits.
- `.planning/research/SUMMARY.md` Phase 2 Rationale — initial pass extracted only `app.scss` lines 1-24; comprehensive UI mining was explicitly deferred to this phase.
- `.planning/research/SOURCES.md` Sections 2 (LDtk web docs) + 3 (LDtk source) — to be updated in place. Section 3 currently LOW confidence with 4 explicit "still open" items; Phase 2 closes all four.
- `.planning/research/SOURCES.md` Section 8 (user's prior research report) — claims about LDtk that this phase verifies/refutes against actual source.
- `.planning/research/STACK.md` — confirms Godot 4.6 has mature dynamic TTF/VF support (re-confirms BMFont rejection); StyleBoxFlat is the chrome primitive; AA requires `corner_radius >= 2`.
- `.planning/research/FEATURES.md` — 35-class coverage matrix + 13 type variations; LDtk patterns get mapped to Control affinity where relevant (e.g., LDtk's modal → NeoCade's PopupPanel/AcceptDialog/Window family).
- `.planning/research/PITFALLS.md` — Pitfall 5.4 (BMFont in v1 rejected); Pitfall 1.7 (popup separate-Window theming, confirmed by Phase 1) — Phase 2's modal-pattern mining feeds into NeoCade's popup design discipline; Pitfall 7.x (anti-cyberpunk drift detection rituals).
- `.planning/research/ARCHITECTURE.md` — already has palette extraction from `app.scss` lines 1-24 (Cabinet Chrome anchor); deeper SCSS mining must reconcile against ARCHITECTURE Section 1 + Section 7 (anti-cyberpunk rules).
- `.planning/research/CROSS-PLATFORM.md` — relevant if LDtk patterns inform mobile-variant authoring.
- `.planning/phases/01-source-dive-godot-minimal-theme-tres-dissection/01-CONTEXT.md` — Phase 1 standards re-applied in Phase 2: provenance discipline, file:line citation discipline, anti-cyberpunk filter, three-output split philosophy (here collapsed to one + SOURCES.md updates per D-09 reasoning).
- `.planning/research/MINIMAL-THEME-DISSECTION.md` (Phase 1 output) — reference for tone/depth standard; Phase 2 mirrors discipline at lighter touch (synthesis vs enumeration).

</canonical_refs>

<code_context>
## Existing Code Insights

### Reusable Assets
- **None directly applicable to Phase 2.** Phase 2 produces research artifacts (`.md` docs in `.planning/research/`); it does NOT touch `addons/neocade_theme/` or any source code.
- The empty Theme scaffold at `addons/neocade_theme/neocade_theme.tres` (3 lines) is intentionally untouched by Phase 2 — first styling commits gated on Phase 3 mockup approval.

### Established Patterns
- **SOURCES.md Section structure** (`What was read` / `What we adopted` / `What we rejected` / `What's still open` / `Confidence in coverage`) — Phase 2 follows this exact structure for Sections 2 + 3 updates. Section 3's existing "still open" items get closed; confidence raised LOW → HIGH.
- **Phase 1 provenance pattern** (path + SHA-256 hash + line count + ISO date) — Phase 2 records the LDtk source root + version pin (no SHA-256 since it's a directory tree, not a single file; per-file line counts at mining time + LDtk version + ISO date suffice).
- **Phase 1 file:line citation discipline** — every adopted pattern in Phase 2's catalogue cites at least one `path:line-range`. Same standard re-applied.
- **Phase 1 description vs analysis split** — collapsed into a single doc here per D-09 because Phase 2 is curated mining (synthesis), not exhaustive enumeration. Synthesis is integrated; enumeration would have been split.
- **Date stamping convention** — every research doc lists "Authored: YYYY-MM-DD" / "Researched: YYYY-MM-DD." Phase 2 follows.
- **Research artifact location** — `.planning/research/*.md` for synthesized research; `.planning/research/SOURCES.md` for the per-source dossier. Phase 2 follows both conventions.

### Integration Points
- **SOURCES.md Section 2** (LDtk web docs) — existing "still open" entries on specific component API patterns and color application rules get resolved by Phase 2.
- **SOURCES.md Section 3** (LDtk source) — all four "still open" items closed (UI patterns end-to-end, atlas conventions, CHANGELOG end-to-end, prior-report claim verification); confidence raised LOW → HIGH.
- **SOURCES.md Section 8** (user's prior research report) — LDtk-specific claims verified/refuted with file:line evidence.
- **ARCHITECTURE.md Section 1** — Cabinet Chrome palette anchor (already partially derived from `app.scss` lines 1-24). Phase 2's deeper SCSS mining may surface additional anchor values that inform Phase 3 mockup work.
- **Phase 3 (downstream consumer)** — mood-board sub-spike + palette mockups will reference Phase 2 patterns when justifying booth chrome / panel header / context-menu visual decisions.
- **Phase 5+ (downstream consumer)** — implementation phases reference Phase 2's pattern catalogue for "what does polished focus chrome / popup header / button group conventions look like" inspiration. Translation sketches in the catalogue are non-binding starting points.

</code_context>

<specifics>
## Specific Ideas

- **User's verbatim guidance, 2026-05-04:** *"LDtk is used as a loose inspiration resource. Not a full spec and source of truth."* Applies across the entire artifact's tone. Comprehensive depth (D-01) does not promote LDtk to spec; the mining is exhaustive but adoption stays curated and clearly tagged "inspiration sketch — Phase 3+ designer's call."
- **User's PROJECT.md mandate:** *"must read all of it for UI"* (Source Coverage Commitment table). Phase 2 closes this — comprehensive file-by-file pass through `src/electron.renderer/` is the explicit close-out.
- **Pre-extracted reference values** (already in ARCHITECTURE.md Section 1 from initial pass): `$bgDark: #1e2229; $bgMed: #2e333f; $bgLight: #545d73; $orange: #ffcc00; $almostWhite: ...`. Phase 2's deeper SCSS mining works WITH these (do not re-extract; do extend).
- **Pre-rejected items** (no need to revisit): bitmap atlas fonts, `pixel_berry.png`, Heaps engine architecture, color-by-function-tinted sidebars (LDtk-specific editor mode), fixed Endesga32 palette for content. Re-confirmation in passing only.
- **Anti-cyberpunk filter required** — every adopted pattern must clear the filter. ARCHITECTURE Section 7's 12 forbidden moves (chromatic aberration, scanlines, grid overlays, glow halos, drop-shadow on text, monospace body, pure-black surfaces, ALL CAPS body, sci-fi terminology, hex-grid backgrounds, fake circuitry, "TRANSMISSION/SYSTEM" labels) are the audit checklist.
- **LDtk's comparison advantage over godot-minimal-theme** — minimal theme is editor-focused and mono-accent; LDtk is a polished application UI with multi-color content tints, modal flow, status bars, context menus. Different complementary inspiration sources. Phase 2 surfaces what's unique to LDtk that minimal theme didn't.
- **SVG icon set is the most likely-adoptable asset.** ~80 SVGs in `app/assets/icons/` cover most of NeoCade's expected slot list (arrow_down/up/left/right, add, close, alpha, bug, autoLayer, etc.). Inspect for stroke discipline + silhouette conventions; do NOT copy specific designs. NeoCade's bespoke icons (Phase 4 ICON-01..04) are independently designed against the inspiration brief.

</specifics>

<deferred>
## Deferred Ideas

- **Decompose `appElements.aseprite` and `icons.aseprite` to PNG slices for visual reference.** Aseprite files are sprite-sheet sources requiring Aseprite or compatible tooling to slice. Out of Phase 2 scope (D-07). If Phase 3 mood-board sub-spike or icon-design work in Phase 4 needs visual access to LDtk's atlas content, that's where to do it — with explicit "still loose inspiration only" framing.
- **Spin up running LDtk instance for live UI screenshots.** Out of strict scope (D-Claude's Discretion). Heaps + Electron build chain isn't necessary for source-level mining. If Phase 3 mockup work wants live visual reference, screenshots-of-LDtk-running can be captured then (not in Phase 2).
- **Diff against earlier LDtk versions to study evolution.** CHANGELOG audit (D-17) covers what shipped + reverted; an actual checkout-and-diff-old-version pass is out of scope. Defer to v1.x if a specific UI evolution question arises.
- **Mine LDtk's Tip / Notification patterns as direct inputs for NeoCade's Tooltip behavior.** Phase 7 (Popups + Advanced) is where TooltipPanel/TooltipLabel get themed; Phase 2 documents the patterns, but the Phase 7 designer chooses whether to adopt them. Don't pre-decide here.
- **LDtk's CommandPalette + QuickSearch UI patterns as a NeoCade Showcase scene addition.** Out of phase scope (Phase 9 is Showcase). Note in Phase 2 if the patterns are adopt-worthy; defer the actual addition.
- **Translate every LDtk pattern to a binding StyleBoxFlat spec.** Per D-12 + user's "loose inspiration" guidance — translations stay non-binding sketches. Binding specs are Phase 3 mockup work + Phase 5+ implementation plans.
- **Build a visual style comparison between LDtk's chrome and NeoCade's three palette directions (Midnight Marquee / Boardwalk Sunset / Cabinet Chrome).** Phase 3 mood-board / palette mockup territory. Phase 2 may flag observations but does not produce the comparison.

</deferred>

---

*Phase: 2-Source-Dive — LDtk Source UI Mining*
*Context gathered: 2026-05-04*
