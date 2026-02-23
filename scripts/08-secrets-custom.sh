#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :closed_lock_with_key: Secrets — Custom Env Var Mapping"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Secret names in the vault don't match what your app expects."
echo "  PROD_DB_CONNECTION_STRING needs to become DATABASE_URL."
echo "  Teams write wrapper scripts just to rename variables."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  Map vault names to custom env var names in YAML."
echo "  Or fetch on demand with buildkite-agent secret get."
echo ""
box \
  'secrets:' \
  '  MY_APP_TOKEN: DEMO_SECRET' \
  '  DATABASE_URL: PROD_DB_CONNECTION_STRING'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  Two approaches — use what fits:"
echo ""
echo "  secrets: YAML              buildkite-agent secret get"
echo "  ─────────────────────────  ─────────────────────────────"
echo "  Available at step start    Fetched on demand"
echo "  Declarative in YAML        Imperative in scripts"
echo "  Best for: known vars       Best for: dynamic needs"
echo ""

echo "  ── LIVE CHECK ───────────────────────────────────────────"
echo ""
TOKEN_VALUE="${MY_APP_TOKEN:-""}"
if [[ -n "$TOKEN_VALUE" ]]; then
  TOKEN_LEN="${#TOKEN_VALUE}"
  echo "  ✅ MY_APP_TOKEN is available! ($TOKEN_LEN chars, mapped from DEMO_SECRET)"
  echo ""
  echo "  Printing the raw value to prove auto-redaction:"
  echo "  → $TOKEN_VALUE"
  echo "  (Buildkite replaced it with [REDACTED] automatically)"
else
  echo "  ⚠️  MY_APP_TOKEN not set — DEMO_SECRET doesn't exist yet"
fi
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  → No wrapper scripts to rename variables."
echo "  → One secret, many pipelines, different env var names."
echo "  → Declarative or imperative — your choice."
echo "  → Values are auto-redacted from logs — no leaks."
echo ""
echo "  📖 docs.buildkite.com/pipelines/security/secrets/buildkite-secrets"

buildkite-agent annotate --style info --context secrets-custom --scope job << 'ANNOTATION'
## :closed_lock_with_key: Custom Env Var Mapping
```yaml
secrets:
  MY_APP_TOKEN: DEMO_SECRET
  DATABASE_URL: PROD_DB_CONNECTION_STRING
```
```bash
TOKEN=$(buildkite-agent secret get DEMO_SECRET)
```
- Declarative (YAML) or imperative (`secret get`) — use what fits
- 📖 [Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
ANNOTATION

echo ""
echo "✅ Custom secrets mapping demo complete"
