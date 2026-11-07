# CG Shops

Build an online shop on [CG Shops](https://www.cgshops.com/en) by talking
with Claude. CG Shops is made by Aspar Software. It works for
businesses in any country. Shops are built in English or Bulgarian today.

## What it does

- **Build a shop.** Tell Claude what you sell, the shop's name, your country
  and currency, and your products and prices. Or ask for a few suggested
  products, or a sample catalogue to replace later. Claude asks the few
  questions it needs in one message, drafts the shop and gives you a link to a
  CG Shops page. There you check the draft, enter your name and email and
  accept the terms. Nothing is built until you send that form.
- **Check your shop.** Ask how your shop is doing. Claude reads the build
  status and tells you when it is ready, with its address.
- **Run your shop with Claude.** Once your shop is built, Claude explains how
  to connect your shop's own admin assistant, so you can work with orders,
  products and settings by chatting. That assistant has its own address and
  sign-in for each shop, and you add it yourself.

The plugin builds online shops only. A separate website builder is coming.
Claude tells you honestly what works in your country and what does not yet.
For example, the built-in couriers deliver in Bulgaria only so far.

## How to use it

1. Add the plugin, then connect its connector (`cg-shop-builder`) on the
   plugin's **Connectors** tab. No account or sign-in is needed.
2. In a chat, say something like:
   - "I want to sell handmade candles online. My shop is called Rila Candle
     Studio, in Bulgaria, prices in EUR."
   - "Make a shop for my ceramics in Ireland, prices in EUR: mug 18, bowl 22,
     vase 48."
   - "I offer yoga classes in Berlin. Make me a shop to sell class passes,
     prices in EUR."
   - "How is my CG Shops request doing?"
3. Open the link Claude gives you and send the form there.

In Claude Code you can also install it from its repository:

```
/plugin install cg-shops --marketplace craftgenie-agent/cg-shops-claude-plugin
```

## What it contains

- Three skills: `build-a-shop`, `check-my-shop` and `connect-my-shop`.
- One connector: the CG Shops shop builder at
  `https://manager.cgshops.com/api/v1/mcp`, run by Aspar Software. It has two
  tools: draft a new shop, and read the status of a drafted shop.

The plugin runs no code on your computer and fetches nothing else.

## Your data

When Claude drafts a shop, the connector sends to CG Shops only what the shop
needs: the description of your business, the shop's name, country, currency,
products and prices, and any VAT, contact or company details you choose to
give for the shop's pages. To check a shop it sends the request id. CG Shops
also keeps a hash of the calling IP address for about an hour, to limit how
many shops one caller can draft. CG Shops never receives your chat history,
memory or files. Your name and email are given only on the CG Shops page,
never in the chat.

Privacy policy: <https://manager.cgshops.com/privacy?lang=en>.
Terms: <https://manager.cgshops.com/terms?lang=en>.

## Support

Email **info@craftgenie.ai**, or see <https://www.cgshops.com/en>.

## На български

С този плъгин Claude Ви помага да създадете онлайн магазин в CG Shops. Кажете какво продавате, името на магазина, държавата, валутата и
продуктите с цените. Claude задава няколко въпроса наведнъж, подготвя проект и
Ви дава линк към страница на CG Shops. Там проверявате проекта, въвеждате име и
имейл и приемате условията. Нищо не се изгражда, преди да изпратите формуляра.
По-късно можете да попитате Claude докъде е стигнал магазинът Ви.

Магазините се правят на български или английски. За България има наложен
платеж, незабавен банков превод, Еконт, Спиди, BOX NOW и Pigeon Express.
Поверителност: <https://manager.cgshops.com/privacy>. Помощ: info@craftgenie.ai.

## License

MIT. See [LICENSE](LICENSE).
