#!/bin/bash
set -euo pipefail

echo "--- :buildkite: Model Providers — LLM Access for Your Agents"
echo ""
echo "  Model Providers let Buildkite agents call LLMs (Claude, GPT, etc.)"
echo "  directly — no separate API key management needed."
echo ""
echo "  Two auth modes:"
echo "    🟢 Buildkite Hosted Token — zero config, works out of the box"
echo "    🔑 Bring Your Own Token   — your API keys, Buildkite tracks usage"

echo ""
echo "--- :anthropic: Using Claude via Model Providers"
echo ""
echo "  The magic is two env vars that turn Buildkite into your LLM proxy:"
echo ""
echo '    export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"'
echo '    export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"'
echo ""
echo "  Then use any Anthropic-compatible tool normally:"
echo ""
echo '    echo "Summarize this log" | claude -p'
echo '    python -c "import anthropic; client = anthropic.Client()"'
echo ""
echo "  That's it. Buildkite proxies the request and tracks usage."

echo ""
echo "--- :mag: Live Environment Check"
echo ""
ENDPOINT="${BUILDKITE_AGENT_ENDPOINT:-"(not set)"}"
TOKEN="${BUILDKITE_AGENT_ACCESS_TOKEN:-""}"
if [[ -n "$TOKEN" ]]; then
  MASKED="${TOKEN:0:8}...$(echo "$TOKEN" | tail -c 5)"
  TOKEN_STATUS="✅ Set ($MASKED)"
else
  TOKEN_STATUS="⚠️  Not set — enable Model Providers in org settings"
fi
echo "  BUILDKITE_AGENT_ENDPOINT      = $ENDPOINT"
echo "  BUILDKITE_AGENT_ACCESS_TOKEN  = $TOKEN_STATUS"

echo ""
echo "--- :white_check_mark: Summary"
echo ""
echo "  ✅ No separate API key rotation"
echo "  ✅ Usage tracking & cost attribution per pipeline"
echo "  ✅ Works with Claude Code, Anthropic SDK, OpenAI SDK"
echo "  ✅ Available on Pro & Enterprise plans"

buildkite-agent annotate --style info --context model-providers << 'ANNOTATION'
## :buildkite: Model Providers — Reference Card

### Quick Setup
```bash
# Add to your pipeline script — that's the entire setup
export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"
export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"

# Now use Claude as normal
echo "Analyze this diff" | claude -p
```

### Auth Options
| Mode | Setup | Best For |
|------|-------|----------|
| **Buildkite Hosted Token** | Zero config | Getting started fast |
| **Bring Your Own Token** | Add your API key in org settings | Existing API contracts |

### Links
- 📖 [Model Providers docs](https://buildkite.com/docs/apis/model-providers)
- 📝 [Blog: What AI is teaching us about CI](https://buildkite.com/resources/blog/what-ai-is-teaching-us-about-ci)
- 📝 [Blog: Agentic CI — Three practical examples](https://buildkite.com/resources/blog/building-ai-powered-ci-workflows-three-practical-examples)
ANNOTATION

echo ""
echo "✅ Model Providers demo complete"
