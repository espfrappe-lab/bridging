# Stage 4 — Test Specifications: 2.1 Simple Payments

---

## TS-01.1 — PaymentOperation builder produces a valid operation
**Scenario:** SC-01.1 | **Criteria:** AC-01.1, AC-01.2, AC-01.3

- **Objective:** Verify that `PaymentOperationBuilder` accepts a G-address, `Asset.NATIVE`, and a decimal amount string, and returns a typed, non-null `PaymentOperation`.
- **Preconditions:** None — no network call required.
- **Test data:** destination = any funded receiver G-address; asset = `Asset.NATIVE`; amount = `"100.50"`.
- **Steps:**
  1. Call `PaymentOperationBuilder(destination, Asset.NATIVE, "100.50").build()`.
- **Assertions:**
  - Result is not null.
  - Result is an instance of `PaymentOperation`.
- **Oracles:** No `FormatException` or assertion error during build (AC-01.3 decimal string acceptance).

---

## TS-02.1 — TransactionBuilder wraps one operation
**Scenario:** SC-02.1 | **Criteria:** AC-02.1, AC-02.2

- **Objective:** Verify that `TransactionBuilder` produces a non-null `Transaction` and that `addOperation` correctly places the operation inside it.
- **Preconditions:** Sender account loaded from Horizon (`sdk.accounts.account`).
- **Test data:** sender `AccountResponse`; amount = `"10"`.
- **Steps:**
  1. Load `AccountResponse` for sender.
  2. Build `PaymentOperation` with `Asset.NATIVE` and amount `"10"`.
  3. Call `TransactionBuilder(senderAccount).addOperation(op).build()`.
- **Assertions:**
  - Transaction is not null.
  - `transaction.operations.length == 1`.

---

## TS-03.1 — Signing with correct network does not throw
**Scenario:** SC-03.1 | **Criteria:** AC-03.1

- **Objective:** Confirm that `transaction.sign(keyPair, Network.TESTNET)` executes without exception.
- **Preconditions:** Sender account loaded; single-operation transaction built.
- **Test data:** amount = `"1"`.
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build transaction with one payment operation.
  3. Call `transaction.sign(sender, Network.TESTNET)` inside `expect(..., returnsNormally)`.
- **Assertions:**
  - No exception thrown during signing.

---

## TS-04.1 — Successful XLM payment returns success and hash
**Scenario:** SC-04.1 | **Criteria:** AC-04.1, AC-04.2, AC-04.3

- **Objective:** Validate the complete build-sign-submit flow returns `success == true` and a non-empty transaction hash.
- **Preconditions:** Sender and receiver both funded via FriendBot.
- **Test data:** amount = `"100.50"`, `Asset.NATIVE`.
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build `PaymentOperation(receiver, Asset.NATIVE, "100.50")`.
  3. Build transaction with `TransactionBuilder`.
  4. Sign with `sender, Network.TESTNET`.
  5. Await `sdk.submitTransaction(transaction)`.
- **Assertions:**
  - `response.success == true`.
  - `response.hash != null`.
  - `response.hash` is not empty.
- **Oracles:** `success == true` is the primary network-verified correctness oracle (the network accepted and executed the transaction).

---

## TS-05.1 — Recipient balance increases by payment amount
**Scenario:** SC-05.1 | **Criteria:** AC-05.1, AC-05.2

- **Objective:** Confirm end-to-end fund transfer: post-payment, the destination account's native balance reflects the received amount.
- **Preconditions:** Fresh Alice and Bob keypairs both funded by FriendBot (≈10 000 XLM each).
- **Test data:** amount = `"100"`, `Asset.NATIVE`.
- **Steps:**
  1. Fund Alice and Bob via `FriendBot.fundTestAccount`.
  2. Load Alice's `AccountResponse`.
  3. Build, sign, and submit payment of 100 XLM from Alice to Bob.
  4. Assert submission succeeded.
  5. Load Bob's `AccountResponse`.
  6. Iterate `bobAccount.balances`; locate `assetType == Asset.TYPE_NATIVE`.
  7. Parse the balance as `double`.
- **Assertions:**
  - `response.success == true` (submission guard).
  - `bobAccount != null` (AC-05.1).
  - Bob's native balance `>= 10100.0` (10 000 from FriendBot + 100 from Alice, AC-05.2).
- **Oracles:** Balance invariant — sender pays X → recipient receives X (network-verified by balance check).

---

## TS-06.1 — Payment with memo submits successfully
**Scenario:** SC-06.1 | **Criteria:** AC-06.1, AC-06.2

- **Objective:** Confirm that a transaction built with `addMemo(Memo.text(...))` is accepted by the network.
- **Preconditions:** Sender and receiver funded via FriendBot (shared setup).
- **Test data:** amount = `"100"`, memo = `"Coffee payment"`.
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build payment operation.
  3. Build transaction with `.addMemo(Memo.text("Coffee payment"))`.
  4. Sign and submit.
- **Assertions:**
  - `response.success == true`.
  - `response.hash != null`.
