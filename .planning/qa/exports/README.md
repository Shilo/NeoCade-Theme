# Export Output Decks

Actual export artifacts are not committed to the repository. This directory is
reserved for per-target QA screenshots and notes captured during release
validation.

Expected future layout:

```text
.planning/qa/exports/
  windows/
  linux/
  macos/
  android/
  ios/
  web/
```

Each target folder should include:

- build command/log summary
- showcase screenshot deck
- target-specific limitations
- device/OS/browser version notes where applicable
