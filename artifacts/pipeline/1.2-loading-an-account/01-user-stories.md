# Stage 1 — User Stories
## Subtopic 1.2: Loading an Account
**Source:** `documentation/sdk-usage.md` § "Loading an Account"

---

> **Design note — test layer**
> Section 1.2 describes live Horizon network operations (`sdk.accounts.account()`).
> There is no in-process, non-network API surface to unit-test in isolation.
> The generated tests therefore follow the benchmark convention: `flutter_test`
> framework with real testnet calls, `FriendBot` setup, and a 600-second timeout.

---

**US-01:** As a developer, I want to load a Stellar account from the network so that
I can read its sequence number, which is required when building transactions.

**US-02:** As a developer, I want to iterate over a loaded account's balances and
identify the native XLM balance separately from other asset balances, so that I can
display or use each balance type correctly.

**US-03:** As a developer, I want to check whether a Stellar account exists on the
network so that I can handle the "account not yet created" case — without any
built-in helper — using only a try/catch on `ErrorResponse`.
