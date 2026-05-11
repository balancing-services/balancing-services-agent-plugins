---
name: balancing-services-api
description: >
  Use when working with European electricity balancing market data, imbalance prices,
  balancing energy, capacity bids, or the Balancing Services API. Routes data queries
  to the `queryBalancingServices` MCP tool. Activates for energy market analysis, TSO
  data queries, and reserve type lookups.
allowed-tools: mcp__plugin_balancing-services_balancing-services-api__queryBalancingServices, WebFetch(domain:agents.balancing.services)
---

# Balancing Services API

Query European electricity balancing market data through the `queryBalancingServices` MCP tool. The tool is self-describing — call it with no arguments to see the available subcommands, then follow the progressive-disclosure pattern it advertises.

## If `queryBalancingServices` is not in your tool list

The `balancing-services-api` MCP server is not connected. Stop and ask the user to install or authenticate it (see https://github.com/Balancing-Services/balancing-services-agent-plugins). Do not attempt to fall back to other paths.
