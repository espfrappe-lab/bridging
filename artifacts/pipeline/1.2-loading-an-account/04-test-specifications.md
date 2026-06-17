# Stage 4 — Test Specifications
## Subtopic 1.2: Loading an Account

Each spec is a language-agnostic blueprint. IDs carry forward from Stages 1–3.
Test oracles are highlighted under **Assertions**.

---

## Group US-01: sdk.accounts.account() — load account data

### TS-01.1 — Returns a non-null AccountResponse for a funded account
| Field | Detail |
|---|---|
| **Scenario** | SC-01.1 |
| **Criteria** | AC-01.1, AC-01.5 |
| **Objective** | Prove `sdk.accounts.account()` returns a non-null object for a funded account |
| **Preconditions** | Account funded via FriendBot on testnet; SDK configured for testnet |
| **Test data** | `accountId` = account funded in `setUpAll` |
| **Steps** | 1. Call `await sdk.accounts.account(accountId)` |
| **Assertions** | `result` is not null |
| **Postconditions** | Shared `_account` variable populated for downstream tests |

---

### TS-01.2 — sequenceNumber is non-null
| Field | Detail |
|---|---|
| **Scenario** | SC-01.2 |
| **Criteria** | AC-01.2, AC-01.3 |
| **Objective** | Prove `AccountResponse.sequenceNumber` exists and is not null |
| **Preconditions** | Account loaded in `setUpAll` |
| **Steps** | 1. Access `_account.sequenceNumber` |
| **Assertions** | `_account.sequenceNumber` is not null |

---

### TS-01.3 — sequenceNumber is integer-parseable (invariant: usable in transactions)
| Field | Detail |
|---|---|
| **Scenario** | SC-01.3 |
| **Criteria** | AC-01.4 |
| **Objective** | Prove the sequence number is a valid integer value as required by transaction building |
| **Preconditions** | Account loaded in `setUpAll` |
| **Steps** | 1. Convert `_account.sequenceNumber` to string via `.toString()` 2. Attempt `int.tryParse()` |
| **Assertions** | `int.tryParse(repr)` is not null; parsed value is ≥ 0 |
| **Test oracle** | Invariant: a sequence number that cannot be parsed as int cannot be used to build a transaction — the doc's stated purpose |
| **Ambiguity** | AMB-2: type of `sequenceNumber` not stated in docs; oracle derived from documented purpose |

---

## Group US-02: AccountResponse.balances — balance inspection

### TS-02.1 — Balances list is non-empty
| Field | Detail |
|---|---|
| **Scenario** | SC-02.1 |
| **Criteria** | AC-02.1, AC-02.6 |
| **Objective** | Prove `account.balances` is iterable and non-empty for a funded account |
| **Preconditions** | Account loaded in `setUpAll` |
| **Steps** | 1. Access `_account.balances` |
| **Assertions** | `_account.balances` is not empty |

---

### TS-02.2 — At least one balance has assetType == Asset.TYPE_NATIVE
| Field | Detail |
|---|---|
| **Scenario** | SC-02.2 |
| **Criteria** | AC-02.4, AC-02.6 |
| **Objective** | Prove the native XLM balance is present and identifiable by `Asset.TYPE_NATIVE` |
| **Preconditions** | Account loaded in `setUpAll` |
| **Steps** | 1. Filter `_account.balances` by `b.assetType == Asset.TYPE_NATIVE` 2. Collect matches |
| **Assertions** | Filtered list is not empty |

---

### TS-02.3 — Native XLM balance is positive
| Field | Detail |
|---|---|
| **Scenario** | SC-02.3 |
| **Criteria** | AC-02.3, AC-02.7 |
| **Objective** | Prove the native balance's `balance` field is parseable as double and > 0 |
| **Preconditions** | Account loaded; at least one native balance entry confirmed by TS-02.2 |
| **Steps** | 1. Find first balance where `assetType == Asset.TYPE_NATIVE` 2. Parse `balance.balance` as double |
| **Assertions** | `double.parse(native.balance) > 0` |
| **Test oracle** | A freshly FriendBot-funded account always receives > 0 XLM; zero balance would indicate a funding failure |

---

### TS-02.4 — Every balance entry exposes assetType and balance fields without throwing
| Field | Detail |
|---|---|
| **Scenario** | SC-02.4 |
| **Criteria** | AC-02.2, AC-02.3, AC-02.5 |
| **Objective** | Prove all `Balance` objects in the list expose the fields referenced in the doc's for-loop |
| **Preconditions** | Account loaded in `setUpAll` |
| **Steps** | 1. Iterate `_account.balances` 2. For each entry, read `balance.assetType` and `balance.balance` |
| **Assertions** | No exception thrown; `balance.assetType` is not null; `balance.balance` is not null for every entry |
| **Ambiguity** | AMB-1: `assetCode` (non-native else-branch) not exercisable without a trustline; covered at field-access level only |

---

## Group US-03: account existence check — try/catch on ErrorResponse

### TS-03.1 — Non-existent account throws ErrorResponse
| Field | Detail |
|---|---|
| **Scenario** | SC-03.1 |
| **Criteria** | AC-03.1 |
| **Objective** | Prove `sdk.accounts.account()` throws `ErrorResponse` for a non-existent account |
| **Test data** | `accountId` = `KeyPair.random().accountId` (never funded) |
| **Steps** | 1. Call `await sdk.accounts.account(nonExistentId)` inside try/catch 2. Record the caught exception type |
| **Assertions** | Caught object is an instance of `ErrorResponse` |

---

### TS-03.2 — Thrown ErrorResponse has code 404
| Field | Detail |
|---|---|
| **Scenario** | SC-03.2 |
| **Criteria** | AC-03.2 |
| **Objective** | Prove the `ErrorResponse` for a non-existent account carries `code == 404` |
| **Test data** | Same non-existent `accountId` |
| **Steps** | 1. Call `await sdk.accounts.account(nonExistentId)` 2. Catch as `ErrorResponse e` 3. Read `e.code` |
| **Assertions** | `e.code == 404` |
| **Test oracle** | HTTP 404 is the Horizon convention for "account not found"; any other code is a different error class |

---

### TS-03.3 — Documented pattern: non-existent account sets exists = false
| Field | Detail |
|---|---|
| **Scenario** | SC-03.3 |
| **Criteria** | AC-03.3 |
| **Objective** | Verify the exact try/catch existence-check pattern shown in the documentation produces `exists = false` for a non-existent account |
| **Test data** | Non-existent `accountId` |
| **Steps** | 1. `bool exists = true;` 2. Wrap `sdk.accounts.account(nonExistentId)` in `try { … } on ErrorResponse catch (e) { if (e.code == 404) exists = false; }` 3. Assert `exists` |
| **Assertions** | `exists == false` |
| **Test oracle** | Reproduces the documentation's code verbatim; any deviation means the documented pattern is wrong |

---

### TS-03.4 — Documented pattern: existing account keeps exists = true
| Field | Detail |
|---|---|
| **Scenario** | SC-03.4 |
| **Criteria** | AC-03.4 |
| **Objective** | Verify the same existence-check pattern does not set `exists = false` for a real account |
| **Test data** | `_funded.accountId` (funded in `setUpAll`) |
| **Steps** | 1. `bool exists = true;` 2. Same try/catch block with funded account ID 3. Assert `exists` |
| **Assertions** | `exists == true` |
