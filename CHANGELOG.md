# Changelog

All notable changes to the Balancing Services Agent Plugins will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed
- Require `issueApiToken` MCP tool before proceeding with any API queries
- Instruct agent to stop and ask user to authenticate if tool is unavailable, offering help finding relevant documentation
- Rename MCP tool reference from `issueApiKey` to `issueApiToken`

## [0.0.1] - 2026-02-09

### Added
- Initial Balancing Services plugin for Claude Code
- Skill for querying European electricity balancing market data via the CLI tool
- MCP server declaration for API token issuance
- Marketplace manifest for plugin discovery
- Plugin metadata (`plugin.json`) with author, homepage, and repository info

[Unreleased]: https://github.com/Balancing-Services/balancing-services-agent-plugins/compare/v0.0.1...HEAD
[0.0.1]: https://github.com/Balancing-Services/balancing-services-agent-plugins/releases/tag/v0.0.1
