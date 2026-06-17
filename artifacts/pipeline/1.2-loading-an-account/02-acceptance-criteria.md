# Stage 2 — Acceptance Criteria
## Subtopic 1.2: Loading an Account
**Source:** `documentation/sdk-usage.md` § "Loading an Account"

IDs carry forward from Stage 1. Each criterion is observable and verifiable
from the documentation alone.

---

## US-01 — Load a Stellar account from the network

**AC-01.1** `sdk.accounts.account(accountId)` shall return an `AccountResponse` object
for a valid, funded account.

**AC-01.2** The returned `AccountResponse` shall expose a `sequenceNumber` property.

**AC-01.3** `sequenceNumber` shall not be null for a funded account.

**AC-01.4** `sequenceNumber` shall be representable as an integer, since the
documentation states it is "required when building transactions" (a non-numeric
value would be unusable).

**AC-01.5** The API shall be asynchronous (the call must be `await`-able).

---

## US-02 — Iterate and inspect balances

**AC-02.1** `AccountResponse` shall expose a `balances` property that is iterable.

**AC-02.2** Each `Balance` object in the list shall expose an `assetType` property.

**AC-02.3** Each `Balance` object shall expose a `balance` property (the amount as
a string, based on the `double.parse()` usage in the doc snippet).

**AC-02.4** The expression `balance.assetType == Asset.TYPE_NATIVE` shall evaluate
to `true` for exactly the native XLM balance entry.

**AC-02.5** Non-native balance entries shall expose an `assetCode` property
(shown in the `else` branch of the doc's example loop).
*(See AMB-1 — this path requires a trustline and cannot be exercised with a
freshly funded account; covered structurally only.)*

**AC-02.6** A freshly FriendBot-funded account shall contain at least one
native balance entry.

**AC-02.7** The native balance's `balance` field shall be parseable as a `double`
and greater than zero.

---

## US-03 — Check account existence via try/catch

**AC-03.1** For a non-existent account, `sdk.accounts.account(accountId)` shall
throw an `ErrorResponse`.

**AC-03.2** The thrown `ErrorResponse` shall have `code == 404`.

**AC-03.3** Wrapping the call in `try { … } on ErrorResponse catch (e) { if (e.code == 404) exists = false; }`
is the correct and sufficient pattern for determining non-existence (the documentation
explicitly states "no built-in helper — use try/catch").

**AC-03.4** For an existing, funded account the same try/catch block shall not
catch an `ErrorResponse`, leaving `exists == true`.

---

## Ambiguities flagged

**AMB-1:** The documentation shows `balance.assetCode` accessed in the `else`
branch of the balance loop, but a freshly funded account carries only XLM (no
non-native balances). The `assetCode` assertion cannot be exercised without
creating a trustline — an operation beyond this subtopic's scope. The generated
test will verify the field is accessible on each entry without asserting a value.

**AMB-2:** The type of `AccountResponse.sequenceNumber` is not stated in the
documentation. The doc shows it printed via string interpolation. The generated
test infers that it must be integer-parseable from the stated purpose ("required
when building transactions") and validates accordingly.
