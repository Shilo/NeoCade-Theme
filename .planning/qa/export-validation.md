# Export Validation Matrix

**Date:** 2026-05-07
**Mode:** Autonomous best-effort. Export templates, signing identities, and
real devices are not available in this session.

| Target | Preset | Status | Notes |
|---|---|---|---|
| Windows | `Windows` | PRESET READY | Requires Godot export templates on CI/local runner |
| Linux | `Linux` | PRESET READY | Requires Godot export templates on CI/local runner |
| macOS | `macOS` | PRESET READY | Requires macOS signing/notarization decision before public release |
| Android | `Android` | PRESET READY / DEVICE UAT DEFERRED | Uses `custom_features="mobile"`; physical device validation deferred |
| iOS | `iOS` | PRESET READY / DEVICE UAT DEFERRED | Requires Apple Developer signing context; physical device validation deferred |
| Web | `Web` | PRESET READY | Used by release workflow for showcase export and Pages deployment |

## Web-Specific Checks

- `include_filter` includes `addons/neocade_theme/fonts/*.ttf` so the Inter
  font is exported even though it is a raw font resource.
- The project uses GL Compatibility, matching the v1 ship target.
- The release workflow opens `showcase/showcase.tscn` headlessly before exporting Web.

## Deferred

- Actual per-target binary output.
- Per-target screenshot decks under `.planning/qa/exports/<target>/`.
- Android/iOS real-device render verification.
- macOS codesign/notarization verification.

These are blocked on templates/devices/signing and are carried as release
notes limitations if still unavailable at v1.0.0.
