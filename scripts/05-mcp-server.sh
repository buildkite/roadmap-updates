#!/bin/bash
set -euo pipefail
source "$(dirname "$0")/_lib.sh"

echo "+++ :electric_plug: MCP Server — AI Tools for Buildkite"
echo ""

echo "  ── THE PROBLEM ──────────────────────────────────────────"
echo ""
echo "  Debugging CI means tab-switching between your IDE and the Buildkite UI."
echo "  Copy build numbers, click through jobs, scroll logs — context-switching"
echo "  that kills flow."
echo ""

echo "  ── HOW IT WORKS ─────────────────────────────────────────"
echo ""
echo "  The MCP (Model Context Protocol) server lets AI tools query builds, read"
echo "  logs, and trigger pipelines directly. One config line and you're connected."
echo "  OAuth handles auth — sign in via browser on first use."
echo ""
box \
  '{ "mcpServers": { "buildkite": {' \
  '    "type": "url",' \
  '    "url": "https://mcp.buildkite.com/mcp"' \
  '}}}'
echo ""

echo "  ── WHAT BUILDKITE ADDS ──────────────────────────────────"
echo ""
echo "  Your AI assistant gets full access to your CI:"
echo ""
echo "  📋 Pipelines    list, get, create, update"
echo "  🔨 Builds       trigger, get, list, wait"
echo "  📜 Logs         read, search, tail"
echo "  📎 Artifacts    list, download"
echo "  📝 Annotations  list"
echo "  🏗️  Clusters     list clusters + queues"
echo "  🧱 Jobs         unblock, get logs"
echo "  🧪 Tests        query runs + failures"
echo ""
echo "  Three deployment modes:"
echo ""
echo "  🌐 Remote:    mcp.buildkite.com/mcp (recommended, OAuth, auto-updated)"
echo "  🔒 Read-only: mcp.buildkite.com/mcp/readonly"
echo "  💻 Local:     self-hosted, open source (Go), for automated pipelines"
echo ""

echo "  ── THE PAYOFF ───────────────────────────────────────────"
echo ""
echo "  \"Why did build 1234 fail?\" — answered from your IDE. No more tab-switching."
echo "  AI agents that can self-diagnose their own builds."
echo ""
echo "  📖 buildkite.com/docs/apis/mcp-server"
echo "  🔗 github.com/buildkite/buildkite-mcp-server"

buildkite-agent annotate --style info --context mcp-server --scope job << 'ANNOTATION'
## :electric_plug: MCP Server — AI Tools for Buildkite

### The Problem
> Debugging CI means tab-switching between your IDE and the Buildkite UI. Copy build numbers, click through jobs, scroll logs — context-switching that kills flow.

### How It Works
The MCP server lets AI tools query builds, read logs, and trigger pipelines directly. One config line and you're connected. OAuth handles auth.

```json
{ "mcpServers": { "buildkite": { "type": "url", "url": "https://mcp.buildkite.com/mcp" }}}
```

### What Buildkite Adds

| Category | Tools |
|----------|-------|
| 📋 Pipelines | list, get, create, update |
| 🔨 Builds | trigger, get, list, wait |
| 📜 Logs | read, search, tail |
| 📎 Artifacts | list, download |
| 📝 Annotations | list |
| 🏗️ Clusters | list clusters + queues |
| 🧱 Jobs | unblock, get logs |
| 🧪 Tests | query runs + failures |

**Three deployment modes:**
- 🌐 **Remote:** `mcp.buildkite.com/mcp` (recommended, OAuth, auto-updated)
- 🔒 **Read-only:** `mcp.buildkite.com/mcp/readonly`
- 💻 **Local:** self-hosted, open source (Go), for automated pipelines

### The Payoff
→ "Why did build 1234 fail?" — answered from your IDE. No more tab-switching.
→ AI agents that can self-diagnose their own builds.

---
📖 [MCP Server docs](https://buildkite.com/docs/apis/mcp-server) · 🔗 [GitHub](https://github.com/buildkite/buildkite-mcp-server)
ANNOTATION

echo ""
echo "✅ MCP Server demo complete"
