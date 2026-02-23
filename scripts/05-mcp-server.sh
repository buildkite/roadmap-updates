#!/bin/bash
set -euo pipefail

echo "+++ :electric_plug: MCP Server — AI Tools for Buildkite"
echo ""
echo "  AI tools query builds, read logs, trigger pipelines via MCP protocol."
echo ""
echo "  ┌──────────────────────────────────────────────────┐"
echo '  │  { "mcpServers": { "buildkite": {               │'
echo '  │      "type": "url",                              │'
echo '  │      "url": "https://mcp.buildkite.com/mcp"     │'
echo "  │  }}}                                             │"
echo "  └──────────────────────────────────────────────────┘"
echo ""
echo "  OAuth handles auth — sign in via browser on first use."
echo ""
echo "  📋 Pipelines   list, get, create, update"
echo "  🔨 Builds      trigger, get, list, wait"
echo "  📜 Logs        read, search, tail"
echo "  📎 Artifacts   list, download"
echo "  📝 Annotations list annotations"
echo "  🏗️  Clusters    manage clusters + queues"
echo "  🧪 Tests       query runs + failures"
echo ""
echo "  🌐 Remote: mcp.buildkite.com/mcp              💻 Local: self-hosted"
echo "  🔒 Read-only: mcp.buildkite.com/mcp/readonly"
echo "  🔗 github.com/buildkite/buildkite-mcp-server (open source, Go)"
echo "  📖 docs.buildkite.com/apis/mcp-server"

buildkite-agent annotate --style info --context mcp-server << 'ANNOTATION'
## :electric_plug: MCP Server
```json
{ "mcpServers": { "buildkite": { "type": "url", "url": "https://mcp.buildkite.com/mcp" }}}
```
- 📖 [MCP Server docs](https://buildkite.com/docs/apis/mcp-server)
- 📖 [Tool reference](https://buildkite.com/docs/apis/mcp-server/tools)
- 🔗 [GitHub](https://github.com/buildkite/buildkite-mcp-server)
ANNOTATION

echo ""
echo "✅ MCP Server demo complete"
