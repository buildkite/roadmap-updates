#!/bin/bash
set -euo pipefail

echo "--- :buildkite: Buildkite Model Providers Demo"
echo ""
echo "Model Providers give your Buildkite agents direct access to LLMs"
echo "without requiring separate infrastructure or API key management."
echo ""
echo "Available environment variables for Model Provider access:"
echo "  BUILDKITE_AGENT_ENDPOINT  = ${BUILDKITE_AGENT_ENDPOINT:-"(not set — enable Model Providers in org settings)"}"
echo "  BUILDKITE_AGENT_ACCESS_TOKEN = ${BUILDKITE_AGENT_ACCESS_TOKEN:+"(set ✅)"}"
echo ""
echo "--- :anthropic: How to use Anthropic via Model Providers"
echo ""
echo "In your pipeline scripts, set these two environment variables:"
echo ""
echo '  export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"'
echo '  export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"'
echo ""
echo "Then use Claude Code, the Anthropic SDK, or any compatible tool as normal."
echo "Buildkite handles authentication and usage tracking automatically."
echo ""
echo "--- :book: Configuration options"
echo ""
echo "1. Buildkite Hosted Token — start immediately, no API keys needed (Pro/Enterprise)"
echo "2. Bring Your Own Token — use your own Anthropic/OpenAI credentials with Buildkite tracking"
echo ""

buildkite-agent annotate --style info --context model-providers << 'ANNOTATION'
## 🤖 Model Providers

**Model Providers** give Buildkite agents direct access to LLMs through the Buildkite platform.

### How it works
```bash
# Set these in your pipeline scripts to use Claude via Model Providers:
export ANTHROPIC_BASE_URL="$BUILDKITE_AGENT_ENDPOINT/ai/anthropic"
export ANTHROPIC_API_KEY="$BUILDKITE_AGENT_ACCESS_TOKEN"

# Then use Claude Code or the Anthropic SDK as normal
echo "Analyze this build log" | claude -p
```

### Authentication options
| Option | Description |
|--------|-------------|
| **Buildkite Hosted Token** | Start immediately — Buildkite manages infrastructure and auth |
| **Bring Your Own Token** | Use your own API keys with Buildkite usage tracking |

### Learn more
- [Model Providers docs](https://buildkite.com/docs/apis/model-providers)
- [Blog: What AI is teaching us about CI](https://buildkite.com/resources/blog/what-ai-is-teaching-us-about-ci)
- [Blog: Agentic CI — Three practical examples](https://buildkite.com/resources/blog/building-ai-powered-ci-workflows-three-practical-examples)
- [MLOps / Workflows for AI](https://buildkite.com/solutions/workflows-for-ai-ml)
ANNOTATION

echo "✅ Model Providers demo complete"
