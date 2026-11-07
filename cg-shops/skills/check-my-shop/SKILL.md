---
name: check-my-shop
description: Check how a CG Shops online shop that was drafted is doing, such as whether the claim form was sent, whether it is still building, or whether it is ready and at what address. Use when someone asks about the status or progress of their CG Shops shop, their claim link, or a request id.
---

# Check my shop

Use the CG Shops connector's `get_shop_status` tool. It needs the `requestId`
that `create_shop` returned. It changes nothing.

If the tool is not available, say that the CG Shops connector is not connected
yet: in Claude, open **Customize > Plugins > CG Shops > Connectors** and
connect it. Then stop.

## Find the request id

- If `create_shop` ran in this chat, use the `requestId` from its result.
- If not, ask the person for it. It is a long id like
  `b4b0a2ab-f54b-4b23-b902-0f2a42d2c39a`. Never guess one and never use one
  from another person.
- The claim page itself also shows the progress, and it updates by itself.

Answer in the person's language, with the polite form for one person ("Вие",
"Ви" with a capital letter in Bulgarian). Short, friendly sentences, no em
dashes.

## Say what the status means

Report what the tool returns. Never add to it.

- `draft`: the claim form has not been sent yet. Opening the link is not
  enough: they must fill in their name and email, accept the terms and submit.
  Remind them the link expires.
- `claimed`: the form was sent and the build is queued.
- `building`: the shop is being set up. It usually takes a few minutes. Share
  `step` if there is one.
- `ready`: the shop is live. Give `storefrontUrl` and `adminUrl`. The admin
  password is set from the "Your shop is ready" email, not here. If
  `needsAttention` lists items (for example payments), list them in plain
  words: the shop is live, but cannot take money until those are done.
- `failed`: relay `error` as it is, and offer to draft a new shop.
- `expired`: the form was not sent in time and the link has run out. Offer to
  draft the shop again (the `build-a-shop` skill).
- `suspended`: the shop is built and intact, but its storefront is closed for
  now. The owner can see why in the email CG Shops sent them, or ask CG Shops
  support at info@craftgenie.ai. Do not guess the reason and do not call it a
  failure.
- `removed`: the shop was removed and its data is being erased. Nothing can be
  rebuilt or recovered. Do not offer a new shop in the same breath.

Never say a shop is ready or live unless the status is `ready`.

## Results that are errors

- **The id is unknown or not in the right form** (a 4xx status such as 400
  or 404): read the message, and ask them to check the id.
- **429:** too many requests. Ask them to try again a little later.
- Anything else: say the status could not be read right now and offer to try
  once more.

## Questions this tool cannot answer

`get_shop_status` only knows how the build is going. For orders, products,
stock or settings of a running shop, the merchant can connect their shop's
own admin assistant to Claude (see the `connect-my-shop` skill), or use the
shop's admin.
