# Stage 4 — Test Specifications: 2.2 Multi-Operation Transactions

---

## TS-01.1 — CreateAccountOperation builder
**Scenario:** SC-01.1 | **Criteria:** AC-01.1, AC-01.2

- **Objective:** Confirm `CreateAccountOperationBuilder` accepts a G-address destination and a starting balance string, and returns a non-null, correctly-typed operation.
- **Preconditions:** None — no network call required.
- **Test data:** `newAccountId` = any `KeyPair.random().accountId`; startingBalance = `"5"`.
- **Steps:**
  1. Call `CreateAccountOperationBuilder(newAccountId, "5").build()`.
- **Assertions:**
  - Result is not null.
  - Result `isA<CreateAccountOperation>()`.
- **Oracle:** No `FormatException` or assertion error (AC-01.2 string acceptance).

---

## TS-02.1 — ChangeTrustOperation builder with custom source account
**Scenario:** SC-02.1 | **Criteria:** AC-02.1, AC-02.2, AC-02.3

- **Objective:** Confirm that `ChangeTrustOperationBuilder` with `setSourceAccount` produces a valid trustline operation targeting the new account as the source.
- **Preconditions:** None — no network call required.
- **Test data:** `usdAsset` = `AssetTypeCreditAlphaNum4("USD", issuerKeyPair.accountId)`; `newAccountId` = `KeyPair.random().accountId`; limit = `"10000"`.
- **Steps:**
  1. Build `ChangeTrustOperationBuilder(usdAsset, "10000").setSourceAccount(newAccountId).build()`.
- **Assertions:**
  - Result is not null.
  - Result `isA<ChangeTrustOperation>()`.
- **Oracle:** `setSourceAccount` accepted without error; limit string `"10000"` accepted (AC-02.2, AC-02.3).

---

## TS-03.1 — PaymentOperation builder for a custom asset
**Scenario:** SC-03.1 | **Criteria:** AC-03.1

- **Objective:** Confirm `PaymentOperationBuilder` accepts a custom `AssetTypeCreditAlphaNum4` asset and returns a non-null `PaymentOperation`.
- **Preconditions:** None.
- **Test data:** `usdAsset` = `AssetTypeCreditAlphaNum4("USD", issuerKeyPair.accountId)`; `newAccountId` = `KeyPair.random().accountId`; amount = `"100"`.
- **Steps:**
  1. Call `PaymentOperationBuilder(newAccountId, usdAsset, "100").build()`.
- **Assertions:**
  - Result is not null.
  - Result `isA<PaymentOperation>()`.

---

## TS-04.1 — Transaction bundles all three operations
**Scenario:** SC-04.1 | **Criteria:** AC-04.1, AC-04.2

- **Objective:** Verify that chaining three `addOperation()` calls produces a transaction with exactly three operations.
- **Preconditions:** Funder `AccountResponse` loaded from Horizon.
- **Test data:** Same three operations as TS-01.1, TS-02.1, TS-03.1.
- **Steps:**
  1. Load funder `AccountResponse`.
  2. Build all three operations.
  3. Call `TransactionBuilder(funder).addOperation(createOp).addOperation(trustOp).addOperation(paymentOp).build()`.
- **Assertions:**
  - Transaction is not null.
  - `transaction.operations.length == 3`.

---

## TS-05.1 — Multi-signature: two signers on one transaction
**Scenario:** SC-05.1 | **Criteria:** AC-05.1, AC-05.2

- **Objective:** Confirm that calling `.sign()` twice with different keypairs on the same transaction does not throw.
- **Preconditions:** Built transaction with at least one operation.
- **Test data:** `issuerKeyPair` (funder) and `newAccountKeyPair`.
- **Steps:**
  1. Build a two-operation transaction (create + trustline, sufficient to require two signers).
  2. Call `tx.sign(issuerKeyPair, Network.TESTNET)`.
  3. Call `tx.sign(newAccountKeyPair, Network.TESTNET)`.
- **Assertions:**
  - Neither call throws.
- **Oracle:** Multi-sig signing contract — both signatures accepted without conflict.

---

## TS-06.1 — Full three-operation transaction submits successfully (with post-state verification)
**Scenario:** SC-06.1, SC-07.1 | **Criteria:** AC-06.1, AC-07.1, AC-07.2

- **Objective:** End-to-end validation: create account + trustline + payment in one atomic transaction, signed by two keys, submits with `success == true`; the new account is verifiably present on Horizon with the correct ID.
- **Preconditions:** Funder/issuer funded via FriendBot; fresh `newAccountKeyPair` generated.
- **Test data:** `usdAsset = AssetTypeCreditAlphaNum4("USD", issuerKeyPair.accountId)`; startingBalance = `"5"`; trustLimit = `"10000"`; paymentAmount = `"100"`.
- **Steps:**
  1. Load funder `AccountResponse`.
  2. Build `CreateAccountOperation`, `ChangeTrustOperation` (source = new account), `PaymentOperation` (custom asset).
  3. Build transaction with all three.
  4. Sign with funder keypair.
  5. Sign with new account keypair.
  6. Await `sdk.submitTransaction(transaction)`.
  7. Await `sdk.accounts.account(newAccountId)`.
- **Assertions:**
  - `response.success == true` (AC-06.1).
  - `newAccount != null` (AC-07.1).
  - `newAccount.accountId == newAccountId` (AC-07.2).
- **Oracle:**
  - `success == true` proves all three operations applied atomically (atomicity positive case — AC-06.2 implicitly confirmed).
  - `accountId` round-trip proves correct account was created (AC-07.2).

---

## TS-06.2 — Atomicity: rollback when one operation fails
**Scenario:** SC-06.2 | **Criteria:** AC-06.2

- **Objective:** Prove that if any operation in a multi-op transaction fails, no operations are applied (all-or-nothing rollback guarantee stated in the docs).
- **Preconditions:** `issuerKeyPair` funded via FriendBot (shared with other tests via `setUpAll`); fresh `newKp = KeyPair.random()`.
- **Test data:**
  - Op 1: `CreateAccountOperationBuilder(newKp.accountId, "5").build()` — valid in isolation.
  - Op 2: `PaymentOperationBuilder(randomDestination, Asset.NATIVE, "50000").build()` — deliberately over-balance; FriendBot provides ~10,000 XLM, so 50,000 guarantees `op_underfunded`.
- **Steps:**
  1. Load `AccountResponse` for `issuerKeyPair` from Horizon.
  2. Build Op 1 (CreateAccount) and Op 2 (over-balance native payment).
  3. Build transaction with both ops; sign with `issuerKeyPair` only (no ChangeTrust, so no second signer required).
  4. Await `sdk.submitTransaction(transaction)`.
  5. Await `sdk.accounts.account(newKp.accountId)` — expect it to throw (account must not exist).
- **Assertions:**
  - `response.success == false` (transaction rejected due to Op 2 failure).
  - `sdk.accounts.account(newKp.accountId)` throws an error (404) — proves Op 1 was rolled back.
- **Oracle:** AC-06.2 — atomic rollback: account was never created despite Op 1 being individually valid.
