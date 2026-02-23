# Buildkite Roadmap Updates Demo Pipeline

A single Buildkite pipeline that demonstrates six major Buildkite features shipped in late 2025 / early 2026. Each feature has its own group of steps with rich annotations that explain what's happening and link to the relevant docs and blog posts.

No application code — just enough bash to demo the actual Buildkite products and features.

## Features Demonstrated

### 🤖 AI / Agentic Workflows

Bring AI into your CI/CD pipelines with Model Providers, dynamic pipeline uploads, and AI plugins.

- **Model Providers** — connect pipelines to LLMs without managing API keys
- **Dynamic Pipeline Upload** — generate and upload pipeline steps at runtime (the foundation of agentic CI)
- **Claude Build Summary** — AI-powered build analysis using the [Claude Summarize plugin](https://github.com/buildkite-plugins/claude-summarize-buildkite-plugin)

| Resource | Link |
|----------|------|
| Agentic Workflows product page | [buildkite.com/platform/agentic-workflows](https://buildkite.com/platform/agentic-workflows) |
| Blog: What AI is teaching us about CI | [Read post](https://buildkite.com/resources/blog/what-ai-is-teaching-us-about-ci) |
| Blog: Agentic CI — Three practical examples | [Read post](https://buildkite.com/resources/blog/building-ai-powered-ci-workflows-three-practical-examples) |
| Model Providers docs | [buildkite.com/docs/apis/model-providers](https://buildkite.com/docs/apis/model-providers) |
| MLOps / Workflows for AI | [buildkite.com/solutions/workflows-for-ai-ml](https://buildkite.com/solutions/workflows-for-ai-ml) |

### 🧪 Test Engine Workflows

Automate responses to test health signals with monitors, alarm/recover events, and actions.

- **Parallel test execution** — `parallelism: 3` with bktec-style test splitting
- **Workflows overview** — monitors, actions, and how they connect

| Resource | Link |
|----------|------|
| Blog: Introducing Test Engine Workflows | [Read post](https://buildkite.com/resources/blog/introducing-test-engine-workflows) |
| Workflows docs | [buildkite.com/docs/test-engine/workflows](https://buildkite.com/docs/test-engine/workflows) |
| Changelog: New Test Monitor | [Nov 20, 2025](https://buildkite.com/changelog) |
| Changelog: bktec v2.0.0 dynamic parallelism | [Dec 7, 2025](https://buildkite.com/changelog) |
| Changelog: bktec v2.1.0 | [Feb 8, 2026](https://buildkite.com/changelog) |

### 🔌 MCP Server

Give AI tools structured access to Buildkite data via the Model Context Protocol.

- **Remote vs Local** — when to use each server type
- **Tool categories** — build inspection, log navigation, pipeline management, test engine

| Resource | Link |
|----------|------|
| MCP Server docs | [buildkite.com/docs/apis/mcp-server](https://buildkite.com/docs/apis/mcp-server) |
| MCP Tools overview | [buildkite.com/docs/apis/mcp-server/tools](https://buildkite.com/docs/apis/mcp-server/tools) |
| Installing the MCP server | [buildkite.com/docs/apis/mcp-server/local/installing](https://buildkite.com/docs/apis/mcp-server/local/installing) |
| Blog: What's new in the MCP server | [Read post](https://buildkite.com/resources/blog/whats-new-in-the-buildkite-mcp-server) |
| Blog: Designing log-navigation tools | [Read post](https://buildkite.com/resources/blog/designing-log-navigation-tools-in-the-buildkite-mcp-server) |
| GitHub repo | [github.com/buildkite/buildkite-mcp-server](https://github.com/buildkite/buildkite-mcp-server) |

### 🔀 GitHub Merge Queue Integration

Build for GitHub merge queues with conditionals, auto-cancellation, and dedicated UI.

- **Merge queue detection** — checks `BUILDKITE_MERGE_QUEUE_*` environment variables
- **Conditional steps** — steps that only run in merge queue builds using `if:` conditionals

| Resource | Link |
|----------|------|
| Changelog entry | [Oct 13, 2025](https://buildkite.com/changelog) |
| Tutorial: Using GitHub merge queues | [buildkite.com/docs/pipelines/tutorials/github-merge-queue](https://buildkite.com/docs/pipelines/tutorials/github-merge-queue) |
| Blog: Using GitHub merge queues | [Read post](https://buildkite.com/resources/blog/github-merge-queue) |

### 🔐 Secrets YAML Integration & Access Controls

Inject secrets directly from pipeline YAML with fine-grained access policies.

- **YAML integration** — `secrets:` key on steps, no hooks needed
- **Custom env var mapping** — map secret keys to custom environment variable names
- **Access policies** — YAML-based policies controlling which builds can access which secrets

| Resource | Link |
|----------|------|
| Changelog: Access control and YAML integration | [Oct 3, 2025](https://buildkite.com/changelog) |
| Secrets docs | [buildkite.com/docs/pipelines/security/secrets/buildkite-secrets](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets) |
| Access policies | [buildkite.com/docs/pipelines/security/secrets/buildkite-secrets/access-policies](https://buildkite.com/docs/pipelines/security/secrets/buildkite-secrets/access-policies) |
| Managing secrets | [buildkite.com/docs/pipelines/security/secrets/managing](https://buildkite.com/docs/pipelines/security/secrets/managing) |

### 🔄 Retry Agent Affinity

Control which agent handles retried jobs — prefer the warmest agent or a different one.

- **Retry configuration** — automatic retry with `retry:` in pipeline YAML
- **Affinity modes** — Prefer Warmest Agent vs Prefer Different Agent
- **Agent prioritization** — priority-based job assignment

| Resource | Link |
|----------|------|
| Changelog entry | [Nov 24, 2025](https://buildkite.com/changelog) |
| Agent prioritization docs | [buildkite.com/docs/agent/v3/self-hosted/prioritization](https://buildkite.com/docs/agent/v3/self-hosted/prioritization) |

## Pipeline Structure

```
🤖 AI / Agentic Workflows
├── Model Providers
├── Dynamic Pipeline Upload → (generates a step at runtime)
└── Claude Build Summary (with claude-summarize plugin)

🧪 Test Engine Workflows
├── Run Tests (parallel × 3)
└── Test Engine Workflows Overview

🔌 MCP Server
└── MCP Server Overview

🔀 GitHub Merge Queue
├── Merge Queue Detection
└── Merge Queue Only Step (conditional — skipped on regular builds)

🔐 Secrets & Access Controls
├── Secrets YAML Integration
├── Secrets Custom Mapping
└── Access Policies Explained

🔄 Retry Agent Affinity
└── Retry with Agent Affinity (auto-retry up to 2×)
```

## Setup

### Prerequisites

- A Buildkite organization with a cluster
- A queue in the cluster (e.g., `default`)
- (Optional) A secret called `DEMO_SECRET` in the cluster
- (Optional) An `ANTHROPIC_API_KEY` secret for the Claude Summarize plugin

### Running

The pipeline is configured at `.buildkite/pipeline.yml` and triggers automatically on push.

## Repository Structure

```
.buildkite/
  pipeline.yml          # Main pipeline definition
scripts/
  model-providers.sh    # Model Providers demo
  dynamic-pipeline.sh   # Dynamic pipeline upload demo
  test-engine.sh        # Parallel test execution demo
  test-engine-workflows.sh  # Test Engine Workflows explainer
  mcp-server.sh         # MCP Server overview
  merge-queue.sh        # Merge queue detection
  secrets-demo.sh       # Secrets YAML integration
  secrets-custom.sh     # Custom secret env var mapping
  secrets-policies.sh   # Access policies explainer
  retry-affinity.sh     # Retry agent affinity demo
tasks/
  prd-buildkite-roadmap-demo-pipeline.md  # Product requirements document
README.md               # This file
```
