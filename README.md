# Balancing Services — Claude Code Plugin

A Claude Code plugin for querying European electricity balancing market data via the [Balancing Services API](https://agents.balancing.services/api/v1).

## Prerequisites

- [uv](https://docs.astral.sh/uv/) — Python package runner (for `uvx`)

## Setup

```bash
claude --plugin-dir /path/to/balancing-services-for-claude
```

## Usage

Once the plugin is loaded, Claude automatically activates the skill when you ask about balancing market data. The agent obtains a token via the MCP server and runs the CLI:

```
bs-cli --token <TOKEN> <command> [options]
```

### Example prompts

- "What were imbalance prices in Estonia yesterday?"
- "Show me activated mFRR energy in Germany last week"
- "Compare aFRR capacity prices between France and Netherlands for January 2025"
- "Download energy bids for Finland as Parquet"

## What's Included

| File | Purpose |
|------|---------|
| `.claude-plugin/plugin.json` | Plugin manifest |
| `skills/balancing-services-api/SKILL.md` | Core skill — domain knowledge, CLI reference, and tool permissions |

## Links

- [Balancing Services](https://balancing.services)
- [API Documentation](https://api.balancing.services/v1/documentation)
- [CLI on PyPI](https://pypi.org/project/balancing-services-cli/)
