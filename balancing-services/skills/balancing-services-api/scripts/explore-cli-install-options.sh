#!/bin/bash

# Explores what options are available for installing the Balancing Services CLI.
# This script is whitelisted in the skill's allowed-tools so it can run without
# manual approval.

set -e

PKG="balancing-services-cli"

# --- Check if bs-cli is already installed ---

if command -v bs-cli &>/dev/null; then
    INSTALLED_VERSION=$(bs-cli --version 2>/dev/null || echo "unknown")
    echo "bs-cli is already installed: ${INSTALLED_VERSION}"
    echo "  Location: $(command -v bs-cli)"
    echo ""
fi

# --- Discover available package managers ---

HAS_UV=false
HAS_UVX_ONLY=false
HAS_PIPX=false
HAS_PIP=""

if command -v uv &>/dev/null; then
    HAS_UV=true
elif command -v uvx &>/dev/null; then
    HAS_UVX_ONLY=true
fi

if command -v pipx &>/dev/null; then
    HAS_PIPX=true
fi

for cmd in pip3 pip; do
    if command -v "$cmd" &>/dev/null; then
        HAS_PIP="$cmd"
        break
    fi
done

if [ "$HAS_UV" = false ] && [ "$HAS_UVX_ONLY" = false ] && [ "$HAS_PIPX" = false ] && [ -z "$HAS_PIP" ]; then
    echo "No supported Python package manager found (uv, pipx, pip3, pip)."
    echo ""
    echo "Ask the user to install one of the following:"
    echo "  - uv:   https://docs.astral.sh/uv/getting-started/installation/"
    echo "  - pipx: https://pipx.pypa.io/stable/installation/"
    echo "  - pip:  usually bundled with Python (https://www.python.org/)"
    exit 0
fi

# --- Print install commands ---

echo "=== Available Install Methods ==="
echo ""

if [ "$HAS_UV" = true ]; then
    UV_VERSION=$(uv --version 2>/dev/null || echo "unknown")
    echo "[uv] ${UV_VERSION}"
    echo "  Install:  uv tool install ${PKG}"
    echo "  Upgrade:  uv tool install --upgrade ${PKG}"
    echo "  Run once: uvx --from ${PKG} bs-cli --help"
    echo ""
elif [ "$HAS_UVX_ONLY" = true ]; then
    echo "[uvx] available (uv not found separately)"
    echo "  Run once: uvx --from ${PKG} bs-cli --help"
    echo ""
fi

if [ "$HAS_PIPX" = true ]; then
    PIPX_VERSION=$(pipx --version 2>/dev/null || echo "unknown")
    echo "[pipx] ${PIPX_VERSION}"
    echo "  Install: pipx install ${PKG}"
    echo "  Upgrade: pipx upgrade ${PKG}"
    echo ""
fi

if [ -n "$HAS_PIP" ]; then
    PIP_VERSION=$("$HAS_PIP" --version 2>/dev/null || echo "unknown")
    echo "[${HAS_PIP}] ${PIP_VERSION} (installs globally — prefer uv or pipx)"
    echo "  Install: ${HAS_PIP} install ${PKG}"
    echo "  Upgrade: ${HAS_PIP} install --upgrade ${PKG}"
    echo ""
fi
