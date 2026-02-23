#!/bin/bash
set -euo pipefail

echo "--- :electric_plug: Buildkite MCP Server Demo"
echo ""
echo "The Buildkite MCP (Model Context Protocol) server exposes Buildkite data"
echo "to AI tools, editors, and agents via an open standard protocol."
echo ""
echo "--- :globe_with_meridians: Remote MCP Server (Recommended)"
echo ""
echo "URL: https://mcp.buildkite.com/mcp"
echo "Read-only: https://mcp.buildkite.com/mcp/readonly"
echo ""
echo "  • No installation needed — Buildkite hosts it"
echo "  • OAuth authentication — no API tokens to manage"
echo "  • Auto-updated with new features"
echo "  • Best for interactive AI tools (editors, chat)"
echo ""
echo "--- :computer: Local MCP Server (For CI/CD)"
echo ""
echo "Install: github.com/buildkite/buildkite-mcp-server"
echo ""
echo "  • Run a specific version for consistent results"
echo "  • Best for automated workflows in pipelines"
echo "  • Requires API access token"
echo ""
echo "--- :wrench: MCP Tool Categories"
echo ""
echo "  Build Inspection    — get build details, list builds, inspect jobs"
echo "  Log Navigation      — tail logs, search logs, read log ranges"
echo "  Pipeline Management — create builds, unblock jobs, manage pipelines"
echo "  Test Engine         — query test runs, find failed executions"
echo "  Annotations         — list build annotations"
echo "  Artifacts           — list and download build artifacts"
echo ""

buildkite-agent annotate --style info --context mcp-server << 'ANNOTATION'
## 🔌 Buildkite MCP Server

The **Model Context Protocol (MCP)** server gives AI tools structured access to Buildkite data.

### Server types

| Type | URL | Best for |
|------|-----|----------|
| **Remote** | `https://mcp.buildkite.com/mcp` | Interactive AI tools (editors, chat) |
| **Remote (read-only)** | `https://mcp.buildkite.com/mcp/readonly` | Safe read-only access |
| **Local** | Self-hosted binary | Automated CI/CD workflows |

### Key tool categories
- 🔍 **Build inspection** — get_build, list_builds, get_pipeline
- 📜 **Log navigation** — tail_logs, search_logs, read_logs
- ⚙️ **Pipeline management** — create_build, unblock_job
- 🧪 **Test Engine** — get_test_run, get_failed_executions
- 📎 **Artifacts** — list_artifacts_for_build, get_artifact

### Example: Configure for Claude Code
```json
{
  "mcpServers": {
    "buildkite": {
      "url": "https://mcp.buildkite.com/mcp"
    }
  }
}
```

### Learn more
- [MCP Server docs](https://buildkite.com/docs/apis/mcp-server)
- [MCP Tools overview](https://buildkite.com/docs/apis/mcp-server/tools)
- [Blog: What's new in the MCP server](https://buildkite.com/resources/blog/whats-new-in-the-buildkite-mcp-server)
- [Blog: Designing log-navigation tools](https://buildkite.com/resources/blog/designing-log-navigation-tools-in-the-buildkite-mcp-server)
- [GitHub repo](https://github.com/buildkite/buildkite-mcp-server)
ANNOTATION

echo "✅ MCP Server demo complete"
