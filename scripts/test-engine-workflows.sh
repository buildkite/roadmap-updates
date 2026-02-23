#!/bin/bash
set -euo pipefail

echo "--- :bar_chart: Test Engine Workflows Overview"
echo ""
echo "Test Engine Workflows let you define automated responses to test health signals."
echo ""
echo "A workflow connects:"
echo "  Monitor (observes test behavior) → Actions (automated responses)"
echo ""
echo "Monitors detect:"
echo "  • Flaky tests (pass + fail on the same commit)"
echo "  • Transition count thresholds exceeded"
echo "  • Probabilistic flakiness scores"
echo ""
echo "Actions can:"
echo "  • Change a test's state (e.g., quarantine flaky tests)"
echo "  • Apply labels to tests"
echo "  • Send Slack notifications"
echo "  • Trigger external webhooks"
echo ""

buildkite-agent annotate --style info --context test-engine-workflows << 'ANNOTATION'
## 🧪 Test Engine Workflows

**Workflows** surface qualitative information about your tests and automate responses.

### How they work
```
Monitor (watches all tests) → Alarm Event → Actions (automated response)
                            → Recover Event → Actions (undo response)
```

### Monitor types
| Signal | Description |
|--------|-------------|
| **Flakiness** | Test reports both pass and fail on the same commit SHA |
| **Transition count** | Score tracking how often a test flips between pass/fail |
| **Probabilistic** | Statistical flakiness probability exceeding a threshold |

### Available actions
- 🏷️ **Label tests** — automatically tag flaky tests
- 🔇 **Quarantine** — remove unreliable tests from blocking CI
- 💬 **Slack notifications** — alert teams when tests become flaky
- 🔗 **Webhooks** — trigger external systems

### Key features
- **Event-driven** — evaluates on every test data ingestion, not on a schedule
- **Hysteretic recovery** — recover events only fire after a prior alarm
- **Rate limited** — 500 events/minute per workflow monitor
- **Tag filters** — scope workflows to specific test subsets

### bktec (Test Engine Client)
- **v2.0.0** — Dynamic parallelism: auto-adjusts parallel job count
- **v2.1.0** — Improved test splitting accuracy

### Learn more
- [Workflows docs](https://buildkite.com/docs/test-engine/workflows)
- [Blog: Introducing Test Engine Workflows](https://buildkite.com/resources/blog/introducing-test-engine-workflows)
- [New Test Monitor changelog](https://buildkite.com/changelog)
ANNOTATION

echo "✅ Test Engine Workflows demo complete"
