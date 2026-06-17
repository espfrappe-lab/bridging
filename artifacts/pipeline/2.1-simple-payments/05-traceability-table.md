# Stage 5 — Traceability Table: 2.1 Simple Payments

| User Story | Acceptance Criterion | Gherkin Scenario | Test Spec | Test (Dart) |
|---|---|---|---|---|
| US-01 | AC-01.1 | SC-01.1 | TS-01.1 | `TS-01.1 — PaymentOperationBuilder returns a non-null PaymentOperation` |
| US-01 | AC-01.2 | SC-01.1 | TS-01.1 | `TS-01.1 — isA<PaymentOperation>()` |
| US-01 | AC-01.3 | SC-01.1 | TS-01.1 | `TS-01.1 — decimal amount string "100.50" accepted` |
| US-02 | AC-02.1 | SC-02.1 | TS-02.1 | `TS-02.1 — TransactionBuilder wraps payment into a single-operation transaction` |
| US-02 | AC-02.2 | SC-02.1 | TS-02.1 | `TS-02.1 — expect(tx.operations.length, 1)` |
| US-03 | AC-03.1 | SC-03.1 | TS-03.1 | `TS-03.1 — Signing with Network.TESTNET does not throw` |
| US-04 | AC-04.1 | SC-04.1 | TS-04.1 | `TS-04.1 — response is SubmitTransactionResponse (implicit)` |
| US-04 | AC-04.2 | SC-04.1 | TS-04.1 | `TS-04.1 — expect(response.success, true)` |
| US-04 | AC-04.3 | SC-04.1 | TS-04.1 | `TS-04.1 — expect(response.hash, isNotNull); isNotEmpty` |
| US-05 | AC-05.1 | SC-05.1 | TS-05.1 | `TS-05.1 — expect(bobAccount, isNotNull)` |
| US-05 | AC-05.2 | SC-05.1 | TS-05.1 | `TS-05.1 — expect(bobNativeBalance, greaterThanOrEqualTo(10100.0))` |
| US-06 | AC-06.1 | SC-06.1 | TS-06.1 | `TS-06.1 — addMemo(Memo.text("Coffee payment")) in build chain` |
| US-06 | AC-06.2 | SC-06.1 | TS-06.1 | `TS-06.1 — Payment transaction with a text memo submits successfully` |

---

## Test Categories

| Category | Count | Tests |
|---|---|---|
| Functional (builder / transaction structure) | 2 | TS-01.1, TS-02.1 |
| Functional (sign + submit flow) | 1 | TS-04.1 |
| Error-handling / contract | 1 | TS-03.1 |
| Invariant (balance after transfer) | 1 | TS-05.1 |
| Feature variation (memo) | 1 | TS-06.1 |
| **Total** | **6** | |

---

## Documentation Ambiguities Resolved

| ID | Ambiguity | Resolution |
|---|---|---|
| AMB-1 | `response.hash` type — the docs print `${response.hash}` but do not state whether it can be null on success | Treated as non-null on success (`isNotNull` + `isNotEmpty`), consistent with all three benchmark tests |
| AMB-2 | Bob's post-payment balance — quick-start says "Bob started with 10000 from FriendBot + 100 from Alice" but FriendBot may deduct a small fee | Used `greaterThanOrEqualTo(10100.0)` with `closeTo` precision left to fee tolerance, consistent with benchmark |
