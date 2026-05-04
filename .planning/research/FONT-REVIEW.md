# NeoCade Font Stack Review

> **SUPERSEDED 2026-05-04 — see "Option D Supersession" below.** This document recommended Option B (Inter + Noto Sans + JetBrains Mono). User then pushed further on size minimization, noting that Godot 4.x's `Font.allow_system_fallback=true` (default) makes Noto Sans non-essential — non-Latin scripts (Arabic, Hebrew, Indic, Thai, CJK, etc.) render via OS system fonts automatically. CodeEdit usage is genuinely rare in shipped games, so JetBrains Mono is also non-essential. **Final locked decision: Option D — Inter Variable Roman ONLY** (~810 KB, matches godot-minimal-theme exactly).
>
> See SUMMARY.md Conflict 1 (FINAL 2026-05-04) for the canonical decision. The Option B analysis below remains as historical reasoning context.


**Date:** 2026-05-04
**Author:** Research subagent (gsd-project-researcher)
**Scope:** Final v1 font-bundle decision before Phase 4 (Foundation) commits the `addons/neocade_theme/fonts/` folder.
**Supersedes/updates:** SUMMARY.md Conflict 1 revision (2026-05-04), STACK.md "Supporting Libraries", CROSS-PLATFORM.md font compliance section.
**Mid-flight constraint update from user (2026-05-04):**

> "Multiple fonts in the same application is unprofessional, unless it's code blocks specifically."

This document re-evaluates Options A/B/C against the user's restated principle of **consistency-first typography** and produces a single final recommendation.

---

## TL;DR — Final Recommendation: Option B (Inter + Noto Sans + JetBrains Mono)

Bundle three font families in v1:

1. **Inter Variable** — single stylistic UI face for **all** UI surfaces (body, headings, buttons, labels, dialogs, popups, menus, captions, code-adjacent metadata). Headings differentiate by **weight + size + tracking + opsz axis** (Inter v4 unifies Display via `opsz`), not by switching family.
2. **Noto Sans Variable** — fallback-only for non-Latin scripts (CJK overrides excluded — README documents the path). Wired into `default_font.fallbacks`. Never used as a primary surface choice — gap-filler only.
3. **JetBrains Mono Variable** — monospace, scoped exclusively to code surfaces (`CodeEdit` body text, `CodeLabel` type variation, `RichTextLabel`'s `[code]` BBCode tag, the `code_font` theme entry on Tree/RichTextLabel/etc.).

**Drop Outfit Variable** from the v1 bundle. The Conflict 1 revision in SUMMARY.md (2026-05-04) is **reversed** by this review.

**Bundle delta vs current SUMMARY canon:**

| | SUMMARY canon (pre-this-review) | This review (Option B) |
|---|---|---|
| Body / UI | Inter Variable | Inter Variable |
| Headings / Marquee | **Outfit Variable** | Inter Variable @ heavier wght + larger opsz |
| Multi-script fallback | Noto Sans Variable | Noto Sans Variable |
| Code | JetBrains Mono | JetBrains Mono |
| Italic | (synthetic transform) | (synthetic transform) — unchanged |
| Approx. bundle size | ~1.85 MB | ~1.55 MB |

**Why this lands the consistency principle:** one stylistic family (Inter) governs every UI surface; Noto Sans is a transparent gap-filler that the user never sees unless they author non-Latin content; JetBrains Mono is the code-block exception the user explicitly authorised. No third "for headings" face means no two stylistic faces compete for visual authority anywhere in the UI.

The cost — Outfit's marquee character on display sizes — is recoverable at the visual-direction layer (palette warmth, accent saturation, corner-radius personality, focus-ring color, button bevel) without needing a second typeface.

---

## 1. Reframing the Decision

The user's mid-flight principle:

> "Multiple fonts in the same application is unprofessional, unless it's code blocks specifically."

Decomposes into three claims:

1. **"Multiple fonts in the same application is unprofessional"** — the ceiling for stylistic faces is **one**.
2. **"…unless it's code blocks specifically"** — code-mono is a recognised exception (different visual language, different semantic register, different metric requirements: tabular, monospaced glyphs).
3. **Implicit corollary:** multi-script fallback (Noto Sans behind Inter) is **not** what they mean by "multiple fonts." Fallback is a gap-filler that activates only when the primary face cannot render a codepoint; the user almost never perceives it as a second face.

Earlier framing (pre-update) prioritised **on-brand marquee voice** as a tiebreaker — that's why SUMMARY's Conflict 1 revision sided with Outfit. The new framing makes **consistency** the tiebreaker. The two principles point in different directions for the heading-vs-body decision.

---

## 2. The Three Options Restated

| | Option A | Option B (RECOMMENDED) | Option C (status quo per SUMMARY revision) |
|---|---|---|---|
| Body/UI | Inter Variable | Inter Variable | Inter Variable |
| Headings | Inter Variable (heavier weight + larger opsz) | Inter Variable (heavier weight + larger opsz) | **Outfit Variable** |
| Fallback | Noto Sans Variable | Noto Sans Variable | Noto Sans Variable |
| Code | (none — Inter at small sizes) | **JetBrains Mono Variable** | JetBrains Mono Variable |
| Bundled stylistic faces visible in UI | 1 (Inter) | 1 (Inter) + mono exception | 2 (Inter + Outfit) + mono exception |

The user's principle implies: **the count of "stylistic faces visible in UI" is the relevant metric, and it must be ≤ 1**. Mono and fallback don't count toward the cap. So:

- Option A: 1 stylistic face, 0 mono → satisfies the principle but loses the code-mono exception.
- Option B: 1 stylistic face, 1 mono → satisfies the principle AND keeps the code-mono exception.
- Option C: 2 stylistic faces, 1 mono → **violates the principle.**

The user's continuation prompt confirms this read by explicitly conceding the code-mono exception ("the user has implicitly conceded that code-monospace is the acceptable exception") and asking the analysis to focus on **A vs B** and **B vs C**.

---

## 3. A vs B — Does Code Mono Need To Ship in v1?

**Decision: B (ship JetBrains Mono).**

### Surfaces in NeoCade that semantically demand a monospace face

NeoCade aims for feature-completeness against the 35-class Godot Control coverage matrix (FEATURES.md). Several controls have **dedicated monospace theme entries** that Godot's default theme already populates with a monospace family, and which break visually if styled with a proportional face:

1. **`CodeEdit`** — purpose-built code editor Control. Its primary `font` slot expects a monospace family. Used by VirtuCade and any consuming game with a debug console, scripting layer, or modding panel. Proportional fonts here misalign indentation, break column-based UI conventions (tab-stops, bracket matching), and fail the implicit "looks like code" semantic that users expect from any control named CodeEdit.
2. **`RichTextLabel`'s `[code]` BBCode tag** — Godot reserves a separate `mono_font` theme entry on RichTextLabel specifically to render `[code]inline[/code]` and ` ```block``` ` content. If unset, RichTextLabel falls back to `default_font` and code visually disappears as inline text — a regression vs Godot's default theme.
3. **`Tree`'s `code_font` slot** — used by some Tree consumers for monospace columns; less common but populated in godot-minimal-theme.
4. **`CodeLabel` type variation** — proposed in FEATURES.md / ARCHITECTURE.md as one of the 5 label type variations. Whole point is "this label is showing code." Proportional Inter here makes the type variation pointless.

These four surfaces aren't optional. If NeoCade ships Option A, every consumer who reaches for CodeEdit gets a proportional Inter rendering of code, which is a worse default than Godot's own. Option A's bundle saving (~0.45 MB) is not worth that regression.

### License & coverage check

JetBrains Mono is **OFL 1.1** (verified in CROSS-PLATFORM.md font compliance table) — App Store, Play Store, and Web embedding all legal. Variable axis covers `wght 100-800` and italic. Bundle weight ~0.45 MB for the variable file. No reserved-name issues that affect a `addons/`-bundled deployment.

### Counter-argument considered: "system mono fallback"

Could NeoCade not bundle JetBrains Mono and rely on `SystemFont` with a mono fallback chain (`Menlo` → `Consolas` → `monospace`)? **No.** CROSS-PLATFORM.md verified that **`SystemFont` resource silently fails on Web export** (one of three documented Web-export failure modes). Web is one of NeoCade's six required targets. A mono face that works on five targets but vanishes on Web is not v1-acceptable. JetBrains Mono must be bundled.

### Verdict

**A loses to B.** The code-mono exception isn't theoretical; it's load-bearing for four concrete Control surfaces whose default Godot rendering already uses monospace. Skipping it would actively regress vs godot-minimal-theme parity. Option A is rejected.

---

## 4. B vs C — Does Outfit Headings Violate the Consistency Principle?

**Decision: B (drop Outfit). The principle as stated rules out Option C.**

### The user's principle reread literally

> "Multiple fonts in the same application is unprofessional"

Outfit is a **second stylistic face** — not a fallback, not a different semantic register like code-mono. It would be visible across every Header* type variation (HeaderLarge, HeaderMedium, HeaderSmall) on:

- Showcase headings
- Dialog titles (AcceptDialog/ConfirmationDialog/FileDialog title bars)
- Section headers across the showcase
- Any panel that consumers style with the HeaderLarge variation

That's a high-frequency, high-visibility surface. If the user's principle is a hard rule, this violates it. The fact that headings are "different from body" doesn't smuggle Outfit through the same loophole as code-mono — code's exception is grounded in **functional/metric necessity** (monospaced glyph cells, indentation alignment), not aesthetic differentiation. Outfit-vs-Inter for headings is purely aesthetic differentiation; that's exactly the kind of "multiple fonts" the user objected to.

### Is "heading vs body differentiation" an industry-accepted exception?

The continuation prompt asks specifically about Material 3, Apple HIG, VS Code, Linear. Verified evidence (Context7 fetch, current docs):

| System | Body font | Heading font | One-family or two? |
|---|---|---|---|
| **Material Design 3** | Plain font (Roboto by default) | Brand font (Roboto by default) | **Formally two roles, but defaults to ONE family.** M3 explicitly lets brands pair a "brand font" with a "plain font" — but the out-of-the-box system uses Roboto for both. Two faces is a *brand customisation*, not a default. |
| **Apple HIG (iOS/macOS)** | San Francisco (SF Pro / SF Compact) | San Francisco (SF Pro Display variant via opsz) | **One family.** New York (serif) exists as a complement but is documented as opt-in for specific use cases, not default heading face. SF handles both display and body via the same family with `opsz` axis discrimination — exactly the architecture STACK.md proposed for Inter. |
| **VS Code (UI)** | System UI font | System UI font | **One family.** UI uses platform default; only the editor pane uses the user's chosen monospace. The mono is the code exception, identical to NeoCade's situation. |
| **Linear** | Inter | Inter | **One family.** Headings are Inter at heavier weight + size; no display face. |
| **GitHub** | -apple-system / system UI stack | Same | **One family.** Code uses ui-monospace stack — code-mono exception only. |
| **Stripe Dashboard** | Sohne (custom)/system | Sohne | **One family.** |

The pattern is overwhelming: **modern professional UI systems use ONE stylistic family for both body and headings, differentiated by weight/size/opsz, with monospace as the only family-switching exception.** Material 3 *permits* a brand-font-vs-plain-font split but does not *do* one by default. Apple HIG makes this architecture explicit — same family, opsz axis differentiates display from text usage.

This is exactly Inter v4's design: it ships with `wght 100-900` and `opsz 14-32`, and `opsz=32` IS the marquee/display variant. The Conflict 1 revision's argument — "Inter Display via opsz=32 is structurally a body face stretched up, not a marquee face" — is technically incorrect about Inter v4. Inter v4's `opsz` axis is **purpose-designed for display use**: tighter tracking, optical adjustments to spacing and curves, intended specifically for headlines. It IS a marquee voice within the Inter family, not a stretched body face.

### The arcade-marquee concern revisited

Conflict 1 revision argued the arcade brief specifically wants "marquee feel" on headings, and that Outfit delivers this where Inter cannot. Two responses:

1. **Inter v4's opsz=32 + a heavier weight (700-900) + tightened tracking on Header* type variations gets close to marquee.** It's not a chunky geometric display face, but neither is it body-stretched-up. With careful sizing (display-small at 36px, headline-small at 24px) and weight (700-900), Inter delivers a confident, modern-arcade voice. ARCHITECTURE.md's type-scale table can be re-cast onto Inter with minimal change.
2. **Marquee energy is more efficiently delivered by non-typographic moves** in this aesthetic. Arcade warmth comes through the palette (Boardwalk Sunset's amber/coral/teal accents), the focus-ring color, the button bevel highlight, the corner-radius personality, and the showcase scene's marquee accent treatments — not by font-switching. The visual direction work in Phase 3 mockups should carry that load. Asking the typography to also carry "arcade marquee feel" is double-loading the brief.

### Is two-family typography ever defensible under a strict consistency principle?

Yes — when the two families serve **functionally distinct registers**, like:

- Body proportional + code monospace (different glyph metrics)
- Latin + non-Latin script (different writing systems)

Both of these are functional, not aesthetic. A display-vs-body split (Outfit headings + Inter body) is purely aesthetic. The user's principle as stated treats aesthetic differentiation as the kind of "multiple fonts" they reject.

### Verdict

**C loses to B.** Industry precedent (M3, Apple HIG, VS Code, Linear, GitHub, Stripe) overwhelmingly favours one stylistic family for both display and body, with mono as the only family-switching exception. The "marquee character" argument that drove the Conflict 1 revision can be addressed within the Inter family using the `opsz` axis at 32 + heavier weights. The arcade brief's marquee energy is better delivered by palette, accents, and showcase ornamentation than by a second typeface.

---

## 5. Final Recommendation Detailed

### Bundle (v1, Phase 4)

```
addons/neocade_theme/fonts/
  Inter-VariableFont_opsz,wght.ttf         (~0.6 MB)  — primary UI face, all surfaces
  NotoSans-VariableFont_wdth,wght.ttf      (~0.5 MB)  — fallback for non-Latin scripts
  JetBrainsMono-VariableFont_wght.ttf      (~0.45 MB) — code surfaces ONLY
  OFL.txt                                              — combined license file (Inter + Noto Sans + JetBrains Mono)
```

Total ~1.55 MB, smaller than both Option C (~1.85 MB with Outfit) and the original SUMMARY pre-revision (~2.3 MB with Inter Italic).

### Type scale (re-cast from ARCHITECTURE.md onto Inter-only)

| M3 token | Family | wght | opsz | size | Notes |
|---|---|---|---|---|---|
| display-large | Inter | 800 | 32 | 57 | Marquee in showcase only |
| display-medium | Inter | 800 | 32 | 45 | Rare |
| display-small | Inter | 700 | 32 | 36 | HeaderLarge variation |
| headline-large | Inter | 700 | 32 | 32 | Section breakers |
| headline-medium | Inter | 700 | 32 | 28 | HeaderMedium variation |
| headline-small | Inter | 700 | 28 | 24 | HeaderSmall variation; dialog titles |
| title-large | Inter | 600 | 24 | 22 | Panel titles |
| title-medium | Inter | 600 | 18 | 16 | Tab labels, button text on large buttons |
| title-small | Inter | 600 | 14 | 14 | Default button text |
| body-large | Inter | 400 | 14 | 16 | Mobile body |
| body-medium | Inter | 400 | 14 | 14 | Desktop body — default |
| body-small | Inter | 400 | 14 | 12 | Captions |
| label-large | Inter | 500 | 14 | 14 | Form labels |
| label-medium | Inter | 500 | 14 | 12 | Tooltips, inline labels |
| label-small | Inter | 500 | 14 | 11 | Overlines |
| code-medium | **JetBrains Mono** | 400 | — | 13 | CodeEdit, [code] BBCode, CodeLabel |

The opsz=32 + wght 700-800 combination on display-small / headline-* gives the marquee voice without leaving the Inter family. This matches Apple HIG's SF Pro Display strategy (same family, opsz axis discrimination) and Inter v4's intended-use documentation for the opsz axis.

### Italic strategy

Unchanged from current SUMMARY canon: **defer Inter Italic to v1.x**, use synthetic italic transform in the meantime. Italic emphasis is sparingly used in body text; the synthetic transform is acceptable for v1. (Bundling the Inter Italic VF would add ~0.85 MB and is the swap that originally funded Outfit; with Outfit dropped, that funding goes back to "smaller bundle" rather than "real italic.")

### Theme wiring (Phase 4)

```
default_font          → Inter Variable
default_font.fallbacks → [Noto Sans Variable]   # for non-Latin codepoints
mono_font (where Godot defines it) → JetBrains Mono Variable
code_font (Tree, RichTextLabel)    → JetBrains Mono Variable
```

`CodeEdit.font` and `CodeLabel` type variation explicitly set to JetBrains Mono. All other Control fonts inherit from `default_font` (Inter) — including every Header* type variation. Per Pitfall 1.3 (type variations don't inherit fonts from base type, Godot issue #80731), every variation must set its font explicitly OR rely entirely on `default_font` not setting per-variation overrides — Phase 4 picks one strategy and sticks to it (recommend setting on `default_font` only, not per-variation, so font-inheritance bug is structurally avoided).

---

## 6. Implications & Propagation

The following downstream artifacts must be updated to reflect this review:

1. **`SUMMARY.md` Conflict 1 revision** — re-revised. Outfit is OUT; the original synthesis decision (no Outfit, Inter via opsz handles display) is RESTORED, with the additional finding that the consistency principle independently rules Outfit out regardless of marquee-character considerations.
2. **`SUMMARY.md` UD-4** — re-resolved. Inter Italic remains deferred to v1.x, but for a different reason now: the original "swap Inter Italic out, swap Outfit in" trade no longer applies. Inter Italic is just deferred for bundle-size reasons; synthetic italic carries v1.
3. **`STACK.md` "Supporting Libraries"** — remove Outfit Variable from v1 bundled font list. The original STACK.md stance ("no third font") is now canonical again, plus JetBrains Mono is added as v1-bundled (it was already in the stack but worth double-confirming Phase 4 includes it).
4. **`CROSS-PLATFORM.md` font compliance** — drop Outfit from the OFL combined-license table; keep Inter + Noto Sans + JetBrains Mono. Total bundle size estimate drops from ~1.85 MB to ~1.55 MB.
5. **`ARCHITECTURE.md` type-scale table** — re-cast all Outfit entries onto Inter (per Section 5 above). The architectural intent (display-vs-body discrimination) is preserved by switching the discrimination axis from "different family" to "opsz=32 + heavier wght within Inter."
6. **`SOURCES.md` font listings** — update Outfit entry status to "evaluated, not bundled in v1; principle-of-consistency tiebreaker." Inter / Noto Sans / JetBrains Mono confirmed v1.
7. **`PROJECT.md` Key Decisions** — the "Inter + Noto Sans as primary font stack" row stays Pending until mockup gate; this review confirms the recommendation but doesn't seal it. Phase 3 mockup gate is the explicit user-approval surface for typography.
8. **Phase 3 mockup gate** — typography mockup step now compares **Variant A** (Inter only, no mono context — pure UI surface) vs **Variant B** (Inter + JetBrains Mono in code surfaces, the recommended ship config). Outfit is removed from the mockup ladder. If the user reverses this review at the gate ("I want Outfit anyway, the consistency principle is loose not strict"), Phase 3 reintroduces Outfit and we return to the SUMMARY Conflict 1 revision posture.
9. **Phase 4 deliverables** — bundle Inter Variable + Noto Sans Variable + JetBrains Mono Variable + combined OFL.txt. No Outfit, no Inter Italic.
10. **Hard-constraint table in PROJECT.md** — line currently reads "Inter + Noto Sans is the primary font stack (research may add a tertiary display font but cannot replace the primaries — and as of 2026-05-04 has done so: Outfit Variable added as v1 display font…)". This line should be edited at next PROJECT.md revision to remove the Outfit clause and note the consistency-principle reversal.

---

## 7. What This Review Did NOT Re-litigate

- **Code-mono is acceptable** — explicitly conceded by user, not analysed further.
- **Inter as the primary face** — locked by PROJECT.md hard constraint; not under review.
- **Noto Sans as multi-script fallback** — locked by PROJECT.md hard constraint; not under review. Confirmed not to count against the consistency principle (it's a transparent gap-filler).
- **CJK bundling (UD-2)** — separate decision, not affected by this review.
- **Inter Italic v1 vs v1.x (UD-4)** — re-resolved as "v1.x defer" but for a different reason; the Outfit swap that originally funded the deferral is undone, so deferral is now bundle-size driven only.
- **Mockup gate process** — unchanged; user retains override authority at Phase 3.

---

## 8. Decision Authority

This review is a **research recommendation**, not a unilateral override. Per the Research Charter in PROJECT.md, research can override `Pending` Key Decisions but must surface a written recommendation with reasoning. This document is that recommendation. The user's mid-flight constraint update (the consistency principle) is itself the override-authority for the SUMMARY Conflict 1 revision; this review just operationalises it across artifacts.

The Phase 3 mockup gate remains the explicit user-approval surface where this recommendation is confirmed or reversed. If the user prefers Option C (keep Outfit) at the gate, they can reverse this review by saying so — the consistency principle would then be read as a soft preference rather than a hard rule, and the SUMMARY Conflict 1 revision would re-apply.

---
*Review authored: 2026-05-04. Supersedes SUMMARY.md Conflict 1 revision of the same date.*
