---
phase: 03-visual-direction-mockup-approval-gate
plan: 01
type: execute
wave: 0
depends_on: []
files_modified:
  - .planning/research/mood-board/INDEX.md
  - .planning/research/mood-board/references.json
  - .planning/research/PHASE-3-TOOLING.md
  - .planning/research/SOURCES.md
autonomous: true
requirements:
  - RES-03
  - RES-04
  - DOCS-05
  - DESIGN-06
must_haves:
  truths:
    - "Mood-board contains 20-30 distinct reference entries with source URL, local/remote image pointer, license/usage status, tags, extraction caption, and anti-cyberpunk note"
    - "D-02: Interior warmth is the strongest extraction target: warm lighting, prize-counter color, painted/wood cabinet surfaces, approachable social spaces, and real entertainment-venue energy"
    - "D-03: Neo/futuristic references emphasize optimistic, playful future-facing details, polished materials, and fun color while remaining visitable and human"
    - "D-04: Sci-fi, spaceship, retro, unusual, and risky imagery is not rejected at collection time because the VirtuCade game world remains open"
    - "D-05: References use the approved tag set: `theme-safe`, `game-world`, `palette`, `surface`, `shape`, and `risky`"
    - "D-06: `game-world` and `risky` references influence NeoCade only through extracted design moves, never by importing their whole mood"
    - "D-07: Sci-fi/spaceship/future-venue imagery is a curated minority, not an equal pillar"
    - "Mood-board is broad by collection policy: modern arcade and warm real-venue references dominate, with sci-fi/spaceship/future references included only as a curated minority tagged `game-world` or `risky`"
    - "Mood-board has enough evidence to derive two additional unique named art directions beyond Midnight Marquee, Boardwalk Sunset, and Cabinet Chrome"
    - "Round1, Dave & Buster's, Two Bit Circus or equivalent neo-arcade source, classic/barcade/pinball source, cabinet imagery, prize/ticket/counter imagery, marquee/signage, and mobile/touch-friendly public-venue cues are all represented"
    - "Each reference caption says what to extract: palette, surface material, lighting, control shape, signage rhythm, density, affordance, or mood"
    - "D-27: Phase 3 performs only a screenshot smoke test proving a Godot screenshot path; input injection is deferred to Phase 10 QA"
    - "D-28: Coding-Solo `godot-mcp` remains useful for launch/run/debug-output workflows, but the currently visible tool surface is recorded as lacking screenshot capture"
    - "GoPeak/Coding-Solo tooling comparison is hands-on and honest: current `mcp__godot__` tool surface is recorded, GoPeak screenshot smoke test is attempted or the environment blocker is documented, and a fallback screenshot path is specified"
    - "Image generation availability is recorded before Plan 02: preferred path is Codex app `image_gen` through the `imagegen` skill; if unavailable, Plan 02 pauses for a user-visible blocker rather than substituting non-image mockups"
    - "Committed mood-board reference images are license-safe: all-rights-reserved venue photos stay URL-only; local reference image files require explicit CC/PD license and attribution"
    - "Phase 3 screenshot baseline captures or explicitly attempts a Godot editor/project screenshot without requiring `.tres` styling changes"
    - "SOURCES.md Section 5 real/virtual arcade aesthetics gains a Phase 3 update cross-linking the mood-board"
    - "No files under `addons/neocade_theme/` and no `.tres` files are modified"
  artifacts:
    - .planning/research/mood-board/INDEX.md
    - .planning/research/mood-board/references.json
    - .planning/research/PHASE-3-TOOLING.md
    - .planning/research/SOURCES.md
  key_links:
    - "03-CONTEXT.md D-01..D-08 and D-26..D-29"
    - "REQUIREMENTS.md RES-03, RES-04, DESIGN-06, DOCS-05"
    - "PROJECT.md Research Charter and no-`.tres` mockup gate"
---

<objective>
Create the evidence base for Phase 3 before any visual direction is generated: a tagged, captioned real-arcade mood-board and a tooling baseline proving what screenshot path is available for later mockup review.
</objective>

<context>
@.planning/PROJECT.md
@.planning/ROADMAP.md
@.planning/REQUIREMENTS.md
@.planning/STATE.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md
@.planning/phases/03-visual-direction-mockup-approval-gate/03-RESEARCH.md
@.planning/research/SUMMARY.md
@.planning/research/SOURCES.md
@.planning/research/ARCHITECTURE.md
@.planning/research/PITFALLS.md
@.planning/research/CROSS-PLATFORM.md

<interfaces>
Primary output directory: `.planning/research/mood-board/`

Suggested source families:
- Round1 official location pages and images
- Dave & Buster's official play/events pages and selected legally reusable interior images
- Two Bit Circus / modern micro-amusement park references
- Classic/barcade/pinball hall references
- Cabinet, marquee, ticket, prize counter, card station, food counter, party-room, and public-space signage references
- Minority futuristic/space/future-venue references tagged `game-world` or `risky`

Godot project root: `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme`
Current MCP surface can be checked with Codex `tool_search` or available `mcp__godot__*` tools.
GoPeak candidate: `npx -y gopeak`.
</interfaces>
</context>

<tasks>

<task type="auto">
  <name>Task 1: Create mood-board directory and reference schema</name>
  <read_first>
    - .planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md
    - .planning/phases/03-visual-direction-mockup-approval-gate/03-RESEARCH.md
    - .planning/research/SOURCES.md Section 5
  </read_first>
  <files>
    - .planning/research/mood-board/INDEX.md
    - .planning/research/mood-board/references.json
  </files>
  <action>
    Create the mood-board artifact skeleton with a JSON schema and a human-readable index.

    Each reference entry must include:
    - `id`
    - `title`
    - `source_url`
    - `image_url_or_local_path`
    - `source_family`
    - `license_or_usage`
    - `tags` from the approved set: `theme-safe`, `game-world`, `palette`, `surface`, `shape`, `risky`
    - `extract`
    - `anti_cyberpunk_note`
    - `candidate_direction_influence`

    Specify that `references.json` is a JSON object with one top-level key: `{ "references": [...] }`.

    Add a note that images with unclear licensing or all-rights-reserved promotional status are reference-only URL entries and must not be committed locally or embedded as distributable assets. Local reference images are allowed only when license is explicit CC/PD or equivalent and attribution is captured in the entry.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\research\mood-board\INDEX.md
    Test-Path .planning\research\mood-board\references.json
    Select-String -Path .planning\research\mood-board\INDEX.md -Pattern 'theme-safe'
    Select-String -Path .planning\research\mood-board\INDEX.md -Pattern 'anti-cyberpunk'
    Select-String -Path .planning\research\mood-board\INDEX.md -Pattern 'URL-only'
    ```
  </verify>
  <done>
    Mood-board structure exists and can accept entries without reformatting.
  </done>
</task>

<task type="auto">
  <name>Task 2: Collect and caption 20-30 references</name>
  <read_first>
    - .planning/research/ARCHITECTURE.md Section 7 and Section 8
    - .planning/research/LDTK-UI-MINING.md Appendix A
    - .planning/research/SUMMARY.md Key Findings and Conflicts Resolved
  </read_first>
  <files>
    - .planning/research/mood-board/INDEX.md
    - .planning/research/mood-board/references.json
  </files>
  <action>
    Add 20-30 references to the mood-board.

    Required distribution:
    - 10-14 modern arcade / entertainment-venue interior references.
    - 4-6 prize, ticket, counter, card-station, claw/crane, food or party-space references.
    - 3-5 classic/barcade/pinball/cabinet-row references.
    - 3-5 future/neo/sci-fi/spaceship references, explicitly minority and tagged `game-world` or `risky`.

    For every item, write a one-sentence extraction caption and an anti-cyberpunk note. Do not reject unusual images during collection; tag them honestly and constrain how they can influence NeoCade.
  </action>
  <verify>
    Count references from `references.json`; pass if 20-30 entries exist and every entry has non-empty `tags`, `extract`, and `anti_cyberpunk_note`.
    ```powershell
    $json = Get-Content -Raw .planning\research\mood-board\references.json | ConvertFrom-Json
    if ($json.references.Count -lt 20 -or $json.references.Count -gt 30) { throw "Mood-board count out of range" }
    foreach ($r in $json.references) {
      if (-not $r.tags -or -not $r.extract -or -not $r.anti_cyberpunk_note) { throw "Incomplete mood-board entry: $($r.id)" }
      if ($r.image_url_or_local_path -and $r.image_url_or_local_path -notmatch '^https?://' -and $r.license_or_usage -notmatch 'CC|Creative Commons|Public Domain|PD|Own generated') { throw "Local reference image without clear reusable license: $($r.id)" }
    }
    ```
  </verify>
  <done>
    Mood-board has the required reference count and extraction captions.
  </done>
</task>

<task type="auto">
  <name>Task 3: Smoke-test Godot / GoPeak screenshot and image-generation tooling</name>
  <read_first>
    - project.godot
    - showcase/showcase.tscn
    - .planning/phases/03-visual-direction-mockup-approval-gate/03-CONTEXT.md D-26..D-29
  </read_first>
  <files>.planning/research/PHASE-3-TOOLING.md</files>
  <action>
    Write a tooling baseline report.

    Required checks:
    - Record current Godot version using available MCP or shell tooling.
    - Record currently exposed `mcp__godot__` tools and state whether screenshot capture is present.
    - Attempt to launch the editor or run the project through current MCP tooling.
    - Attempt GoPeak screenshot smoke test with `npx -y gopeak` if available in this environment, or document the exact blocker.
    - If direct screenshot capture fails, specify a fallback screenshot harness using either a Godot script that saves `get_viewport().get_texture().get_image()` output or an external screenshot capture command. The fallback must be programmatic, repeatable, and able to produce named output files so it can scale into Phase 10 screenshot QA rather than only manual PrintScreen capture.
    - Record Codex image-generation availability for Plan 02. Preferred path is the Codex app `image_gen` tool invoked through the `imagegen` skill. If the current executor cannot access an image generator, mark Plan 02 as blocked until the user enables/provides an image-generation path; do not downgrade to HTML-only or text-only concept boards without explicit user approval.

    Phase 3 only needs screenshot capture evidence. Input injection is documented as deferred to Phase 10.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\research\PHASE-3-TOOLING.md
    Select-String -Path .planning\research\PHASE-3-TOOLING.md -Pattern 'GoPeak'
    Select-String -Path .planning\research\PHASE-3-TOOLING.md -Pattern 'screenshot'
    Select-String -Path .planning\research\PHASE-3-TOOLING.md -Pattern 'image_gen'
    Select-String -Path .planning\research\PHASE-3-TOOLING.md -Pattern 'programmatic'
    Select-String -Path .planning\research\PHASE-3-TOOLING.md -Pattern 'Phase 10'
    ```
  </verify>
  <done>
    Screenshot path is proven or honestly documented with a fallback.
  </done>
</task>

<task type="auto">
  <name>Task 4: Update SOURCES.md for real-arcade and tooling coverage</name>
  <read_first>
    - .planning/research/SOURCES.md
    - .planning/research/mood-board/INDEX.md
    - .planning/research/PHASE-3-TOOLING.md
  </read_first>
  <files>.planning/research/SOURCES.md</files>
  <action>
    Update `.planning/research/SOURCES.md` narrowly:
    - Section 5 real/virtual arcade aesthetics receives a Phase 3 update with mood-board link, what was read, adopted, rejected, still open, and confidence.
    - Sections covering the user-supplied research report and prototype get cross-links only if Phase 3 critique adds new claim-by-claim findings.
    - The tooling/GoPeak mention is updated only where SOURCES.md already discusses MCP or tooling.
    - Do not mark visual direction confidence HIGH until user approval; mood-board raises source coverage, not final design certainty.
  </action>
  <verify>
    ```powershell
    Select-String -Path .planning\research\SOURCES.md -Pattern 'mood-board'
    Select-String -Path .planning\research\SOURCES.md -Pattern 'PHASE-3-TOOLING'
    ```
  </verify>
  <done>
    Source dossier reflects Phase 3 reference collection and tooling baseline.
  </done>
</task>

<task type="auto">
  <name>Task 5: No-theme-touch verification and summary</name>
  <read_first>
    - git status
    - .planning/research/mood-board/INDEX.md
    - .planning/research/PHASE-3-TOOLING.md
  </read_first>
  <files>.planning/phases/03-visual-direction-mockup-approval-gate/03-01-SUMMARY.md</files>
  <action>
    Create `03-01-SUMMARY.md` with:
    - Mood-board reference count and source-family distribution.
    - Candidate influence notes for deriving Directions 4 and 5.
    - Tooling result: current MCP capabilities, GoPeak status, screenshot evidence or fallback.
    - Confirmation that no `.tres` or addon styling files were touched.
  </action>
  <verify>
    ```powershell
    Test-Path .planning\phases\03-visual-direction-mockup-approval-gate\03-01-SUMMARY.md
    $status = git status --short
    if ($status -match 'addons/neocade_theme|\.tres') { throw "Theme/addon file changed during Phase 3 plan 01" }
    ```
  </verify>
  <done>
    Phase 3 research/tooling base is complete and safe for concept generation.
  </done>
</task>

</tasks>

<verification>
- [ ] Mood-board has 20-30 complete references
- [ ] References are tagged, captioned, and screened for anti-cyberpunk drift
- [ ] Tooling report records current MCP, GoPeak, screenshot result or fallback
- [ ] SOURCES.md updated narrowly
- [ ] No `.tres` or addon styling files changed
</verification>

<success_criteria>
- RES-03 is ready to verify from mood-board artifacts
- RES-04 has a documented screenshot baseline or fallback
- Phase 3 has evidence to derive the two new art directions
</success_criteria>

<output>
After completion, create `.planning/phases/03-visual-direction-mockup-approval-gate/03-01-SUMMARY.md`.
</output>
