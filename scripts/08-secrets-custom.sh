#!/bin/bash
set -euo pipefail

echo "--- :closed_lock_with_key: Custom Environment Variable Mapping"
echo ""
echo "  Map Buildkite secret names to custom env var names."
echo "  Your app expects \$MY_APP_TOKEN? Map it from a secret called DEMO_SECRET."

echo ""
echo "--- :yaml: The YAML"
echo ""
echo "  This step uses a key-value mapping:"
echo ""
echo '    steps:'
echo '      - label: "Custom mapping"'
echo '        command: scripts/08-secrets-custom.sh'
echo '        secrets:'
echo '          MY_APP_TOKEN: DEMO_SECRET'
echo ""
echo "  The secret 'DEMO_SECRET' is injected as \$MY_APP_TOKEN."
echo "  Your script never knows the Buildkite secret name."

echo ""
echo "--- :mag: Checking for MY_APP_TOKEN"
echo ""

TOKEN_VALUE="${MY_APP_TOKEN:-""}"
if [[ -n "$TOKEN_VALUE" ]]; then
  TOKEN_LEN="${#TOKEN_VALUE}"
  echo "  ✅ MY_APP_TOKEN is available!"
  echo "  📏 Length: $TOKEN_LEN characters"
  echo "  🔗 Mapped from Buildkite secret: DEMO_SECRET"
  echo "  🔒 Value: (auto-redacted by Buildkite agent)"
else
  echo "  ⚠️  MY_APP_TOKEN is not set"
  echo ""
  echo "  This means the DEMO_SECRET secret doesn't exist yet."
  echo "  Create it in Org Settings → Secrets to see this work."
fi

echo ""
echo "--- :hammer_and_wrench: Alternative: buildkite-agent secret get"
echo ""
echo "  You can also fetch secrets programmatically:"
echo ""
echo '    TOKEN=$(buildkite-agent secret get DEMO_SECRET)'
echo ""
echo "  Useful when you need a secret mid-script, not at step start."

echo ""
echo "--- :bulb: When to Use Each Approach"
echo ""
echo "    secrets:                       buildkite-agent secret get"
echo "    ─────────────────────────────  ─────────────────────────────"
echo "    Available at step start        Fetched on demand"
echo "    Declarative in YAML            Imperative in scripts"
echo "    Auto-redacted in logs          Auto-redacted in logs"
echo "    Best for: most use cases       Best for: conditional access"

buildkite-agent annotate --style info --context secrets-custom << 'ANNOTATION'
## :closed_lock_with_key: Custom Env Var Mapping — Reference Card

### Map Secret → Custom Env Var
```yaml
steps:
  - label: "Deploy"
    command: deploy.sh
    secrets:
      # env var name: buildkite secret name
      DATABASE_URL: PROD_DB_CONNECTION_STRING
      API_KEY: STRIPE_SECRET_KEY
      MY_APP_TOKEN: DEMO_SECRET
```

### Programmatic Access
```bash
# Fetch a secret mid-script
TOKEN=$(buildkite-agent secret get DEMO_SECRET)
```

### Links
- 📖 [Buildkite Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
ANNOTATION

echo ""
echo "✅ Custom secrets mapping demo complete"
