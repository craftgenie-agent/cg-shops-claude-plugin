---
name: connect-my-shop
description: Explain how a CG Shops merchant connects their own shop's admin assistant to Claude, so Claude can help run a shop that is already built, with orders, products, stock, coupons, pages and settings. Use when someone with a CG Shops shop asks Claude to manage, change or report on their shop, or asks how to connect their shop to Claude.
---

# Connect my shop to Claude

The CG Shops connector in this plugin only drafts new shops and checks their
build. It cannot see or change a shop that is already built.

Each built shop has its own **admin assistant**: a separate connector with its
own address and its own sign-in. The merchant adds it to Claude themselves. It
is not part of this plugin, because every shop has a different address.

Answer in the person's language, with the polite form for one person ("Вие",
"Ви" with a capital letter in Bulgarian). Short steps, simple words, no em
dashes.

## Steps to give the merchant

1. In the shop's admin, go to **Setting > AI assistants**.
2. Copy the **Admin** address. It looks like
   `https://<shop>-assistant-admin.cgshops.com/t/<shop>/mcp`.
3. In Claude, open **Customize > Connectors** (older versions: **Settings >
   Connectors**), choose **Add custom connector**, name it after the shop and
   paste the address. If Claude asks how to sign in, choose **OAuth**.
4. Claude opens the shop's sign-in page. Sign in, with the two-factor code if
   it is on.
5. Read the screen "Allow ... to use this shop as you?" and press **Approve**.
   Only approve a connection they started themselves, just now.
6. In a chat, turn the connector on in the tools menu and ask something real,
   such as "what were this week's orders?"

No codes or keys are needed. The **AI assistants** page in the admin has its
own step-by-step guide for Claude too.

## What it can do, once connected

Orders (find, ship, mark paid or delivered, cancel, refund), products
(create, change name, price or stock, variants), categories and collections,
customers, coupons, pages and blog posts, some settings (shop name, email,
currency, timezone), couriers, pictures, reports (sales, low stock, abandoned
carts), and moving a shop from Shopify or WooCommerce.

It acts as the merchant, with their admin access. Changes that are hard to
undo, such as a refund, a cancellation, a price change or a deletion, are
shown first and wait for the merchant to confirm in the chat.

## Good to know

- After a password change or a change to two-factor sign-in, the connection
  stops. Connect again with the same steps.
- To disconnect, press **Disconnect** under **Connected to your account** on
  the **AI assistants** page.
- A refund moves money by itself only for Stripe. For other payment methods
  the merchant pays the shopper back themselves.

Never ask for the merchant's password, two-factor code or recovery codes in
the chat. They enter them only on their shop's own sign-in page.
