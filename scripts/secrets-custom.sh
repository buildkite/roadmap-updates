#!/bin/bash
set -euo pipefail

echo "--- :closed_lock_with_key: Secrets Custom Environment Variable Mapping"
echo ""
echo "This step uses custom mapping: secrets: { MY_APP_TOKEN: DEMO_SECRET }"
echo "The secret 'DEMO_SECRET' is injected as the env var 'MY_APP_TOKEN'."
echo ""

if [ -n "${MY_APP_TOKEN:-}" ]; then
  echo "✅ MY_APP_TOKEN is available (mapped from DEMO_SECRET)!"
  echo "   Length: ${#MY_APP_TOKEN} characters"
else
  echo "⚠️  MY_APP_TOKEN is not set (DEMO_SECRET may not exist in the cluster)."
fi

echo ""
echo "--- :yaml: Custom mapping syntax"
echo ""
echo "  steps:"
echo "    - command: ./api-call.sh"
echo "      secrets:"
echo "        MY_APP_TOKEN: API_ACCESS_TOKEN    # secret key → env var name"
echo "        DB_PASSWORD: DATABASE_CREDENTIALS"
echo ""
echo "--- :terminal: Alternative: buildkite-agent secret get"
echo ""
echo "  # Retrieve a secret in a script (useful for scoping exposure):"
echo '  SECRET_VAR=$(buildkite-agent secret get secret_name)'
echo ""
echo "  # Write to a file:"
echo '  buildkite-agent secret get tls_cert > cert.pem'
echo ""
echo "  # Pass directly to a tool:"
echo '  cli-tool --token $(buildkite-agent secret get api_token)'
