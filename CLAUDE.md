# Repository rules

The CG Shops plugin for Claude (`cg-shops`, display name "CG Shops", publisher
Aspar Software). The plugin folder is `cg-shops/`; that folder is what users
install and what Anthropic's directory reads. Everything else here (this file,
`scripts/`, `docs/`, the marketplace file) is for us.

## How we work

- **Branches in worktrees.** Every change is a branch in its own git worktree
  under `/home/trifon/workspace-craftgenie-evershop/worktrees/`, from
  `origin/main`, with a pull request. Never commit to `main`, never switch a
  main checkout to a branch, never run commands in another repo's main
  checkout.
- **Never merge, publish, submit, tag or release, and never make the repository
  public.** The owner does those. The repository must be public before the
  directory listing goes live; the owner flips it at publish time.
- **Codex review loop** (workspace `AGENTS.md`): request `@codex review`, wait,
  check each finding against the code, fix the valid ones, reply
  `Valid. Resolving.` or `Invalid. <reason>`, resolve every thread, request
  again. Ready means the latest Codex result on the head is clean, no thread
  is open, and the gate below passed on that head.
- **Commits** end with the `Co-Authored-By` trailer; PR bodies with the Claude
  Code line.

## What the plugin may say

- **International, not Bulgaria-only.** CG Shops is for businesses in any
  country. Skills are country-neutral; country details live in
  `cg-shops/skills/build-a-shop/references/` (`bulgaria.md`,
  `international.md`). Add a country guide only when the platform has
  something specific for that country.
- **Only verified facts.** Never write that a country, language, currency,
  courier, payment method or feature works unless the production code or the
  merchant help (`craftgenie-shop-manager-backend/docs/merchant-help/`) shows
  it. Where it is not ready, the skill must say so. Note the source in
  `docs/RESEARCH.md` when you add a fact.
- **No CG Shops plan prices, plans or trials** anywhere in the plugin. Plans
  are on www.cgshops.com.
- **Texts:** simple words, short sentences, friendly. No em dashes. In
  Bulgarian, "Вие"/"Ви" with a capital letter to one person.
- **No secrets.** `.mcp.json` holds only the public URL
  `https://manager.cgshops.com/api/v1/mcp`. No keys, tokens or headers, in any
  file, examples included.
- **Directory rules** (`docs/RESEARCH.md` has the sources): the `name` never
  changes; raise `version` in `plugin.json` on every release; README of 40+
  words that says what the plugin sends; a license; no `bin/`; no binary files
  other than images; nothing outside `cg-shops/` that the plugin needs.

## Definition of done

Run from the repo root, in order:

```bash
scripts/check.sh                       # JSON, connector URL, no em dashes, no prices,
                                       # no secrets, README length, claude plugin validate
(cd cg-shops && claude plugin eval . --trust-plugin --no-publish -j 4)
                                       # when a skill or eval changed; uses model calls
scripts/build-zip.sh                   # after committing: dist/cg-shops-<version>.zip
```

There is no CI: `scripts/check.sh` is the gate, and the PR says that it ran and
what the eval summary was.
