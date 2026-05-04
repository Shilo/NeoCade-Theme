# NeoCade Theme — Project Research Summary

**Project:** NeoCade Theme (Godot 4.6 dark UI Theme addon, dark v1, distributed as `res://addons/neocade_theme/neocade_theme.tres`)
**Domain:** Godot 4.6 native Theme resource — visual design system + bundled fonts + bespoke icons + showcase scene
**Researched:** 2026-05-04 (initial parallel pass complete)
**Overall confidence:** HIGH on Godot Theme/Font API, table-stakes Control coverage, and table-stakes pitfalls. MEDIUM on real-arcade visual reference depth, Asset Library policy nuance, MCP screenshot tooling baseline. LOW on `godot-minimal-theme` `.tres` line-by-line entry enumeration and LDtk `src/electron.renderer/` UI mining — both flagged for dedicated source-dive spike phases.

> **Update (2026-05-04, post-CROSS-PLATFORM):** The 5th research dimension landed after the initial synthesis. Key cross-platform findings have been folded in below:
> - **No `.tres`-to-`.tres` inheritance in Godot Theme** — verified against Theme class API. Token-sharing strategy: `@tool` script (`addons/neocade_theme/_dev/generate_themes.gd`) generates BOTH desktop and mobile `.tres` from a single `TokenSet` constants block. Both `.tres` files are committed final artifacts, generated from one source of truth — drift is structurally impossible. ThemeGen (MIT) is a proven prior-art reference.
> - **GL Compatibility renderer is the safest cross-platform choice** — already locked in project.godot. Avoids two new Godot 4.6 regressions: iOS Mobile-renderer Metal validation failure on iPhone SE 2nd gen (#116090, 4.7 release blocker) and Android Mobile-renderer reducing Play Store device coverage (#111729). **Stay on GL Compatibility — do NOT switch.**
> - **Web export is highest-risk** — three failure modes: SystemFont resource silently fails (must use FontFile + bundled `.ttf`); `.ttf` files must be in "Filters to export non-resources" OR wrapped in saved FontFile.tres; iOS Safari has documented WebGL2 quirks (no pixel-parity required for v1). All `.tres` references must use `uid://` to survive PCK remap.
> - **Mobile spec is concrete:** Button height 48px mobile vs 32px desktop (satisfies iOS HIG 44pt + Material 3 48dp); body 16px mobile vs 14px desktop; spacing scale +50% on space.4 and above; **corner radii STAY IDENTICAL** across desktop/mobile (brand identity, not platform-specific).
> - **Density buckets — answered:** Ship ONE `neocade_mobile_theme.tres`, not four. Godot does not use Android density qualifiers for theme resources; density variation is handled at runtime via `content_scale_factor` + Godot stretch modes (`canvas_items` + `expand`). Authored values are dp-equivalent at base scale 1.0.
> - **License compliance:** Inter, Noto Sans, Outfit, JetBrains Mono are all OFL 1.1 — App Store + Play Store + Web embedding legal per SIL OFL FAQ. Reserved-name clause: do NOT rename `Inter-VariableFont*.ttf`. Single combined `OFL.txt` covers all bundled fonts.
> - **Two new phases required** in the roadmap: **Mobile Variant Authoring** (interleaved with desktop authoring after Foundation) and **Cross-Platform Export Validation** (post-desktop-QA, pre-v1-release). Optional Cross-Platform Hardening Spike buffer phase recommended.
> - **FEATURES.md AF-5 must be stricken** — mobile-as-anti-feature is no longer correct; mobile variant is now v1 must-have.
> - **Open questions surfaced (not blocking):** Whether 4.6.x has fixed iOS Safari/Chrome HTML5 audio crash (#107390) — informational only since theme has no audio; whether iOS Mobile-renderer regression (#116090) gets backported — informational only since we use GL Compat; real-device Android testing matrix (3 devices: low/mid/high-end) — user hardware unknown; iOS testing requires Mac + paid Apple Developer Program — user status unknown; whether to ship Inter Italic in v1 (~+0.85 MB) or defer; AccessKit/VoiceOver/TalkBack screen-reader integration is partial in 4.6 — full integration deferred to v1.x or v2; v1 sets `accessibility_name` on showcase Controls only.

---

## Executive Summary

NeoCade is a "feature-complete coverage" project, not a feature-velocity project. Its `.tres` ships when **every** built-in Godot 4.6 Control class is themed across all states, when a coherent design-token system underpins those entries, when bundled fonts + bespoke SVG icons are wired correctly through `addons/`, and when a showcase scene visually proves it on screen. Research converges on the same architectural shape: **single `.tres` Theme resource, no `plugin.cfg`, no `EditorPlugin` script, no custom shaders**, with `StyleBoxFlat` as the universal chrome primitive, two bundled variable fonts (Inter + Noto Sans, OFL), a small bespoke SVG icon set (~25-40 glyphs), and a Material-3-derived token system rendered through Godot's Theme Type Variations.

The hardest problems are **identity discipline** and **state-correctness**. The user's prior research report and prototype both drift toward synthwave/cyberpunk aesthetics that have been explicitly rejected; SUMMARY recommends **Boardwalk Sunset** (warm-neutral surface ramp + amber/coral/teal accents) as the visual direction that most cleanly lands "vibrant arcade hall by day," with **Cabinet Chrome** (LDtk-inspired neutral charcoal + signature orange) as the disciplined fallback. State-correctness is the second hardest problem: Godot's `focus` stylebox is an **overlay, not a state** (loses to `pressed`/`checked`), `PopupMenu`/`OptionButton` dropdowns are **separate Windows that don't inherit overrides or texture filter**, and **type variations don't inherit fonts** from their base type — three behaviors that silently produce a "looks correct in editor preview, broken at runtime" theme. The roadmap must front-load these in the design token spec and the QA harness.

The single biggest risk to v1 is **scope drift via tempting but project-forbidden visual moves** (drop shadows on small controls, glow halos on focus rings, scanline textures, neon-on-pure-black palettes, pixel fonts for headings). Every researcher independently flagged some variant of this. The roadmap's mockup approval gate is the primary defense — a 3-step approval flow (3 palette mockups → 2-3 typography combos → 1 full-fidelity Control gallery) before any `.tres` styling commits. The secondary defense is the dual-renderer + multi-resolution screenshot pass mandated in QA, since the project's GL Compatibility renderer is where the most-overlooked rendering bugs live.

---

## Key Findings

### Recommended Stack

A **theme-resource-only addon** with two bundled variable fonts and a small bespoke icon set. No `plugin.cfg`, no editor plugin script, no shaders, no GDExtension, no scripted StyleBoxes. Total addon footprint ~2.3 MB before optional CJK fonts.

**Core technologies (full detail in `STACK.md`):**

- **Godot 4.6** — locked target; introduces "Modern" editor theme (productized port of `godot-minimal-theme`), focus decoupling, `pivot_offset_ratio`, instant editor theme reload.
- **`Theme` resource (`.tres`, text format)** — single deliverable at `res://addons/neocade_theme/neocade_theme.tres`. Diffable, hot-reloadable.
- **`StyleBoxFlat` everywhere** — pure-vector, GPU-rendered, scales infinitely. AA requires `corner_radius >= 2` (Godot issue #87226). Reserve `StyleBoxLine` for separators; `StyleBoxEmpty` only in runtime contexts where editor leak is impossible (plugins assume `StyleBoxFlat` methods).
- **`FontFile` + `FontVariation`** — one upright Inter VF + one italic Inter VF + one Noto Sans VF (Latin extended). Per-weight derivation via `variation_opentype["wght"]`.
- **Inter Variable v4.x (OFL)** — primary UI typeface; `wght 100-900` and `opsz 14-32`. v4 split italic into a separate VF — bundle both. Inter Display is now the `opsz` axis at 32, not a separate family.
- **Noto Sans Variable (OFL)** — fallback chain for non-Latin scripts. CJK is **not bundled** (~30 MB+); README documents the override path.
- **Bespoke SVG icon set, ~25-40 icons** — authored at 32×32 reference, imported with `Scale = 2.0` and **Linear With Mipmaps** filter explicitly per resource. Mapped 1:1 to Godot's hard-coded theme icon slots. Generic icon libraries (Material Symbols, Lucide, Phosphor) are explicitly rejected.
- **GL Compatibility renderer** — locked by `project.godot`. Authoring AND screenshot-QA must run on Compatibility.

**Tooling:**

- **GoPeak Godot MCP** (`npx gopeak`) — recommended primary MCP server (95-110+ tools, screenshot capture, input injection). The currently-wired Coding-Solo `godot-mcp` lacks screenshot capture; **swap recommended** before QA phases begin.
- **Context7 MCP** — for live Godot 4.6 / Material 3 / font-library docs.
- Godot's built-in Theme Editor as authoring surface; never edit Theme via a Control's inspector context (4.6 issue #115500 crashes editor).

**Explicitly rejected:** pixel fonts (any), Material Symbols/Lucide/Phosphor as bundled libraries, `EditorPlugin` script, `plugin.cfg`, `StyleBoxTexture` for chrome, custom shaders, GDExtension, `SystemFont` fallback, synthwave/scanline/glow tokens, "VirtuCade Theme" naming.

### Expected Features

The "feature surface" is the **coverage matrix**: 35 user-facing Control classes × all states × all theme entries.

**Must have (table stakes):**

- All 7 BaseButton variants × 5 states themed (Button is the keystone).
- All 5 text input/display classes (Label, RichTextLabel, LineEdit, TextEdit, CodeEdit) with normal/focus/read_only + caret + selection + placeholder colors.
- All range controls (HSlider, VSlider, ProgressBar, HScrollBar, VScrollBar, SpinBox).
- All list/tree controls (ItemList, Tree — 16 styleboxes, 12 icons —, TabBar, TabContainer).
- All popup-class controls themed as **separate types** (PopupPanel, PopupMenu, AcceptDialog, ConfirmationDialog, FileDialog, TooltipPanel, TooltipLabel, Window).
- Visible focus indicator on every focusable Control (WCAG 2.1 SC 1.4.11).
- Bundled OFL fonts wired into `default_font.fallbacks`.
- HD rendering at 1080p/1440p/4K.
- `res://main.tscn` showcase rendering every Control with realistic content + prominent NeoCade↔Godot toggle.

**Should have (NeoCade differentiators):**

- 6 button type variations (PrimaryButton, SecondaryButton, GhostButton, DangerButton, IconButton, FlatButton — role-based naming).
- 5 label type variations (HeaderLarge / HeaderMedium / HeaderSmall / Caption / CodeLabel).
- Distinctive 2px outer focus ring in `primary` color, drawn outside corner radius — the ONLY glow-coded element allowed in v1.
- 5-stop M3 tonal surface ramp + outline + 3 text colors + 8-hue accent palette + semantic role aliases.
- 4-rung corner radius scale (none/sm=4/md=8/lg=12).
- BBCode demo + Token Gallery panels in showcase.

**Defer (v2+):** Light mode, alternate palette variants, editor-only theme types, CJK font bundling, CodeEdit syntax-highlight presets, animations beyond Godot built-in.
**Mobile-tuned variant** — moved into v1 must-have per user constraint update 2026-05-04 (originally scoped as v2). Will be addressed by CROSS-PLATFORM dimension currently in flight.

**Hard anti-features (never):** glow halos, scanline/CRT/hex-grid overlays, chrome 3D titles, pixel fonts, texture-driven default chrome, theme-bundled sound, "VirtuCade Theme" naming.

### Architecture Approach

The architecture **is** the visual design system encoded in the `.tres`. Six layers:

1. **Color tokens** — Material-3 5-stop tonal surface ramp + outline + 3 text tones + 8-hue accent palette + semantic role aliases. WCAG 2.1 AA verified for all combinations.
2. **Typography tokens** — Inter (body) + Noto Sans (fallback) + JetBrains Mono (code). Material 3 type scale (10 entries).
3. **Spacing / radius / stroke / elevation scales** — 4px-base spacing (xs=4 → 3xl=48), 5-rung radius, 3 stroke widths (integer px). **Elevation is color-based, not shadow-based.**
4. **Interaction state system** — M3 deterministic state-layer model: hover 8%, focus 12% + 2px ring, pressed 12%, dragged 16%, disabled 38%/12%.
5. **Per-Control theme entries** — 35 Control classes × all states populated.
6. **Type variations** — 13 in v1 (6 button, 5 label, 1 RichTextLabel, 2 panel).

**Major components:**

1. `neocade_theme.tres` — single artifact; references fonts and icons by `uid://`.
2. `addons/neocade_theme/fonts/` — Inter VF + Inter Italic VF + Noto Sans VF + `OFL.txt`.
3. `addons/neocade_theme/icons/` — bespoke SVGs + `.import` sidecars.
4. `res://main.tscn` — 9-section showcase + top bar with theme toggle.
5. `README.md` + `LICENSE.md` + `CHANGELOG.md` + `addons/neocade_theme/VERSION` + `.github/workflows/release.yml` — GitHub Releases distribution (no Asset Library in v1).

### Critical Pitfalls

The five non-obvious pitfalls every phase plan must internalise (full detail in `PITFALLS.md`):

1. **Focus stylebox is an OVERLAY, not a state** — `focus` does not have `hover_focus`/`pressed_focus`/`checked_focus` variants. Naive focus rings disappear under hover/pressed/checked. **Prevention:** design focus indicator as **outer ring** (drawn outside `corner_radius` bounds); test under every state combination; Tab-walk the entire showcase as a QA gate.
2. **PopupMenu / OptionButton popup is a separate Window** — popups own their own Viewport, theme resolution chain, texture filter. They do **not** inherit `theme_override` or texture filter from spawning Control. **Prevention:** theme `PopupMenu`, `PopupPanel`, `Window`, `AcceptDialog`, `ConfirmationDialog`, `FileDialog`, `TooltipPanel`, `TooltipLabel` as **first-class types**.
3. **Type variations don't inherit fonts from base type** (issue #80731) — stylebox inheritance works, font inheritance silently fails. **Prevention:** set fonts explicitly on every variation OR set fonts only on theme `default_font`. Editor preview hides this; only runtime QA catches it.
4. **Dark + neon = synthwave by default** — both prior inputs drift this way. **Prevention:** explicit warm-hue mandate (orange/yellow/red), >60% lightness on accents, no grid/scanline/chrome typography, side-by-side mockup comparison against real-arcade reference photos at the gate.
5. **GL Compatibility renderer divergence** — theme authored on Forward+ looks subtly different on Compatibility (shadow over-darkening, AA feathering, no 2D MSAA). **Prevention:** authoring AND QA must run on Compatibility; dual-renderer screenshot pass mandatory before v1 ships.

Other high-severity flagged: StyleBoxFlat shadow alpha bug (over-renders ~2× on GL Compat) → **policy: no drop shadows in v1**; SVG icons rasterise at import (Scale=2.0 + Linear With Mipmaps explicit per icon); 4.6 inspector edit crash (#115500); OFL "reserved name" footgun (never rename Inter/Noto binaries); `addons/` font path break (use `uid://`); project theme leaks into editor (README must document); color-blind safety (state combos through deuteranopia/protanopia/tritanopia simulators).

---

## Conflicts Resolved

### Conflict 1 — Display/heading font + bundle minimization — **FINAL 2026-05-04 (Option D)**

History: Outfit added (Conflict 1 revision) → reversed to Option B (Inter+NotoSans+JBMono per FONT-REVIEW.md applying consistency principle) → user pushed further on size minimization, noting `Font.allow_system_fallback=true` makes Noto Sans optional and CodeEdit usage is rare in shipped games. **Final decision: Option D — Inter Variable ONLY.**

**Final v1 bundle: Inter Variable Roman ONLY. ~810 KB. Matches godot-minimal-theme exactly.**

**Why minimal works:**
- **`Font.allow_system_fallback = true` (Godot 4.x default)** handles missing-glyph rendering automatically. Non-Latin text (Arabic, Hebrew, Hindi, Thai, CJK, etc.) renders via the user's OS system fonts — no tofu boxes, no bundle overhead. Every supported export target (Win/Mac/Linux/iOS/Android/Web) has system fonts covering these scripts.
- **CodeEdit / `[code]` BBCode is genuinely rare in shipped games.** Consumers who use it can override `theme.default_font` for that Control via documented README pattern.
- **Headings differentiate via `opsz=32` + heavier `wght`** — Apple HIG / Material 3 native pattern.

**Trade-off accepted:**
- Non-Latin scripts will render with system fonts — functional, but visually less harmonized with Inter. For consumers who care, README documents how to extend `default_font.fallbacks` with their preferred coordinated font (e.g., Noto Sans for Arabic/Hebrew/Indic, Noto Sans CJK for East Asian).
- CodeEdit users get unstyled-looking code unless they override.

**Implications propagated:**
- Phase 4 deliverables: bundle Inter Variable Roman + `OFL.txt`. NO Noto Sans, NO JetBrains Mono, NO Outfit, NO Inter Italic in v1.
- Theme wiring: `theme.default_font = Inter Variable; default_font.fallbacks = []; default_font.allow_system_fallback = true (default).` Heading type variations use Inter at higher opsz/wght.
- CodeEdit and RichTextLabel `[code]` get NO theme-bundled mono — README documents the override pattern for consumers who need it.
- Phase 3 mockup gate's typography step: 1 typography mockup confirming Inter is sufficient + a sample showing CJK/Arabic system-fallback rendering for visual review.
- v1.x roadmap items: bundle Noto Sans (designed-together cross-script harmony) + bundle Inter Italic (true italic) + optional JetBrains Mono.

### Conflict 2 — Surface token taxonomy: M3 5-stop ramp vs prototype's Base/Secondary/Panel/Raised/Elevated

**ARCHITECTURE.md** recommended Material 3 tonal ramp (5 stops). **FEATURES.md** recommended preserving prototype naming but ADDING `surface.sunken` and `surface.overlay` (7 stops). **Prototype itself** uses 5 stops with prototype's naming.

**Decision: Adopt the M3 5-stop surface ramp as canonical, with internal alias map back to prototype's friendlier names. Adopt FEATURES' `surface.overlay` insight by mapping it to `surface-container-highest`. Reject `surface.sunken` for v1.**

| M3 token | Friendlier alias | Use |
|---|---|---|
| `surface` | base | Window/scene background |
| `surface-container-low` | secondary | Tab inactive, scroll track, secondary panels |
| `surface-container` | panel | Default Panel/PanelContainer, GraphEdit grid |
| `surface-container-high` | raised | Button normal, LineEdit, dropdown |
| `surface-container-highest` | overlay | PopupMenu, Tooltip, AcceptDialog, modals over content |
| `outline` | stroke.default | Border default |
| `on-surface` / `on-surface-variant` / `on-surface-muted` | text.strong / text.default / text.muted | Text colors |

**Reasoning:** M3 names are canonical for v2 alt-palettes / light-mode work. Prototype names are friendlier in user-facing mockup labels. Documented aliases preserve both. `surface.sunken` rejected for v1 — depth-via-color-only philosophy doesn't have a natural sunken story; inputs are visually distinguished via focus/normal stylebox + corner radius.

### Conflict 3 — Shadows policy

**ARCHITECTURE.md** allowed shadows on large surfaces with low alpha. **STACK.md** allowed same with GL Compat caveat (issue #23640 over-darkens). **FEATURES.md** locked **"no drop shadows on panels"** as anti-feature AF-13.

**Decision: FEATURES wins — no drop shadows in v1. Elevation conveyed through color surface ramp ONLY.**

**Reasoning:** All three docs agree GL Compat over-renders shadow alpha (~2×); bug open since 2018 (#23640). Designing for a known-broken renderer is not pragmatic. M3 elevation principle in our context is "taller surfaces use lighter tones," not "taller surfaces have shadows." Optional small accent allowed: 1px lighter top-bevel border on raised buttons (`border_width_top=1` + lighter `border_color`) — implements arcade button cap highlight without engaging the broken shadow path. Design-token phase explicitly documents `shadow_size = -1` (the disable value per #98162) on every StyleBoxFlat.

---

## Open User Decisions

### UD-1: MCP server swap (decision before Phase 10 QA tooling baseline sub-spike)
Currently wired Coding-Solo `godot-mcp` lacks screenshot capture; PROJECT.md mandates screenshot-driven QA. **Recommend: swap to GoPeak Godot MCP** (`npx gopeak`) before QA phases begin. Alternates: GDAI MCP, Godot MCP Pro.

### UD-2: CJK font bundling
Default v1 ships without CJK (~30 MB+ doubles addon size); README documents override path. **Recommend: confirm default — defer CJK to v2 or optional bundle.** Decision must land before Phase 4 commits the font folder structure.

### UD-3: Stylebox authoring tooling — UPDATED post-CROSS-PLATFORM
PROJECT.md mandates Godot's Theme Editor as the authoring path. CROSS-PLATFORM introduced a `@tool` script generator (`addons/neocade_theme/_dev/generate_themes.gd`) producing both desktop and mobile `.tres` from a single TokenSet block. **Reconciled recommendation: the `@tool` generator is the PRIMARY authoring path for tokenized properties (colors, font sizes, paddings, radii) — TokenSet is the single source of truth. Godot's Theme Editor is the VERIFICATION surface (open the generated `.tres` to visually confirm) and the targeted-edit path for non-tokenized one-off properties.** Both paths are committed to v1; Phase 4 establishes the workflow.

### UD-4: Inter Italic — v1 vs v1.x — RE-RESOLVED post-FONT-REVIEW
**Resolution: defer Inter Italic to v1.x.** Original Conflict-1-revision rationale (swap Italic out, Outfit in) no longer applies — Outfit is dropped per consistency principle. Inter Italic deferral now driven purely by bundle-size economy (~+0.85 MB for a feature body text uses sparingly). Synthetic italic transform carries v1. User can override at Phase 3 typography mockup gate.

### UD-5 (NEW): Real-device cross-platform testing matrix
CROSS-PLATFORM requires per-target export validation. Real-device coverage needs: 3 Android devices (low/mid/high-end); iOS testing requires Mac + paid Apple Developer Program. **User hardware/account status is unknown.** Phase 10 acceptance criteria must be marked with `(if-real-device-available)` qualifier where applicable. **Decision needed before Phase 10 plan is authored:** confirm available test surfaces, identify gaps, decide whether v1 ships with "verified on Windows/macOS/Linux/Web; mobile-targets pending real-device QA in v1.0.1" or with full mobile coverage.

### UD-6 (NEW): AccessKit / VoiceOver / TalkBack screen-reader integration
Godot 4.6 has partial screen-reader integration via AccessKit. CROSS-PLATFORM flags full integration as v1.x or v2 work. **Recommend confirm:** v1 sets `accessibility_name` on every showcase Control (cheap win) but defers deeper screen-reader QA to v1.x. If user wants screen-reader QA in v1, Phase 10 needs additional acceptance criteria + estimated +4-8 hours.

---

## Visual Direction (Recommended)

| Palette | Personality | Best for |
|---|---|---|
| **A. Midnight Marquee** (refined prototype) | Cool deep navy + warm pink + amber focus. | If user feels Boardwalk Sunset is too warm. |
| **B. Boardwalk Sunset** _(RECOMMENDED)_ | Warm-neutral pine surface (`#1A1410`), amber `#FFB347` primary, coral `#FF6B8A` secondary, mint-teal `#5DD3C3` tertiary. | Smallest move that respects prototype while landing arcade-by-day brief. |
| **C. Cabinet Chrome** | Neutral charcoal `#1E2229` (LDtk's `$bgDark`) + signature orange `#FFB020` + cool blue `#5C9CFF`. | Disciplined fallback; closest to godot-minimal-theme ethos. |

All three pass WCAG 2.1 AA on body text and SC 1.4.11 (3:1 non-text) on accents. Full contrast tables in `ARCHITECTURE.md` Section 1.

**Typography (FINAL — Option D):** **Inter Variable Roman ONLY.** Single bundled font (~810 KB). Headings use `opsz=32` + heavier `wght`. Non-Latin scripts via Godot's `Font.allow_system_fallback=true`. Italic via synthetic transform (Inter Italic deferred to v1.x). CodeEdit/code surfaces via consumer-side override (no bundled mono in v1). M3 type scale: display-small 36 (Inter opsz=32 wght=800) / headline-small 24 (Inter opsz=32 wght=700) / title-large 20 (Inter opsz=24 wght=600) / body-medium 14 (Inter wght=400) / code 13 (consumer-supplied mono).

**Geometry:** corner radius default 4px (godot-minimal-theme parity), 8px on PopupPanel/Window, 12px on dialogs. 1px hairline borders default; 2px focus rings; 3px reserved for danger emphasis. **No drop shadows; tonal surface ramp is the elevation system.**

**State system:** M3 deterministic transforms — hover 8%, focus 12% + 2px outer ring in `primary`, pressed 12%, disabled 38%/12%.

---

## Implications for Roadmap

Updated structure: **11 phases** post-CROSS-PLATFORM. Phases 1-3 are research/design spikes (no `.tres` edits). Phases 4-8 are implementation (with mobile variant interleaved). Phase 9-10 are QA/cross-platform validation. Phase 11 is distribution. **Mockup approval gate falls between Phase 3 and Phase 4.**

**Phase order (post-CROSS-PLATFORM):**
- Phase 1: Source-Dive Spike — godot-minimal-theme `.tres` dissection
- Phase 2: Source-Dive Spike — LDtk source code UI mining
- Phase 3: Visual Direction Mockup Phase (3-step approval gate, mockups must include desktop+mobile representations) **+ MCP/QA tooling baseline sub-spike (UD-1 GoPeak swap) + real-arcade reference photo collection**
- **[GATE: User mockup approval. No `.tres` edits before this passes.]**
- Phase 4: Foundation — Tokens, Fonts, Icons, Scaffold + **`@tool` theme generator script** (`addons/neocade_theme/_dev/generate_themes.gd`) producing BOTH desktop and mobile `.tres` from shared TokenSet
- Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop authoring)
- Phase 6: Lists, Layout, Range — Tree, ItemList, Tabs, Containers, Sliders (desktop authoring)
- Phase 7: Dialogs, Popups, Advanced — Window, Popups, MenuBar, ColorPicker, Graph (desktop authoring)
- **Phase 8 (NEW): Mobile Variant Authoring** — Mobile token overrides (tap targets 48px / body 16px / spacing +50%); generator outputs `neocade_mobile_theme.tres`; tap-target audit script; mobile showcase variant or toggle. Estimated 12-18 hours. Interleaved with phases 5-7 in practice (token overrides accrue as desktop entries land).
- Phase 9: Showcase + Token Gallery + Theme Toggle — `res://main.tscn`; desktop+mobile theme toggle in addition to NeoCade↔Godot toggle.
- **Phase 10 (NEW/EXPANDED): QA + Cross-Platform Export Validation** — Dual-renderer screenshot pass (Forward+ vs GL Compat); per-target export builds (Windows/macOS/Linux/iOS/Android/Web) with screenshot decks; CI workflow for desktop + Web targets; manual Android+iOS validation; accessibility QA (WCAG, focus stylebox audit, CVD simulation); fresh-install dry-run. Estimated 8-12 hours plus device time.
- Phase 11: Distribution — GitHub Actions release workflow (modeled on Shilo/PentaTile release.yml); auto-version-bump from `addons/neocade_theme/VERSION`; CI gates (headless import + showcase open); commit/tag/push; addon zip via `git archive`; Godot Web export of showcase scene; GitHub Release publishes both zips as assets; **web build auto-deployed to GitHub Pages for instant browser-playable showcase** (`https://<owner>.github.io/<repo>/`). NO Asset Library in v1.
- **Optional buffer:** Cross-Platform Hardening Spike (4-8 hours) inserted before Phase 11 if real-device regressions surface.

### Phase 1: Source-Dive Spike — godot-minimal-theme `.tres` dissection
**Rationale:** PROJECT.md names this top-value source requiring dedicated spike. Initial pass extracted README values (Inter, `#272727`, `#569eff`, 4-5px radius) but did NOT enumerate the `.tres`'s actual entries per Control × state. Godot 4.6 ships its productized port as the new default — line-by-line list needed for "feature-complete to godot-minimal-theme's bar" claims.
**Delivers:** SOURCES.md updated with full enumeration; concrete coverage delta vs FEATURES.md 35-class list.
**Avoids:** Pitfall 6.1 (lifting numerics verbatim).
**Research flag:** YES.

### Phase 2: Source-Dive Spike — LDtk source code UI mining
**Rationale:** PROJECT.md says user wants "all of [LDtk source] read for UI." Initial pass extracted palette from `app/assets/css/app.scss` and noted `res/fonts/`, but did NOT mine `src/electron.renderer/` UI patterns.
**Delivers:** SOURCES.md updated with concrete UI patterns to adopt (file paths, line refs) and patterns explicitly rejected.
**Avoids:** Identity drift via real polished-UI anchors rather than imagined ones.
**Research flag:** YES — Haxe code reading required.

### Phase 3: Visual Direction Mockup Phase (3-step approval gate)
**Rationale:** PROJECT.md mandates mockup approval before any `.tres` styling. ARCHITECTURE.md Section 6 specifies workflow.
**Delivers:** 3 HTML/SVG palette mockups (A/B/C) → user picks → 2 typography mockups → user picks → 1 full-fidelity Control gallery → user APPROVES (or revises, max 3 rounds). Output: approved `DESIGN_TOKENS.md` + `.planning/mockups/*.html` archive.
**Avoids:** Pitfalls 7.1-7.4 (cyberpunk drift); 6.1 (minimal-theme verbatim).
**Sub-spike:** real-arcade reference photo collection (Round1 / Dave & Buster's / Two Bit Circus interior shots) before mockup production.
**Research flag:** YES.

**[GATE: User mockup approval. No `.tres` edits before this passes.]**

### Phase 4: Foundation — Tokens, Fonts, Icons, Scaffold + `@tool` Generator
**Rationale:** Token system blocks every stylebox; fonts block per-Control text styling; icons block buttons/Tree/TabBar/ColorPicker/FileDialog/PopupMenu/ScrollBar. Per CROSS-PLATFORM, both desktop and mobile `.tres` are generated from a single `TokenSet` block via a `@tool` script — Foundation phase establishes that mechanism so subsequent phases populate one source of truth.
**Delivers:** `addons/neocade_theme/fonts/` (Inter Variable + Outfit Variable + Noto Sans Variable + `OFL.txt`; per Conflict 1 revision, no Inter Italic in v1); `addons/neocade_theme/icons/` (~30 SVGs at 32×32, Scale=2.0 + Linear With Mipmaps); `addons/neocade_theme/_dev/generate_themes.gd` `@tool` script with `TokenSet` constants block; first-run output of empty-but-valid `neocade_theme.tres` and `neocade_mobile_theme.tres` scaffolds; `DESIGN_TOKENS.md` finalized.
**Implements:** Architecture layers 1-3 + token-sharing strategy.

### Phase 5: Core Controls — Buttons, Inputs, Labels, Panels (desktop authoring)
**Rationale:** Button is keystone; Labels carry typography system; Panels carry elevation system. Desktop entries authored first; mobile overrides accrue in TokenSet.mobile alongside.
**Delivers:** Button + 6 button variations × 5 states; LineEdit + TextEdit + CodeEdit + SpinBox; Label + RichTextLabel + 5 label variations; Panel + PanelContainer + 2 panel variations; Checkbox/CheckButton/OptionButton/MenuButton/ColorPickerButton/LinkButton; bespoke button-state icons.
**Avoids:** Pitfalls 1.1 (focus overlay), 1.2 (font inheritance fail), 1.4 (shadow alpha bug — disabled).

### Phase 6: Lists, Layout, Range — Tree, ItemList, Tabs, Containers, Sliders (desktop authoring)
**Rationale:** Tree alone is half-day (16 styleboxes, 12 icons); TabBar/TabContainer share state model.
**Delivers:** Tree + ItemList + TabBar + TabContainer + FoldableContainer; all container constants; Splits + Separators + ScrollContainer; HSlider + VSlider + ProgressBar + HScrollBar + VScrollBar.

### Phase 7: Dialogs, Popups, Advanced — Window, Popups, MenuBar, ColorPicker, Graph (desktop authoring)
**Rationale:** Popup-class controls are separate Windows (Pitfall 1.7) — must be themed as first-class types.
**Delivers:** Window + AcceptDialog + ConfirmationDialog + FileDialog; PopupMenu + PopupPanel + TooltipPanel + TooltipLabel; MenuBar; ColorPicker + 16 bespoke icons; GraphEdit + GraphNode + GraphFrame (basic).
**Avoids:** Pitfall 1.7 (popup theming); 4.3 (tooltip readability).

### Phase 8 (NEW post-CROSS-PLATFORM): Mobile Variant Authoring
**Rationale:** PROJECT.md elevates mobile variant to v1 must-have. CROSS-PLATFORM specifies concrete mobile token deltas (button height 48px / body 16px / spacing +50% on space.4+; corner radii identical for brand identity). The `@tool` generator authored in Phase 4 produces the mobile `.tres` from a TokenSet.mobile override block — this phase fills that block, validates against tap-target audit, and confirms parity.
**Delivers:** `addons/neocade_theme/_dev/generate_themes.gd` filled with TokenSet.mobile overrides; generated `neocade_mobile_theme.tres` committed; `MOBILE-DESIGN-SPEC.md` documenting deltas vs desktop; tap-target audit script (every interactive Control ≥48px in mobile theme); showcase variant toggle (NeoCade desktop ↔ NeoCade mobile ↔ Godot default) — three-way toggle.
**Interleaving note:** In practice, mobile token overrides accrue in parallel with Phases 5-7 desktop authoring (each desktop entry surfaces its mobile delta). Phase 8 is the dedicated mobile-completeness checkpoint and audit.
**Avoids:** Token drift between desktop and mobile (structurally impossible with `@tool` generator); manual sync errors.
**Estimated:** 12-18 hours.

### Phase 9: Showcase + Token Gallery + Theme Toggle
**Rationale:** PROJECT.md mandates showcase + prominent toggle. Showcase doubles as QA forcing function. With mobile variant in v1, the showcase scene also demonstrates the desktop ↔ mobile theme switch.
**Delivers:** `res://main.tscn` with 9 sections (Buttons, Text Inputs, Numbers/Range, Selection/Lists, Containers/Layout, Dialogs/Popups, Advanced/Graph, Token Gallery, Coverage 35/35); three-way theme toggle button (NeoCade desktop ↔ NeoCade mobile ↔ Godot default) with inline overrides (Pitfall 10.3); BBCode demo; `accessibility_name` on every Control (Pitfall 2.5); realistic sample content per Control (Pitfall 10.1).

### Phase 10 (EXPANDED post-CROSS-PLATFORM): QA + Cross-Platform Export Validation
**Rationale:** PITFALLS flags multiple QA gates pre-ship. CROSS-PLATFORM elevates per-target export validation to v1 must-have. This phase combines visual QA, accessibility QA, dual-renderer screenshot pass, and per-target export validation.
**Delivers:**
- **Visual QA matrix:** screenshot pass (9 showcase sections × Forward+ + GL Compat × 1080p/1440p/4K × 100%/150%/200% scale) — produces `.planning/qa/screenshots/` reference set.
- **Accessibility QA:** WCAG 2.1 AA audit signed off; focus stylebox audit (Tab-walk every Control, screenshot the focused state); deuteranopia/protanopia/tritanopia CVD simulation pass; multi-script label test (Latin/Cyrillic/Arabic/Hebrew/Devanagari).
- **Cross-platform export validation:** per-target export builds (Windows, macOS, Linux, iOS, Android, Web/Browser); per-target screenshot decks; CI workflow for desktop+Web (Linux runner via headless export); manual Android+iOS validation on real devices (or noted as deferred if hardware unavailable — see UD-5).
- **Sub-spike at start of phase:** MCP/QA tooling baseline (UD-1 resolution + GoPeak smoke test) — required before screenshot capture begins.
**Estimated:** 8-12 hours plus device time.
**Avoids:** All distribution pitfalls (9.x); all QA pitfalls (8.x); cross-platform regressions (CROSS-PLATFORM Section 1).

### Phase 11: Distribution — GitHub Actions Release Workflow
**Rationale (REVISED 2026-05-04):** Final pre-ship gate. Distribution is GitHub Releases via a single manually-triggered GitHub Actions workflow modeled on [Shilo/PentaTile release.yml](https://github.com/Shilo/PentaTile/blob/main/.github/workflows/release.yml). **No Asset Library submission in v1.**
**Delivers:** `.github/workflows/release.yml` (workflow_dispatch, no inputs); `addons/neocade_theme/VERSION` single-line version source; auto-version-increment policy; CI gates (headless import + showcase scene open); version commit + tag + push; addon zip via `git archive`; Godot Web export of `main.tscn` packaged as `neocade_theme-showcase-web-v<VERSION>.zip`; CHANGELOG slice extraction for release body; GitHub Release published via `softprops/action-gh-release@v3` attaching both zips. Plus `OFL.txt` (Inter only per Option D), `LICENSE.md`, `CHANGELOG.md` with `[Unreleased]` section pre-populated.
**Avoids:** Submission rejection (font license oversights, missing README sections, malformed icon).

### Optional Buffer: Cross-Platform Hardening Spike
**When:** Inserted before Phase 11 only if Phase 10 surfaces real-device regressions.
**Delivers:** targeted fixes per regression, re-run of relevant Phase 10 acceptance criteria.
**Estimated:** 4-8 hours.

### Phase Ordering Rationale (post-CROSS-PLATFORM)
- Research/spike (1-3) precedes implementation (4-9) per mandatory mockup gate.
- Foundation (4) establishes the `@tool` generator and TokenSet structure — every later phase populates the one source of truth.
- Desktop core authoring (5-7) → Mobile variant authoring/audit (8) → Showcase (9): mobile overrides depend on desktop entries existing.
- QA + Cross-Platform Validation (10) requires both themes complete and the showcase scene ready.
- Distribution (11) is last — GitHub Actions release pipeline (CI checks → version bump → addon zip + web export → GitHub Release publish). No Asset Library in v1.

### Research Flags
**Phases needing per-phase RESEARCH.md:** Phase 1 (godot-minimal-theme `.tres` dissection), Phase 2 (LDtk Haxe-source UI mining), Phase 3 (mockup phase — real-arcade reference photo collection + MCP tooling baseline). Phase 11 needs no research (GitHub Actions workflow modeled directly on PentaTile reference).

**Phases with standard patterns (skip research-phase):** Phase 4 (Foundation — patterns established by FEATURES.md and CROSS-PLATFORM), Phase 5/6/7 (per-Control authoring — entry tables authoritative; only Tree and ColorPicker may want sub-research per complexity), Phase 8 (Mobile Variant Authoring — overrides driven by CROSS-PLATFORM Section 3 numerics), Phase 9 (Showcase — well-covered by FEATURES.md Section 5), Phase 10 (QA — checklist-driven from PITFALLS).

**Additional dedicated spikes recommended (some folded into Phases 1-3 above):**
- MCP/QA tooling baseline spike (UD-1 + GoPeak smoke test).
- Real-arcade visual reference collection (mood board pre-mockup).
- Accessibility QA phase (focus stylebox audit + CVD simulation + screen-reader sanity).
- Visual-direction mockup phase (3-step approval).
- Dual-renderer screenshot pass (Forward+ vs GL Compatibility).
- Fresh-install dry-run pre-Asset-Library submission.

---

## Confidence Assessment

| Area | Confidence | Notes |
|---|---|---|
| Stack | HIGH | Godot 4.6 Theme/Font/StyleBox API verified via WebFetch (Context7 had upstream MCP issues during research); Inter v4 / Noto Sans / OFL terms verified. MEDIUM on Asset Library policy nuance; LOW on hands-on Coding-Solo `godot-mcp` vs GoPeak comparison. |
| Features | HIGH | Coverage matrix and per-Control theme entry enumeration cross-checked against official Godot 4.6 docs; godot-minimal-theme as completeness benchmark. MEDIUM on token taxonomy (synthesized from M3 + prototype critique). |
| Architecture | HIGH | M3 type scale and state-layer opacities pulled from upstream `material-web` SCSS; LDtk palette from real `app.scss` with file path; godot-minimal-theme from upstream README; WCAG via W3C luminance formula. MEDIUM on real-arcade visual interpretation (D&B brand color is single-source). |
| Pitfalls | HIGH | Most items backed by Godot issue numbers/PRs. MEDIUM on visual identity drift sections (7.x — synthesized from multiple aesthetic-wiki sources). |
| Cross-Platform | HIGH (Godot/iOS HIG/Material 3 numerics, font licensing); MEDIUM (Web export real-world reliability, real-device coverage) | All findings folded in 2026-05-04. Per-target table verified, mobile spec concrete, token-sharing strategy verified against Godot Theme API limits. Real-device testing matrix is open (UD-5). |

**Overall confidence:** HIGH on technical surface; MEDIUM on visual-identity direction (resolved via mockup gate); LOW on two source-dive areas explicitly flagged for follow-up phases.

### Gaps to Address
- godot-minimal-theme `.tres` actual entries (README-level only) → Phase 1 spike.
- LDtk `src/electron.renderer/` UI patterns (not opened) → Phase 2 spike.
- Real-arcade reference photos (MEDIUM-confidence visual interp) → Phase 3 mood-board sub-phase.
- MCP screenshot tooling validated end-to-end → UD-1 + Phase 3 sub-phase.
- Per-state-combination accessibility math (focus+hover, focus+pressed, etc.) → Phase 9 accessibility QA.
- ~~Asset Library policy current at submission~~ — **N/A 2026-05-04: no Asset Library in v1; distribution is GitHub Releases only.**
- 4.6.x crash workarounds for inspector edits (#115500) — verify against latest 4.6 stable at start of Phase 5.
- Cross-platform export support (all 6 targets) and mobile variant — pending CROSS-PLATFORM researcher completion.

---

## Sources

### Primary (HIGH confidence)
- Godot 4.6 official docs (Theme, StyleBox, StyleBoxFlat, Theme Type Variations, Using Fonts, FontFile, FontVariation, all Control class pages)
- Godot 4.6 release notes
- Material Design 3 — Color roles, Type scale tokens, State layers, Spacing — incl. upstream SCSS source
- WCAG 2.1 SC 1.4.3, 1.4.11, 2.4.7
- W3C luminance formula (used for all contrast computations)
- Inter font (rsms.me/inter, github.com/rsms/inter) — v4.1, OFL 1.1
- Noto Sans (notofonts.github.io)
- SIL Open Font License 1.1 (openfontlicense.org/ofl-faq)
- godot-minimal-theme (github.com/passivestar/godot-minimal-theme)
- LDtk source at `C:\Programming_Files\ldtk-master\app\assets\css\app.scss` lines 1-24
- Godot issues: #87226, #23640, #69462, #80731, #82199, #30856, #74489, #115500, #113872, #76119, #97902, #73491, #112700, #74694, #67401, #74200, #102509, #74267, #110548, #77443, #117159, #112247, #82504, #19887, #63606, #98162
- Asset Library submission docs

### Secondary (MEDIUM confidence)
- Dave & Buster's brand palette (1000logos.net/dave-busters-logo)
- Round One Corporation (Wikipedia)
- Arcadecore aesthetic (aesthetics.fandom.com/wiki/Arcadecore)
- Material Theme Builder
- GoPeak Godot MCP (github.com/HaD0Yun/Gopeak-godot-mcp) — verified screenshot capture
- Coding-Solo godot-mcp — verified NO screenshot capture (must swap)
- godot-demo-projects/gui/control_gallery — showcase scope
- Lethal Audio / Aesthetics Wiki — synthwave/cyberpunk shared aesthetic articulation
- bugnet.io, kidscancode.org, Godot forum threads

### Tertiary (LOW confidence — needs follow-up)
- Real-arcade interior visual references (curated mood board not yet collected) → Phase 3
- godot-minimal-theme `.tres` line-by-line (README-only in initial pass) → Phase 1
- LDtk `src/electron.renderer/` UI patterns (not opened) → Phase 2
- User's prior `NeoCade-Research-Report.md` and `NeoCade-Theme-Prototype.png` — challenged claim-by-claim and element-by-element in `SOURCES.md`; many claims rejected per anti-cyberpunk and HD-only constraints

---
*Research synthesized: 2026-05-04*
*Ready for roadmap: yes (with three open user decisions surfaced — UD-1 MCP swap, UD-2 CJK bundling, UD-3 stylebox authoring tooling, plus pending cross-platform addendum)*
