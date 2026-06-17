# Stage 4 — Test Specifications
## Subtopic 1.3: Funding Testnet Accounts

Each spec is language-agnostic. IDs carry forward from Stages 1–3.
Test oracles are derived solely from the documentation.

---

## Group US-01: FriendBot.fundTestAccount() — fund a testnet account

### TS-01.1 — FriendBot.fundTestAccount() completes without throwing

| Field | Detail |
|---|---|
| **Scenario** | SC-01.1 |
| **Criteria** | AC-01.1, AC-01.2 |
| **Objective** | Prove the documented API call is invocable and resolves successfully for a valid testnet account ID |
| **Preconditions** | SDK available; testnet connectivity |
| **Test data** | `accountId` = `KeyPair.random().accountId` (never previously funded) |
| **Steps** | 1. Generate a fresh keypair via `KeyPair.random()` 2. Call `await FriendBot.fundTestAccount(kp.accountId)` |
| **Expected outcome** | Call resolves; no exception is thrown |
| **Assertions** | The line after the `await` is reached (implicit pass) |
| **Test oracle** | The documented usage shows a bare `await` with no return-value capture (AMB-1); successful completion is the only required postcondition derivable from the docs |
| **Postconditions** | Account now exists on testnet |

---

### TS-01.2 — Funded account is loadable on testnet

| Field | Detail |
|---|---|
| **Scenario** | SC-01.2 |
| **Criteria** | AC-01.3 |
| **Objective** | Prove the postcondition: after `FriendBot.fundTestAccount()` the account exists on testnet and returns a valid `AccountResponse` |
| **Preconditions** | Account funded via `FriendBot.fundTestAccount()` in `setUpAll`; testnet SDK available |
| **Test data** | `accountId` = account funded in `setUpAll` |
| **Steps** | 1. Assert the `AccountResponse` loaded in `setUpAll` is not null |
| **Expected outcome** | Non-null `AccountResponse` |
| **Assertions** | `expect(account, isNotNull)` |
| **Test oracle** | An `AccountResponse` existing proves the account was created on-chain — a necessary postcondition of successful funding |

---

### TS-01.3 — Native XLM balance is approximately 10,000

| Field | Detail |
|---|---|
| **Scenario** | SC-01.3 |
| **Criteria** | AC-01.4 |
| **Objective** | Verify the documentation's specific claim: *"funds new accounts with 10,000 test XLM"* |
| **Preconditions** | Account loaded from testnet in `setUpAll` |
| **Steps** | 1. Find the balance entry where `assetType == Asset.TYPE_NATIVE` 2. Parse `balance.balance` as double 3. Assert within range |
| **Expected outcome** | Native XLM balance ≈ 10,000 |
| **Assertions** | `expect(xlm, closeTo(10000, 100))` — i.e. 9,900 ≤ xlm ≤ 10,100 |
| **Test oracle** | The documentation states the exact funded amount (10,000 XLM). Tolerance of ±100 accommodates AMB-2 (minimum reserve deductions) while still validating the documented claim. A balance of 0 or an arbitrary unrelated amount would constitute a violation. |
| **Postconditions** | None |

---

---

### TS-TL-1 — FriendBot is testnet-only: funded account absent from mainnet

| Field | Detail |
|---|---|
| **Scenario** | SC-TL-1 |
| **Criteria** | AC-TL-1 |
| **Objective** | Prove FriendBot only writes to testnet by confirming the funded account is absent from mainnet Horizon |
| **Preconditions** | None — uses a fresh keypair independent of `setUpAll` |
| **Test data** | `kp = KeyPair.random()` |
| **Steps** | 1. Await `FriendBot.fundTestAccount(kp.accountId)` 2. Await `StellarSDK.TESTNET.accounts.account(kp.accountId)` — must succeed 3. Await `StellarSDK.PUBLIC.accounts.account(kp.accountId)` — must throw |
| **Expected outcome** | Testnet account is not null; mainnet lookup throws (404) |
| **Assertions** | `expect(testnetAccount, isNotNull)` and `expectLater(StellarSDK.PUBLIC.accounts.account(...), throwsA(anything))` |
| **Test oracle** | AC-TL-1 — FriendBot's hardcoded `https://friendbot.stellar.org` URL proves it only touches testnet; a fresh random keypair can never exist on mainnet unless explicitly created there |
| **Safety note** | Step 3 is a read-only HTTP GET against the public mainnet Horizon (`https://horizon.stellar.org`). No mainnet XLM is spent. |

---

## Testability limitations

| ID | Untested behavior | Reason |
|---|---|---|
| TL-1 | ~~FriendBot fails on mainnet~~ | **Upgraded to AC-TL-1 / TS-TL-1** — testable via read-only mainnet Horizon lookup |
| TL-2 | Re-funding an already-funded account | Docs describe "new accounts" only; re-funding behavior not documented |
