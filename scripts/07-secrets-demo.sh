#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :key: Secrets — YAML Integration"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Getting secrets into CI jobs means plugins, environment hooks,"
echo "  or wrapper scripts. Every team rolls their own approach."
echo "  Onboarding a new pipeline takes longer than it should."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Add a secrets: block to your step YAML."
echo "  Values appear as environment variables. That's it."
echo ""
box \
  'steps:' \
  '  - label: "Deploy"' \
  '    command: deploy.sh' \
  '    secrets:' \
  '      - DATABASE_URL' \
  '      - API_KEY'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  🔒 Auto-redacted in logs — no accidental leaks"
echo "  📦 Built into the agent (v3.106.0+) — no plugins needed"
echo "  🔐 Encrypted at rest and in transit"
echo "  🏗️  Scoped to a cluster — secrets don't leak across boundaries"
echo ""

echo "  ── LIVE CHECK ───────────────────────────────────────────"
echo ""
SECRET_VALUE="${DEMO_SECRET:-""}"
if [[ -n "$SECRET_VALUE" ]]; then
  SECRET_LEN="${#SECRET_VALUE}"
  echo "  ✅ DEMO_SECRET is available! ($SECRET_LEN chars, auto-redacted)"
  echo "  DEMO_SECRET = $SECRET_VALUE"
else
  echo "  ⚠️  DEMO_SECRET not set — create in Org Settings → Secrets"
fi
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  Two lines of YAML replaces a plugin + hook chain."
echo "  Consistent across every pipeline."
echo "  Auto-redaction means fewer \"oops\" moments."
echo ""
echo "  📖 docs.buildkite.com/pipelines/security/secrets/buildkite-secrets"

buildkite-agent annotate --style info --context secrets-yaml --scope job << 'ANNOTATION'
## :key: Secrets — YAML Integration

### The Problem
> Getting secrets into CI jobs means plugins, environment hooks, or wrapper scripts. Every team rolls their own approach. Onboarding a new pipeline takes longer than it should.

### How It Works
Add a `secrets:` block to your step YAML. Values appear as environment variables. That's it.

```yaml
steps:
  - label: "Deploy"
    command: deploy.sh
    secrets:
      - DATABASE_URL
      - API_KEY
```

### What Buildkite Adds
- 🔒 **Auto-redacted in logs** — no accidental leaks
- 📦 **Built into the agent** (v3.106.0+) — no plugins needed
- 🔐 **Encrypted** at rest and in transit
- 🏗️ **Scoped to a cluster** — secrets don't leak across boundaries

### The Payoff
→ Two lines of YAML replaces a plugin + hook chain.
→ Consistent across every pipeline. Auto-redaction means fewer "oops" moments.

---
📖 [Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
ANNOTATION

echo ""
echo "✅ Secrets YAML demo complete"
