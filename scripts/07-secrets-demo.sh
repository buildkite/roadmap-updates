#!/bin/bash
set -euo pipefail

echo "--- :key: Secrets YAML Integration"
echo ""
echo "  The secrets: key in pipeline YAML injects secrets directly"
echo "  as environment variables — no plugins, no hooks, no scripts."

echo ""
echo "--- :yaml: The YAML"
echo ""
echo "  This step is defined with:"
echo ""
echo '    steps:'
echo '      - label: "Secrets demo"'
echo '        command: scripts/07-secrets-demo.sh'
echo '        secrets:'
echo '          - DEMO_SECRET'
echo ""
echo "  That's it. DEMO_SECRET is now available as \$DEMO_SECRET."

echo ""
echo "--- :mag: Checking for DEMO_SECRET"
echo ""

SECRET_VALUE="${DEMO_SECRET:-""}"
if [[ -n "$SECRET_VALUE" ]]; then
  SECRET_LEN="${#SECRET_VALUE}"
  echo "  ✅ DEMO_SECRET is available!"
  echo "  📏 Length: $SECRET_LEN characters"
  echo "  🔒 Value: (auto-redacted by Buildkite agent)"
  echo ""
  echo "  Try printing it — Buildkite redacts it automatically:"
  echo "  DEMO_SECRET = $SECRET_VALUE"
else
  echo "  ⚠️  DEMO_SECRET is not set"
  echo ""
  echo "  To make this work:"
  echo "    1. Go to Org Settings → Secrets"
  echo "    2. Create a secret named 'DEMO_SECRET'"
  echo "    3. Rebuild this pipeline"
fi

echo ""
echo "--- :shield: Key Features"
echo ""
echo "  ✅ Declarative — secrets: key in YAML"
echo "  ✅ Auto-redaction — values masked in logs automatically"
echo "  ✅ Agent v3.106.0+ required"
echo "  ✅ No plugins or hooks needed"
echo "  ✅ Access controlled by policies (see next step)"

buildkite-agent annotate --style info --context secrets-yaml << 'ANNOTATION'
## :key: Secrets YAML Integration — Reference Card

### Basic Usage
```yaml
steps:
  - label: "Deploy"
    command: deploy.sh
    secrets:
      - DATABASE_URL
      - API_KEY
```
Secrets are injected as environment variables. Values are auto-redacted in logs.

### Requirements
- Buildkite Agent **v3.106.0+**
- Secrets created in **Org Settings → Secrets**

### Links
- 📖 [Buildkite Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
ANNOTATION

echo ""
echo "✅ Secrets YAML demo complete"
