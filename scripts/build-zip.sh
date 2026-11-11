#!/usr/bin/env bash
# Builds the upload zip for claude.ai (Customize > Plugins > Add > Upload plugin)
# from the COMMITTED plugin folder, so the zip is exactly what the directory
# would read from the repository. The zip root holds .claude-plugin/plugin.json.
# Usage: scripts/build-zip.sh [git-ref] [plugin folder]   (default HEAD cg-shops)
set -euo pipefail
cd "$(dirname "$0")/.."
ref="${1:-HEAD}"
plugin="${2:-cg-shops}"
version=$(git show "$ref:$plugin/.claude-plugin/plugin.json" | sed -n 's/^ *"version": *"\([^"]*\)".*/\1/p')
[ -n "$version" ] || { echo "no version in plugin.json at $ref" >&2; exit 1; }
mkdir -p dist
out="dist/$plugin-$version.zip"
git archive --format=zip -o "$out" "$ref:$plugin"
echo "$out"
