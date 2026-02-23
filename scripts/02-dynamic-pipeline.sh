#!/bin/bash
set -euo pipefail

echo "--- :pipeline: Dynamic Pipeline Upload — Agentic CI Pattern"
echo ""
echo "  The core pattern: generate YAML at runtime → pipe to buildkite-agent pipeline upload"
echo ""
echo "  This is how AI agents adapt builds on the fly:"
echo "    1. Agent analyzes context (code, logs, artifacts)"
echo "    2. Agent decides what steps to run next"
echo "    3. Agent generates pipeline YAML"
echo "    4. YAML gets uploaded → new steps appear in the build"

echo ""
echo "--- :hammer_and_wrench: The Pattern in Bash"
echo ""
echo '  cat <<YAML | buildkite-agent pipeline upload'
echo '  steps:'
echo '    - label: ":sparkles: AI-generated step"'
echo '      command: echo "I was created at runtime!"'
echo '  YAML'
echo ""
echo "  That's it. The new steps appear in your build immediately."

echo ""
echo "--- :rocket: Generating a live dynamic step now..."
echo ""

DYNAMIC_YAML='steps:
  - label: ":sparkles: I Was Dynamically Generated!"
    command: |
      echo "--- :sparkles: Hello from a Dynamic Step!"
      echo ""
      echo "  This step did not exist in pipeline.yml."
      echo "  It was generated at runtime by scripts/02-dynamic-pipeline.sh"
      echo "  and uploaded via: buildkite-agent pipeline upload"
      echo ""
      echo "  In an agentic workflow, an AI agent would generate"
      echo "  steps like this based on what it discovers during the build."
      echo ""
      echo "  Analyze code → Generate YAML → Upload → Execute"
      buildkite-agent annotate --style success --context dynamic-step "## :sparkles: Dynamic Step Executed!

      This step was **generated at runtime** and uploaded via buildkite-agent pipeline upload.

      This is the foundation of **agentic CI** — pipelines that adapt based on what an AI agent discovers."'

echo "  Generated YAML:"
echo "$DYNAMIC_YAML" | sed 's/^/    /'
echo ""

echo "--- :upload: Uploading to Buildkite..."
echo "$DYNAMIC_YAML" | buildkite-agent pipeline upload
echo "  ✅ Uploaded! The new step will appear below in this build."

buildkite-agent annotate --style info --context dynamic-pipeline << 'ANNOTATION'
## :pipeline: Dynamic Pipeline Upload — Reference Card

### The Pattern
```bash
# Generate YAML however you want — AI, scripts, templates
cat <<YAML | buildkite-agent pipeline upload
steps:
  - label: ":robot_face: Agent-generated step"
    command: "echo 'decided at runtime'"
YAML
```

### Buildkite SDK (Typed Pipeline Generation)
Build pipelines programmatically with type safety:
- **JavaScript/TypeScript** — `@buildkite/pipeline`
- **Python** — `buildkite-pipelines`
- **Go** — `go-pipeline`
- **Ruby** — `buildkite-pipeline`

### Links
- 📖 [Dynamic Pipelines docs](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines)
- 📖 [Buildkite SDK docs](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines/sdk)
ANNOTATION

echo ""
echo "✅ Dynamic pipeline demo complete"
