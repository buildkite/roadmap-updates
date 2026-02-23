#!/bin/bash
set -euo pipefail

echo "--- :arrows_counterclockwise: Retry Agent Affinity Demo"
echo ""
echo "Agent:       ${BUILDKITE_AGENT_NAME:-"(not set)"}"
echo "Retry count: ${BUILDKITE_RETRY_COUNT:-0}"
echo "Job ID:      ${BUILDKITE_JOB_ID:-"(not set)"}"
echo ""

RETRY_COUNT=${BUILDKITE_RETRY_COUNT:-0}

if [ "$RETRY_COUNT" -eq 0 ]; then
  echo "This is the first attempt."
  echo "Agent '${BUILDKITE_AGENT_NAME:-unknown}' is running this job."
elif [ "$RETRY_COUNT" -eq 1 ]; then
  echo "This is retry attempt #1."
  echo "Agent '${BUILDKITE_AGENT_NAME:-unknown}' is running this retry."
  echo ""
  echo "With 'Prefer Different Agent' affinity, Buildkite would try to"
  echo "schedule this on a DIFFERENT agent than the first attempt."
else
  echo "This is retry attempt #${RETRY_COUNT}."
  echo "Agent '${BUILDKITE_AGENT_NAME:-unknown}' is running this retry."
fi

echo ""
echo "--- :gear: Agent Prioritization"
echo ""
echo "Buildkite assigns jobs based on:"
echo "  1. Agent priority (higher value = first to receive jobs)"
echo "  2. Success history (most recently successful agent preferred)"
echo "  3. Tag targeting (queue, capabilities)"
echo ""

buildkite-agent annotate --style info --context retry-affinity << 'ANNOTATION'
## 🔄 Retry Agent Affinity

**Current attempt:** #RETRY_PLACEHOLDER

### Affinity modes (configured per queue)

| Mode | Behavior |
|------|----------|
| **Prefer Warmest Agent** (default) | Retry on the agent that most recently finished a job |
| **Prefer Different Agent** | Retry on a *different* agent if available — useful for flaky infrastructure |

### How to configure
Set retry agent affinity on a **self-hosted queue** via:
- Buildkite UI → Agents → Cluster → Queue → Settings
- REST API when updating the queue

### Automatic retry in pipeline YAML
```yaml
steps:
  - label: "Run tests"
    command: "./test.sh"
    retry:
      automatic:
        - exit_status: "*"
          limit: 2
```

### Agent prioritization
```bash
# High-performance agents get jobs first
buildkite-agent start --priority 16 --tags "queue=ci,perf=high"

# Standard agents as fallback
buildkite-agent start --priority 8 --tags "queue=ci,perf=standard"
```

### Learn more
- [Agent prioritization docs](https://buildkite.com/docs/agent/v3/self-hosted/prioritization)
- [Retry Agent Affinity changelog](https://buildkite.com/changelog)
ANNOTATION

# Replace the placeholder with actual retry count
RETRY_COUNT=${BUILDKITE_RETRY_COUNT:-0}

echo "✅ Retry Agent Affinity demo complete (attempt #${RETRY_COUNT})"
