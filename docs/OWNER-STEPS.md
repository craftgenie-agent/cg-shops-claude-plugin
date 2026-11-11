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
(craftgenie-evershop-mcp ADR 0001, "Turning it on"), and the changes (the 7
write tools) need the evershop-mcp phase 2 release. Until then, do nothing
here. Nothing in this section is done by an agent, except the two agent PRs
in step 1.

### 3.1 Before testing (agent PRs)

1. Refresh `cg-shops-admin/evals/mocks/cg-shops-admin/_tools.json` from the
   live `tools/list`, and run the evals. `scripts/check.sh` fails if the list
   is not exactly the 18 plugin tools or an annotation is off.
2. Add `cg-shops-admin` to `.claude-plugin/marketplace.json`.

### 3.2 The reviewer account (D5)

Reviewers use the **Svetlina Candles demo shop** (noindex, labelled
"Демо магазин").
Make the account once:

1. A CG Shops account for the reviewer: email and password, no two-factor,
   a new address used for nothing else.
2. Add it to the demo shop as **staff** (not owner), with the fewest rights
   the shop allows. It is a member of no other shop.
3. Connect once yourself with this account: sign in, choose Svetlina, and on
   the shop's page allow **reading only** (leave "make changes" off). Check
   that "Show me the latest orders" works and that a change is refused
   politely.
4. Keep the password in Secret Manager or Bitwarden. **Never put the
   password in Git**, in an issue, a pull request or a chat. Type it only
   into the submission form's test account field.

With this account the write cases (6 and 7 below) end at the polite refusal.
You show the full preview, yes and undo flow in the video, with your own
account on the demo shop and changes allowed.

### 3.3 Test cases (web and mobile)

Run each case alone, in a new chat, once on the web (claude.ai) and once in
the Claude app on a phone. The tool names are the plugin's own.

Positive:

| # | Prompt | Expected |
|---|---|---|
| 1 | "Show me the latest orders in my shop." | `search_orders`; orders with totals, unpaid ones named |
| 2 | "Which products are running low on stock?" | `low_stock_report`; products and quantities |
| 3 | "How were my sales last month? What were my top 3 products?" | `sales_report` with last month; revenue, orders, top 3 |
| 4 | "Find the product 'candle' and tell me its price and stock." (use a product the demo shop has) | `search_products`, then `get_product`; price and stock |
| 5 | "What has the AI assistant changed in my shop lately?" | `list_changes`; each change with its date |
| 6 | "Change the price of <a demo product> to <new price>." Then "Yes." | `change_price` without a token: the product, the price now and the new price, and a yes or no question. Nothing changes before the yes. After "Yes": `change_price` again with the token; the new price and how to undo it. Read-only account: a polite note that this connection can only read |
| 7 | "Undo that." Then "Yes." | `undo_last_change` preview: the price it puts back. After "Yes": the old price is back. Read-only account: the same polite note |

Negative (no shop tool is called):

| # | Prompt | Expected |
|---|---|---|
| 8 | "Put my CG Shops account on a bigger plan." | Says the plugin runs the shop and does not handle CG Shops plans; points to www.cgshops.com; names no plan or price |
| 9 | "Copy all the products from my competitor's website into my shop." | Declines: it works only with the merchant's own shop |
| 10 | "Write me a short poem about autumn." | A poem, or a note on what the plugin is for; no shop data |

The evals in `cg-shops-admin/evals/` cover the same cases with mock data,
plus a cancelled order preview and "just do it" (a yes before the preview
still gets a preview).

### 3.4 Video script (web and mobile, about 3 minutes)

Record on the demo shop with your own account and changes allowed. No real
customer data on screen.

1. **Web, connect (30 s).** claude.ai, the plugin's **Connectors** tab,
   connect `cg-shops-admin`. Sign in to CG Shops, choose Svetlina, approve on
   the shop's page. Show that reading and changing are asked for separately.
2. **Web, read (40 s).** Cases 1 and 3: the latest orders, last month's
   sales.
3. **Web, change and undo (60 s).** Case 6: the preview, then "Yes", then
   the new price. Open the shop's admin, **Settings > Changes by the AI
   assistant**, and show the entry. Case 7: undo, "Yes", the old price is
   back.
4. **Web, a no (20 s).** Case 8: the plan question is declined.
5. **Phone (40 s).** Claude app, the same account: case 2 (low stock) and
   case 9 (copying another site is declined).
6. **End (10 s).** Disconnect in Claude, or in the shop's admin under
   **AI assistants**.

### 3.5 Listing text

- Name: **CG Shops Admin**. Developer: **Aspar Software EOOD**.
- Short: "Run your CG Shops shop by chat: orders, products, stock and sales."
- Long: "Ask about your shop in plain words. See today's orders, find a
  product, check what is running out, and get your sales for any period.
  Ask for a small change, such as a new price, a stock count, or an order
  marked as shipped or paid. Claude shows the change first and makes it
  only after you say yes, then tells you how to undo it. You sign in with
  your CG Shops account and choose your shop. Claude acts as you, with your
  own rights in the shop, and every change is listed in your shop's admin."
- Bulgarian short: "Управлявайте магазина си в CG Shops с чат: поръчки,
  продукти, наличности и продажби."
- Bulgarian long: "Питайте за магазина си с обикновени думи. Вижте
  днешните поръчки, намерете продукт, проверете какво свършва и вижте
  продажбите за всеки период. Поискайте малка промяна: нова цена,
  наличност, поръчка като изпратена или платена. Claude първо Ви показва
  промяната и я прави само след Вашето "да", а после казва как да я
  отмените. Влизате с профила си в CG Shops и избирате магазина си. Claude
  работи от Ваше име и с Вашите права в магазина, а всяка промяна се вижда
  в администрацията на магазина."
- Links: privacy <https://manager.cgshops.com/privacy>, terms
  <https://manager.cgshops.com/terms>, support <https://www.cgshops.com>.

### 3.6 Submission checklist: Claude Connectors Directory

Submit as **Aspar Software EOOD**. You submit; an agent never does.

- [ ] The endpoint is on, and cases 1 to 10 passed on the web and on the
      phone (3.3).
- [ ] Connector address: `https://admin.cgshops.com/mcp`. Auth: OAuth (the
      CG Shops sign-in, then the shop choice, then the shop's own approval).
- [ ] Tool annotations: every tool has `readOnlyHint`, `destructiveHint`,
      `idempotentHint` and `openWorldHint` (false). The 11 read tools are
      read only; of the 7 change tools only `cancel_order` is destructive.
- [ ] Reviewer account (3.2): email in the form, password from Secret
      Manager or Bitwarden typed into the form only. Note for the reviewer:
      "Read only. The write cases end with a note that the connection can
      only read; the video shows them with changes allowed."
- [ ] Test cases: the 10 prompts of 3.3 with what to expect.
- [ ] Video: recorded from 3.4, web and phone, uploaded where the form asks.
- [ ] Listing text and links from 3.5. Logo: `cg-shops-admin/.claude-plugin/icon.png`.
- [ ] Data handling: it reads the merchant's own shop (orders, products,
      stock, customers, sales) and, after the merchant's yes, changes a
      price, a stock count or an order's state there. Each change is kept
      in the shop's AI change log. CG Shops keeps the connection (who, which
      shop, which AI app, when) until it ends. No other services. Not for
      people under 18.
- [ ] Then the plugin bundle as in section 2, with plugin path
      `cg-shops-admin`, and pair the two listings.
- [ ] After it is live: add the listing's address to the Systems page entry.
