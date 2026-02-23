#!/bin/bash
set -euo pipefail

echo "--- :electric_plug: Buildkite MCP Server"
echo ""
echo "  The MCP (Model Context Protocol) Server lets AI tools"
echo "  interact with Buildkite — query builds, read logs,"
echo "  trigger pipelines, manage infrastructure."
echo ""
echo "  Two flavors:"
echo "    🌐 Remote Server — hosted by Buildkite, no install required"
echo "    💻 Local Server  — self-hosted, for CI/CD automation"

echo ""
echo "--- :globe_with_meridians: Remote Server (Recommended)"
echo ""
echo "  Full access:      https://mcp.buildkite.com/mcp"
echo "  Read-only access: https://mcp.buildkite.com/mcp/readonly"
echo ""
echo "  Just add to your AI tool config — no install, no binary, no updates."

echo ""
echo "--- :wrench: Config for Claude Code / Cursor"
echo ""
echo '  Add to your MCP config (OAuth — no API key needed!):'
echo ""
echo '  {'
echo '    "mcpServers": {'
echo '      "buildkite": {'
echo '        "type": "url",'
echo '        "url": "https://mcp.buildkite.com/mcp"'
echo '      }'
echo '    }'
echo '  }'
echo ""
echo "  That's it. OAuth handles auth — you'll sign in via browser on first use."

echo ""
echo "--- :toolbox: Tool Categories"
echo ""
echo "  The MCP server exposes 30+ tools:"
echo ""
echo "    📋 Pipelines    — list, get, create, update pipelines"
echo "    🔨 Builds       — trigger, get, list, wait for builds"
echo "    📜 Logs         — read, search, tail build logs"
echo "    📎 Artifacts    — list & download build artifacts"
echo "    📝 Annotations  — list build annotations"
echo "    🏗️  Clusters     — manage clusters and queues"
echo "    🧪 Test Engine  — query test runs and failures"

echo ""
echo "--- :octocat: Open Source"
echo ""
echo "  The MCP server is fully open source:"
echo "  🔗 github.com/buildkite/buildkite-mcp-server"
echo ""
echo "  Contributions welcome! Built in Go."

buildkite-agent annotate --style info --context mcp-server << 'ANNOTATION'
## :electric_plug: MCP Server — Reference Card

### Config (Claude Code / Cursor)
```json
{
  "mcpServers": {
    "buildkite": {
      "type": "url",
      "url": "https://mcp.buildkite.com/mcp"
    }
  }
}
```

> 💡 OAuth handles auth automatically. For read-only access, use `https://mcp.buildkite.com/mcp/readonly`

### Tool Categories
| Category | Examples |
|----------|----------|
| **Pipelines** | `list_pipelines`, `get_pipeline`, `create_pipeline` |
| **Builds** | `create_build`, `get_build`, `wait_for_build` |
| **Logs** | `read_logs`, `search_logs`, `tail_logs` |
| **Artifacts** | `list_artifacts_for_build`, `get_artifact` |
| **Test Engine** | `get_test_run`, `get_failed_executions` |
| **Clusters** | `list_clusters`, `list_cluster_queues` |

### Links
- 📖 [MCP Server docs](https://buildkite.com/docs/apis/mcp-server)
- 📖 [Full tool reference](https://buildkite.com/docs/apis/mcp-server/tools)
- 🔗 [GitHub: buildkite-mcp-server](https://github.com/buildkite/buildkite-mcp-server)
ANNOTATION

echo ""
echo "✅ MCP Server demo complete"
