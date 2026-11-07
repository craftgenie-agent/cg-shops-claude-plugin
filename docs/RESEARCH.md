# Research notes

Read on 2026-11-07. Every fact the plugin states has a source here. When a
source changes, change the skill and this file together.

## Plugin format and directory rules

| Rule | How this repo meets it | Source |
|---|---|---|
| Manifest at `.claude-plugin/plugin.json` with `name`, `displayName`, `version`, `description`, `author`, `license` | `cg-shops/.claude-plugin/plugin.json` | [Plugin structure and testing](https://claude.com/docs/plugins/build.md) |
| Skills at `skills/<name>/SKILL.md`, folder name = `name`, description written as the user's situations | three skills; `scripts/check.sh` checks the names | same; [Skills overview](https://claude.com/docs/skills/overview.md) |
| Remote connector in `.mcp.json`, `type` `http`, absolute `https` URL, no secrets | `{"type":"http","url":"https://manager.cgshops.com/api/v1/mcp"}`, no headers | build.md; [Pre-submission checklist](https://claude.com/docs/plugins/pre-submission-checklist.md) |
| Use the same URL as the listed connector, so users with both see one set of tools | same URL as the CG Shop Builder connector | build.md, "Bundle an MCP connector" |
| README of 40+ words outside code blocks, saying what it does, how to use it, what data it sends | `cg-shops/README.md`; checked by `scripts/check.sh` | checklist, "README and license" |
| `LICENSE` file or `license` field | both, MIT | checklist |
| `name`: lowercase, digits, hyphens, distinctive, not a reserved word, never changed | `cg-shops` | checklist, "Manifest and plugin name" |
| No top-level `bin/` (claude.ai and Cowork refuse the plugin) | none | [Platform support](https://claude.com/docs/plugins/platform-support.md) |
| Only text and image files, each under 256 KiB, at most 512 files | about 40 small text files | checklist, "Files in the plugin folder" |
| Commands load as skills in chat | no commands: the skills are already `/cg-shops:build-a-shop` etc. in Claude Code, and a `/new-shop` command would only duplicate `build-a-shop` | platform-support.md |
| Submit one plugin folder; plugin path can be a subfolder | plugin path `cg-shops` | [Submit your plugin](https://claude.com/docs/plugins/submit.md) |
| Repository may be private while validating and submitting; must be public before going live | private now; the owner makes it public at publish time | submit.md, "Submit from a private repository" |
| Submit the server as an MCP connector too, and pair the two listings | CG Shop Builder connector (backend `plugin/CLAUDE-DIRECTORY.md`) | [Publish to the directory](https://claude.com/docs/directory/publish.md) |
| Marketplace file for team testing | `.claude-plugin/marketplace.json`, source `./cg-shops` | [Create a marketplace](https://code.claude.com/docs/en/plugins/create-marketplace) |
| Privacy policy link, support contact, accurate narrow descriptions, no promotional-only content, only the data the function needs | README links `https://manager.cgshops.com/privacy?lang=en`; support `info@craftgenie.ai`; no plan prices | [Software Directory Policy](https://support.claude.com/en/articles/13145358-anthropic-software-directory-policy) |
| Evals: `evals/<case>/prompt.md` + `graders/`, MCP mocks in `evals/mocks/<server>/` | 10 cases, mocks of both tools with the real `tools/list` in `_tools.json` | [Plugin evals](https://code.claude.com/docs/en/plugin-evals) |

## What the connector does

`tools/list` of `https://manager.cgshops.com/api/v1/mcp` on 2026-11-07 (saved
as `cg-shops/evals/mocks/cg-shop-builder/_tools.json`):

- `create_shop` ("Create a new shop"): write, idempotent, not destructive.
  Required: `idempotencyKey`, `brief` (40+ characters), `shopName`, `country`;
  `currency`. Optional:
  `vatRate`, `pricesIncludeVat`, `cashOnDelivery`, `timezone`, `language`,
  `requestedSlug`, `legal`, `contact`, `productHints`, `template`. Templates:
  `candles`, `ceramics`, `jewelry`, `knitwear`, `services`. Currencies the
  euro replaced are refused.
- **Shops only (owner, 2026-11-07).** The server's website mode (`mode: site`,
  templates `business`, `restaurant`) is being removed from this endpoint and
  moves to a separate future server and plugin ("CG Site Builder"). The skills
  never use it, and `_tools.json` in the evals is the 2026-11-07 `tools/list`
  with the website parts taken out. Asked for a website, Claude says this
  plugin builds online shops only and a website builder is coming separately.
- `get_shop_status` ("Check my shop"): read-only. Statuses `draft`, `claimed`,
  `building`, `ready`, `failed`, `expired`, `suspended`, `removed`.
- Production lists only these two (`SHOP_BUILDER_MCP_TOOLS`), no sign-in, about
  10 drafts an hour per calling address. Backend `plugin/README.md`,
  `plugin/CLAUDE-DIRECTORY.md`.
- The endpoint refuses shops for prohibited goods (adult, gambling, drugs,
  prescription medicines, tobacco and nicotine, weapons, spy gear, counterfeit,
  fake documents). Backend `src/main/java/.../mcp/DirectoryRules.java`.

## Facts the skills state, and their sources

Backend = `craftgenie-agent/craftgenie-shop-manager-backend` at `cd75556`.
Help = its `docs/merchant-help/en/` (and `bg/`).

| Fact | Source |
|---|---|
| Any country: `country` is any ISO 3166 code; it sets the store address, the tax rate's country and the first shipping zone | `create_shop` schema; backend `StatedFactsShopConfigGenerator` (`tax`, `shipping`) |
| Storefront, shoppers' emails and legal pages in Bulgarian or English only; other languages get English | `StatedFactsShopConfigGenerator.HOME_LANGUAGES` ("the storefront's own two", English for any other); help `first-steps.md` (legal pages "Bulgarian or English"); backend `plugin/plugin.json` translations ("only these two languages for shops, emails and legal pages") |
| Default language: Bulgarian for BG, English elsewhere | `StatedFactsShopConfigGenerator.LANGUAGE_BY_COUNTRY = {BG: bg}`, default `en` |
| Any currency the shop can be paid in; BGN, HRK and other replaced currencies refused; convert BGN at 1.95583 | `create_shop` schema `currency`; backend `gpt/INSTRUCTIONS.md`; `docs/legal/research/01-craftgenie-platform.md` |
| VAT only when stated; 0 for not registered; prices with or without VAT | schema `vatRate`, `pricesIncludeVat`; generator `tax()` comment ("A rate of 0 is what the claim page asks an owner who is not registered") |
| Shoppers see prices with VAT; "Price includes 20% VAT" example | help `products-and-images.md` |
| Cash on delivery can be on from day one, only for carts with something to ship | schema `cashOnDelivery`; help `payments.md` |
| Bank transfer (Blink): Bulgarian IBAN only | help `payments.md` ("The IBAN must be Bulgarian") |
| Stripe and PayPal set up in the admin with the merchant's own account | help `payments.md` |
| myPOS test mode only | help `payments.md` |
| Couriers Econt, Speedy, BOX NOW, Pigeon Express, all in Bulgaria; BOX NOW lockers only; COD in EUR only with BOX NOW and Pigeon Express | help `couriers.md` |
| A shop with physical products starts with one zone for its country and "Standard delivery" at 0; more zones in Setting > Shipping Setting | generator `shipping()`; help `couriers.md` |
| Four legal pages, Bulgarian and English, written for Bulgarian law (Consumer Protection Act) and EU rules | help `first-steps.md`; `craftgenie-evershop` `packages/evershop/src/modules/cms/services/defaultLegalPages.ts` |
| Legal details expect Bulgarian formats (UIC/BULSTAT, BG VAT number) | help `first-steps.md`, "Your legal details" |
| Checkout button "Поръчка със задължение за плащане" | help `bg/payments.md` |
| Sales to other EU countries over the threshold: the shop does not handle OSS | help `digital-products.md` |
| Own domain with one CNAME to `domains.cgshops.com` or by nameservers; .bg via Register.BG | help `own-domain.md` |
| Claim page asks name, email, terms; build starts on submit; link single-use and expires; "Your shop is ready" email | `create_shop` and `RequestStatus` descriptions; backend `plugin/skills/shop-builder/SKILL.md`; help `first-steps.md` |
| Admin assistant: Setting > AI assistants, Admin address, custom connector in Claude, OAuth, Approve; what it can do; confirms big changes | help `assistant.md`; `craftgenie-evershop-mcp` `packages/evershop-oauth/src/services/connectPanel.ts` (Claude guide) |
| Claude's menus: Customize > Plugins > the plugin > Connectors; Customize > Connectors > Add custom connector | build.md; backend `plugin/CLAUDE-DIRECTORY.md` (owner's test steps, 2026-11-06) |
| Data the connector receives; hash of the IP kept about an hour; conversation not seen | live privacy policy `https://manager.cgshops.com/privacy?lang=en` (names Claude and CG Shop Builder); UI `src/legal/PrivacyPage.tsx` |
| The assistant says it is an AI at the start | Terms `https://manager.cgshops.com/terms?lang=en` (UI `src/legal/TermsPage.tsx`) |
| Polite form "Вие/Ви" to one person; short interview in one message | owner, 2026-11-07, after the live connector test in claude.ai |

## Left out, on purpose

- **Imports from Shopify or WooCommerce** and photos from web addresses: the
  production endpoint does not list them (backend `plugin/README.md`, since
  plugin 1.1.5).
- **Bundling the shop's admin assistant**: each shop has its own URL and OAuth,
  so it can't be a fixed `.mcp.json` entry. `connect-my-shop` explains how the
  merchant adds it as a custom connector, as the help documents.
- **Commands**: nothing they add over the skills.
- **CI**: there is no workflow yet; `scripts/check.sh` is the gate.
