#!/bin/bash
set -euo pipefail

SUITE_URL="https://buildkite.com/organizations/roadmap-updates/analytics/suites/roadmap-updates-demo"

echo "+++ :bar_chart: Test Engine Workflows — Auto-Quarantine"
echo ""
echo "  Event-driven automation for test health: Monitor → Event → Action."
echo ""
echo "  ┌──────────────────────────────────────────────────────────┐"
echo "  │  🔍 Monitor: Flaky Test Detected                       │"
echo "  │     │                                                    │"
echo "  │     ├── 🚨 ALARM ──→ Auto-quarantine + Slack #eng-qa   │"
echo "  │     │                                                    │"
echo "  │     └── 🟢 RECOVER ──→ Un-quarantine + Slack update    │"
echo "  └──────────────────────────────────────────────────────────┘"
echo ""
echo "  Actions:          Triggers:"
echo "  🏷️  Quarantine     🚨 Alarm / 🟢 Recover"
echo "  💬 Slack notify   🚨 Alarm / 🟢 Recover"
echo "  📧 Email owner    🚨 Alarm"
echo "  🔗 Webhook        🚨 Alarm / 🟢 Recover"
echo ""
echo "  Suite: $SUITE_URL"
echo "  📖 docs.buildkite.com/test-engine/workflows"
echo "  📝 Blog: Introducing Test Engine Workflows"

buildkite-agent annotate --style info --context test-engine-workflows << ANNOTATION
## :bar_chart: Test Engine Workflows
\`\`\`
Monitor: "Flaky Test Detected"
    ├── 🚨 ALARM ──→ Auto-quarantine + Slack
    └── 🟢 RECOVER ──→ Un-quarantine + Slack
\`\`\`
- 🔗 [Test Suite]($SUITE_URL)
- 📖 [Workflows docs](https://buildkite.com/docs/test-engine/workflows)
- 📝 [Blog: Introducing Workflows](https://buildkite.com/resources/blog/introducing-test-engine-workflows)
ANNOTATION

echo ""
echo "✅ Test Engine Workflows demo complete"
