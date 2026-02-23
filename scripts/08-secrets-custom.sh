#!/bin/bash
set -euo pipefail

echo "+++ :closed_lock_with_key: Secrets — Custom Env Var Mapping"
echo ""
echo "  Map Buildkite secret names to custom env var names."
echo ""
echo "  ┌──────────────────────────────────────────┐"
echo "  │  steps:                                  │"
echo '  │    - label: "Deploy"                     │'
echo "  │      command: deploy.sh                  │"
echo "  │      secrets:                            │"
echo "  │        MY_APP_TOKEN: DEMO_SECRET         │"
echo "  └──────────────────────────────────────────┘"
echo ""

TOKEN_VALUE="${MY_APP_TOKEN:-""}"
if [[ -n "$TOKEN_VALUE" ]]; then
  TOKEN_LEN="${#TOKEN_VALUE}"
  echo "  ✅ MY_APP_TOKEN is available! ($TOKEN_LEN chars, mapped from DEMO_SECRET)"
else
  echo "  ⚠️  MY_APP_TOKEN not set — DEMO_SECRET doesn't exist yet"
fi

echo ""
echo "  Alternative: buildkite-agent secret get DEMO_SECRET"
echo ""
echo "  secrets: YAML              buildkite-agent secret get"
echo "  ─────────────────────────  ─────────────────────────────"
echo "  Available at step start    Fetched on demand"
echo "  Declarative in YAML        Imperative in scripts"
echo "  📖 docs.buildkite.com/pipelines/security/secrets/buildkite-secrets"

buildkite-agent annotate --style info --context secrets-custom << 'ANNOTATION'
## :closed_lock_with_key: Custom Env Var Mapping
```yaml
secrets:
  MY_APP_TOKEN: DEMO_SECRET
  DATABASE_URL: PROD_DB_CONNECTION_STRING
```
```bash
TOKEN=$(buildkite-agent secret get DEMO_SECRET)
```
- 📖 [Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
ANNOTATION

echo ""
echo "✅ Custom secrets mapping demo complete"
