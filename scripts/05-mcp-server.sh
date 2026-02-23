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

buildkite-agent annotate --style info --context mcp-server << 'ANNOTATION'
## :electric_plug: MCP Server — AI Tools for Buildkite
```json
{ "mcpServers": { "buildkite": { "type": "url", "url": "https://mcp.buildkite.com/mcp" }}}
```
**Tools:** Pipelines · Builds · Logs · Artifacts · Annotations · Clusters · Jobs · Tests

**Modes:** Remote (OAuth) · Read-only · Local (self-hosted, Go)

"Why did build 1234 fail?" — answered from your IDE.
- 📖 [MCP Server docs](https://buildkite.com/docs/apis/mcp-server)
- 🔗 [GitHub](https://github.com/buildkite/buildkite-mcp-server)
ANNOTATION

echo ""
echo "✅ MCP Server demo complete"
