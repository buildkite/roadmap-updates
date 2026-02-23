#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :webhook: Universal Pipeline Triggers"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Connecting external tools to CI requires custom API"
echo "  integrations — every service needs its own glue code to"
echo "  trigger builds. There's no universal \"when X happens,"
echo "  run my pipeline\" mechanism."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Pipeline triggers are HTTP endpoints that create builds"
echo "  when they receive POST requests. Each trigger has a unique"
echo "  URL. Any service that can send HTTP can trigger your CI."
echo "  JSON payloads are accessible in all steps via"
echo "  buildkite-agent meta-data get buildkite:webhook."
echo ""
box \
  "PagerDuty alert  ──→  POST webhook URL  ──→  Build created" \
  "Linear issue     ──→  POST webhook URL  ──→  AI agent analyzes" \
  "GitHub event     ──→  POST webhook URL  ──→  Code review bot"
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  🔗 Three webhook types:"
echo "     Generic (any HTTP POST), GitHub (with signature"
echo "     verification), Linear (with signature verification)"
echo ""
echo "  📦 JSON payload accessible via buildkite:webhook meta-data key"
echo ""
echo "  🤖 Combine with Model Providers + SDK for full agentic CI:"
echo "     Linear issue created → trigger fires → AI agent reads"
echo "     the issue → generates a fix → opens a PR"
echo ""
box \
  'Linear issue labeled "buildkite-analyze"' \
  "  → Pipeline trigger fires" \
  "  → Handler reads webhook payload" \
  "  → AI agent analyzes codebase" \
  "  → Opens PR or posts analysis back to Linear"
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  Any tool that sends HTTP can kick off CI work. This is"
echo "  the glue between your tools and your pipelines — the"
echo "  on-ramp for agentic workflows."
echo ""
echo "  📖 docs.buildkite.com/apis/webhooks/incoming/pipeline-triggers"

buildkite-agent annotate --style info --context pipeline-triggers --scope job << 'ANNOTATION'
## :webhook: Universal Pipeline Triggers

### The Problem
> Connecting external tools to CI requires custom API integrations — every service needs its own glue code to trigger builds. There's no universal "when X happens, run my pipeline" mechanism.

### How It Works
Pipeline triggers are HTTP endpoints that create builds when they receive POST requests. Any service that can send HTTP can trigger your CI.

```
PagerDuty alert  ──→  POST webhook URL  ──→  Build created
Linear issue     ──→  POST webhook URL  ──→  AI agent analyzes
GitHub event     ──→  POST webhook URL  ──→  Code review bot
```

### What Buildkite Adds
- 🔗 **Three webhook types:** Generic (any HTTP POST), GitHub (signature verified), Linear (signature verified)
- 📦 **JSON payload** accessible via `buildkite-agent meta-data get buildkite:webhook`
- 🤖 **Combine with Model Providers + SDK** for full agentic CI:

```
Linear issue labeled "buildkite-analyze"
  → Pipeline trigger fires
  → AI agent analyzes codebase
  → Opens PR or posts analysis back to Linear
```

### The Payoff
→ Any tool that sends HTTP can kick off CI work
→ The glue between your tools and your pipelines — the on-ramp for agentic workflows

---
📖 [Pipeline Triggers docs](https://buildkite.com/docs/apis/webhooks/incoming/pipeline-triggers) · 📝 [Agentic CI examples](https://buildkite.com/resources/blog/building-ai-powered-ci-workflows-three-practical-examples)
ANNOTATION

echo ""
echo "✅ Pipeline Triggers demo complete"
