#!/bin/bash
set -euo pipefail

echo "--- :merged: GitHub Merge Queue Integration"
echo ""
echo "  When GitHub merge queue triggers a build, Buildkite sets special"
echo "  environment variables you can use for conditional logic."

echo ""
echo "--- :mag: Merge Queue Environment Variables"
echo ""
echo "  Checking current build..."
echo ""

MQ_BASE_BRANCH="${BUILDKITE_MERGE_QUEUE_BASE_BRANCH:-""}"
MQ_BASE_COMMIT="${BUILDKITE_MERGE_QUEUE_BASE_COMMIT:-""}"
MQ_TRIGGERED="${BUILDKITE_MERGE_QUEUE_TRIGGERED:-""}"

if [[ -n "$MQ_BASE_BRANCH" ]]; then
  echo "  🟢 This IS a merge queue build!"
  echo ""
  echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH  = $MQ_BASE_BRANCH"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT  = $MQ_BASE_COMMIT"
  echo "  BUILDKITE_MERGE_QUEUE_TRIGGERED    = $MQ_TRIGGERED"
else
  echo "  ℹ️  This is a regular build (not triggered by merge queue)"
  echo ""
  echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH  = (not set)"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT  = (not set)"
  echo "  BUILDKITE_MERGE_QUEUE_TRIGGERED    = (not set)"
  echo ""
  echo "  These vars are only populated when GitHub merge queue triggers the build."
fi

echo ""
echo "--- :yaml: Conditional Steps with if:"
echo ""
echo "  Run steps ONLY inside a merge queue build:"
echo ""
echo '    steps:'
echo '      - label: "Merge queue validation"'
echo '        if: build.merge_queue.base_commit != null'
echo '        command: run-merge-checks.sh'
echo ""
echo "  Skip steps during merge queue builds:"
echo ""
echo '      - label: "Full integration tests"'
echo '        if: build.merge_queue.base_commit == null'
echo '        command: run-full-tests.sh'

echo ""
echo "--- :gear: How to Enable"
echo ""
echo "  1. Pipeline Settings → GitHub → ✅ Build merge queues"
echo "  2. GitHub repo → Settings → Branch protection → Enable merge queue"
echo ""
echo "  Auto-cancel feature:"
echo "    When a merge group is invalidated, Buildkite automatically"
echo "    cancels the running build — no wasted compute."

echo ""
echo "--- :white_check_mark: Summary"
echo ""
echo "  ✅ Detect merge queue builds via env vars"
echo "  ✅ Conditional steps with if: expressions"
echo "  ✅ Auto-cancel invalidated merge groups"
echo "  ✅ Works with existing pipeline config"

buildkite-agent annotate --style info --context merge-queue << 'ANNOTATION'
## :merged: GitHub Merge Queue — Reference Card

### Environment Variables
| Variable | Description |
|----------|-------------|
| `BUILDKITE_MERGE_QUEUE_BASE_BRANCH` | The target branch (e.g., `main`) |
| `BUILDKITE_MERGE_QUEUE_BASE_COMMIT` | The commit SHA of the base branch |
| `BUILDKITE_MERGE_QUEUE_TRIGGERED` | Whether this build was triggered by merge queue |

### Conditional Steps
```yaml
steps:
  # Only in merge queue builds
  - label: "Merge validation"
    if: build.merge_queue.base_commit != null
    command: run-merge-checks.sh

  # Only in regular builds
  - label: "Full test suite"
    if: build.merge_queue.base_commit == null
    command: run-full-tests.sh
```

### Enable It
1. **Buildkite:** Pipeline Settings → GitHub → ✅ Build merge queues
2. **GitHub:** Repo Settings → Branch protection → Enable merge queue

### Links
- 📖 [GitHub Merge Queue tutorial](https://buildkite.com/docs/pipelines/tutorials/github-merge-queue)
- 📝 [Blog: Using GitHub merge queues](https://buildkite.com/resources/blog/using-github-merge-queues-with-buildkite)
ANNOTATION

echo ""
echo "✅ Merge Queue demo complete"
