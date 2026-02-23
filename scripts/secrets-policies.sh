#!/bin/bash
set -euo pipefail

echo "--- :shield: Secrets Access Policies"
echo ""
echo "Access policies restrict which builds can access a secret."
echo "Policies are written in YAML and evaluated against build context."
echo ""

buildkite-agent annotate --style info --context secrets-policies << 'ANNOTATION'
## 🔐 Secrets & Access Controls

### YAML Integration (Agent v3.106.0+)
Secrets can be injected directly from pipeline YAML — no hooks or plugins needed.

```yaml
# Inject for all steps
secrets:
  - API_TOKEN

steps:
  - command: ./deploy.sh

# Per-step with custom env var names
steps:
  - command: ./deploy.sh
    secrets:
      MY_TOKEN: API_ACCESS_TOKEN
```

### Access Policies
Policies restrict secret access based on build attributes. All claims in a rule must match.

```yaml
# Only allow main branch builds from this pipeline
- pipeline_slug: "my-pipeline"
  build_branch: "main"

# Allow multiple pipelines on main or develop
- pipeline_slug:
    - "frontend-pipeline"
    - "backend-pipeline"
  build_branch:
    - "main"
    - "develop"

# Only merge queue builds
- pipeline_slug: "my-pipeline"
  build_branch: "gh-readonly-queue/*"

# Only builds on the deploy queue
- cluster_queue_key: "production"
```

### Available claims
| Claim | Type | Description |
|-------|------|-------------|
| `pipeline_id` | First-party | Pipeline UUID (secure) |
| `build_source` | First-party | How the build was triggered |
| `cluster_queue_id` | First-party | Queue UUID (secure) |
| `pipeline_slug` | Third-party | Pipeline slug |
| `build_branch` | Third-party | Branch name |
| `build_creator` | Third-party | User email |
| `build_creator_team` | Third-party | Team UUIDs |

### Security features
- 🔒 Encrypted at rest and in transit
- 📝 All access is logged
- 🙈 Values auto-redacted in build logs
- 🏢 Scoped to cluster — each cluster has its own encryption key

### Learn more
- [Secrets docs](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets)
- [Access policies](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets/access-policies)
- [Managing secrets](https://buildkite.com/docs/pipelines/security/secrets/managing)
- [Changelog: Access control and YAML integration](https://buildkite.com/changelog)
ANNOTATION

echo "✅ Secrets & Access Policies demo complete"
