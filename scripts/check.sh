#!/usr/bin/env bash
# The repository's gate (see CLAUDE.md, Definition of done). Fast and free:
# no model calls. The evals are separate (claude plugin eval, costs usage).
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
err() { echo "FAIL: $*" >&2; fail=1; }

# 1. Every JSON file in the repository parses.
while IFS= read -r f; do
  jq empty "$f" 2>/dev/null || err "$f is not valid JSON"
done < <(find . -path ./.git -prune -o -path "./*/evals/results" -prune -o -type f -name '*.json' -print)

# 5. Nothing that looks like a credential, anywhere.
grep -rn -E '(sk|pk)_(live|test)_[A-Za-z0-9]{8,}|ghp_[A-Za-z0-9]{20,}|AKIA[0-9A-Z]{16}|-----BEGIN [A-Z ]*PRIVATE KEY' \
  --exclude-dir=.git --exclude-dir=results . && err "something that looks like a secret"

# Each plugin folder and its one fixed public connector URL. cg-shops-admin is
# a draft (not in the marketplace yet); it is checked the same way.
for entry in "cg-shops https://manager.cgshops.com/api/v1/mcp" "cg-shops-admin https://admin.cgshops.com/mcp"; do
  plugin=${entry% *} url=${entry#* }
  texts=$(find "$plugin" -path "$plugin/evals" -prune -o -type f \( -name '*.md' -o -name '*.json' \) -print)

  # 2. The connector is the fixed public URL, with no headers or secrets.
  jq -e --arg url "$url" '.mcpServers | to_entries | length == 1
         and (.[0].value | .type == "http" and .url == $url and (has("headers") | not))' \
    "$plugin/.mcp.json" >/dev/null || err "$plugin/.mcp.json must hold only $url, no headers"

  # 3. No em dashes in anything a user or Claude reads (brand rule).
  grep -n '—' $texts && err "em dash found (brand rule: no em dashes)"

  # 4. No CG Shops plan prices, plans or trials in the listing or the skills.
  grep -n -i -E '(€|eur|лв\.?) ?[0-9]+ ?(/|per|a|на) ?(month|year|мес|год)|[0-9]+ ?(€|eur) ?(/|per|a) ?(month|year)|free trial|безплатен пробен' $texts \
    && err "a plan price or trial is mentioned (directory listing must not show plan prices)"

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
done

# 9. CG Shops Admin says nothing about paying CG Shops, in any file it ships
#    (the zip is the whole folder, evals too). The same words the ChatGPT
#    draft's test refuses (evershop-mcp pluginPackage.test.ts), after the
#    Shop Builder review of 1.1.5.
admin_files=$(git ls-files cg-shops-admin | grep -v -E '/evals/results/|\.png$' || true)
[ -n "$admin_files" ] || admin_files=$(find cg-shops-admin -path '*/evals/results' -prune -o -type f ! -name '*.png' -print)
grep -n -i -E 'invoice|billing|subscription|free trial|upgrade|14-day|14 days|144|per year|a year|pricing' $admin_files \
  && err "cg-shops-admin mentions paying CG Shops (no invoice, billing, subscription, trial, upgrade or pricing words)"

# 10. CG Shops Admin: the owner's test cases and listing text (OWNER-STEPS
#     section 3) follow the same rules as the plugin: no paying words, no em
#     dashes. The eval graders are left out of the em dash check because the
#     no-em-dash graders hold the character as their pattern.
admin_steps=$(mktemp)
trap 'rm -f "$admin_steps"' EXIT
awk '/^## 3\. /{on=1} /^## [0-9]+\. / && !/^## 3\. /{on=0} on' docs/OWNER-STEPS.md > "$admin_steps"
[ -s "$admin_steps" ] || err "docs/OWNER-STEPS.md has no section 3 (CG Shops Admin)"
grep -n -i -E 'invoice|billing|subscription|free trial|upgrade|14-day|14 days|144|per year|a year|pricing' "$admin_steps" \
  && err "OWNER-STEPS section 3 mentions paying CG Shops"
admin_eval_texts=$(printf '%s\n' $admin_files | grep '/evals/' | grep -v '/graders/' || true)
grep -n '—' "$admin_steps" $admin_eval_texts && err "em dash in the CG Shops Admin test cases or owner steps"

# 11. CG Shops Admin names only its own 18 tools (11 read, 7 write), and they
#     match the mocked tools/list. A test case or skill that names any other
#     tool would ask the reviewer for something the connector does not have.
admin_read="search_orders get_order search_products get_product low_stock_report search_customers get_customer sales_summary sales_report list_categories list_changes"
admin_write="change_price adjust_inventory create_shipment mark_delivered mark_order_paid cancel_order undo_last_change"
admin_tools=$(printf '%s\n' $admin_read $admin_write | sort)
admin_args="confirmation_token"
tools_json=cg-shops-admin/evals/mocks/cg-shops-admin/_tools.json
[ "$(jq -r '.tools[].name' "$tools_json" | sort)" = "$admin_tools" ] \
  || err "$tools_json must list exactly the 18 plugin tools"
# Annotations: all four hints; read tools read only; only cancel_order destructive.
jq -e --arg read "$admin_read" '
  ($read | split(" ")) as $r
  | all(.tools[]; .annotations as $a
      | ($a | has("readOnlyHint") and has("destructiveHint") and has("idempotentHint") and has("openWorldHint"))
      and $a.openWorldHint == false
      and $a.readOnlyHint == (.name | IN($r[]))
      and $a.destructiveHint == (.name == "cancel_order"))' "$tools_json" >/dev/null \
  || err "$tools_json: annotations must be set on every tool (read tools read only, only cancel_order destructive, openWorldHint false)"
named=$( {
  # tool names in eval graders, mocks and history, by their full MCP name
  grep -h -o -E 'mcp__plugin_cg-shops-admin_cg-shops-admin__[a-z_]+' $admin_files "$admin_steps" | sed 's/.*__//'
  # mock files, one per tool
  printf '%s\n' $admin_files | grep '/mocks/cg-shops-admin/[a-z_]*\.md$' | sed 's#.*/##; s/\.md$//'
  # tool-like names in backticks in the skill, the README and the owner's test cases
  grep -h -o -E '`[a-z]+(_[a-z]+)+`' cg-shops-admin/skills/*/SKILL.md cg-shops-admin/README.md "$admin_steps" | tr -d '`'
} | sort -u)
for t in $named; do
  printf '%s\n' $admin_tools $admin_args | grep -qx "$t" || err "cg-shops-admin names '$t', which is not one of its tools"
done
grep -h -o -E 'mcp__[A-Za-z0-9_-]+' $admin_files "$admin_steps" | grep -v '^mcp__plugin_cg-shops-admin_cg-shops-admin__' \
  && err "cg-shops-admin test cases name a tool of another connector"

# 12. CG Shops Admin has one address. Any MCP address in its files or owner
#     steps is https://admin.cgshops.com/mcp, never a shop's own address.
grep -h -o -E 'https?://[^ )>"`'"'"']+' $admin_files "$admin_steps" \
  | grep -E 'cgshops\.com.*mcp|/mcp/?$|assistant-admin' | grep -v -x 'https://admin.cgshops.com/mcp' \
  && err "cg-shops-admin names an MCP address other than https://admin.cgshops.com/mcp"
grep -n -E 'assistant-admin\.cgshops\.com|/t/<shop>/mcp' $admin_files "$admin_steps" \
  && err "cg-shops-admin names a per-shop admin address"

# 8. Claude Code's own validation, when the CLI is here.
if command -v claude >/dev/null; then
  for plugin in cg-shops cg-shops-admin; do
    claude plugin validate "./$plugin" || err "claude plugin validate ./$plugin"
  done
  claude plugin validate . || err "claude plugin validate . (marketplace)"
else
  echo "note: claude CLI not found, skipped claude plugin validate" >&2
fi

[ "$fail" = 0 ] && echo "check.sh: all checks passed"
exit "$fail"
