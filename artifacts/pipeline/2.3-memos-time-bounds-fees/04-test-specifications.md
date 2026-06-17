# Stage 4 — Test Specifications: 2.3 Memos, Time Bounds, and Fees

---

## TS-01.1 — Memo.text() returns a non-null MemoText
**Scenario:** SC-01.1 | **Criteria:** AC-01.1

- **Objective:** Confirm that `Memo.text()` constructs a `MemoText` object whose `.text` field preserves the original string (factory contract).
- **Preconditions:** None — no network call required.
- **Test data:** `"Payment for invoice #1234"`
- **Steps:**
  1. Call `Memo.text("Payment for invoice #1234")`.
- **Assertions:**
  - Result is not null.
  - Result `isA<MemoText>()`.
  - `(result as MemoText).text == "Payment for invoice #1234"` (factory preserves value).
- **Oracle:** The factory method must preserve the memo text string — a `MemoText` returning a different string is a data-integrity violation.

---

## TS-02.1 — Text memo round-trip: submitted memo is retrievable with correct type and text
**Scenario:** SC-02.1 | **Criteria:** AC-01.2, AC-01.3, AC-02.1, AC-02.2, AC-02.3, AC-02.4, AC-02.5

- **Objective:** End-to-end proof that a text memo added to a transaction is preserved on the ledger and can be retrieved with the correct type and exact text.
- **Preconditions:** Sender and receiver funded via FriendBot; sender `AccountResponse` loaded from Horizon.
- **Test data:** Memo text = `"Payment for invoice #1234"`; payment amount = `"1"`.
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build `PaymentOperation(receiver.accountId, Asset.NATIVE, "1")`.
  3. Build transaction with `.addMemo(Memo.text("Payment for invoice #1234"))`.
  4. Sign with sender on `Network.TESTNET`.
  5. Await `sdk.submitTransaction(transaction)`.
  6. Await `sdk.transactions.transaction(response.hash!)`.
- **Assertions:**
  - `response.success == true` (AC-01.3).
  - `response.hash != null` (AC-02.1).
  - `txResponse != null` (AC-02.2).
  - `txResponse.memo != null` (AC-02.3).
  - `txResponse.memo is MemoText` (AC-02.4).
  - `(txResponse.memo as MemoText).text == "Payment for invoice #1234"` (AC-02.5).
- **Oracle:** Memo round-trip is a data-integrity invariant — the text on-chain must be byte-for-byte identical to the text passed at build time.

---

## TS-03.1 — Memo.id() creates a non-null memo
**Scenario:** SC-03.1 | **Criteria:** AC-03.1

- **Objective:** Confirm `Memo.id()` accepts a numeric value and returns a non-null object.
- **Preconditions:** None.
- **Test data:** `12345`
- **Steps:**
  1. Call `Memo.id(12345)`.
- **Assertions:**
  - Result is not null.
- **Oracle:** Factory method contract — non-null return for a valid non-negative integer.

---

## TS-03.2 — Memo.hash() and Memo.returnHash() accept 32-byte values
**Scenario:** SC-03.2 | **Criteria:** AC-03.2, AC-03.3

- **Objective:** Confirm both hash memo factories accept a `Uint8List` of 32 bytes and return non-null objects.
- **Preconditions:** None.
- **Test data:** `Uint8List(32)` (32 zero bytes, valid hash-length value).
- **Steps:**
  1. Call `Memo.hash(Uint8List(32))`.
  2. Call `Memo.returnHash(Uint8List(32))`.
- **Assertions:**
  - Both results are not null.
- **Oracle:** 32 bytes is the standard size for SHA-256 hashes used in Stellar memo payloads; both factories must accept it.

---

## TS-04.1 — TimeBounds constructor and addTimeBounds() do not throw
**Scenario:** SC-04.1 | **Criteria:** AC-04.1, AC-04.2

- **Objective:** Confirm that `TimeBounds(minTime, maxTime)` is constructable and that `.addTimeBounds()` on a `TransactionBuilder` does not throw.
- **Preconditions:** Sender `AccountResponse` loaded from Horizon.
- **Test data:** `now = DateTime.now().millisecondsSinceEpoch ~/ 1000`; `minTime = now - 60`; `maxTime = now + 300`.
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build a `PaymentOperation`.
  3. Construct `TimeBounds(now - 60, now + 300)`.
  4. Call `TransactionBuilder(account).addOperation(op).addTimeBounds(timeBounds).build()` inside `expect(..., returnsNormally)`.
- **Assertions:**
  - Build completes without exception.
- **Oracle:** `TimeBounds` constructor must accept integer Unix timestamps; `addTimeBounds` must not mutate the builder in a broken way.

---

## TS-04.2 — Transaction with valid time bounds submits successfully
**Scenario:** SC-04.2 | **Criteria:** AC-04.3

- **Objective:** Confirm that a transaction with a time window that includes the current moment is accepted by Horizon.
- **Preconditions:** Sender and receiver funded; sender `AccountResponse` loaded.
- **Test data:** `TimeBounds(now - 60, now + 300)` (window started 1 min ago, expires in 5 min).
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build and add a `PaymentOperation`.
  3. Build transaction with `.addTimeBounds(TimeBounds(now - 60, now + 300))`.
  4. Sign and submit.
- **Assertions:**
  - `response.success == true`.
- **Oracle:** Horizon accepts a transaction if `minTime <= ledger_close_time <= maxTime`; a 5-minute window centred on `now` must satisfy this.

---

## TS-05.1 — setMaxOperationFee() does not throw
**Scenario:** SC-05.1 | **Criteria:** AC-05.1

- **Objective:** Confirm `.setMaxOperationFee(200)` on a `TransactionBuilder` is accepted without error.
- **Preconditions:** Sender `AccountResponse` loaded from Horizon.
- **Test data:** `maxOperationFee = 200` (stroops).
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build a `PaymentOperation`.
  3. Call `TransactionBuilder(account).addOperation(op).setMaxOperationFee(200).build()` inside `expect(..., returnsNormally)`.
- **Assertions:**
  - Build completes without exception.
- **Oracle:** 200 stroops is a valid fee above the 100-stroop default; the builder must accept it.

---

## TS-05.2 — Transaction with custom fee (200 stroops) submits successfully
**Scenario:** SC-05.2 | **Criteria:** AC-05.2

- **Objective:** Confirm that a transaction with a custom max operation fee of 200 stroops is accepted by Horizon.
- **Preconditions:** Sender and receiver funded; sender `AccountResponse` loaded.
- **Test data:** `setMaxOperationFee(200)`.
- **Steps:**
  1. Load sender `AccountResponse`.
  2. Build a `PaymentOperation`.
  3. Build transaction with `.setMaxOperationFee(200)`.
  4. Sign and submit.
- **Assertions:**
  - `response.success == true`.
- **Oracle:** 200 stroops exceeds the minimum base fee; Horizon must accept the transaction.
