#!/bin/bash
set -euo pipefail

SHARD="${BUILDKITE_PARALLEL_JOB:-0}"
TOTAL="${BUILDKITE_PARALLEL_JOB_COUNT:-3}"

echo "--- :jest: Test Engine — Parallel Execution with bktec"
echo ""
echo "  bktec is the Test Engine Client — it splits and distributes tests"
echo "  across parallel agents for maximum speed."
echo ""
echo "  This step runs with parallelism: $TOTAL in the pipeline YAML."
echo "  I'm shard $SHARD of $TOTAL (zero-indexed)."

echo ""
echo "--- :gear: How bktec Works"
echo ""
echo "  pipeline.yml:"
echo "    - label: 'Tests'"
echo "      command: bktec --test-cmd 'pytest'"
echo "      parallelism: 8"
echo ""
echo "  That's the whole setup. bktec handles:"
echo "    📊 Splitting tests based on historical timing data"
echo "    🔄 Distributing shards across parallel agents"
echo "    📈 Reporting results to Test Engine"

echo ""
echo "--- :new: What's New in bktec"
echo ""
echo "  v2.0.0 (Dec 2025):"
echo "    ⚡ Dynamic parallelism — auto-scale shards based on test count"
echo "    📊 Improved timing-based splitting"
echo ""
echo "  v2.1.0 (Feb 2026):"
echo "    🎯 Smarter split algorithm — better balance across shards"
echo "    🐛 Edge case fixes for very small test suites"

echo ""
echo "--- :test_tube: Simulating Test Shard $SHARD"
echo ""

TESTS=("test_auth_login" "test_auth_logout" "test_api_create" "test_api_read" "test_api_update" "test_api_delete" "test_webhook_send" "test_webhook_verify" "test_cache_hit" "test_cache_miss" "test_rate_limit" "test_pagination")

START=$((SHARD * ${#TESTS[@]} / TOTAL))
END=$(((SHARD + 1) * ${#TESTS[@]} / TOTAL))

for i in $(seq "$START" $((END - 1))); do
  TEST="${TESTS[$i]}"
  DURATION="0.$((RANDOM % 900 + 100))"
  echo "  ✅ PASS  ${TEST}  (${DURATION}s)"
  sleep 0.1
done

SHARD_COUNT=$((END - START))
echo ""
echo "  ──────────────────────────────────"
echo "  Shard $SHARD: $SHARD_COUNT tests passed ✅"

buildkite-agent annotate --style info --context "test-engine-shard-${SHARD}" << ANNOTATION
## :test_tube: Test Engine — Shard $SHARD of $TOTAL

### Quick Setup
\`\`\`yaml
# pipeline.yml
steps:
  - label: ":jest: Tests"
    command: bktec --test-cmd "pytest"
    parallelism: 8   # bktec handles the rest
\`\`\`

### Install bktec
\`\`\`bash
# macOS / Linux
curl -fsSL https://buildkite.com/install/bktec | bash

# Or via Buildkite plugin
plugins:
  - test-engine#v1.0.0
\`\`\`

### Changelog
- 🆕 [bktec v2.0.0](https://buildkite.com/changelog/171-bktec-v2-0-0) — Dynamic parallelism (Dec 7, 2025)
- 🆕 [bktec v2.1.0](https://buildkite.com/changelog/175-bktec-v2-1-0) — Improved splitting (Feb 8, 2026)
ANNOTATION

echo ""
echo "✅ Test Engine shard $SHARD complete"
