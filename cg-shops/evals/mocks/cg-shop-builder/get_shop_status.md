---
expect:
  requestId: /^[0-9a-f-]{36}$/
---

HTTP 200 OK

{"requestId":"{{input.requestId}}","status":"expired"}
