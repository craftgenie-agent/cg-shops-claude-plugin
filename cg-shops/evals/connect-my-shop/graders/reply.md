---
type: llm
---

PASS if the reply explains these steps: in the shop's admin open Setting > AI assistants and copy the Admin address; in Claude add a custom connector with that address; sign in to the shop and approve the connection (OAuth). It must not ask for the shop password in the chat.
FAIL if it misses the AI assistants page or the custom connector step, or asks for a password.
