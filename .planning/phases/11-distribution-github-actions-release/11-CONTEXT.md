# Phase 11: Distribution - GitHub Actions Release Context

**Gathered:** 2026-05-07
**Status:** Ready for planning
**Mode:** Autonomous (`--auto`; no questions)

<domain>
## Phase Boundary

Phase 11 prepares the release pipeline. v1 ships through GitHub Releases only,
with a Web showcase artifact and GitHub Pages deployment. Asset Library
submission remains out of scope.
</domain>

<decisions>
## Implementation Decisions

- **D-01:** Use a single `workflow_dispatch` release workflow with no manual inputs.
- **D-02:** Use `addons/neocade_theme/VERSION` as the version source.
- **D-03:** Normalize the current pre-release version to `0.9.0` so the workflow's
  minor-bump rule produces `1.0.0`.
- **D-04:** Adapt the PentaTile release workflow pattern to NeoCade's addon path,
  Web showcase export, and GitHub Pages deployment.
- **D-05:** Keep release zips limited to tracked addon files through `git archive`.
</decisions>

<deferred>
## Deferred Ideas

- One-time GitHub Pages repository setting (`Source = GitHub Actions`) must be
  done in GitHub if it is not already configured.
- Branch protection or release permissions may require repository-owner action.
</deferred>
