---
phase: 03-visual-direction-mockup-approval-gate
artifact: tooling-baseline
status: complete
date: 2026-05-04
---

# Phase 3 Tooling Baseline

## Summary

Phase 3 has a working Godot launch/debug path, a repeatable screenshot fallback, browser screenshot tools for HTML mockup review, and access to the Codex app `image_gen` tool through the `imagegen` skill. The currently active Godot MCP surface is the Coding-Solo `godot-mcp` style launch/debug surface; it does not expose direct viewport screenshot capture in this session.

## Godot Project Check

| Check | Result |
| --- | --- |
| Godot version | `4.6.2.stable.official.71f334935` |
| Project path | `C:\Programming_Files\Shilocity\Godot\NeoCade-Theme` |
| Project name | `NeoCade-Theme` |
| Project info | 1 scene, 0 scripts, 1 asset, 7 other files reported by MCP |
| Shell Godot executable | `godot`, `godot4`, and `godot4.6` were not on PATH |
| MCP project run | PASS: `mcp__godot__.run_project` launched the project |
| MCP debug/stop | PASS: `mcp__godot__.stop_project` returned normal Godot startup output and no final errors |
| Renderer observed | OpenGL API 3.3.0, Compatibility, NVIDIA GeForce RTX 3070 Ti |

Observed stop output:

```text
Godot Engine v4.6.2.stable.official.71f334935 - https://godotengine.org
OpenGL API 3.3.0 NVIDIA 591.86 - Compatibility - Using Device: NVIDIA - NVIDIA GeForce RTX 3070 Ti
finalErrors: []
```

## Active Godot MCP Surface

`tool_search` exposed these Godot tools in the active session:

| Tool | Useful for Phase 3/10? |
| --- | --- |
| `mcp__godot__.get_godot_version` | Version proof. |
| `mcp__godot__.get_project_info` | Project metadata proof. |
| `mcp__godot__.run_project` | Runtime smoke launch. |
| `mcp__godot__.stop_project` | Runtime cleanup and debug output. |
| `mcp__godot__.launch_editor` | Editor launch if needed. |
| `mcp__godot__.list_projects` | Discovery only. |
| `mcp__godot__.get_uid` | Resource UID lookup. |
| `mcp__godot__.update_project_uids` | UID maintenance. |

Direct screenshot, viewport image capture, input injection, scene tree inspection, node click, or UI automation tools were not exposed by this MCP surface during Phase 3.

## GoPeak Check

`npx -y gopeak --help` succeeded and reported:

```text
GoPeak v2.3.6 - AI-Powered Godot Development via MCP
Usage:
  gopeak                Start MCP server (default)
  gopeak setup          Install shell hooks for update notifications
  gopeak check          Check for GoPeak updates
  gopeak version        Show current version
More info: https://github.com/HaD0Yun/Gopeak-godot-mcp
```

GoPeak is available as an installable/runnable MCP server command, but it is not the MCP server currently loaded into Codex's active callable tool surface. Because Codex cannot hot-swap the active MCP server from inside this execution thread, a direct GoPeak screenshot-tool smoke test could not be called here. The actionable result is: use the current Coding-Solo MCP surface for launch/debug in Phase 3, and prefer GoPeak for Phase 10 if it is loaded before QA and exposes screenshot/visual tools.

## Screenshot Baseline

Direct Godot MCP screenshot capture was not available, so Phase 3 proved a programmatic fallback:

| Screenshot path | Method | Result |
| --- | --- | --- |
| `.planning/research/godot-screenshot-smoke.png` | PowerShell + `System.Windows.Forms.Screen.PrimaryScreen` + `System.Drawing.Graphics.CopyFromScreen` while the Godot project was running | PASS, PNG generated |

This is an external desktop capture, not a Godot viewport-only capture. It is good enough for the Phase 3 smoke requirement and can scale into named output files, but Phase 10 should prefer a viewport-native path.

Recommended Phase 10 screenshot harness:

```gdscript
@tool
extends EditorScript

func _run() -> void:
    await get_tree().process_frame
    var image := get_tree().root.get_texture().get_image()
    var output := "user://qa-screenshots/neocade-desktop-main.png"
    image.save_png(output)
```

If running from a standalone test scene, use the active scene viewport instead of `get_tree().root` and save deterministic filenames such as `neocade-desktop-button-states.png`, `neocade-mobile-form-controls.png`, and `neocade-editor-inspector.png`.

Input injection is intentionally deferred to Phase 10 QA. Phase 3 only proves screenshot capture or a repeatable fallback.

## Browser / HTML Mockup Review

Playwright tooling is available for browser-side concept-board checks. The current exposed browser tools include `mcp__playwright__.browser_take_screenshot` and `mcp__playwright__.browser_snapshot`; additional navigation/resize tools can be discovered with `tool_search` when Plan 02 renders the HTML board.

Use browser screenshots for:

- Full-page desktop check of `.planning/mockups/03-direction-boards.html`.
- Mobile-width check for text fit, overlap, and direction-card readability.
- Accessibility snapshot where useful for heading/button text structure.

## Image Generation Availability

The Codex app `image_gen` tool is available in this runtime and the `imagegen` skill was read for output handling. Plan 02 should use `image_gen` for concept-design images first, then build the HTML/Markdown direction boards around those images and the supporting text.

Project-bound generated images must be moved or copied into `.planning/mockups/concepts/` after generation. If `image_gen` becomes unavailable in a later continuation, Plan 02 is blocked until the user enables/provides an image-generation path; it should not silently downgrade to HTML-only or text-only concept boards.
