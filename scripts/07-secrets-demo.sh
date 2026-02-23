#!/bin/bash
set -euo pipefail

echo "+++ :key: Secrets — YAML Integration"
echo ""
echo "  Inject secrets as env vars — no plugins, no hooks, no scripts."
echo ""
echo "  ┌────────────────────────────────────────┐"
echo "  │  steps:                                │"
echo '  │    - label: "Deploy"                   │'
echo "  │      command: deploy.sh                │"
echo "  │      secrets:                          │"
echo "  │        - DEMO_SECRET                   │"
echo "  └────────────────────────────────────────┘"
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
echo "  🔒 Auto-redacted in logs   📦 Agent v3.106.0+"
echo "  📖 docs.buildkite.com/pipelines/security/secrets/buildkite-secrets"

buildkite-agent annotate --style info --context secrets-yaml << 'ANNOTATION'
## :key: Secrets YAML
```yaml
steps:
  - label: "Deploy"
    command: deploy.sh
    secrets:
      - DATABASE_URL
      - API_KEY
```
- 📖 [Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
ANNOTATION

echo ""
echo "✅ Secrets YAML demo complete"
