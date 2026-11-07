# CG Shops plugin for Claude

The CG Shops plugin for Claude, by Aspar Software. It helps a merchant in any
country build an online shop on CG Shops from a
conversation with Claude, and check how the shop is doing.

The plugin itself is the [`cg-shops/`](cg-shops/) folder. Its
[README](cg-shops/README.md) is the directory listing's description.

| Path | What it is |
|---|---|
| `cg-shops/.claude-plugin/plugin.json` | The manifest (`name` `cg-shops`, display name "CG Shops") |
| `cg-shops/.mcp.json` | The CG Shops connector, `https://manager.cgshops.com/api/v1/mcp` |
| `cg-shops/skills/` | `build-a-shop` (with country guides), `check-my-shop`, `connect-my-shop` |
| `cg-shops/evals/` | Eval cases for `claude plugin eval`, with mocks of the two tools |
| `.claude-plugin/marketplace.json` | Lets a tester add this repository as a marketplace |
| `scripts/check.sh` | The gate: validation and text rules |
| `scripts/build-zip.sh` | The zip for **Customize > Plugins > Upload plugin** |
| `docs/RESEARCH.md` | The rules and facts the plugin relies on, with sources |
| `docs/OWNER-STEPS.md` | How to test the zip and submit the plugin |

Rules for working here: [CLAUDE.md](CLAUDE.md). License: MIT.
