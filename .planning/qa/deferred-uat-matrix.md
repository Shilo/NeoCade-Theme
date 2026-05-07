# Deferred UAT Matrix

**Date:** 2026-05-07
**Reason:** User requested autonomous continuation, no questions, and deferral
of all UAT tasks.

| Item | Phase Requirement | Deferred To | Release Impact |
|---|---|---|---|
| Visual screenshot deck: 9 sections × renderers × resolutions × scale factors | QA-02/QA-04 | Manual QA pass | Note limitation if absent at release |
| Tab-walk and focus screenshots | QA-03/A11Y-02 | Manual QA pass | Required before "fully visually validated" claim |
| CVD simulation screenshots | A11Y-04 | Manual QA pass | Note limitation if absent |
| Android physical device | EXPORT-06 | v1.0.1 or pre-release manual run | Changelog limitation if unavailable |
| iOS physical device | EXPORT-07 | v1.0.1 or pre-release manual run | Changelog limitation if unavailable |
| macOS export/signing/notarization | EXPORT-05/EXPORT-07 | CI/macOS runner | Release workflow can still build Web/addon |
| Clean-project copy screenshot | QA-05 | Manual QA pass | Checklist exists |
| Human acceptance of showcase | UAT | User review after autonomous run | Not blocking per user instruction |

No item above stops autonomous execution. Each is explicit so deferred UAT is
visible and recoverable.
