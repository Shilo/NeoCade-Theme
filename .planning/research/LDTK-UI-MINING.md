# LDtk UI Mining

Authored: 2026-05-04

## Provenance

| Field | Live value |
|---|---|
| Source root | `C:\Programming_Files\ldtk-master\` |
| Snapshot date | 2026-05-04 |
| LDtk version | `1.5.3` from `docs/version.txt` and `app/package.json` |
| Repository metadata | No `.git` directory in local snapshot; no commit SHA available, version-only |
| License | MIT License, copyright Sebastien Benard / Deepnight Games |
| `src/electron.renderer/**/*.hx` | 143 Haxe files |
| `src/electron.renderer/ui/**/*.hx` | 69 Haxe files |
| `src/electron.renderer/page/Editor.hx` | 1 file, 2456 lines |
| `src/electron.renderer/tool/**/*.hx` | 9 Haxe files |
| `app/assets/css/app.scss` | 9322 lines |
| `docs/CHANGELOG.md` | 1023 lines |
| `app/assets/icons/*.svg` | 98 SVG files |
| `res/atlas/` | 2 files: `appElements.aseprite`, `icons.aseprite` |
| `res/fonts/` | 13 files: Noto Sans Display Semicondensed bitmap atlases, `pixel_berry`, and notes |

Inventory commands were run from Windows PowerShell. Preferred `rg` commands were paired with `Get-ChildItem` or `Get-Content | Measure-Object` fallbacks; when both were available for SVG icons, they agreed at 98 files. The local LDtk root has no root `version.txt`; `docs/version.txt` and `app/package.json` both report `1.5.3`.

## Scope and Method

LDtk is a loose inspiration resource, not a NeoCade design spec, value source, or implementation dependency. This document mines LDtk for polish patterns that can inform future design discussion; it does not promote LDtk's UI architecture, palette, icon set, asset pipeline, or editor-specific behavior into requirements.

The order below is optimized for Phase 2 mining flow while preserving every D-10 deliverable from `02-CONTEXT.md`. The Haxe pass records per-file UI behavior first, then extracts adopt/reject candidates with file:line citations. The SCSS, CHANGELOG, asset, and prior-report passes append evidence under their reserved headings.

Every adopted pattern must cite at least one source file path and line range. Every translation note must start with this exact prefix:

`Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`

Anti-cyberpunk filtering is mandatory for every candidate pattern. NeoCade's target remains vibrant arcade hall by day: no synthwave/noir drift, no glow halos, no scanline/grid overlays, no sci-fi console terminology, no pixel-art theme chrome, and no direct LDtk visual copying.

PowerShell-native inventory fallbacks used during this phase:

| Intent | Preferred command | PowerShell fallback |
|---|---|---|
| Haxe renderer file count | `rg --files C:\Programming_Files\ldtk-master\src\electron.renderer -g '*.hx'` | `Get-ChildItem C:\Programming_Files\ldtk-master\src\electron.renderer -Recurse -Filter *.hx` |
| Haxe UI file count | `rg --files C:\Programming_Files\ldtk-master\src\electron.renderer\ui -g '*.hx'` | `Get-ChildItem C:\Programming_Files\ldtk-master\src\electron.renderer\ui -Recurse -Filter *.hx` |
| SVG icon count | `rg --files C:\Programming_Files\ldtk-master\app\assets\icons -g '*.svg'` | `Get-ChildItem C:\Programming_Files\ldtk-master\app\assets\icons -Filter *.svg` |
| SCSS line count | `rg --files ...` plus reader count | `(Get-Content C:\Programming_Files\ldtk-master\app\assets\css\app.scss | Measure-Object -Line).Lines` |
| CHANGELOG line count | `rg --files ...` plus reader count | `(Get-Content C:\Programming_Files\ldtk-master\docs\CHANGELOG.md | Measure-Object -Line).Lines` |
| Git metadata | `git -C C:\Programming_Files\ldtk-master rev-parse --short HEAD` | `if (Test-Path C:\Programming_Files\ldtk-master\.git) { git -C ... } else { 'No .git directory in snapshot' }` |

## File-by-File UI Index

Reserved for Plan 02-02.

## UI Pattern Catalogue

Reserved for Plan 02-02.

## SCSS Chrome and Interaction Conventions

Reserved for Plan 02-03.

## Rejected Patterns

Reserved for Plans 02-02 through 02-04.

## CHANGELOG Lessons Learned

Reserved for Plan 02-04.

## Asset Inventory

Reserved for Plan 02-04.

## Prior Research Report Claim Verification

Reserved for Plan 02-04.

## Anti-Cyberpunk Filter Audit

Reserved for Plan 02-05.

## Open Questions

Reserved for Plan 02-05.

## Phase 2 Verification Log

Reserved for Plan 02-05.
