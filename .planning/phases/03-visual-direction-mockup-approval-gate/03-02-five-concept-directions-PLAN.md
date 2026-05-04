---
phase: 03-visual-direction-mockup-approval-gate
plan: 02
type: execute
wave: 1
depends_on:
  - 01
files_modified:
  - .planning/mockups/concepts/
  - .planning/mockups/03-direction-boards.html
  - .planning/mockups/03-direction-boards.md
  - .planning/phases/03-visual-direction-mockup-approval-gate/03-02-SUMMARY.md
autonomous: true
requirements:
  - DESIGN-01
  - DESIGN-02
  - TOKEN-01
  - TOKEN-02
  - TOKEN-03
  - TOKEN-05
  - TOKEN-06
  - TOKEN-07
  - TOKEN-08
  - TOKEN-09
  - TOKEN-10
must_haves:
  truths:
    - "D-10: The three traceable anchor directions remain Midnight Marquee, Boardwalk Sunset, and Cabinet Chrome"
    - "D-11: Two additional named directions are derived from Plan 01 mood-board evidence and must satisfy the same reusable, HD-only, accessible, modern/neo arcade, professional, colorful, non-cyberpunk NeoCade constraints"
    - "D-13: Image-generator concept designs are created before implementation-style UI samples and explore concept, energy, imagery, shape language, lighting, material cues, layout direction, and emotional target"
    - "D-14: Directions vary layout, shapes, density, accent rhythm, surface treatment, control geometry, and color behavior; they are not recolors of one layout"
    - "D-17: Heading distinction comes from Inter `opsz`, weight, size, spacing/layout, and composition, not from a second display font"
    - "D-18: Inter Variable upright/Roman provides multiple upright `wght` values in one file without true italic; do not re-open the font stack during execution unless the user asks"
    - "D-19: Every direction board shows a small synthetic italic/emphasis sample labelled as synthetic v1 behavior"
    - "D-20: Every direction board shows a functional Latin plus non-Latin system-fallback text panel, labelled as functional fallback with script-specific Noto fonts left to consumers"
    - "Concept image generation uses the Codex app `image_gen` path recorded in `PHASE-3-TOOLING.md`; if unavailable, execution pauses and reports a blocker instead of substituting non-image artifacts"
    - "Every concept image is UI-adjacent: it includes at least one abstract/sketched control surface such as a button bar, panel stack, dialog, tabs, or menu chrome, while remaining labelled as mood/atmosphere rather than final UI"
    - "Every direction board includes basic contrast sanity checks before finalist selection and flags any direction that needs accessibility tuning"
    - "The gallery opens with a compact comparison matrix so the user can compare the five directions before reading detailed boards"
    - "Exactly five named art directions are presented: Midnight Marquee, Boardwalk Sunset, Cabinet Chrome, plus two research-derived directions named from Plan 01 evidence"
    - "Each direction includes image-generator concept design output first, then a direction board; boards are not merely recolored copies"
    - "Every direction varies at least four of these axes: layout rhythm, shapes, density, accent rhythm, surface treatment, control geometry, imagery, signage, and color behavior"
    - "Boardwalk Sunset is clearly marked as the recommended baseline, with rationale, while other directions are serious alternatives with strengths and risks"
    - "All five directions use Inter Variable upright/Roman only; headings differ by `opsz`, `wght`, size, and composition"
    - "Each board includes synthetic italic, non-Latin system fallback sample, and consumer-supplied mono/code override sample"
    - "Each board includes mini token sketch: 5-stop surface ramp, 8 accent swatches, text colors, focus ring, spacing/radius/stroke suggestions, no-shadow policy"
    - "Each board includes a source trace back to mood-board IDs and phase research, including how risky/game-world references were constrained"
    - "Generated concept image prompts and outputs are recorded so the design path is reproducible"
    - "No files under `addons/neocade_theme/` and no `.tres` files are modified"
  artifacts:
    - .planning/mockups/concepts/
    - .planning/mockups/03-direction-boards.html
    - .planning/mockups/03-direction-boards.md
  key_links:
    - "03-CONTEXT.md D-09..D-21"
    - ".planning/research/mood-board/INDEX.md"
    - ".planning/research/ARCHITECTURE.md"
    - ".planning/research/FONT-REVIEW.md"
---

<objective>
Explore NeoCade's visual identity as five full art directions, beginning with image-generated concept designs and ending with a comparative direction-board gallery ready for user finalist selection.
</objective>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-RESEARCH.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-01-SUMMARY.md
@.planning/research/mood-board/INDEX.md
@.planning/research/mood-board/references.json
@.planning/research/ARCHITECTURE.md
@.planning/research/FEATURES.md
@.planning/research/LDTK-UI-MINING.md
@.planning/research/CROSS-PLATFORM.md
</context>

<tasks>

<task type="auto">
  <name>Task 1: Derive and name Directions 4 and 5 from mood-board evidence</name>
  <read_first>
    - .planning/research/mood-board/INDEX.md
    - .planning/research/mood-board/references.json
    - .planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md D-09..D-15
  </read_first>
  <files>.planning/mockups/03-direction-boards.md</files>
  <action>
    Analyze the mood-board and pick two additional unique named directions.

    Constraints:
    - Direction 4 and 5 must be materially distinct from Midnight Marquee, Boardwalk Sunset, and Cabinet Chrome.
    - They must stay reusable as a Godot theme and pass NeoCade constraints: HD-only, professional, colorful, accessible, modern/neo arcade, not cyberpunk by default.
    - One may draw from sci-fi/spaceship/game-world inspiration only if it is explicitly constrained to extracted design moves.
    - Any future/spaceship-derived direction must still read as a friendly modern arcade lobby or public entertainment venue, not a Tron set, synthwave poster, or cyberpunk menu.
    - Do not lock final token hex values yet; use token sketches and relative direction.

    Add a `## Direction Derivation` section to `03-direction-boards.md` with:
    - Mood-board evidence clusters.
    - Candidate names considered.
    - Final two names and why they won.
    - Risks and anti-cyberpunk guardrails.
  </action>
  <verify>
    `03-direction-boards.md` names five directions and cites mood-board IDs for the two new directions.
  </verify>
  <done>
    Five-direction set is established before concept images are generated.
  </done>
</task>

<task type="auto">
  <name>Task 2: Generate concept-design images for each direction</name>
  <read_first>
    - .planning/mockups/03-direction-boards.md
    - .planning/research/mood-board/INDEX.md
  </read_first>
  <files>.planning/mockups/concepts/</files>
  <action>
    Use the Codex app `image_gen` workflow recorded in `.planning/research/PHASE-3-TOOLING.md` to create raster concept-design images for all five directions.

    If `image_gen` or an equivalent raster image generator is not available in the execution environment, stop Plan 02 and report a blocker. Do not replace this with HTML-only, SVG-only, text-only, or mood-board-only concept boards unless the user explicitly approves a fallback.

    Each prompt must describe:
    - NeoCade as a polished Godot UI theme concept, not a game screenshot.
    - Arcade interior inspiration and emotional target.
    - Shape language and material cues.
    - Lighting and accent rhythm.
    - At least one UI-adjacent motif: button bar, panel stack, dialog frame, tabs, slider surface, menu chrome, or control cluster.
    - Inter-only UI signage/text feel, without requiring legible generated typography.
    - Strict exclusions: cyberpunk, synthwave, vaporwave, scanlines, glitch, neon-noir, dystopian grime, pixel art UI, glow halos.

    Save each output under `.planning/mockups/concepts/` with a stable filename:
    - `midnight-marquee-concept.png`
    - `boardwalk-sunset-concept.png`
    - `cabinet-chrome-concept.png`
    - `{direction-4-slug}-concept.png`
    - `{direction-5-slug}-concept.png`

    Also save prompt text beside each image as `{slug}-prompt.md`.

    Add a short note beside each generated image: "Concept image: mood/atmosphere and shape-language reference, not a final UI preview."
  </action>
  <verify>
    ```powershell
    Get-ChildItem .planning\mockups\concepts -Filter '*-concept.png' | Measure-Object
    Get-ChildItem .planning\mockups\concepts -Filter '*-prompt.md' | Measure-Object
    ```
    Pass if both counts are 5.
  </verify>
  <done>
    Concept designs exist before HTML/UI boards.
  </done>
</task>

<task type="auto">
  <name>Task 3: Build comparative direction boards</name>
  <read_first>
    - .planning/mockups/concepts/
    - .planning/research/ARCHITECTURE.md
    - .planning/research/FEATURES.md
    - .planning/research/CROSS-PLATFORM.md
  </read_first>
  <files>
    - .planning/mockups/03-direction-boards.html
    - .planning/mockups/03-direction-boards.md
  </files>
  <action>
    Create an HTML gallery and markdown companion for the five direction boards.

    The HTML gallery must open with a compact comparison matrix before the detailed boards. Rows should include palette warmth, density, shape language, surface material, accent rhythm, UI geometry, risk level, accessibility status, and recommended use case; columns are the five directions.

    Each board must include:
    - Concept image.
    - Direction promise: what it feels like and when it wins.
    - Mood-board source IDs.
    - Layout rhythm and density.
    - Shape language and control geometry.
    - Surface/material treatment.
    - 5-stop surface ramp sketch and 8 accent sketch.
    - Basic contrast sanity results for body text against surface stops, primary/secondary accent labels against panel/raised surfaces, focus ring against base/panel, and danger/warning/success/info non-text accents against panel/raised surfaces. Failing or low-confidence pairs are marked `needs accessibility tuning` before finalist selection.
    - Button/input/panel/tabs/popup/list mini UI sample.
    - Focus/hover/pressed/disabled state sketches.
    - Inter-only type sample with opsz/weight notes.
    - Synthetic italic sample.
    - Latin plus non-Latin system-fallback sample.
    - Code/mono override sample.
    - Desktop/mobile notes, including 48px mobile tap target implication.
    - Risks and anti-cyberpunk guardrails.

    Keep cards visually distinct. Do not reuse one layout with different colors.
  </action>
  <verify>
    ```powershell
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'comparison matrix'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'Midnight Marquee'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'Boardwalk Sunset'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'Cabinet Chrome'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'synthetic italic'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'system fallback'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern '48px'
    Select-String -Path .planning\mockups\03-direction-boards.html -Pattern 'contrast'
    ```
  </verify>
  <done>
    HTML and markdown direction boards are ready for review.
  </done>
</task>

<task type="auto">
  <name>Task 4: Render/check direction boards in browser</name>
  <read_first>
    - .planning/mockups/03-direction-boards.html
  </read_first>
  <files>.planning/mockups/03-direction-boards-check.md</files>
  <action>
    Probe the available browser/Playwright path, record the chosen tool or blocker, then open or render `03-direction-boards.html` and document:
    - Desktop viewport check at 1440px width.
    - Narrow/mobile viewport check at 390px width.
    - Text does not overlap.
    - Concept images load.
    - Five boards are visually distinct.
    - No `.tres` styling files were touched.

    If screenshot tooling is not available, use an HTML static validation checklist and record the blocker.
  </action>
  <verify>
    `03-direction-boards-check.md` exists and records desktop + mobile checks or a tooling blocker.
  </verify>
  <done>
    Direction board render quality is documented.
  </done>
</task>

<task type="auto">
  <name>Task 5: Create summary for finalist-selection gate</name>
  <read_first>
    - .planning/mockups/03-direction-boards.md
    - .planning/mockups/03-direction-boards-check.md
  </read_first>
  <files>.planning/phases/03-visual-direction-mockup-approval-gate/03-02-SUMMARY.md</files>
  <action>
    Write a concise summary listing:
    - Five directions and their differentiating axes.
    - Recommended direction and why.
    - Which two or three directions are strongest finalist candidates.
    - Risks that should be discussed at the gate.
    - Verification results and no-theme-touch confirmation.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\phases\03-visual-direction-mockup-approval-gate\03-02-SUMMARY.md
    Select-String -Path .planning\phases\03-visual-direction-mockup-approval-gate\03-02-SUMMARY.md -Pattern 'recommended'
    $status = git status --short
    if ($status -match 'addons/neocade_theme|\.tres') { throw "Theme/addon file changed during Phase 3 plan 02" }
    ```
  </verify>
  <done>
    User can select finalists based on concept and direction evidence.
  </done>
</task>

</tasks>

<verification>
- [ ] Five named art directions exist
- [ ] Five concept images and prompts exist
- [ ] Direction boards include token sketches, typography samples, state samples, mobile notes, and source traces
- [ ] Render check passes or documents blocker
- [ ] No `.tres` or addon styling files changed
</verification>

<success_criteria>
- The phase has complete art-direction boards for user finalist selection
- Concepts came before control mockups
- The two new directions are evidence-derived, not invented from thin air
</success_criteria>

<output>
After completion, create `.planning/phases/03-visual-direction-mockup-approval-gate/03-02-SUMMARY.md`.
</output>
