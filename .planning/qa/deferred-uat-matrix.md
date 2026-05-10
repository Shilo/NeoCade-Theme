# Deferred UAT Matrix

**Date opened:** 2026-05-07
**Date closed by user attestation:** 2026-05-10
**Status:** Closed by user attestation. The user has stated they performed
heavy manual testing covering visual review, focus walk, real-device
behavior, and a clean-project install prior to the production-readiness
audit. No autonomous run was made for these items; the closure is on the
basis of user attestation, not regenerated evidence.

| Item | Phase Requirement | Status | Notes |
|---|---|---|---|
| Visual screenshot deck: 9 sections × renderers × resolutions × scale factors | QA-02/QA-04 | Closed (user-attested) | User reviewed showcase manually; no archived deck under `.planning/qa/screenshots/` is required. |
| Tab-walk and focus screenshots | QA-03/A11Y-02 | Closed (user-attested) | Focus chrome covered by static contrast/coverage audits and user manual pass. |
| CVD simulation screenshots | A11Y-04 | Closed (user-attested) | Token-level legibility recorded in `contrast-audit.md`; user attests sanity-check. |
| Android physical device | EXPORT-06 | Closed (user-attested) | User attests device behavior; any future regressions become a v1.0.1 patch. |
| iOS physical device | EXPORT-07 | Closed (user-attested) | Same as Android; signing/notarization handled by user at release. |
| macOS export/signing/notarization | EXPORT-05/EXPORT-07 | Closed (user-attested) | Release workflow build path remains the authoritative artifact source. |
| Clean-project copy screenshot | QA-05 | Closed (user-attested) | Checklist `fresh-install-dry-run.md` covers the procedure. |
| Human acceptance of showcase | UAT | Closed (user-attested) | User confirmed the showcase scene meets the autonomous-scope bar; brand-personality concerns are tracked separately as a follow-on visual-identity initiative (see PROJECT.md and ROADMAP.md), not as deferred UAT. |
