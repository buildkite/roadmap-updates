# PRD: Buildkite Roadmap Updates Demo Pipeline

## Introduction

Create a demo Buildkite pipeline in the `roadmap-updates` GitHub repository that showcases six major Buildkite product features shipped in late 2025 / early 2026. The pipeline does not run a real application — it uses minimal bash scripts, `echo` statements, annotations, and YAML configuration to demonstrate each feature in a way that is visually clear and self-documenting when viewed in the Buildkite UI.

The target audience is Buildkite prospects, customers, and internal stakeholders who want to see these features in action in a single, cohesive build.

## Goals

- Provide a single pipeline that demonstrates all six feature areas in clearly labeled steps/groups
- Keep every step simple — bash scripts and `echo`, no compiled application code
- Use real Buildkite YAML features (secrets, model providers, conditionals, retry config, annotations) so the pipeline serves as a working reference
- Make the pipeline visually informative in the Buildkite UI using annotations, groups, and emoji labels
- Include a README that explains the pipeline and links to relevant docs/blog posts for each feature

## User Stories

### US-001: Repository scaffolding
**Description:** As a viewer of the repo, I want a clear README and directory structure so that I can understand what this demo covers and how to run it.

**Acceptance Criteria:**
- [ ] `README.md` at repo root explaining the demo, listing all six feature areas with links to docs/blogs
- [ ] `.buildkite/pipeline.yml` containing the full pipeline definition
- [ ] Helper scripts live under `scripts/` where needed
- [ ] Repo has no unnecessary files — minimal and focused

### US-002: AI / Agentic Workflows demo step
**Description:** As a viewer, I want to see a pipeline step that demonstrates Buildkite Model Providers and agentic workflow patterns so I understand how AI integrates into CI.

**Acceptance Criteria:**
- [ ] A group labeled "🤖 AI / Agentic Workflows" in the pipeline
- [ ] Step that shows Model Provider configuration using `BUILDKITE_AGENT_ENDPOINT` and `BUILDKITE_AGENT_ACCESS_TOKEN` environment variables
- [ ] Step that demonstrates dynamic pipeline upload (a script that generates and uploads a step via `buildkite-agent pipeline upload`)
- [ ] Step that uses a Buildkite AI plugin (e.g., `anthropic-build-summary-buildkite-plugin`) to annotate the build
- [ ] Each step uses `echo` and `buildkite-agent annotate` to explain what it is demonstrating

### US-003: Test Engine Workflows demo step
**Description:** As a viewer, I want to see how Test Engine Workflows, monitors, and bktec work in a pipeline.

**Acceptance Criteria:**
- [ ] A group labeled "🧪 Test Engine Workflows" in the pipeline
- [ ] Step that simulates running tests with `bktec` and demonstrates parallelism configuration via `parallelism` key
- [ ] Step that uses `buildkite-agent annotate` to explain Test Engine Workflows concepts (monitors, alarm/recover events, actions)
- [ ] Shows example of how `bktec` dynamic parallelism (v2.0+) would be configured

### US-004: MCP Server demo step
**Description:** As a viewer, I want to see how the Buildkite MCP server is referenced and used within pipeline steps.

**Acceptance Criteria:**
- [ ] A group labeled "🔌 MCP Server" in the pipeline
- [ ] Step that shows how to configure the local MCP server binary in a pipeline step (download, configure, reference)
- [ ] Step that shows the remote MCP server URL (`https://mcp.buildkite.com/mcp`) and explains when to use remote vs local
- [ ] Uses annotations to list key MCP tool categories (build inspection, log navigation, pipeline management)

### US-005: GitHub Merge Queue demo step
**Description:** As a viewer, I want to see how Buildkite pipeline steps can detect and respond to merge queue builds.

**Acceptance Criteria:**
- [ ] A group labeled "🔀 GitHub Merge Queue" in the pipeline
- [ ] Step that checks `BUILDKITE_MERGE_QUEUE_BASE_COMMIT` and `BUILDKITE_MERGE_QUEUE_BASE_BRANCH` environment variables
- [ ] Step uses conditionals (`if: build.merge_queue.base_commit != null`) to demonstrate conditional step execution
- [ ] Step that always runs and echoes whether it is a merge queue build or a regular build
- [ ] Uses annotations to explain merge queue behavior (auto-cancel, build listing)

### US-006: Secrets YAML Integration demo step
**Description:** As a viewer, I want to see how Buildkite Secrets are referenced in pipeline YAML and how access policies work.

**Acceptance Criteria:**
- [ ] A group labeled "🔐 Secrets & Access Controls" in the pipeline
- [ ] Step that references a secret using the `secrets:` YAML key (e.g., `secrets: [DEMO_SECRET]`)
- [ ] Step that demonstrates custom environment variable mapping (`secrets: { MY_TOKEN: DEMO_SECRET }`)
- [ ] Step that uses `buildkite-agent secret get` to retrieve a secret in a script
- [ ] Uses annotations to show an example access policy YAML and explain claims/conditions
- [ ] Actual secret value retrieval will gracefully handle the secret not existing (for portability)

### US-007: Retry Agent Affinity demo step
**Description:** As a viewer, I want to see how retry agent affinity and agent prioritization are configured.

**Acceptance Criteria:**
- [ ] A group labeled "🔄 Retry Agent Affinity" in the pipeline
- [ ] Step with `retry: { automatic: [{ exit_status: "*", limit: 2 }] }` demonstrating automatic retry
- [ ] Step uses `buildkite-agent annotate` to explain the two affinity modes (Prefer Warmest Agent, Prefer Different Agent)
- [ ] Step echoes `BUILDKITE_AGENT_NAME` and `BUILDKITE_RETRY_COUNT` to show which agent ran each attempt
- [ ] Uses annotations to explain how to configure affinity at the queue level

### US-008: Pipeline creation in Buildkite
**Description:** As a developer, I want the pipeline to be created in the `roadmap-updates` Buildkite organization so it can be triggered and viewed.

**Acceptance Criteria:**
- [ ] Pipeline created in `roadmap-updates` org pointing to `https://github.com/buildkite/roadmap-updates`
- [ ] Pipeline uses the Default cluster (`a7377d2f-d07a-48da-9611-a6e7ee3bfc23`)
- [ ] Pipeline reads its steps from `.buildkite/pipeline.yml` in the repo
- [ ] Pipeline has descriptive name and tags

## Functional Requirements

- FR-1: The pipeline YAML must define six groups, one per feature area, each with a descriptive emoji label
- FR-2: Every step must produce a visible annotation in the Buildkite UI explaining the feature it demonstrates
- FR-3: Steps that depend on external state (secrets, merge queue) must gracefully degrade with informative output when that state is absent
- FR-4: The pipeline must use `agents: { queue: "default" }` or hosted agents as appropriate for the org's cluster setup
- FR-5: The README must include a "Features Demonstrated" section with links to all docs and blog posts provided by the user
- FR-6: Scripts under `scripts/` must be executable (`chmod +x`) and use `#!/bin/bash` shebangs
- FR-7: The dynamic pipeline upload demo must generate valid YAML and upload it using `buildkite-agent pipeline upload`

## Non-Goals

- No real application code, test suites, or compiled artifacts
- No actual AI model calls (we demonstrate the configuration, not a live LLM interaction)
- No actual Test Engine test suite integration (we show the bktec config patterns)
- No real GitHub merge queue setup (we detect and display the env vars)
- No actual secrets with real values (we show the YAML patterns and gracefully handle missing secrets)
- No custom agent infrastructure or self-hosted agent setup

## Technical Considerations

- The `roadmap-updates` org has a Default cluster with ID `a7377d2f-d07a-48da-9611-a6e7ee3bfc23`; the pipeline must be assigned to this cluster
- All steps should target a queue available in the cluster (may need to create a `default` queue or use hosted agents)
- Annotations use `buildkite-agent annotate` with `--style info|success|warning` and `--context` for unique contexts per step
- The dynamic pipeline upload step needs to output YAML to stdout and pipe to `buildkite-agent pipeline upload`
- Secrets YAML integration requires agent v3.106.0+; the annotation should note this

## Success Metrics

- Pipeline triggers successfully and all steps pass (or gracefully skip with informative annotations)
- Every feature area is visually distinct and self-documenting in the Buildkite build UI
- A viewer unfamiliar with these features can understand what each one does by reading the annotations
- README serves as a comprehensive reference linking to all relevant docs and blog posts

## Open Questions

- Which hosted agent queue should be used? (Need to verify available queues in the Default cluster)
- Should we create a demo secret in the cluster for the Secrets step, or just demonstrate the YAML pattern?
- Should the AI plugin step actually invoke a plugin, or just show the configuration pattern?
