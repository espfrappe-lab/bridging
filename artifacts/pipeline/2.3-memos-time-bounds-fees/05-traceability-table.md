# Stage 5 — Traceability Table: 2.3 Memos, Time Bounds, and Fees

| User Story | Acceptance Criterion | Gherkin Scenario | Test Spec | Test (Dart) |
|---|---|---|---|---|
| US-01 | AC-01.1 | SC-01.1 | TS-01.1 | `TS-01.1 — memo isNotNull; isA<MemoText>(); .text == "Payment for invoice #1234"` |
| US-01 | AC-01.2 | SC-02.1 | TS-02.1 | `TS-02.1 — addMemo() builds without exception` |
| US-01 | AC-01.3 | SC-02.1 | TS-02.1 | `TS-02.1 — expect(response.success, true)` |
| US-02 | AC-02.1 | SC-02.1 | TS-02.1 | `TS-02.1 — expect(response.hash, isNotNull)` |
| US-02 | AC-02.2 | SC-02.1 | TS-02.1 | `TS-02.1 — sdk.transactions.transaction(hash) returns non-null txResponse` |
| US-02 | AC-02.3 | SC-02.1 | TS-02.1 | `TS-02.1 — expect(memo, isNotNull)` |
| US-02 | AC-02.4 | SC-02.1 | TS-02.1 | `TS-02.1 — expect(memo is MemoText, true)` |
| US-02 | AC-02.5 | SC-02.1 | TS-02.1 | `TS-02.1 — expect((memo as MemoText).text, "Payment for invoice #1234")` |
| US-03 | AC-03.1 | SC-03.1 | TS-03.1 | `TS-03.1 — Memo.id(12345) isNotNull` |
| US-03 | AC-03.2 | SC-03.2 | TS-03.2 | `TS-03.2 — Memo.hash(Uint8List(32)) isNotNull` |
| US-03 | AC-03.3 | SC-03.2 | TS-03.2 | `TS-03.2 — Memo.returnHash(Uint8List(32)) isNotNull` |
| US-04 | AC-04.1 | SC-04.1 | TS-04.1 | `TS-04.1 — TimeBounds(now-60, now+300) accepted without exception` |
| US-04 | AC-04.2 | SC-04.1 | TS-04.1 | `TS-04.1 — addTimeBounds(timeBounds).build() returnsNormally` |
| US-04 | AC-04.3 | SC-04.2 | TS-04.2 | `TS-04.2 — expect(response.success, true)` |
| US-05 | AC-05.1 | SC-05.1 | TS-05.1 | `TS-05.1 — setMaxOperationFee(200).build() returnsNormally` |
| US-05 | AC-05.2 | SC-05.2 | TS-05.2 | `TS-05.2 — expect(response.success, true)` |

---

## Test Categories

| Category | Count | Tests |
|---|---|---|
| Functional (memo factory / type) | 3 | TS-01.1, TS-03.1, TS-03.2 |
| Functional + data-integrity (memo round-trip) | 1 | TS-02.1 |
| Contract (builder / does not throw) | 2 | TS-04.1, TS-05.1 |
| Integration (submit success) | 2 | TS-04.2, TS-05.2 |
| **Total** | **8** | |

---

## Documentation Ambiguities Resolved

| ID | Ambiguity | Resolution |
|---|---|---|
| AMB-1 | The docs use `TimeBounds(now, now + 300)` (minTime = `now`), but the benchmark uses `TimeBounds(now - 60, now + 300)` (minTime = `now - 60`). | Generated tests use `now - 60` to allow for minor clock skew between test execution and ledger close time, matching the benchmark's practical usage. The doc's intent ("valid for next 5 minutes") is preserved — the exact minTime value is an implementation detail, not a documented invariant. |
| AMB-2 | `Memo.id()`, `Memo.hash()`, and `Memo.returnHash()` are listed as available types without constructor argument details. | `Memo.id(int)` is a reasonable inference for a numeric ID memo; `Memo.hash(Uint8List)` and `Memo.returnHash(Uint8List)` use 32 bytes, the standard SHA-256 hash length and Stellar's required size. These are the lowest-risk assumptions matching the Stellar protocol spec. |
