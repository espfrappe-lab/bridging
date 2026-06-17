# Stage 2 — Acceptance Criteria: 2.2 Multi-Operation Transactions

---

## US-01 — Create Account Operation

**AC-01.1** `CreateAccountOperationBuilder(newAccountId, "5").build()` returns a non-null `CreateAccountOperation`.

**AC-01.2** The starting balance string `"5"` is accepted without error (no format exception during build).

---

## US-02 — Trustline Operation with Custom Source

**AC-02.1** `ChangeTrustOperationBuilder(usdAsset, "10000").setSourceAccount(newAccountId).build()` returns a non-null `ChangeTrustOperation`.

**AC-02.2** `.setSourceAccount(newAccountId)` sets the operation source to the new account, not the funder, so that the trustline is established on behalf of the new account.

**AC-02.3** The trustline limit string `"10000"` is accepted without error (no format exception during build).

---

## US-03 — Payment Operation for Custom Asset

**AC-03.1** `PaymentOperationBuilder(newAccountId, usdAsset, "100").build()` returns a non-null `PaymentOperation` for a `AssetTypeCreditAlphaNum4` custom asset.

---

## US-04 — Bundling Operations in a Transaction

**AC-04.1** `TransactionBuilder(funder).addOperation(op1).addOperation(op2).addOperation(op3).build()` accepts multiple chained operation additions without error.

**AC-04.2** The resulting `Transaction.operations.length` equals 3 when three operations are added.

---

## US-05 — Multi-Signature

**AC-05.1** `transaction.sign(funderKeyPair, Network.TESTNET)` adds the funder's signature without throwing.

**AC-05.2** A subsequent `transaction.sign(newAccountKeyPair, Network.TESTNET)` adds a second, distinct signature without throwing (multi-sig is supported on a single transaction).

---

## US-06 — Atomicity

**AC-06.1** `sdk.submitTransaction(transaction)` returns a `SubmitTransactionResponse` with `success == true` for a valid, fully-signed three-operation transaction.

**AC-06.2** All operations execute atomically: if any operation in the transaction fails, the entire transaction is rolled back and no partial state is applied to the ledger.

---

## US-07 — Post-Transaction Account Verification

**AC-07.1** After successful submission, `sdk.accounts.account(newAccountId)` returns a non-null `AccountResponse`.

**AC-07.2** `AccountResponse.accountId` equals the `newAccountId` string that was passed to `CreateAccountOperationBuilder`.
