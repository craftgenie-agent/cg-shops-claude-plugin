# CG Shops Admin (DRAFT)

> **Draft, not submitted.** The connector address `https://admin.cgshops.com/mcp`
> is switched off until the owner turns it on (design: craftgenie-evershop-mcp
> `docs/adr/0001-cg-shops-admin-plugin.md`). This plugin is not in the
> marketplace file yet. Do not install or submit it before then.

Run your [CG Shops](https://www.cgshops.com/en) shop by chatting with Claude.
CG Shops is made by Aspar Software. Ask about your shop in plain words: see
the latest orders, find a product, check what is running out, and get your
sales for any period. Ask for a small change, such as a new price, and
Claude shows it to you first and makes it only after you say yes.

## What it does

- **Orders.** Find recent, unpaid or not yet shipped orders, and read one
  order with its items, delivery and payment state.
- **Products and stock.** Find a product by name or SKU, see its price and
  stock, and list what is running low.
- **Customers.** Find a customer and read their account.
- **Sales.** Sales for today, this week, last month or any dates, with best
  sellers and a comparison with the period before.
- **AI change log.** See what an AI assistant changed in your shop.
- **Changes, with your yes.** Change a product's price or stock, mark an
  order shipped, delivered or paid, cancel an order, and undo the last
  change.

## How changes work

1. You ask, for example "Set the blue mug to 20 euros".
2. Claude shows what will change: the product or order, the value now and
   the new value. Nothing has changed yet.
3. Claude waits for your yes. Without it, nothing changes.
4. Claude makes the change and tells you what changed and how to undo it.

Every change is listed in your shop's admin under **Settings > Changes by
the AI assistant**, with who made it, from which AI app, and the values
before and after. A price or stock change can be undone, by asking Claude or
on that page. A shipment, a delivery, a payment you recorded and a cancelled
order cannot be undone there; Claude tells you this before you say yes.

Changing is asked for separately when you connect. You can allow reading
only.

## How to use it

1. Add the plugin, then connect its connector (`cg-shops-admin`) on the
   plugin's **Connectors** tab.
2. Sign in with your CG Shops account, choose your shop, and approve the
   connection on your shop's own page. Claude then acts as you, with your own
   rights in the shop. One connection is one shop.
3. In a chat, ask things like "Show me today's orders", "What is running
   out?" or "How were my sales last month?".

## What it contains

- One skill: `run-my-shop`.
- One connector: CG Shops Admin at `https://admin.cgshops.com/mcp`, run by
  Aspar Software, with 11 tools that read and 7 that change the shop
  (`change_price`, `adjust_inventory`, `create_shipment`, `mark_delivered`,
  `mark_order_paid`, `cancel_order`, `undo_last_change`). Each change waits
  for your yes.

The plugin runs no code on your computer and fetches nothing else.

## Your data

The connector sends CG Shops only what each question needs: what to search
for, an order id, a SKU or a period, and for a change, the new value (a
price, a stock count, a carrier and tracking number, a reason to cancel).
The answers come from your own shop: orders, products, stock, customers and
sales. Each change is kept in your shop's AI change log. CG Shops keeps
who connected, to which shop, from which AI app and when, until you
disconnect. It never receives your chat history, memory or files. You can
disconnect in Claude or in your shop's admin under **AI assistants**.

Privacy policy: <https://manager.cgshops.com/privacy?lang=en>.
Terms: <https://manager.cgshops.com/terms?lang=en>.

## Support

Email **info@craftgenie.ai**, or see <https://www.cgshops.com/en>.

## На български

С този плъгин питате Claude за магазина си в CG Shops: поръчки, продукти,
наличности, клиенти и продажби. Влизате с профила си в CG Shops, избирате
магазина и одобрявате връзката на страницата на магазина. Claude може да
промени цена или наличност, да отбележи поръчка като изпратена, доставена
или платена и да анулира поръчка. Преди всяка промяна Ви показва какво ще
се промени и чака Вашето "да". Всяка промяна се вижда в администрацията на
магазина, а промяна на цена или наличност може да бъде отменена.

## License

MIT. See [LICENSE](LICENSE).
