#!/bin/bash
set -euo pipefail

AGENT_NAME="${BUILDKITE_AGENT_NAME:-"(not available)"}"
RETRY_COUNT="${BUILDKITE_RETRY_COUNT:-0}"
JOB_ID="${BUILDKITE_JOB_ID:-"(not available)"}"

echo "--- :arrows_counterclockwise: Retry Agent Affinity"
echo ""
echo "  When a job retries, Buildkite can control WHICH agent picks it up."
echo "  Two modes: prefer the same agent (warm caches) or a different one (avoid bad hosts)."

echo ""
echo "--- :mag: Current Job Context"
echo ""
echo "  BUILDKITE_AGENT_NAME   = $AGENT_NAME"
echo "  BUILDKITE_RETRY_COUNT  = $RETRY_COUNT"
echo "  BUILDKITE_JOB_ID       = $JOB_ID"
echo ""
if [[ "$RETRY_COUNT" -gt 0 ]]; then
  echo "  🔄 This is retry #$RETRY_COUNT!"
  echo "  Check if the agent name changed from the previous attempt."
else
  echo "  ℹ️  This is the first attempt (retry count = 0)"
fi

echo ""
echo "--- :yaml: Retry Config in pipeline.yml"
echo ""
echo "  This step uses automatic retry:"
echo ""
echo '    steps:'
echo '      - label: "Retry demo"'
echo '        command: scripts/10-retry-affinity.sh'
echo '        retry:'
echo '          automatic:'
echo '            - exit_status: "*"'
echo '              limit: 2'
echo ""
echo "  On any non-zero exit, Buildkite retries up to 2 times."

echo ""
echo "--- :dart: Two Affinity Modes"
echo ""
echo "    Mode                        When to Use"
echo "    ────────────────────────    ──────────────────────────────────"
echo "    Prefer Warmest Agent        Docker layer cache, build artifacts,"
echo "    (default)                   checkout cache — reuse warm state"
echo ""
echo "    Prefer Different Agent      Flaky infra, bad host isolation —"
echo "                                try a fresh machine"
echo ""
echo "  ⚙️  Configured per QUEUE, not per step."
echo "  Set in: Cluster → Queue → Agent Affinity"

echo ""
echo "--- :chart_with_upwards_trend: Agent Prioritization"
echo ""
echo "  Control which agents get jobs first:"
echo ""
echo '    # Start agent with higher priority'
echo '    buildkite-agent start --priority 10'
echo ""
echo "  Higher priority = gets jobs first."
echo "  Useful for: faster machines, spot vs on-demand, GPU agents."

echo ""
echo "--- :white_check_mark: Summary"
echo ""
echo "  ✅ Retry affinity is per-queue, not per-step"
echo "  ✅ Default: prefer warmest agent (cache reuse)"
echo "  ✅ Alternative: prefer different agent (avoid bad hosts)"
echo "  ✅ Agent --priority controls job assignment order"

buildkite-agent annotate --style info --context retry-affinity << ANNOTATION
## :arrows_counterclockwise: Retry Agent Affinity — Reference Card

### Retry Config
\`\`\`yaml
steps:
  - label: "Build & Test"
    command: make test
    retry:
      automatic:
        - exit_status: "*"
          limit: 2
        - exit_status: -1    # agent lost
          limit: 3
\`\`\`

### Affinity Modes (per queue)
| Mode | Behavior | Best For |
|------|----------|----------|
| **Prefer Warmest** (default) | Retry on same agent | Docker cache, build artifacts |
| **Prefer Different** | Retry on different agent | Avoiding flaky hosts |

### Current Job
| Variable | Value |
|----------|-------|
| Agent | \`$AGENT_NAME\` |
| Retry count | \`$RETRY_COUNT\` |
| Job ID | \`$JOB_ID\` |

### Agent Priority
\`\`\`bash
# Higher priority agents get jobs first
buildkite-agent start --priority 10
\`\`\`

### Links
- 📖 [Agent Prioritization docs](https://buildkite.com/docs/agent/v3/self-hosted/prioritization)
ANNOTATION

echo ""
echo "✅ Retry Agent Affinity demo complete"
