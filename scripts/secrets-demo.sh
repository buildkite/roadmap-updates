#!/bin/bash
set -euo pipefail

echo "--- :key: Secrets YAML Integration Demo"
echo ""
echo "Buildkite Secrets can be injected into jobs directly from pipeline YAML."
echo "This step has 'secrets: [DEMO_SECRET]' in its step definition."
echo ""
echo "Checking if DEMO_SECRET was injected..."

if [ -n "${DEMO_SECRET:-}" ]; then
  echo "✅ DEMO_SECRET is available as an environment variable!"
  echo "   Value: (redacted by Buildkite — secret values are automatically redacted in logs)"
  echo "   Length: ${#DEMO_SECRET} characters"
  echo ""
  echo "The secret was loaded from the cluster's secret store and injected"
  echo "into this job's environment when the job started."
else
  echo "⚠️  DEMO_SECRET is not set."
  echo "   This means either:"
  echo "   - The secret 'DEMO_SECRET' hasn't been created in the cluster yet"
  echo "   - The agent version is < 3.106.0 (required for YAML secrets)"
  echo "   - An access policy is blocking this pipeline from accessing the secret"
fi

echo ""
echo "--- :yaml: How it looks in pipeline YAML"
echo ""
echo "  # Inject secret for all steps:"
echo "  secrets:"
echo "    - DEMO_SECRET"
echo ""
echo "  steps:"
echo "    - command: ./deploy.sh"
echo ""
echo "  # Or per-step:"
echo "  steps:"
echo "    - command: ./deploy.sh"
echo "      secrets:"
echo "        - API_TOKEN"
