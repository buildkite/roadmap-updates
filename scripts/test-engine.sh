#!/bin/bash
set -euo pipefail

echo "--- :jest: Test Engine + bktec Demo (parallel job ${BUILDKITE_PARALLEL_JOB:-0} of ${BUILDKITE_PARALLEL_JOB_COUNT:-1})"
echo ""
echo "This step demonstrates Test Engine integration with bktec (Test Engine Client)."
echo ""
echo "Current parallel job index: ${BUILDKITE_PARALLEL_JOB:-0}"
echo "Total parallel jobs:        ${BUILDKITE_PARALLEL_JOB_COUNT:-1}"
echo ""

echo "--- :test_tube: Simulating test execution with bktec"
echo ""
echo "In a real pipeline, you would run:"
echo ""
echo '  # Install bktec'
echo '  curl -fsSL https://github.com/buildkite/test-engine-client/releases/latest/download/bktec-linux-amd64 -o bktec'
echo '  chmod +x bktec'
echo ""
echo '  # Run tests with intelligent splitting and dynamic parallelism (bktec v2.0+)'
echo '  ./bktec --test-cmd "pytest" --parallelism $BUILDKITE_PARALLEL_JOB_COUNT --job-index $BUILDKITE_PARALLEL_JOB'
echo ""
echo "bktec v2.0 introduced dynamic parallelism — automatically adjusting the"
echo "number of parallel jobs based on test suite size and historical run times."
echo ""
echo "bktec v2.1 added further improvements to splitting accuracy."
echo ""

# Simulate some test output
TESTS=("test_user_auth" "test_api_endpoints" "test_data_validation" "test_caching" "test_notifications" "test_search")
JOB_INDEX=${BUILDKITE_PARALLEL_JOB:-0}
TOTAL=${BUILDKITE_PARALLEL_JOB_COUNT:-1}

echo "--- :white_check_mark: Running test shard ${JOB_INDEX}"
for i in "${!TESTS[@]}"; do
  if (( i % TOTAL == JOB_INDEX )); then
    echo "  PASS  ${TESTS[$i]} ($(( RANDOM % 500 + 100 ))ms)"
  fi
done
echo ""
echo "All tests passed in shard ${JOB_INDEX} ✅"
