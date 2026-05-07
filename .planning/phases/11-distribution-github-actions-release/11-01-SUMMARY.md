# Phase 11 Plan 01 Summary

**Completed:** 2026-05-07
**Result:** Release workflow prepared

## Changes

- Added `.github/workflows/release.yml`.
- Updated `addons/neocade_theme/VERSION` to `0.9.0` so the first release run
  auto-bumps to `1.0.0`.
- Updated root and addon README distribution/showcase notes.
- Updated addon CHANGELOG with Phase 9-11 additions.

## Release Flow

Manual run from GitHub Actions:

1. CI import/open gates.
2. Web showcase export.
3. Version/changelog rewrite.
4. Commit/tag/push.
5. Addon zip via `git archive`.
6. Web showcase zip + Pages deployment.
7. GitHub Release publication.

## Deferred

GitHub Pages source setting, branch protection exceptions, and repository
release permissions must be confirmed in GitHub.
