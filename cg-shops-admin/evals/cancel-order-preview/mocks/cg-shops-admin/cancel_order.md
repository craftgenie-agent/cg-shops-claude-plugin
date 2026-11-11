---
expect:
  order_id: a1f3c2d4-1111-4c1e-9a1b-000000000101
  reason: string
---

This change has NOT been made yet. It needs confirming.

Cancel order a1f3c2d4-1111-4c1e-9a1b-000000000101? Its customer and total are shown below.

{
  "reason": "{{input.reason}}",
  "theShopSays": "<<shop text>>{\"order\":\"1042\",\"customer\":\"maria@example.com\",\"total\":\"58.00 EUR\",\"currentStatus\":\"New\"}<</shop text>>"
}

To proceed, call this tool again with identical arguments plus confirmation_token: "cnf_cancel_1042"
The confirmation expires at 2026-11-11T10:25:00.000Z, is valid once, and only for exactly these arguments.
