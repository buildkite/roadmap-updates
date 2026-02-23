#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :pipeline: Dynamic Pipelines + Buildkite SDK"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Static YAML can't adapt. You define every step up front,"
echo "  even when the right steps depend on what actually changed."
echo "  Teams over-build to be safe, wasting compute."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Generate pipeline YAML at runtime and pipe to"
echo "  buildkite-agent pipeline upload. Steps appear on the fly."
echo ""
box \
  "Analyze code ──→ Generate YAML ──→ Upload ──→ Execute"
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  ✨ Buildkite SDK (preview) — typed pipeline generation"
echo "     in JS/TS, Python, Go, Ruby, C#."
echo "     No more string-templating YAML by hand."
echo ""
echo "  🤖 Foundation for agentic CI — an AI agent analyzes the"
echo "     diff, decides what to test, generates steps, uploads"
echo "     them. The pipeline becomes a conversation, not a"
echo "     config file."
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  CI that adapts to the code. Less wasted compute."
echo "  AI agents that own their own CI workflow."
echo ""
echo "  📖 docs.buildkite.com/pipelines/configure/dynamic-pipelines"
echo ""

echo "  ── LIVE DEMO ────────────────────────────────────────────"
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
