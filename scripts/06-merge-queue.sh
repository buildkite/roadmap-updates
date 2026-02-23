#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :merge: GitHub Merge Queue Support"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  PRs pass CI individually, then break main when merged together. The faster"
echo "  your team ships, the worse this gets — engineers waste time rebasing,"
echo "  re-running CI, and playing \"merge chicken.\""
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  GitHub batches PRs into \"merge groups.\" Each group gets a speculative"
echo "  commit — the exact code that main will look like if the group merges."
echo "  CI runs against reality, not hope."
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  First-class merge queue builds — not a branch hack. Dedicated UI section,"
echo "  unique env vars, native conditionals."
echo ""
echo "  Auto-cancel invalidated builds — queue reshuffles? Stale builds die"
echo "  immediately. No wasted compute."
echo ""
echo "  Conditional steps — run heavy checks only in the queue:"
echo ""
box \
  'if: build.merge_queue.base_commit != null' \
  'command: run-full-integration-suite.sh'
echo ""
echo "  PR builds stay fast. Merge queue builds run the full suite."
echo ""
echo "  Smart file detection with if_changed — only test what the PR actually"
echo "  touched, even inside the queue."
echo ""

echo "  ── LIVE CHECK ───────────────────────────────────────────"
echo ""

MQ_BASE_BRANCH="${BUILDKITE_MERGE_QUEUE_BASE_BRANCH:-""}"
MQ_BASE_COMMIT="${BUILDKITE_MERGE_QUEUE_BASE_COMMIT:-""}"

if [[ -n "$MQ_BASE_BRANCH" ]]; then
  echo "  🟢 This IS a merge queue build!"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH  = $MQ_BASE_BRANCH"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT  = $MQ_BASE_COMMIT"
else
  echo "  ℹ️  Regular build (not merge queue)"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_BRANCH  = (not set)"
  echo "  BUILDKITE_MERGE_QUEUE_BASE_COMMIT  = (not set)"
fi
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  main stays green. Engineers stop babysitting merges. CI spend goes down"
echo "  (redundant builds auto-killed)."
echo ""
echo "  📖 docs.buildkite.com/pipelines/tutorials/github-merge-queue"

buildkite-agent annotate --style info --context merge-queue --scope job << 'ANNOTATION'
## :merge: GitHub Merge Queue Support

### The Problem
> PRs pass CI individually, then break main when merged together. The faster your team ships, the worse this gets — engineers waste time rebasing, re-running CI, and playing "merge chicken."

### How It Works
GitHub batches PRs into "merge groups." Each group gets a speculative commit — the exact code that main will look like if the group merges. CI runs against reality, not hope.

### What Buildkite Adds
- **First-class merge queue builds** — not a branch hack. Dedicated UI section, unique env vars, native conditionals.
- **Auto-cancel invalidated builds** — queue reshuffles? Stale builds die immediately. No wasted compute.
- **Conditional steps** — run heavy checks only in the queue:

```yaml
steps:
  - label: "Full integration suite"
    if: build.merge_queue.base_commit != null
    command: run-full-integration-suite.sh
```

- **Smart `if_changed` detection** — only test what the PR actually touched, even inside the queue.

### The Payoff
→ main stays green. Engineers stop babysitting merges.
→ CI spend goes down — redundant builds auto-killed.

---
📖 [Merge Queue tutorial](https://buildkite.com/docs/pipelines/tutorials/github-merge-queue)
ANNOTATION

echo ""
echo "✅ Merge Queue demo complete"
