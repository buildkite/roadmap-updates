#!/bin/bash
set -euo pipefail

echo "--- :bar_chart: Test Engine Workflows — Monitors + Actions"
echo ""
echo "  Workflows let you automate responses to test health changes."
echo "  They're event-driven — not scheduled, not polling."
echo ""
echo "  Formula:  Monitor → Event → Action(s)"

echo ""
echo "--- :mag: Monitors — Watch Your Tests"
echo ""
echo "  A monitor watches for test health changes and fires events:"
echo ""
echo "    📊 Monitor: 'Flaky test detected'"
echo "        ↓"
echo "    🚨 Alarm Event: test became flaky"
echo "        ↓"
echo "    🟢 Recover Event: test stabilized"
echo ""
echo "  Monitors evaluate continuously — you get notified the moment"
echo "  something changes, not on a schedule."

echo ""
echo "--- :zap: Actions — Respond Automatically"
echo ""
echo "  Actions fire when a monitor raises an alarm or recovers:"
echo ""
echo "    ┌──────────────────────────────────────────────────┐"
echo "    │  🔍 Monitor: Flaky Test Detected                │"
echo "    │     │                                            │"
echo "    │     ├── 🚨 ALARM                                │"
echo "    │     │     ├── 🏷️  Auto-quarantine the test      │"
echo "    │     │     ├── 💬 Slack: '#eng-quality'           │"
echo "    │     │     └── 📧 Email test owner                │"
echo "    │     │                                            │"
echo "    │     └── 🟢 RECOVER                              │"
echo "    │           ├── 🏷️  Remove quarantine              │"
echo "    │           └── 💬 Slack: 'Test stabilized'        │"
echo "    └──────────────────────────────────────────────────┘"

echo ""
echo "--- :bulb: Why This Matters"
echo ""
echo "  Before Workflows:"
echo "    😤 Flaky test breaks main → team ignores all failures → trust erodes"
echo ""
echo "  After Workflows:"
echo "    🎯 Flaky test detected → auto-quarantined → owner notified → fixed"
echo "    📉 Zero human intervention for known-flaky isolation"

echo ""
echo "--- :white_check_mark: Key Takeaways"
echo ""
echo "  ✅ Event-driven (alarm/recover), not scheduled"
echo "  ✅ Auto-quarantine flaky tests immediately"
echo "  ✅ Notify via Slack, email, or webhook"
echo "  ✅ No code changes needed — works with existing test suites"

buildkite-agent annotate --style info --context test-engine-workflows << 'ANNOTATION'
## :bar_chart: Test Engine Workflows — Reference Card

### How It Works
```
Monitor: "Flaky Test Detected"
    │
    ├── 🚨 ALARM ──→ Auto-quarantine + Slack notification
    │
    └── 🟢 RECOVER ──→ Remove quarantine + Slack update
```

### Available Actions
| Action | Trigger | Description |
|--------|---------|-------------|
| **Auto-quarantine** | Alarm | Isolate flaky test from blocking builds |
| **Slack notification** | Alarm / Recover | Post to a channel |
| **Email** | Alarm | Notify test owner |
| **Webhook** | Alarm / Recover | Call an external service |

### Links
- 📖 [Test Engine Workflows docs](https://buildkite.com/docs/test-engine/workflows)
- 📝 [Blog: Introducing Test Engine Workflows](https://buildkite.com/resources/blog/introducing-test-engine-workflows)
ANNOTATION

echo ""
echo "✅ Test Engine Workflows demo complete"
