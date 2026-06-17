# Stage 4 — Test Specifications: 2.4 Fee Bump Transactions

---

## TS-01.1 — FeeBumpTransactionBuilder produces a non-null FeeBumpTransaction
**Scenario:** SC-01.1 | **Criteria:** AC-01.1, AC-01.2, AC-02.1, AC-03.1

- **Objective:** Confirm that `FeeBumpTransactionBuilder` accepts a pre-signed inner `Transaction`, and that chaining `.setBaseFee(300).setFeeAccount(id).build()` returns a non-null `FeeBumpTransaction` without error.
- **Preconditions:** User account (`userKeyPair`) funded via FriendBot. Receiver account available (can use a random keypair for accountId — no need for receiver to be funded since the inner tx is not submitted here). Fee payer `KeyPair` generated (no network call needed for fee account ID).
- **Test data:**
  - Two `PaymentOperationBuilder` operations (matching docs): `"10"` XLM and `"20"` XLM to two destination addresses.
  - `baseFee = 300`; `feeAccountId = feePayerKeyPair.accountId`.
- **Steps:**
  1. Load user `AccountResponse` from Horizon.
  2. Build inner transaction with two payment operations.
  3. Sign inner transaction with `userKeyPair` on `Network.TESTNET`.
  4. Call `FeeBumpTransactionBuilder(innerTransaction).setBaseFee(300).setFeeAccount(feePayerKeyPair.accountId).build()`.
- **Assertions:**
  - Result is not null.
  - Result `isA<FeeBumpTransaction>()`.
- **Oracle:** Builder must accept any valid pre-signed inner transaction; 300 stroops and a G-address fee account are valid inputs.

---

## TS-04.1 — Fee payer signs the fee bump; signing does not throw
**Scenario:** SC-04.1 | **Criteria:** AC-04.1, AC-04.2

- **Objective:** Confirm that `feeBumpTx.sign(feePayerKeyPair, Network.TESTNET)` adds the fee payer's signature without error, and that this signing step is independent of the inner transaction's signing.
- **Preconditions:** A `FeeBumpTransaction` built as per TS-01.1; inner transaction already signed by `userKeyPair` only.
- **Test data:** Same 2-op inner transaction; `feePayerKeyPair = KeyPair.random()` (funded only for the integration test, not required here).
- **Steps:**
  1. Build `FeeBumpTransaction` as per TS-01.1 steps.
  2. Call `feeBumpTx.sign(feePayerKeyPair, Network.TESTNET)` inside `expect(..., returnsNormally)`.
- **Assertions:**
  - No exception is thrown.
- **Oracle:** Fee payer's signature must be accepted on the fee bump envelope; the inner transaction's signature by the user is separate and unaffected.

---

## TS-02.1 — Full fee bump submission: 2-op inner tx, fee payer absorbs fee, response.success == true
**Scenario:** SC-05.1 (with SC-02.1 implicitly) | **Criteria:** AC-02.2, AC-04.2, AC-05.1, AC-05.2

- **Objective:** End-to-end proof that a fee bump transaction — wrapping a 2-operation inner transaction signed by the user — submitted via `sdk.submitFeeBumpTransaction()` returns `response.success == true` when the fee payer has XLM and the base fee meets the protocol minimum.
- **Preconditions:** User, receiver 1, receiver 2, and fee payer all funded via FriendBot. User `AccountResponse` loaded.
- **Test data:**
  - Inner op 1: `PaymentOperationBuilder(dest1, Asset.NATIVE, "10").build()`
  - Inner op 2: `PaymentOperationBuilder(dest2, Asset.NATIVE, "20").build()`
  - `baseFee = 300` (minimum for 2 ops: 100×2+100=300, per documented formula — AC-02.2)
  - Fee account = `feePayerKeyPair.accountId`
- **Steps:**
  1. Load user `AccountResponse`.
  2. Build inner transaction with 2 payment operations.
  3. Sign inner transaction with `userKeyPair` (`innerTransaction.sign(userKeyPair, Network.TESTNET)`).
  4. Build fee bump: `FeeBumpTransactionBuilder(innerTransaction).setBaseFee(300).setFeeAccount(feePayer.accountId).build()`.
  5. Sign fee bump with fee payer only: `feeBumpTx.sign(feePayerKeyPair, Network.TESTNET)`.
  6. Await `sdk.submitFeeBumpTransaction(feeBumpTx)`.
- **Assertions:**
  - `response.success == true` (AC-05.2).
- **Oracle:**
  - `success == true` proves the fee payer (not the user) covered the fee (AC-04.2 implicitly: user signed inner, fee payer signed bump, submission succeeded).
  - Using `sdk.submitFeeBumpTransaction()` is the correct API call — `sdk.submitTransaction()` would not accept a `FeeBumpTransaction` (AC-05.1 implicitly validated by success).
  - `baseFee = 300` satisfies the documented formula (100 × 2 + 100 = 300, AC-02.2 positive case).

---

## Notes on AC-02.2 (Fee Formula — Negative Case)

The protocol rule `baseFee >= (inner_base_fee × inner_num_ops) + 100` could in principle be negatively tested (submit with `baseFee = 299` and expect failure). However, the docs only show the positive case and no error example is given. The positive case (TS-02.1 with `baseFee = 300`) implicitly validates the formula: the 300 value was chosen by the docs *because* it equals the minimum. A negative test (deliberate underfee → Horizon rejection) is beyond the documented scope and is not included. The formula constraint is documented, exercised in the positive path, and marked EXPANDED.
