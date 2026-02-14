---
name: balancing-services-api
description: >
  Use when working with European electricity balancing market data, imbalance prices,
  balancing energy, capacity bids, or the Balancing Services API. Activates for energy
  market analysis, TSO data queries, and reserve type lookups.
allowed-tools: Bash(bs-cli *), Bash(uvx --from balancing-services-cli *), Bash(uvx --from "balancing-services-cli*" *)
---

# Balancing Services API

Query European electricity balancing market data using the Balancing Services CLI.

The API's OpenAPI definition is available at https://api.balancing.services/v1/openapi.yaml.

## CLI Invocation

```
bs-cli --token $TOKEN [options] <command> [command-options]
```

The CLI is available on [PyPI](https://pypi.org/project/balancing-services-cli/) as `balancing-services-cli`. The minimum required version is **1.6.0.post5**. For example:
- `uv tool install "balancing-services-cli>=1.6.0.post5"`
- `uvx --from "balancing-services-cli>=1.6.0.post5" bs-cli ...` (run without installing)
- `pip install "balancing-services-cli>=1.6.0.post5"`

If a documented option is not available, upgrade the CLI (e.g. `uv tool install --upgrade balancing-services-cli` or `pip install --upgrade balancing-services-cli`).

### Authentication

**Before doing anything else**, verify that the `issueApiToken` MCP tool is available. This is the only way to obtain an API token — there is no other authentication method.

- If available: call `issueApiToken` to get a token and pass it with `--token`. The token is valid for 1 hour.
- If NOT available: **stop immediately** and ask the user to authenticate the `balancing-services-api` MCP server and offer your help for finding relevant documentation. Do not attempt to proceed without a token.

## How to Use the CLI

**Always run `bs-cli --help` before your first query** to see available commands. Then **check subcommand help** before constructing each query — parameter names, valid area codes, and required options vary by command:

```
bs-cli <command> --help
```

### Output Formats

The `-o`, `-f`, and `-v` flags are **root-level options** and must be placed **before** the subcommand:

- **CSV** (default): printed to stdout — ideal for quick inspection or piping
- **CSV file**: `bs-cli --token $TOKEN -o data.csv <command> [command-options]`
- **Parquet file**: `bs-cli --token $TOKEN -o data.parquet <command> [command-options]`
  Parquet requires the extra dependency. Use:
  ```
  uvx --from "balancing-services-cli[parquet]>=1.6.0.post5" bs-cli --token $TOKEN -o data.parquet <command> ...
  ```

**Note:** JSON output is not supported. Use CSV (default) or Parquet.

### Timestamps

All `--start` and `--end` parameters accept ISO 8601 timestamps:
- Date only: `2025-01-15` (interpreted as midnight UTC)
- With time: `2025-01-15T08:00:00Z`
- With offset: `2025-01-15T08:00:00+02:00`

Keep queries to reasonable time ranges. Most endpoints return granular data (15 min or 1 hour intervals), so querying a full year may produce very large results. Start with a day or a week.

## Reserve Types

European balancing markets use four reserve types, from fastest to slowest:

| Type | Full Name | Activation Time | Purpose |
|------|-----------|----------------|---------|
| **FCR** | Frequency Containment Reserve | ~30 seconds | Immediate frequency stabilisation |
| **aFRR** | Automatic Frequency Restoration Reserve | Minutes | Automated frequency restoration |
| **mFRR** | Manual Frequency Restoration Reserve | ~15 minutes | Manual frequency restoration |
| **RR** | Replacement Reserve | >15 minutes | Replacement of activated reserves |

Use these as `--reserve-type` values (lowercase): `fcr`, `afrr`, `mfrr`, `rr`.

## Tips

- Use `bs-cli -v <command> ...` to see progress messages during long queries.
- When comparing countries, run multiple queries and combine the results.
- For analysis, save to Parquet (`bs-cli --token $TOKEN -o data.parquet <command> ...`) and use DuckDB for efficient aggregate queries: `duckdb -c "SELECT ... FROM 'data.parquet'"`.
