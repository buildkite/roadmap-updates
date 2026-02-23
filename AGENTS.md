# Buildkite Roadmap Updates Demo

This repo contains a single Buildkite pipeline that demos six major features. There is no application code — only bash scripts and pipeline YAML.

## Repository structure

- `.buildkite/pipeline.yml` — main pipeline definition with 6 groups of steps
- `scripts/*.sh` — bash scripts that echo feature explanations and create `buildkite-agent annotate` annotations
- `tasks/` — PRDs and planning docs
- `README.md` — full documentation with links to all relevant Buildkite docs and blog posts

## Conventions

- Scripts use `#!/bin/bash` with `set -euo pipefail`
- Every script calls `buildkite-agent annotate` with a unique `--context` to produce a rich annotation in the Buildkite UI
- Steps gracefully handle missing environment variables (secrets, merge queue vars) with informative fallback output
- Pipeline YAML uses emoji labels, `key:` identifiers, and `group:` for visual organization

## Features demonstrated

1. **AI / Agentic Workflows** — Model Providers, dynamic pipeline upload, Claude Summarize plugin
2. **Test Engine Workflows** — parallel test execution with bktec, monitors, actions
3. **MCP Server** — remote vs local server, tool categories
4. **GitHub Merge Queue** — env var detection, conditional steps with `if:`
5. **Secrets YAML Integration** — `secrets:` key, custom env var mapping, access policies
6. **Retry Agent Affinity** — automatic retry config, affinity modes, agent prioritization

## Buildkite org

- **Organization:** `roadmap-updates`
- **Pipeline:** `roadmap-updates-demo`
- **Cluster:** Default cluster (`a7377d2f-d07a-48da-9611-a6e7ee3bfc23`)

## Adding new feature demos

1. Create a new script in `scripts/` following the existing pattern (echo explanation, call `buildkite-agent annotate`)
2. Add a new group or step to `.buildkite/pipeline.yml`
3. Update `README.md` with the new feature's docs/blog links
