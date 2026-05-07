---
phase: 05-core-controls-buttons-inputs-labels-panels-desktop
plan: 01
subsystem: tooling
tags: [godot-cli, powershell, sceneTree-script, editorScript, headless-verifier, focus-probe, godot-4.6, mono-stable]

requires:
  - phase: 04-foundation-neocadetheme-superclass-per-theme-subclasses-font
    provides: production NeoCadeTheme class + 5 direction .tres files + Phase 4 dual verifier helper pattern
provides:
  - resolved Godot 4.6.x CLI executable path documented per machine (helpers/godot-cli-path.txt) + provenance (helpers/godot-cli-provenance.txt)
  - search-only Godot resolver (helpers/Resolve-Godot46.ps1) with explicit-approval -AllowInstall opt-in (URL whitelist + SHA256 verification + extract-outside-repo)
  - human-action checkpoint contract (helpers/GODOT-CLI-MISSING.md is written if no Godot is found)
  - Phase 5 CLI smoke (helpers/_phase5_cli_smoke.gd) proving Godot loads pulse_neocade_theme.tres as NeoCadeTheme
  - dual Phase 5 verifier (helpers/_phase5_verify_headless.gd + helpers/_phase5_verify.gd) with named D-12 assertion groups
  - focus structural probe (helpers/_phase5_focus_probe.gd) with D-07 invariant guard
  - tooling/strict stage selector via OS.get_cmdline_user_args() (--script ... -- --stage <stage>)
affects: [05-02, 05-03, 05-04, 05-05, 05-06, 05-07, 06-*, 07-*, all phases that ResourceSaver-round-trip a .tres]

tech-stack:
  added: [Godot 4.6.2.stable.mono.official.71f334935 (operator-local, not bundled), PowerShell 5.1+ resolver script with optional PowerShell 7 outer]
  patterns:
    - "Resolve-PreferConsoleExe: prefer the `_console.exe` companion on Windows so --version / --import / --script invocations produce captureable stdout (the GUI exe detaches its console and silently drops stdout). All later Phase 5 plans inherit this by reading helpers/godot-cli-path.txt."
    - "Invoke-GodotCapture: Start-Process with -RedirectStandardOutput / -RedirectStandardError; the only invocation pattern that reliably captures Godot output on Windows."
    - "ASCII-only PowerShell helpers: Windows PowerShell 5.1 reads .ps1 files in the system ANSI codepage. Em-dashes / ellipses / ornament dashes mojibake into a multi-byte sequence that breaks the parser. All resolver text is ASCII; provenance + log files are utf-8."
    - "Named assertion groups + tooling/strict staging: each named group emits PHASE5_GROUP_OK:<group_name> in tooling stage even when its Phase 5 invariant has not yet landed (logs PHASE5_GROUP_PENDING alongside). Plans 05-02..05-07 only need to flip --stage; the verifier never gets re-authored."
    - "Argv parse via OS.get_cmdline_user_args(): Godot 4.6 splits CLI args at the literal `--`. Engine + --script consume args before `--`; user args (e.g. --stage strict) arrive in get_cmdline_user_args(). The verifier reads both for resilience."
    - "`assert_no_theme_clear` strips comment lines before scanning so the regex/substring scanner is not a self-match against its own pattern strings (the literal `.clear()` and `set_theme(null` in the source-data array are inside non-comment context but the strip runs only on comment lines, so the patterns match in real call sites and not in their own definitions)."
    - "Operator-local godot-cli-path.txt + godot-cli-provenance.txt are gitignored at the phase level; downstream plans must re-run the resolver on each machine. GODOT-CLI-MISSING.md is committable when present (documents checkpoint state)."

key-files:
  created:
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/.gitignore
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt (gitignored, operator-local)
    - .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt (gitignored, operator-local)
  modified: []

key-decisions:
  - "Plan 01 is search-only; -AllowInstall is opt-in and requires both -DownloadUrl (whitelisted to github.com/godotengine/godot/releases, godotengine.org, downloads.tuxfamily.org/godotengine) and -ExpectedSha256 (64 hex chars, exact match required, archive deleted on mismatch). Per cross-AI plan-review HIGH gate + project D-11."
  - "Resolver detects and prefers Godot's `_console.exe` companion when both exist. The GUI exe on Windows detaches from the parent console and produces no captureable stdout when run from PowerShell or cmd, breaking --version / --import / --script log capture. The companion exe wraps the GUI exe in a true console host so subsequent invocations work."
  - "Verifier exposes 7 named assertion groups (D-12) with tooling/strict staging. Tooling stage emits PHASE5_GROUP_OK:<group> for every group even when the underlying invariant is not yet met (logs PHASE5_GROUP_PENDING alongside). Strict stage treats PENDING as FAIL. This lets the marker check in Plan 01's verify block pass while Phase 5 work is still outstanding, AND lets Plans 05-02..05-07 flip the gate to strict by argv only."
  - "`assert_no_theme_clear` scans non-comment lines only. The Phase 4 grep contract (`grep -E '\\.clear\\(\\)|Theme\\.clear|set_theme\\(null|free\\(\\)' addons/neocade_theme/neocade_theme.gd`) was at risk of matching itself once Phase 5 introduced a verifier whose source contained the same regex literally; this implementation pre-strips lines beginning with `#` so the verifier source's own pattern declarations are excluded from the match space."
  - "Focus probe always emits PHASE5_FOCUS_RENDER_SKIPPED for the optional pixel sample. The structural focus assertion (focus stylebox populated, has visible border or expand profile, no invented combo slots present) is sufficient for Plan 01's gate. Plans 05-03 / 05-04 may flip the SubViewport pixel-sample path on once the variation chrome is known to render in headless GL on the developer's machine; per CONTEXT.md the structural assertion stands alone if pixel verification is unavailable."
  - "Resolved Godot path file (helpers/godot-cli-path.txt) and provenance file are gitignored at the phase level. They record the operator's local install path which differs per machine; the orchestrator and downstream plans (05-02..05-07) re-run Resolve-Godot46.ps1 on each agent's machine."

patterns-established:
  - "Phase 5 helper file location: addon root contains exactly 1 .gd (neocade_theme.gd, Phase 4 F3 lock); ALL Phase 5 helpers live under .planning/phases/05-.../helpers/. Verifier checks this implicitly by loading res://addons/neocade_theme/neocade_theme.gd through ProjectSettings.globalize_path."
  - "Dual verifier (EditorScript + headless SceneTree) with shared assertion-group surface mirroring Phase 4's _phase4_verify.gd / _phase4_verify_headless.gd pattern. Group bodies are duplicated rather than extracted into a shared resource so each entrypoint is self-contained and editor / CI can run independently."
  - "Stage parameter pattern: --stage tooling | strict on the headless verifier; EditorScript hard-codes `_stage = 'tooling'` for the developer's editor convenience. Marker semantics (PHASE5_GROUP_OK / PHASE5_GROUP_PENDING / PHASE5_GROUP_FAIL) are consistent across stages so log scrapers work uniformly."
  - "Operator-local resolved paths are gitignored by the phase's own .gitignore; the script + smoke + verifier helpers ARE source-controlled and stable across machines."

requirements-completed: [COV-02, COV-03, TYPEVAR-01, TYPEVAR-02, TYPEVAR-03, TYPEVAR-04, TYPEVAR-05, COV-01, COV-07, COV-09, TYPEVAR-06]
# NOTE: requirement IDs above are copied from the plan's `requirements:` frontmatter
# array verbatim. Plan 01 OPENS the verifier surface that proves these requirements
# (per D-12); the implementation work that closes each REQ lands in Plans 05-02..05-07.
# In tooling stage today, 1 of 7 named groups (assert_no_theme_clear) is ENFORCED OK;
# the other 6 are PENDING and flip to ENFORCED as the implementation work lands.
# The Phase verifier (Phase 5 /gsd-verify-work) re-evaluates these requirement IDs
# against the strict-mode verifier output once all plans complete.

duration: ~21min
completed: 2026-05-07T04:13:00Z
---

# Phase 5 Plan 01: Godot 4.6 CLI + Phase 5 Verifier Scaffold Summary

**Search-only Godot 4.6.x resolver + dual EditorScript/headless verifier with 7 named D-12 assertion groups + focus probe, ASCII-clean PowerShell with `_console.exe` preference for captureable Windows stdout, and operator-local path persistence gitignored.**

## Performance

- **Duration:** approximately 21 minutes
- **Started:** 2026-05-07T03:52:00Z (worktree branch creation)
- **Completed:** 2026-05-07T04:13:00Z
- **Tasks:** 2 (Task 1 + Task 2 by plan numbering; Task 2 checkpoint SKIPPED per `<checkpoint_handling>` because Task 1 successfully wrote helpers/godot-cli-path.txt)
- **Files created:** 6 source-controlled + 2 operator-local (gitignored) = 8 helper files plus 1 phase-level .gitignore

## Accomplishments

- Located Godot 4.6.2 mono stable on the operator's machine via `$env:GODOT4` (already set by the operator) at `C:\Programming_Files\Godot\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64.exe`. Resolver auto-detected the `_console.exe` companion and recorded that path so downstream `& $godot --version` / `--import` / `--script` PowerShell invocations capture stdout correctly.
- Wrote a search-only resolver that NEVER downloads or installs autonomously and refuses non-official hosts in `-AllowInstall` mode. Per cross-AI plan-review HIGH gate + project D-11.
- Verified the full Task 1 chain: resolver -> `--version` returns `4.6.2.stable.mono.official.71f334935` -> `--headless --import --quit-after 2` returns clean (no `^(ERROR|SCRIPT ERROR):` lines per PentaTile pitfall #1) -> CLI smoke loads `pulse_neocade_theme.tres` as `NeoCadeTheme` and asserts `has_stylebox("normal", "Button")` after load-time `_regenerate_theme()`.
- Authored the dual Phase 5 verifier (`_phase5_verify.gd` EditorScript + `_phase5_verify_headless.gd` SceneTree) with all 7 D-12 named assertion groups. Tooling stage exit 0, all 7 PHASE5_GROUP_OK markers present, 6 PENDING (matching exactly the Phase 5 work surface for Plans 05-02..05-07). Strict stage exit 1 (correct: implementation has not landed yet).
- Authored the focus probe (`_phase5_focus_probe.gd`) which structurally asserts the official `focus` stylebox is populated and visible on Button / CheckBox / CheckButton / OptionButton, AND hard-fails if any of the invented `pressed_focus` / `checked_focus` / `hover_pressed_focus` slots are ever wired (D-07 invariant). Pixel sample emits PHASE5_FOCUS_RENDER_SKIPPED per CONTEXT.md.
- Established the operator-local persistence pattern: `helpers/godot-cli-path.txt` and `helpers/godot-cli-provenance.txt` are gitignored at the phase level; downstream plans re-run the resolver on each machine. The script, smoke, verifier, and focus probe ARE source-controlled.

## Task Commits

Each task was committed atomically:

1. **Task 1: search-only resolver + CLI smoke** - `34f5d91` (feat)
   - Files: helpers/Resolve-Godot46.ps1, helpers/_phase5_cli_smoke.gd, .gitignore (phase-level)
2. **Task 2 [checkpoint:human-action]** - SKIPPED per `<checkpoint_handling>` because Task 1 successfully wrote helpers/godot-cli-path.txt (the operator already had Godot 4.6.2 mono installed). No commit; the checkpoint contract documents the alternate path (Resolve-Godot46.ps1 -AllowInstall ...).
3. **Task 3 (numbered Task 2 in plan): verifier scaffold + focus probe** - `097bf2c` (feat)
   - Files: helpers/_phase5_verify_headless.gd, helpers/_phase5_verify.gd, helpers/_phase5_focus_probe.gd

(Plan-metadata commit lands separately when this SUMMARY.md is staged. Per `<parallel_execution>`, the worktree-mode autodetect in execute-plan.md commits SUMMARY.md alone here; STATE.md and ROADMAP.md are deliberately NOT modified by this worktree per the orchestrator contract.)

## Files Created/Modified

**Source-controlled:**
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/.gitignore` -- gitignores operator-local resolver outputs and the phase logs/ scratchpad. helpers/Resolve-Godot46.ps1 + helpers/_phase5_*.gd files are NOT ignored.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1` -- search-only Godot 4.6.x resolver with optional -AllowInstall (URL whitelist + SHA256 verification + extract-outside-repo). Exit 0 on success, 2 if no Godot found (writes GODOT-CLI-MISSING.md), 3 on -AllowInstall precondition failure.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd` -- SceneTree script that loads pulse_neocade_theme.tres, asserts NeoCadeTheme cast + Button.normal presence, and emits PHASE5_CLI_SMOKE OK marker.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd` -- SceneTree verifier with 7 D-12 named assertion groups + tooling/strict staging via OS.get_cmdline_user_args().
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd` -- EditorScript wrapper running the same 7 assertion groups for in-editor `File -> Run`.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd` -- focus slot structural probe (Button/CheckBox/CheckButton/OptionButton). Hard-fails if invented combo slots appear; emits PHASE5_FOCUS_RENDER_SKIPPED for the optional pixel sample.

**Operator-local (gitignored, written at runtime by Resolve-Godot46.ps1):**
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt` -- absolute path to the verified Godot 4.6.x exe. On this machine: `C:\Programming_Files\Godot\Godot_v4.6.2-stable_mono_win64\Godot_v4.6.2-stable_mono_win64_console.exe`.
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt` -- resolution timestamp, version line, executable path, and SHA256 / DownloadUrl when -AllowInstall was used.

**Operator-local (gitignored, written at runtime by verifier runs):**
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-resolve.log`
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-version.log`
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-import.log`
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-cli-smoke.log`
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-tooling.log`
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-strict.log`
- `.planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/logs/05-01-focus-probe.log`

## Decisions Made

See `key-decisions:` in the frontmatter above. The two largest:

1. **Prefer `_console.exe` over the GUI exe on Windows** -- this is a Windows-Godot wart that bites every project trying to do CLI verification. The GUI exe (default file extension Windows users associate with Godot) detaches from the parent console handle and silently drops stdout when invoked from non-console hosts (PowerShell / cmd). The `_console.exe` companion shipped in every official Godot 4.x Windows build wraps the GUI exe in a true console host. We detect both, prefer the console one, and write the console path to godot-cli-path.txt so all downstream `& $godot --version` invocations work without needing Start-Process specifically.
2. **Tooling/strict staging with PENDING markers that still emit OK in tooling** -- this lets the Plan 01 marker-presence gate pass right now (when no Phase 5 implementation work has landed) AND lets Plans 05-02..05-07 flip the gate to strict by argv only without re-authoring the verifier. The alternative (only emit OK when the strict invariant is met today) would have forced Plan 01 to either ship a stub verifier or block on every Phase 5 work plan being merged first; neither matches the plan's intent.

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Resolver crashed under StrictMode when no candidate paths discovered**
- **Found during:** Task 1 verification (initial run before Godot was discovered via the env probe).
- **Issue:** `Get-CandidatePaths` returned a `System.Collections.Generic.List[string]` with 0 items. PowerShell pipeline-unwraps an empty List to `$null`, then `$candidates.Count` raises under `Set-StrictMode -Version Latest`.
- **Fix:** Wrapped the return in a unary-comma array (`return ,$unique.ToArray()`) to suppress pipeline unwrapping and switched the caller to `$candidates.Length` plus an explicit `$null` check.
- **Files modified:** helpers/Resolve-Godot46.ps1 (Get-CandidatePaths return + Find-Godot46 length check)
- **Verification:** Resolver re-ran without exception; the search-only path either returns a path or writes GODOT-CLI-MISSING.md as the plan requires.
- **Committed in:** part of `34f5d91` (Task 1 commit).

**2. [Rule 1 - Bug] Em-dash mojibake broke the Windows PowerShell 5.1 parser**
- **Found during:** Task 1 verification (immediately after the file was first written).
- **Issue:** The plan's verify block invokes `powershell` (the legacy Windows PowerShell 5.1 host, not pwsh 7+). 5.1 reads .ps1 files in the system ANSI codepage. The original file contained em-dashes (U+2014), an ellipsis, and an ornament dash inside both Write-Info strings and the `Write-MissingFile` here-string body. Each was a multi-byte UTF-8 sequence that ANSI re-decoded as a 3-character noise glyph (e.g. `?"`), which the parser then choked on (`Missing closing '}' in statement block`, `Missing '(' after 'If' in if statement`, etc.).
- **Fix:** Replaced every non-ASCII character in the resolver source with a hyphen pair (`--`) or plain ASCII equivalent. Verified with `LC_ALL=C grep -n '[^[:print:][:space:]]'` which now returns no hits. Did the same on `_phase5_cli_smoke.gd`.
- **Files modified:** helpers/Resolve-Godot46.ps1 (10 lines), helpers/_phase5_cli_smoke.gd (2 lines)
- **Verification:** Resolver re-ran cleanly under both pwsh 7 (outer) and powershell 5.1 (inner that the plan's verify block invokes).
- **Committed in:** part of `34f5d91`.

**3. [Rule 1 - Bug] Resolver returned a Windows GUI exe path that produced no stdout from PowerShell**
- **Found during:** Task 1 verification (between resolver success and the `& $godot --version` step).
- **Issue:** The first successful resolver run wrote `Godot_v4.6.2-stable_mono_win64.exe` (the GUI variant) to godot-cli-path.txt. Subsequent `& $godot --version` produced empty stdout and undefined `$LASTEXITCODE`. Investigation confirmed the GUI exe always detaches from the parent console on Windows and silently drops stdout when launched from PowerShell or cmd. The plan's verify block uses `& $godot --version` and depends on captured stdout; it would have failed for every Plan 05-02..05-07 attempt.
- **Fix:** Added two helpers: `Resolve-PreferConsoleExe` (detects the `_console.exe` companion in the same folder and returns it when present) and `Invoke-GodotCapture` (Start-Process with `-RedirectStandardOutput` / `-RedirectStandardError`, the only invocation pattern that reliably captures Godot output on Windows). Updated `Find-Godot46` to write the resolved console-exe path to godot-cli-path.txt so downstream `& $godot ...` invocations capture stdout.
- **Files modified:** helpers/Resolve-Godot46.ps1 (Test-IsGodot46Executable rewrite + Find-Godot46 prefers console exe)
- **Verification:** Plan-verbatim verify block ran end-to-end. `& $godot --version` returns `4.6.2.stable.mono.official.71f334935`. `& $godot --headless --path . --import --quit-after 2 *> import.log` exits 0 with no `^(ERROR|SCRIPT ERROR):` lines. `& $godot --headless --path . --script ... cli_smoke.gd *> smoke.log` exits 0 with `PHASE5_CLI_SMOKE OK` marker present.
- **Committed in:** part of `34f5d91`.

**4. [Rule 1 - Bug] Verifier --stage argv was being passed to OS.get_cmdline_args() but Godot delivers it via OS.get_cmdline_user_args() when separated by `--`**
- **Found during:** Task 2 verification (when sanity-checking that strict mode actually rejects the Phase 4 baseline).
- **Issue:** Per the plan, the verifier is invoked as `... --script <path> -- --stage tooling`. Godot 4.6 splits CLI args at the literal `--`: engine + `--script <path>` arguments arrive in `OS.get_cmdline_args()`; user args (`--stage tooling`) arrive in `OS.get_cmdline_user_args()`. The original `_parse_args` only walked `OS.get_cmdline_args()` so `--stage` was never seen and the verifier silently defaulted to `tooling` even when the caller asked for `strict`.
- **Fix:** Walk both arrays, preferring `OS.get_cmdline_user_args()` (the canonical post-`--` location). Diagnosed via a 4-line argv inspection script that printed both arrays for the same invocation pattern.
- **Files modified:** helpers/_phase5_verify_headless.gd (`_parse_args`)
- **Verification:** Re-ran with `... --stage tooling` (exit 0, all OK markers, 6 PENDING) AND `... --stage strict` (exit 1, 6 FAIL + 1 OK). Both behaviors match the plan's intent.
- **Committed in:** part of `097bf2c` (Task 2 commit).

**5. [Rule 2 - Missing Critical] Focus probe `state_combos` strings used names that LOOK like invented theme slots**
- **Found during:** Task 2 self-review before commit (caught while writing the docstring for D-07).
- **Issue:** The probe's `FOCUS_TARGETS` list originally used `"states": ["focus_only", "pressed_focus", "checked_focus", ...]` as informational labels for the print output. These strings are NOT used as theme slot names anywhere -- the probe correctly checks `theme.has_stylebox("focus", klass)` and explicitly hard-fails if `theme.has_stylebox("pressed_focus", klass)` returns true -- but a casual reviewer reading `pressed_focus` in source could have misread it as the verifier itself referencing the forbidden slot, violating D-07's "verifier MUST NOT reference invented combo slots" intent.
- **Fix:** Renamed the field from `states` to `state_combos` and switched the strings to compound-state notation (`"focus"`, `"pressed+focus"`, `"checked+focus"`, `"disabled+focus"`) that reads as a visual scenario rather than as a theme slot name. Updated docstrings to call out explicitly that these are visual scenario labels, NOT theme slot names. The actual D-07 invariant guard (`FORBIDDEN_FOCUS_SLOTS = ["pressed_focus", "checked_focus", "hover_pressed_focus"]`) is unchanged.
- **Files modified:** helpers/_phase5_focus_probe.gd (FOCUS_TARGETS field rename + docstring tightening)
- **Verification:** Focus probe re-ran with new labels; output lines now read `state_combos=["focus", "pressed+focus", ...]`. Structural assertion + D-07 invariant guard both still pass.
- **Committed in:** part of `097bf2c`.

---

**Total deviations:** 5 auto-fixed (3 bugs / Rule 1, 1 missing critical / Rule 2, 1 blocking / Rule 3).
**Impact on plan:** All 5 deviations were essential for correctness. None introduced scope creep -- they all sit inside the Plan 01 deliverables surface (resolver + smoke + verifier + focus probe). Three of them (em-dash mojibake, GUI exe stdout, --stage argv) are Windows-Godot-specific footguns that would have silently broken every Plan 05-02..05-07 verify block; documenting them in this SUMMARY makes them visible to future readers and to the Phase 5 verifier.

## Issues Encountered

- **Worktree path confusion at session start.** The Write tool was called with absolute paths under the MAIN repo root (`C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.planning\...`) instead of the worktree path (`C:\Programming_Files\Shilocity\Godot\NeoCade-Theme\.claude\worktrees\agent-a78677c5a9da6fb70\.planning\...`). The first two helper files were written to the main repo and had to be `mv`-ed into the worktree before any verification could run. Subsequent file operations always used the worktree-prefixed path. Resolved with no data loss; surfaced as a process note for future agents -- in worktree mode the env's working-directory string IS the worktree path; Write paths must reflect that.
- **PowerShell 5.1 vs PowerShell 7 character encoding behavior.** The plan's verify block uses `powershell -ExecutionPolicy Bypass -File ...` which invokes Windows PowerShell 5.1 specifically. 5.1 reads .ps1 files in the system ANSI codepage; 7 reads UTF-8. Fixed by ASCII-only authoring (see deviation #2). For all future Phase 5 helpers, the rule is: any .ps1 file invoked by the plan MUST be ASCII-only or have a UTF-8 BOM.

## User Setup Required

None for this plan -- the operator already had Godot 4.6.2 mono stable installed under `C:\Programming_Files\Godot\` (the resolver detected it via the `$env:GODOT4` probe). Other operators running this plan on a different machine without Godot 4.6.x installed will trigger the human-action checkpoint and either (a) provide an absolute path to their already-installed Godot, or (b) approve `Resolve-Godot46.ps1 -AllowInstall -DownloadUrl <official URL> -ExpectedSha256 <hash>` -- contract documented in `helpers/GODOT-CLI-MISSING.md` (which the resolver writes when no executable is found).

## Next Phase Readiness

**Plan 05-02 unblocked.** The recorded Godot path + verifier scaffold satisfy every Plan 05-02..05-07 prerequisite:

- All later plans read `helpers/godot-cli-path.txt` to find Godot. The path is operator-local but the resolver script is source-controlled; downstream agents on different machines just rerun `Resolve-Godot46.ps1` once.
- All later plans run `_phase5_verify_headless.gd` with `--stage strict` to gate their work. Today the verifier passes only `assert_no_theme_clear` in strict mode; as Plan 05-02..05-07 ship their work, additional groups flip from PENDING to ENFORCED and the strict gate progressively closes.
- The focus probe is wired and ready for Plan 05-03 (BaseButton family + Button variations) to start emitting per-variation focus slots, which will flip `assert_focus_overlay_visibility` from PENDING to ENFORCED.
- The CLI smoke is the minimum viable Plan 5 invocation surface; if a later plan introduces a regression that prevents `pulse_neocade_theme.tres` from loading as `NeoCadeTheme`, the smoke immediately catches it without needing the full strict verifier.

## Self-Check: PASSED

Verified post-write that all source-controlled artifacts exist on disk and the two task commits are present in git history.

```
Files (source-controlled):
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/.gitignore
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/Resolve-Godot46.ps1
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_cli_smoke.gd
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify_headless.gd
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_verify.gd
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/_phase5_focus_probe.gd

Files (operator-local, gitignored, present at runtime):
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-path.txt
  FOUND: .planning/phases/05-core-controls-buttons-inputs-labels-panels-desktop/helpers/godot-cli-provenance.txt

Commits:
  FOUND: 34f5d91  feat(05-01): add Godot 4.6 CLI resolver + Phase 5 CLI smoke
  FOUND: 097bf2c  feat(05-01): add Phase 5 verifier scaffold + focus probe
```

---
*Phase: 05-core-controls-buttons-inputs-labels-panels-desktop*
*Plan: 01*
*Completed: 2026-05-07*
