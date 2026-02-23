#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

AGENT_NAME="${BUILDKITE_AGENT_NAME:-"(not available)"}"
RETRY_COUNT="${BUILDKITE_RETRY_COUNT:-0}"
JOB_ID="${BUILDKITE_JOB_ID:-"(not available)"}"

echo "+++ :arrows_counterclockwise: Retry Agent Affinity"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Retried jobs land on random agents. If the failure was a flaky"
echo "  host, you retry on the same broken machine. If the job needs"
echo "  warm caches, you retry on a cold one. Lose-lose."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  A queue-level setting controls where retried jobs go."
echo "  Two modes, opposite trade-offs:"
echo ""
echo "  Prefer Warmest (default)     Prefer Different"
echo "  ─────────────────────────    ─────────────────────────"
echo "  Same agent, warm caches      Different agent, fresh start"
echo "  Great for: Docker layer       Great for: flaky hosts,"
echo "  cache, git checkout,          bad machine isolation,"
echo "  build artifacts               hardware issues"
echo ""
box \
  'retry:' \
  '  automatic:' \
  '    - exit_status: "*"' \
  '      limit: 2'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  ⚙️  Configured per QUEUE (self-hosted): Cluster → Queue → Agent Affinity"
echo "  🔢 Agent priority: buildkite-agent start --priority 10"
echo "     Higher-priority agents get jobs first"
echo "  ✅ Success-based preference: agents that recently completed"
echo "     jobs successfully are favored"
echo ""

echo "  ── LIVE CHECK ───────────────────────────────────────────"
echo ""
echo "  Agent: $AGENT_NAME"
echo "  Retry: #$RETRY_COUNT    Job: $JOB_ID"
if [[ "$RETRY_COUNT" -gt 0 ]]; then
  echo "  🔄 This is retry #$RETRY_COUNT — check if agent name changed."
else
  echo "  ℹ️  First attempt (retry count = 0)"
fi
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  Retries that actually fix the problem — not random roulette."
echo "  Warm caches when you want them, fresh starts when you need them."
echo ""
echo "  📖 docs.buildkite.com/agent/v3/self-hosted/prioritization"

buildkite-agent annotate --style info --context retry-affinity << ANNOTATION
## :arrows_counterclockwise: Retry Agent Affinity
\`\`\`yaml
retry:
  automatic:
    - exit_status: "*"
      limit: 2
\`\`\`
Agent: \`$AGENT_NAME\` · Retry: \`$RETRY_COUNT\`
| Prefer Warmest (default) | Prefer Different |
|--------------------------|------------------|
| Same agent, warm caches | Different agent, fresh start |
| Docker layer cache, git checkout | Flaky host isolation, hardware issues |
- 📖 [Agent Prioritization docs](https://buildkite.com/docs/agent/v3/self-hosted/prioritization)
ANNOTATION

echo ""
echo "✅ Retry Agent Affinity demo complete"
