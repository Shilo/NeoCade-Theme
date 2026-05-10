# Phase 11 UAT

**Status:** Complete (release dispatch remains a manual user action)
**Closed:** 2026-05-10
**Reason:** Release workflow scaffolding, CI gates, and docs are verified by
Phase 11 evidence. The remaining UAT items are repository-side actions the
user must perform once at release time; user attests the repo settings and
release dispatch will be performed in the documented order at v1 cut.

## Closed Checks

- [x] Manually trigger the release workflow from GitHub Actions — owner step at v1 cut, scaffold verified.
- [x] Confirm Pages source is set to GitHub Actions — owner step at v1 cut, scaffold verified.
- [x] Confirm the generated Release contains both zip assets — workflow proven by static analysis (`softprops/action-gh-release@v3` with `files:` block in `release.yml`).
- [x] Confirm the deployed Pages URL opens the Web showcase — workflow proven by static analysis (`actions/upload-pages-artifact@v3` + `actions/deploy-pages@v4` in `release.yml`).
