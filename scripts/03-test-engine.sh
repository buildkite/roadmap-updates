#!/bin/bash
set -euo pipefail

SHARD="${BUILDKITE_PARALLEL_JOB:-0}"
TOTAL="${BUILDKITE_PARALLEL_JOB_COUNT:-3}"

echo "+++ :jest: Test Engine — Parallel with bktec"
echo ""
echo "  bktec splits and distributes tests across parallel agents."
echo "  Shard $SHARD of $TOTAL (zero-indexed)."
echo ""
echo "  ┌───────────────────────────────────────────┐"
echo '  │  steps:                                   │'
echo '  │    - label: "Tests"                       │'
echo '  │      command: bktec --test-cmd "pytest"   │'
echo "  │      parallelism: 8                       │"
echo "  └───────────────────────────────────────────┘"
echo ""
echo "  📊 Timing-based split   🔄 Auto-distribute   📈 Report to Test Engine"
echo ""

TESTS=("test_auth_login" "test_auth_logout" "test_api_create" "test_api_read" "test_api_update" "test_api_delete" "test_webhook_send" "test_webhook_verify" "test_cache_hit" "test_cache_miss" "test_rate_limit" "test_pagination")
SCOPES=("Auth" "Auth" "API" "API" "API" "API" "Webhook" "Webhook" "Cache" "Cache" "RateLimit" "Pagination")
FILES=("tests/auth.sh" "tests/auth.sh" "tests/api.sh" "tests/api.sh" "tests/api.sh" "tests/api.sh" "tests/webhook.sh" "tests/webhook.sh" "tests/cache.sh" "tests/cache.sh" "tests/rate_limit.sh" "tests/pagination.sh")

START=$((SHARD * ${#TESTS[@]} / TOTAL))
END=$(((SHARD + 1) * ${#TESTS[@]} / TOTAL))

RUN_KEY="${BUILDKITE_BUILD_ID:-local-$(date +%s)}"
COMMIT="${BUILDKITE_COMMIT:-$(git rev-parse HEAD 2>/dev/null || echo 'abc123')}"
BRANCH="${BUILDKITE_BRANCH:-main}"
BUILD_URL="${BUILDKITE_BUILD_URL:-}"
BUILD_NUMBER="${BUILDKITE_BUILD_NUMBER:-0}"
START_TIME=$(python3 -c "import time; print(time.monotonic())")

JSON_RESULTS="["
FIRST=true

echo "  Running tests:"
for i in $(seq "$START" $((END - 1))); do
  TEST="${TESTS[$i]}"
  SCOPE="${SCOPES[$i]}"
  FILE="${FILES[$i]}"
  DURATION="0.$((RANDOM % 900 + 100))"
  UUID=$(python3 -c "import uuid; print(uuid.uuid4())")
  MONO_START=$(python3 -c "import time; print(time.monotonic())")

  RESULT="passed"
  FAILURE_REASON=""
  if [[ "$TEST" == "test_cache_miss" ]] && (( RANDOM % 100 < 30 )); then
    RESULT="failed"
    FAILURE_REASON="Expected cache miss but got stale hit (TTL race condition)"
    echo "  ❌ FAIL  ${TEST}  (${DURATION}s) — flaky!"
  else
    echo "  ✅ PASS  ${TEST}  (${DURATION}s)"
  fi

  sleep 0.1
  MONO_END=$(python3 -c "import time; print(time.monotonic())")

  if [ "$FIRST" = true ]; then
    FIRST=false
  else
    JSON_RESULTS+=","
  fi

  if [ "$RESULT" = "failed" ]; then
    JSON_RESULTS+=$(cat <<TESTJSON
{
  "id": "$UUID",
  "scope": "$SCOPE",
  "name": "$TEST",
  "location": "./$FILE:$((i * 10 + 1))",
  "file_name": "./$FILE",
  "result": "$RESULT",
  "failure_reason": "$FAILURE_REASON",
  "failure_expanded": [{"expanded": ["  expected: cache miss", "       got: stale cache hit", "", "  Cache TTL expired but value not evicted"], "backtrace": ["./$FILE:$((i * 10 + 3))"]}],
  "history": {
    "start_at": $MONO_START,
    "end_at": $MONO_END,
    "duration": $DURATION
  }
}
TESTJSON
)
  else
    JSON_RESULTS+=$(cat <<TESTJSON
{
  "id": "$UUID",
  "scope": "$SCOPE",
  "name": "$TEST",
  "location": "./$FILE:$((i * 10 + 1))",
  "file_name": "./$FILE",
  "result": "$RESULT",
  "history": {
    "start_at": $MONO_START,
    "end_at": $MONO_END,
    "duration": $DURATION
  }
}
TESTJSON
)
  fi
done

JSON_RESULTS+="]"

SHARD_COUNT=$((END - START))
echo ""
echo "  ──────────────────────────────────"
echo "  Shard $SHARD: $SHARD_COUNT tests executed"

RESULTS_FILE="/tmp/test-results-shard-${SHARD}.json"
echo "$JSON_RESULTS" > "$RESULTS_FILE"

echo ""
echo "  Uploading results to Test Engine..."

if [ -n "${BUILDKITE_ANALYTICS_TOKEN:-}" ]; then
  UPLOAD_RESPONSE=$(curl -s -X POST \
    -H "Authorization: Token token=\"${BUILDKITE_ANALYTICS_TOKEN}\"" \
    -F "format=json" \
    -F "data=@${RESULTS_FILE}" \
    -F "run_env[CI]=buildkite" \
    -F "run_env[key]=${RUN_KEY}" \
    -F "run_env[number]=${BUILD_NUMBER}" \
    -F "run_env[branch]=${BRANCH}" \
    -F "run_env[commit_sha]=${COMMIT}" \
    -F "run_env[url]=${BUILD_URL}" \
    -F "run_env[message]=Roadmap demo build #${BUILD_NUMBER} shard ${SHARD}" \
    https://analytics-api.buildkite.com/v1/uploads 2>&1) || true

  echo "  Upload response: $UPLOAD_RESPONSE"
  echo "  ✅ Results uploaded (shard $SHARD)"
else
  echo "  ⚠️  BUILDKITE_ANALYTICS_TOKEN not set — skipping upload"
fi

buildkite-agent annotate --style info --context "test-engine-shard-${SHARD}" << ANNOTATION
## :test_tube: Test Engine — Shard $SHARD/$TOTAL
\`\`\`yaml
steps:
  - label: "Tests"
    command: bktec --test-cmd "pytest"
    parallelism: 8
\`\`\`
- 🆕 [bktec v2.0.0](https://buildkite.com/changelog/171-bktec-v2-0-0) — Dynamic parallelism
- 🆕 [bktec v2.1.0](https://buildkite.com/changelog/175-bktec-v2-1-0) — Improved splitting
ANNOTATION

echo ""
echo "✅ Test Engine shard $SHARD complete"
