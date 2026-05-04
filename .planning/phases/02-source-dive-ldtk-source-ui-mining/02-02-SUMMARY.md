---
phase: 02-source-dive-ldtk-source-ui-mining
plan: 02
subsystem: haxe-ui-mining
tags:
  - research
  - ldtk
  - haxe
key-files:
  - .planning/research/LDTK-UI-MINING.md
metrics:
  files_indexed: 80
  ui_haxe_files_indexed: 69
  editor_files_indexed: 1
  base_tool_files_indexed: 1
  tool_files_indexed: 9
  haxe_adopted_patterns: 14
  haxe_rejected_patterns: 6
  not_ui_files: 1
---

# Phase 02 Plan 02 Summary

## Commits

| Commit | Description |
|---|---|
| Pending | Append Haxe file index, adopted UI patterns, and rejected implementation patterns |

## Completed

- Indexed 80 Haxe UI/chrome/tool surfaces: 69 `ui/**/*.hx` files, `page/Editor.hx`, `Tool.hx`, and 9 `tool/**/*.hx` files.
- Reconciled index count against the target file list; no target files were silently omitted.
- Marked one target as `not-ui`: `src/electron.renderer/ui/modal/DebugMenu.hx`.
- Appended 14 Haxe-derived adopted pattern entries with file:line citations and anti-cyberpunk notes.
- Appended 6 Haxe-derived rejected pattern entries with portability/scope reasoning.
- Used the required translation prefix on every Haxe translation sketch.

## Deviations

None.

## Self-Check: PASSED

Haxe mining materially exceeds the ROADMAP floors by itself: 14 adopted patterns and 6 rejected patterns. No theme/addon files were touched.
