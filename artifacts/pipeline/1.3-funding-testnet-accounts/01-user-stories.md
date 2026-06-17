# Stage 1 — User Stories
## Subtopic 1.3: Funding Testnet Accounts
**Source:** `documentation/sdk-usage.md` § "Funding Testnet Accounts"

---

**US-01:** As a developer, I want to fund a newly generated Stellar keypair on testnet
using `FriendBot.fundTestAccount()` so that the account receives 10,000 test XLM
and becomes usable for testnet transactions.

---

> **Scope note — single user story**
> The documentation section is intentionally short: one API call (`FriendBot.fundTestAccount`),
> one outcome (10,000 test XLM), and one constraint (testnet only). All verifiable behaviors
> derive from this single capability and are captured in its acceptance criteria (Stage 2)
> rather than as additional user stories.
>
> The mainnet constraint ("on mainnet you need an existing funded account") is a documentation
> note, not a testable API feature in a testnet test suite — it is recorded as a testability
> limitation (TL-1) rather than a separate user story.
