#!/usr/bin/env bash
# The repository's gate (see CLAUDE.md, Definition of done). Fast and free:
# no model calls. The evals are separate (claude plugin eval, costs usage).
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

plugin=cg-shops
texts=$(find "$plugin" -path "$plugin/evals" -prune -o -type f \( -name '*.md' -o -name '*.json' \) -print)

# 1. Every JSON file parses.
while IFS= read -r f; do
  jq empty "$f" 2>/dev/null || err "$f is not valid JSON"
done < <(find . -path ./.git -prune -o -path "./$plugin/evals/results" -prune -o -type f -name '*.json' -print)

# 2. The connector is the fixed public URL, with no headers or secrets.
jq -e '.mcpServers | to_entries | length == 1
       and (.[0].value | .type == "http" and .url == "https://manager.cgshops.com/api/v1/mcp" and (has("headers") | not))' \
  "$plugin/.mcp.json" >/dev/null || err "$plugin/.mcp.json must hold only the CG Shops http URL, no headers"

# 3. No em dashes in anything a user or Claude reads (brand rule).
grep -n '—' $texts && err "em dash found (brand rule: no em dashes)"

# 4. No CG Shops plan prices, plans or trials in the listing or the skills.
grep -n -i -E '(€|eur|лв\.?) ?[0-9]+ ?(/|per|a|на) ?(month|year|мес|год)|[0-9]+ ?(€|eur) ?(/|per|a) ?(month|year)|free trial|безплатен пробен' $texts \
  && err "a plan price or trial is mentioned (directory listing must not show plan prices)"

# 5. Nothing that looks like a credential.
grep -rn -E '(sk|pk)_(live|test)_[A-Za-z0-9]{8,}|ghp_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY' \
  --exclude-dir=.git --exclude-dir=results . && err "something that looks like a secret"

# 6. Directory checks: README of 40+ words outside code blocks, a license,
#    no OS junk files, no top-level bin/.
words=$(awk '/^```/{c=!c; next} !c' "$plugin/README.md" | wc -w)
[ "$words" -ge 40 ] || err "$plugin/README.md has $words words outside code blocks (40 needed)"
[ -f "$plugin/LICENSE" ] || jq -e '.license' "$plugin/.claude-plugin/plugin.json" >/dev/null || err "no license"
find "$plugin" \( -name .DS_Store -o -name Thumbs.db -o -name desktop.ini -o -name __MACOSX \) | grep . && err "OS junk files"
[ -e "$plugin/bin" ] && err "a top-level bin/ stops claude.ai and Cowork installing the plugin"

# 7. Every skill folder matches its name.
for s in "$plugin"/skills/*/SKILL.md; do
  d=$(basename "$(dirname "$s")")
  n=$(sed -n 's/^name: *//p' "$s" | head -1)
  [ "$d" = "$n" ] || err "$s: name '$n' does not match folder '$d'"
done

# 8. Claude Code's own validation, when the CLI is here.
if command -v claude >/dev/null; then
  claude plugin validate "./$plugin" || err "claude plugin validate ./$plugin"
  claude plugin validate . || err "claude plugin validate . (marketplace)"
else
  echo "note: claude CLI not found, skipped claude plugin validate" >&2
fi

[ "$fail" = 0 ] && echo "check.sh: all checks passed"
exit "$fail"
