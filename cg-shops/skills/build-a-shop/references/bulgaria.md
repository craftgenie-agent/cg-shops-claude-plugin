# Country guide: Bulgaria

Bulgaria is the country CG Shops supports most completely today. Use this
guide when the business operates in Bulgaria (country code `BG`).

When you write to the person in Bulgarian, use "Вие" and "Ви" with a capital
letter for one person. Use the words below as written.

## Language

- The storefront, the shoppers' emails and the legal pages are in Bulgarian by
  default for a Bulgarian shop. English is also available.
- The admin is in the storefront's language. The merchant can switch it in
  **Setting > Store Setting > Languages**.

## Currency and VAT

- Prices are in **EUR**. BGN is refused: Bulgaria uses the euro, so convert
  lev prices to euro at the fixed rate (1 EUR = 1.95583 BGN) and confirm the
  new prices with the person. Never just change the code.
- Ask whether they are registered for VAT (ДДС).
  - Registered: ask the rate. The usual rate is 20%; send it only when they
    confirm it. Ask whether their prices already include VAT.
  - Not registered: send `vatRate: 0`.
  - Not sure: leave VAT out. The claim page asks.
- Shoppers always see prices with VAT included, as the law requires.

## Payments

- **Наложен платеж** (cash on delivery): can be on from the first day. It is
  offered only for carts with something to ship. With BOX NOW and Pigeon
  Express the courier collects in euro only.
- **Незабавен банков превод (Blink)** (instant bank transfer): the shopper pays
  from their bank app to the merchant's Bulgarian IBAN (starts with BG). No
  card fees. The merchant can give the account on the claim page or later in
  **Setting > Payment Setting**. Works for services and downloads too.
- **Stripe** (cards) and **PayPal**: set up later in **Setting > Payment
  Setting** with the merchant's own account.
- **myPOS**: test mode only for now. It takes no real payments yet. Do not
  offer it for real sales; suggest Stripe for cards.

## Couriers

The shop works with **Econt**, **Speedy**, **BOX NOW** and **Pigeon Express**.
All four deliver in Bulgaria.

- Econt: office, Econtomat or address.
- Speedy: office, automat or address.
- BOX NOW: lockers only. The merchant must set a locker price.
- Pigeon Express: office, locker or address.

The merchant enters their own courier account in **Setting > Shipping
Providers**, then offers the courier in a shipping zone in **Setting >
Shipping Setting**. Shoppers pick the office or locker at checkout.

## Legal pages

Every shop gets four pages, in Bulgarian and English: **Общи условия**
(terms), **Политика за поверителност** (privacy), **Отказ и връщане**
(withdrawal and returns, with the withdrawal form) and **Доставка и плащане**
(delivery and payment). They are written for Bulgarian law (the Consumer
Protection Act) and fill in the shop's details by themselves.

The merchant fills in **Setting > Store Setting > Legal details**: legal name
(for example "Керамика Иванова ЕООД"), ЕИК/БУЛСТАТ, VAT number (BG and 9 or 10
digits, only if VAT-registered) and registered office. The pages are a
starting point, not legal advice: the merchant should read them through.

The checkout button says **"Поръчка със задължение за плащане"** (order with
obligation to pay), as Bulgarian law requires.

## Own domain

The shop can move from `<shop>.cgshops.com` to the merchant's own domain, such
as `www.magazin.bg`, with one DNS record. For a `.bg` domain the nameservers
are changed at the registrar or at Register.BG.

## Next steps to tell a Bulgarian merchant

After the shop is ready:

1. Add photos to the products.
2. Turn on payments: Наложен платеж, Blink bank transfer, Stripe or PayPal.
3. Enter the courier account and set delivery prices.
4. Fill in the legal details and read the legal pages.
5. Optionally connect their own domain, and the admin assistant (see the
   `connect-my-shop` skill) to run the shop by chatting with Claude.
