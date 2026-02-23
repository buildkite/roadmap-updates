#!/bin/bash
set -euo pipefail

echo "+++ :buildkite: Model Providers — LLM Access for Agents"
echo ""
echo "  Buildkite agents call LLMs directly — no separate API keys needed."
echo ""
echo "  ┌──────────────────────────────────────────────────────────────────┐"
echo '  │  export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"  │'
echo '  │  export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"       │'
echo "  └──────────────────────────────────────────────────────────────────┘"
echo ""
echo "  curl example:"
echo '    curl -X POST "$BUILDKITE_AGENT_ENDPOINT/ai/anthropic/v1/messages" \'
echo '      -H "x-api-key: $BUILDKITE_AGENT_ACCESS_TOKEN" \'
echo "      -d '{\"model\": \"claude-sonnet-4-5\", \"max_tokens\": 1000, \"messages\": [...]}'"
echo ""

ENDPOINT="${BUILDKITE_AGENT_ENDPOINT:-"(not set)"}"
TOKEN="${BUILDKITE_AGENT_ACCESS_TOKEN:-""}"
if [[ -n "$TOKEN" ]]; then
  MASKED="${TOKEN:0:8}...$(echo "$TOKEN" | tail -c 5)"
  TOKEN_STATUS="✅ Set ($MASKED)"
else
  TOKEN_STATUS="⚠️  Not set — enable in org settings"
fi

echo "  Live check:"
echo "  BUILDKITE_AGENT_ENDPOINT      = $ENDPOINT"
echo "  BUILDKITE_AGENT_ACCESS_TOKEN  = $TOKEN_STATUS"
echo ""
echo "  🟢 Hosted Token — zero config    🔑 BYOT — your keys, BK tracks usage"
echo "  📖 docs.buildkite.com/apis/model-providers"
echo "  📝 Blog: What AI is teaching us about CI"

buildkite-agent annotate --style info --context model-providers << 'ANNOTATION'
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
