#!/bin/bash
set -euo pipefail

AGENT_NAME="${BUILDKITE_AGENT_NAME:-"(not available)"}"
RETRY_COUNT="${BUILDKITE_RETRY_COUNT:-0}"
JOB_ID="${BUILDKITE_JOB_ID:-"(not available)"}"

echo "+++ :arrows_counterclockwise: Retry Agent Affinity"
echo ""
echo "  Control WHICH agent picks up a retried job."
echo ""
echo "  Agent: $AGENT_NAME"
echo "  Retry: #$RETRY_COUNT    Job: $JOB_ID"
echo ""
if [[ "$RETRY_COUNT" -gt 0 ]]; then
  echo "  🔄 This is retry #$RETRY_COUNT — check if agent name changed."
else
  echo "  ℹ️  First attempt (retry count = 0)"
fi
echo ""
echo "  ┌───────────────────────────────────────────┐"
echo "  │  retry:                                   │"
echo "  │    automatic:                             │"
echo '  │      - exit_status: "*"                   │'
echo "  │        limit: 2                           │"
echo "  └───────────────────────────────────────────┘"
echo ""
echo "  Prefer Warmest (default)     Prefer Different"
echo "  ─────────────────────────    ─────────────────────────"
echo "  Retry on same agent          Retry on different agent"
echo "  Docker cache, build          Avoid flaky hosts,"
echo "  artifacts, checkout          bad machine isolation"
echo ""
echo "  ⚙️  Per QUEUE, not per step: Cluster → Queue → Agent Affinity"
echo "  🔢 Agent priority: buildkite-agent start --priority 10"
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
| Same agent, warm caches | Different agent, avoid bad hosts |
- 📖 [Agent Prioritization docs](https://buildkite.com/docs/agent/v3/self-hosted/prioritization)
ANNOTATION

echo ""
echo "✅ Retry Agent Affinity demo complete"
