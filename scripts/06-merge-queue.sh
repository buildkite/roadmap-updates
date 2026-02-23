#!/bin/bash
set -euo pipefail

echo "+++ :merged: GitHub Merge Queue — Conditionals"
echo ""
echo "  Buildkite sets env vars when GitHub merge queue triggers a build."
echo ""

MQ_BASE_BRANCH="${BUILDKITE_MERGE_QUEUE_BASE_BRANCH:-""}"
MQ_BASE_COMMIT="${BUILDKITE_MERGE_QUEUE_BASE_COMMIT:-""}"
MQ_TRIGGERED="${BUILDKITE_MERGE_QUEUE_TRIGGERED:-""}"

if [[ -n "$MQ_BASE_BRANCH" ]]; then
  echo "  🟢 This IS a merge queue build!"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH  = $MQ_BASE_BRANCH"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT  = $MQ_BASE_COMMIT"
  echo "  BUILDKITE_MERGE_QUEUE_TRIGGERED    = $MQ_TRIGGERED"
else
  echo "  ℹ️  Regular build (not merge queue)"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH  = (not set)"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT  = (not set)"
  echo "  BUILDKITE_MERGE_QUEUE_TRIGGERED    = (not set)"
fi

echo ""
echo "  ┌─────────────────────────────────────────────────────┐"
echo "  │  steps:                                             │"
echo '  │    - label: "Merge queue validation"                │'
echo "  │      if: build.merge_queue.base_commit != null      │"
echo "  │      command: run-merge-checks.sh                   │"
echo "  └─────────────────────────────────────────────────────┘"
echo ""
echo "  🔀 if: != null ──→ only in merge queue"
echo "  🚫 if: == null ──→ skip during merge queue"
echo "  ⚡ Auto-cancel invalidated merge groups"
echo "  📖 docs.buildkite.com/pipelines/tutorials/github-merge-queue"
echo "  📝 Blog: Using GitHub merge queues with Buildkite"

buildkite-agent annotate --style info --context merge-queue << 'ANNOTATION'
## :merged: GitHub Merge Queue
```yaml
steps:
  - label: "Merge validation"
    if: build.merge_queue.base_commit != null
    command: run-merge-checks.sh
```
- 📖 [Merge Queue tutorial](https://buildkite.com/docs/pipelines/tutorials/github-merge-queue)
- 📝 [Blog: Using GitHub merge queues](https://buildkite.com/resources/blog/using-github-merge-queues-with-buildkite)
ANNOTATION

echo ""
echo "✅ Merge Queue demo complete"
