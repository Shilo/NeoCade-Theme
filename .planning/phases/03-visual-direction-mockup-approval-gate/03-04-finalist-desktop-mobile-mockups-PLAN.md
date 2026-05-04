---
phase: 03-visual-direction-mockup-approval-gate
plan: 04
type: execute
wave: 3
depends_on:
  - 03
files_modified:
  - .planning/mockups/finalists/
  - .planning/mockups/03-finalist-comparison.html
  - .planning/mockups/03-finalist-comparison.md
  - .planning/phases/03-visual-direction-mockup-approval-gate/03-04-SUMMARY.md
autonomous: true
requirements:
  - DESIGN-03
  - DESIGN-04
  - DESIGN-06
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
    - "D-23: Approval mockups prove both theme identity and usability: they feel like NeoCade, support real UI content, show focus/hover/disabled states, and remain readable"
    - "Full-fidelity mockups are produced only for the user-selected two or three finalists from `03-FINALIST-SELECTION.md`"
    - "Each finalist has a desktop representative control gallery and mobile representative gallery at 360x800 and 768x1024"
    - "Desktop mockups show representative Godot Control families with realistic content and visible normal/hover/pressed/focused/disabled states"
    - "Mobile mockups show 48px tap-target overlays, body text at 16px, spacing uplift for larger tokens, and unchanged corner-radius identity"
    - "Mockups include image/visual material plus concise annotations; they are representative full-fidelity, not mere palette swatches"
    - "Inter-only typography is visible in every finalist; synthetic italic, system fallback sample, and consumer mono/code override sample are included"
    - "Contrast math is computed for candidate surface/text/accent pairs and any failing pair is corrected before approval"
    - "Browser/render checks cover desktop and mobile widths and record any issue"
    - "No `DESIGN_TOKENS.md` is finalized yet unless Plan 05 approval passes"
    - "No files under `addons/neocade_theme/` and no `.tres` files are modified"
  artifacts:
    - .planning/mockups/finalists/
    - .planning/mockups/03-finalist-comparison.html
    - .planning/mockups/03-finalist-comparison.md
  key_links:
    - "03-CONTEXT.md D-22..D-25"
    - ".planning/mockups/03-FINALIST-SELECTION.md"
    - ".planning/research/FEATURES.md 35-class coverage matrix"
    - ".planning/research/CROSS-PLATFORM.md mobile deltas"
---

<objective>
Build representative, full-fidelity desktop and mobile mockups for the selected finalists so the user can approve the final NeoCade visual direction before token finalization.
</objective>

<context>
@.planning/PROJECT.md
@.planning/REQUIREMENTS.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md
@.planning/mockups/03-FINALIST-SELECTION.md
@.planning/mockups/03-direction-boards.md
@.planning/research/FEATURES.md
@.planning/research/ARCHITECTURE.md
@.planning/research/CROSS-PLATFORM.md
@.planning/research/PITFALLS.md
@.planning/research/LDTK-UI-MINING.md
</context>

<tasks>

<task type="auto">
  <name>Task 1: Define finalist mockup components and candidate token math</name>
  <read_first>
    - .planning/mockups/03-FINALIST-SELECTION.md
    - .planning/research/FEATURES.md Section 5
    - .planning/research/CROSS-PLATFORM.md mobile spec
  </read_first>
  <files>.planning/mockups/03-finalist-comparison.md</files>
  <action>
    Write a finalist mockup specification with:
    - List of selected finalists.
    - Representative Control set to show: buttons, check/radio/toggle, option/menu, line/text/code inputs, labels/rich text, sliders/progress/scrollbars, item list/tree/tabs/foldable, panel/dialog/popup/tooltip/window, ColorPicker sample, Graph sample, token gallery.
    - Required states: normal, hover, pressed, focus, disabled, selected, checked where applicable.
    - Desktop viewport target.
    - Mobile viewport targets: 360x800 and 768x1024.
    - Candidate token values per finalist, including surface/text/accent colors.
  </action>
  <verify>
    `03-finalist-comparison.md` lists every required Control family and both mobile viewport sizes.
  </verify>
  <done>
    Mockup implementation has a clear scope before HTML is written.
  </done>
</task>

<task type="auto">
  <name>Task 2: Compute WCAG contrast and correct candidate token pairs</name>
  <read_first>
    - .planning/mockups/03-finalist-comparison.md
    - .planning/research/ARCHITECTURE.md contrast examples
  </read_first>
  <files>.planning/mockups/03-finalist-contrast.md</files>
  <action>
    Compute contrast ratios for every finalist:
    - `text.strong`, `text.default`, `text.muted` against all five surfaces.
    - Accent fills against black/near-black text and white/cream text; choose the accessible label color.
    - Focus ring against adjacent surfaces.
    - Danger/warning/success/info non-text contrast against panel and raised surfaces.

    Correct any failing candidate pair before building the HTML. Keep this as candidate-token math; final `DESIGN_TOKENS.md` waits for approval.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\mockups\03-finalist-contrast.md
    Select-String -Path .planning\mockups\03-finalist-contrast.md -Pattern 'PASS'
    Select-String -Path .planning\mockups\03-finalist-contrast.md -Pattern 'focus'
    ```
  </verify>
  <done>
    Candidate finalist values meet contrast expectations before visual approval.
  </done>
</task>

<task type="auto">
  <name>Task 3: Build finalist HTML mockups</name>
  <read_first>
    - .planning/mockups/03-finalist-comparison.md
    - .planning/mockups/03-finalist-contrast.md
    - .planning/mockups/concepts/
  </read_first>
  <files>
    - .planning/mockups/finalists/
    - .planning/mockups/03-finalist-comparison.html
  </files>
  <action>
    Create HTML/CSS mockups for each finalist and an index/comparison page.

    Required files:
    - `.planning/mockups/finalists/{slug}-desktop.html`
    - `.planning/mockups/finalists/{slug}-mobile.html`
    - `.planning/mockups/03-finalist-comparison.html`

    The comparison page should link to every finalist desktop/mobile mockup and embed thumbnails or screenshots if available.

    Design requirements:
    - Use Inter-only CSS font stack.
    - Use clear UI controls, not marketing hero layouts.
    - Include visual/image material from concept outputs and/or mood-board references where licensing allows; otherwise use generated/abstracted visual motifs.
    - Keep controls stable in size; no hover/label state should resize layout.
    - No card-inside-card composition.
    - No decorative gradient orbs or bokeh.
    - No visible text explaining generic UI usage; annotations should explain why the direction works and what tokens it implies.
  </action>
  <verify>
    ```powershell
    Get-ChildItem .planning\mockups\finalists -Filter '*-desktop.html' | Measure-Object
    Get-ChildItem .planning\mockups\finalists -Filter '*-mobile.html' | Measure-Object
    Test-Path .planning\mockups\03-finalist-comparison.html
    Select-String -Path .planning\mockups\03-finalist-comparison.html -Pattern 'Inter'
    Select-String -Path .planning\mockups\03-finalist-comparison.html -Pattern '48px'
    ```
  </verify>
  <done>
    Finalist mockup HTML files exist and link together.
  </done>
</task>

<task type="auto">
  <name>Task 4: Browser and responsive verification</name>
  <read_first>
    - .planning/mockups/03-finalist-comparison.html
    - .planning/mockups/finalists/
  </read_first>
  <files>.planning/mockups/03-finalist-render-check.md</files>
  <action>
    Use available browser/Playwright tooling to inspect the comparison page and finalist mockups at:
    - 1440x900 desktop.
    - 390x844 mobile.
    - 768x1024 tablet.

    Record:
    - Screenshots or screenshot paths if tool supports screenshots.
    - Whether all linked files load.
    - Whether text overlaps or spills.
    - Whether mobile tap-target overlays are visible.
    - Whether concept images or generated visual assets load.
    - Any issues corrected.

    If screenshot capture is unavailable, record a manual/static render-check blocker and perform HTML/CSS structural checks.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\mockups\03-finalist-render-check.md
    Select-String -Path .planning\mockups\03-finalist-render-check.md -Pattern '1440'
    Select-String -Path .planning\mockups\03-finalist-render-check.md -Pattern '390'
    Select-String -Path .planning\mockups\03-finalist-render-check.md -Pattern '768'
    ```
  </verify>
  <done>
    Finalist mockups are render-checked before approval.
  </done>
</task>

<task type="auto">
  <name>Task 5: Summary for final approval gate</name>
  <read_first>
    - .planning/mockups/03-finalist-comparison.md
    - .planning/mockups/03-finalist-contrast.md
    - .planning/mockups/03-finalist-render-check.md
  </read_first>
  <files>.planning/phases/03-visual-direction-mockup-approval-gate/03-04-SUMMARY.md</files>
  <action>
    Write a summary with:
    - Finalist mockup file paths.
    - Contrast outcome.
    - Render-check outcome.
    - Recommended finalist and why.
    - Known tradeoffs for each finalist.
    - Confirmation that final approval is still required before token writing.
    - No-theme-touch verification.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\phases\03-visual-direction-mockup-approval-gate\03-04-SUMMARY.md
    Select-String -Path .planning\phases\03-visual-direction-mockup-approval-gate\03-04-SUMMARY.md -Pattern 'approval'
    $status = git status --short
    if ($status -match 'addons/neocade_theme|\.tres') { throw "Theme/addon file changed during Phase 3 plan 04" }
    ```
  </verify>
  <done>
    Mockups are ready for final user approval.
  </done>
</task>

</tasks>

<verification>
- [ ] Finalist desktop and mobile mockups exist
- [ ] Contrast math passes or failing pairs corrected
- [ ] Browser/responsive checks recorded
- [ ] Final approval is still pending
- [ ] No `.tres` or addon styling files changed
</verification>

<success_criteria>
- User can approve the final NeoCade visual direction from representative full-fidelity desktop and mobile mockups
- Candidate token values are numerically plausible and accessible before finalization
</success_criteria>

<output>
After completion, create `.planning/phases/03-visual-direction-mockup-approval-gate/03-04-SUMMARY.md`.
</output>
