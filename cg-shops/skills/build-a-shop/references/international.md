# Country guide: any other country

Use this guide for a business outside Bulgaria. CG Shops can build a shop for a
business in any country. Some features are only ready for Bulgaria so far, and
this guide says which. Be open about it: tell the merchant what works today and
what does not yet, before you draft the shop.

## What works in any country

- **Country:** send the ISO code (for example `DE`, `IE`, `GB`, `US`). It sets
  the store address, the tax rate's country and the first shipping zone.
- **Currency:** the currency the merchant prices in, as an ISO code (EUR, GBP,
  USD and so on). Ask; never guess from the country or language. A currency
  the euro replaced (such as HRK) is refused: convert the prices to EUR and
  confirm them with the merchant.
- **VAT or sales tax:** the merchant's own rate, if they tell you, and whether
  their prices include it. Send `vatRate: 0` if they charge none. If they are
  not sure, leave it out: the claim page asks. Never guess a rate.
- **Products, sample catalogues and websites:** the same everywhere.
- **Cash on delivery:** can be on from the first day, for carts with
  something to ship. The merchant delivers and collects the money themselves.
- **Card payments:** Stripe and PayPal, set up later in the shop's admin
  (**Setting > Payment Setting**) with the merchant's own account. Whether
  Stripe or PayPal is available for their business is up to Stripe or PayPal.
- **Delivery:** a shop with physical products starts with one shipping zone
  for its country and a "Standard delivery" rate priced at 0. The merchant
  must set the real price in the admin. They can add zones for other
  countries in **Setting > Shipping Setting**.
- **Own domain:** any domain, connected with one DNS record (`www` CNAME to
  `domains.cgshops.com`) or by moving the nameservers.
- **The admin assistant:** run the shop by chatting with Claude (see the
  `connect-my-shop` skill).

## What is not ready outside Bulgaria yet

Say these plainly when they matter to the merchant:

- **Languages:** the storefront, shoppers' emails and legal pages are in
  **English or Bulgarian** only. A shop for German, French, Spanish or any
  other language is built in English today. The merchant can rewrite their own
  product texts and pages in the admin in any language, but the shop's built-in
  words (buttons, emails, legal pages) stay English.
- **Couriers:** the built-in courier integrations (Econt, Speedy, BOX NOW,
  Pigeon Express) deliver in Bulgaria only. Elsewhere the merchant ships with
  their own carrier and charges with the "Standard delivery" rate.
- **Bank transfer:** works with a Bulgarian IBAN only.
- **myPOS:** test mode only, anywhere.
- **Legal pages:** they cite Bulgarian law (the Bulgarian Consumer Protection
  Act) and EU consumer rules such as the 14-day withdrawal. The legal details
  form in the admin expects Bulgarian formats (company number, a BG VAT
  number). Outside Bulgaria the pages are only a starting point: the merchant
  must check and adapt them for their country, ideally with a local adviser.
- **EU sales to other EU countries:** if their sales to consumers in other EU
  countries pass the EU threshold, VAT is due at the buyer's rate. The shop
  does not do this by itself: tell them to ask their accountant.

## How to say it

Keep it short and kind. For example:

"Good news: I can draft your shop for Ireland with prices in EUR. Two things to
know first. The shop's built-in texts and emails will be in English. The
built-in couriers only work in Bulgaria for now, so you would ship with your
own carrier and set your delivery price in the admin. Shall I go ahead?"

## Next steps to tell the merchant (a shop)

After the shop is ready:

1. Add photos to the products.
2. Set the delivery price (it starts at 0), and add zones for other countries
   they ship to.
3. Turn on payments: cash on delivery, and Stripe or PayPal with their own
   account.
4. Read the legal pages and adapt them for their country.
5. Optionally connect their own domain, and the admin assistant.
