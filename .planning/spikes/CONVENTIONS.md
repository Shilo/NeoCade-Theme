# Spike Conventions

Patterns and stack choices established across spike sessions in this project. New spikes follow these unless the question requires otherwise.

## Stack

| Need | Tool | Reason |
|---|---|---|
| Architecture / feasibility (against Godot itself) | GDScript headless verifiers | Only path that exercises the real engine. See `dynamic-theme/` for the reference pattern (verifier `.gd` script run via `godot --headless --script`). |
| Color analysis / image processing | Python 3.14 + PIL + numpy | Available, well-tested, no Godot dependency. |
| Throwaway mockups | Self-contained HTML + CSS | One file, opens in any browser, no build step, no JS framework. |
| Color math reproduction (mirror GDScript formulas in spike) | Python `colorsys` stdlib | Sufficient for HSV/HSL conversions. No extra deps. |
| K-means / classification (if needed) | scikit-learn user-scoped install | First-pass attempt at LAB+K-means failed due to PIL ImageCms profile mismatch on Python 3.14; HSV-binning is the safer default for hue-counting. |

## Structure

| Pattern | Example |
|---|---|
| Umbrella directory for related spikes | `.planning/spikes/visual-identity-distinctiveness/` (contains `BRIEF.md`, sub-numbered spikes, comparison artifacts, eventual `REPORT.md`) |
| Sub-spikes inside an umbrella | `001-name/`, `002a-name/`, `002b-name/` (NNN-letter-name) |
| Per-spike `README.md` with YAML frontmatter | Required: `spike`, `name`, `type`, `validates`, `verdict`, `related`, `tags` |
| Comparison spikes share a number with letter suffix | `002a` + `002b`; head-to-head artifact in the candidate spike's directory or in the umbrella |
| Top-level `MANIFEST.md` indexes all spikes | Tracks Idea, Requirements, and per-spike row with verdict |
| Self-contained HTML mockup files | Embed CSS in `<style>`, embed images via base64 if needed (~3 MB acceptable for spike artifacts; production assets stay separate) |

## Patterns

### Investigation trail in every README

Each spike `README.md` has an "Investigation Trail" section that documents iterations: what was tried, what surfaced, what was tried next. Ships as part of the verdict, not as scratch work. Lets future spikes (and the user) re-trace why a verdict was reached.

### Surprises section in every Results

Findings that contradicted the briefing or surfaced unexpectedly are called out explicitly under "Surprises". This is where partial recantations go (e.g., spike 002a's finding that the BRIEF's hue-drift complaint was largely a misread).

### .planning-only spike artifacts

Spike artifacts live under `.planning/spikes/`. **No spike commits modify `addons/` or other production paths.** The implementation lives in the eventually-spawned phase, not in the spike. This is enforced by the umbrella manifest's Requirements section.

### Math reproduction over Godot rendering for visual mockups

When validating proposed StyleBox math, reproducing the formula in CSS / Python is faster, more shareable, and lower-risk than building the same in Godot. The mockups are throwaway; faithful enough for decisions, not for production.

### One self-contained file per visual deliverable

Mockups, comparison pages, and reports are one HTML file each, with embedded CSS and (where needed) base64-embedded images. No external CSS, no build step, no JS framework. Drag-and-drop into any browser.

## Tools & Libraries

### Confirmed working

- Python 3.14.2 + PIL/Pillow 11 — image loading, downsample, base64 encode.
- numpy 2.x — vector ops, K-means feature prep.
- scikit-learn 1.8 (user-scoped install) — K-means clustering when needed.
- Python `colorsys` stdlib — HSV/RGB conversions.
- Godot 4.6.2 mono — headless feasibility verification (see `dynamic-theme/`).

### Avoid unless required

- PIL `ImageCms` for sRGB→LAB on Python 3.14 — produced out-of-range a*/b* values for ordinary navy on test runs (2026-05-10). Use HSV or `skimage.color.rgb2lab` if LAB precision is genuinely needed.
- Sklearn's K-means in (a*, b*) space without weighting — small but vivid hue regions get absorbed into dominant clusters. Saturation-weighted hue-binning (60 bins, ~6° wide) gave more honest results for hue-counting purposes.
- `pip install` system-scoped on Windows — defaults to user-scoped on this machine. Use `pip install --user` explicitly when scripts assume importability.

### Specifically not used

- No Docker / containers / build tools / bundlers — slows down throwaway work.
- No env files or config systems — hardcode constants at the top of each spike script with descriptive names.
- No shaders / GDExtension / native code — out of scope for a Godot Theme addon's research.

## Naming

| Pattern | Example |
|---|---|
| Spike umbrellas | kebab-case slug describing the question family (`visual-identity-distinctiveness`, `dynamic-theme`) |
| Sub-spike directories | `NNN-name` or `NNN-letter-name` (`001-color-monoculture-diagnostic`, `002a-raised-depth-formula-current`) |
| Spike script filenames | snake_case verb-noun (`analyze_hues.py`, `compare_formulas.py`, `build_mockups.py`, `synth_references.py`) |
| Output artifacts | `report.html`, `<thing>.json`, `mockup-<topic>.html`, etc. — predictable, no timestamps |

## Commit pattern

```
docs(spike-NNN): [VERDICT] short headline finding

2-4 paragraphs: what the spike validates, the method, the surprise
(if any), the verdict, and the signal for downstream spikes / phases.

List the spike artifacts touched: scripts, READMEs, generated outputs.
```

Comparison spikes (002a/002b) ship in one combined commit with `docs(spike-NNN):` prefix.
