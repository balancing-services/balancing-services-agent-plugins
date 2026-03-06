# Balancing Services Plugin

An agent plugin for working with European electricity balancing markets.

## Setup

### Claude Code

**Via the marketplace:**

```
/plugin marketplace add Balancing-Services/balancing-services-agent-plugins
/plugin install balancing-services@balancing-services-agent-plugins
```

**Local install:**

```bash
claude plugin install --local /path/to/balancing-services-agent-plugins/balancing-services
```

### Cursor IDE

Use `/add-plugin` in the agent chat to find and install **balancing-services** from the Cursor Marketplace. For team setups, see the [root README](../README.md#cursor-ide).

### Claude Co-work

Install from the marketplace — see the [root README](../README.md#claude-co-work) for adding the marketplace, then install **balancing-services** from the plugin list.

## Skills

### Balancing Services API

Query European electricity balancing market data — imbalance prices, balancing energy, capacity bids, and more — using the [Balancing Services CLI](https://pypi.org/project/balancing-services-cli/). Claude automatically activates this skill when you ask about balancing market data.

**Example prompts:**

- "What were imbalance prices in Estonia yesterday?"
- "Show me activated mFRR energy in Germany last week"
- "Compare aFRR capacity prices between France and Netherlands for January 2025"
- "Download energy bids for Finland as Parquet"

## Links

- [Balancing Services](https://balancing.services)
- [API Documentation](https://api.balancing.services/v1/documentation)
- [CLI on PyPI](https://pypi.org/project/balancing-services-cli/)
