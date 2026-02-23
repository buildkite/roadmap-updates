#!/bin/bash
set -euo pipefail

echo "--- :pipeline: Dynamic Pipeline Upload Demo"
echo ""
echo "Agentic workflows use dynamic pipelines to adapt at runtime."
echo "An AI agent can generate and upload new steps based on what it discovers."
echo ""
echo "Generating a dynamic step now..."
echo ""

# Generate a pipeline step dynamically — this is how AI agents
# add new steps to a running build based on runtime analysis.
DYNAMIC_YAML=$(cat <<'YAML'
steps:
  - label: ":sparkles: Dynamically Generated Step"
    command: |
      echo "✨ This step was generated and uploaded at runtime!"
      echo ""
      echo "In an agentic workflow, an AI agent would:"
      echo "  1. Analyze build context (logs, artifacts, code changes)"
      echo "  2. Decide what steps to run next"
      echo "  3. Generate pipeline YAML dynamically"
      echo "  4. Upload it with 'buildkite-agent pipeline upload'"
      echo ""
      echo "This is the foundation of adaptive CI — pipelines that"
      echo "branch, fan out, and change based on what the agent discovers."
      buildkite-agent annotate --style success --context dynamic-step "## ✨ Dynamic Step Executed\nThis step was **generated at runtime** by \`scripts/dynamic-pipeline.sh\` and uploaded via \`buildkite-agent pipeline upload\`.\n\nThis pattern powers agentic workflows where AI agents decide what to run next.\n\n- [Buildkite SDK docs](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines/sdk)\n- [Dynamic Pipelines docs](https://buildkite.com/docs/pipelines/configure/dynamic-pipelines)"
YAML
)

echo "Generated YAML:"
echo "$DYNAMIC_YAML"
echo ""

echo "--- :upload: Uploading dynamic pipeline"
echo "$DYNAMIC_YAML" | buildkite-agent pipeline upload

echo "✅ Dynamic pipeline uploaded — the new step will appear in this build"
