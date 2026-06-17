# Stage 5 — Traceability Table: 2.4 Fee Bump Transactions

| User Story | Acceptance Criterion | Gherkin Scenario | Test Spec | Test (Dart) |
|---|---|---|---|---|
| US-01 | AC-01.1 | SC-01.1 | TS-01.1 | `TS-01.1 — FeeBumpTransactionBuilder(innerTx) accepted without error` |
| US-01 | AC-01.2 | SC-01.1 | TS-01.1 | `TS-01.1 — expect(feeBumpTx isNotNull); isA<FeeBumpTransaction>()` |
| US-02 | AC-02.1 | SC-01.1 | TS-01.1 | `TS-01.1 — setBaseFee(300) accepted without error` |
| US-02 | AC-02.2 | SC-02.1 | TS-02.1 | `TS-02.1 — baseFee=300 = 100×2+100 satisfies formula (positive case, success)` |
| US-03 | AC-03.1 | SC-01.1 | TS-01.1 | `TS-01.1 — setFeeAccount(feePayerKeyPair.accountId) accepted without error` |
| US-04 | AC-04.1 | SC-04.1 | TS-04.1 | `TS-04.1 — feeBumpTx.sign(feePayerKeyPair Network.TESTNET) returnsNormally` |
| US-04 | AC-04.2 | SC-04.1 | TS-02.1 | `TS-02.1 — inner signed by user only; fee bump signed by fee payer only; success proves separation` |
| US-05 | AC-05.1 | SC-05.1 | TS-02.1 | `TS-02.1 — sdk.submitFeeBumpTransaction(feeBumpTx) is the API used (success confirms correct method)` |
| US-05 | AC-05.2 | SC-05.1 | TS-02.1 | `TS-02.1 — expect(response.success true)` |

---

## Test Categories

| Category | Count | Tests |
|---|---|---|
| Functional (builder / type) | 1 | TS-01.1 |
| Contract (signing does not throw) | 1 | TS-04.1 |
| Integration (end-to-end submit success) | 1 | TS-02.1 |
| **Total** | **3** | |

---

## Documentation Ambiguities Resolved

| ID | Ambiguity | Resolution |
|---|---|---|
| AMB-1 | The docs show a 2-operation inner transaction (two payment ops: "10" XLM and "20" XLM). The benchmark uses 1 operation. The baseFee of 300 is labeled "minimum" in the docs for 2 ops. | Generated tests follow the documentation (2 inner ops) to exercise the documented fee formula. baseFee=300 is exactly the documented minimum for 2 ops. The benchmark's 1-op simplification is a valid simplification but underdocuments the formula. |
| AMB-2 | The docs use placeholder keypairs (`"SUSER..."`, `"SFEEPAYER..."`). In tests these must be real funded accounts. | `userKeyPair`, `feePayerKeyPair`, `dest1KeyPair`, and `dest2KeyPair` are all funded via FriendBot in `setUpAll`. |
| AMB-3 | AC-02.2 (fee formula — negative case: what if baseFee < 300?) is documented as a protocol rule but no rejection example is shown. | Positive case only (baseFee=300 accepted). Negative test omitted as out of documented scope; the formula is exercised implicitly. |
