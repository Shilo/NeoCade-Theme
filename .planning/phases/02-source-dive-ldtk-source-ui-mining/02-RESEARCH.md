# Phase 2 Research: LDtk Source UI Mining

**Researched:** 2026-05-04
**Status:** Planning research complete

## Source Availability

LDtk source root is present at `C:\Programming_Files\ldtk-master`.

Quick planning-time inventory:

| Surface | Observed |
|---------|----------|
| `src/electron.renderer/**/*.hx` | 143 Haxe files |
| `src/electron.renderer/ui/**/*.hx` | 69 Haxe files |
| `app/assets/css/app.scss` | 9322 lines |
| `docs/CHANGELOG.md` | 1023 lines |
| `app/assets/icons/*.svg` | 98 SVG icons |
| `res/atlas/` | `appElements.aseprite`, `icons.aseprite` |
| `res/fonts/` | Noto Sans bitmap atlases plus `pixel_berry` bitmap font |
| Git metadata | No `.git` directory in the LDtk snapshot |
| Version file | `docs/version.txt` exists; root `version.txt` does not |

The current local `app.scss` line count differs from the Phase 2 context's earlier approximate value, so executors must record live provenance from the current files rather than copying stale counts.

## Planning Implications

Phase 2 should be split into multiple documentation-only plans:

- Establish the target artifact and provenance first so every later plan appends to a stable `LDTK-UI-MINING.md` structure.
- Mine Haxe UI files by surface area, not randomly: `page/Editor.hx` and `tool/` for chrome/tool wiring, `ui/` for reusable panels/forms, `ui/modal/` for dialogs/context menus/panels, `ui/palette/` and `ui/vp/` for palettes/viewport UI.
- Mine `app.scss` separately because its size and selector density make it the main source for interaction-state and chrome conventions.
- Treat CHANGELOG, SVG icons, atlas files, bitmap fonts, and prior-report claim verification as one evidence pass because those outputs feed the same sections in the final artifact.
- Update `.planning/research/SOURCES.md` only after the evidence artifact is complete; this keeps Section 2/3 confidence changes grounded.

## Risks

- LDtk is loose inspiration only. Every translation note in `LDTK-UI-MINING.md` must begin with `Inspiration sketch - Phase 3 mockup or Phase 5+ designer's call.`
- Do not touch `addons/neocade_theme/` or `.tres` files in this phase.
- Do not copy LDtk color values, SVG designs, bitmap atlases, or exact SCSS values into NeoCade as binding decisions.
- Anti-cyberpunk screening must be explicit for each adopted pattern.

## Research Complete

The source tree is available and broad enough to justify a five-plan split. No additional external research is needed before authoring Phase 2 plans.

