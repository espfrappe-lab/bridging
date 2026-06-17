# Stage 5 — Traceability Table: 2.2 Multi-Operation Transactions

| User Story | Acceptance Criterion | Gherkin Scenario | Test Spec | Test (Dart) |
|---|---|---|---|---|
| US-01 | AC-01.1 | SC-01.1 | TS-01.1 | `TS-01.1 — expect(op isNotNull); isA<CreateAccountOperation>()` |
| US-01 | AC-01.2 | SC-01.1 | TS-01.1 | `TS-01.1 — "5" accepted in build (no exception)` |
| US-02 | AC-02.1 | SC-02.1 | TS-02.1 | `TS-02.1 — expect(op isNotNull); isA<ChangeTrustOperation>()` |
| US-02 | AC-02.2 | SC-02.1 | TS-02.1 | `TS-02.1 — setSourceAccount(newAccountId) accepted` |
| US-02 | AC-02.3 | SC-02.1 | TS-02.1 | `TS-02.1 — "10000" limit accepted in build` |
| US-03 | AC-03.1 | SC-03.1 | TS-03.1 | `TS-03.1 — expect(op isNotNull); isA<PaymentOperation>()` |
| US-04 | AC-04.1 | SC-04.1 | TS-04.1 | `TS-04.1 — three chained addOperation() calls accepted` |
| US-04 | AC-04.2 | SC-04.1 | TS-04.1 | `TS-04.1 — expect(tx.operations.length 3)` |
| US-05 | AC-05.1 | SC-05.1 | TS-05.1 | `TS-05.1 — tx.sign(issuerKeyPair Network.TESTNET) returnsNormally` |
| US-05 | AC-05.2 | SC-05.1 | TS-05.1 | `TS-05.1 — tx.sign(newAccountKeyPair Network.TESTNET) returnsNormally` |
| US-06 | AC-06.1 | SC-06.1 | TS-06.1 | `TS-06.1 — expect(response.success true)` |
| US-06 | AC-06.2 | SC-06.1 | TS-06.1 | UNTESTABLE — rollback path not exercisable in unit context |
| US-07 | AC-07.1 | SC-07.1 | TS-06.1 | `TS-06.1 — expect(newAccount isNotNull)` |
| US-07 | AC-07.2 | SC-07.1 | TS-06.1 | `TS-06.1 — expect(newAccount.accountId newAccountId)` |

---

## Test Categories

| Category | Count | Tests |
|---|---|---|
| Functional (builder / operation type) | 3 | TS-01.1, TS-02.1, TS-03.1 |
| Functional (transaction structure) | 1 | TS-04.1 |
| Contract (multi-sig signing) | 1 | TS-05.1 |
| Functional + invariant (end-to-end, atomicity positive case) | 1 | TS-06.1 |
| **Total** | **6** | |

---

## Documentation Ambiguities Resolved

| ID | Ambiguity | Resolution |
|---|---|---|
| AMB-1 | The docs use placeholder keys (`"SFUNDER..."`, `"GISSUER..."`) — funder and issuer are presented as different parties. In practice, for the payment step to work, the funder needs USD. | Made funder = issuer: `issuerKeyPair` is both the transaction source and the USD asset issuer, so it can send USD without requiring a separate trustline. This matches the documented "funder sends USD to new account" intent while being executable on testnet. |
| AMB-2 | The benchmark test (`sdk-usage: Multi-Operation Transactions`) omits the payment operation (only 2 ops: create + trustline). The docs show 3 ops. | Generated tests follow the documentation (3 ops). The 2-op simplification in the benchmark is a benchmark choice, not a doc constraint. |
| AMB-3 | AC-06.2 (atomicity rollback) — the docs state the guarantee but show no error example. | Marked UNTESTABLE; the positive path (success == true with 3 ops) implicitly confirms the success side of atomicity. |
