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
| `cg-shops-admin/` | **Draft, not submitted:** "CG Shops Admin", a merchant runs their own shop by chat through `https://admin.cgshops.com/mcp` (off until the owner turns it on; design in craftgenie-evershop-mcp `docs/adr/0001-cg-shops-admin-plugin.md`). Read-only tools, skill `run-my-shop`, 8 eval cases. Not in the marketplace file yet |
| `.claude-plugin/marketplace.json` | Lets a tester add this repository as a marketplace |
| `scripts/check.sh` | The gate: validation and text rules, for both plugin folders |
| `scripts/build-zip.sh` | The zip for **Customize > Plugins > Upload plugin** (`scripts/build-zip.sh HEAD cg-shops-admin` for the draft) |
| `docs/RESEARCH.md` | The rules and facts the plugin relies on, with sources |
| `docs/OWNER-STEPS.md` | How to test the zip and submit the plugin |

Rules for working here: [CLAUDE.md](CLAUDE.md). License: MIT.
