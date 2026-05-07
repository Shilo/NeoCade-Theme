# QA Tooling Baseline

**Date:** 2026-05-07
**Godot:** 4.6.2.stable.official.71f334935
**Renderer smoke:** OpenGL 3.3 Compatibility on NVIDIA GeForce RTX 3070 Ti

## Available

- Godot MCP `get_project_info`
- Godot MCP `run_project`
- Godot MCP `get_debug_output`
- Godot MCP `stop_project`

## Verified

- `main.tscn` launches through the MCP runner.
- Final Phase 9 smoke run produced no debug errors.
- Project remains configured for GL Compatibility:
  - `renderer/rendering_method="gl_compatibility"`
  - `renderer/rendering_method.mobile="gl_compatibility"`

## Not Available in This Session

- Screenshot capture MCP command.
- Input injection / tab-walk automation.
- Android device.
- iOS device / Apple Developer signing context.
- macOS runner.
- Export templates installed locally.

These unavailable surfaces are tracked as deferred manual/device UAT rather
than silently accepted.
