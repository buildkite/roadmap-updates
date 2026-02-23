#!/bin/bash
set -euo pipefail

echo "--- :merged: GitHub Merge Queue Detection"
echo ""
echo "Buildkite supports creating builds for pull requests in a GitHub merge queue."
echo "These builds have special environment variables and conditionals."
echo ""
echo "Checking merge queue environment variables:"
echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT = ${BUILDKITE_MERGE_QUEUE_BASE_COMMIT:-"(not set — this is a regular build)"}"
echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH = ${BUILDKITE_MERGE_QUEUE_BASE_BRANCH:-"(not set — this is a regular build)"}"
echo "  BUILDKITE_BRANCH                  = ${BUILDKITE_BRANCH:-"(not set)"}"
echo "  BUILDKITE_COMMIT                  = ${BUILDKITE_COMMIT:-"(not set)"}"
echo ""

if [ -n "${BUILDKITE_MERGE_QUEUE_BASE_COMMIT:-}" ]; then
  echo "🔀 This IS a merge queue build!"
  echo "  Base branch: $BUILDKITE_MERGE_QUEUE_BASE_BRANCH"
  echo "  Base commit: $BUILDKITE_MERGE_QUEUE_BASE_COMMIT"
  STYLE="success"
  STATUS="✅ **Merge queue build detected!**"
else
  echo "📋 This is a regular build (not a merge queue build)."
  echo "   To see merge queue behavior, push a PR through a GitHub merge queue"
  echo "   with 'Build merge queues' enabled in pipeline settings."
  STYLE="info"
  STATUS="ℹ️ Regular build — not a merge queue build."
fi

buildkite-agent annotate --style "$STYLE" --context merge-queue << ANNOTATION
## 🔀 GitHub Merge Queue Integration

**Status:** $STATUS

### How it works
1. Enable **Build merge queues** in Pipeline Settings → GitHub
2. GitHub sends \`merge_group\` webhook events when PRs enter the queue
3. Buildkite creates builds with merge queue metadata

### Conditionals available in pipeline YAML
\`\`\`yaml
steps:
  # This step only runs in merge queue builds
  - label: "Merge queue validation"
    if: build.merge_queue.base_commit != null
    command: "./validate.sh"

  # This step skips merge queue builds
  - label: "Regular CI"
    if: build.merge_queue.base_commit == null
    command: "./ci.sh"
\`\`\`

### Environment variables
| Variable | Description |
|----------|-------------|
| \`BUILDKITE_MERGE_QUEUE_BASE_COMMIT\` | Base SHA of the merge group |
| \`BUILDKITE_MERGE_QUEUE_BASE_BRANCH\` | Target branch of the queue |

### Features
- 🚫 **Auto-cancel** — cancel builds for invalidated merge groups
- 📊 **Separate listing** — merge queue builds shown separately in UI
- 🔄 **if_changed support** — conditional steps based on changed files

### Learn more
- [Merge queue tutorial](https://buildkite.com/docs/pipelines/tutorials/github-merge-queue)
- [Blog: Using GitHub merge queues](https://buildkite.com/resources/blog/github-merge-queue)
- [Changelog entry](https://buildkite.com/changelog)
ANNOTATION

echo "✅ Merge Queue demo complete"
