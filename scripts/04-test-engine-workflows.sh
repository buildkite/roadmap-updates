#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

SUITE_URL="https://buildkite.com/organizations/roadmap-updates/analytics/suites/roadmap-updates-demo"
IMG_URL="https://buildkite.com/docs/assets/alarm-and-recovery-light-DZI9FFG6.png"

echo "+++ :bar_chart: Test Engine Workflows — Monitors & Actions"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Flaky tests rot in the suite. Nobody notices until they"
echo "  block a release. Engineers manually triage failures, dig"
echo "  through dashboards, and file tickets by hand."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Workflows are event-driven — they evaluate each time new"
echo "  test data is ingested. A monitor watches test health and"
echo "  fires alarm/recover events that trigger automated actions."
echo ""
printf '\033]1338;url='"'"'%s'"'"';alt='"'"'Workflow: Monitor → Alarm → Recover'"'"'\a\n' "$IMG_URL"
echo ""

echo "  ── MONITORS ───────────────────────────────────────────────"
echo ""
box \
  "Transition Count          Track pass/fail flips over a window" \
  "  P F P F P → score 0.8   high score = flaky test" \
  "" \
  "Passed on Retry           Same commit, pass + fail = flaky" \
  "  Alarm fires immediately, recovers after 7d / 100 runs" \
  "" \
  "Probabilistic (Ent)       Meta's Bayesian model: predicts" \
  "                          probability of flaking next run" \
  "" \
  "New Test (Beta)           Fires on first-ever execution"
echo ""

echo "  ── ACTIONS ────────────────────────────────────────────────"
echo ""
box \
  "         🚨 ALARM                    ✅ RECOVER" \
  "" \
  "  🔇 Change state → muted     ▶ Change state → enabled" \
  "  🏷️  Add label \"flaky\"        🏷️  Remove label \"flaky\"" \
  "  💬 Slack → #test-health      💬 Slack → #test-health" \
  "  🔗 Webhook → PagerDuty" \
  "  📋 Create Linear issue"
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  Flaky tests get caught and quarantined automatically."
echo "  When they stabilize, they re-enable themselves. No manual"
echo "  triage. Tests self-heal: mute on alarm, restore on recover."
echo ""
echo "  🔗 Suite: $SUITE_URL"
echo "  📖 docs.buildkite.com/test-engine/workflows"

buildkite-agent annotate --style info --context test-engine-workflows --scope job << ANNOTATION
## :bar_chart: Test Engine Workflows — Monitors & Actions

### The Problem
> Flaky tests rot in the suite. Nobody notices until they block a release. Engineers manually triage failures, dig through dashboards, and file tickets by hand.

### How It Works
Workflows are event-driven — they evaluate each time new test data is ingested. A monitor watches test health and fires alarm/recover events that trigger automated actions.

\`\`\`
Monitor: "Passed on retry" / "Transition count"
    ├── 🚨 ALARM  ──→  Mute + Label + Slack + Linear
    └── 🟢 RECOVER ──→  Enable + Remove label + Slack
\`\`\`

### Monitors

| Monitor | Description |
|---------|-------------|
| **Transition Count** | Track pass/fail flips over a window. High score = flaky. |
| **Passed on Retry** | Same commit, pass + fail = flaky. Alarm fires immediately. |
| **Probabilistic** (Ent) | Meta's Bayesian model: predicts probability of flaking next run. |
| **New Test** (Beta) | Fires on first-ever execution. |

### Actions

| 🚨 Alarm | ✅ Recover |
|----------|-----------|
| 🔇 Change state → muted | ▶ Change state → enabled |
| 🏷️ Add label "flaky" | 🏷️ Remove label "flaky" |
| 💬 Slack → #test-health | 💬 Slack → #test-health |
| 🔗 Webhook → PagerDuty | |
| 📋 Create Linear issue | |

### The Payoff
→ Flaky tests get caught and quarantined automatically
→ When they stabilize, they re-enable themselves — no manual triage
→ Tests self-heal: mute on alarm, restore on recover

---
🔗 [Test Suite]($SUITE_URL) · 📖 [Workflows docs](https://buildkite.com/docs/test-engine/workflows) · 📖 [Monitors](https://buildkite.com/docs/test-engine/workflows/monitors) · [Actions](https://buildkite.com/docs/test-engine/workflows/actions)
ANNOTATION

echo ""
echo "✅ Test Engine Workflows demo complete"
