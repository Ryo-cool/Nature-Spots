# Blacksmith Benchmark Log

## Purpose
Compare CI runtime between GitHub-hosted runners and Blacksmith runners using successful runs on the same `headSha`.

## Scope
- Repository: `Ryo-cool/Nature-Spots` (organization-side benchmark repository)
- Workflows:
  - `Backend CI` vs `Backend CI (Blacksmith)`
  - `Frontend CI` vs `Frontend CI (Blacksmith)`
- Event: `pull_request`
- Pairing rule: only successful run pairs with the same `headSha`
- Exclusions: any non-successful runs (`failure`, `cancelled`, `timed_out`, etc.)

## Runner Configuration
- `BLACKSMITH_RUNNER_LABEL` repository variable controls the runner label.
- Default label in workflows: `blacksmith-4vcpu-ubuntu-2404`
- Note: set a fixed label from the Blacksmith dashboard for the entire benchmark window.
- Optional: set `RUN_FRONTEND_TESTS=true` when including `yarn test` in both frontend workflows.

## Baseline Snapshot (2026-02-14)
- Backend CI successful runs (last 50): avg `61s`
- Frontend CI successful runs (last 50): avg `73s`

## Execution Procedure
1. Run base and Blacksmith workflows in parallel on the same PR.
2. Collect at least 5 successful pairs per workflow.
3. Run the command below to generate the comparison report.

```bash
./scripts/ci/compare_blacksmith.sh <owner/repo>
```

Example:

```bash
./scripts/ci/compare_blacksmith.sh my-org/Nature-Spots
```

## Result Template
### Measurement Window
- Start:
- End:
- Runner tag:
- Pair count (backend):
- Pair count (frontend):

### Backend Summary
- base avg / median / p90:
- blacksmith avg / median / p90:
- delta avg / median / p90:
- Notes:

### Frontend Summary
- base avg / median / p90:
- blacksmith avg / median / p90:
- delta avg / median / p90:
- Notes:

### Conclusion
- Observed speed difference:
- Adoption decision:
- Follow-up actions:
