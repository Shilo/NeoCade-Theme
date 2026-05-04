# Stack Research — NeoCade Godot UI Theme

**Domain:** Godot 4.6 UI Theme addon (drop-in `.tres` resource + bundled fonts)
**Researched:** 2026-05-04
**Overall confidence:** HIGH on Godot/Theme/font specifics; MEDIUM on Asset Library policy nuances; LOW on long-tail icon licensing edge cases.

---

## TL;DR — The 5 Decisions That Must Be Locked Before Implementation

These supersede every other recommendation below. Lock them at the end of design phase, before any `.tres` styling is committed.

| # | Decision | Recommendation | Confidence | Why It Must Be Locked First |
|---|---------|----------------|------------|---------------------------|
| 1 | **Font distribution model** | Bundle Inter v4.x **upright variable + italic variable** as two `.ttf` files (NOT the static OTF set) + Noto Sans Variable for fallback. Use `FontVariation` with `wght` axis for weights, separate file for italic. | HIGH | Determines theme item structure, .tres complexity, addon size (~2-3 MB vs ~25 MB for static set), and italic correctness. |
| 2 | **Icon strategy** | Author **a small bespoke SVG icon set (~25-40 icons)** for the theme's intrinsic Godot icon slots (checkbox tick, dropdown arrow, tree expand, etc). Do NOT bundle Material Symbols / Lucide / Phosphor as a general icon font. | HIGH | Theme intrinsic icons have hard-coded names per Control class — generic libraries don't map 1:1. Asset Library size limits and license-stacking favor minimal bespoke set. |
| 3 | **Display/heading font policy** | NO arcade display font in v1. Use Inter Display optical sizing (`wght 700-900`, larger size) for marquee/headline feel. Arcade aesthetic comes from **color, glow-via-border-color, and stylebox geometry** — not font novelty. | HIGH | User explicitly rejected pixel fonts for HD constraint and rejected synthwave/retro affectations. Adding a display arcade font reopens the rejected aesthetic. |
| 4 | **StyleBox geometry baseline** | All interactive surfaces use `StyleBoxFlat` with `corner_radius >= 2` (forces AA on), `anti_aliasing = true`, `anti_aliasing_size = 1.0`. Avoid `corner_radius = 0` on focus/hover boxes. Avoid `StyleBoxTexture` for chrome. No drop-shadow on small controls (banding in GL Compatibility). | HIGH | StyleBoxFlat AA only renders with non-zero corner radius (Godot issue #87226). GL Compatibility renderer has known shadow/AA quirks — designing around the limit is faster than fighting it. |
| 5 | **Addon shape: theme-resource-only, no `plugin.cfg`** | Ship as `addons/neocade_theme/` containing `neocade_theme.tres` + `fonts/` + `icons/` + `LICENSE` + `README.md`. No `plugin.cfg`, no `EditorPlugin` script, no autoload. Users apply via Project Settings → GUI → Theme → Custom or per-scene `theme = preload(...)`. | HIGH | The PROJECT spec already mandates "no plugin scripts in v1." `plugin.cfg` is for editor *plugins*; theme-only addons don't need it. Keeps addon footprint clean. |

---

## Recommended Stack

### Core Technologies

| Technology | Version | Purpose | Why Recommended |
|------------|---------|---------|-----------------|
| **Godot Engine** | 4.6 stable (current as of Jan 2026; `config_version=5`) | Target engine | Project is locked to 4.6; the 4.6 release introduced the "Modern" editor theme (port of Minimal Theme), focus-stylebox decoupling (mouse vs keyboard focus), `pivot_offset_ratio`, and live-updating editor themes — all material to our work. |
| **`Theme` resource (`.tres`)** | Godot 4.6 native | Single artifact that holds every theme item | Native, version-controlled, editor-authorable, hot-reloadable. The PROJECT mandates `res://addons/neocade_theme/neocade_theme.tres`. |
| **`StyleBoxFlat`** | Godot 4.6 native | Primary chrome primitive (buttons, panels, popups, etc.) | Pure-vector, GPU-rendered, scales infinitely → satisfies HD-first constraint. Gives us border, corner radius, expand margin, shadow, AA, skew without textures. **No shaders required — meets PROJECT constraint.** |
| **`StyleBoxLine`** | Godot 4.6 native | Separators (HSeparator/VSeparator), tab underlines | Cheaper/simpler than StyleBoxFlat for 1-D dividers. |
| **`StyleBoxEmpty`** | Godot 4.6 native | Invisible spacers / state-equivalent boxes | For state where we want layout consistency but no visible chrome (e.g., `TabBar`'s tab_unselected may use empty). |
| **`FontFile`** | Godot 4.6 native | The imported font binary | One per `.ttf` we bundle (upright + italic + fallback). |
| **`FontVariation`** | Godot 4.6 native | Per-weight derivation from a single variable font | Lets us use ONE Inter variable file for Regular(400)/Medium(500)/SemiBold(600)/Bold(700) by setting `variation_opentype.wght`. Halves the font-file count vs static weights. |
| **C# / .NET** | enabled in project.godot | Already enabled at project level | Theme itself ships **no C#** — pure resources. .NET is irrelevant to the v1 deliverable but inert. |
| **Renderer: GL Compatibility** | locked in project.godot | Broad device reach (web/mobile) | Constrains design (see Pitfalls research): no MSAA in 2D, StyleBoxFlat AA needs non-zero corner radius, alpha-to-coverage is broken — but is the right call for a theme that must "just work" on any device a Godot game targets. |

### Supporting Libraries (Bundled Assets)

| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| **Inter Variable (roman)** | v4.1 (Nov 2024 release; latest as of May 2026) | Primary UI typeface (Latin/Cyrillic/Greek, ~2000 glyphs, 147 langs) | Every text-bearing Control. The 4.6 editor's "Modern" theme also recommends Inter — choosing it harmonizes NeoCade with the editor's own aesthetic. |
| **Inter Variable (italic)** | v4.1 | True italic typeface (Inter v4 split italic into separate VF file) | RichTextLabel `[i]`, Tree italic items, code editors. **Required**: synthetic skew via `FontVariation.variation_transform` is a fallback only — Inter v4 has true italics, use them. |
| **Noto Sans Variable** | latest from notofonts.github.io (covers 162/168 Unicode 16 scripts) | Fallback for every script Inter doesn't cover (Arabic, Hebrew, Devanagari, Thai, etc.) | Wired as `FontFile.fallbacks` on the primary Inter font. CJK is too large to bundle (~30 MB+); document a "for CJK, override the theme's default_font with Noto Sans CJK" path instead of bundling. |
| **Noto Sans Mono Variable** | latest | Monospace fallback (CodeEdit, RichTextLabel `[code]`) | Optional v1.x. v1 can ship without and let CodeEdit use system mono; or bundle if budget allows (~500 KB variable). |
| **Bespoke SVG icon set** | authored in-house, ~25-40 icons | Theme intrinsic icons (checkbox check, radio dot, dropdown arrow, tree arrow open/closed, file/folder for FileDialog, color picker eyedropper, etc.) | These map 1:1 to specific theme icon slots in Godot Control classes. Authored at 32×32 reference, imported with Scale=2.0 for HD. **NOT a general-purpose icon library.** |

### What's NOT in the Stack (Explicit Rejections)

| Tool | Why Not | What We Use Instead |
|------|---------|---------------------|
| Material Symbols icon font | Apache 2.0 license is fine, but: (a) bundles thousands of icons we'll never use (4+ MB minimum), (b) uses font-glyph mapping (string codepoints) which doesn't fit Godot's Texture2D-per-icon-slot theme model, (c) optical-size axis is web-tuned. | Bespoke SVG set authored to fit Godot's exact icon slot list. |
| Lucide / Tabler / Phosphor as bundled libraries | Same Texture2D-per-slot mismatch. Lucide is ISC, Tabler MIT, Phosphor MIT — all redistributable, but bundling 1500+ icons for the ~30 we actually need is wasteful. | If the consuming project wants a general icon library, the existing Lucide-icons Godot Asset Library plugin (asset/5047) handles that — orthogonal to our theme. |
| `EditorPlugin` script | PROJECT spec: "no plugin scripts in v1." | Users apply theme via Project Settings → GUI → Theme → Custom, or per-scene preload. |
| `plugin.cfg` | Editor plugin metadata; we are not an editor plugin. Users would see us toggleable in Plugins panel even though we have no enable/disable behavior — confusing. | Plain addon folder with README.md as the entry point. |
| `StyleBoxTexture` for chrome | Texture-based — pixel-locked at one resolution, fights HD-first goal. Also requires shipping PNGs that don't scale. | `StyleBoxFlat` everywhere. Reserve `StyleBoxTexture` ONLY for marquee/decorative elements that are intentionally raster (none in v1). |
| Custom shaders | PROJECT spec: "no custom shaders for control rendering — keep within Theme/StyleBox primitives for portability." | StyleBoxFlat properties (`bg_color`, `border_color`, `expand_margin`, `shadow_*`, AA) cover every visual we need. |
| GDExtension | PROJECT spec: out of scope. | Pure resource theme. |
| Pixel font (any variant) | PROJECT explicitly rejects pixel fonts including for logos/headlines (HD-only constraint). The user's prior research report suggesting a pixel font for logos is **wrong** for this project. | Inter Display weights (700-900) at large sizes for headline impact. |
| Synthwave/scanline/glow effects | PROJECT explicitly rejects "synthwave/vaporwave/scanline/glow-effect aesthetic." User's prior research report leaned into these — **must be ignored.** | Arcade warmth via color (saturated but not neon-noir), border accents, slightly elevated stylebox layering. "Vibrant arcade hall by day, not neon noir alley by night." |
| `SystemFont` fallback | Defeats the "consistent across machines" promise of a designed theme — system font choice varies wildly across Windows/macOS/Linux/web/mobile. | Bundle Inter + Noto Sans. Document CJK override path. |

### Development Tools

| Tool | Purpose | Notes |
|------|---------|-------|
| **Godot 4.6 Theme Editor** (built-in) | Primary authoring surface for the .tres | Use the bottom Theme panel + per-Control inspector overrides during design exploration. PROJECT mandates this over hand-writing the .tres. |
| **GoPeak Godot MCP** (`npx gopeak`) | MCP server with 95-110+ tools incl. screenshot capture (editor + running game), input injection, scene management, ClassDB introspection, theme tools | **Recommended primary MCP** for this project. Has explicit screenshot capture (the PROJECT mandate), input injection (lets us hover/press/focus controls programmatically for state coverage screenshots), and theme inspection tools. Installs via `npx gopeak`. |
| **Coding-Solo godot-mcp** | Alternative MCP — launch editor, run project, capture *debug output* (text only) | **NOT screenshot-capable** — confirmed in WebFetch. Use for headless launch / log scraping only. Don't pick it as the primary. |
| **GDAI MCP / Godot MCP Pro / PurpleJelly godot-mcp** | All offer editor + running-game screenshot capture | Reasonable secondary options if GoPeak has gaps. PurpleJelly's is itch.io-distributed; GoPeak is the open-source npm package and is the safer pick for a public repo's CI. |
| **Context7 MCP** | Live docs for Godot, Material 3, font libraries | Per user's global rule: use it for any framework/library question even when training data feels confident. (Note: this agent had MCP tools stripped due to upstream bug — verified findings via WebFetch instead. Implementation phase agents should use Context7 directly.) |
| **Godot's built-in Theme Generator** | One-click "fill in defaults for all Controls" button in the Theme editor | Use ONCE early to seed all Control types with default styleboxes, then overwrite with NeoCade values. Saves authoring time vs adding each item by hand. |
| **WCAG contrast checker** (e.g., webaim.org/resources/contrastchecker) | Verify all token pairs hit 4.5:1 (text) / 3:1 (UI) | Required before mockup approval. Document the matrix in DESIGN.md. |
| **Godot CLI** (`godot --headless --import`, `godot main.tscn`) | Reproducible re-import of font/icon resources, scripted screenshot runs | Pair with GoPeak MCP for QA. |
| **Git LFS** | Optional — for the `.ttf` files (~500KB-2MB each) | Probably skip; total bundled font size is ~3-5 MB, not LFS-worthy. Repo will be ~5 MB which is fine. |

---

## Installation & Bundling

### Addon Directory Layout (locked recommendation)

```
res://
├── addons/
│   └── neocade_theme/
│       ├── neocade_theme.tres         # primary deliverable — Theme resource
│       ├── neocade_theme.tres.import  # auto-generated, DO commit
│       ├── README.md                  # "what this is, how to apply, license summary"
│       ├── LICENSE.md                 # NeoCade theme license (e.g. MIT) + bundled-asset license attributions
│       ├── CHANGELOG.md               # versioned changes (1.0.0, 1.0.1, 1.1.0...)
│       ├── icon.svg                   # 128x128 addon icon for Asset Library listing
│       ├── icon.svg.import            # auto-generated, DO commit
│       ├── fonts/
│       │   ├── Inter-Variable.ttf            # ~800 KB, wght 100-900, opsz 14-32
│       │   ├── Inter-Variable.ttf.import
│       │   ├── Inter-Italic-Variable.ttf     # ~800 KB, italic counterpart
│       │   ├── Inter-Italic-Variable.ttf.import
│       │   ├── NotoSans-Variable.ttf         # ~600 KB, fallback for non-Latin Latin-extended scripts
│       │   ├── NotoSans-Variable.ttf.import
│       │   └── OFL.txt                       # SIL OFL 1.1 — covers Inter and Noto Sans
│       └── icons/
│           ├── checkbox_checked.svg          # 32x32 reference, imported at scale 2.0
│           ├── checkbox_unchecked.svg
│           ├── checkbox_checked.svg.import
│           ├── checkbox_unchecked.svg.import
│           ├── radio_checked.svg
│           ├── radio_unchecked.svg
│           ├── arrow_down.svg                # OptionButton dropdown
│           ├── arrow_right.svg               # Tree expand
│           ├── arrow_down_filled.svg         # Tree expanded
│           ├── close.svg                     # TabBar close, Window close
│           ├── folder.svg                    # FileDialog
│           ├── file.svg                      # FileDialog
│           ├── reload.svg                    # FileDialog
│           ├── ... (remaining ~20 icons)
│           └── ATTRIBUTIONS.md               # if any icons derive from another set
├── main.tscn                                  # showcase scene (PROJECT mandate)
├── icon.svg                                   # project-level icon (existing)
├── project.godot                              # existing
└── README.md                                  # repo-level readme; can re-summarize addon README
```

### Why this layout

- **Single-folder root**: Asset Library expects the entire deliverable under `addons/<name>/`. The root has only `main.tscn` (showcase, not part of addon) and `icon.svg` (project icon). When users download via Asset Library, only `addons/neocade_theme/` gets copied.
- **`.import` files committed**: Godot 4.6 still uses the `.import` sidecar pattern. They must be in version control or imports re-run on every clone.
- **Fonts and icons in subfolders**: Mirrors LDtk's `res/fonts/` and `res/atlas/` convention — keeps the .tres adjacent to its primary deliverable status.
- **No `plugin.cfg`**: Addons that aren't `EditorPlugin`s don't need it. Including one would make NeoCade appear (uselessly togglable) in Project Settings → Plugins.
- **`OFL.txt` next to fonts**: SIL Open Font License 1.1 requires the license file be distributed alongside fonts. Single combined OFL.txt is fine since both Inter and Noto Sans are OFL.

### Bundle Sizes (verified vs. estimated)

| Asset | Size | Note |
|-------|------|------|
| `neocade_theme.tres` | ~30-80 KB (text format) or ~15-40 KB binary | Estimate; depends on how many type variations and theme items. Text format recommended (diffable). |
| Inter-Variable.ttf | ~810 KB | v4.1 release file. |
| Inter-Italic-Variable.ttf | ~810 KB | v4.1 italic VF. |
| NotoSans-Variable.ttf (Latin extended only) | ~580 KB | If shipping reduced subset. Full Noto Sans is larger; we don't need full. |
| 30 SVG icons @ ~1 KB each | ~30 KB | Plus `.import` sidecars. |
| **Total addon footprint** | **~2.3-2.5 MB** | Well within Asset Library norms. |

### User Install Flow

```bash
# Option A: Asset Library inside Godot
#   Project → Asset Library → Search "NeoCade" → Install → Project includes addons/neocade_theme/

# Option B: Manual
#   git clone https://github.com/<user>/NeoCade-Theme
#   Copy addons/neocade_theme/ into your project's addons/ folder

# Apply project-wide:
#   Project → Project Settings → GUI → Theme → Custom → res://addons/neocade_theme/neocade_theme.tres

# Apply per-scene:
#   Inspector on root Control → Theme → load → res://addons/neocade_theme/neocade_theme.tres
```

---

## Alternatives Considered

| Recommended | Alternative | When to Use Alternative |
|-------------|-------------|-------------------------|
| **Inter Variable (one upright + one italic file)** | Static OTF set (Thin/Light/Regular/Medium/SemiBold/Bold/Black + 7 italics = 14 files, ~3 MB+) | If Godot's variable font axis support shows perf issues on low-end mobile. (Verified: Godot 4.6 has mature variable font support with `FontVariation.variation_opentype["wght"]` — no known issues. Stick with VF.) |
| **Inter** | Roboto Flex / Geist / Source Sans 3 | Roboto Flex: bigger file (~1.5 MB), more axes, but less arcade-friendly aesthetically. Geist (Vercel, OFL): newer, sharper, narrower — viable swap if user prefers tighter glyphs. Source Sans 3: warmer, less geometric — closer to "friendly arcade" but less iconic. **Inter is locked by user mandate.** |
| **Bespoke SVG icon set (~30 icons)** | Material Symbols variable font + glyph-codepoint mapping in Theme | If Godot ever adds direct font-glyph-as-icon support for theme items (currently it doesn't — icons must be Texture2D). **Not viable today.** |
| **Bespoke SVG icon set** | Bundle a slice of Lucide (15-30 icons, ISC license, attribution required) | Only if authoring time is the binding constraint and user agrees to ship "based on Lucide" attribution. Lucide's outline style fits a clean-arcade vibe. **Backup option** if bespoke authoring slips. |
| **No CJK fonts bundled** | Bundle Noto Sans CJK SC subset (~10 MB compressed) | If consuming game targets Chinese/Japanese/Korean markets at launch. **v1 scope: skip; document the override path.** |
| **No `plugin.cfg`** | Include `plugin.cfg` with no script | If user feedback shows confusion ("I don't see NeoCade in Plugins panel"). Then add a stub plugin.cfg that just identifies the addon for discovery — but no enable/disable script. v1: skip. |
| **`StyleBoxFlat` everywhere** | Mix in `StyleBoxTexture` for one or two "marquee" panels | Only if a hero panel (e.g., showcase scene title bar) demands raster art. v1: avoid; keep portability. |

---

## What NOT to Use

| Avoid | Why | Use Instead |
|-------|-----|-------------|
| **Pixel/bitmap fonts** (PressStart2P, VT323, Silkscreen, etc.) | PROJECT spec hard-rejects pixel fonts even for logos. Conflicts with HD-first constraint. User's prior research report incorrectly recommends a pixel font for titles — **ignore that recommendation.** | Inter Display optical sizing (`wght 800-900` at 28-48px) for headline weight. |
| **`Inter Display` as a separate font family** | Inter v4 *unified* the Display variants into the main variable font under the `opsz` axis. Shipping a separate Inter Display is now wasteful duplication. | Set `FontVariation.variation_opentype["opsz"] = 32` on heading variations to engage Display designs. |
| **`StyleBoxFlat.corner_radius = 0` paired with `anti_aliasing = true`** | Confirmed Godot bug (issue #87226): AA only renders if at least one corner has non-zero radius. Sharp-edged AA boxes look jagged. | Use `corner_radius = 2` minimum on every interactive surface OR set `anti_aliasing = false` on intentionally-sharp boxes. |
| **Drop shadows (`shadow_size > 4`) on small/dense controls** | GL Compatibility renderer over-darkens StyleBoxFlat shadows (issue #23640). At small sizes the banding reads as dirty edges, not depth. | Use shadows ONLY on large surfaces (popups, dialogs, dropdowns). Cap `shadow_size` at 4-6 px and use a low-alpha shadow_color (alpha ~0.25). For "lift" on small controls use border highlight instead. |
| **MSAA-based 2D AA expectations** | GL Compatibility has no 2D MSAA in 4.6 (proposal still open: godot#69462). Assuming MSAA will smooth edges = wrong. | Rely on StyleBoxFlat's built-in `anti_aliasing` (per-stylebox edge AA) instead of project-level MSAA. |
| **Synthetic italic via `variation_transform` skew when real italics exist** | Inter v4 has real italic VF. Using skew on the upright produces ugly slanted Latin and broken Cyrillic. | Wire `Inter-Italic-Variable.ttf` as a separate FontFile + FontVariation chain for any `[i]` text. |
| **Theme item names invented from scratch** | Each Control class has *fixed* theme item names (e.g., Button has `normal`, `hover`, `pressed`, `disabled`, `focus`, `font_color`, ...). Inventing names = items don't apply. | Mirror Godot's documented theme item names per class. The Theme editor's "Add type" + "Generate defaults" flow seeds the correct set. |
| **Storing color tokens only in the .tres** | Tokens locked inside the binary are hard to audit, version, or document. | Maintain a parallel `DESIGN_TOKENS.md` with `BG_BASE = #...`, `ACCENT_PRIMARY = #...` → committed alongside .tres. The .tres references same hexes. |
| **Bundling Material Symbols/Lucide entire library** | License-fine but wasteful (multi-MB), and Godot theme icons are Texture2D-per-slot, not glyph-mapped. | Author ~30 SVGs that match Godot's exact intrinsic icon slots. |
| **`SystemFont` resource as default_font** | System font varies wildly (Segoe UI / SF Pro / Cantarell / Roboto / nothing on web). Defeats the "consistent designed look" goal. | Bundled Inter as default_font; SystemFont only as a documented escape hatch. |
| **Naming the theme "VirtuCade Theme" anywhere in the .tres or addon** | User's prior research and prototype mislabel as "VirtuCade Godot Theme." This is **NeoCade**. VirtuCade is the future consuming game. | All metadata, README, .tres internal name = "NeoCade." |
| **Synthwave/vaporwave/scanline/glow tokens** | Explicitly rejected aesthetic per PROJECT. The prior research report leans into these; **must not influence implementation.** | "Vibrant arcade hall by day" — saturated but clean colors, modest border highlights, no scanline overlay, no chromatic aberration, no neon glow shaders. |

---

## Stack Patterns by Variant

**If shipping for desktop only (current v1 scope):**
- Use full Inter + Noto Sans bundle (~2.3 MB).
- Enable StyleBoxFlat `anti_aliasing` on all rounded controls.
- Use `shadow_size = 4-6` on dialogs/popups for elevation.

**If extending to mobile in v2:**
- Keep Inter (still readable at small sizes thanks to `opsz` axis).
- Increase tap target sizes via `content_margin_*` (44pt minimum per WCAG).
- Drop drop-shadows on mobile (perf cost on GL Compatibility on Android low-end).
- Consider exposing a `theme_type_variation` like `MobileButton` with larger paddings.

**If extending to light mode in v2:**
- Keep same StyleBox geometry; swap color tokens.
- Re-verify all WCAG contrast pairs in light context (pure inversion fails ~30% of token pairs typically).
- Maintain identical type variation names so consuming projects don't refactor.

**If consuming project needs CJK:**
- Document override pattern in README:
  ```gdscript
  var theme = preload("res://addons/neocade_theme/neocade_theme.tres").duplicate()
  var cjk_font := preload("res://your/NotoSansCJK-Variable.ttf")
  theme.default_font.fallbacks.append(cjk_font)
  ```
- Don't ship CJK in NeoCade core (10+ MB doubles addon size).

---

## Version Compatibility

| Package | Compatible With | Notes |
|---------|-----------------|-------|
| Godot 4.6 stable | Theme `.tres` format=3, FontFile, FontVariation, type variations all stable | This is the project's locked target. |
| Godot 4.5 → 4.6 | Theme format compatible (format=3 since 4.0); some new theme items added in 4.6 (focus styling decoupling, MarginContainer indicators) | NeoCade should declare 4.6 minimum. Don't try to back-port. |
| Godot 4.7+ (future) | Likely backwards compatible; Modern editor theme being iterated upstream | Re-test on each minor; expect minor adjustments. |
| Inter v4.1 | Godot 4.6 FontFile importer | Verified import support for `.ttf` variable fonts. Use `wght` (axis tag, not capitalized). |
| Noto Sans VF (current) | Godot 4.6 FontFile importer | Same as above; widely tested. |
| Lucide (if used) | ISC license — compatible with theme MIT distribution | Attribution recommended in ATTRIBUTIONS.md. |
| Material Symbols (if used) | Apache 2.0 — compatible with theme MIT distribution | Attribution + NOTICE file required by Apache 2.0. We're not using this. |
| GL Compatibility renderer | Limits in Godot 4.6: no 2D MSAA, alpha-to-coverage broken, 3D shadows partial | Constrains design — see Pitfalls research. |

---

## Critique of Prior Inputs

This section calls out specific recommendations from `.planning/inputs/NeoCade-Research-Report.md` and the `NeoCade-Theme-Prototype.png` that this research **disagrees with**, with evidence:

1. **Theme is named "VirtuCade Godot Theme" throughout the prior report and prototype.**
   - **Evidence of conflict**: PROJECT.md explicitly states "the canonical theme name is **NeoCade**. VirtuCade is the consuming game."
   - **Action**: Every artifact (README, .tres metadata, LICENSE copyright, Asset Library listing) must use "NeoCade Theme."

2. **Prior report recommends a pixel font for title logos: "reserve a stylized pixel font for title logos only."**
   - **Evidence of conflict**: PROJECT.md Out of Scope section: "Pixel font for any UI element including logos — research report suggested pixel font for titles; conflicts with the HD-only constraint. Theme stays crisp HD throughout."
   - **Action**: Inter Display weights only. No pixel/bitmap fonts anywhere.

3. **Prior report leans into synthwave aesthetic: "Synthwave/Vaporwave Vibe — references to 1980s-90s sci-fi (Tron, synth music) – think magenta and cyan glows, grid patterns or scanlines as subtle background texture."**
   - **Evidence of conflict**: PROJECT.md hard-rejects this: "Synthwave/vaporwave/scanline/glow-effect aesthetic — research report leans into these; explicitly rejected as too cyberpunk-adjacent."
   - **Action**: No grid overlays, no scanlines, no chromatic aberration. Saturated colors yes; "neon noir alley by night" no.

4. **Prior report's name suggestions include "CyberCade" and "SynthWave UI."**
   - **Evidence of conflict**: PROJECT key decisions: "Cyberpunk aesthetic explicitly rejected." Name is locked as NeoCade.
   - **Action**: Discard the name brainstorm — irrelevant; brand is locked.

5. **Prior report's example StyleBox uses `border_width_all = 2` and `border_color = ACCENT_PRIMARY.darker(0.8)` — a darker variant of the bg color.**
   - **Evidence concerns**: This produces a heavy "boxed" look that fights the modern arcade brief. godot-minimal-theme (the feature-completeness benchmark) uses thinner borders (1px) and lighter accent ratios.
   - **Action**: Default border_width = 1. Use border for emphasis (focus state), not as default chrome on every box. Reserve `border_width >= 2` for the "Active/Selected/Focused" states only.

6. **Prior report's accent palette: cyan #00ffff, hot pink #ff33cc, green #00ff66, purple #cc00ff — full-saturation neon stack.**
   - **Evidence concerns**: WCAG 2.1 AA requires 4.5:1 contrast for text. Pure neon (#00ffff) on near-black (#0a0a0a) only passes for non-text usage. As text colors these will fail or strain accessibility.
   - **Action**: Treat full-saturation neons as *accent fill colors* for stylebox backgrounds and *icon tints*, NEVER as text colors directly. Pair with desaturated near-white (#e8e8e8 ish) for body text, and use the neon ONLY for highlight/selected/focus indicators where the eye is drawn temporarily.

7. **Prototype (`NeoCade-Theme-Prototype.png`) reads as "futuristic neon" rather than "vibrant arcade."**
   - **User-stated concern**: "user feels it leans too futuristic / not arcade-y enough."
   - **Evidence**: The prototype's heavy use of cool blues/purples on near-black with thin neon strokes evokes Tron/cyberpunk. An "arcade hall" reads warmer (some red/gold/teal mix) and brighter (mid-dark surfaces, not pitch black).
   - **Action**: Mockup phase must explore **warmer accents** (consider amber/coral/teal trio rather than cyan/magenta/green) and **lighter base surfaces** (`bg_base ~ #16161D` rather than `#000–#111`) to lean arcade rather than cyberpunk. Multiple variants for user approval gate.

---

## Sources

- **Godot 4.6 release notes** ([godotengine.org/releases/4.6](https://godotengine.org/releases/4.6/)) — Verified: Modern theme is the new default (port of Minimal Theme), focus stylebox decoupling, `pivot_offset_ratio`, MarginContainer in-viewport indicators, instant editor theme reload. Confidence: HIGH.
- **Godot Theme class docs** ([class_theme.html](https://docs.godotengine.org/en/stable/classes/class_theme.html)) — Verified: 6 theme item types (color/constant/font/font_size/icon/stylebox), `default_font`, `default_font_size`, `default_base_scale`, `set_type_variation()` API. Confidence: HIGH.
- **Godot StyleBoxFlat docs** ([class_styleboxflat.html](https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html)) — Verified: bg_color, border, corner_radius (per-corner), shadow_*, anti_aliasing, anti_aliasing_size (1.0 baseline), expand_margin, skew, draw_center. Confidence: HIGH.
- **Godot Theme Type Variations tutorial** ([gui_theme_type_variations.html](https://docs.godotengine.org/en/stable/tutorials/ui/gui_theme_type_variations.html)) — Verified workflow: theme editor → `+ Type` → set `Base Type` → use `theme_type_variation` on Control. Confidence: HIGH.
- **Godot Using Fonts tutorial** ([gui_using_fonts.html](https://docs.godotengine.org/en/stable/tutorials/ui/gui_using_fonts.html)) — Verified: TTF/OTF/WOFF/WOFF2 supported; FontFile vs FontVariation distinction; MSDF for large text; `opsz`, `wght`, `slnt` axes; fallbacks via Advanced Import Settings or FontFile.fallbacks. Confidence: HIGH.
- **Inter font homepage** ([rsms.me/inter](https://rsms.me/inter/)) and **Inter v4 release notes** ([rsms/inter releases](https://github.com/rsms/inter/releases)) — Verified: v4.1, OFL 1.1, Latin/Cyrillic/Greek, ~2000 glyphs, 147 langs, two VF files (upright + italic) with `wght` 100-900 and `opsz` 14-32. Inter Display now an opsz axis, not separate family. Confidence: HIGH.
- **Noto Sans / Noto Fonts docs** ([notofonts.github.io/noto-docs](https://notofonts.github.io/noto-docs/website/use/), [Wikipedia](https://en.wikipedia.org/wiki/Noto_fonts)) — Verified: 162/168 Unicode 16 scripts, OFL 1.1, variable wght axis 100-900 for most scripts. Confidence: HIGH.
- **Godot Asset Library submission docs** ([submitting_to_assetlib](https://docs.godotengine.org/en/stable/community/asset_library/submitting_to_assetlib.html)) — Verified: `addons/asset_name/` convention, `.gitignore` and LICENSE required, square 128×128 icon required, manual approval. Confidence: HIGH for layout, MEDIUM for whether plugin.cfg is needed for theme-only — community consensus says "not required" but no official statement. Confidence: MEDIUM-HIGH.
- **godot-minimal-theme repo README** ([github.com/passivestar/godot-minimal-theme](https://github.com/passivestar/godot-minimal-theme)) — Verified: MIT license, recommends Inter + base #272727 + accent #569eff + corner_radius 4-5px + high icon saturation. Now ported into Godot 4.6 as the default Modern theme. Confidence: HIGH.
- **GoPeak Godot MCP** ([github.com/HaD0Yun/Gopeak-godot-mcp](https://github.com/HaD0Yun/Gopeak-godot-mcp)) — Verified: 95-110+ tools, screenshot capture (editor + running), input injection, `npx gopeak` install, Godot 4.x. Confidence: HIGH.
- **Coding-Solo godot-mcp** ([github.com/Coding-Solo/godot-mcp](https://github.com/Coding-Solo/godot-mcp)) — Verified: launches editor, runs project, **NO screenshot capture**. Use only for headless launch / log scraping. Confidence: HIGH.
- **Godot StyleBoxFlat AA bug** ([Godot issue #87226](https://github.com/godotengine/godot/issues/87226)) — Verified: AA only renders with non-zero corner radius. Confidence: HIGH.
- **Godot StyleBoxFlat shadow opacity bug** ([Godot issue #23640](https://github.com/godotengine/godot/issues/23640)) — Verified: shadow opacity over-rendered in GL Compatibility. Confidence: HIGH.
- **Godot 2D MSAA missing in OpenGL** ([Godot issue #69462](https://github.com/godotengine/godot/issues/69462)) — Verified: 2D MSAA still not reimplemented for GL Compatibility as of 4.6. Confidence: HIGH.
- **Godot FontVariation docs** ([class_fontvariation.html](https://docs.godotengine.org/en/stable/classes/class_fontvariation.html)) — Verified: `variation_opentype` dictionary keyed by axis tag (`wght`, `opsz`, etc.); `variation_transform` for synthetic skew; `base_font` + per-variation overrides. Confidence: HIGH.
- **Material Symbols** ([github.com/google/material-design-icons](https://github.com/google/material-design-icons)) — Verified: Apache 2.0, four axes (opsz/wght/grade/fill), variable + static + SVG distribution. Not chosen due to Texture2D-per-slot mismatch. Confidence: HIGH.
- **Lucide icons** ([github.com/lucide-icons/lucide](https://github.com/lucide-icons/lucide)) — Verified: v1.14.0 (April 2026), 1600+ icons, ISC license. Backup option only. Confidence: HIGH.
- **Lucide for Godot Asset Library plugin** ([asset/5047](https://godotengine.org/asset-library/asset/5047)) — Verified: MIT plugin, fetches Lucide on first use, Godot 4.1+. Orthogonal to NeoCade — consuming projects can use both. Confidence: HIGH.
- **LDtk source code on disk** (`C:\Programming_Files\ldtk-master\res\fonts\`, `res\atlas\`) — Verified directly: LDtk bundles `noto_sans_display_semicondensed_*.png/.xml` (bitmap atlas font, multiple weights/sizes baked) plus `pixel_berry.png` (pixel font for tiny labels). LDtk's approach is bitmap-baked due to Heaps engine constraints — Godot's TTF/VF support means we don't need to bake. Insight: even a polished pixel-art tool ships Noto Sans for chrome, not pixel fonts. Confidence: HIGH.

---

*Stack research for: Godot 4.6 native UI Theme addon, dark mode v1, HD-only, accessibility-first, distributed via Godot Asset Library.*
*Researched: 2026-05-04*
