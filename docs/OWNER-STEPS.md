# Owner steps: test, then submit

Account: aspar.software (paid Claude plan). Nothing here is done by an agent.

## 1. Test with the zip

1. Get the zip: `scripts/build-zip.sh` writes `dist/cg-shops-<version>.zip`
   from the committed `cg-shops/` folder (the zip root holds
   `.claude-plugin/plugin.json`).
2. claude.ai: **Customize > Plugins > Add > Upload plugin**, choose the zip.
3. Open the plugin's **Connectors** tab and connect `cg-shop-builder` (no
   sign-in). If CG Shop Builder is already added as a custom connector, you
   will see the tools twice; remove the custom one while testing.
4. **Settings > Capabilities**: "Code execution and file creation" must be on
   for skills.
5. New chat. Ask "Which skills do you have from plugins?" It should name
   `build-a-shop`, `check-my-shop` and `connect-my-shop`.
6. Try these, on the web and on the phone:
   - "Искам онлайн магазин за ръчно направени свещи. Казва се Рила Свещи, в
     България, цени в евро. Предложете 3 свещи." Expect: Bulgarian with
     Вие/Ви, one call, the claim link, "nothing is built until you send the
     form".
   - "I make leather wallets in Cork, Ireland. Shop Lee Leather, EUR, VAT 23%
     included: bifold 45, card holder 25." Expect: drafted with country IE,
     and an honest note that couriers and bank transfer are Bulgaria-only for
     now.
   - "Je voudrais une boutique en ligne en français pour mes bijoux." Expect:
     French with vous, all questions in one message, a note that the shop's
     texts would be English.
   - "How is my CG Shops request <requestId from above> doing?" Expect:
     `draft`.
   - "My shop is live. How can Claude manage my orders?" Expect: the AI
     assistants steps.
   Do not submit the claim forms; unclaimed drafts expire.
7. Optional, Claude Code: `claude --plugin-dir ./cg-shops` from the repo root.

## 2. Submit (after the test passes)

Before: the CG Shop Builder connector submission (backend
`plugin/CLAUDE-DIRECTORY.md`) should be in, so the two listings can be paired.

1. Connect GitHub on claude.ai (same organization you submit from), and
   install the Claude GitHub App on `craftgenie-agent/cg-shops-claude-plugin`.
2. `https://claude.ai/directory/manage` > **Submit new** > **Plugin bundle**.
3. **Source**: repository `craftgenie-agent/cg-shops-claude-plugin`, plugin
   path `cg-shops`, branch `main`. Agree to the private source upload.
   **Validate**, fix any **Blocking** finding, validate again.
4. **Listing details**: read from `plugin.json` and the README. Check them.
5. **Data handling**:
   - Reads or stores personal data: only what the merchant chooses to give for
     the shop's public pages (business contact and company details) goes to
     CG Shops' own server; the owner's name and email are given on the CG Shops
     page, not in the chat. A SHA-256 hash of the calling address is kept
     about an hour for rate limits.
   - Sends data to services other than its declared connector: no.
   - Retention: an unclaimed draft expires; see the privacy policy.
   - Intended for people under 18: no.
6. **Compliance**: contact `info@craftgenie.ai` (or the owner's), tick the four
   acknowledgements.
7. **Review and submit**: keep "GitHub push webhook", leave auto-publish off,
   **Submit for review**.
8. When it passes: make the repository **public**, then **Check for new
   commits**, then **Publish**.
9. After it is live: pair it with the CG Shop Builder connector listing, and
   add the listing's address to the Systems page entry.

Every later release: raise `version` in `cg-shops/.claude-plugin/plugin.json`
and merge to `main`; the directory scans the new commit.

## 3. CG Shops Admin (`cg-shops-admin`): later, after the endpoint is on

The draft plugin needs `https://admin.cgshops.com/mcp` switched on first
(craftgenie-evershop-mcp ADR 0001, "Turning it on"). Until then, do nothing
here.

1. Refresh `cg-shops-admin/evals/mocks/cg-shops-admin/_tools.json` from the
   live `tools/list` (agent PR), and run the evals.
2. Add `cg-shops-admin` to `.claude-plugin/marketplace.json` (agent PR).
3. Test: `scripts/build-zip.sh HEAD cg-shops-admin`, upload the zip, connect
   `cg-shops-admin`, sign in with the demo shop's reviewer account (staff,
   email and password, no two-factor), choose the demo shop, approve on the
   shop's page. On the web and on the phone, try the 5 positive cases of the
   ADR ("Show me today's orders in my shop.", "Which products are running low
   on stock?", "How were my sales last month? Top 3 products?", "Find the
   product 'ceramic mug' and tell me its price and stock.", "What did the AI
   assistant change in my shop this week?") and the 3 negative ones ("Put my
   CG Shops account on a bigger plan.", "Copy all products from another shop's website into
   mine.", "Write me a poem about autumn.").
4. Submit the connector `https://admin.cgshops.com/mcp` to the Connectors
   Directory as Aspar Software EOOD (OAuth; the reviewer account above), then
   the plugin bundle as in section 2 with plugin path `cg-shops-admin`, and
   pair the two listings.
5. Data handling: it reads the merchant's own shop (orders, products, stock,
   customers, sales); CG Shops keeps the connection (who, which shop, which
   AI app, when) until it ends; no other services; not for people under 18.
