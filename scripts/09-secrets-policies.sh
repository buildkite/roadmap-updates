#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :shield: Secrets — Access Policies"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Any pipeline can access any secret. There's no least-privilege."
echo "  A typo in a dev pipeline could pull production credentials."
echo "  Auditors ask \"who can access what?\" and you don't have a good answer."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  YAML-defined policies scope secrets by pipeline, branch, queue,"
echo "  and creator. Only builds that match the policy get access."
echo ""
box \
  '- pipeline_slug: "deploy-*"' \
  '  build_branch: "main"' \
  '  cluster_queue_key: "production"'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  Two levels of claim assurance:"
echo ""
echo "  1st-party (Buildkite-generated, high assurance):"
echo "    pipeline_id · build_source · cluster_queue_id"
echo ""
echo "  3rd-party (convenience filters):"
echo "    pipeline_slug · build_branch · build_creator"
echo "    build_creator_team · cluster_queue_key"
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  Prod secrets locked to prod pipelines — by policy, not trust."
echo "  Auditable: policies are YAML, version-controlled, reviewable."
echo "  Least-privilege without slowing teams down."
echo ""
echo "  📖 docs.buildkite.com/pipelines/security/secrets/buildkite-secrets/access-policies"

buildkite-agent annotate --style info --context secrets-policies --scope job << 'ANNOTATION'
## :shield: Secrets — Access Policies

### The Problem
> Any pipeline can access any secret. There's no least-privilege. A typo in a dev pipeline could pull production credentials. Auditors ask "who can access what?" and you don't have a good answer.

### How It Works
YAML-defined policies scope secrets by pipeline, branch, queue, and creator. Only builds that match the policy get access.

```yaml
- pipeline_slug: "deploy-*"
  build_branch: "main"
  cluster_queue_key: "production"
```

### What Buildkite Adds

| Assurance Level | Claims |
|----------------|--------|
| **1st-party** (high assurance) | `pipeline_id` · `build_source` · `cluster_queue_id` |
| **3rd-party** (convenience) | `pipeline_slug` · `build_branch` · `build_creator` · `build_creator_team` · `cluster_queue_key` |

### The Payoff
→ Prod secrets locked to prod pipelines — by policy, not trust
→ Auditable: policies are YAML, version-controlled, reviewable
→ Least-privilege without slowing teams down

---
📖 [Access Policies docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets/access-policies)
ANNOTATION

echo ""
echo "✅ Access Policies demo complete"
