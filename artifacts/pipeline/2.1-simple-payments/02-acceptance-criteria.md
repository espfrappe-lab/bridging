# Stage 2 — Acceptance Criteria: 2.1 Simple Payments

---

## US-01 — Payment Operation

**AC-01.1** `PaymentOperationBuilder` accepts a valid G-address as destination, `Asset.NATIVE` as the asset, and a decimal string as the amount; `.build()` returns a non-null `PaymentOperation`.

**AC-01.2** The built `PaymentOperation` is typed as `PaymentOperation` (correct operation class).

**AC-01.3** A decimal amount string such as `"100.50"` is accepted without error (no format exception or assertion failure during build).

---

## US-02 — Transaction Building

**AC-02.1** `TransactionBuilder(sourceAccount)` accepts an `AccountResponse` as the transaction source and `.build()` returns a non-null `Transaction`.

**AC-02.2** `.addOperation(paymentOp)` places the operation in the transaction; the resulting transaction has `operations.length == 1` when one operation is added.

---

## US-03 — Signing

**AC-03.1** `transaction.sign(keyPair, Network.TESTNET)` completes without throwing; the transaction is ready for submission afterward.

---

## US-04 — Submission and Response

**AC-04.1** `sdk.submitTransaction(transaction)` is async (awaitable) and returns a `SubmitTransactionResponse`.

**AC-04.2** `response.success` is `true` for a well-formed, signed XLM payment to a funded, existing destination account.

**AC-04.3** `response.hash` is a non-null, non-empty string when the transaction succeeds.

---

## US-05 — Balance Verification

**AC-05.1** After a successful payment the recipient account is retrievable from Horizon (non-null `AccountResponse`).

**AC-05.2** The recipient's native XLM balance after receiving a FriendBot seed (≈10 000 XLM) plus a payment of 100 XLM is at least 10 100 XLM.

---

## US-06 — Memo

**AC-06.1** `.addMemo(Memo.text("..."))` attaches a text memo to the transaction without error.

**AC-06.2** A payment transaction that carries a text memo submits successfully (`response.success == true`) and returns a non-null hash.
