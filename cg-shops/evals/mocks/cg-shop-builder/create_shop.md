---
expect:
  idempotencyKey: string
  brief: string
  shopName: string
  country: /^[A-Z]{2}$/
---

HTTP 201 Created

{"requestId":"6f1c2d3e-4b5a-4c7d-8e9f-0a1b2c3d4e5f","claimUrl":"https://manager.cgshops.com/claim/7Qx2vR9mKp4LwZ8nYb3T","status":"draft","expiresAt":"2026-11-14T10:00:00Z","shopNamePreview":"{{input.shopName}}"}
