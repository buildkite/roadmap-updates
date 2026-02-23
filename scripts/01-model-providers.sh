#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :buildkite: Model Providers — Proxied LLM Access for CI"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Every team wanting AI in CI needs API keys — distributed"
echo "  per-pipeline, tracked in spreadsheets, rotated manually."
echo "  No visibility into spend."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Buildkite proxies LLM calls through the agent. Jobs call"
echo "  Claude via the agent endpoint — no API keys to distribute."
echo ""
box \
  'export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"' \
  'export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"' \
  'echo "Summarize this log" | claude -p'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  🟢 Hosted Token (Pro/Enterprise) — zero config, Buildkite manages the key"
echo "  🔑 Bring Your Own Token — your keys, Buildkite tracks usage"
echo "  📊 Centralized usage monitoring across all pipelines"
echo "     Settings → Usage → Model Providers"
echo "  🔌 Currently supports Anthropic (Claude) models"
echo ""

echo "  ── LIVE CHECK ───────────────────────────────────────────"
echo ""
ENDPOINT="${BUILDKITE_AGENT_ENDPOINT:-"(not set)"}"
TOKEN="${BUILDKITE_AGENT_ACCESS_TOKEN:-""}"
if [[ -n "$TOKEN" ]]; then
  MASKED="${TOKEN:0:8}...$(echo "$TOKEN" | tail -c 5)"
  TOKEN_STATUS="✅ Set ($MASKED)"
else
  TOKEN_STATUS="⚠️  Not set — enable in org settings"
fi
echo "  BUILDKITE_AGENT_ENDPOINT      = $ENDPOINT"
echo "  BUILDKITE_AGENT_ACCESS_TOKEN  = $TOKEN_STATUS"
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  AI in CI without key sprawl. One config for the whole org."
echo "  Centralized cost tracking per pipeline."
echo ""
echo "  📖 docs.buildkite.com/apis/model-providers"

buildkite-agent annotate --style info --context model-providers --scope job << 'ANNOTATION'
## :buildkite: Model Providers
```bash
export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"
export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"
echo "Summarize this log" | claude -p
```
- 📖 [Model Providers docs](https://buildkite.com/docs/apis/model-providers)
- 📝 [What AI is teaching us about CI](https://buildkite.com/resources/blog/what-ai-is-teaching-us-about-ci)
- 📝 [Agentic CI — Three practical examples](https://buildkite.com/resources/blog/building-ai-powered-ci-workflows-three-practical-examples)
ANNOTATION

echo ""
echo "✅ Model Providers demo complete"
