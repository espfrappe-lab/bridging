# Stage 2 — Acceptance Criteria: 2.3 Memos, Time Bounds, and Fees

---

## US-01 — Attach a text memo to a transaction

- **AC-01.1** `Memo.text("Payment for invoice #1234")` returns a non-null `MemoText` object.
- **AC-01.2** Calling `.addMemo(Memo.text(...))` on a `TransactionBuilder` does not throw and produces a transaction containing the memo.
- **AC-01.3** A transaction built with a text memo submits successfully (`response.success == true`).

---

## US-02 — Verify a submitted memo is preserved on-chain

- **AC-02.1** `response.hash` is non-null on a successful submit, and can be used to query the transaction.
- **AC-02.2** `sdk.transactions.transaction(hash)` returns a non-null `TransactionResponse` for a submitted transaction.
- **AC-02.3** `txResponse.memo` is not null for a transaction submitted with a text memo.
- **AC-02.4** `txResponse.memo` is of runtime type `MemoText`.
- **AC-02.5** `(txResponse.memo as MemoText).text` equals the exact string passed to `Memo.text()`.

---

## US-03 — Use alternative memo types

- **AC-03.1** `Memo.id(12345)` creates a non-null memo object (numeric identifier memo).
- **AC-03.2** `Memo.hash(Uint8List(32))` creates a non-null hash memo (32-byte value).
- **AC-03.3** `Memo.returnHash(Uint8List(32))` creates a non-null return-hash memo (32-byte value).

---

## US-04 — Constrain a transaction's validity window with time bounds

- **AC-04.1** `TimeBounds(minTime, maxTime)` is constructed from integer Unix timestamps (seconds since epoch) without error.
- **AC-04.2** `.addTimeBounds(timeBounds)` attaches the time bounds to the transaction via `TransactionBuilder` without error.
- **AC-04.3** A transaction with a valid time window (`minTime <= now <= maxTime`) submits successfully.

---

## US-05 — Set a custom fee per operation

- **AC-05.1** `.setMaxOperationFee(200)` sets a custom fee of 200 stroops per operation on the `TransactionBuilder` without error.
- **AC-05.2** A transaction built with `.setMaxOperationFee(200)` submits successfully.
