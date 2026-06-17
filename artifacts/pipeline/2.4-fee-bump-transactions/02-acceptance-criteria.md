# Stage 2 — Acceptance Criteria: 2.4 Fee Bump Transactions

---

## US-01 — Wrap an inner transaction in a fee bump

- **AC-01.1** `FeeBumpTransactionBuilder(innerTransaction)` accepts a pre-built, pre-signed `Transaction` as its sole constructor argument without error.
- **AC-01.2** Chaining `.setBaseFee(300).setFeeAccount(accountId).build()` on the builder returns a non-null `FeeBumpTransaction` object.

---

## US-02 — Set a valid base fee on the fee bump

- **AC-02.1** `.setBaseFee(300)` is accepted by the builder without error and applies 300 as the maximum base fee per operation.
- **AC-02.2** The documented minimum base fee constraint holds: `baseFee >= (innerBaseFeePerOp × numInnerOps) + 100`. For the documented 2-operation inner transaction at the default 100 stroops each: `100 × 2 + 100 = 300` stroops minimum.

---

## US-03 — Designate the fee payer account

- **AC-03.1** `.setFeeAccount(feePayerKeyPair.accountId)` designates the fee payer's G-address on the builder without error.

---

## US-04 — Sign the fee bump with only the fee payer

- **AC-04.1** `feeBumpTx.sign(feePayerKeyPair, Network.TESTNET)` adds the fee payer's signature to the fee bump transaction without error.
- **AC-04.2** The inner transaction is signed only by the original user (`innerTransaction.sign(userKeyPair, Network.TESTNET)`); the fee bump transaction is signed only by the fee payer — the two signing steps are independent.

---

## US-05 — Submit the fee bump transaction via its dedicated method

- **AC-05.1** `sdk.submitFeeBumpTransaction(feeBumpTx)` is the correct submission method for fee bump transactions; this is distinct from `sdk.submitTransaction()`.
- **AC-05.2** A valid fee bump transaction (inner tx signed by user, fee bump signed by fee payer, fee ≥ minimum) submitted via `sdk.submitFeeBumpTransaction()` returns `response.success == true`.
