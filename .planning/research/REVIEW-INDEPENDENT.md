# Independent Review — NeoCade Theme Planning Docs

**Date:** 2026-05-04
**Reviewer:** independent (no prior conversation context)
**Files reviewed:**

| File | Lines |
|---|---|
| `.planning/PROJECT.md` | 234 |
| `.planning/research/SUMMARY.md` | 341 |
| `.planning/research/SOURCES.md` | 513 |
| `.planning/research/STACK.md` | 300 |
| `.planning/research/FEATURES.md` | 960 |
| `.planning/research/ARCHITECTURE.md` | 577 |
| `.planning/research/PITFALLS.md` | 1246 |
| `.planning/research/CROSS-PLATFORM.md` | 945 |
| (Inputs spot-checked: `inputs/NeoCade-Research-Report.md`, `inputs/NeoCade-Theme-Prototype.png`) | — |

## Verdict

- **CRITICAL issues:** 4 (must-fix before REQUIREMENTS.md)
- **MAJOR issues:** 7 (should fix; reconcilable)
- **MINOR issues:** 5 (cosmetic; fix later or ignore)
- **Goal coverage:** ~94% (16 of 17 PROJECT.md Active requirements have concrete research backing; 1 partially covered — see G/H below)

The research is dense, well-cited, and disciplined about hard constraints. The core stack/feature/architecture story is internally consistent on the high-confidence axes (Godot 4.6 API, control coverage, WCAG math, license compliance, anti-cyberpunk discipline). However, the post-CROSS-PLATFORM addendum was bolted onto SUMMARY.md without propagating downward — leaving SUMMARY internally inconsistent (its own phase numbering doesn't match between the high-level list and the detailed sections), and leaving a real font-stack contradiction between SUMMARY/STACK and CROSS-PLATFORM/ARCHITECTURE on whether Outfit ships in v1. PITFALLS.md also contains one self-contradicting line about shadows that violates the locked policy. These are the must-fix items before REQUIREMENTS.md.

---

## CRITICAL Findings

### CRIT-1 — Font stack contradiction: Outfit in v1 vs Outfit deferred

**Evidence:**
- `SUMMARY.md` lines 122-130 (Conflict 1 resolution): "**Decision: STACK.md wins for v1 — no third font in v1.** ... Inter Display via `opsz=32` is a factually free move ... Outfit adds ~210 KB ... Surface as a mockup-gate question, not a research-time question. The typography mockup phase produces 2 variants (A: Inter-only with `opsz` engagement; B: Inter body + Outfit headings); user picks at typography approval gate."
- `SUMMARY.md` line 183: "**Typography (default):** Inter Variable upright + Inter Italic Variable + Noto Sans Variable."
- `SUMMARY.md` line 233 (Phase 4 deliverables): "Inter VF + Inter Italic VF + Noto Sans VF + `OFL.txt`" — no Outfit.
- vs `ARCHITECTURE.md` lines 211-226: Outfit is **PRIMARY** display font; "Final stack (in `default_font.fallbacks` order): 1. **Outfit** ... 2. **Inter** ... 3. **Noto Sans + Noto Sans CJK + Noto Sans Arabic**"
- vs `ARCHITECTURE.md` lines 245-253 (type scale): `display-small`/`headline-small` use **Outfit** as the font in the canonical type-scale table.
- vs `CROSS-PLATFORM.md` lines 19, 74-75, 145, 538, 558, 595-596, 828-829: Outfit is treated as a v1 bundled font throughout, including in `OFL.txt` template. CROSS-PLATFORM line 829 explicitly says: "**Recommend defer Inter Italic to v1.x and add Outfit in v1** — shipped size ~1.85 MB."
- vs `SOURCES.md` line 14 (CROSS-PLATFORM addendum): "Inter, Noto Sans, **Outfit**, JetBrains Mono are all OFL 1.1" — Outfit listed with the v1 bundle.
- `SOURCES.md` line 473 (open question): "Whether to ship Inter Italic in v1 (~+0.85 MB) or defer."

**Why critical:** The user prompt explicitly flagged this exact contradiction. PROJECT.md Constraints (line 122) lists Inter + Noto Sans as primary stack and gives research permission to "add a tertiary display font but cannot replace the primaries." So adding Outfit is permitted in principle, but two of the four research dimensions (ARCHITECTURE, CROSS-PLATFORM) treat Outfit as a v1 default while the synthesizer (SUMMARY) explicitly resolved Conflict 1 against shipping it in v1. Whichever way the project lands, the docs cannot ship in this state — implementers will follow ARCHITECTURE's type-scale table and bundle Outfit, while the synthesis claims they shouldn't.

**Suggested fix:** Pick one. Since CROSS-PLATFORM was authored *after* the SUMMARY conflict resolution, and CROSS-PLATFORM line 828-829 says "CROSS-PLATFORM concurs but adds: also bundle Outfit Variable" — the post-addendum *de facto* decision appears to be "ship Outfit in v1, defer Inter Italic." Either:
1. Update SUMMARY.md Conflict 1 to flip the decision (Outfit IS bundled in v1; Inter Italic deferred to v1.x). Add an explicit "**Decision changed 2026-05-04 after CROSS-PLATFORM**" marker. Update SUMMARY's phase deliverables (line 233) to list Inter VF + Outfit VF + Noto Sans VF (drop Inter Italic). OR
2. Update ARCHITECTURE.md and CROSS-PLATFORM.md to accept SUMMARY's "no Outfit in v1" decision (revert the type-scale table to Inter-only, strip Outfit from the bundle list and OFL.txt template).

This must be resolved before REQUIREMENTS.md — every requirement that touches typography flows from this decision.

---

### CRIT-2 — SUMMARY.md phase numbering is internally inconsistent (9-phase detail under an 11-phase header)

**Evidence:**
- `SUMMARY.md` line 193: "Updated structure: **11 phases** post-CROSS-PLATFORM."
- `SUMMARY.md` lines 196-208 (high-level list): correctly enumerates Phases 1-11, with Phase 8 = "Mobile Variant Authoring", Phase 9 = "Showcase + Token Gallery + Theme Toggle", Phase 10 = "QA + Cross-Platform Export Validation", Phase 11 = "Distribution".
- vs `SUMMARY.md` lines 210-258 (per-phase detail): only describes phases 1-9, with Phase 8 still labeled "Showcase + Token Gallery + Theme Toggle" (line 250) and Phase 9 still labeled "QA + Distribution" (line 254). There is no per-phase detail block for "Phase 8: Mobile Variant Authoring", no "Phase 10", no "Phase 11".
- `SUMMARY.md` line 263 ("Core (5) → Lists/Layout (6) → Dialogs/Popups (7)"): correct.
- `SUMMARY.md` line 268: "Phases needing per-phase RESEARCH.md: Phase 1 ..., Phase 9 (Asset Library policy verification at submission time)" — references Phase 9 in the OLD numbering (Asset Library = old Phase 9 = new Phase 11).
- `SUMMARY.md` line 270: "Phases with standard patterns (skip research-phase): Phase 4 (Foundation), Phase 5/6/7 ..., Phase 8 (Showcase — well-covered by FEATURES.md Section 5)" — Phase 8 here = OLD Phase 8 (Showcase), but in the new 11-phase list Phase 8 = Mobile Variant Authoring.

**Why critical:** The roadmapper agent will be reading this. The high-level list at line 196 and the per-phase detail blocks at lines 210-258 disagree about what Phases 8-11 are. The "Research Flags" subsection at line 268 references the *old* numbering. A roadmapper that reads only the high-level list and trusts it will produce a roadmap with the wrong dependencies; a roadmapper that reads the detail blocks will miss Mobile Variant Authoring and Cross-Platform Export Validation as standalone phases entirely.

**Suggested fix:** Rewrite the "Implications for Roadmap" section (lines 192-279) end-to-end as 11 coherent phases. Either renumber the existing detail blocks (insert a new Phase 8 = Mobile Variant Authoring detail block; move existing Phase 8 detail to Phase 9; expand existing Phase 9 detail into Phase 10 + Phase 11), or commit to a different number and update the high-level list to match. The current state is a half-applied edit.

---

### CRIT-3 — PITFALLS.md contradicts the locked "no drop shadows in v1" policy

**Evidence:**
- `SUMMARY.md` lines 152-156 (Conflict 3 resolution): "**Decision: FEATURES wins — no drop shadows in v1. Elevation conveyed through color surface ramp ONLY.** ... Designing for a known-broken renderer is not pragmatic."
- `SUMMARY.md` line 185: "**No drop shadows; tonal surface ramp is the elevation system.**"
- `FEATURES.md` line 86 (AF-13): "Drop shadows on panels via StyleBoxFlat shadow ... Godot's StyleBoxFlat shadow is offset-only and renders behind content — reads as 'ghosted clone', not elevation. Looks worse than no shadow."
- `ARCHITECTURE.md` lines 305-318: elevation is via color ramp; "we do **not** use box shadows."
- vs `PITFALLS.md` line 758 (inside Section 7.2 "Drift trigger: glow effects creep in"): "**Use drop shadow, not outer glow, for elevation. Shadows are arcade-native (cabinets cast shadows); glows are synthwave-native.**"

**Why critical:** PITFALLS.md is the document implementers consult when they encounter a visual decision in the wild. Line 758 reads as authoritative guidance to *use* drop shadows for elevation — directly opposite to the synthesis decision. An implementer following PITFALLS.md verbatim will engage the StyleBoxFlat shadow path that PITFALLS.md *itself* flags as a 2× over-rendering bug at section 1.4 / 1.5. This is not just a style mismatch; the contradiction is internal to PITFALLS.md.

**Suggested fix:** Edit `PITFALLS.md` line 758 to align with the locked policy. Replacement copy: "Reserve elevation cues for the tonal surface ramp (color-only). Glows are synthwave-native and forbidden in v1; drop shadows render incorrectly under GL Compatibility (issues #23640, #1.4) and are also forbidden in v1 — see `FEATURES.md` AF-13 and `SUMMARY.md` Conflict 3." Cross-reference both anchors so the next reader doesn't re-introduce the drift.

---

### CRIT-4 — `surface.sunken` taxonomy is inconsistent: rejected by SUMMARY, but still present in FEATURES.md token tables

**Evidence:**
- `SUMMARY.md` lines 132-148 (Conflict 2 resolution): "**Decision: ... Reject `surface.sunken` for v1.** ... `surface.sunken` rejected for v1 — depth-via-color-only philosophy doesn't have a natural sunken story; inputs are visually distinguished via focus/normal stylebox + corner radius."
- `SOURCES.md` line 342: "REJECT `surface.sunken` for v1."
- vs `FEATURES.md` line 16: "Surface tokens are correct in spirit but missing one rung — Base/Secondary/Panel/Raised/Elevated covers backgrounds but lacks an 'overlay' token for popups and a 'sunken' token for inputs. Add `surface.sunken` and `surface.overlay`."
- `FEATURES.md` line 491: `surface.sunken | #0A0C11 | NEW vs prototype — text inputs, tree backgrounds (look "carved into" base)` — actively defines the rejected token in the canonical token table.
- `FEATURES.md` line 911: "ADD both" (sunken and overlay) — listed under "Prototype Gaps (adjust)."
- `FEATURES.md` Section 3.6 (line 600+) shows a 6-rung elevation ladder using `surface.overlay` but does not show `surface.sunken` as a level — internally half-reconciled.

**Why critical:** The canonical token table in FEATURES.md (Section 3.1, lines 482-501) is what implementers will copy into the `@tool` generator script's `TokenSet` constants block (per CROSS-PLATFORM 4.2's code sketch). If `surface.sunken` is in that table when the generator is authored, it ends up in both `.tres` files. The "REJECT" decision then exists only in SUMMARY/SOURCES, where the implementer may not look. SUMMARY explicitly flagged that "FEATURES has been (or should be) reconciled" — it has not.

**Suggested fix:** Edit `FEATURES.md` to either (a) strike `surface.sunken` from line 16, line 490-491, line 911, and any other token tables, replacing references with "input fields visually distinguished via focus/normal stylebox + corner radius (per SUMMARY Conflict 2 resolution)"; or (b) overturn the synthesis decision with explicit reasoning. Option (a) is faster and aligns with synthesis; option (b) needs more work and is not justified by the evidence I see.

Also note: FEATURES.md line 491 also defines `text.placeholder` and other tokens that aren't in SUMMARY's friendlier-alias table at line 138-148 — review the full token list for parity, not just `surface.sunken`.

---

## MAJOR Findings

### MAJ-1 — "VirtuCade" leak in PROJECT.md "What This Is" section

**Evidence:** `PROJECT.md` line 7: "The theme is built primarily to power the author's upcoming game **VirtuCade**..." This is correct *contextual* mention (VirtuCade is the consuming game). However, line 67 says: `.NET / C# enabled (`project/assembly_name="NeoCade Theme"`)` — verifies the project's own internal name is NeoCade, good.

This is not a hard-constraint violation (line 7 properly distinguishes theme vs game), but I flag it because the user prompt warned about VirtuCade leakage, and one place where it appears OK could prime the next reader to think VirtuCade naming is acceptable in some contexts. Recommend tightening line 7 to: "The theme is built primarily to power the author's upcoming game (codename: VirtuCade)..." or moving the VirtuCade context further down in the document.

**Severity:** MAJOR — strictly pedantic; technically the wording is correct.

---

### MAJ-2 — "Drop drop-shadows on mobile" in STACK.md (line 206) is now inverted by the locked no-shadow policy

**Evidence:**
- `STACK.md` line 206 (under "If extending to mobile in v2"): "Drop drop-shadows on mobile (perf cost on GL Compatibility on Android low-end)."

**Why MAJOR:** This implies shadows exist on desktop primary and are dropped on mobile. The locked policy (no shadows in v1 at all, on either variant) means this guidance is moot. STACK.md was written before the Conflict 3 lock and the mobile→v1 elevation. Now that mobile is v1 must-have and shadows are categorically banned, line 206 is misleading.

**Suggested fix:** Edit STACK.md line 206 to "Continue to forbid drop-shadows on mobile (already forbidden in v1 desktop per Conflict 3 / AF-13; perf cost on GL Compatibility Android low-end is an additional reason)." Or remove the bullet entirely.

---

### MAJ-3 — STACK.md "If extending to mobile in v2" framing (lines 203-207) hasn't been updated for mobile-as-v1

**Evidence:** `STACK.md` lines 203-207: an entire "If extending to mobile in v2" subsection still treats mobile as a v2 deferral. Mobile is v1 must-have per PROJECT.md line 29 and CROSS-PLATFORM addendum.

**Suggested fix:** Update STACK.md "Stack Patterns by Variant" section (or rename the subsection to "Mobile variant — v1 must-have") to reflect that mobile is now in v1. Reference CROSS-PLATFORM Section 3 for concrete numerics.

---

### MAJ-4 — FEATURES.md "Future Consideration (v2+)" still lists mobile as future work

**Evidence:** `FEATURES.md` lines 870-873: "**Future Consideration (v2+):** [...] Mobile-tuned variant (`neocade_mobile_theme.tres`)"

**Why MAJOR:** AF-5 (line 78) was correctly stricken with a 2026-05-04 timestamp. But this *separate* "Future Consideration" list at line 872 was not updated and still claims mobile is v2+. A reader who jumps to the MVP/Future tables will get the wrong scope.

**Suggested fix:** Remove the mobile-tuned-variant entry from `FEATURES.md` Future Consideration (line 872). Add a new entry to "Launch With (v1)" reflecting the mobile variant deliverables (matching CROSS-PLATFORM Phase: Mobile Variant Authoring).

---

### MAJ-5 — FEATURES.md MVP "Launch With (v1)" lists 5 phases (Foundation/Core/Lists/Dialogs/Showcase+QA), conflicting with SUMMARY's 11-phase plan

**Evidence:**
- `FEATURES.md` lines 826-861: 5-phase v1 plan (Phase 1: Foundation; Phase 2: Core Controls; Phase 3: Lists & Layout; Phase 4: Dialogs & Advanced; Phase 5: Showcase & QA).
- vs `SUMMARY.md` lines 196-208: 11-phase plan post-CROSS-PLATFORM.

**Why MAJOR:** FEATURES.md's roadmap predates the source-dive spike phases (Phase 1-2 in SUMMARY's numbering), the mockup gate (Phase 3), the Mobile Variant Authoring phase, and the Cross-Platform Export Validation phase. A roadmapper reading FEATURES.md will produce a 5-phase implementation roadmap and miss research phases entirely.

**Suggested fix:** Either (a) rewrite FEATURES.md MVP section to say "See `SUMMARY.md` for current phase decomposition; FEATURES.md only enumerates the deliverables, not the phasing", or (b) update FEATURES.md's MVP phase headers to match SUMMARY's 11-phase plan.

---

### MAJ-6 — ARCHITECTURE.md mockup strategy doesn't include the mandatory mobile mockup step

**Evidence:**
- `ARCHITECTURE.md` lines 386-453 (Section 6 — Mockup Strategy): describes a 6-step gate flow (3 palettes → typography → 1 high-fidelity Control gallery) that produces only desktop mockups.
- vs `CROSS-PLATFORM.md` lines 838-840 (Section 9.3 corrections to ARCHITECTURE.md): "ARCHITECTURE.md Section 6 mockup strategy doesn't account for mobile mockups. ADD a Step 5b: produce a mobile-specific mockup (one HTML file showing the same Controls at mobile sizes, with tap-target overlays visible) for user approval, in addition to the desktop full-fidelity mockup."

**Why MAJOR:** CROSS-PLATFORM identified this gap and prescribed the fix, but ARCHITECTURE.md itself was not edited. A reader of ARCHITECTURE.md alone will miss the mobile-mockup gate step. Mockup approval is the mandatory blocker before `.tres` work begins; this gap could cause Phase 4 onwards to start with mobile design unapproved.

**Suggested fix:** Edit ARCHITECTURE.md Section 6 to add Step 5b mobile mockup, inline. Or add a 2026-05-04 addendum block at the end of Section 6 referencing the CROSS-PLATFORM correction.

---

### MAJ-7 — Editor-vs-runtime coverage is implicit; users won't know which Editor surfaces NeoCade themes

**Evidence:**
- `PROJECT.md` line 26: "**Universal usage**: theme works correctly in both Godot Editor and game runtime."
- `FEATURES.md` line 79 (AF-6): editor-only types (FlatButton, MainScreenButton, BottomPanelButton, EditorInspector*) are deferred to v1.x.
- `SOURCES.md` line 39: "Editor-only theme types — minimal theme styles `FlatButton`/`MainScreenButton`/`BottomPanelButton`/`EditorInspector*` etc. NeoCade v1 scopes to user-facing public Control hierarchy only (FEATURES.md AF-6); editor parity is v1.x."
- `PITFALLS.md` 2.2: documents that the project theme leaks into editor contexts (LineEdit override breaks editor LineEdits).

**Why MAJOR:** PROJECT.md says "Universal" coverage. AF-6 + SOURCES caveats reduce Editor coverage to "the public Control hierarchy that the user-facing 35 classes already cover, plus whatever the editor renders that uses those classes." That's defensible — but the docs don't explain *which Editor surfaces are themed* and *which fall back to default*. A user setting NeoCade as an editor theme will be surprised when (e.g.) the Inspector chrome stays default while LineEdits change. PITFALLS.md 2.2 documents the leak risk; nothing documents the coverage map.

**Suggested fix:** Add a small subsection to FEATURES.md (or a new file `EDITOR-COVERAGE.md`) that lists, with concrete examples: "When NeoCade is applied as editor theme, these surfaces are themed: [LineEdit, Button, Tree, etc. — basically the 35 user-facing classes]; these are NOT themed in v1: [FlatButton, MainScreenButton, EditorInspectorPlugin, EditorProperty*, BottomPanelButton, etc.]. Plan to address in v1.x." This avoids user surprise and clarifies the AF-6 boundary.

---

## MINOR Findings

### MIN-1 — Confidence Assessment table in SUMMARY.md is stale

**Evidence:** `SUMMARY.md` lines 286-292 has a Confidence Assessment table where the Cross-Platform row reads "**PENDING** | 5th researcher in flight as of this synthesis. SUMMARY.md will be amended before REQUIREMENTS.md is authored." But the addendum landed and the file was extensively amended. The PENDING row should now read HIGH/MEDIUM with a brief summary.

**Suggested fix:** Update the Cross-Platform confidence row.

---

### MIN-2 — SOURCES.md's "Source coverage commitment" check: source #5 (Real arcade aesthetics) is correctly flagged LOW for visual reference, but no source-dive spike phase appears in the 11-phase plan to *collect* the photos

**Evidence:** `SOURCES.md` line 488-498 (Summary table): Source #5 says "**Phase 3 sub-spike: real-arcade reference photo collection**". `SUMMARY.md` line 198 (Phase 3) does mention "real-arcade reference photo collection" inline. Consistent — but it's bundled into Phase 3 along with mockup production and MCP/QA tooling baseline. That's a lot of work in one phase. Recommend the roadmapper split if Phase 3 grows.

**Suggested fix:** Flag at roadmap time. Not a doc bug.

---

### MIN-3 — STACK.md "If extending to light mode in v2" still uses singular "theme" framing, contradicting the now-mandatory two-theme reality

**Evidence:** `STACK.md` lines 209-213 ("If extending to light mode in v2"): "Keep same StyleBox geometry; swap color tokens. Re-verify all WCAG contrast pairs..." This was written when there was one .tres. Now there are two (.tres + mobile.tres). Light mode in v2 means up to 4 .tres files (desktop dark + desktop light + mobile dark + mobile light), unless mobile-light is explicitly out per PROJECT.md line 46.

**Suggested fix:** Note in STACK.md that light mode v2 multiplies across desktop+mobile; PROJECT.md line 46 already flags "Light color mode for mobile variant — mobile theme follows the same dark-only constraint as desktop in v1."

---

### MIN-4 — FEATURES.md says total "39 distinct theme classes" → "32 user-facing" in exec summary line 13, but Section 1 line 92-93 says "42 user-facing... 35 with theme entries"

**Evidence:**
- `FEATURES.md` line 13: "Coverage target. 39 distinct theme classes need entries to match godot-minimal-theme's bar (32 user-facing Controls + 4 editor-only classes + Window + 2 Editor* variations the minimal theme adds). NeoCade matches the user-facing 32 in v1..."
- vs `FEATURES.md` line 93: "**42 user-facing Control classes** across 8 categories. NeoCade v1 styles all that have theme entries (35 classes — content-only Controls like NinePatchRect have none)."
- vs `FEATURES.md` line 205: "**Total user-facing Control classes with theme entries to populate in v1: 35**"

**Why MINOR:** The numbers 32, 35, 42 all appear in the same document for the same concept (user-facing Control classes with theme entries to populate). The detailed enumeration in Section 1 (35) is the most authoritative; the exec summary's "32" is stale.

**Suggested fix:** Update FEATURES.md exec summary line 13 to "35 user-facing Controls with theme entries" to match Section 1.

---

### MIN-5 — Some minor "Outfit display font" leakage in SOURCES.md fonts list

**Evidence:** `SOURCES.md` line 14 (in CROSS-PLATFORM addendum): "Inter, Noto Sans, Outfit, JetBrains Mono are all OFL 1.1 — App Store + Play Store + Web embedding legal" — listed as one of the bundled fonts.

**Why MINOR:** This is the same CRIT-1 issue, but at the SOURCES.md level. SOURCES.md is a dossier, not a decision doc, so the inconsistency is downstream of CRIT-1. Once CRIT-1 is resolved, SOURCES.md must be updated to reflect the chosen direction.

---

## Goal-Coverage Matrix

| PROJECT.md Active requirement | Where addressed | Concrete? | Notes |
|---|---|---|---|
| Exhaustive research & spiking is first-class deliverable | SUMMARY.md "Implications for Roadmap" (11 phases, with research phases 1-3); SOURCES.md "Summary of Source-Dive Spike Recommendations" line 488+ | YES | Internal phase-numbering inconsistency (CRIT-2) |
| Feature-complete Control coverage (godot-minimal-theme bar) | FEATURES.md Section 1 (35 classes), Section 2 (per-class entry matrix) | YES | godot-minimal-theme `.tres` not yet line-by-line dissected (Phase 1 spike) |
| Dark theme v1 | ARCHITECTURE.md Section 1 (3 palette options A/B/C, all dark) | YES | — |
| Universal usage (Editor + runtime) | FEATURES.md AF-6 (editor-only types deferred); PITFALLS.md 2.1, 2.2, 2.3 (editor-runtime divergence) | PARTIAL | MAJ-7: which Editor surfaces are themed vs not is not explicitly mapped |
| HD resolution (sharp at 1080p/1440p/4K) | STACK.md TL;DR Decision 4 (StyleBoxFlat geometry); PITFALLS.md 3.1-3.4 | YES | — |
| Cross-platform export support — all 6 Godot targets | CROSS-PLATFORM.md Section 1 (per-target matrix) | YES | — |
| Mobile-optimized variant (`neocade_mobile_theme.tres`) | CROSS-PLATFORM.md Section 3 (concrete numerics) | YES | MAJ-3, MAJ-4 (legacy "v2" leftovers in STACK/FEATURES) |
| Bundled fonts (Inter + Noto Sans, OFL) | STACK.md "Supporting Libraries"; ARCHITECTURE.md Section 2; CROSS-PLATFORM.md Section 5 (license compliance) | YES | CRIT-1 (Outfit yes/no contradiction) |
| Strict design system documentation | ARCHITECTURE.md Sections 1-5; FEATURES.md Section 3 | YES | CRIT-4 (`surface.sunken` taxonomy unreconciled) |
| Mockup approval gate | ARCHITECTURE.md Section 6; SUMMARY.md Phase 3 | YES | MAJ-6: mobile mockup step missing from Section 6 itself |
| Theme editor authoring | STACK.md "Development Tools" section; PROJECT.md mandate | YES | UD-3 raises tooling question |
| Type variations | FEATURES.md Section 4 (13 variations); PITFALLS.md 1.2 (font inheritance bug warning) | YES | — |
| Showcase scene (`res://main.tscn`) | FEATURES.md Section 5 (9 sections) | YES | — |
| Theme toggle button (NeoCade ↔ Godot default) | FEATURES.md Section 5.1; PITFALLS.md 10.3 | YES | — |
| MCP-driven QA | UD-1 in SUMMARY (GoPeak swap); STACK.md "Development Tools" | YES (with open decision) | UD-1 is open |
| UX/UI styleguide adherence (Material 3) | ARCHITECTURE.md throughout (M3 type scale, state layers, spacing) | YES | — |
| Accessibility (WCAG 2.1 AA) | ARCHITECTURE.md Section 1 (per-palette WCAG tables); PITFALLS.md Section 4 | YES | Per-state-combination accessibility math deferred to Phase 9 |

**Coverage rate:** 16/17 = 94% concrete, 1 partial (Editor coverage map).

---

## Hard-Constraint Audit

| Constraint | Honored across all docs? | Evidence/violation |
|---|---|---|
| Theme name is **NeoCade** (not VirtuCade, CyberCade) | YES across all 7 research files | SOURCES.md Source #8 audit explicitly rejects all "VirtuCade Theme" references; every research file uses NeoCade. PROJECT.md line 7 correctly distinguishes consuming game from theme. (MAJ-1 is a pedantic flag, not violation.) |
| Aesthetic is arcade-friendly, NOT cyberpunk | YES | PITFALLS.md Section 7 (12 forbidden visual moves); ARCHITECTURE.md Section 7 (anti-cyberpunk rules); STACK.md "What NOT to Use" rejects synthwave/scanline/glow tokens; FEATURES.md AF-1, AF-2 reject glow/scanlines. No leakage detected. |
| HD-only (no pixel art in theme) | YES | STACK.md line 60 + 181 reject pixel fonts; ARCHITECTURE.md line 226 ("Rejected: pixel font for logos"); SOURCES.md Source #8 audit rejects user's pixel-font claim. |
| Feature-complete to godot-minimal-theme's bar | YES | FEATURES.md Section 1-2 enumerates 35 classes with full entry matrix; SOURCES.md flags Phase 1 spike to dissect minimal theme `.tres` for completeness verification. |
| Distributes as `res://addons/neocade_theme/neocade_theme.tres` | YES | STACK.md addon layout; PROJECT.md Context. |
| Mockup approval gate is mandatory before implementation | YES (with MAJ-6 caveat) | ARCHITECTURE.md Section 6; SUMMARY.md Phase 3 gate. MAJ-6: mobile mockup step missing. |
| Inter + Noto Sans is the primary font stack | YES | STACK.md TL;DR Decision 1; ARCHITECTURE.md Section 2; CROSS-PLATFORM Section 5. (CRIT-1 is about adding a *tertiary* — explicitly permitted by PROJECT.md line 122 — and contradiction is on whether to do so in v1, not on swapping primaries.) |
| Cross-platform: all 6 Godot export targets | YES | CROSS-PLATFORM.md Section 1 (per-target matrix). |
| Mobile variant is v1 must-have (added 2026-05-04) | PARTIAL | CROSS-PLATFORM and SUMMARY accept this; FEATURES AF-5 stricken; but FEATURES.md "Future Consideration v2+" line 872 still lists mobile-tuned variant as future work (MAJ-4); STACK.md "If extending to mobile in v2" framing not updated (MAJ-3). |

**Hard-constraint integrity verdict:** No CRITICAL violations of hard constraints. Two MAJOR cleanup items related to "mobile is v1" propagation. No leaks of "VirtuCade", "synthwave", "scanline", "pixel font", or non-GL-Compatibility renderer recommendations.

---

## Cross-Document Consistency Audit

The user prompt named 5 specific consistency checks. Findings:

| Check | Status | Detail |
|---|---|---|
| **Outfit display font (SUMMARY says NO; CROSS-PLATFORM says ADD)** | **CONTRADICTION CONFIRMED — CRIT-1** | See CRIT-1 above. SUMMARY Conflict 1 says no Outfit in v1; CROSS-PLATFORM 9.1 says "defer Inter Italic to v1.x and add Outfit in v1." Two of four research dimensions assume Outfit IS in v1. Must be resolved. |
| **Surface tokens (SUMMARY 5 stops; FEATURES 7 stops with sunken+overlay)** | **CONTRADICTION — CRIT-4** | SUMMARY/SOURCES reject `surface.sunken`; FEATURES.md still defines it in token tables and lists it in "Prototype Gaps to ADD." See CRIT-4. |
| **Shadows policy (SUMMARY/FEATURES locked "no drop shadows in v1")** | **VIOLATION — CRIT-3** | PITFALLS.md line 758 says "Use drop shadow, not outer glow, for elevation." Direct contradiction of locked policy. STACK.md line 206 also stale (MAJ-2). |
| **Mobile variant (PROJECT v1 must-have; CROSS-PLATFORM provides specs)** | PARTIAL | FEATURES AF-5 correctly stricken with date; FEATURES "Future Consideration" line 872 NOT updated (MAJ-4); STACK.md "If extending to mobile in v2" NOT updated (MAJ-3). |
| **9-phase vs 11-phase roadmap (SUMMARY updated to 11)** | **INCONSISTENCY — CRIT-2** | SUMMARY high-level list (lines 196-208) says 11 phases; per-phase detail (lines 210-258) only describes 9; "Research Flags" subsection (line 268) references old phase numbers; FEATURES.md MVP section (lines 826-861) still 5-phase plan (MAJ-5). |

---

## Source Coverage Audit

| Source (named in PROJECT.md) | In SOURCES.md? | Adequate dossier? | Notes |
|---|---|---|---|
| godot-minimal-theme (passivestar) | YES (#1, lines 13-48) | MEDIUM — README-level only | Phase 1 spike correctly flagged for line-by-line `.tres` dissection. Adopted/rejected/open structure complete. |
| LDtk UI docs (ldtk.io) | YES (#2, lines 51-79) | MEDIUM | Surface read; Phase 2 spike addresses depth. |
| LDtk source code (`C:\Programming_Files\ldtk-master`) | YES (#3, lines 82-112) | LOW (acknowledged) | "Must read all of it for UI" mandate explicitly unsatisfied; Phase 2 spike addresses. Honest self-rating. |
| Material Design 3 (m3.material.io) | YES (#4, lines 116-155) | HIGH | Upstream SCSS values pulled with version pin; full audit of what's adopted vs rejected. |
| Real & virtual arcade aesthetics | YES (#5, lines 159-194) | MEDIUM (text) / LOW (visual) | Photo collection deferred to Phase 3 sub-spike. Honest self-rating. |
| Godot Theme docs (4 specific URLs) | YES (#6, lines 198-242) | HIGH | All 4 URLs read. Acknowledges Context7 re-verification per user's global rule. |
| Godot controls gallery | YES (#7, lines 246-270) | MEDIUM-HIGH | Full `.tscn` enumeration deferred to Phase 8 implementation; structural reference confirmed. |
| `NeoCade-Research-Report.md` | YES (#8, lines 273-321) | HIGH | 20-row claim-by-claim audit table with explicit verdicts and PROJECT.md cross-references. |
| `NeoCade-Theme-Prototype.png` | YES (#9, lines 324-378) | HIGH | 16-row element-by-element critique with explicit verdicts. |
| CROSS-PLATFORM dimension sources (Godot exports, iOS HIG, Material 3 mobile, ThemeGen, font licenses) | YES (#10, lines 382-477) | HIGH | Authored after addendum landed. Per-source sub-rows with adopt/reject/open structure. |

**Source coverage verdict:** Every source named in PROJECT.md's "Source coverage commitment" table has a SOURCES.md entry. Three sources are honestly flagged at LOW or MEDIUM-LOW with explicit Phase 1/2/3 spike recommendations to close the gaps. No silent gaps; no missing entries.

---

## Anti-Feature Reconciliation

Anti-features / "explicitly rejected" / "out of scope" entries collected across docs:

| Anti-feature | Sources that lock it | Conflict? |
|---|---|---|
| Synthwave / vaporwave / scanline / glow | PROJECT.md OOS; STACK.md "What NOT to Use"; ARCHITECTURE.md Section 7; FEATURES AF-1, AF-2; PITFALLS Section 7 | NO |
| Pixel fonts (any UI element) | PROJECT.md OOS; STACK.md line 60+181; ARCHITECTURE.md line 226; SOURCES.md Source #8 audit row 12 | NO |
| Cyberpunk aesthetic | PROJECT.md OOS; ARCHITECTURE.md Section 7; PITFALLS Section 7 | NO |
| Drop shadows in v1 | SUMMARY Conflict 3; FEATURES AF-13; ARCHITECTURE elevation = color-only | **YES — PITFALLS.md line 758 contradicts (CRIT-3)** |
| `surface.sunken` token | SUMMARY Conflict 2 | **YES — FEATURES.md still defines it (CRIT-4)** |
| Outfit / third display font in v1 | SUMMARY Conflict 1 | **YES — ARCHITECTURE makes it primary, CROSS-PLATFORM bundles it (CRIT-1)** |
| Material Symbols / Lucide / Phosphor as bundled libraries | STACK.md "What NOT to Use" | NO |
| `EditorPlugin` script + `plugin.cfg` | STACK.md TL;DR Decision 5; FEATURES (no AF# but consistent) | NO |
| `StyleBoxTexture` for chrome | STACK.md "What NOT to Use"; FEATURES AF-12 | NO |
| Custom shaders | PROJECT.md Constraints; STACK.md | NO |
| GDExtension | PROJECT.md OOS; STACK.md | NO |
| `SystemFont` fallback | STACK.md "What NOT to Use"; CROSS-PLATFORM 2.2 | NO |
| Light mode in v1 | PROJECT.md OOS; FEATURES AF-4 | NO |
| ~~Mobile variant~~ | ~~FEATURES AF-5 (stricken 2026-05-04)~~ | NO (correctly stricken) |
| Editor-only types (FlatButton, MainScreenButton, EditorInspector*) | FEATURES AF-6; SOURCES Source #1 row 6 | NO |
| CodeEdit syntax-highlight color presets | FEATURES AF-7 | NO |
| Animations beyond Godot built-in | PROJECT.md OOS; FEATURES AF-3 | NO |
| Per-platform native fonts | FEATURES AF-9 | NO |
| Sound effects bundled | PROJECT.md OOS; FEATURES AF-10 | NO |
| Per-density-bucket mobile theme files | CROSS-PLATFORM 3.5 (one mobile theme, not four) | NO |
| Material You / dynamic Android color | CROSS-PLATFORM 3.7 | NO |
| Mobile renderer (Vulkan/Metal) on iOS or Android in 4.6 | CROSS-PLATFORM TL;DR Decision 1 (stay on GL Compat) | NO |

**Net:** 22 distinct anti-features identified; 19 are consistently locked across all docs; 3 have contradictions (the three CRITICAL findings above). All three are reconcilable with scoped edits.

---

## Phase-Readiness Assessment

The next workflow step is REQUIREMENTS.md → ROADMAP.md. Question: is SUMMARY.md's 11-phase plan specific enough for a roadmapper to:

1. **Map every PROJECT.md Active requirement to a specific phase?** — PARTIAL. The 11-phase plan covers all 17 Active requirements at a coarse grain (research/design/foundation/core/lists/dialogs/mobile/showcase/QA/distribution). But the internal inconsistency between the high-level list and the detailed phase blocks (CRIT-2) means a roadmapper can't trust phase numbers when reading the doc. Once CRIT-2 is fixed, mapping is straightforward.

2. **Define success criteria per phase?** — PARTIAL. Phases 1-3 (research/design) have clear deliverables and the user-facing approval gate is explicit. Phase 4 (Foundation) has clear deliverables. Phases 5-7 (per-Control authoring) reference FEATURES.md Section 2 entry tables — that's enough for the roadmapper. Phase 8 (Mobile Variant Authoring, in the new numbering) has acceptance criteria from CROSS-PLATFORM Section 8 but no detailed block in SUMMARY (CRIT-2). Phase 10 (QA + Cross-Platform Validation) has acceptance criteria from CROSS-PLATFORM Section 6.5 (per-target table). Phase 11 (Distribution) is sketched but Asset Library policy verification is correctly flagged as research-required at submission time.

3. **Sequence phases by dependency?** — YES, mostly. SUMMARY.md "Phase Ordering Rationale" (lines 261-265) is solid for the desktop-only path. The mobile-variant-interleaving is mentioned (line 204: "Interleaved with phases 5-7 in practice (token overrides accrue as desktop entries land)") — that's enough context but worth being explicit about in REQUIREMENTS.md whether mobile variant is a separate phase, an interleaved sub-task, or both.

**What's missing for full phase-readiness:**

- **CRIT-1, CRIT-2, CRIT-3, CRIT-4 must be resolved first.** Each affects what implementers do in Phase 4-8.
- **Per-phase acceptance criteria are fragmented across 4 documents.** Roadmapper has to assemble them. A consolidated table of "Phase X delivers Y, accepted when Z" would help.
- **Mockup approval gate failure path.** ARCHITECTURE Section 6 says "max 3 rounds" but doesn't define what happens after round 3. Edge case — flag for REQUIREMENTS.md.
- **UD-1 (MCP swap) timing is in Phase 3 sub-spike, but Phase 9 QA and Phase 10 Cross-Platform Validation depend on it.** Roadmapper should sequence UD-1 resolution explicitly before any phase that captures screenshots.
- **UD-2 (CJK bundling) is open.** Phase 4 ships fonts; CJK decision must land before Phase 4 commits the font folder structure.
- **UD-3 (stylebox authoring tooling) is mostly resolved (Theme Editor primary; .tres text edits for token-aliasing only) but the @tool generator script in CROSS-PLATFORM 4.2 is a third path that isn't reconciled with UD-3.** The generator script is essentially a programmatic authoring tool that the @tool script *generates* the .tres rather than the Theme Editor. Is the generator the primary authoring path and Theme Editor a verification surface? Is it the other way around? UD-3 needs an update to incorporate the generator script.
- **CROSS-PLATFORM "Open Questions" (real-device testing matrix, AccessKit integration, Inter Italic in v1)** — these need to be surfaced as UD-4, UD-5, UD-6 in SUMMARY.md's "Open User Decisions" section. Currently they're only listed in CROSS-PLATFORM and the Confidence/Open-Questions block at SUMMARY line 17 — not in the main UD-N enumeration at lines 162-169.

**Phase-readiness verdict:** Once CRIT-1 through CRIT-4 are resolved and the open user decisions are consolidated into one place (UD-1 through UD-6+), the 11-phase plan is roadmapper-ready. Without those fixes, the roadmapper will produce internally inconsistent phase plans.

---

## Recommended Actions Before REQUIREMENTS.md

Numbered, prioritized:

1. **[CRIT-1] Decide Outfit-in-v1 and propagate.** Pick one direction (recommend: ship Outfit in v1, defer Inter Italic to v1.x — this is the post-CROSS-PLATFORM de facto state). Edit SUMMARY.md Conflict 1 with a "Decision changed 2026-05-04 after CROSS-PLATFORM" marker. Update Phase 4 deliverables (line 233) and SOURCES.md line 14, line 473. ARCHITECTURE.md is already aligned with the "ship Outfit" direction; no edit needed there. STACK.md TL;DR Decision 1 needs an Outfit row.

2. **[CRIT-2] Rewrite SUMMARY.md "Implications for Roadmap" section as 11 coherent phases.** Either insert detail blocks for the new Phases 8 (Mobile Variant Authoring), 10 (Cross-Platform Validation), 11 (Distribution) and renumber the existing Phase 8 (Showcase) and Phase 9 (QA+Distribution) into Phase 9 and Phase 10 respectively; or commit to a different number consistently. Update the "Research Flags" and "Phases with standard patterns" subsections to use the new numbering.

3. **[CRIT-3] Fix PITFALLS.md line 758.** Edit the "Use drop shadow, not outer glow, for elevation" bullet to align with the locked no-shadow policy.

4. **[CRIT-4] Strike `surface.sunken` from FEATURES.md.** Lines 16, 490-491, 911. Replace with the "inputs differentiated via focus/normal stylebox + corner radius" reasoning from SUMMARY Conflict 2.

5. **[MAJ-3, MAJ-4] Update STACK.md and FEATURES.md "v2+" mobile leftovers.** STACK.md "If extending to mobile in v2" subsection title; FEATURES.md "Future Consideration (v2+)" line 872.

6. **[MAJ-5] Update FEATURES.md MVP section.** Add a pointer to SUMMARY.md as the authoritative phasing.

7. **[MAJ-6] Add Step 5b mobile mockup to ARCHITECTURE.md Section 6.** Per CROSS-PLATFORM 9.3.

8. **[MAJ-7] Author an explicit "Editor surfaces themed vs not" map.** Could be a small subsection in FEATURES.md or a dedicated `EDITOR-COVERAGE.md`. Lists which Editor controls render with NeoCade styling and which fall back to default.

9. **[MAJ-2] Update STACK.md line 206 (drop-shadow guidance).**

10. **[MIN-1, MIN-4, MIN-5] Cosmetic fixes.** Update SUMMARY confidence row; reconcile FEATURES exec-summary class count (32 vs 35); SOURCES.md Outfit reference flows from CRIT-1 fix.

11. **Consolidate open user decisions.** Add UD-4 (Inter Italic v1 vs v1.x), UD-5 (real-device testing matrix), UD-6 (AccessKit / VoiceOver / TalkBack scope) to SUMMARY.md "Open User Decisions" subsection at lines 162-169. Currently buried in CROSS-PLATFORM addendum bullet list at SUMMARY line 17 only.

12. **Update UD-3 to reference the @tool generator script.** Either confirm the script is the primary authoring path (Theme Editor is a verification surface) or vice-versa, and document the chosen workflow.

After these 12 actions, the docs are coherent, hard constraints are honored uniformly, and a roadmapper agent has a clean 11-phase plan with concrete acceptance criteria to lift into REQUIREMENTS.md and ROADMAP.md.

---

*Independent review authored: 2026-05-04*
*Reviewer position: PROJECT.md is source of truth; research files are challenged against it.*
*Confidence: HIGH on findings cited with file+line evidence; HIGH that CRIT-1 through CRIT-4 are real and reconcilable.*
