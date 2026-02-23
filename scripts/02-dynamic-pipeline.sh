#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :pipeline: Dynamic Pipelines + Buildkite SDK"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Today's CI is reactive. A lint rule fails, a test breaks,"
echo "  the build goes red — and everything stops. A developer"
echo "  context-switches, investigates, pushes a one-line fix,"
echo "  waits for CI again. For a missing import or a formatting"
echo "  violation, that's 30 minutes of wasted cycle time."
echo ""
echo "  Static YAML makes this worse — every step is defined"
echo "  up front. The pipeline can't adapt to what it finds."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  A step generates pipeline YAML at runtime and pipes it"
echo "  to buildkite-agent pipeline upload. New steps appear"
echo "  on the fly — the pipeline rewrites itself mid-build."
echo ""
box \
  "Analyze diff ──→ Generate steps ──→ Upload ──→ Execute" \
  "" \
  "On failure:  Diagnose ──→ Fix ──→ Commit ──→ Re-verify"
echo ""

echo "  ── USE CASES ──────────────────────────────────────────"
echo ""
echo "  🔧 Auto-remediation — lint or format failures get fixed"
echo "     inline. The agent runs the formatter, commits the"
echo "     result, and re-verifies. No human round-trip."
echo ""
echo "  🧪 Smart test selection — analyze the diff, run only"
echo "     the tests that cover changed code. Skip the rest."
echo ""
echo "  🚀 Roll-forward deploys — a low-impact test breaks in"
echo "     staging? The agent patches it, re-runs the suite,"
echo "     and keeps the deploy moving instead of blocking."
echo ""
echo "  📐 Conditional pipelines — monorepo with 12 services?"
echo "     Generate steps only for the services that changed."
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  ✨ Buildkite SDK (preview) — typed pipeline generation"
echo "     in JS/TS, Python, Go, Ruby, C#."
echo "     No more string-templating YAML by hand."
echo ""
echo "  🤖 Agentic CI foundation — an AI agent owns the loop:"
echo "     detect failure → diagnose → remediate → upload a"
echo "     fix-and-verify step → confirm green. The pipeline"
echo "     becomes a conversation, not a config file."
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  → CI that fixes low-impact issues instead of blocking"
echo "  → Developers stay in flow — fewer context switches"
echo "  → Faster cycle times: minutes, not hours"
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
      echo "  This step was generated at runtime by"
      echo "  02-dynamic-pipeline.sh and uploaded via:"
      echo "  buildkite-agent pipeline upload"
      echo ""
      echo "  ── FAIL FORWARD ─────────────────────────────────────────"
      echo ""
      echo "  Traditional CI: fail → stop → wait for developer →"
      echo "  fix → push → wait for CI again. A formatting"
      echo "  violation costs 30 minutes of cycle time."
      echo ""
      echo "  Agentic CI: fail → diagnose → remediate → re-verify."
      echo "  The pipeline keeps moving."
      echo ""
      echo "  🔧 Auto-remediation — lint fails? The agent runs the"
      echo "     formatter, commits the fix, re-verifies. No human"
      echo "     round-trip needed."
      echo ""
      echo "  🚀 Roll-forward deploys — a low-impact test breaks"
      echo "     in staging? Patch it, re-run the suite, keep the"
      echo "     deploy moving instead of blocking the release."
      echo ""
      echo "  🧪 Smart test selection — analyze the diff, generate"
      echo "     steps for only the tests covering changed code."
      echo ""
      echo "  📐 Conditional pipelines — monorepo with 12 services?"
      echo "     Generate steps only for what changed. Skip the rest."
      echo ""
      echo "  → This step is proof: it was decided at runtime,"
      echo "    not written in advance."
      echo ""
      buildkite-agent annotate --style success --context dynamic-step "## :sparkles: Dynamic Step — Fail Forward
      Generated at runtime via \`buildkite-agent pipeline upload\`. Instead of fail-stop, agentic CI **fails forward**: diagnose → remediate → re-verify → ship."'

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
