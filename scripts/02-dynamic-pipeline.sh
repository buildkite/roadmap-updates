#!/bin/bash
set -euo pipefail

echo "+++ :pipeline: Dynamic Pipelines — Agentic CI"
echo ""
echo "  Generate YAML at runtime → pipe to buildkite-agent pipeline upload."
echo ""
echo "  ┌──────────────────────────────────────────────────────┐"
echo "  │  cat <<YAML | buildkite-agent pipeline upload        │"
echo "  │  steps:                                              │"
echo '  │    - label: "AI-generated step"                      │'
echo '  │      command: "decided at runtime"                   │'
echo "  │  YAML                                                │"
echo "  └──────────────────────────────────────────────────────┘"
echo ""
echo "  Analyze code ──→ Generate YAML ──→ Upload ──→ Execute"
echo ""

DYNAMIC_YAML='steps:
  - label: ":sparkles: I Was Dynamically Generated!"
    command: |
      echo "+++ :sparkles: Hello from a Dynamic Step!"
      echo ""
      echo "  This step was generated at runtime by 02-dynamic-pipeline.sh"
      echo "  and uploaded via: buildkite-agent pipeline upload"
      echo ""
      echo "  In agentic CI, an AI agent generates steps like this"
      echo "  based on what it discovers during the build."
      buildkite-agent annotate --style success --context dynamic-step "## :sparkles: Dynamic Step Executed!
      Generated at runtime via \`buildkite-agent pipeline upload\`. This is the foundation of **agentic CI**."'

echo "  Uploading dynamic step now..."
echo "$DYNAMIC_YAML" | buildkite-agent pipeline upload
echo "  ✅ Uploaded! New step will appear below."
echo ""
echo "  📖 docs.buildkite.com/pipelines/configure/dynamic-pipelines"
echo "  📖 SDKs: JS/TS, Python, Go, Ruby"

buildkite-agent annotate --style info --context dynamic-pipeline << 'ANNOTATION'
## :pipeline: Dynamic Pipeline Upload
```bash
cat <<YAML | buildkite-agent pipeline upload
steps:
  - label: ":robot_face: Agent-generated step"
    command: "echo 'decided at runtime'"
YAML
```
- 📖 [Dynamic Pipelines docs](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines)
- 📖 [Buildkite SDK docs](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines/sdk)
ANNOTATION

echo ""
echo "✅ Dynamic pipeline demo complete"
