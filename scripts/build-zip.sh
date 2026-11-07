#!/usr/bin/env bash
# Builds the upload zip for claude.ai (Customize > Plugins > Add > Upload plugin)
# from the COMMITTED plugin folder, so the zip is exactly what the directory
# would read from the repository. The zip root holds .claude-plugin/plugin.json.
# Usage: scripts/build-zip.sh [git-ref]   (default HEAD)
set -euo pipefail
cd "$(dirname "$0")/.."
ref="${1:-HEAD}"
version=$(git show "$ref:cg-shops/.claude-plugin/plugin.json" | sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p')
[ -n "$version" ] || { echo "no version in plugin.json at $ref" >&2; exit 1; }
mkdir -p dist
out="dist/cg-shops-$version.zip"
git archive --format=zip -o "$out" "$ref:cg-shops"
echo "$out"
