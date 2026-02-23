#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

SUITE_URL="https://buildkite.com/organizations/roadmap-updates/analytics/suites/roadmap-updates-demo"

echo "+++ :bar_chart: Test Engine Workflows — Monitors & Actions"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Flaky tests rot in the suite. Nobody notices until they block a release."
echo "  Engineers manually triage failures, dig through dashboards, and file"
echo "  tickets by hand — if they bother at all."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Monitors watch test health metrics (like \"passed on retry\" or transition"
echo "  counts). When thresholds are crossed, they fire alarm events. When tests"
echo "  recover, they fire recover events. These events trigger automated actions."
echo ""
echo "  Workflows are event-driven — they evaluate each time test data is"
echo "  ingested, not on a schedule."
echo ""
box \
  'Monitor: "Passed on retry" / "Transition count"' \
  '  │' \
  '  ├── ALARM  ──→  Change state + Slack + Linear' \
  '  │' \
  '  └── RECOVER ──→  Change state + Slack'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  Actions you can wire up to alarm/recover events:"
echo ""
echo "  🔀 Change test state — automatically quarantine flaky tests"
echo "  🏷️  Add/Remove labels — tag tests for triage"
echo "  💬 Slack notification — alert the owning team"
echo "  🔗 Webhook — trigger any external system"
echo "  📋 Create Linear issue — auto-file a ticket on alarm"
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  Flaky tests get caught and ticketed automatically. No manual triage."
echo "  Tests self-heal: quarantine on alarm, restore on recovery."
echo ""
echo "  Suite: $SUITE_URL"
echo "  📖 docs.buildkite.com/test-engine/workflows"

buildkite-agent annotate --style info --context test-engine-workflows << ANNOTATION
## :bar_chart: Test Engine Workflows — Monitors & Actions
\`\`\`
Monitor: "Passed on retry" / "Transition count"
    ├── 🚨 ALARM  ──→  Change state + Slack + Linear
    └── 🟢 RECOVER ──→  Change state + Slack
\`\`\`
**Actions:** Change state · Add/Remove labels · Slack · Webhook · Create Linear issue

Flaky tests get caught and ticketed automatically. Tests self-heal: quarantine on alarm, restore on recovery.
- 🔗 [Test Suite]($SUITE_URL)
- 📖 [Workflows docs](https://buildkite.com/docs/test-engine/workflows)
ANNOTATION

echo ""
echo "✅ Test Engine Workflows demo complete"
