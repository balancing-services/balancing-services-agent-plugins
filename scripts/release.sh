#!/bin/bash

# Release script for Balancing Services Agent Plugins
# Updates CHANGELOG.md, plugin.json, creates a commit, tags it, and pushes both.

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

cd "$(dirname "$0")/.."

REPO_URL="https://github.com/Balancing-Services/balancing-services-agent-plugins"
DRY_RUN=false

# Parse arguments
POSITIONAL_ARGS=()
for arg in "$@"; do
    case $arg in
        --dry-run) DRY_RUN=true ;;
        *) POSITIONAL_ARGS+=("$arg") ;;
    esac
done

# --- Preflight checks ---

# Must be on main
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}Error: Must be on the main branch to release (currently on '${CURRENT_BRANCH}')${NC}"
    exit 1
fi

# Working tree must be clean
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}Error: Working tree is not clean. Commit or stash changes first.${NC}"
    exit 1
fi

# Check arguments
if [ ${#POSITIONAL_ARGS[@]} -ne 1 ]; then
    echo -e "${RED}Error: Version number required${NC}"
    echo "Usage: $0 [--dry-run] <version>"
    echo "Example: $0 0.1.0"
    exit 1
fi

NEW_VERSION="${POSITIONAL_ARGS[0]}"

# Validate version format (X.Y.Z)
if ! echo "$NEW_VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    echo -e "${RED}Error: Invalid version format${NC}"
    echo "Version must be in format X.Y.Z (e.g., 0.1.0)"
    exit 1
fi

# Tag must not already exist
if git rev-parse "v${NEW_VERSION}" >/dev/null 2>&1; then
    echo -e "${RED}Error: Tag v${NEW_VERSION} already exists${NC}"
    exit 1
fi

# Get current version from plugin.json
CURRENT_VERSION=$(grep '"version"' balancing-services/.claude-plugin/plugin.json | sed 's/.*"version": *"\([^"]*\)".*/\1/')

if [ "$DRY_RUN" = true ]; then
    echo -e "${YELLOW}[DRY RUN] Releasing version ${NEW_VERSION} (current: ${CURRENT_VERSION})${NC}"
else
    echo -e "${YELLOW}Releasing version ${NEW_VERSION} (current: ${CURRENT_VERSION})${NC}"
fi
echo ""

# --- Update files ---

# Update plugin.json version
echo "Updating balancing-services/.claude-plugin/plugin.json..."
sed -i "s/\"version\": \"${CURRENT_VERSION}\"/\"version\": \"${NEW_VERSION}\"/" balancing-services/.claude-plugin/plugin.json

# Update CHANGELOG.md - stamp the [Unreleased] section with the new version and date
echo "Updating CHANGELOG.md..."
CURRENT_DATE=$(date +%Y-%m-%d)

{
    sed -n '1,/^## \[Unreleased\]/p' CHANGELOG.md
    echo ""
    echo "## [${NEW_VERSION}] - ${CURRENT_DATE}"
    sed -n '/^## \[Unreleased\]/,$p' CHANGELOG.md | tail -n +2
} > CHANGELOG.md.tmp

mv CHANGELOG.md.tmp CHANGELOG.md

# Update version comparison links
sed -i "s|\[Unreleased\]: .*|[Unreleased]: ${REPO_URL}/compare/v${NEW_VERSION}...HEAD|" CHANGELOG.md
sed -i "/^\[Unreleased\]:/a [${NEW_VERSION}]: ${REPO_URL}/compare/v${CURRENT_VERSION}...v${NEW_VERSION}" CHANGELOG.md

# --- Show diff ---

echo ""
echo "Changes:"
git diff

# --- Commit, tag, push ---

if [ "$DRY_RUN" = true ]; then
    echo ""
    echo -e "${YELLOW}[DRY RUN] Would commit, tag v${NEW_VERSION}, and push to origin${NC}"
    echo "Reverting file changes..."
    git checkout -- CHANGELOG.md balancing-services/.claude-plugin/plugin.json
    exit 0
fi

echo ""
echo "Creating commit and tag..."
git add CHANGELOG.md balancing-services/.claude-plugin/plugin.json
git commit -m "Release ${NEW_VERSION}"
git tag "v${NEW_VERSION}"

echo "Pushing commit and tag..."
git push origin main
git push origin "v${NEW_VERSION}"

echo ""
echo -e "${GREEN}✓ Released v${NEW_VERSION} successfully${NC}"
echo ""
echo "  Commit: $(git rev-parse --short HEAD)"
echo "  Tag:    v${NEW_VERSION}"
echo "  URL:    ${REPO_URL}/releases/tag/v${NEW_VERSION}"
