# Stage 1 — User Stories: 2.3 Memos, Time Bounds, and Fees

Source: `documentation/sdk-usage.md` § Memos, Time Bounds, and Fees (section 2.3)

---

## US-01 — Attach a text memo to a transaction

As a developer, I want to attach a text memo to a transaction using `addMemo(Memo.text(...))`, so that I can embed a human-readable payment reference or user identifier in the transaction.

## US-02 — Verify a submitted memo is preserved on-chain

As a developer, I want to retrieve a submitted transaction from Horizon and read back the memo, so that I can confirm the memo was recorded correctly on the ledger.

## US-03 — Use alternative memo types

As a developer, I want to create memos of different types (text, id, hash, returnHash), so that I can choose the appropriate memo format for different data payloads.

## US-04 — Constrain a transaction's validity window with time bounds

As a developer, I want to attach a `TimeBounds(minTime, maxTime)` to a transaction using `addTimeBounds(timeBounds)`, so that the transaction is only valid within a specific time window and expired signed transactions cannot be replayed.

## US-05 — Set a custom fee per operation

As a developer, I want to set a custom maximum fee per operation in stroops using `setMaxOperationFee(stroops)`, so that I can control the maximum fee paid for transaction submission beyond the default 100 stroops.
