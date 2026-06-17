# Stage 5 — Traceability Table
## Subtopic 1.2: Loading an Account

Every row walks the chain: Documentation claim → User Story → Acceptance Criterion → Gherkin Scenario → Test Spec → Test in generated file.

| Doc claim | US | AC | Scenario | Spec | Generated test | Benchmark coverage |
|---|---|---|---|---|---|---|
| `sdk.accounts.account(id)` returns an `AccountResponse` | US-01 | AC-01.1 | SC-01.1 | TS-01.1 | TS-01.1 (group US-01) | implicit (account loaded in setUpAll) |
| `account.sequenceNumber` is accessible | US-01 | AC-01.2 | SC-01.2 | TS-01.2 | TS-01.2 | `expect(account.sequenceNumber, isNotNull)` |
| `sequenceNumber` not null for funded account | US-01 | AC-01.3 | SC-01.2 | TS-01.2 | TS-01.2 | same |
| `sequenceNumber` usable in transactions (integer) | US-01 | AC-01.4 | SC-01.3 | TS-01.3 | TS-01.3 | not explicitly tested in benchmark |
| API is asynchronous (await-able) | US-01 | AC-01.5 | SC-01.1 | TS-01.1 | all async tests | implicit |
| `account.balances` is iterable | US-02 | AC-02.1 | SC-02.1 | TS-02.1 | TS-02.1 | implicit (for-loop in benchmark) |
| `Balance` exposes `assetType` | US-02 | AC-02.2 | SC-02.4 | TS-02.4 | TS-02.4 | implicit |
| `Balance` exposes `balance` (amount) | US-02 | AC-02.3 | SC-02.3 / SC-02.4 | TS-02.3 / TS-02.4 | TS-02.3, TS-02.4 | `double.parse(balance.balance)` |
| `balance.assetType == Asset.TYPE_NATIVE` identifies XLM | US-02 | AC-02.4 | SC-02.2 | TS-02.2 | TS-02.2 | `if (balance.assetType == Asset.TYPE_NATIVE)` |
| Non-native `Balance` exposes `assetCode` | US-02 | AC-02.5 | SC-02.4 | TS-02.4 | TS-02.4 (AMB-1: field-access only) | `print("${balance.assetCode}")` in loop |
| Funded account has ≥ 1 native balance entry | US-02 | AC-02.6 | SC-02.2 | TS-02.2 | TS-02.2 | `expect(foundNative, true)` |
| Native balance > 0 | US-02 | AC-02.7 | SC-02.3 | TS-02.3 | TS-02.3 | `expect(double.parse(balance.balance), greaterThan(0))` |
| Non-existent account throws `ErrorResponse` | US-03 | AC-03.1 | SC-03.1 | TS-03.1 | TS-03.1 | implicit in try/catch |
| Thrown `ErrorResponse.code == 404` | US-03 | AC-03.2 | SC-03.2 | TS-03.2 | TS-03.2 | `if (e.code == 404) fakeExists = false` |
| try/catch pattern is correct existence check | US-03 | AC-03.3 | SC-03.3 | TS-03.3 | TS-03.3 | `expect(fakeExists, false)` |
| Pattern does not fire for existing account | US-03 | AC-03.4 | SC-03.4 | TS-03.4 | TS-03.4 | `expect(exists, true)` |

---

## Coverage gaps

| Gap | Reason | Mitigation |
|---|---|---|
| `balance.assetCode` on non-native entry (AC-02.5) | Requires trustline; FriendBot funds XLM only | Flagged as AMB-1; field access verified without value assertion |
| `sequenceNumber` as explicit integer type (AC-01.4) | Type not stated in docs | Oracle: `int.tryParse()` succeeds (TS-01.3) |
